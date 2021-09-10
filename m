Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1704062CD
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbhIJAq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:46:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234043AbhIJAWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:22:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB298610A3;
        Fri, 10 Sep 2021 00:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233274;
        bh=KrHQ9fGnGUVGhxsCSqlXmDtAgHCh5oF6gYb9Rkdbprw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CI1VDF/mPwGobSbAx0zvuhDMeiadDcWe1e17T8msrKMUu3WOOZs524zcw2E8chqrS
         ZE2R9liHbdi+NoM85fsGAF7vuB6TYOetKXFODA6Fy/a1w+4Kv5LjwdHrgGoO/4PRax
         viVrAGgrd20DlUsMsJB+e/mhi2LA4RRwQZ7ZHI5dBGrU1aZo0hBitTOUHZKLGMSaeC
         YplqjvYIAFbvRWsiYdQ+4Qm4Fz/vqf0JHeOfqYkDOnQpxjVO6tvo2vVW6teX8s/xH3
         24qKAIrcekx8bVMCAGY+enmTTU5g72mhF5AFayJdejzr87GT6sp5/DN5i4W/vDR3cK
         iO8+4AYFV7XQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 33/53] scsi: qla2xxx: Fix NVMe session down detection
Date:   Thu,  9 Sep 2021 20:20:08 -0400
Message-Id: <20210910002028.175174-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002028.175174-1-sashal@kernel.org>
References: <20210910002028.175174-1-sashal@kernel.org>
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
index 6a2c4a6fcded..22f230e001cc 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2700,12 +2700,14 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
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
index a24b82de4aab..db4182ecbc26 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2380,6 +2380,15 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
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
index 4ebd8851a0c9..91c3bd7829de 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4136,6 +4136,16 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
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

