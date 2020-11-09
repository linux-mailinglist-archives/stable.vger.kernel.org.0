Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D012ABB16
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387529AbgKINYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:24:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:46676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387480AbgKINTO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:19:14 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 400D7206D8;
        Mon,  9 Nov 2020 13:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927953;
        bh=T4yyToto1LNtWt2uFoW4AtB6C061JWC20AajmIIF5fM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KLlZ4ngFsGcX3OVEUII2c3ry2jxbntg2hgrxdMfM7hoCtlUjWozHfKIlKzbXeZ4rR
         chnZ9ghefy/PYqQM8c2/IxSu12D6VOfrc+TW4kI182fthAPdx+vNuQ2mRFNlFcqCNU
         T2keDnnjmYX5ZnsMrTJQnf5lR/BASDpAQ3jkAFxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 078/133] io_uring: dont miss setting IO_WQ_WORK_CONCURRENT
Date:   Mon,  9 Nov 2020 13:55:40 +0100
Message-Id: <20201109125034.475257424@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 64f214a3dc9dd..eba5f65493a10 100644
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
@@ -6281,13 +6284,6 @@ static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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



