Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2E0378506
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbhEJK6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:58:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231428AbhEJKxH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:53:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C04806101A;
        Mon, 10 May 2021 10:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643278;
        bh=9gFP7i5HqIkxBZA7fUwQpQGPVVNEyvP52KnWhKvpCa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FSIm6ndD83SemxwR64gYR/xxENoYbfjfRq0jfb1Y/YTRGrUj7WYQyD9fZFCtqtS+L
         DCLV82By9Qi9MMa6cXMM6sN2tzqbNY1JP8MaX25hr4YumwEn0IrytV5sp7bcDyk5L2
         IDmBAoH86fqNGXzskK2JyvZ2Z5eX7SzLBx5sZ49U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Vivek Goyal <vgoyal@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.10 251/299] fuse: fix write deadlock
Date:   Mon, 10 May 2021 12:20:48 +0200
Message-Id: <20210510102013.242413513@linuxfoundation.org>
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

From: Vivek Goyal <vgoyal@redhat.com>

commit 4f06dd92b5d0a6f8eec6a34b8d6ef3e1f4ac1e10 upstream.

There are two modes for write(2) and friends in fuse:

a) write through (update page cache, send sync WRITE request to userspace)

b) buffered write (update page cache, async writeout later)

The write through method kept all the page cache pages locked that were
used for the request.  Keeping more than one page locked is deadlock prone
and Qian Cai demonstrated this with trinity fuzzing.

The reason for keeping the pages locked is that concurrent mapped reads
shouldn't try to pull possibly stale data into the page cache.

For full page writes, the easy way to fix this is to make the cached page
be the authoritative source by marking the page PG_uptodate immediately.
After this the page can be safely unlocked, since mapped/cached reads will
take the written data from the cache.

Concurrent mapped writes will now cause data in the original WRITE request
to be updated; this however doesn't cause any data inconsistency and this
scenario should be exceedingly rare anyway.

If the WRITE request returns with an error in the above case, currently the
page is not marked uptodate; this means that a concurrent read will always
read consistent data.  After this patch the page is uptodate between
writing to the cache and receiving the error: there's window where a cached
read will read the wrong data.  While theoretically this could be a
regression, it is unlikely to be one in practice, since this is normal for
buffered writes.

In case of a partial page write to an already uptodate page the locking is
also unnecessary, with the above caveats.

Partial write of a not uptodate page still needs to be handled.  One way
would be to read the complete page before doing the write.  This is not
possible, since it might break filesystems that don't expect any READ
requests when the file was opened O_WRONLY.

The other solution is to serialize the synchronous write with reads from
the partial pages.  The easiest way to do this is to keep the partial pages
locked.  The problem is that a write() may involve two such pages (one head
and one tail).  This patch fixes it by only locking the partial tail page.
If there's a partial head page as well, then split that off as a separate
WRITE request.

Reported-by: Qian Cai <cai@lca.pw>
Link: https://lore.kernel.org/linux-fsdevel/4794a3fa3742a5e84fb0f934944204b55730829b.camel@lca.pw/
Fixes: ea9b9907b82a ("fuse: implement perform_write")
Cc: <stable@vger.kernel.org> # v2.6.26
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c   |   41 +++++++++++++++++++++++++++++------------
 fs/fuse/fuse_i.h |    1 +
 2 files changed, 30 insertions(+), 12 deletions(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1093,6 +1093,7 @@ static ssize_t fuse_send_write_pages(str
 	struct fuse_file *ff = file->private_data;
 	struct fuse_mount *fm = ff->fm;
 	unsigned int offset, i;
+	bool short_write;
 	int err;
 
 	for (i = 0; i < ap->num_pages; i++)
@@ -1105,32 +1106,38 @@ static ssize_t fuse_send_write_pages(str
 	if (!err && ia->write.out.size > count)
 		err = -EIO;
 
+	short_write = ia->write.out.size < count;
 	offset = ap->descs[0].offset;
 	count = ia->write.out.size;
 	for (i = 0; i < ap->num_pages; i++) {
 		struct page *page = ap->pages[i];
 
-		if (!err && !offset && count >= PAGE_SIZE)
-			SetPageUptodate(page);
-
-		if (count > PAGE_SIZE - offset)
-			count -= PAGE_SIZE - offset;
-		else
-			count = 0;
-		offset = 0;
-
-		unlock_page(page);
+		if (err) {
+			ClearPageUptodate(page);
+		} else {
+			if (count >= PAGE_SIZE - offset)
+				count -= PAGE_SIZE - offset;
+			else {
+				if (short_write)
+					ClearPageUptodate(page);
+				count = 0;
+			}
+			offset = 0;
+		}
+		if (ia->write.page_locked && (i == ap->num_pages - 1))
+			unlock_page(page);
 		put_page(page);
 	}
 
 	return err;
 }
 
-static ssize_t fuse_fill_write_pages(struct fuse_args_pages *ap,
+static ssize_t fuse_fill_write_pages(struct fuse_io_args *ia,
 				     struct address_space *mapping,
 				     struct iov_iter *ii, loff_t pos,
 				     unsigned int max_pages)
 {
+	struct fuse_args_pages *ap = &ia->ap;
 	struct fuse_conn *fc = get_fuse_conn(mapping->host);
 	unsigned offset = pos & (PAGE_SIZE - 1);
 	size_t count = 0;
@@ -1183,6 +1190,16 @@ static ssize_t fuse_fill_write_pages(str
 		if (offset == PAGE_SIZE)
 			offset = 0;
 
+		/* If we copied full page, mark it uptodate */
+		if (tmp == PAGE_SIZE)
+			SetPageUptodate(page);
+
+		if (PageUptodate(page)) {
+			unlock_page(page);
+		} else {
+			ia->write.page_locked = true;
+			break;
+		}
 		if (!fc->big_writes)
 			break;
 	} while (iov_iter_count(ii) && count < fc->max_write &&
@@ -1226,7 +1243,7 @@ static ssize_t fuse_perform_write(struct
 			break;
 		}
 
-		count = fuse_fill_write_pages(ap, mapping, ii, pos, nr_pages);
+		count = fuse_fill_write_pages(&ia, mapping, ii, pos, nr_pages);
 		if (count <= 0) {
 			err = count;
 		} else {
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -911,6 +911,7 @@ struct fuse_io_args {
 		struct {
 			struct fuse_write_in in;
 			struct fuse_write_out out;
+			bool page_locked;
 		} write;
 	};
 	struct fuse_args_pages ap;


