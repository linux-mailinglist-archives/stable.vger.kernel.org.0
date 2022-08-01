Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A847958693F
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbiHAL7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbiHAL7Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:59:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D334B4B2;
        Mon,  1 Aug 2022 04:52:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9F0B612D0;
        Mon,  1 Aug 2022 11:52:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9E1C433C1;
        Mon,  1 Aug 2022 11:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354757;
        bh=2GgHoR7USiJJkgyuus9H81Rz/A15wlVLazyS1MogrRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A21ssDrc9vW3BE9WcamgGe6R7e7/co5Xo0DIJV9sVTeHFGl0AhMHI9cJlDkVceHQw
         kA/6fm7WeuFyZaiAty3D7+fTBcd0YSlrd3PiJCNNuUoIYuO0q80ivaQ5M0iut0R+L4
         mPAfjHkFcBIMjbx7jfO68sYU7JR88uIGBy+yqLBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junxiao Bi <junxiao.bi@oracle.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>, heming.zhao@suse.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 02/69] Revert "ocfs2: mount shared volume without ha stack"
Date:   Mon,  1 Aug 2022 13:46:26 +0200
Message-Id: <20220801114134.567093202@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
References: <20220801114134.468284027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junxiao Bi <ocfs2-devel@oss.oracle.com>

commit c80af0c250c8f8a3c978aa5aafbe9c39b336b813 upstream.

This reverts commit 912f655d78c5d4ad05eac287f23a435924df7144.

This commit introduced a regression that can cause mount hung.  The
changes in __ocfs2_find_empty_slot causes that any node with none-zero
node number can grab the slot that was already taken by node 0, so node 1
will access the same journal with node 0, when it try to grab journal
cluster lock, it will hung because it was already acquired by node 0.
It's very easy to reproduce this, in one cluster, mount node 0 first, then
node 1, you will see the following call trace from node 1.

[13148.735424] INFO: task mount.ocfs2:53045 blocked for more than 122 seconds.
[13148.739691]       Not tainted 5.15.0-2148.0.4.el8uek.mountracev2.x86_64 #2
[13148.742560] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[13148.745846] task:mount.ocfs2     state:D stack:    0 pid:53045 ppid: 53044 flags:0x00004000
[13148.749354] Call Trace:
[13148.750718]  <TASK>
[13148.752019]  ? usleep_range+0x90/0x89
[13148.753882]  __schedule+0x210/0x567
[13148.755684]  schedule+0x44/0xa8
[13148.757270]  schedule_timeout+0x106/0x13c
[13148.759273]  ? __prepare_to_swait+0x53/0x78
[13148.761218]  __wait_for_common+0xae/0x163
[13148.763144]  __ocfs2_cluster_lock.constprop.0+0x1d6/0x870 [ocfs2]
[13148.765780]  ? ocfs2_inode_lock_full_nested+0x18d/0x398 [ocfs2]
[13148.768312]  ocfs2_inode_lock_full_nested+0x18d/0x398 [ocfs2]
[13148.770968]  ocfs2_journal_init+0x91/0x340 [ocfs2]
[13148.773202]  ocfs2_check_volume+0x39/0x461 [ocfs2]
[13148.775401]  ? iput+0x69/0xba
[13148.777047]  ocfs2_mount_volume.isra.0.cold+0x40/0x1f5 [ocfs2]
[13148.779646]  ocfs2_fill_super+0x54b/0x853 [ocfs2]
[13148.781756]  mount_bdev+0x190/0x1b7
[13148.783443]  ? ocfs2_remount+0x440/0x440 [ocfs2]
[13148.785634]  legacy_get_tree+0x27/0x48
[13148.787466]  vfs_get_tree+0x25/0xd0
[13148.789270]  do_new_mount+0x18c/0x2d9
[13148.791046]  __x64_sys_mount+0x10e/0x142
[13148.792911]  do_syscall_64+0x3b/0x89
[13148.794667]  entry_SYSCALL_64_after_hwframe+0x170/0x0
[13148.797051] RIP: 0033:0x7f2309f6e26e
[13148.798784] RSP: 002b:00007ffdcee7d408 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
[13148.801974] RAX: ffffffffffffffda RBX: 00007ffdcee7d4a0 RCX: 00007f2309f6e26e
[13148.804815] RDX: 0000559aa762a8ae RSI: 0000559aa939d340 RDI: 0000559aa93a22b0
[13148.807719] RBP: 00007ffdcee7d5b0 R08: 0000559aa93a2290 R09: 00007f230a0b4820
[13148.810659] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffdcee7d420
[13148.813609] R13: 0000000000000000 R14: 0000559aa939f000 R15: 0000000000000000
[13148.816564]  </TASK>

