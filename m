Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55DFB26F5B
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731477AbfEVTZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:25:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731469AbfEVTZA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:25:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C697F21473;
        Wed, 22 May 2019 19:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553098;
        bh=0ZLy2LeUMIxMVKlnQ4fwW1DrlViLCq41LvDBz5QV1ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c/ep9wSwLoylQkiiT6SYzSkeT6OnHj6/19kqVYhGrL4JwDZQ2aqc64HkqBzNM8NiK
         BumoO1da54WTfuiNIC8gng9h+tO5tavRFyYi6bOiulv9Gk2Z0QuaF54S+tPg9Xdy9a
         tZlLpR5q1Nztxb4//3q/JuAejRfuB9jUBE0SrNlQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Giridhar Malavali <gmalavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 047/317] scsi: qla2xxx: Fix hardirq-unsafe locking
Date:   Wed, 22 May 2019 15:19:08 -0400
Message-Id: <20190522192338.23715-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 300ec7415c1fed5c73660f50c8e14a67e236dc0a ]

Since fc_remote_port_delete() must be called with interrupts enabled, do
not disable interrupts when calling that function. Remove the lockin calls
from around the put_sess() call. This is safe because the function that is
called when the final reference is dropped, qlt_unreg_sess(), grabs the
proper locks. This patch avoids that lockdep reports the following:

WARNING: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected
kworker/2:1/62 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
0000000009e679b3 (&(&k->k_lock)->rlock){+.+.}, at: klist_next+0x43/0x1d0

and this task is already holding:
00000000a033b71c (&(&ha->tgt.sess_lock)->rlock){-...}, at: qla24xx_delete_sess_fn+0x55/0xf0 [qla2xxx_scst]
which would create a new lock dependency:
 (&(&ha->tgt.sess_lock)->rlock){-...} -> (&(&k->k_lock)->rlock){+.+.}

but this new dependency connects a HARDIRQ-irq-safe lock:
 (&(&ha->tgt.sess_lock)->rlock){-...}

... which became HARDIRQ-irq-safe at:
  lock_acquire+0xe3/0x200
  _raw_spin_lock_irqsave+0x3d/0x60
  qla24xx_report_id_acquisition+0xa69/0xe30 [qla2xxx_scst]
  qla24xx_process_response_queue+0x69e/0x1270 [qla2xxx_scst]
  qla24xx_msix_rsp_q+0x79/0xf0 [qla2xxx_scst]
  __handle_irq_event_percpu+0x79/0x3c0
  handle_irq_event_percpu+0x70/0xf0
  handle_irq_event+0x5a/0x8b
  handle_edge_irq+0x12c/0x310
  handle_irq+0x192/0x20a
  do_IRQ+0x73/0x160
  ret_from_intr+0x0/0x1d
  default_idle+0x23/0x1f0
  arch_cpu_idle+0x15/0x20
  default_idle_call+0x35/0x40
  do_idle+0x2bb/0x2e0
  cpu_startup_entry+0x1d/0x20
  start_secondary+0x2a8/0x320
  secondary_startup_64+0xa4/0xb0

to a HARDIRQ-irq-unsafe lock:
 (&(&k->k_lock)->rlock){+.+.}

... which became HARDIRQ-irq-unsafe at:
...
  lock_acquire+0xe3/0x200
  _raw_spin_lock+0x32/0x50
  klist_add_tail+0x33/0xb0
  device_add+0x7e1/0xb50
  device_create_groups_vargs+0x11c/0x150
  device_create_with_groups+0x89/0xb0
  vtconsole_class_init+0xb2/0x124
  do_one_initcall+0xc5/0x3ce
  kernel_init_freeable+0x295/0x32e
  kernel_init+0x11/0x11b
  ret_from_fork+0x3a/0x50

other info that might help us debug this:

 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&(&k->k_lock)->rlock);
                               local_irq_disable();
                               lock(&(&ha->tgt.sess_lock)->rlock);
                               lock(&(&k->k_lock)->rlock);
  <Interrupt>
    lock(&(&ha->tgt.sess_lock)->rlock);

 *** DEADLOCK ***

