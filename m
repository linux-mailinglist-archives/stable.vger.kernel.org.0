Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA4C23A467
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgHCM0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:26:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:52212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728409AbgHCM0m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:26:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85CA0207FC;
        Mon,  3 Aug 2020 12:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457601;
        bh=5TXyn/wlwTOopHs0f1sd8GztkJl5GDHmCySOXvXNy5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lA9y2kO4OcwqvtSM7hEet/Z+aluQnAth/WTpXrFducH1gekgCAT/gqLV/p2tP7J85
         idzL66Kj22wK4529H5MPbL4+3T6qrOt6xqYnyoRGls7vUScBtTq18ctqoYRfpJyOTW
         fF/LZHGTQfbaf4oT07k00ZaRrqNC8BnBJFu1JZNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Albano <d.albano@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 100/120] io_uring: always allow drain/link/hardlink/async sqe flags
Date:   Mon,  3 Aug 2020 14:19:18 +0200
Message-Id: <20200803121907.776492818@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniele Albano <d.albano@gmail.com>

[ Upstream commit 61710e437f2807e26a3402543bdbb7217a9c8620 ]

We currently filter these for timeout_remove/async_cancel/files_update,
but we only should be filtering for fixed file and buffer select. This
also causes a second read of sqe->flags, which isn't needed.

Just check req->flags for the relevant bits. This then allows these
commands to be used in links, for example, like everything else.

Signed-off-by: Daniele Albano <d.albano@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d0d3efaaa4d4f..4e09af1d5d223 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4808,7 +4808,9 @@ static int io_timeout_remove_prep(struct io_kiocb *req,
 {
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->flags || sqe->ioprio || sqe->buf_index || sqe->len)
+	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->buf_index || sqe->len)
 		return -EINVAL;
 
 	req->timeout.addr = READ_ONCE(sqe->addr);
@@ -5014,8 +5016,9 @@ static int io_async_cancel_prep(struct io_kiocb *req,
 {
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->flags || sqe->ioprio || sqe->off || sqe->len ||
-	    sqe->cancel_flags)
+	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->off || sqe->len || sqe->cancel_flags)
 		return -EINVAL;
 
 	req->cancel.addr = READ_ONCE(sqe->addr);
@@ -5033,7 +5036,9 @@ static int io_async_cancel(struct io_kiocb *req)
 static int io_files_update_prep(struct io_kiocb *req,
 				const struct io_uring_sqe *sqe)
 {
-	if (sqe->flags || sqe->ioprio || sqe->rw_flags)
+	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->rw_flags)
 		return -EINVAL;
 
 	req->files_update.offset = READ_ONCE(sqe->off);
-- 
2.25.1



