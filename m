Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE1427BA28
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 03:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgI2Bf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 21:35:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727449AbgI2Ba4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 21:30:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D716216C4;
        Tue, 29 Sep 2020 01:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343055;
        bh=hjeLJcU4y+D2UPaE6PdGfXAU95Pq1CLWddqqvWCNuNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HP2gxXSTqo7d/1KuVWEez/au5qMfDTuvDULmCc4RA45D0djSPANYJDQGqQ9bBj41c
         ZLDKPaIa607XZ+apVhw1E0XaGLF1vx3750AVC3TcN21YUzwYQ9tEkArsLBl6wA0fkY
         Q7ObTAbmn/Q09dJ9nUkyQXJgwZkniWgwwpzLkI30=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 22/29] io_uring: mark statx/files_update/epoll_ctl as non-SQPOLL
Date:   Mon, 28 Sep 2020 21:30:19 -0400
Message-Id: <20200929013027.2406344-22-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013027.2406344-1-sashal@kernel.org>
References: <20200929013027.2406344-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 6ca56f845955e325033758f90a2cffe150f31bc8 ]

These will naturally fail when attempted through SQPOLL, but either
with -EFAULT or -EBADF. Make it explicit that these are not workable
through SQPOLL and return -EINVAL, just like other ops that need to
use ->files.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d05023ca74bdc..25543fdec5904 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3316,7 +3316,7 @@ static int io_epoll_ctl_prep(struct io_kiocb *req,
 #if defined(CONFIG_EPOLL)
 	if (sqe->ioprio || sqe->buf_index)
 		return -EINVAL;
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL)))
 		return -EINVAL;
 
 	req->epoll.epfd = READ_ONCE(sqe->fd);
@@ -3433,7 +3433,7 @@ static int io_fadvise(struct io_kiocb *req, bool force_nonblock)
 
 static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL)))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->buf_index)
 		return -EINVAL;
@@ -5038,6 +5038,8 @@ static int io_async_cancel(struct io_kiocb *req)
 static int io_files_update_prep(struct io_kiocb *req,
 				const struct io_uring_sqe *sqe)
 {
+	if (unlikely(req->ctx->flags & IORING_SETUP_SQPOLL))
+		return -EINVAL;
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->rw_flags)
-- 
2.25.1