3 locks held by kworker/2:1/62:
 #0: 00000000a4319c16 ((wq_completion)"qla2xxx_wq"){+.+.}, at: process_one_work+0x437/0xa80
 #1: 00000000ffa34c42 ((work_completion)(&sess->del_work)){+.+.}, at: process_one_work+0x437/0xa80
 #2: 00000000a033b71c (&(&ha->tgt.sess_lock)->rlock){-...}, at: qla24xx_delete_sess_fn+0x55/0xf0 [qla2xxx_scst]

the dependencies between HARDIRQ-irq-safe lock and the holding lock:
-> (&(&ha->tgt.sess_lock)->rlock){-...} ops: 8 {
   IN-HARDIRQ-W at:
                    lock_acquire+0xe3/0x200
                    _raw_spin_lock_irqsave+0x3d/0x60
                    qla24xx_report_id_acquisition+0xa69/0xe30 [qla2xxx_scst]
                    qla24xx_process_response_queue+0x69e/0x1270 [qla2xxx_scst]
                    qla24xx_msix_rsp_q+0x79/0xf0 [qla2xxx_scst]
                    __handle_irq_event_percpu+0x79/0x3c0
                    handle_irq_event_percpu+0x70/0xf0
                    handle_irq_event+0x5a/0x8b
                    handle_edge_irq+0x12c/0x310
                    handle_irq+0x192/0x20a
                    do_IRQ+0x73/0x160
                    ret_from_intr+0x0/0x1d
                    default_idle+0x23/0x1f0
                    arch_cpu_idle+0x15/0x20
                    default_idle_call+0x35/0x40
                    do_idle+0x2bb/0x2e0
                    cpu_startup_entry+0x1d/0x20
                    start_secondary+0x2a8/0x320
                    secondary_startup_64+0xa4/0xb0
   INITIAL USE at:
                   lock_acquire+0xe3/0x200
                   _raw_spin_lock_irqsave+0x3d/0x60
                   qla24xx_report_id_acquisition+0xa69/0xe30 [qla2xxx_scst]
                   qla24xx_process_response_queue+0x69e/0x1270 [qla2xxx_scst]
                   qla24xx_msix_rsp_q+0x79/0xf0 [qla2xxx_scst]
                   __handle_irq_event_percpu+0x79/0x3c0
                   handle_irq_event_percpu+0x70/0xf0
                   handle_irq_event+0x5a/0x8b
                   handle_edge_irq+0x12c/0x310
                   handle_irq+0x192/0x20a
                   do_IRQ+0x73/0x160
                   ret_from_intr+0x0/0x1d
                   default_idle+0x23/0x1f0
                   arch_cpu_idle+0x15/0x20
                   default_idle_call+0x35/0x40
                   do_idle+0x2bb/0x2e0
                   cpu_startup_entry+0x1d/0x20
                   start_secondary+0x2a8/0x320
                   secondary_startup_64+0xa4/0xb0
 }
 ... key      at: [<ffffffffa0c0d080>] __key.85462+0x0/0xfffffffffff7df80 [qla2xxx_scst]
 ... acquired at:
   lock_acquire+0xe3/0x200
   _raw_spin_lock_irqsave+0x3d/0x60
   klist_next+0x43/0x1d0
   device_for_each_child+0x96/0x110
   scsi_target_block+0x3c/0x40 [scsi_mod]
   fc_remote_port_delete+0xe7/0x1c0 [scsi_transport_fc]
   qla2x00_mark_device_lost+0xa0b/0xa30 [qla2xxx_scst]
   qlt_unreg_sess+0x1c6/0x380 [qla2xxx_scst]
   qla24xx_delete_sess_fn+0xe6/0xf0 [qla2xxx_scst]
   process_one_work+0x511/0xa80
   worker_thread+0x67/0x5b0
   kthread+0x1d2/0x1f0
   ret_from_fork+0x3a/0x50

the dependencies between the lock to be acquired
 and HARDIRQ-irq-unsafe lock:
