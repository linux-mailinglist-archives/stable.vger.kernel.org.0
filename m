Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E08B4062C8
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242025AbhIJAqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:46:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233932AbhIJAWK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:22:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC79E610A3;
        Fri, 10 Sep 2021 00:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233260;
        bh=r6UkilAbGXg9jEIE+iduq/aHqzrYn0ndDQC+R/5RiPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cp9m+DFBDEp8gZdNkPCwKL7SCn+5B/AbqMF3Jb4CaiRSVg3OkWFVMCXxBo6rwYsA4
         4zi+5rAkSBlXE2olSygfzaeLLUc5TKEyxg8Nk5osFC5Wbsn3pk2SmxSsYcJaMPbtBL
         epZwYkm5MvQHiMbhLkbSRk65ZggYOOTCM9q/pjS49upy0GLY4QzwzQ/MLmyLisozmC
         qdk3IyGtLYNv8EtHe7+bzKpsOqsiJxo1K0cLVFw+D4EuJvtpHrPRUlwLCCfuQaD0W0
         Kr282p4WyCUAwVhYO8QKQgqqjiHXAXeGdbKrm5Czuw+6VlNtGdGJYUIswpE7vQ5w+R
         s5uy/PM/DHz6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 23/53] scsi: qla2xxx: Fix unsafe removal from linked list
Date:   Thu,  9 Sep 2021 20:19:58 -0400
Message-Id: <20210910002028.175174-23-sashal@kernel.org>
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

[ Upstream commit 0c9a5f3e42f75dbad5966aa59db935b694ab00d1 ]

On NPIV delete, the VPort is taken off a linked list in an unsafe manner.
The check for VPort refcount should be done behind lock before taking off
the element.

[ 2733.016907] general protection fault: 0000 [#1] SMP NOPTI
[ 2733.016908] qla2xxx [0000:22:00.1]-7088:27: VP[4] deleted.
[ 2733.016912] CPU: 22 PID: 23481 Comm: qla2xxx_15_dpc Kdump: loaded Tainted:
G           OE KX    5.3.18-47-default #1 SLE15-SP3
[ 2733.016914] Hardware name: Dell Inc. PowerEdge R7525/0PYVT1, BIOS 2.1.4 02/17/2021
[ 2733.016929] RIP: 0010:qla2x00_abort_isp+0x90/0x850 [qla2xxx]
[ 2733.016933] RSP: 0018:ffffb9cfc91efe98 EFLAGS: 00010087
[ 2733.016935] RAX: 0000000000000292 RBX: dead000000000100 RCX: 0000000000000000
[ 2733.016936] RDX: 0000000000000001 RSI: ffff944bfeb99558 RDI: ffff944bfc4b4488
[ 2733.016937] RBP: ffff944bfc4b2868 R08: 00000000000187a2 R09: 0000000000000001
[ 2733.016937] R10: ffffb9cfc91efcc8 R11: 0000000000000001 R12: ffff944bfc4b4000
[ 2733.016938] R13: ffff944bfc4b4870 R14: ffff944bfc4b4488 R15: ffff944bda895c80
[ 2733.016939] FS:  0000000000000000(0000) GS:ffff944bfeb80000(0000) knlGS:0000000000000000
[ 2733.016940] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2733.016940] CR2: 00007fc173e74458 CR3: 0000001ff57de000 CR4: 0000000000350ee0
[ 2733.016941] Call Trace:
[ 2733.016951]   qla2xxx_pci_error_detected+0x190/0x190 [qla2xxx]
[ 2733.016957]   qla2x00_do_dpc+0x560/0xa10 [qla2xxx]
[ 2733.016962]   kthread+0x10d/0x130
[ 2733.016963]   kthread_park+0xa0/0xa0
[ 2733.016966]   ret_from_fork+0x22/0x40

Link: https://lore.kernel.org/r/20210810043720.1137-9-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 33 +++++++++++++++++---------
 drivers/scsi/qla2xxx/qla_mid.c  | 42 ++++++++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_os.c   |  6 ++---
 3 files changed, 50 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 6faf34fa6220..9d51ef4eae3f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -6388,13 +6388,13 @@ void
 qla2x00_update_fcports(scsi_qla_host_t *base_vha)
 {
 	fc_port_t *fcport;
-	struct scsi_qla_host *vha;
+	struct scsi_qla_host *vha, *tvp;
 	struct qla_hw_data *ha = base_vha->hw;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ha->vport_slock, flags);
 	/* Go with deferred removal of rport references. */
