Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D03E22FCEA
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 01:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgG0XX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 19:23:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727957AbgG0XX5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 19:23:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CDCD2173E;
        Mon, 27 Jul 2020 23:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595892236;
        bh=VmwA5yULAMfmhKYTXg6cCjOLNQZggdm0KXFjrBNk3fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yH+jdhM5WeD6RmgMIWTdb9Q7NXHyoqYrNCF5Ekiq6I2QOKBYLu7PfN9h3bXE0AH/x
         0/EQjjKgdeXS+2Jmh0CqYs+qP6ISNDMjkb0E+MSXhblckwWeu2ZKTJ1SNUqqTZ57PU
         yyEkVOtgrix8D273163RBCuI4zHfC1OeuhN7mkmU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniele Albano <d.albano@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 07/25] io_uring: always allow drain/link/hardlink/async sqe flags
Date:   Mon, 27 Jul 2020 19:23:27 -0400
Message-Id: <20200727232345.717432-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200727232345.717432-1-sashal@kernel.org>
References: <20200727232345.717432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 51be3a20ade17..12ab983474dff 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4803,7 +4803,9 @@ static int io_timeout_remove_prep(struct io_kiocb *req,
 {
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->flags || sqe->ioprio || sqe->buf_index || sqe->len)
+	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->buf_index || sqe->len)
 		return -EINVAL;
 
 	req->timeout.addr = READ_ONCE(sqe->addr);
@@ -5009,8 +5011,9 @@ static int io_async_cancel_prep(struct io_kiocb *req,
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
@@ -5028,7 +5031,9 @@ static int io_async_cancel(struct io_kiocb *req)
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