To fix it, we can just fix __ocfs2_find_empty_slot.  But original commit
introduced the feature to mount ocfs2 locally even it is cluster based,
that is a very dangerous, it can easily cause serious data corruption,
there is no way to stop other nodes mounting the fs and corrupting it.
Setup ha or other cluster-aware stack is just the cost that we have to
take for avoiding corruption, otherwise we have to do it in kernel.

Link: https://lkml.kernel.org/r/20220603222801.42488-1-junxiao.bi@oracle.com
Fixes: 912f655d78c5("ocfs2: mount shared volume without ha stack")
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/ocfs2.h    |    4 +---
 fs/ocfs2/slot_map.c |   46 +++++++++++++++++++---------------------------
 fs/ocfs2/super.c    |   21 ---------------------
 3 files changed, 20 insertions(+), 51 deletions(-)

--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -277,7 +277,6 @@ enum ocfs2_mount_options
 	OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT = 1 << 15,  /* Journal Async Commit */
 	OCFS2_MOUNT_ERRORS_CONT = 1 << 16, /* Return EIO to the calling process on error */
 	OCFS2_MOUNT_ERRORS_ROFS = 1 << 17, /* Change filesystem to read-only on error */
-	OCFS2_MOUNT_NOCLUSTER = 1 << 18, /* No cluster aware filesystem mount */
 };
 
 #define OCFS2_OSB_SOFT_RO	0x0001
