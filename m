Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292C21EFA4D
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbgFEOQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:16:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728232AbgFEOQ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:16:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA97B20897;
        Fri,  5 Jun 2020 14:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366587;
        bh=fCZJ/XHdKHiSHStzGsvusFWRTMUu6YnQ/9xTD63G/qo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z1X+6oRCd7Kn1j74iZ7kmRjhzofJnOe2V/Q3lnPLca3EyQbexxd7NQhiGHvzryfaz
         THZM3TiG+2HhGWhCWZ8dh77scOw5nvWl3NzXhVjlO3+hRq1dKBhnimxvu3hV7LEtKC
         gT5fAeNaPc5qTK1m1OMugLE2Tao31LQx8MM9qqj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 13/43] io_uring: dont prepare DRAIN reqs twice
Date:   Fri,  5 Jun 2020 16:14:43 +0200
Message-Id: <20200605140153.218553972@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140152.493743366@linuxfoundation.org>
References: <20200605140152.493743366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 650b548129b60b0d23508351800108196f4aa89f ]

If req->io is not NULL, it's already prepared. Don't do it again,
it's dangerous.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8bdf2629f7fd..aa800f70c55e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4262,12 +4262,13 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (!req_need_defer(req) && list_empty_careful(&ctx->defer_list))
 		return 0;
 
-	if (!req->io && io_alloc_async_ctx(req))
-		return -EAGAIN;
-
-	ret = io_req_defer_prep(req, sqe);
-	if (ret < 0)
-		return ret;
+	if (!req->io) {
+		if (io_alloc_async_ctx(req))
+			return -EAGAIN;
+		ret = io_req_defer_prep(req, sqe);
+		if (ret < 0)
+			return ret;
+	}
 
 	spin_lock_irq(&ctx->completion_lock);
 	if (!req_need_defer(req) && list_empty(&ctx->defer_list)) {
-- 
2.25.1



