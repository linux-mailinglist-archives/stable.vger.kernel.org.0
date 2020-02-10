Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 304AB157738
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729306AbgBJM60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:58:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:43296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729959AbgBJMlT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:19 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7498E2051A;
        Mon, 10 Feb 2020 12:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338478;
        bh=zbDSL2IRCRq63JOrJgxVy1SNSOhSXsvo8WExnJj+SEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=obv0MC9RvldaMxhnas/PcQpBAp1G/81QI9rRoaY+i5wgKAGutgnYVKuGCI9KTYgkW
         Fe/eEyMPYRiq++XMFB0/eQR+0fKQifiZFkoCusEVo3A1g+xXhkOarIP3Ux10+KmIag
         8z1XNv87cLbudkD4mwDhdzW0flxBDdvJh6R08xL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.5 211/367] gfs2: fix O_SYNC write handling
Date:   Mon, 10 Feb 2020 04:32:04 -0800
Message-Id: <20200210122443.808503014@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 6e5e41e2dc4e4413296d5a4af54ac92d7cd52317 upstream.

In gfs2_file_write_iter, for direct writes, the error checking in the buffered
write fallback case is incomplete.  This can cause inode write errors to go
undetected.  Fix and clean up gfs2_file_write_iter along the way.

Based on a proposed fix by Christoph Hellwig <hch@lst.de>.

Fixes: 967bcc91b044 ("gfs2: iomap direct I/O support")
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/file.c |   51 +++++++++++++++++++++------------------------------
 1 file changed, 21 insertions(+), 30 deletions(-)

--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -847,7 +847,7 @@ static ssize_t gfs2_file_write_iter(stru
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
 	struct gfs2_inode *ip = GFS2_I(inode);
-	ssize_t written = 0, ret;
+	ssize_t ret;
 
 	ret = gfs2_rsqa_alloc(ip);
 	if (ret)
@@ -879,55 +879,46 @@ static ssize_t gfs2_file_write_iter(stru
 
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		struct address_space *mapping = file->f_mapping;
-		loff_t pos, endbyte;
-		ssize_t buffered;
+		ssize_t buffered, ret2;
 
-		written = gfs2_file_direct_write(iocb, from);
-		if (written < 0 || !iov_iter_count(from))
+		ret = gfs2_file_direct_write(iocb, from);
+		if (ret < 0 || !iov_iter_count(from))
 			goto out_unlock;
 
+		iocb->ki_flags |= IOCB_DSYNC;
 		current->backing_dev_info = inode_to_bdi(inode);
-		ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
+		buffered = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
 		current->backing_dev_info = NULL;
-		if (unlikely(ret < 0))
+		if (unlikely(buffered <= 0))
 			goto out_unlock;
-		buffered = ret;
 
 		/*
 		 * We need to ensure that the page cache pages are written to
 		 * disk and invalidated to preserve the expected O_DIRECT
-		 * semantics.
+		 * semantics.  If the writeback or invalidate fails, only report
+		 * the direct I/O range as we don't know if the buffered pages
+		 * made it to disk.
 		 */
-		pos = iocb->ki_pos;
-		endbyte = pos + buffered - 1;
-		ret = filemap_write_and_wait_range(mapping, pos, endbyte);
-		if (!ret) {
-			iocb->ki_pos += buffered;
-			written += buffered;
-			invalidate_mapping_pages(mapping,
-						 pos >> PAGE_SHIFT,
-						 endbyte >> PAGE_SHIFT);
-		} else {
-			/*
-			 * We don't know how much we wrote, so just return
-			 * the number of bytes which were direct-written
-			 */
-		}
+		iocb->ki_pos += buffered;
+		ret2 = generic_write_sync(iocb, buffered);
+		invalidate_mapping_pages(mapping,
+				(iocb->ki_pos - buffered) >> PAGE_SHIFT,
+				(iocb->ki_pos - 1) >> PAGE_SHIFT);
+		if (!ret || ret2 > 0)
+			ret += ret2;
 	} else {
 		current->backing_dev_info = inode_to_bdi(inode);
 		ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
 		current->backing_dev_info = NULL;
-		if (likely(ret > 0))
+		if (likely(ret > 0)) {
 			iocb->ki_pos += ret;
+			ret = generic_write_sync(iocb, ret);
+		}
 	}
 
 out_unlock:
 	inode_unlock(inode);
-	if (likely(ret > 0)) {
-		/* Handle various SYNC-type writes */
-		ret = generic_write_sync(iocb, ret);
-	}
-	return written ? written : ret;
+	return ret;
 }
 
 static int fallocate_chunk(struct inode *inode, loff_t offset, loff_t len,