-	list_for_each_entry(vha, &base_vha->hw->vp_list, list) {
+	list_for_each_entry_safe(vha, tvp, &base_vha->hw->vp_list, list) {
 		atomic_inc(&vha->vref_count);
 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
 			if (fcport->drport &&
@@ -6739,7 +6739,8 @@ void
 qla2x00_quiesce_io(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct scsi_qla_host *vp;
+	struct scsi_qla_host *vp, *tvp;
+	unsigned long flags;
 
 	ql_dbg(ql_dbg_dpc, vha, 0x401d,
 	    "Quiescing I/O - ha=%p.\n", ha);
@@ -6748,8 +6749,18 @@ qla2x00_quiesce_io(scsi_qla_host_t *vha)
 	if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
 		atomic_set(&vha->loop_state, LOOP_DOWN);
 		qla2x00_mark_all_devices_lost(vha);
-		list_for_each_entry(vp, &ha->vp_list, list)
+
+		spin_lock_irqsave(&ha->vport_slock, flags);
+		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
+			atomic_inc(&vp->vref_count);
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 			qla2x00_mark_all_devices_lost(vp);
+
+			spin_lock_irqsave(&ha->vport_slock, flags);
+			atomic_dec(&vp->vref_count);
+		}
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
 	} else {
 		if (!atomic_read(&vha->loop_down_timer))
 			atomic_set(&vha->loop_down_timer,
@@ -6764,7 +6775,7 @@ void
 qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct scsi_qla_host *vp;
+	struct scsi_qla_host *vp, *tvp;
 	unsigned long flags;
 	fc_port_t *fcport;
 	u16 i;
@@ -6828,7 +6839,7 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 		qla2x00_mark_all_devices_lost(vha);
 
 		spin_lock_irqsave(&ha->vport_slock, flags);
-		list_for_each_entry(vp, &ha->vp_list, list) {
+		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
 			atomic_inc(&vp->vref_count);
 			spin_unlock_irqrestore(&ha->vport_slock, flags);
 
@@ -6850,7 +6861,7 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 		fcport->scan_state = 0;
 	}
 	spin_lock_irqsave(&ha->vport_slock, flags);
-	list_for_each_entry(vp, &ha->vp_list, list) {
+	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
 		atomic_inc(&vp->vref_count);
 		spin_unlock_irqrestore(&ha->vport_slock, flags);
 
@@ -6898,7 +6909,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 	int rval;
 	uint8_t        status = 0;
 	struct qla_hw_data *ha = vha->hw;
-	struct scsi_qla_host *vp;
+	struct scsi_qla_host *vp, *tvp;
 	struct req_que *req = ha->req_q_map[0];
 	unsigned long flags;
 
@@ -7030,7 +7041,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 		ql_dbg(ql_dbg_taskm, vha, 0x8022, "%s succeeded.\n", __func__);
 		qla2x00_configure_hba(vha);
 		spin_lock_irqsave(&ha->vport_slock, flags);
-		list_for_each_entry(vp, &ha->vp_list, list) {
+		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
 			if (vp->vp_idx) {
 				atomic_inc(&vp->vref_count);
 				spin_unlock_irqrestore(&ha->vport_slock, flags);
@@ -8719,7 +8730,7 @@ qla82xx_restart_isp(scsi_qla_host_t *vha)
 {
 	int status, rval;
 	struct qla_hw_data *ha = vha->hw;
-	struct scsi_qla_host *vp;
+	struct scsi_qla_host *vp, *tvp;
 	unsigned long flags;
 
 	status = qla2x00_init_rings(vha);
@@ -8791,7 +8802,7 @@ qla82xx_restart_isp(scsi_qla_host_t *vha)
 		    "qla82xx_restart_isp succeeded.\n");
 
 		spin_lock_irqsave(&ha->vport_slock, flags);
-		list_for_each_entry(vp, &ha->vp_list, list) {
+		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
 			if (vp->vp_idx) {
 				atomic_inc(&vp->vref_count);
 				spin_unlock_irqrestore(&ha->vport_slock, flags);
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index c7caf322f445..787e0c0446a6 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -65,7 +65,7 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
 	uint16_t vp_id;
 	struct qla_hw_data *ha = vha->hw;
 	unsigned long flags = 0;
-	u8 i;
+	u32 i, bailout;
 
 	mutex_lock(&ha->vport_lock);
 	/*
@@ -75,21 +75,29 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
 	 * ensures no active vp_list traversal while the vport is removed
 	 * from the queue)
 	 */
-	for (i = 0; i < 10; i++) {
-		if (wait_event_timeout(vha->vref_waitq,
-		    !atomic_read(&vha->vref_count), HZ) > 0)
+	bailout = 0;
+	for (i = 0; i < 500; i++) {
+		spin_lock_irqsave(&ha->vport_slock, flags);
+		if (atomic_read(&vha->vref_count) == 0) {
+			list_del(&vha->list);
+			qlt_update_vp_map(vha, RESET_VP_IDX);
+			bailout = 1;
+		}
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
+
+		if (bailout)
 			break;
+		else
+			msleep(20);
 	}
-
-	spin_lock_irqsave(&ha->vport_slock, flags);
-	if (atomic_read(&vha->vref_count)) {
-		ql_dbg(ql_dbg_vport, vha, 0xfffa,
-		    "vha->vref_count=%u timeout\n", vha->vref_count.counter);
-		vha->vref_count = (atomic_t)ATOMIC_INIT(0);
+	if (!bailout) {
+		ql_log(ql_log_info, vha, 0xfffa,
+			"vha->vref_count=%u timeout\n", vha->vref_count.counter);
+		spin_lock_irqsave(&ha->vport_slock, flags);
+		list_del(&vha->list);
+		qlt_update_vp_map(vha, RESET_VP_IDX);
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
 	}
-	list_del(&vha->list);
-	qlt_update_vp_map(vha, RESET_VP_IDX);
-	spin_unlock_irqrestore(&ha->vport_slock, flags);
 
 	vp_id = vha->vp_idx;
 	ha->num_vhosts--;
@@ -257,13 +265,13 @@ qla24xx_configure_vp(scsi_qla_host_t *vha)
 void
 qla2x00_alert_all_vps(struct rsp_que *rsp, uint16_t *mb)
 {
-	scsi_qla_host_t *vha;
+	scsi_qla_host_t *vha, *tvp;
 	struct qla_hw_data *ha = rsp->hw;
 	int i = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ha->vport_slock, flags);
-	list_for_each_entry(vha, &ha->vp_list, list) {
+	list_for_each_entry_safe(vha, tvp, &ha->vp_list, list) {
 		if (vha->vp_idx) {
 			if (test_bit(VPORT_DELETE, &vha->dpc_flags))
 				continue;
@@ -416,7 +424,7 @@ void
 qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
-	scsi_qla_host_t *vp;
+	scsi_qla_host_t *vp, *tvp;
 	unsigned long flags = 0;
 
 	if (vha->vp_idx)
@@ -430,7 +438,7 @@ qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
 		return;
 
 	spin_lock_irqsave(&ha->vport_slock, flags);
-	list_for_each_entry(vp, &ha->vp_list, list) {
+	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
 		if (vp->vp_idx) {
 			atomic_inc(&vp->vref_count);
 			spin_unlock_irqrestore(&ha->vport_slock, flags);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 21be50b35bc2..dd734992c726 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7366,7 +7366,7 @@ static void qla_pci_error_cleanup(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 	struct qla_qpair *qpair = NULL;
-	struct scsi_qla_host *vp;
+	struct scsi_qla_host *vp, *tvp;
 	fc_port_t *fcport;
 	int i;
 	unsigned long flags;
@@ -7407,7 +7407,7 @@ static void qla_pci_error_cleanup(scsi_qla_host_t *vha)
 	qla2x00_mark_all_devices_lost(vha);
 
 	spin_lock_irqsave(&ha->vport_slock, flags);
-	list_for_each_entry(vp, &ha->vp_list, list) {
+	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
 		atomic_inc(&vp->vref_count);
 		spin_unlock_irqrestore(&ha->vport_slock, flags);
 		qla2x00_mark_all_devices_lost(vp);
@@ -7421,7 +7421,7 @@ static void qla_pci_error_cleanup(scsi_qla_host_t *vha)
 		fcport->flags &= ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
 
 	spin_lock_irqsave(&ha->vport_slock, flags);
-	list_for_each_entry(vp, &ha->vp_list, list) {
+	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
 		atomic_inc(&vp->vref_count);
 		spin_unlock_irqrestore(&ha->vport_slock, flags);
 		list_for_each_entry(fcport, &vp->vp_fcports, list)
-- 
2.30.2