-> (&(&k->k_lock)->rlock){+.+.} ops: 13831 {
   HARDIRQ-ON-W at:
                    lock_acquire+0xe3/0x200
                    _raw_spin_lock+0x32/0x50
                    klist_add_tail+0x33/0xb0
                    device_add+0x7e1/0xb50
                    device_create_groups_vargs+0x11c/0x150
                    device_create_with_groups+0x89/0xb0
                    vtconsole_class_init+0xb2/0x124
                    do_one_initcall+0xc5/0x3ce
                    kernel_init_freeable+0x295/0x32e
                    kernel_init+0x11/0x11b
                    ret_from_fork+0x3a/0x50
   SOFTIRQ-ON-W at:
                    lock_acquire+0xe3/0x200
                    _raw_spin_lock+0x32/0x50
                    klist_add_tail+0x33/0xb0
                    device_add+0x7e1/0xb50
                    device_create_groups_vargs+0x11c/0x150
                    device_create_with_groups+0x89/0xb0
                    vtconsole_class_init+0xb2/0x124
                    do_one_initcall+0xc5/0x3ce
                    kernel_init_freeable+0x295/0x32e
                    kernel_init+0x11/0x11b
                    ret_from_fork+0x3a/0x50
   INITIAL USE at:
                   lock_acquire+0xe3/0x200
                   _raw_spin_lock+0x32/0x50
                   klist_add_tail+0x33/0xb0
                   device_add+0x7e1/0xb50
                   device_create_groups_vargs+0x11c/0x150
                   device_create_with_groups+0x89/0xb0
                   vtconsole_class_init+0xb2/0x124
                   do_one_initcall+0xc5/0x3ce
                   kernel_init_freeable+0x295/0x32e
                   kernel_init+0x11/0x11b
                   ret_from_fork+0x3a/0x50
 }
 ... key      at: [<ffffffff83ed8780>] __key.15491+0x0/0x40
 ... acquired at:
   lock_acquire+0xe3/0x200
   _raw_spin_lock_irqsave+0x3d/0x60
   klist_next+0x43/0x1d0
   device_for_each_child+0x96/0x110
   scsi_target_block+0x3c/0x40 [scsi_mod]
   fc_remote_port_delete+0xe7/0x1c0 [scsi_transport_fc]
   qla2x00_mark_device_lost+0xa0b/0xa30 [qla2xxx_scst]
   qlt_unreg_sess+0x1c6/0x380 [qla2xxx_scst]
   qla24xx_delete_sess_fn+0xe6/0xf0 [qla2xxx_scst]
   process_one_work+0x511/0xa80
   worker_thread+0x67/0x5b0
   kthread+0x1d2/0x1f0
   ret_from_fork+0x3a/0x50

