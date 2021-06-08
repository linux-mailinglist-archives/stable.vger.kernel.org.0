Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D463A01F2
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235715AbhFHS6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:58:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237011AbhFHS4Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:56:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64695613FF;
        Tue,  8 Jun 2021 18:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177722;
        bh=kUMjmIv4kodkdy3zONmPQpYjVM8v4O4P2r/aNZfFh/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wqvkaMusMhHeOdgSDvQ1ItTtDUr6s4yFXtV+Ebf/My8AbOGIWvGTU8pTynCnh6maw
         /kjNkGtIiuitn59SPwlHbYEM/3SucT89CaJUjxOdPv0DrCH6wnarovxd7rndabNDTI
         MXVpsTOv+RzcOouSNeCV8ofBhCIU2itDWLMO2S4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/137] io_uring: use better types for cflags
Date:   Tue,  8 Jun 2021 20:26:54 +0200
Message-Id: <20210608175944.858059739@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 8c3f9cd1603d0e4af6c50ebc6d974ab7bdd03cf4 ]

__io_cqring_fill_event() takes cflags as long to squeeze it into u32 in
an CQE, awhile all users pass int or unsigned. Replace it with unsigned
int and store it as u32 in struct io_completion to match CQE.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 958c463c11eb..fdbaaf579cc6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -545,7 +545,7 @@ struct io_statx {
 struct io_completion {
 	struct file			*file;
 	struct list_head		list;
-	int				cflags;
+	u32				cflags;
 };
 
 struct io_async_connect {
@@ -1711,7 +1711,8 @@ static void io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 	}
 }
 
-static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
+static void __io_cqring_fill_event(struct io_kiocb *req, long res,
+				   unsigned int cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_cqe *cqe;
-- 
2.30.2



