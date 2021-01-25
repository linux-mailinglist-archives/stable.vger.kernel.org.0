Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECCC304B01
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbhAZEws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:52:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:33594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726735AbhAYSre (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:47:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AF7F2083E;
        Mon, 25 Jan 2021 18:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600422;
        bh=Vvof8TKQ1Nn4JeGz28Yau7BIZFgMkv5SB03KEK9+cbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eF71IkglNK5NsSXdfshKwalh0XtBqRfCQ6FOq73s3YICpfm/HpXfxlBkRgveeEZhq
         Nl8nty50FVk8v7C3RqquyPdNS0rScH0065ziXHweoyXlbRUxyuVzW4BKuf3AyjeZDl
         4gCZl+LujOlwR7ubb/MN+QSNqCIBoywAjxyvVMr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bodo Stroesser <bostroesser@gmail.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 001/199] scsi: target: tcmu: Fix use-after-free of se_cmd->priv
Date:   Mon, 25 Jan 2021 19:37:03 +0100
Message-Id: <20210125183216.312892680@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

commit 780e1384687d6ecdee9ca789a1027610484ac8a2 upstream.

Commit a35129024e88 ("scsi: target: tcmu: Use priv pointer in se_cmd")
modified tcmu_free_cmd() to set NULL to priv pointer in se_cmd. However,
se_cmd can be already freed by work queue triggered in
target_complete_cmd(). This caused BUG KASAN use-after-free [1].

To fix the bug, do not touch priv pointer in tcmu_free_cmd(). Instead, set
NULL to priv pointer before target_complete_cmd() calls. Also, to avoid
unnecessary priv pointer change in tcmu_queue_cmd(), modify priv pointer in
the function only when tcmu_free_cmd() is not called.

[1]
BUG: KASAN: use-after-free in tcmu_handle_completions+0x1172/0x1770 [target_core_user]
Write of size 8 at addr ffff88814cf79a40 by task cmdproc-uio0/14842

CPU: 2 PID: 14842 Comm: cmdproc-uio0 Not tainted 5.11.0-rc2 #1
Hardware name: Supermicro Super Server/X10SRL-F, BIOS 3.2 11/22/2019
Call Trace:
 dump_stack+0x9a/0xcc
 ? tcmu_handle_completions+0x1172/0x1770 [target_core_user]
 print_address_description.constprop.0+0x18/0x130
 ? tcmu_handle_completions+0x1172/0x1770 [target_core_user]
 ? tcmu_handle_completions+0x1172/0x1770 [target_core_user]
 kasan_report.cold+0x7f/0x10e
 ? tcmu_handle_completions+0x1172/0x1770 [target_core_user]
 tcmu_handle_completions+0x1172/0x1770 [target_core_user]
 ? queue_tmr_ring+0x5d0/0x5d0 [target_core_user]
 tcmu_irqcontrol+0x28/0x60 [target_core_user]
 uio_write+0x155/0x230
 ? uio_vma_fault+0x460/0x460
 ? security_file_permission+0x4f/0x440
 vfs_write+0x1ce/0x860
 ksys_write+0xe9/0x1b0
 ? __ia32_sys_read+0xb0/0xb0
 ? syscall_enter_from_user_mode+0x27/0x70
 ? trace_hardirqs_on+0x1c/0x110
 do_syscall_64+0x33/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fcf8b61905f
Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 b9 fc ff ff 48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 44 24 08 e8 0c fd ff ff 48
RSP: 002b:00007fcf7b3e6c30 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fcf8b61905f
RDX: 0000000000000004 RSI: 00007fcf7b3e6c78 RDI: 000000000000000c
RBP: 00007fcf7b3e6c80 R08: 0000000000000000 R09: 00007fcf7b3e6aa8
R10: 000000000b01c000 R11: 0000000000000293 R12: 00007ffe0c32a52e
R13: 00007ffe0c32a52f R14: 0000000000000000 R15: 00007fcf7b3e7640

Allocated by task 383:
 kasan_save_stack+0x1b/0x40
 ____kasan_kmalloc.constprop.0+0x84/0xa0
 kmem_cache_alloc+0x142/0x330
 tcm_loop_queuecommand+0x2a/0x4e0 [tcm_loop]
 scsi_queue_rq+0x12ec/0x2d20
 blk_mq_dispatch_rq_list+0x30a/0x1db0
 __blk_mq_do_dispatch_sched+0x326/0x830
 __blk_mq_sched_dispatch_requests+0x2c8/0x3f0
 blk_mq_sched_dispatch_requests+0xca/0x120
 __blk_mq_run_hw_queue+0x93/0xe0
 process_one_work+0x7b6/0x1290
 worker_thread+0x590/0xf80
 kthread+0x362/0x430
 ret_from_fork+0x22/0x30

Freed by task 11655:
 kasan_save_stack+0x1b/0x40
 kasan_set_track+0x1c/0x30
 kasan_set_free_info+0x20/0x30
 ____kasan_slab_free+0xec/0x120
 slab_free_freelist_hook+0x53/0x160
 kmem_cache_free+0xf4/0x5c0
 target_release_cmd_kref+0x3ea/0x9e0 [target_core_mod]
 transport_generic_free_cmd+0x28b/0x2f0 [target_core_mod]
 target_complete_ok_work+0x250/0xac0 [target_core_mod]
 process_one_work+0x7b6/0x1290
 worker_thread+0x590/0xf80
 kthread+0x362/0x430
 ret_from_fork+0x22/0x30

