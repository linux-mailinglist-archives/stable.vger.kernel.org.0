Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 224DC11AEBD
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730119AbfLKPHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:07:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:55012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730076AbfLKPHs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:07:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6560520663;
        Wed, 11 Dec 2019 15:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576076866;
        bh=3m563FRZtB/k4I8XP+18gcNzctJF6R2qy2jQ07wZW0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lq0owAKvDQPAE61LUoH8/lNEgrm3rAzap/gTchhpIUYp8O+Q2+sJtn9oTyugY4ey5
         XSAu7+WwyxVmt8JsaBHWaX3d+O87OTxVyiaA9zV1zhlJMoOFtCS5dN18t7zRY9F+Gs
         pZUgCsIPF6lEdAv+QKAyGpdSyhbgctiEaYLf9HTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 20/92] io_uring: fix dead-hung for non-iter fixed rw
Date:   Wed, 11 Dec 2019 16:05:11 +0100
Message-Id: <20191211150227.929391888@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 311ae9e159d81a1ec1cf645daf40b39ae5a0bd84 upstream.

Read/write requests to devices without implemented read/write_iter
using fixed buffers can cause general protection fault, which totally
hangs a machine.

io_import_fixed() initialises iov_iter with bvec, but loop_rw_iter()
accesses it as iovec, dereferencing random address.

kmap() page by page in this case

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1351,9 +1351,19 @@ static ssize_t loop_rw_iter(int rw, stru
 		return -EAGAIN;
 
 	while (iov_iter_count(iter)) {
-		struct iovec iovec = iov_iter_iovec(iter);
+		struct iovec iovec;
 		ssize_t nr;
 
+		if (!iov_iter_is_bvec(iter)) {
+			iovec = iov_iter_iovec(iter);
+		} else {
+			/* fixed buffers import bvec */
+			iovec.iov_base = kmap(iter->bvec->bv_page)
+						+ iter->iov_offset;
+			iovec.iov_len = min(iter->count,
+					iter->bvec->bv_len - iter->iov_offset);
+		}
+
 		if (rw == READ) {
 			nr = file->f_op->read(file, iovec.iov_base,
 					      iovec.iov_len, &kiocb->ki_pos);
@@ -1362,6 +1372,9 @@ static ssize_t loop_rw_iter(int rw, stru
 					       iovec.iov_len, &kiocb->ki_pos);
 		}
 
+		if (iov_iter_is_bvec(iter))
+			kunmap(iter->bvec->bv_page);
+
 		if (nr < 0) {
 			if (!ret)
 				ret = nr;


