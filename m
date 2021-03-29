Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3168234C950
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbhC2I31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:29:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233682AbhC2IZ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:25:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EAF8619BB;
        Mon, 29 Mar 2021 08:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006326;
        bh=mHF8+Ki1w5Z7pryKIf68rubLDuN40bh2yS1C9XqTdpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JIoNnZNrQnKEAAKeMFPuOdxzNVrCrl+/Z8/bIus9gCI9XndUi4lQyhPcRTBDGAS+A
         FDzTDZ6gATnc/wZh0Uvh7pAtamh/6SAE9Z+9oyAg+zRCiPagkN3/JSiwcxNuMNQLcl
         TL7MZ+rTo6BDUzhBrgxv6CKwAT3NfdWvMBD5+/q0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 200/221] io_uring: fix provide_buffers sign extension
Date:   Mon, 29 Mar 2021 09:58:51 +0200
Message-Id: <20210329075635.803001996@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit d81269fecb8ce16eb07efafc9ff5520b2a31c486 ]

io_provide_buffers_prep()'s "p->len * p->nbufs" to sign extension
problems. Not a huge problem as it's only used for access_ok() and
increases the checked length, but better to keep typing right.

Reported-by: Colin Ian King <colin.king@canonical.com>
Fixes: efe68c1ca8f49 ("io_uring: validate the full range of provided buffers for access")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/562376a39509e260d8532186a06226e56eb1f594.1616149233.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 06e9c2181995..dde290eb7dd0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3996,6 +3996,7 @@ static int io_remove_buffers(struct io_kiocb *req, bool force_nonblock,
 static int io_provide_buffers_prep(struct io_kiocb *req,
 				   const struct io_uring_sqe *sqe)
 {
+	unsigned long size;
 	struct io_provide_buf *p = &req->pbuf;
 	u64 tmp;
 
@@ -4009,7 +4010,8 @@ static int io_provide_buffers_prep(struct io_kiocb *req,
 	p->addr = READ_ONCE(sqe->addr);
 	p->len = READ_ONCE(sqe->len);
 
-	if (!access_ok(u64_to_user_ptr(p->addr), (p->len * p->nbufs)))
+	size = (unsigned long)p->len * p->nbufs;
+	if (!access_ok(u64_to_user_ptr(p->addr), size))
 		return -EFAULT;
 
 	p->bgid = READ_ONCE(sqe->buf_group);
-- 
2.30.1



