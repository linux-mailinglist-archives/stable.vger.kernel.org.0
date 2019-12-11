Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F43E11B00B
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731989AbfLKPS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:18:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731654AbfLKPS5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:18:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A36E208C3;
        Wed, 11 Dec 2019 15:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077537;
        bh=6N9Korw92IZCsMG74LXoqy/tRYYFEnFvZy73tHOE0is=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EHsA4/R4Lf3b3F8+ssuOORimLi4uvOf+76KVSLFtxDvC8OBPiw+vyF934LcRm85Ee
         p/eRHESc6AzRXwKlZAkYg6qArDM5BiFMpxiandXUYiqkH+ZG75T1nY7/NJh1Vlc/tS
         UbPNgvIf9aRs0oylu2UFvYWUr/SqtulAD76jPB/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 077/243] iomap: dio data corruption and spurious errors when pipes fill
Date:   Wed, 11 Dec 2019 16:03:59 +0100
Message-Id: <20191211150344.304750036@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 4721a6010990971440b4ffefbdf014976b8eda2f ]

When doing direct IO to a pipe for do_splice_direct(), then pipe is
trivial to fill up and overflow as it can only hold 16 pages. At
this point bio_iov_iter_get_pages() then returns -EFAULT, and we
abort the IO submission process. Unfortunately, iomap_dio_rw()
propagates the error back up the stack.

The error is converted from the EFAULT to EAGAIN in
generic_file_splice_read() to tell the splice layers that the pipe
is full. do_splice_direct() completely fails to handle EAGAIN errors
(it aborts on error) and returns EAGAIN to the caller.

copy_file_write() then completely fails to handle EAGAIN as well,
and so returns EAGAIN to userspace, having failed to copy the data
it was asked to.

Avoid this whole steaming pile of fail by having iomap_dio_rw()
silently swallow EFAULT errors and so do short reads.

To make matters worse, iomap_dio_actor() has a stale data exposure
bug bio_iov_iter_get_pages() fails - it does not zero the tail block
that it may have been left uncovered by partial IO. Fix the error
handling case to drop to the sub-block zeroing rather than
immmediately returning the -EFAULT error.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index d3d227682f7d4..0ff0f8ca3b197 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1603,7 +1603,7 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 	struct bio *bio;
 	bool need_zeroout = false;
 	bool use_fua = false;
-	int nr_pages, ret;
+	int nr_pages, ret = 0;
 	size_t copied = 0;
 
 	if ((pos | length | align) & ((1 << blkbits) - 1))
@@ -1668,8 +1668,14 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 
 		ret = bio_iov_iter_get_pages(bio, &iter);
 		if (unlikely(ret)) {
+			/*
+			 * We have to stop part way through an IO. We must fall
+			 * through to the sub-block tail zeroing here, otherwise
+			 * this short IO may expose stale data in the tail of
+			 * the block we haven't written data to.
+			 */
 			bio_put(bio);
-			return copied ? copied : ret;
+			goto zero_tail;
 		}
 
 		n = bio->bi_iter.bi_size;
@@ -1706,6 +1712,7 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 	 * the block tail in the latter case, we can expose stale data via mmap
 	 * reads of the EOF block.
 	 */
+zero_tail:
 	if (need_zeroout ||
 	    ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode))) {
 		/* zero out from the end of the write to the end of the block */
@@ -1713,7 +1720,7 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 		if (pad)
 			iomap_dio_zero(dio, iomap, pos, fs_block_size - pad);
 	}
-	return copied;
+	return copied ? copied : ret;
 }
 
 static loff_t
@@ -1888,6 +1895,15 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 				wait_for_completion = true;
 				ret = 0;
 			}
+
+			/*
+			 * Splicing to pipes can fail on a full pipe. We have to
+			 * swallow this to make it look like a short IO
+			 * otherwise the higher splice layers will completely
+			 * mishandle the error and stop moving data.
+			 */
+			if (ret == -EFAULT)
+				ret = 0;
 			break;
 		}
 		pos += ret;
-- 
2.20.1



