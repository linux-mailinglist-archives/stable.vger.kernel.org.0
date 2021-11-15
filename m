Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A274450EBD
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241229AbhKOSSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:18:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:49952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240687AbhKOSLr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:11:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16830633C5;
        Mon, 15 Nov 2021 17:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998462;
        bh=zmg9aHYYdo0oKZAUMkV8EGJbugpSfAwWqxsvPPy/p9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HE7kMxC/t+sBUHUt5cJZ8+beWBhGGAJa2MBNM3kOByWN2kODb67oofE5Qlht+D4fD
         cmhwcS6PUIyc6jxyhcUeNqObkepbIAxb6cWJFG/L+M+1ukmoNBuHUACt9WrSFz7cxb
         YsIRdjdprTR1kKTzW8bF/oh4rCfpDVCAVgrfdky0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 501/575] scsi: qla2xxx: Turn off target reset during issue_lip
Date:   Mon, 15 Nov 2021 18:03:46 +0100
Message-Id: <20211115165401.015299119@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

[ Upstream commit 0b7a9fd934a68ebfc1019811b7bdc1742072ad7b ]

When user uses issue_lip to do link bounce, driver sends additional target
reset to remote device before resetting the link. The target reset would
affect other paths with active I/Os. This patch will remove the unnecessary
target reset.

Link: https://lore.kernel.org/r/20211026115412.27691-4-njavali@marvell.com
Fixes: 5854771e314e ("[SCSI] qla2xxx: Add ISPFX00 specific bus reset routine")
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_gbl.h |  2 --
 drivers/scsi/qla2xxx/qla_mr.c  | 23 -----------------------
 drivers/scsi/qla2xxx/qla_os.c  | 27 ++-------------------------
 3 files changed, 2 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index e39b4f2da73a0..3bc1850273421 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -158,7 +158,6 @@ extern int ql2xasynctmfenable;
 extern int ql2xgffidenable;
 extern int ql2xenabledif;
 extern int ql2xenablehba_err_chk;
-extern int ql2xtargetreset;
 extern int ql2xdontresethba;
 extern uint64_t ql2xmaxlun;
 extern int ql2xmdcapmask;
@@ -791,7 +790,6 @@ extern void qlafx00_abort_iocb(srb_t *, struct abort_iocb_entry_fx00 *);
 extern void qlafx00_fxdisc_iocb(srb_t *, struct fxdisc_entry_fx00 *);
 extern void qlafx00_timer_routine(scsi_qla_host_t *);
 extern int qlafx00_rescan_isp(scsi_qla_host_t *);
-extern int qlafx00_loop_reset(scsi_qla_host_t *vha);
 
 /* qla82xx related functions */
 
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index ca73066853255..7178646ee0f06 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -738,29 +738,6 @@ qlafx00_lun_reset(fc_port_t *fcport, uint64_t l, int tag)
 	return qla2x00_async_tm_cmd(fcport, TCF_LUN_RESET, l, tag);
 }
 
-int
-qlafx00_loop_reset(scsi_qla_host_t *vha)
-{
-	int ret;
-	struct fc_port *fcport;
-	struct qla_hw_data *ha = vha->hw;
-
-	if (ql2xtargetreset) {
-		list_for_each_entry(fcport, &vha->vp_fcports, list) {
-			if (fcport->port_type != FCT_TARGET)
-				continue;
-
-			ret = ha->isp_ops->target_reset(fcport, 0, 0);
-			if (ret != QLA_SUCCESS) {
-				ql_dbg(ql_dbg_taskm, vha, 0x803d,
-				    "Bus Reset failed: Reset=%d "
-				    "d_id=%x.\n", ret, fcport->d_id.b24);
-			}
-		}
-	}
-	return QLA_SUCCESS;
-}
-
 int
 qlafx00_iospace_config(struct qla_hw_data *ha)
 {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 30ce84468c759..e7f73a167fbd6 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -197,12 +197,6 @@ MODULE_PARM_DESC(ql2xdbwr,
 		" 0 -- Regular doorbell.\n"
 		" 1 -- CAMRAM doorbell (faster).\n");
 
-int ql2xtargetreset = 1;
-module_param(ql2xtargetreset, int, S_IRUGO);
-MODULE_PARM_DESC(ql2xtargetreset,
-		 "Enable target reset."
-		 "Default is 1 - use hw defaults.");
-
 int ql2xgffidenable;
 module_param(ql2xgffidenable, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xgffidenable,
@@ -1652,27 +1646,10 @@ int
 qla2x00_loop_reset(scsi_qla_host_t *vha)
 {
 	int ret;
-	struct fc_port *fcport;
 	struct qla_hw_data *ha = vha->hw;
 
-	if (IS_QLAFX00(ha)) {
-		return qlafx00_loop_reset(vha);
-	}
-
-	if (ql2xtargetreset == 1 && ha->flags.enable_target_reset) {
-		list_for_each_entry(fcport, &vha->vp_fcports, list) {
-			if (fcport->port_type != FCT_TARGET)
-				continue;
-
-			ret = ha->isp_ops->target_reset(fcport, 0, 0);
-			if (ret != QLA_SUCCESS) {
-				ql_dbg(ql_dbg_taskm, vha, 0x802c,
-				    "Bus Reset failed: Reset=%d "
-				    "d_id=%x.\n", ret, fcport->d_id.b24);
-			}
-		}
-	}
-
+	if (IS_QLAFX00(ha))
+		return QLA_SUCCESS;
 
 	if (ha->flags.enable_lip_full_login && !IS_CNA_CAPABLE(ha)) {
 		atomic_set(&vha->loop_state, LOOP_DOWN);
-- 
2.33.0



