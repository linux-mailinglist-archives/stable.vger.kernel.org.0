Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE7D21A6E
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 17:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729221AbfEQPST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 11:18:19 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:35687 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729202AbfEQPST (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 11:18:19 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id DE945469;
        Fri, 17 May 2019 11:18:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 17 May 2019 11:18:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=p8PNZD
        N8X8lMs+jh5w7hksmxNRZFGIHyvW/5Nv/1+DY=; b=RgE3Qezybryr4aWDrdPt6L
        SXdPQp8Pcw9yv7jgXICPuwk/yqTbEh1zaFHg9bMdqAT6Aym87mYXdpqkPji/Hh3z
        KmokZXtLMWOvsS2wsxAa8BWpSRcAhYQnRGHPjBuFy+Ols6ugHq9mcCYdnegDMS3l
        4aJDGq95pCXXwThuOMcHuPFdhkyaJsa6ePXvwg7xGmERbq4ZTqzm+VtrhmqiUCH5
        cXVh60yRaG/IBhc9bm7xVSLcr7akhvAiJLG8g+WJJoYdIPaEHAYrnTX0ZKQNhCuC
        bYLjgqFEc34FO+aTaOX0HbyS6xMIN4qteP6GTKm1lTeD/+bd5tcg4K/2yq58rokg
        ==
X-ME-Sender: <xms:udDeXAeQTD5Mekih4gnJ0t_kI-JgGj0jkhPzN0vhUHCo1wL5RIjWZw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpqhgvmhhuqdhprhhojhgvtghtrd
    horhhgnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhho
    mhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:udDeXMfVZMSWatH1CjQRX8fPdj992HsS5YAU5WySWYr11xXfL_fuTA>
    <xmx:udDeXAd8uNl-w7RN9wbkrIjEAWgSetCJefHDnKjtz6D9P7n3cumQVQ>
    <xmx:udDeXNk3rvlTvoXkV53I-siV2sztlq12tgsnqEjaFdigPmdhCuE2_w>
    <xmx:udDeXEp6nAlqHqcECmA00sJKCHKbaftZT_6-v29wCHflvCbpQ0_hAw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 449A5103D8;
        Fri, 17 May 2019 11:18:16 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Btrfs: fix race between send and deduplication that lead to" failed to apply to 4.9-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 17:18:14 +0200
Message-ID: <155810629417235@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 62d54f3a7fa27ef6a74d6cdf643ce04beba3afa7 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Mon, 22 Apr 2019 16:43:42 +0100
Subject: [PATCH] Btrfs: fix race between send and deduplication that lead to
 failures and crashes

Send operates on read only trees and expects them to never change while it
is using them. This is part of its initial design, and this expection is
due to two different reasons:

1) When it was introduced, no operations were allowed to modifiy read-only
   subvolumes/snapshots (including defrag for example).

2) It keeps send from having an impact on other filesystem operations.
   Namely send does not need to keep locks on the trees nor needs to hold on
   to transaction handles and delay transaction commits. This ends up being
   a consequence of the former reason.

However the deduplication feature was introduced later (on September 2013,
while send was introduced in July 2012) and it allowed for deduplication
with destination files that belong to read-only trees (subvolumes and
snapshots).

That means that having a send operation (either full or incremental) running
in parallel with a deduplication that has the destination inode in one of
the trees used by the send operation, can result in tree nodes and leaves
getting freed and reused while send is using them. This problem is similar
to the problem solved for the root nodes getting freed and reused when a
snapshot is made against one tree that is currenly being used by a send
operation, fixed in commits [1] and [2]. These commits explain in detail
how the problem happens and the explanation is valid for any node or leaf
that is not the root of a tree as well. This problem was also discussed
and explained recently in a thread [3].

The problem is very easy to reproduce when using send with large trees
(snapshots) and just a few concurrent deduplication operations that target
files in the trees used by send. A stress test case is being sent for
fstests that triggers the issue easily. The most common error to hit is
the send ioctl return -EIO with the following messages in dmesg/syslog:

 [1631617.204075] BTRFS error (device sdc): did not find backref in send_root. inode=63292, offset=0, disk_byte=5228134400 found extent=5228134400
 [1631633.251754] BTRFS error (device sdc): parent transid verify failed on 32243712 wanted 24 found 27

