Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23AD92A39CC
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 02:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbgKCBSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 20:18:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:60424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727334AbgKCBSy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 20:18:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0864A222EC;
        Tue,  3 Nov 2020 01:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366333;
        bh=NsTZ4LeL44b2TEztNibwzFI+wjAhn0RVr98hf/W1DYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P68X21YRhVGL8V75H8Ez2XlQ27UQ0UQLbcGSN9t9JAkQ/kDvLclfjfxblRltZ2fT8
         eNwU/a0lsK+umypumfevaVWt6LIG8JVBRiWj/S1qf9h51Uhx2vSYue0JUU0+zfC9xY
         Tt8SlPCo3Loe6cKlwVSNzA7vCrkkZ0ql1vo0J4+Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 09/35] io_uring: don't miss setting IO_WQ_WORK_CONCURRENT
Date:   Mon,  2 Nov 2020 20:18:14 -0500
Message-Id: <20201103011840.182814-9-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201103011840.182814-1-sashal@kernel.org>
References: <20201103011840.182814-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit feaadc4fc2ebdbd53ffed1735077725855a2af53 ]

Set IO_WQ_WORK_CONCURRENT for all REQ_F_FORCE_ASYNC requests, do that in
that is also looks better.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 59ab8c5c2aaaa..670b15014e256 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1140,6 +1140,9 @@ static void io_prep_async_work(struct io_kiocb *req)
 
 	io_req_init_async(req);
 
+	if (req->flags & REQ_F_FORCE_ASYNC)
+		req->work.flags |= IO_WQ_WORK_CONCURRENT;
+
 	if (req->flags & REQ_F_ISREG) {
 		if (def->hash_reg_file || (req->ctx->flags & IORING_SETUP_IOPOLL))
 			io_wq_hash_work(&req->work, file_inode(req->file));
@@ -6279,13 +6282,6 @@ static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (unlikely(ret))
 				goto fail_req;
 		}
-
-		/*
-		 * Never try inline submit of IOSQE_ASYNC is set, go straight
-		 * to async execution.
-		 */
-		io_req_init_async(req);
-		req->work.flags |= IO_WQ_WORK_CONCURRENT;
 		io_queue_async_work(req);
 	} else {
 		__io_queue_sqe(req, sqe, cs);
-- 
2.27.0

