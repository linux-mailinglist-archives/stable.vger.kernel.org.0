Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298EE2B6596
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730722AbgKQN46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:56:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:56238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731104AbgKQNWE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:22:04 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5A4D221FE;
        Tue, 17 Nov 2020 13:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619324;
        bh=e6UyMN3hF1Sjnmt9zKWw8WaZgONJIs6z6eppvdaU9u4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xYZojWapph+haugQCNjn5HRY1SWhcTYmBNzvWBx8xgKj4htMY5H+4/sLs563ABlgC
         GAd7MkOQB7HntYC0wP5FS/ulKoK9/2FC8+5rad71SvnNhTQC+yeoFPxMhs1AgZR1Uk
         HUEFkreq49W43og6u0clIll2fWmjE5II7bJVJ+GA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 075/101] btrfs: fix potential overflow in cluster_pages_for_defrag on 32bit arch
Date:   Tue, 17 Nov 2020 14:05:42 +0100
Message-Id: <20201117122116.770326371@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit a1fbc6750e212c5675a4e48d7f51d44607eb8756 upstream.

On 32-bit systems, this shift will overflow for files larger than 4GB as
start_index is unsigned long while the calls to btrfs_delalloc_*_space
expect u64.

CC: stable@vger.kernel.org # 4.4+
Fixes: df480633b891 ("btrfs: extent-tree: Switch to new delalloc space reserve and release")
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Sterba <dsterba@suse.com>
[ define the variable instead of repeating the shift ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1239,6 +1239,7 @@ static int cluster_pages_for_defrag(stru
 	u64 page_start;
 	u64 page_end;
 	u64 page_cnt;
+	u64 start = (u64)start_index << PAGE_SHIFT;
 	int ret;
 	int i;
 	int i_done;
@@ -1255,8 +1256,7 @@ static int cluster_pages_for_defrag(stru
 	page_cnt = min_t(u64, (u64)num_pages, (u64)file_end - start_index + 1);
 
 	ret = btrfs_delalloc_reserve_space(inode, &data_reserved,
-			start_index << PAGE_SHIFT,
-			page_cnt << PAGE_SHIFT);
+			start, page_cnt << PAGE_SHIFT);
 	if (ret)
 		return ret;
 	i_done = 0;
@@ -1346,8 +1346,7 @@ again:
 		btrfs_mod_outstanding_extents(BTRFS_I(inode), 1);
 		spin_unlock(&BTRFS_I(inode)->lock);
 		btrfs_delalloc_release_space(inode, data_reserved,
-				start_index << PAGE_SHIFT,
-				(page_cnt - i_done) << PAGE_SHIFT, true);
+				start, (page_cnt - i_done) << PAGE_SHIFT, true);
 	}
 
 
@@ -1374,8 +1373,7 @@ out:
 		put_page(pages[i]);
 	}
 	btrfs_delalloc_release_space(inode, data_reserved,
-			start_index << PAGE_SHIFT,
-			page_cnt << PAGE_SHIFT, true);
+			start, page_cnt << PAGE_SHIFT, true);
 	btrfs_delalloc_release_extents(BTRFS_I(inode), page_cnt << PAGE_SHIFT);
 	extent_changeset_free(data_reserved);
 	return ret;


