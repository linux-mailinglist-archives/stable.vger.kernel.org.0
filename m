Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7202B644E
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732561AbgKQNpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:45:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:51282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732687AbgKQNj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:39:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDB0824695;
        Tue, 17 Nov 2020 13:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620367;
        bh=7R0dZauWIWuIurbo1dI7lJaXShXrrZAkqR/55o9O18o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O8qH5wUVzilgKUTgsEDnRPXgtiJ+6Qm3TfaM9zVOjtXbwX41HT6Cj6Grv6irAVYFH
         2P32oGSVKdsPCPNOTqXtPrlsaS0fcyssXgW/YN3CvEYChQlTljFhQkfmNntyNkBKtV
         qVxkucHHi3VTIELUxXPkhZpAShjJ8tonUPjV5KBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.9 187/255] btrfs: fix potential overflow in cluster_pages_for_defrag on 32bit arch
Date:   Tue, 17 Nov 2020 14:05:27 +0100
Message-Id: <20201117122148.025371260@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
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
@@ -1261,6 +1261,7 @@ static int cluster_pages_for_defrag(stru
 	u64 page_start;
 	u64 page_end;
 	u64 page_cnt;
+	u64 start = (u64)start_index << PAGE_SHIFT;
 	int ret;
 	int i;
 	int i_done;
@@ -1277,8 +1278,7 @@ static int cluster_pages_for_defrag(stru
 	page_cnt = min_t(u64, (u64)num_pages, (u64)file_end - start_index + 1);
 
 	ret = btrfs_delalloc_reserve_space(BTRFS_I(inode), &data_reserved,
-			start_index << PAGE_SHIFT,
-			page_cnt << PAGE_SHIFT);
+			start, page_cnt << PAGE_SHIFT);
 	if (ret)
 		return ret;
 	i_done = 0;
@@ -1367,8 +1367,7 @@ again:
 		btrfs_mod_outstanding_extents(BTRFS_I(inode), 1);
 		spin_unlock(&BTRFS_I(inode)->lock);
 		btrfs_delalloc_release_space(BTRFS_I(inode), data_reserved,
-				start_index << PAGE_SHIFT,
-				(page_cnt - i_done) << PAGE_SHIFT, true);
+				start, (page_cnt - i_done) << PAGE_SHIFT, true);
 	}
 
 
@@ -1395,8 +1394,7 @@ out:
 		put_page(pages[i]);
 	}
 	btrfs_delalloc_release_space(BTRFS_I(inode), data_reserved,
-			start_index << PAGE_SHIFT,
-			page_cnt << PAGE_SHIFT, true);
+			start, page_cnt << PAGE_SHIFT, true);
 	btrfs_delalloc_release_extents(BTRFS_I(inode), page_cnt << PAGE_SHIFT);
 	extent_changeset_free(data_reserved);
 	return ret;


