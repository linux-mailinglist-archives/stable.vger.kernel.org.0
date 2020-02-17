Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 491C0161B40
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 20:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729555AbgBQTJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 14:09:31 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41801 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728448AbgBQTJa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 14:09:30 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id DB174210D8;
        Mon, 17 Feb 2020 14:09:29 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 17 Feb 2020 14:09:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=K70hPq
        6hdpwRBM/HYVFgvdJXObCCkwtI0vhX0oLgtzA=; b=UlF6XbQvDZrzMoKaI0jVKI
        H39Wy7EZqpV5ZLowGuMKTZUuPDWP/2TAyy4aPMCl1WEaUdb7fZczHuK/LvbBS8Fm
        W/WvK5RbRjKMveVX7xvs8KTpM05o5WRgxdJPlz38gBE1u0NF7I/9lMMQxpQoDE9L
        P8ShpXuco3FX1ginggistaEC/qjrXJVS0wbLAzMowpZApNmZBy+q2NNRaP8aRYcf
        I+yKBs8dTpa2eBdIp0Gw68844TAvhnu3TDAg4H3UaWfCLBwEIRlkf8e5WAKn2HRW
        MlJZYVUMxnhdBhhTJ8zASLGWtfUoAYk9ISI5w8j/9b/1IvA0fR3v+kmu1K5dedrA
        ==
X-ME-Sender: <xms:6eRKXp_nCHLMwT5BxdAzlabhanxliAjF9KJzf99xoLD8A9FxXyiedg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedvne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:6eRKXh9unJe-6vpbxxlXEaw9VkXuvMcqWuhhsYLMPVKf0QtS6-N35A>
    <xmx:6eRKXiCqyUD5JpnlARmE1Y1kWM24MfGA17iIPR4gFr9FxAW7Kpt-7g>
    <xmx:6eRKXhw5NWmX_nyaMP79OEjGwo3O6g4FMsV7NV_mPkkRrkWB59hLpA>
    <xmx:6eRKXtv_8JgPPqivrp0b7LWbdI6jmI6_690ZPUD2dLG8zdP1x3AeSQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 724DD3280060;
        Mon, 17 Feb 2020 14:09:29 -0500 (EST)
Subject: FAILED: patch "[PATCH] Btrfs: fix race between shrinking truncate and fiemap" failed to apply to 4.19-stable tree
To:     fdmanana@suse.com, dsterba@suse.com, josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Feb 2020 20:09:27 +0100
Message-ID: <158196656712413@kroah.com>
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

From 28553fa992cb28be6a65566681aac6cafabb4f2d Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Fri, 7 Feb 2020 12:23:09 +0000
Subject: [PATCH] Btrfs: fix race between shrinking truncate and fiemap

When there is a fiemap executing in parallel with a shrinking truncate
we can end up in a situation where we have extent maps for which we no
longer have corresponding file extent items. This is generally harmless
and at the moment the only consequences are missing file extent items
representing holes after we expand the file size again after the
truncate operation removed the prealloc extent items, and stale
information for future fiemap calls (reporting extents that no longer
exist or may have been reallocated to other files for example).

Consider the following example:

1) Our inode has a size of 128KiB, one 128KiB extent at file offset 0
   and a 1MiB prealloc extent at file offset 128KiB;

2) Task A starts doing a shrinking truncate of our inode to reduce it to
   a size of 64KiB. Before it searches the subvolume tree for file
   extent items to delete, it drops all the extent maps in the range
   from 64KiB to (u64)-1 by calling btrfs_drop_extent_cache();

3) Task B starts doing a fiemap against our inode. When looking up for
   the inode's extent maps in the range from 128KiB to (u64)-1, it
   doesn't find any in the inode's extent map tree, since they were
   removed by task A.  Because it didn't find any in the extent map
   tree, it scans the inode's subvolume tree for file extent items, and
   it finds the 1MiB prealloc extent at file offset 128KiB, then it
   creates an extent map based on that file extent item and adds it to
   inode's extent map tree (this ends up being done by
   btrfs_get_extent() <- btrfs_get_extent_fiemap() <-
   get_extent_skip_holes());

4) Task A then drops the prealloc extent at file offset 128KiB and
   shrinks the 128KiB extent file offset 0 to a length of 64KiB. The
   truncation operation finishes and we end up with an extent map
   representing a 1MiB prealloc extent at file offset 128KiB, despite we
   don't have any more that extent;

After this the two types of problems we have are:

1) Future calls to fiemap always report that a 1MiB prealloc extent
   exists at file offset 128KiB. This is stale information, no longer
   correct;

2) If the size of the file is increased, by a truncate operation that
   increases the file size or by a write into a file offset > 64KiB for
   example, we end up not inserting file extent items to represent holes
   for any range between 128KiB and 128KiB + 1MiB, since the hole
   expansion function, btrfs_cont_expand() will skip hole insertion for
   any range for which an extent map exists that represents a prealloc
   extent. This causes fsck to complain about missing file extent items
   when not using the NO_HOLES feature.

The second issue could be often triggered by test case generic/561 from
fstests, which runs fsstress and duperemove in parallel, and duperemove
does frequent fiemap calls.

Essentially the problems happens because fiemap does not acquire the
inode's lock while truncate does, and fiemap locks the file range in the
inode's iotree while truncate does not. So fix the issue by making
btrfs_truncate_inode_items() lock the file range from the new file size
to (u64)-1, so that it serializes with fiemap.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5b3ec93ff911..7d26b4bfb2c6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4085,6 +4085,8 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	u64 bytes_deleted = 0;
 	bool be_nice = false;
 	bool should_throttle = false;
+	const u64 lock_start = ALIGN_DOWN(new_size, fs_info->sectorsize);
+	struct extent_state *cached_state = NULL;
 
 	BUG_ON(new_size > 0 && min_type != BTRFS_EXTENT_DATA_KEY);
 
@@ -4101,6 +4103,9 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 	path->reada = READA_BACK;
 
+	lock_extent_bits(&BTRFS_I(inode)->io_tree, lock_start, (u64)-1,
+			 &cached_state);
+
 	/*
 	 * We want to drop from the next block forward in case this new size is
 	 * not block aligned since we will be keeping the last block of the
@@ -4367,6 +4372,9 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 		btrfs_ordered_update_i_size(inode, last_size, NULL);
 	}
 
+	unlock_extent_cached(&BTRFS_I(inode)->io_tree, lock_start, (u64)-1,
+			     &cached_state);
+
 	btrfs_free_path(path);
 	return ret;
 }

