Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D76287987B
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbfG2TiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:38:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388841AbfG2TiO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:38:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC4692054F;
        Mon, 29 Jul 2019 19:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429093;
        bh=jJS2Hl146sLNV2zsYlfjeiTnP8ZcPiX/ViingnfrTwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dYFxXC35+UQ2xZftI5GjKDrXLwpU/lWrbV4c8BXvowFqhVaOLewTzaB5CakzfpXpH
         rwRBnfoBVkKP1X6qsE5fieVXUxaIg+F4+iVQ1NOpg4k16sjyH9nk/G7q3Y6/RmuYvw
         LsdSQlBc6DPtPYA7wEqrH0+iwwrNazVNsXv231iA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Harvey <jamespharvey20@gmail.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 4.14 283/293] btrfs: inode: Dont compress if NODATASUM or NODATACOW set
Date:   Mon, 29 Jul 2019 21:22:54 +0200
Message-Id: <20190729190845.942574983@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 42c16da6d684391db83788eb680accd84f6c2083 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -405,10 +405,31 @@ static noinline int add_async_extent(str
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
@@ -1626,7 +1647,8 @@ static int run_delalloc_range(void *priv
 	} else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC && !force_cow) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
-	} else if (!inode_need_compress(inode, start, end)) {
+	} else if (!inode_can_compress(inode) ||
+		   !inode_need_compress(inode, start, end)) {
 		ret = cow_file_range(inode, locked_page, start, end, end,
 				      page_started, nr_written, 1, NULL);
 	} else {


