Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAB7282C28
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 20:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgJDSEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Oct 2020 14:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgJDSEg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Oct 2020 14:04:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B80C0613CE;
        Sun,  4 Oct 2020 11:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=pBzpd+ZwGINPndJww6tlDY0rtfFWrUcfW5HnCOvqMps=; b=HhKU5wBQQ0+KAkIw1hnOknJpey
        b+TM07EAXbH1BzLpr/tUIU6Zn7nHldnfw2dLBkS4z6MtoQnD3AAjPOkWyZZOu/Jr6aVZ0Cw5ktum2
        5rjXSksb901BlCVzzhiselxVyeUEGWOOPrd8+9nldrBw8W+QUdQRl7AMynVgT4dl7FqMGGLAz4MPp
        WJxO5XhcrH1qidqBSWiTtGhlnAVa1ZuoGcR32NQI48q1WbsygsXbRVU6XAKrsyhKOb4CKCU486nqP
        KNFJDJkYunqJevFpgyZjj/sGecsoaHR04EjI6+GDdt8LHtOLgV2YMnxRvy8yT5o4QNZnfm3hX91QT
        JGA1mwtw==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kP8N6-0003mo-1t; Sun, 04 Oct 2020 18:04:32 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, ericvh@gmail.com,
        lucho@ionkov.net, viro@zeniv.linux.org.uk, jlayton@kernel.org,
        idryomov@gmail.com, mark@fasheh.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, linux-btrfs@vger.kernel.org,
        clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        stable@vger.kernel.org
Subject: [PATCH 5/7] btrfs: Promote to unsigned long long before shifting
Date:   Sun,  4 Oct 2020 19:04:26 +0100
Message-Id: <20201004180428.14494-6-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201004180428.14494-1-willy@infradead.org>
References: <20201004180428.14494-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 32-bit systems, this shift will overflow for files larger than 4GB.

Cc: stable@vger.kernel.org
Fixes: df480633b891 ("btrfs: extent-tree: Switch to new delalloc space reserve and release")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/btrfs/ioctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ac45f022b495..4d3b7e4ae53a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1277,7 +1277,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	page_cnt = min_t(u64, (u64)num_pages, (u64)file_end - start_index + 1);
 
 	ret = btrfs_delalloc_reserve_space(BTRFS_I(inode), &data_reserved,
-			start_index << PAGE_SHIFT,
+			(loff_t)start_index << PAGE_SHIFT,
 			page_cnt << PAGE_SHIFT);
 	if (ret)
 		return ret;
@@ -1367,7 +1367,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 		btrfs_mod_outstanding_extents(BTRFS_I(inode), 1);
 		spin_unlock(&BTRFS_I(inode)->lock);
 		btrfs_delalloc_release_space(BTRFS_I(inode), data_reserved,
-				start_index << PAGE_SHIFT,
+				(loff_t)start_index << PAGE_SHIFT,
 				(page_cnt - i_done) << PAGE_SHIFT, true);
 	}
 
@@ -1395,7 +1395,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 		put_page(pages[i]);
 	}
 	btrfs_delalloc_release_space(BTRFS_I(inode), data_reserved,
-			start_index << PAGE_SHIFT,
+			(loff_t)start_index << PAGE_SHIFT,
 			page_cnt << PAGE_SHIFT, true);
 	btrfs_delalloc_release_extents(BTRFS_I(inode), page_cnt << PAGE_SHIFT);
 	extent_changeset_free(data_reserved);
-- 
2.28.0

