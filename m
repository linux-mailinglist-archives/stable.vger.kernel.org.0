Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B9E250472
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 19:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgHXRB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 13:01:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728486AbgHXQik (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 12:38:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40DA222D71;
        Mon, 24 Aug 2020 16:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598287110;
        bh=qkdyS7d8IfKRt0vPSqX3ghon+iMsNJgrh+HCthJqC/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbsnATCzbuYf74Zru06EGGhLHMzr0sSIdyxoUa99X7+r3JQCCc3lufB99KX/RBy7b
         UCRUo9PHm8I/yui0yTnLtTcNMmGxR7UNLBXHYeQUZePgX9eN49LfJzUjwNfSXRUIVs
         BFMciOUN8klPRTx2HXh+8GhGyR35/MQzRL7epPb8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 28/38] scsi: qla2xxx: Fix login timeout
Date:   Mon, 24 Aug 2020 12:37:40 -0400
Message-Id: <20200824163751.606577-28-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163751.606577-1-sashal@kernel.org>
References: <20200824163751.606577-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit abb31aeaa9b20680b0620b23fea5475ea4591e31 ]

Multipath errors were seen during failback due to login timeout.  The
remote device sent LOGO, the local host tore down the session and did
relogin. The RSCN arrived indicates remote device is going through failover
after which the relogin is in a 20s timeout phase.  At this point the
driver is stuck in the relogin process.  Add a fix to delete the session as
part of abort/flush the login.

Link: https://lore.kernel.org/r/20200806111014.28434-5-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gs.c     | 18 +++++++++++++++---
 drivers/scsi/qla2xxx/qla_target.c |  2 +-
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index a44de4c5dcf6c..fc6e12fb7d77b 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3673,10 +3673,22 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 		}
 
 		if (fcport->scan_state != QLA_FCPORT_FOUND) {
+			bool do_delete = false;
+
+			if (fcport->scan_needed &&
+			    fcport->disc_state == DSC_LOGIN_PEND) {
+				/* Cable got disconnected after we sent
+				 * a login. Do delete to prevent timeout.
+				 */
+				fcport->logout_on_delete = 1;
+				do_delete = true;
+			}
+
 			fcport->scan_needed = 0;
-			if ((qla_dual_mode_enabled(vha) ||
-				qla_ini_mode_enabled(vha)) &&
-			    atomic_read(&fcport->state) == FCS_ONLINE) {
+			if (((qla_dual_mode_enabled(vha) ||
+			      qla_ini_mode_enabled(vha)) &&
+			    atomic_read(&fcport->state) == FCS_ONLINE) ||
+				do_delete) {
 				if (fcport->loop_id != FC_NO_LOOP_ID) {
 					if (fcport->flags & FCF_FCP2_DEVICE)
 						fcport->logout_on_delete = 0;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index cb8a892e2d393..b75e6e4d58c06 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1262,7 +1262,7 @@ void qlt_schedule_sess_for_deletion(struct fc_port *sess)
 
 	qla24xx_chk_fcp_state(sess);
 
-	ql_dbg(ql_dbg_tgt, sess->vha, 0xe001,
+	ql_dbg(ql_dbg_disc, sess->vha, 0xe001,
 	    "Scheduling sess %p for deletion %8phC\n",
 	    sess, sess->port_name);
 
-- 
2.25.1

