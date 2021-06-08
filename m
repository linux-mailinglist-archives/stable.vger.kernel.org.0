Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170443A0256
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236362AbhFHTDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:03:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237608AbhFHTBC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:01:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C6B66144E;
        Tue,  8 Jun 2021 18:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177851;
        bh=F2ETnJw9S0rl4zRvVb2Cq54LEp82vMjREJ+qusaerX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vEa6H+koS+4iDE9bAgiSTelL3agmbhZ7U0JxsWfwtT9fZTV94IehZcCgHORYdC/jr
         7ADA1WmM4C9kn76pebSpmTOG+oiB/yP5IPOAo5jQyI6ecDxpSSYisyFy3TeSVGcnej
         nvOcQlP8BCAuSlo0noCxxolhIEtaHvgh+YbzPOJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 124/137] btrfs: fix deadlock when cloning inline extents and low on available space
Date:   Tue,  8 Jun 2021 20:27:44 +0200
Message-Id: <20210608175946.571794673@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 76a6d5cd74479e7ec8a7f9a29bce63d5549b6b2e upstream.

There are a few cases where cloning an inline extent requires copying data
into a page of the destination inode. For these cases we are allocating
the required data and metadata space while holding a leaf locked. This can
result in a deadlock when we are low on available space because allocating
the space may flush delalloc and two deadlock scenarios can happen:

1) When starting writeback for an inode with a very small dirty range that
   fits in an inline extent, we deadlock during the writeback when trying
   to insert the inline extent, at cow_file_range_inline(), if the extent
   is going to be located in the leaf for which we are already holding a
   read lock;

2) After successfully starting writeback, for non-inline extent cases,
   the async reclaim thread will hang waiting for an ordered extent to
   complete if the ordered extent completion needs to modify the leaf
   for which the clone task is holding a read lock (for adding or
   replacing file extent items). So the cloning task will wait forever
   on the async reclaim thread to make progress, which in turn is
   waiting for the ordered extent completion which in turn is waiting
   to acquire a write lock on the same leaf.

So fix this by making sure we release the path (and therefore the leaf)
every time we need to copy the inline extent's data into a page of the
destination inode, as by that time we do not need to have the leaf locked.

Fixes: 05a5a7621ce66c ("Btrfs: implement full reflink support for inline extents")
CC: stable@vger.kernel.org # 5.10+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/reflink.c |   38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -207,10 +207,7 @@ static int clone_copy_inline_extent(stru
 			 * inline extent's data to the page.
 			 */
 			ASSERT(key.offset > 0);
-			ret = copy_inline_to_page(BTRFS_I(dst), new_key->offset,
-						  inline_data, size, datal,
-						  comp_type);
-			goto out;
+			goto copy_to_page;
 		}
 	} else if (i_size_read(dst) <= datal) {
 		struct btrfs_file_extent_item *ei;
@@ -226,13 +223,10 @@ static int clone_copy_inline_extent(stru
 		    BTRFS_FILE_EXTENT_INLINE)
 			goto copy_inline_extent;
 
-		ret = copy_inline_to_page(BTRFS_I(dst), new_key->offset,
-					  inline_data, size, datal, comp_type);
-		goto out;
+		goto copy_to_page;
 	}
 
 copy_inline_extent:
-	ret = 0;
 	/*
 	 * We have no extent items, or we have an extent at offset 0 which may
 	 * or may not be inlined. All these cases are dealt the same way.
@@ -244,11 +238,13 @@ copy_inline_extent:
 		 * clone. Deal with all these cases by copying the inline extent
 		 * data into the respective page at the destination inode.
 		 */
-		ret = copy_inline_to_page(BTRFS_I(dst), new_key->offset,
-					  inline_data, size, datal, comp_type);
-		goto out;
+		goto copy_to_page;
 	}
 
+	/*
+	 * Release path before starting a new transaction so we don't hold locks
+	 * that would confuse lockdep.
+	 */
 	btrfs_release_path(path);
 	/*
 	 * If we end up here it means were copy the inline extent into a leaf
@@ -282,11 +278,6 @@ copy_inline_extent:
 out:
 	if (!ret && !trans) {
 		/*
-		 * Release path before starting a new transaction so we don't
-		 * hold locks that would confuse lockdep.
-		 */
-		btrfs_release_path(path);
-		/*
 		 * No transaction here means we copied the inline extent into a
 		 * page of the destination inode.
 		 *
@@ -306,6 +297,21 @@ out:
 		*trans_out = trans;
 
 	return ret;
+
+copy_to_page:
+	/*
+	 * Release our path because we don't need it anymore and also because
+	 * copy_inline_to_page() needs to reserve data and metadata, which may
+	 * need to flush delalloc when we are low on available space and
+	 * therefore cause a deadlock if writeback of an inline extent needs to
+	 * write to the same leaf or an ordered extent completion needs to write
+	 * to the same leaf.
+	 */
+	btrfs_release_path(path);
+
+	ret = copy_inline_to_page(BTRFS_I(dst), new_key->offset,
+				  inline_data, size, datal, comp_type);
+	goto out;
 }
 
 /**


