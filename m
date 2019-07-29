Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 945ED796EB
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404273AbfG2Tz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:55:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404250AbfG2Tz5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:55:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2A02204EC;
        Mon, 29 Jul 2019 19:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430156;
        bh=wh1zoquakyM/0TPKZ8B93mtc776SuJUVqVduk7mbb1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M3tuxRCYanLZzQp/zqBPSh71Iix5KaghalvfjpR7lHpWjc+L+t2Ddss9VRBz/z4h/
         LYS2TT9P7F7gJ/kvZ6TtZt8ocy2e7GPkK7ohWQQvqz5xHPgZV5J+rMem+t/vaMw+VA
         NnFUy4vcMYXqdtcHWbnHXHUpIYfuQ6wAGJW+EM2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hrvoje Zeba <zeba.hrvoje@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.2 215/215] io_uring: dont use iov_iter_advance() for fixed buffers
Date:   Mon, 29 Jul 2019 21:23:31 +0200
Message-Id: <20190729190817.178599978@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit bd11b3a391e3df6fa958facbe4b3f9f4cca9bd49 upstream.

Hrvoje reports that when a large fixed buffer is registered and IO is
being done to the latter pages of said buffer, the IO submission time
is much worse:

reading to the start of the buffer: 11238 ns
reading to the end of the buffer:   1039879 ns

In fact, it's worse by two orders of magnitude. The reason for that is
how io_uring figures out how to setup the iov_iter. We point the iter
at the first bvec, and then use iov_iter_advance() to fast-forward to
the offset within that buffer we need.

However, that is abysmally slow, as it entails iterating the bvecs
that we setup as part of buffer registration. There's really no need
to use this generic helper, as we know it's a BVEC type iterator, and
we also know that each bvec is PAGE_SIZE in size, apart from possibly
the first and last. Hence we can just use a shift on the offset to
find the right index, and then adjust the iov_iter appropriately.
After this fix, the timings are:

reading to the start of the buffer: 10135 ns
reading to the end of the buffer:   1377 ns

Or about an 755x improvement for the tail page.

Reported-by: Hrvoje Zeba <zeba.hrvoje@gmail.com>
Tested-by: Hrvoje Zeba <zeba.hrvoje@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 fs/io_uring.c |   39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1001,8 +1001,43 @@ static int io_import_fixed(struct io_rin
 	 */
 	offset = buf_addr - imu->ubuf;
 	iov_iter_bvec(iter, rw, imu->bvec, imu->nr_bvecs, offset + len);
-	if (offset)
-		iov_iter_advance(iter, offset);
+
+	if (offset) {
+		/*
+		 * Don't use iov_iter_advance() here, as it's really slow for
+		 * using the latter parts of a big fixed buffer - it iterates
+		 * over each segment manually. We can cheat a bit here, because
+		 * we know that:
+		 *
+		 * 1) it's a BVEC iter, we set it up
+		 * 2) all bvecs are PAGE_SIZE in size, except potentially the
+		 *    first and last bvec
+		 *
+		 * So just find our index, and adjust the iterator afterwards.
+		 * If the offset is within the first bvec (or the whole first
+		 * bvec, just use iov_iter_advance(). This makes it easier
+		 * since we can just skip the first segment, which may not
+		 * be PAGE_SIZE aligned.
+		 */
+		const struct bio_vec *bvec = imu->bvec;
+
+		if (offset <= bvec->bv_len) {
+			iov_iter_advance(iter, offset);
+		} else {
+			unsigned long seg_skip;
+
+			/* skip first vec */
+			offset -= bvec->bv_len;
+			seg_skip = 1 + (offset >> PAGE_SHIFT);
+
+			iter->bvec = bvec + seg_skip;
+			iter->nr_segs -= seg_skip;
+			iter->count -= (seg_skip << PAGE_SHIFT);
+			iter->iov_offset = offset & ~PAGE_MASK;
+			if (iter->iov_offset)
+				iter->count -= iter->iov_offset;
+		}
+	}
 
 	/* don't drop a reference to these pages */
 	iter->type |= ITER_BVEC_FLAG_NO_REF;


