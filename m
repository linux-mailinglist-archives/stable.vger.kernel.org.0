Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389414A4376
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359683AbiAaLVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:21:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35518 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376760AbiAaLQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:16:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3339DB82A65;
        Mon, 31 Jan 2022 11:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E56C340E8;
        Mon, 31 Jan 2022 11:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627780;
        bh=YnkjfIxpDHPnN/B2PSOmGQTtqqp8DqWpVFYT75xX2xQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zaArjQRcXT5nnX+j46LFmPRvB/voBrysmOBtBymyCqtINTItWdjrxNIsf6c6k1gM4
         lH9mUQoIrEkUlFZTNT1GxqpfUbO+je3nYFEl94WlSlAY2ZZyd+BHJgFwboXLhRWIOG
         NkGGCQokJ/yq3ar+sOt4SXyVHJYGjMduebLnCexI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 005/200] btrfs: defrag: properly update range->start for autodefrag
Date:   Mon, 31 Jan 2022 11:54:28 +0100
Message-Id: <20220131105233.739400641@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit c080b4144b9dd3b7af838a194ffad3204ca15166 upstream.

[BUG]
After commit 7b508037d4ca ("btrfs: defrag: use defrag_one_cluster() to
implement btrfs_defrag_file()") autodefrag no longer properly re-defrag
the file from previously finished location.

[CAUSE]
The recent refactoring of defrag only focuses on defrag ioctl subpage
support, doesn't take autodefrag into consideration.

There are two problems involved which prevents autodefrag to restart its
scan:

- No range.start update
  Previously when one defrag target is found, range->start will be
  updated to indicate where next search should start from.

  But now btrfs_defrag_file() doesn't update it anymore, making all
  autodefrag to rescan from file offset 0.

  This would also make autodefrag to mark the same range dirty again and
  again, causing extra IO.

- No proper quick exit for defrag_one_cluster()
  Currently if we reached or exceed @max_sectors limit, we just exit
  defrag_one_cluster(), and let next defrag_one_cluster() call to do a
  quick exit.
  This makes @cur increase, thus no way to properly know which range is
  defragged and which range is skipped.

[FIX]
The fix involves two modifications:

- Update range->start to next cluster start
  This is a little different from the old behavior.
  Previously range->start is updated to the next defrag target.

  But in the end, the behavior should still be pretty much the same,
  as now we skip to next defrag target inside btrfs_defrag_file().

  Thus if auto-defrag determines to re-scan, then we still do the skip,
  just at a different timing.

- Make defrag_one_cluster() to return >0 to indicate a quick exit
  So that btrfs_defrag_file() can also do a quick exit, without
  increasing @cur to the range end, and re-use @cur to update
  @range->start.

- Add comment for btrfs_defrag_file() to mention the range->start update
  Currently only autodefrag utilize this behavior, as defrag ioctl won't
  set @max_to_defrag parameter, thus unless interrupted it will always
  try to defrag the whole range.

Reported-by: Filipe Manana <fdmanana@suse.com>
Fixes: 7b508037d4ca ("btrfs: defrag: use defrag_one_cluster() to implement btrfs_defrag_file()")
Link: https://lore.kernel.org/linux-btrfs/0a269612-e43f-da22-c5bc-b34b1b56ebe8@mailbox.org/
CC: stable@vger.kernel.org # 5.16
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1417,8 +1417,10 @@ static int defrag_one_cluster(struct btr
 		u32 range_len = entry->len;
 
 		/* Reached or beyond the limit */
-		if (max_sectors && *sectors_defragged >= max_sectors)
+		if (max_sectors && *sectors_defragged >= max_sectors) {
+			ret = 1;
 			break;
+		}
 
 		if (max_sectors)
 			range_len = min_t(u32, range_len,
@@ -1461,7 +1463,10 @@ out:
  *		   will be defragged.
  *
  * Return <0 for error.
- * Return >=0 for the number of sectors defragged.
+ * Return >=0 for the number of sectors defragged, and range->start will be updated
+ * to indicate the file offset where next defrag should be started at.
+ * (Mostly for autodefrag, which sets @max_to_defrag thus we may exit early without
+ *  defragging all the range).
  */
 int btrfs_defrag_file(struct inode *inode, struct file_ra_state *ra,
 		      struct btrfs_ioctl_defrag_range_args *range,
@@ -1554,10 +1559,19 @@ int btrfs_defrag_file(struct inode *inod
 		if (ret < 0)
 			break;
 		cur = cluster_end + 1;
+		if (ret > 0) {
+			ret = 0;
+			break;
+		}
 	}
 
 	if (ra_allocated)
 		kfree(ra);
+	/*
+	 * Update range.start for autodefrag, this will indicate where to start
+	 * in next run.
+	 */
+	range->start = cur;
 	if (sectors_defragged) {
 		/*
 		 * We have defragged some sectors, for compression case they


