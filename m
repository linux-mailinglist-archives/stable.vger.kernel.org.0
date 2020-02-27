Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0981713FD
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 10:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbgB0JTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 04:19:46 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:53401 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728504AbgB0JTq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 04:19:46 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 40F7A687;
        Thu, 27 Feb 2020 04:19:45 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 27 Feb 2020 04:19:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Th+E6Z
        X+wRkqVmHvD6Nflgqa2oziuZ8PTlLB7tnBmfs=; b=XxsGF3qQ2aMknNzWbJRktR
        tYarw4r84CePW/fWKnHdft65xMMrHn76hdlvhsuG9R/wYk4x/UB3q7GndW/9tvjl
        9nkwZTgXp97jyZ172aix9WBV6/0QtdWYaM/mtHWmI/PsoR+jcl0SxaUea8OxcLv6
        0HESHOSaXidU6fVJ1JcW3Uw1Gh3mUwVZfukWZc8ga7JkOjTT0cXmr3KARGE9q2sN
        prL+KqUApMzuqJ/F89f3oXI+QCIqee/7bXbv42SWdV8TTSKILbWZCsRJafffvRIi
        xGsoIKzgVuHfow8SQayO25QbbcyKw0m57ebtD1JeMIMKROLIVkIxY/ojySvxp0iw
        ==
X-ME-Sender: <xms:sIlXXlXoe_1q5vgGZVmmlAkaFPZZcZLvC4ratXHwuRMANBDPsXayUA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeigddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepuddvne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:sIlXXqnn_2opfhupdJmfWldhcXVgK8aIO_mtGP6tSiidMJRE448KeA>
    <xmx:sIlXXiRAULLgmZ_rgKyXZBhsF0KSdPZur5NuA777oYSb_c0hYVl5Ew>
    <xmx:sIlXXuHquTMfip-2SbB9qSnOmXk3Wbs1kPWQ-zalLE91iXU0eloc7w>
    <xmx:sIlXXgcLYq0TsAWH09OK6Vho7hm51nsPD9oC25fUGtcKmo4LTUmVBA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7FA1D3060BD1;
        Thu, 27 Feb 2020 04:19:44 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: don't set path->leave_spinning for truncate" failed to apply to 4.9-stable tree
To:     josef@toxicpanda.com, davej@codemonkey.org.uk, dsterba@suse.com,
        fdmanana@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 Feb 2020 10:19:42 +0100
Message-ID: <158279518279125@kroah.com>
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

From 52e29e331070cd7d52a64cbf1b0958212a340e28 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 17 Jan 2020 09:02:20 -0500
Subject: [PATCH] btrfs: don't set path->leave_spinning for truncate

The only time we actually leave the path spinning is if we're truncating
a small amount and don't actually free an extent, which is not a common
occurrence.  We have to set the path blocking in order to add the
delayed ref anyway, so the first extent we find we set the path to
blocking and stay blocking for the duration of the operation.  With the
upcoming file extent map stuff there will be another case that we have
to have the path blocking, so just swap to blocking always.

Note: this patch also fixes a warning after 28553fa992cb ("Btrfs: fix
race between shrinking truncate and fiemap") got merged that inserts
extent locks around truncation so the path must not leave spinning locks
after btrfs_search_slot.

  [70.794783] BUG: sleeping function called from invalid context at mm/slab.h:565
  [70.794834] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1141, name: rsync
  [70.794863] 5 locks held by rsync/1141:
  [70.794876]  #0: ffff888417b9c408 (sb_writers#17){.+.+}, at: mnt_want_write+0x20/0x50
  [70.795030]  #1: ffff888428de28e8 (&type->i_mutex_dir_key#13/1){+.+.}, at: lock_rename+0xf1/0x100
  [70.795051]  #2: ffff888417b9c608 (sb_internal#2){.+.+}, at: start_transaction+0x394/0x560
  [70.795124]  #3: ffff888403081768 (btrfs-fs-01){++++}, at: btrfs_try_tree_write_lock+0x2f/0x160
  [70.795203]  #4: ffff888403086568 (btrfs-fs-00){++++}, at: btrfs_try_tree_write_lock+0x2f/0x160
  [70.795222] CPU: 5 PID: 1141 Comm: rsync Not tainted 5.6.0-rc2-backup+ #2
  [70.795362] Call Trace:
  [70.795374]  dump_stack+0x71/0xa0
  [70.795445]  ___might_sleep.part.96.cold.106+0xa6/0xb6
  [70.795459]  kmem_cache_alloc+0x1d3/0x290
  [70.795471]  alloc_extent_state+0x22/0x1c0
  [70.795544]  __clear_extent_bit+0x3ba/0x580
  [70.795557]  ? _raw_spin_unlock_irq+0x24/0x30
  [70.795569]  btrfs_truncate_inode_items+0x339/0xe50
  [70.795647]  btrfs_evict_inode+0x269/0x540
  [70.795659]  ? dput.part.38+0x29/0x460
  [70.795671]  evict+0xcd/0x190
  [70.795682]  __dentry_kill+0xd6/0x180
  [70.795754]  dput.part.38+0x2ad/0x460
  [70.795765]  do_renameat2+0x3cb/0x540
  [70.795777]  __x64_sys_rename+0x1c/0x20

Reported-by: Dave Jones <davej@codemonkey.org.uk>
Fixes: 28553fa992cb ("Btrfs: fix race between shrinking truncate and fiemap")
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add note ]
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7d26b4bfb2c6..36deef69f847 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4142,7 +4142,6 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	path->leave_spinning = 1;
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
 	if (ret < 0)
 		goto out;
@@ -4294,7 +4293,6 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 		     root == fs_info->tree_root)) {
 			struct btrfs_ref ref = { 0 };
 
-			btrfs_set_path_blocking(path);
 			bytes_deleted += extent_num_bytes;
 
 			btrfs_init_generic_ref(&ref, BTRFS_DROP_DELAYED_REF,

