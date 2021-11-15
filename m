Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA47451E31
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355042AbhKPAfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:45402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344667AbhKOTZL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF41A6336B;
        Mon, 15 Nov 2021 19:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002921;
        bh=hJKan4MyEIwf7sqkwibzZ7F4nWlaQD/iqhNokcKSvuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gmr8zPv+sh+1eLJPzN9GZid+Ur68l4IiuL2MecdlikKIg/GKkbGosFVlmjEjzdoWU
         FBdyj6CNlfU17rsaFQX8hAlBxdvs+yirlejbedLrpLnAoqqTExAmB6RtcOQ/NqP+ZO
         FBmKuGCobcgwx4Fh0PRFV5SPHqD+Fp9NL6ZY0ax0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Bolshakov <r.bolshakov@yadro.com>,
        Mike Christie <michael.christie@oracle.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 746/917] scsi: target: core: Remove from tmr_list during LUN unlink
Date:   Mon, 15 Nov 2021 18:04:01 +0100
Message-Id: <20211115165454.214003287@linuxfoundation.org>
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

From: Dmitry Bogdanov <d.bogdanov@yadro.com>

[ Upstream commit 12b6fcd0ea7f3cb7c3b34668fc678779924123ae ]

Currently TMF commands are removed from de_device.dev_tmf_list at the very
end of se_cmd lifecycle. However, se_lun unlinks from se_cmd upon a command
status (response) being queued in transport layer. This means that LUN and
backend device can be deleted in the meantime and a panic will occur:

target_tmr_work()
	cmd->se_tfo->queue_tm_rsp(cmd); // send abort_rsp to a wire
	transport_lun_remove_cmd(cmd) // unlink se_cmd from se_lun
- // - // - // -
<<<--- lun remove
<<<--- core backend device remove
- // - // - // -
qlt_handle_abts_completion()
  tfo->free_mcmd()
    transport_generic_free_cmd()
      target_put_sess_cmd()
        core_tmr_release_req() {
          if (dev) { // backend device, can not be null
            spin_lock_irqsave(&dev->se_tmr_lock, flags); //<<<--- CRASH

Call Trace:
NIP [c000000000e1683c] _raw_spin_lock_irqsave+0x2c/0xc0
LR [c00800000e433338] core_tmr_release_req+0x40/0xa0 [target_core_mod]
Call Trace:
(unreliable)
0x0
target_put_sess_cmd+0x2a0/0x370 [target_core_mod]
transport_generic_free_cmd+0x6c/0x1b0 [target_core_mod]
tcm_qla2xxx_complete_mcmd+0x28/0x50 [tcm_qla2xxx]
process_one_work+0x2c4/0x5c0
worker_thread+0x88/0x690

For the iSCSI protocol this is easily reproduced:

 - Send some SCSI sommand

 - Send Abort of that command over iSCSI

 - Remove LUN on target

 - Send next iSCSI command to acknowledge the Abort_Response

 - Target panics

There is no need to keep the command in tmr_list until response completion,
so move the removal from tmr_list from the response completion to the
response queueing when the LUN is unlinked.  Move the removal from state
list too as it is a subject to the same race condition.

Link: https://lore.kernel.org/r/20211018135753.15297-1-d.bogdanov@yadro.com
Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_tmr.c       | 17 +--------------
 drivers/target/target_core_transport.c | 30 ++++++++++++++++++++------
 2 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index e7fcbc09f9dbc..bac111456fa1d 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -50,15 +50,6 @@ EXPORT_SYMBOL(core_tmr_alloc_req);
 
 void core_tmr_release_req(struct se_tmr_req *tmr)
 {
-	struct se_device *dev = tmr->tmr_dev;
-	unsigned long flags;
-
-	if (dev) {
-		spin_lock_irqsave(&dev->se_tmr_lock, flags);
-		list_del_init(&tmr->tmr_list);
-		spin_unlock_irqrestore(&dev->se_tmr_lock, flags);
-	}
-
 	kfree(tmr);
 }
 
@@ -156,13 +147,6 @@ void core_tmr_abort_task(
 			se_cmd->state_active = false;
 			spin_unlock_irqrestore(&dev->queues[i].lock, flags);
 
-			/*
-			 * Ensure that this ABORT request is visible to the LU
-			 * RESET code.
-			 */
-			if (!tmr->tmr_dev)
-				WARN_ON_ONCE(transport_lookup_tmr_lun(tmr->task_cmd) < 0);
-
 			if (dev->transport->tmr_notify)
 				dev->transport->tmr_notify(dev, TMR_ABORT_TASK,
 							   &aborted_list);
@@ -234,6 +218,7 @@ static void core_tmr_drain_tmr_list(
 		}
 
 		list_move_tail(&tmr_p->tmr_list, &drain_tmr_list);
+		tmr_p->tmr_dev = NULL;
 	}
 	spin_unlock_irqrestore(&dev->se_tmr_lock, flags);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 14c6f2bb1b01d..e60abd230e90f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -676,6 +676,21 @@ static void target_remove_from_state_list(struct se_cmd *cmd)
 	spin_unlock_irqrestore(&dev->queues[cmd->cpuid].lock, flags);
 }
 
+static void target_remove_from_tmr_list(struct se_cmd *cmd)
+{
+	struct se_device *dev = NULL;
+	unsigned long flags;
+
+	if (cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
+		dev = cmd->se_tmr_req->tmr_dev;
+
+	if (dev) {
+		spin_lock_irqsave(&dev->se_tmr_lock, flags);
+		if (cmd->se_tmr_req->tmr_dev)
+			list_del_init(&cmd->se_tmr_req->tmr_list);
+		spin_unlock_irqrestore(&dev->se_tmr_lock, flags);
+	}
+}
 /*
  * This function is called by the target core after the target core has
  * finished processing a SCSI command or SCSI TMF. Both the regular command
@@ -687,13 +702,6 @@ static int transport_cmd_check_stop_to_fabric(struct se_cmd *cmd)
 {
 	unsigned long flags;
 
-	target_remove_from_state_list(cmd);
-
-	/*
-	 * Clear struct se_cmd->se_lun before the handoff to FE.
-	 */
-	cmd->se_lun = NULL;
-
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	/*
 	 * Determine if frontend context caller is requesting the stopping of
@@ -728,8 +736,16 @@ static void transport_lun_remove_cmd(struct se_cmd *cmd)
 	if (!lun)
 		return;
 
+	target_remove_from_state_list(cmd);
+	target_remove_from_tmr_list(cmd);
+
 	if (cmpxchg(&cmd->lun_ref_active, true, false))
 		percpu_ref_put(&lun->lun_ref);
+
+	/*
+	 * Clear struct se_cmd->se_lun before the handoff to FE.
+	 */
+	cmd->se_lun = NULL;
 }
 
 static void target_complete_failure_work(struct work_struct *work)
-- 
2.33.0