Last potentially related work creation:
 kasan_save_stack+0x1b/0x40
 kasan_record_aux_stack+0xa3/0xb0
 insert_work+0x48/0x2e0
 __queue_work+0x4e8/0xdf0
 queue_work_on+0x78/0x80
 tcmu_handle_completions+0xad0/0x1770 [target_core_user]
 tcmu_irqcontrol+0x28/0x60 [target_core_user]
 uio_write+0x155/0x230
 vfs_write+0x1ce/0x860
 ksys_write+0xe9/0x1b0
 do_syscall_64+0x33/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Second to last potentially related work creation:
 kasan_save_stack+0x1b/0x40
 kasan_record_aux_stack+0xa3/0xb0
 insert_work+0x48/0x2e0
 __queue_work+0x4e8/0xdf0
 queue_work_on+0x78/0x80
 tcm_loop_queuecommand+0x1c3/0x4e0 [tcm_loop]
 scsi_queue_rq+0x12ec/0x2d20
 blk_mq_dispatch_rq_list+0x30a/0x1db0
 __blk_mq_do_dispatch_sched+0x326/0x830
 __blk_mq_sched_dispatch_requests+0x2c8/0x3f0
 blk_mq_sched_dispatch_requests+0xca/0x120
 __blk_mq_run_hw_queue+0x93/0xe0
 process_one_work+0x7b6/0x1290
 worker_thread+0x590/0xf80
 kthread+0x362/0x430
 ret_from_fork+0x22/0x30

The buggy address belongs to the object at ffff88814cf79800 which belongs
to the cache tcm_loop_cmd_cache of size 896.

Link: https://lore.kernel.org/r/20210113024508.1264992-1-shinichiro.kawasaki@wdc.com
Fixes: a35129024e88 ("scsi: target: tcmu: Use priv pointer in se_cmd")
Cc: stable@vger.kernel.org # v5.9+
Acked-by: Bodo Stroesser <bostroesser@gmail.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_user.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -562,8 +562,6 @@ tcmu_get_block_page(struct tcmu_dev *ude
 
 static inline void tcmu_free_cmd(struct tcmu_cmd *tcmu_cmd)
 {
-	if (tcmu_cmd->se_cmd)
-		tcmu_cmd->se_cmd->priv = NULL;
 	kfree(tcmu_cmd->dbi);
 	kmem_cache_free(tcmu_cmd_cache, tcmu_cmd);
 }
@@ -1188,11 +1186,12 @@ tcmu_queue_cmd(struct se_cmd *se_cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
 	mutex_lock(&udev->cmdr_lock);
-	se_cmd->priv = tcmu_cmd;
 	if (!(se_cmd->transport_state & CMD_T_ABORTED))
 		ret = queue_cmd_ring(tcmu_cmd, &scsi_ret);
 	if (ret < 0)
 		tcmu_free_cmd(tcmu_cmd);
+	else
+		se_cmd->priv = tcmu_cmd;
 	mutex_unlock(&udev->cmdr_lock);
 	return scsi_ret;
 }
@@ -1255,6 +1254,7 @@ tcmu_tmr_notify(struct se_device *se_dev
 
 		list_del_init(&cmd->queue_entry);
 		tcmu_free_cmd(cmd);
+		se_cmd->priv = NULL;
 		target_complete_cmd(se_cmd, SAM_STAT_TASK_ABORTED);
 		unqueued = true;
 	}
@@ -1346,6 +1346,7 @@ static void tcmu_handle_completion(struc
 	}
 
 done:
+	se_cmd->priv = NULL;
 	if (read_len_valid) {
 		pr_debug("read_len = %d\n", read_len);
 		target_complete_cmd_with_length(cmd->se_cmd,
@@ -1492,6 +1493,7 @@ static void tcmu_check_expired_queue_cmd
 	se_cmd = cmd->se_cmd;
 	tcmu_free_cmd(cmd);
 
+	se_cmd->priv = NULL;
 	target_complete_cmd(se_cmd, SAM_STAT_TASK_SET_FULL);
 }
 
@@ -1606,6 +1608,7 @@ static void run_qfull_queue(struct tcmu_
 			 * removed then LIO core will do the right thing and
 			 * fail the retry.
 			 */
+			tcmu_cmd->se_cmd->priv = NULL;
 			target_complete_cmd(tcmu_cmd->se_cmd, SAM_STAT_BUSY);
 			tcmu_free_cmd(tcmu_cmd);
 			continue;
@@ -1619,6 +1622,7 @@ static void run_qfull_queue(struct tcmu_
 			 * Ignore scsi_ret for now. target_complete_cmd
 			 * drops it.
 			 */
+			tcmu_cmd->se_cmd->priv = NULL;
 			target_complete_cmd(tcmu_cmd->se_cmd,
 					    SAM_STAT_CHECK_CONDITION);
 			tcmu_free_cmd(tcmu_cmd);
@@ -2226,6 +2230,7 @@ static void tcmu_reset_ring(struct tcmu_
 		if (!test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
 			WARN_ON(!cmd->se_cmd);
 			list_del_init(&cmd->queue_entry);
+			cmd->se_cmd->priv = NULL;
 			if (err_level == 1) {
 				/*
 				 * Userspace was not able to start the