The first one is very easy to hit while the second one happens much less
frequently, except for very large trees (in that test case, snapshots
with 100000 files having large xattrs to get deep and wide trees).
Less frequently, at least one BUG_ON can be hit:

 [1631742.130080] ------------[ cut here ]------------
 [1631742.130625] kernel BUG at fs/btrfs/ctree.c:1806!
 [1631742.131188] invalid opcode: 0000 [#6] SMP DEBUG_PAGEALLOC PTI
 [1631742.131726] CPU: 1 PID: 13394 Comm: btrfs Tainted: G    B D W         5.0.0-rc8-btrfs-next-45 #1
 [1631742.132265] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.2-0-gf9626ccb91-prebuilt.qemu-project.org 04/01/2014
 [1631742.133399] RIP: 0010:read_node_slot+0x122/0x130 [btrfs]
 (...)
 [1631742.135061] RSP: 0018:ffffb530021ebaa0 EFLAGS: 00010246
 [1631742.135615] RAX: ffff93ac8912e000 RBX: 000000000000009d RCX: 0000000000000002
 [1631742.136173] RDX: 000000000000009d RSI: ffff93ac564b0d08 RDI: ffff93ad5b48c000
 [1631742.136759] RBP: ffffb530021ebb7d R08: 0000000000000001 R09: ffffb530021ebb7d
 [1631742.137324] R10: ffffb530021eba70 R11: 0000000000000000 R12: ffff93ac87d0a708
 [1631742.137900] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000001
 [1631742.138455] FS:  00007f4cdb1528c0(0000) GS:ffff93ad76a80000(0000) knlGS:0000000000000000
 [1631742.139010] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 [1631742.139568] CR2: 00007f5acb3d0420 CR3: 000000012be3e006 CR4: 00000000003606e0
 [1631742.140131] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [1631742.140719] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 [1631742.141272] Call Trace:
 [1631742.141826]  ? do_raw_spin_unlock+0x49/0xc0
 [1631742.142390]  tree_advance+0x173/0x1d0 [btrfs]
 [1631742.142948]  btrfs_compare_trees+0x268/0x690 [btrfs]
 [1631742.143533]  ? process_extent+0x1070/0x1070 [btrfs]
 [1631742.144088]  btrfs_ioctl_send+0x1037/0x1270 [btrfs]
 [1631742.144645]  _btrfs_ioctl_send+0x80/0x110 [btrfs]
 [1631742.145161]  ? trace_sched_stick_numa+0xe0/0xe0
 [1631742.145685]  btrfs_ioctl+0x13fe/0x3120 [btrfs]
 [1631742.146179]  ? account_entity_enqueue+0xd3/0x100
 [1631742.146662]  ? reweight_entity+0x154/0x1a0
 [1631742.147135]  ? update_curr+0x20/0x2a0
 [1631742.147593]  ? check_preempt_wakeup+0x103/0x250
 [1631742.148053]  ? do_vfs_ioctl+0xa2/0x6f0
 [1631742.148510]  ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
 [1631742.148942]  do_vfs_ioctl+0xa2/0x6f0
 [1631742.149361]  ? __fget+0x113/0x200
 [1631742.149767]  ksys_ioctl+0x70/0x80
 [1631742.150159]  __x64_sys_ioctl+0x16/0x20
 [1631742.150543]  do_syscall_64+0x60/0x1b0
 [1631742.150931]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
 [1631742.151326] RIP: 0033:0x7f4cd9f5add7
 (...)
 [1631742.152509] RSP: 002b:00007ffe91017708 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
 [1631742.152892] RAX: ffffffffffffffda RBX: 0000000000000105 RCX: 00007f4cd9f5add7
 [1631742.153268] RDX: 00007ffe91017790 RSI: 0000000040489426 RDI: 0000000000000007
 [1631742.153633] RBP: 0000000000000007 R08: 00007f4cd9e79700 R09: 00007f4cd9e79700
 [1631742.153999] R10: 00007f4cd9e799d0 R11: 0000000000000202 R12: 0000000000000003
 [1631742.154365] R13: 0000555dfae53020 R14: 0000000000000000 R15: 0000000000000001
 (...)
 [1631742.156696] ---[ end trace 5dac9f96dcc3fd6b ]---

That BUG_ON happens because while send is using a node, that node is COWed
by a concurrent deduplication, gets freed and gets reused as a leaf (because
a transaction commit happened in between), so when it attempts to read a
slot from the extent buffer, at ctree.c:read_node_slot(), the extent buffer
contents were wiped out and it now matches a leaf (which can even belong to
some other tree now), hitting the BUG_ON(level == 0).

Fix this concurrency issue by not allowing send and deduplication to run
in parallel if both operate on the same readonly trees, returning EAGAIN
to user space and logging an exlicit warning in dmesg/syslog.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=be6821f82c3cc36e026f5afd10249988852b35ea
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6f2f0b394b54e2b159ef969a0b5274e9bbf82ff2
[3] https://lore.kernel.org/linux-btrfs/CAL3q7H7iqSEEyFaEtpRZw3cp613y+4k2Q8b4W7mweR3tZA05bQ@mail.gmail.com/

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b19c7d65fe7d..aeaadeebc1fd 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1340,6 +1340,12 @@ struct btrfs_root {
 	 * manipulation with the read-only status via SUBVOL_SETFLAGS
 	 */
 	int send_in_progress;
+	/*
+	 * Number of currently running deduplication operations that have a
+	 * destination inode belonging to this root. Protected by the lock
+	 * root_item_lock.
+	 */
+	int dedupe_in_progress;
 	struct btrfs_subvolume_writers *subv_writers;
 	atomic_t will_be_snapshotted;
 	atomic_t snapshot_force_cow;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 19b0ee4e2c70..7755b503b348 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3262,6 +3262,19 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 {
 	int ret;
 	u64 i, tail_len, chunk_count;
+	struct btrfs_root *root_dst = BTRFS_I(dst)->root;
+
+	spin_lock(&root_dst->root_item_lock);
+	if (root_dst->send_in_progress) {
+		btrfs_warn_rl(root_dst->fs_info,
+"cannot deduplicate to root %llu while send operations are using it (%d in progress)",
+			      root_dst->root_key.objectid,
+			      root_dst->send_in_progress);
+		spin_unlock(&root_dst->root_item_lock);
+		return -EAGAIN;
+	}
+	root_dst->dedupe_in_progress++;
+	spin_unlock(&root_dst->root_item_lock);
 
 	tail_len = olen % BTRFS_MAX_DEDUPE_LEN;
 	chunk_count = div_u64(olen, BTRFS_MAX_DEDUPE_LEN);
@@ -3270,7 +3283,7 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 		ret = btrfs_extent_same_range(src, loff, BTRFS_MAX_DEDUPE_LEN,
 					      dst, dst_loff);
 		if (ret)
-			return ret;
+			goto out;
 
 		loff += BTRFS_MAX_DEDUPE_LEN;
 		dst_loff += BTRFS_MAX_DEDUPE_LEN;
@@ -3279,6 +3292,10 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 	if (tail_len > 0)
 		ret = btrfs_extent_same_range(src, loff, tail_len, dst,
 					      dst_loff);
+out:
+	spin_lock(&root_dst->root_item_lock);
+	root_dst->dedupe_in_progress--;
+	spin_unlock(&root_dst->root_item_lock);
 
 	return ret;
 }
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 12363081f53b..dd38dfe174df 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6640,6 +6640,13 @@ static void btrfs_root_dec_send_in_progress(struct btrfs_root* root)
 	spin_unlock(&root->root_item_lock);
 }
 
+static void dedupe_in_progress_warn(const struct btrfs_root *root)
+{
+	btrfs_warn_rl(root->fs_info,
+"cannot use root %llu for send while deduplications on it are in progress (%d in progress)",
+		      root->root_key.objectid, root->dedupe_in_progress);
+}
+
 long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg)
 {
 	int ret = 0;
@@ -6663,6 +6670,11 @@ long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg)
 	 * making it RW. This also protects against deletion.
 	 */
 	spin_lock(&send_root->root_item_lock);