stack backtrace:
CPU: 2 PID: 62 Comm: kworker/2:1 Tainted: G           O      5.0.7-dbg+ #8
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
Workqueue: qla2xxx_wq qla24xx_delete_sess_fn [qla2xxx_scst]
Call Trace:
 dump_stack+0x86/0xca
 check_usage.cold.52+0x473/0x563
 __lock_acquire+0x11c0/0x23e0
 lock_acquire+0xe3/0x200
 _raw_spin_lock_irqsave+0x3d/0x60
 klist_next+0x43/0x1d0
 device_for_each_child+0x96/0x110
 scsi_target_block+0x3c/0x40 [scsi_mod]
 fc_remote_port_delete+0xe7/0x1c0 [scsi_transport_fc]
 qla2x00_mark_device_lost+0xa0b/0xa30 [qla2xxx_scst]
 qlt_unreg_sess+0x1c6/0x380 [qla2xxx_scst]
 qla24xx_delete_sess_fn+0xe6/0xf0 [qla2xxx_scst]
 process_one_work+0x511/0xa80
 worker_thread+0x67/0x5b0
 kthread+0x1d2/0x1f0
 ret_from_fork+0x3a/0x50

Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Giridhar Malavali <gmalavali@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_target.c  | 25 ++++++++-----------------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  2 --
 2 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index d4ac18573d813..4758cd6877188 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -680,7 +680,6 @@ int qla24xx_async_notify_ack(scsi_qla_host_t *vha, fc_port_t *fcport,
 void qla24xx_do_nack_work(struct scsi_qla_host *vha, struct qla_work_evt *e)
 {
 	fc_port_t *t;
-	unsigned long flags;
 
 	switch (e->u.nack.type) {
 	case SRB_NACK_PRLI:
@@ -690,10 +689,8 @@ void qla24xx_do_nack_work(struct scsi_qla_host *vha, struct qla_work_evt *e)
 		if (t) {
 			ql_log(ql_log_info, vha, 0xd034,
 			    "%s create sess success %p", __func__, t);
-			spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 			/* create sess has an extra kref */
 			vha->hw->tgt.tgt_ops->put_sess(e->u.nack.fcport);
-			spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 		}
 		break;
 	}
@@ -705,9 +702,6 @@ void qla24xx_delete_sess_fn(struct work_struct *work)
 {
 	fc_port_t *fcport = container_of(work, struct fc_port, del_work);
 	struct qla_hw_data *ha = fcport->vha->hw;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 
 	if (fcport->se_sess) {
 		ha->tgt.tgt_ops->shutdown_sess(fcport);
@@ -715,7 +709,6 @@ void qla24xx_delete_sess_fn(struct work_struct *work)
 	} else {
 		qlt_unreg_sess(fcport);
 	}
-	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 }
 
 /*
@@ -784,8 +777,9 @@ void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
 		    fcport->port_name, sess->loop_id);
 		sess->local = 0;
 	}
-	ha->tgt.tgt_ops->put_sess(sess);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+
+	ha->tgt.tgt_ops->put_sess(sess);
 }
 
 /*
@@ -4242,9 +4236,7 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 	/*
 	 * Drop extra session reference from qla_tgt_handle_cmd_for_atio*(
 	 */
-	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 	ha->tgt.tgt_ops->put_sess(sess);
-	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 	return;
 
 out_term:
@@ -4261,9 +4253,7 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 	target_free_tag(sess->se_sess, &cmd->se_cmd);
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
-	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 	ha->tgt.tgt_ops->put_sess(sess);
-	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 }
 
 static void qlt_do_work(struct work_struct *work)
@@ -4472,9 +4462,7 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 	if (!cmd) {
 		ql_dbg(ql_dbg_io, vha, 0x3062,
 		    "qla_target(%d): Allocation of cmd failed\n", vha->vp_idx);
-		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 		ha->tgt.tgt_ops->put_sess(sess);
-		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 		return -EBUSY;
 	}
 
@@ -6318,17 +6306,19 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 	}
 
 	rc = __qlt_24xx_handle_abts(vha, &prm->abts, sess);
-	ha->tgt.tgt_ops->put_sess(sess);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags2);
 
+	ha->tgt.tgt_ops->put_sess(sess);
+
 	if (rc != 0)
 		goto out_term;
 	return;
 
 out_term2:
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags2);
+
 	if (sess)
 		ha->tgt.tgt_ops->put_sess(sess);
-	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags2);
 
 out_term:
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -6388,9 +6378,10 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 	    scsilun_to_int((struct scsi_lun *)&a->u.isp24.fcp_cmnd.lun);
 
 	rc = qlt_issue_task_mgmt(sess, unpacked_lun, fn, iocb, 0);
-	ha->tgt.tgt_ops->put_sess(sess);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 
+	ha->tgt.tgt_ops->put_sess(sess);
+
 	if (rc != 0)
 		goto out_term;
 	return;
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 72d5b678e85d2..5e3bb49687dff 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -359,7 +359,6 @@ static void tcm_qla2xxx_put_sess(struct fc_port *sess)
 	if (!sess)
 		return;
 
-	assert_spin_locked(&sess->vha->hw->tgt.sess_lock);
 	kref_put(&sess->sess_kref, tcm_qla2xxx_release_session);
 }
 
@@ -861,7 +860,6 @@ static void tcm_qla2xxx_clear_nacl_from_fcport_map(struct fc_port *sess)
 
 static void tcm_qla2xxx_shutdown_sess(struct fc_port *sess)
 {
-	assert_spin_locked(&sess->vha->hw->tgt.sess_lock);
 	target_sess_cmd_list_set_waiting(sess->se_sess);
 }
 
-- 
2.20.1

