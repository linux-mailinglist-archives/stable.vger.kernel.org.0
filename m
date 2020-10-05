Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90258283A5F
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbgJEPdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:33:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728116AbgJEPdv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:33:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E680B206DD;
        Mon,  5 Oct 2020 15:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601912030;
        bh=uA21n8kTXWeX3eBanMnYhXu9Yi/6iQkvG/dYxZd7Krs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IHaCVdSLJaFtnzK8Wff7DfJxt/RWoptStb/DA3sxMIV+O/0hNxE4ZaJ3DnKD/QKPa
         umPIN8kwlea4RW/ET7Rd38grRVVg583m7htbh5NqQ/ae2vOm3+GEcQz2f7ge6eCzWZ
         esuR/9M2l7MbNuCYWKqt4xnrkj704pJmGOHLz9tQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 43/85] io_uring: mark statx/files_update/epoll_ctl as non-SQPOLL
Date:   Mon,  5 Oct 2020 17:26:39 +0200
Message-Id: <20201005142116.802782495@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 4d79c1763e733..ebc3586b18795 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3318,7 +3318,7 @@ static int io_epoll_ctl_prep(struct io_kiocb *req,
 #if defined(CONFIG_EPOLL)
 	if (sqe->ioprio || sqe->buf_index)
 		return -EINVAL;
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL)))
 		return -EINVAL;
 
 	req->epoll.epfd = READ_ONCE(sqe->fd);
@@ -3435,7 +3435,7 @@ static int io_fadvise(struct io_kiocb *req, bool force_nonblock)
 
 static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL)))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->buf_index)
 		return -EINVAL;
@@ -5042,6 +5042,8 @@ static int io_async_cancel(struct io_kiocb *req)
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



