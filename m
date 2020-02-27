Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9FE31713FB
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 10:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgB0JTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 04:19:43 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:39143 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728504AbgB0JTn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 04:19:43 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 06D15777;
        Thu, 27 Feb 2020 04:19:41 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 27 Feb 2020 04:19:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=nLGQn0
        NcbtWZ/W7k3n8TYAXy3Os9kuyX8f0jpQu37bw=; b=UiPNYLFoVP5w5U6UIUluyZ
        f8+QIZIkGmTMcetMOxsj0P37/F/CzbfE1IXtCTMx94OTQdXgEZtp8xAOOxJ90P26
        wW78ZK2yxbCvVWtWpADY+Oj2vffS+yzJN70r6CpG2DYTR8grrsBlmRDpWlXmaMkQ
        t+SfQExsJ6aGDUxdlmP6XKgdmEewSA7/wCO4V2+tXot2t4C7LmY5bDZd7J0yv9a8
        IuNQeqKZUh0rrA+XuCjKdVJt2rsh4Kn4CJInOi85X2S7TNnNvvnjTPpgS4OzaZS6
        U7Yb1FKCJ0F/j6zVE59xAlLr2B/OnoBC38AYieYvFInnFfVBSUg4jWD5ugHHLKKQ
        ==
X-ME-Sender: <xms:rYlXXkHfszD7Y-8NMhBzkz5hv4FxoIkezx3WCBZZbLU0pfHGwRMuhw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeigddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepuddune
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:rYlXXhlqOyYy6zBRbNWM-JX5eZ7L0Kdhz-DHww36ud2nIeAMRTjetg>
    <xmx:rYlXXpKPVee_NAgmZQAa9tM_8hrL1HCLflpaUa19B3DtkiznZB6mFQ>
    <xmx:rYlXXqZWAmR2S1y1dzQ07PhSsdQI4eFRxuKJy88f1HFq11jJncR0Rg>
    <xmx:rYlXXmU_mVVkperR6jBSqbxbJpJXqpPsS4bxd-HHvisyhTwmBTMN1Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3DF4430610E8;
        Thu, 27 Feb 2020 04:19:41 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: don't set path->leave_spinning for truncate" failed to apply to 4.19-stable tree
To:     josef@toxicpanda.com, davej@codemonkey.org.uk, dsterba@suse.com,
        fdmanana@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 Feb 2020 10:19:40 +0100
Message-ID: <15827951808020@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

