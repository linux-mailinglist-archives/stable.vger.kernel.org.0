Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA8F61E5ECE
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 13:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388658AbgE1L4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 07:56:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388650AbgE1L4O (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 07:56:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D918208E4;
        Thu, 28 May 2020 11:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590666973;
        bh=fCZJ/XHdKHiSHStzGsvusFWRTMUu6YnQ/9xTD63G/qo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z6qcsaHyVVLK2DCo+kBmk+9LiJ8aIiY85Bst15qpwORw+ztftRZW+XW9yzPtKM01J
         jGH6dVdmfqfdQUvYBZd91geTzNos/FnOaQnxWYkMg1b8IHdmlf3BmacAjWmMvrqfDo
         RC2Z3e8XtcayEOtm1AfVWVDFyaqdAQK9GqYNdcf4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 11/47] io_uring: don't prepare DRAIN reqs twice
Date:   Thu, 28 May 2020 07:55:24 -0400
Message-Id: <20200528115600.1405808-11-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115600.1405808-1-sashal@kernel.org>
References: <20200528115600.1405808-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

