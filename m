Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F76427C706
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730945AbgI2LtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:49:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731172AbgI2LtI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:49:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD048206F7;
        Tue, 29 Sep 2020 11:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380147;
        bh=gmUfHcRNOMsi8iXW2jc6KIgwQ4oBWMzx6TbG1531NnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YHxTWsdk5wPHr85nKTEptnPhssmYTlQ8Xk3S2CoPXCYkC+RedfrUlasaR7oSarv8G
         ns8OZ0AAsIYBIxQ035oEvGrLpmOXLupYieQipnzEX6Bont8OIS+v2dRfdZ3HF8Uoz8
         A/Pd8/IEogAkl6XM/3ThVDcN3O7ithR5EV+Jw4lA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 58/99] io_uring: fix openat/openat2 unified prep handling
Date:   Tue, 29 Sep 2020 13:01:41 +0200
Message-Id: <20200929105932.583523181@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 4eb8dded6b82e184c09bb963bea0335fa3f30b55 ]

A previous commit unified how we handle prep for these two functions,
but this means that we check the allowed context (SQPOLL, specifically)
later than we should. Move the ring type checking into the two parent
functions, instead of doing it after we've done some setup work.

Fixes: ec65fea5a8d7 ("io_uring: deduplicate io_openat{,2}_prep()")
Reported-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d05023ca74bdc..849e39c3cfcd7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3056,8 +3056,6 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	const char __user *fname;
 	int ret;
 
-	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
-		return -EINVAL;
 	if (unlikely(sqe->ioprio || sqe->buf_index))
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
@@ -3084,6 +3082,8 @@ static int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	u64 flags, mode;
 
+	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
+		return -EINVAL;
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
 	mode = READ_ONCE(sqe->len);
@@ -3098,6 +3098,8 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	size_t len;
 	int ret;
 
+	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
+		return -EINVAL;
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
 	how = u64_to_user_ptr(READ_ONCE(sqe->addr2));
-- 
2.25.1



