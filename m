Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8012B4A35
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 17:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730652AbgKPQBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 11:01:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730176AbgKPQBY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 11:01:24 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDEA8C0613CF
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 08:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UMFc36DVvhbUcyBYQB6IJBQgOWDP2weq5/5h/y+1kdo=; b=py+rCVLZ8C005wB6DNCDoTbl54
        fqa6bZu4qk0uU2NykatPZFziNHZZlks6mEf+n6ER5w+7Gup1M8XkUu2DIRLNan4Gj1WiAykfw5B68
        TpFhRS9m/nKxcpTnlX8AbQEVX9Mzarjrv8GuYMHhqcUYT/rqAWQ3/5fPVRUj7S7vTEN4QOqxAbP4X
        FOFrNutLHoDSoo7Zsnl0WuBVNBm89chC2EaoHKynpHE8GwxH/GUtnkxM5rMUBscdCL3YpEcedw0xk
        RJZAElU1Vg8F88LyCaKp+MoPztmx9QK9nWzwXtvryS2fQOVWebX0FVEsc+YIxLiMQcQit6lqYcdrM
        9Nj6ACOg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kegwT-0002Ti-5L; Mon, 16 Nov 2020 16:01:21 +0000
Date:   Mon, 16 Nov 2020 16:01:21 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     gregkh@linuxfoundation.org
Cc:     dsterba@suse.com, josef@toxicpanda.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: fix potential overflow in
 cluster_pages_for_defrag on" failed to apply to 5.4-stable tree
Message-ID: <20201116160121.GE29991@casper.infradead.org>
References: <160554176663142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160554176663142@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 16, 2020 at 04:49:26PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Patch below generated against 5.4.67

> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> >From a1fbc6750e212c5675a4e48d7f51d44607eb8756 Mon Sep 17 00:00:00 2001
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Date: Sun, 4 Oct 2020 19:04:26 +0100
> Subject: [PATCH] btrfs: fix potential overflow in cluster_pages_for_defrag on
>  32bit arch
> 
> On 32-bit systems, this shift will overflow for files larger than 4GB as
> start_index is unsigned long while the calls to btrfs_delalloc_*_space
> expect u64.
> 
> CC: stable@vger.kernel.org # 4.4+
> Fixes: df480633b891 ("btrfs: extent-tree: Switch to new delalloc space reserve and release")
> Reviewed-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: David Sterba <dsterba@suse.com>
> [ define the variable instead of repeating the shift ]
> Signed-off-by: David Sterba <dsterba@suse.com>


diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 63394b450afc..4e3b71ec7492 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1255,6 +1255,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	u64 page_start;
 	u64 page_end;
 	u64 page_cnt;
+	u64 start = (u64)start_index << PAGE_SHIFT;
 	int ret;
 	int i;
 	int i_done;
@@ -1271,8 +1272,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	page_cnt = min_t(u64, (u64)num_pages, (u64)file_end - start_index + 1);
 
 	ret = btrfs_delalloc_reserve_space(inode, &data_reserved,
-			start_index << PAGE_SHIFT,
-			page_cnt << PAGE_SHIFT);
+			start, page_cnt << PAGE_SHIFT);
 	if (ret)
 		return ret;
 	i_done = 0;
@@ -1361,8 +1361,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 		btrfs_mod_outstanding_extents(BTRFS_I(inode), 1);
 		spin_unlock(&BTRFS_I(inode)->lock);
 		btrfs_delalloc_release_space(inode, data_reserved,
-				start_index << PAGE_SHIFT,
-				(page_cnt - i_done) << PAGE_SHIFT, true);
+				start, (page_cnt - i_done) << PAGE_SHIFT, true);
 	}
 
 
@@ -1389,8 +1388,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 		put_page(pages[i]);
 	}
 	btrfs_delalloc_release_space(inode, data_reserved,
-			start_index << PAGE_SHIFT,
-			page_cnt << PAGE_SHIFT, true);
+			start, page_cnt << PAGE_SHIFT, true);
 	btrfs_delalloc_release_extents(BTRFS_I(inode), page_cnt << PAGE_SHIFT);
 	extent_changeset_free(data_reserved);
 	return ret;
