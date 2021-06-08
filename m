Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB243A036D
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237142AbhFHTQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:16:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238332AbhFHTOp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:14:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AFCC6195B;
        Tue,  8 Jun 2021 18:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178218;
        bh=wGFYGr1NSn8YgFOfDkzegQP7kcOXfTWKROcBc4tcO5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Djc/ZDq9vQ+OcrtWsKnApXdkkAzkjkaFcTjd7l+L7eSm2loWJF4zzOxglXGDsXTlM
         P8NxnJU1juP1fFR7VuzkdJE3aoNNUxMkhM6x297fAch36tJOlykh+6x2alh3FQtw5n
         8DIxiEJlQMGyqt4OGvb9urUHUPNsBP7JGuFeL6ZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 086/161] io_uring: use better types for cflags
Date:   Tue,  8 Jun 2021 20:26:56 +0200
Message-Id: <20210608175948.347729934@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
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
index 89f4e5e80b9e..5cc76fa9d4a1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -653,7 +653,7 @@ struct io_unlink {
 struct io_completion {
 	struct file			*file;
 	struct list_head		list;
-	int				cflags;
+	u32				cflags;
 };
 
 struct io_async_connect {
@@ -1476,7 +1476,8 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 	return ret;
 }
 
-static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
+static void __io_cqring_fill_event(struct io_kiocb *req, long res,
+				   unsigned int cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_cqe *cqe;
-- 
2.30.2



