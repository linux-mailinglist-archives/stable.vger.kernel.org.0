Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A90878F56
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 17:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387963AbfG2Pcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 11:32:35 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48471 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387925AbfG2Pcf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 11:32:35 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id BAA3A22205;
        Mon, 29 Jul 2019 11:32:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 29 Jul 2019 11:32:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=2jOeKK
        xWrWd4iJa3zBwwCxBRJBpMwRTrHvsz619ERLA=; b=rsYivuTEkH/MQsLKSgzTtg
        19MtmGXvC0F9amSI088ivEgbfP+PgD0WQJKDwgI7i6t4t8N8G+xDw/uAakWgiPiq
        8QOYMXpxLEO866up6dtUGLKOfajkFXnNkl+rnVDbgMWY8TdNZh54HqIKpF0dtf3p
        eeLQriTVm/AZsdpUevOdgm2KsEty24By506DsCY8/kij4bCwwavRyOhj1v7JwXa4
        k4dcDTYRo5nJpydd/+a5iutRrI3tqfTjWZnaQ5iGTb9PFYkl2U/lL/RAUyihA9m/
        Qo+Ydyxoous/TNOHND2GXjkAAoAeHU6WQPEFLoHR8IUGAXIaVRhblGxUtu4mJ51w
        ==
X-ME-Sender: <xms:kRE_XZ-ZZ3mOZzZdbbSVs3XueaIdfTfarGU-jxUcNWoeDon5L9PVrw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrledugdeltdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:kRE_Xc5dgBULeEMYnD0kkoZOQVWhlcKA_qXyHiCO-YQJTyPKAvER0A>
    <xmx:kRE_XZtvCFcxVlaZVWxyjhamhlVsCUcGeaQt-8mTNmNPhUu2WkvbPA>
    <xmx:kRE_XW0AErgiQ7Yswn0uO3PF2DALJ1Wp77xwc9o1k4Ezjuu9eADJzw>
    <xmx:kRE_XcjeKmcQBRbJ2LAcdTjnttSWbNI5UIGjAviPxm-6hFl8-9G4Vw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0DD16380083;
        Mon, 29 Jul 2019 11:32:32 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: inode: Don't compress if NODATASUM or NODATACOW set" failed to apply to 4.4-stable tree
To:     wqu@suse.com, dsterba@suse.com, jamespharvey20@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Jul 2019 17:32:31 +0200
Message-ID: <1564414351138157@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 42c16da6d684391db83788eb680accd84f6c2083 Mon Sep 17 00:00:00 2001
From: Qu Wenruo <wqu@suse.com>
Date: Mon, 1 Jul 2019 05:12:46 +0000
Subject: [PATCH] btrfs: inode: Don't compress if NODATASUM or NODATACOW set

As btrfs(5) specified:

	Note
	If nodatacow or nodatasum are enabled, compression is disabled.

If NODATASUM or NODATACOW set, we should not compress the extent.

Normally NODATACOW is detected properly in run_delalloc_range() so
compression won't happen for NODATACOW.

However for NODATASUM we don't have any check, and it can cause
compressed extent without csum pretty easily, just by:
  mkfs.btrfs -f $dev
  mount $dev $mnt -o nodatasum
  touch $mnt/foobar
  mount -o remount,datasum,compress $mnt
  xfs_io -f -c "pwrite 0 128K" $mnt/foobar

And in fact, we have a bug report about corrupted compressed extent
without proper data checksum so even RAID1 can't recover the corruption.
(https://bugzilla.kernel.org/show_bug.cgi?id=199707)

Running compression without proper checksum could cause more damage when
corruption happens, as compressed data could make the whole extent
unreadable, so there is no need to allow compression for
NODATACSUM.

The fix will refactor the inode compression check into two parts:

- inode_can_compress()
  As the hard requirement, checked at btrfs_run_delalloc_range(), so no
  compression will happen for NODATASUM inode at all.

- inode_need_compress()
  As the soft requirement, checked at btrfs_run_delalloc_range() and
  compress_file_range().

Reported-by: James Harvey <jamespharvey20@gmail.com>
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1af069a9a0c7..ee582a36653d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -395,10 +395,31 @@ static noinline int add_async_extent(struct async_chunk *cow,
 	return 0;
 }
 
+/*
+ * Check if the inode has flags compatible with compression
+ */
+static inline bool inode_can_compress(struct inode *inode)
+{
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW ||
+	    BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)
+		return false;
+	return true;
+}
+
+/*
+ * Check if the inode needs to be submitted to compression, based on mount
+ * options, defragmentation, properties or heuristics.
+ */
 static inline int inode_need_compress(struct inode *inode, u64 start, u64 end)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 
+	if (!inode_can_compress(inode)) {
+		WARN(IS_ENABLED(CONFIG_BTRFS_DEBUG),
+			KERN_ERR "BTRFS: unexpected compression for ino %llu\n",
+			btrfs_ino(BTRFS_I(inode)));
+		return 0;
+	}
 	/* force compress */
 	if (btrfs_test_opt(fs_info, FORCE_COMPRESS))
 		return 1;
@@ -1631,7 +1652,8 @@ int btrfs_run_delalloc_range(struct inode *inode, struct page *locked_page,
 	} else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC && !force_cow) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
-	} else if (!inode_need_compress(inode, start, end)) {
+	} else if (!inode_can_compress(inode) ||
+		   !inode_need_compress(inode, start, end)) {
 		ret = cow_file_range(inode, locked_page, start, end, end,
 				      page_started, nr_written, 1, NULL);
 	} else {

