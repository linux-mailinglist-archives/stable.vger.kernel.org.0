Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04AF3783B9
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbhEJKrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:47:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233066AbhEJKpB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:45:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A60D761624;
        Mon, 10 May 2021 10:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642875;
        bh=HjluC2N3I32cUFD4y6+oqHofg8Wl0e8qOQOIPhatPTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EupUWmZyWX7aO+5ZUkRR97qT37TnZ/XJsU/AnFTFhh9M6z+bAoJCNUc4SHecxuTvP
         7Tx5HDvsumwS/KuxIJhjmibMzztbLeQSYjKaDaKAmMpv+wp1X7tIx1PwYM2bcOa6CJ
         3cJFe/eN20iJHHfS1aqkGzgq0JOfCDMC0IEcm4ak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 043/299] btrfs: handle remount to no compress during compression
Date:   Mon, 10 May 2021 12:17:20 +0200
Message-Id: <20210510102006.275929345@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 1d8ba9e7e785b6625f4d8e978e8a284b144a7077 upstream.

[BUG]
When running btrfs/071 with inode_need_compress() removed from
compress_file_range(), we got the following crash:

  BUG: kernel NULL pointer dereference, address: 0000000000000018
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  Workqueue: btrfs-delalloc btrfs_work_helper [btrfs]
  RIP: 0010:compress_file_range+0x476/0x7b0 [btrfs]
  Call Trace:
   ? submit_compressed_extents+0x450/0x450 [btrfs]
   async_cow_start+0x16/0x40 [btrfs]
   btrfs_work_helper+0xf2/0x3e0 [btrfs]
   process_one_work+0x278/0x5e0
   worker_thread+0x55/0x400
   ? process_one_work+0x5e0/0x5e0
   kthread+0x168/0x190
   ? kthread_create_worker_on_cpu+0x70/0x70
   ret_from_fork+0x22/0x30
  ---[ end trace 65faf4eae941fa7d ]---

This is already after the patch "btrfs: inode: fix NULL pointer
dereference if inode doesn't need compression."

[CAUSE]
@pages is firstly created by kcalloc() in compress_file_extent():
                pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);

Then passed to btrfs_compress_pages() to be utilized there:

                ret = btrfs_compress_pages(...
                                           pages,
                                           &nr_pages,
                                           ...);

btrfs_compress_pages() will initialize each page as output, in
zlib_compress_pages() we have:

                        pages[nr_pages] = out_page;
                        nr_pages++;

Normally this is completely fine, but there is a special case which
is in btrfs_compress_pages() itself:

        switch (type) {
        default:
                return -E2BIG;
        }

In this case, we didn't modify @pages nor @out_pages, leaving them
untouched, then when we cleanup pages, the we can hit NULL pointer
dereference again:

        if (pages) {
                for (i = 0; i < nr_pages; i++) {
                        WARN_ON(pages[i]->mapping);
                        put_page(pages[i]);
                }
        ...
        }

Since pages[i] are all initialized to zero, and btrfs_compress_pages()
doesn't change them at all, accessing pages[i]->mapping would lead to
NULL pointer dereference.

This is not possible for current kernel, as we check
inode_need_compress() before doing pages allocation.
But if we're going to remove that inode_need_compress() in
compress_file_extent(), then it's going to be a problem.

[FIX]
When btrfs_compress_pages() hits its default case, modify @out_pages to
0 to prevent such problem from happening.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=212331
CC: stable@vger.kernel.org # 5.10+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/compression.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -80,10 +80,15 @@ static int compression_compress_pages(in
 	case BTRFS_COMPRESS_NONE:
 	default:
 		/*
-		 * This can't happen, the type is validated several times
-		 * before we get here. As a sane fallback, return what the
-		 * callers will understand as 'no compression happened'.
+		 * This can happen when compression races with remount setting
+		 * it to 'no compress', while caller doesn't call
+		 * inode_need_compress() to check if we really need to
+		 * compress.
+		 *
+		 * Not a big deal, just need to inform caller that we
+		 * haven't allocated any pages yet.
 		 */
+		*out_pages = 0;
 		return -E2BIG;
 	}
 }


