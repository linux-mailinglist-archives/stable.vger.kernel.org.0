Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32ECA406184
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbhIJAnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:43:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232355AbhIJASw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:18:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69C9C6120A;
        Fri, 10 Sep 2021 00:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233046;
        bh=kbn0gaMtUc9hnrx2fOxMn8ctJ6IlOJ77GFn7rY9mYtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ISlLDLK8/2+W5nKnx/RfLQne9dUjaxqPcCs6NI92I1E69X9rPYuAyqF4fobHgbUWa
         X7+I1hJ+sInXOwqcHZ8dzxXDfVGG1A+gOEQ3zs+HEkIZoxd3PqTAOQ3tjPAjstwiGP
         3UKYetI1Yq6/rSBjuIsRNu1IMp0epQNOmWeGE8s1nXI4oG9OyOzbw1FGrrzH433Cgy
         iHrK0cS+afPrMCK5wEz0egEZsXqjqqHtuTBjOO9dah8SZuGfTCiFDoKGzbXnJGMqKr
         IeXFCjOoh2146WR2H6hBibgA3dIag9SpS6oygTmlhYuOP77y+UyNg6xUZ9KgdLrI0k
         F3bX2b7tCPn8Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 63/99] scsi: qla2xxx: Fix NVMe session down detection
Date:   Thu,  9 Sep 2021 20:15:22 -0400
Message-Id: <20210910001558.173296-63-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 7a8ff7d9854a1727435557184c8255bbbca60920 ]

When Target port transitions personality from one to another (NVMe <-->
FCP), there could be some overlap of the two where one layer is going down
while the other layer is coming up. This overlap can cause temporary I/O
error. Detect those errors/transitions and recover from them. Triggers
session tear down and allow relogin to re-drive the connection under the
following conditions:

 - NVMe command error

 - On PRLO + N2N (rida format 2)

Link: https://lore.kernel.org/r/20210817051315.2477-11-njavali@marvell.com
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_attr.c | 12 +++++++-----
 drivers/scsi/qla2xxx/qla_isr.c  |  9 +++++++++
 drivers/scsi/qla2xxx/qla_mbx.c  | 10 ++++++++++
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 3aa9869f6fae..0708dbdfa2cc 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2706,12 +2706,14 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
 	 * final cleanup of firmware resources (PCBs and XCBs).
 	 */
 	if (fcport->loop_id != FC_NO_LOOP_ID) {
-		if (IS_FWI2_CAPABLE(fcport->vha->hw))
-			fcport->vha->hw->isp_ops->fabric_logout(fcport->vha,
-			    fcport->loop_id, fcport->d_id.b.domain,
-			    fcport->d_id.b.area, fcport->d_id.b.al_pa);
-		else
+		if (IS_FWI2_CAPABLE(fcport->vha->hw)) {
+			if (fcport->loop_id != FC_NO_LOOP_ID)
+				fcport->logout_on_delete = 1;
+
+			qlt_schedule_sess_for_deletion(fcport);
+		} else {
 			qla2x00_port_logout(fcport->vha, fcport);
+		}
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d9fb093a60a1..6d47f4a93eff 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2417,6 +2417,15 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	case CS_PORT_UNAVAILABLE:
 	case CS_PORT_LOGGED_OUT:
 		fcport->nvme_flag |= NVME_FLAG_RESETTING;
+		if (atomic_read(&fcport->state) == FCS_ONLINE) {
+			ql_dbg(ql_dbg_disc, fcport->vha, 0x3021,
+			       "Port to be marked lost on fcport=%06x, current "
+			       "port state= %s comp_status %x.\n",
+			       fcport->d_id.b24, port_state_str[FCS_ONLINE],
+			       comp_status);
+
+			qlt_schedule_sess_for_deletion(fcport);
+		}
 		fallthrough;
 	case CS_ABORTED:
 	case CS_PORT_BUSY:
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index f9992e010ed4..2c1b8d590162 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4172,6 +4172,16 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 				rptid_entry->u.f2.remote_nport_id[1];
 			fcport->d_id.b.al_pa =
 				rptid_entry->u.f2.remote_nport_id[0];
+
+			/*
+			 * For the case where remote port sending PRLO, FW
+			 * sends up RIDA Format 2 as an indication of session
+			 * loss. In other word, FW state change from PRLI
+			 * complete back to PLOGI complete. Delete the
+			 * session and let relogin drive the reconnect.
+			 */
+			if (atomic_read(&fcport->state) == FCS_ONLINE)
+				qlt_schedule_sess_for_deletion(fcport);
 		}
 	}
 }
-- 
2.30.2

