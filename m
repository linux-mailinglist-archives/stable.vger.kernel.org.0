Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0D340E13D
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242106AbhIPQ2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:28:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240942AbhIPQ0v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:26:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3ED526152A;
        Thu, 16 Sep 2021 16:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809036;
        bh=1ztJ4vTn+M9k7NbaV/SF2yxHhIUd78+fIQxAk7eg9JA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gigv3N6Zrc2xGmjYrvLLn2mCdrMBVEzSAb883mwCSldu2ulnJ/Q4242B+QWbyjK/r
         ONUn9IyzeIQhm04DzCJfgvyj5MvWq1iUqMI6eJozy7dEfJtdCaQMkDrXXFoNOgcLUz
         zsdkjJZBXBEf6UhUJamTHy4FapZtj2e/Ixov3ztU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 279/306] io_uring: remove duplicated io_size from rw
Date:   Thu, 16 Sep 2021 18:00:24 +0200
Message-Id: <20210916155803.589764820@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 632546c4b5a4dad8e3ac456406c65c0db9a0b570 ]

io_size and iov_count in io_read() and io_write() hold the same value,
kill the last one.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8de0f52fd29d..d0089039fee7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3413,7 +3413,6 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	struct iov_iter __iter, *iter = &__iter;
 	struct io_async_rw *rw = req->async_data;
 	ssize_t io_size, ret, ret2;
-	size_t iov_count;
 	bool no_async;
 
 	if (rw)
@@ -3422,8 +3421,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	ret = io_import_iovec(READ, req, &iovec, iter, !force_nonblock);
 	if (ret < 0)
 		return ret;
-	iov_count = iov_iter_count(iter);
-	io_size = iov_count;
+	io_size = iov_iter_count(iter);
 	req->result = io_size;
 	ret = 0;
 
@@ -3439,7 +3437,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	if (no_async)
 		goto copy_iov;
 
-	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), iov_count);
+	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), io_size);
 	if (unlikely(ret))
 		goto out_free;
 
@@ -3458,7 +3456,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 		if (req->file->f_flags & O_NONBLOCK)
 			goto done;
 		/* some cases will consume bytes even on error returns */
-		iov_iter_revert(iter, iov_count - iov_iter_count(iter));
+		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		ret = 0;
 		goto copy_iov;
 	} else if (ret < 0) {
@@ -3542,7 +3540,6 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	struct kiocb *kiocb = &req->rw.kiocb;
 	struct iov_iter __iter, *iter = &__iter;
 	struct io_async_rw *rw = req->async_data;
-	size_t iov_count;
 	ssize_t ret, ret2, io_size;
 
 	if (rw)
@@ -3551,8 +3548,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	ret = io_import_iovec(WRITE, req, &iovec, iter, !force_nonblock);
 	if (ret < 0)
 		return ret;
-	iov_count = iov_iter_count(iter);
-	io_size = iov_count;
+	io_size = iov_iter_count(iter);
 	req->result = io_size;
 
 	/* Ensure we clear previously set non-block flag */
@@ -3570,7 +3566,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	    (req->flags & REQ_F_ISREG))
 		goto copy_iov;
 
-	ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), iov_count);
+	ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), io_size);
 	if (unlikely(ret))
 		goto out_free;
 
@@ -3613,7 +3609,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	} else {
 copy_iov:
 		/* some cases will consume bytes even on error returns */
-		iov_iter_revert(iter, iov_count - iov_iter_count(iter));
+		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
 		if (!ret)
 			return -EAGAIN;
-- 
2.30.2



