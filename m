Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32EC451E35
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344077AbhKPAf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:45408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344665AbhKOTZL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A964763376;
        Mon, 15 Nov 2021 19:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002924;
        bh=jfTiw9UZQklgf79bDPoDz0PZ4l8HhdW2uSnEvYUGk8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oM1S9bSIadLPN64zuqjBhzJlHhixlEnFkhlQgcxY05Aaw48nO871FcQxCD4tY0El2
         k3X9IpyzVFPLpLzPkQDbWr6zmSjRMEJhsVu81gMlRtVkjK91fGLfG/mOwZ/bwLZESj
         mTrq6LzyHdTthkv57z266HQf48v9YyAIvo0uDGcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 747/917] scsi: qla2xxx: Relogin during fabric disturbance
Date:   Mon, 15 Nov 2021 18:04:02 +0100
Message-Id: <20211115165454.245184917@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit bb2ca6b3f09ac20e8357d257d0557ab5ddf6adcd ]

For RSCN of type "Area, Domain, or Fabric", which indicate a portion or
entire fabric was disturbed, current driver does not set the scan_need flag
to indicate a session was affected by the disturbance. This in turn can
lead to I/O timeout and delay of relogin. Hence initiate relogin in the
event of fabric disturbance.

Link: https://lore.kernel.org/r/20211026115412.27691-2-njavali@marvell.com
Fixes: 1560bafdff9e ("scsi: qla2xxx: Use complete switch scan for RSCN events")
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 54 +++++++++++++++++++++++++++------
 1 file changed, 45 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7e64e4730b259..df3884d9f12a2 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1786,16 +1786,52 @@ void qla2x00_handle_rscn(scsi_qla_host_t *vha, struct event_arg *ea)
 	fc_port_t *fcport;
 	unsigned long flags;
 
-	fcport = qla2x00_find_fcport_by_nportid(vha, &ea->id, 1);
-	if (fcport) {
-		if (fcport->flags & FCF_FCP2_DEVICE) {
-			ql_dbg(ql_dbg_disc, vha, 0x2115,
-			       "Delaying session delete for FCP2 portid=%06x %8phC ",
-			       fcport->d_id.b24, fcport->port_name);
-			return;
+	switch (ea->id.b.rsvd_1) {
+	case RSCN_PORT_ADDR:
+		fcport = qla2x00_find_fcport_by_nportid(vha, &ea->id, 1);
+		if (fcport) {
+			if (fcport->flags & FCF_FCP2_DEVICE) {
+				ql_dbg(ql_dbg_disc, vha, 0x2115,
+				       "Delaying session delete for FCP2 portid=%06x %8phC ",
+					fcport->d_id.b24, fcport->port_name);
+				return;
+			}
+			fcport->scan_needed = 1;
+			fcport->rscn_gen++;
+		}
+		break;
+	case RSCN_AREA_ADDR:
+		list_for_each_entry(fcport, &vha->vp_fcports, list) {
+			if (fcport->flags & FCF_FCP2_DEVICE)
+				continue;
+
+			if ((ea->id.b24 & 0xffff00) == (fcport->d_id.b24 & 0xffff00)) {
+				fcport->scan_needed = 1;
+				fcport->rscn_gen++;
+			}
 		}
-		fcport->scan_needed = 1;
-		fcport->rscn_gen++;
+		break;
+	case RSCN_DOM_ADDR:
+		list_for_each_entry(fcport, &vha->vp_fcports, list) {
+			if (fcport->flags & FCF_FCP2_DEVICE)
+				continue;
+
+			if ((ea->id.b24 & 0xff0000) == (fcport->d_id.b24 & 0xff0000)) {
+				fcport->scan_needed = 1;
+				fcport->rscn_gen++;
+			}
+		}
+		break;
+	case RSCN_FAB_ADDR:
+	default:
+		list_for_each_entry(fcport, &vha->vp_fcports, list) {
+			if (fcport->flags & FCF_FCP2_DEVICE)
+				continue;
+
+			fcport->scan_needed = 1;
+			fcport->rscn_gen++;
+		}
+		break;
 	}
 
 	spin_lock_irqsave(&vha->work_lock, flags);
-- 
2.33.0