+	if (btrfs_root_readonly(send_root) && send_root->dedupe_in_progress) {
+		dedupe_in_progress_warn(send_root);
+		spin_unlock(&send_root->root_item_lock);
+		return -EAGAIN;
+	}
 	send_root->send_in_progress++;
 	spin_unlock(&send_root->root_item_lock);
 
@@ -6797,6 +6809,13 @@ long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg)
 				ret = -EPERM;
 				goto out;
 			}
+			if (clone_root->dedupe_in_progress) {
+				dedupe_in_progress_warn(clone_root);
+				spin_unlock(&clone_root->root_item_lock);
+				srcu_read_unlock(&fs_info->subvol_srcu, index);
+				ret = -EAGAIN;
+				goto out;
+			}
 			clone_root->send_in_progress++;
 			spin_unlock(&clone_root->root_item_lock);
 			srcu_read_unlock(&fs_info->subvol_srcu, index);
@@ -6831,6 +6850,13 @@ long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg)
 			ret = -EPERM;
 			goto out;
 		}
+		if (sctx->parent_root->dedupe_in_progress) {
+			dedupe_in_progress_warn(sctx->parent_root);
+			spin_unlock(&sctx->parent_root->root_item_lock);
+			srcu_read_unlock(&fs_info->subvol_srcu, index);
+			ret = -EAGAIN;
+			goto out;
+		}
 		spin_unlock(&sctx->parent_root->root_item_lock);
 
 		srcu_read_unlock(&fs_info->subvol_srcu, index);