@@ -673,8 +672,7 @@ static inline int ocfs2_cluster_o2cb_glo
 
 static inline int ocfs2_mount_local(struct ocfs2_super *osb)
 {
-	return ((osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_LOCAL_MOUNT)
-		|| (osb->s_mount_opt & OCFS2_MOUNT_NOCLUSTER));
+	return (osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_LOCAL_MOUNT);
 }
 
 static inline int ocfs2_uses_extended_slot_map(struct ocfs2_super *osb)
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -252,16 +252,14 @@ static int __ocfs2_find_empty_slot(struc
 	int i, ret = -ENOSPC;
 
 	if ((preferred >= 0) && (preferred < si->si_num_slots)) {
-		if (!si->si_slots[preferred].sl_valid ||
-		    !si->si_slots[preferred].sl_node_num) {
+		if (!si->si_slots[preferred].sl_valid) {
 			ret = preferred;
 			goto out;
 		}
 	}
 
 	for(i = 0; i < si->si_num_slots; i++) {
-		if (!si->si_slots[i].sl_valid ||
-		    !si->si_slots[i].sl_node_num) {
+		if (!si->si_slots[i].sl_valid) {
 			ret = i;
 			break;
 		}
@@ -456,30 +454,24 @@ int ocfs2_find_slot(struct ocfs2_super *
 	spin_lock(&osb->osb_lock);
 	ocfs2_update_slot_info(si);
 
-	if (ocfs2_mount_local(osb))
-		/* use slot 0 directly in local mode */
-		slot = 0;
-	else {
-		/* search for ourselves first and take the slot if it already
-		 * exists. Perhaps we need to mark this in a variable for our
-		 * own journal recovery? Possibly not, though we certainly
-		 * need to warn to the user */
-		slot = __ocfs2_node_num_to_slot(si, osb->node_num);
+	/* search for ourselves first and take the slot if it already
+	 * exists. Perhaps we need to mark this in a variable for our
+	 * own journal recovery? Possibly not, though we certainly
+	 * need to warn to the user */
+	slot = __ocfs2_node_num_to_slot(si, osb->node_num);
+	if (slot < 0) {
+		/* if no slot yet, then just take 1st available
+		 * one. */
+		slot = __ocfs2_find_empty_slot(si, osb->preferred_slot);
 		if (slot < 0) {
-			/* if no slot yet, then just take 1st available
-			 * one. */
-			slot = __ocfs2_find_empty_slot(si, osb->preferred_slot);
-			if (slot < 0) {
-				spin_unlock(&osb->osb_lock);
-				mlog(ML_ERROR, "no free slots available!\n");
-				status = -EINVAL;
-				goto bail;
-			}
-		} else
-			printk(KERN_INFO "ocfs2: Slot %d on device (%s) was "
-			       "already allocated to this node!\n",
-			       slot, osb->dev_str);
-	}
+			spin_unlock(&osb->osb_lock);
+			mlog(ML_ERROR, "no free slots available!\n");
+			status = -EINVAL;
+			goto bail;
+		}
+	} else
+		printk(KERN_INFO "ocfs2: Slot %d on device (%s) was already "
+		       "allocated to this node!\n", slot, osb->dev_str);
 
 	ocfs2_set_slot(si, slot, osb->node_num);
 	osb->slot_num = slot;
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -173,7 +173,6 @@ enum {
 	Opt_dir_resv_level,
 	Opt_journal_async_commit,
 	Opt_err_cont,
-	Opt_nocluster,
 	Opt_err,
 };
 
@@ -207,7 +206,6 @@ static const match_table_t tokens = {
 	{Opt_dir_resv_level, "dir_resv_level=%u"},
 	{Opt_journal_async_commit, "journal_async_commit"},
 	{Opt_err_cont, "errors=continue"},
-	{Opt_nocluster, "nocluster"},
 	{Opt_err, NULL}
 };
 
@@ -619,13 +617,6 @@ static int ocfs2_remount(struct super_bl
 		goto out;
 	}
 
-	tmp = OCFS2_MOUNT_NOCLUSTER;
-	if ((osb->s_mount_opt & tmp) != (parsed_options.mount_opt & tmp)) {
-		ret = -EINVAL;
-		mlog(ML_ERROR, "Cannot change nocluster option on remount\n");
-		goto out;
-	}
-
 	tmp = OCFS2_MOUNT_HB_LOCAL | OCFS2_MOUNT_HB_GLOBAL |
 		OCFS2_MOUNT_HB_NONE;
 	if ((osb->s_mount_opt & tmp) != (parsed_options.mount_opt & tmp)) {
@@ -866,7 +857,6 @@ static int ocfs2_verify_userspace_stack(
 	}
 
 	if (ocfs2_userspace_stack(osb) &&
-	    !(osb->s_mount_opt & OCFS2_MOUNT_NOCLUSTER) &&
 	    strncmp(osb->osb_cluster_stack, mopt->cluster_stack,
 		    OCFS2_STACK_LABEL_LEN)) {
 		mlog(ML_ERROR,
@@ -1145,11 +1135,6 @@ static int ocfs2_fill_super(struct super
 	       osb->s_mount_opt & OCFS2_MOUNT_DATA_WRITEBACK ? "writeback" :
 	       "ordered");
 
-	if ((osb->s_mount_opt & OCFS2_MOUNT_NOCLUSTER) &&
-	   !(osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_LOCAL_MOUNT))
-		printk(KERN_NOTICE "ocfs2: The shared device (%s) is mounted "
-		       "without cluster aware mode.\n", osb->dev_str);
-
 	atomic_set(&osb->vol_state, VOLUME_MOUNTED);
 	wake_up(&osb->osb_mount_event);
 
@@ -1456,9 +1441,6 @@ static int ocfs2_parse_options(struct su
 		case Opt_journal_async_commit:
 			mopt->mount_opt |= OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT;
 			break;
-		case Opt_nocluster:
-			mopt->mount_opt |= OCFS2_MOUNT_NOCLUSTER;
-			break;
 		default:
 			mlog(ML_ERROR,
 			     "Unrecognized mount option \"%s\" "
@@ -1570,9 +1552,6 @@ static int ocfs2_show_options(struct seq
 	if (opts & OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT)
 		seq_printf(s, ",journal_async_commit");
 
-	if (opts & OCFS2_MOUNT_NOCLUSTER)
-		seq_printf(s, ",nocluster");
-
 	return 0;
 }
 


