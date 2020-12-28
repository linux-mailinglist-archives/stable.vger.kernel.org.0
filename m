Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5658A2E3FED
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732223AbgL1OqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:46:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:60164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502963AbgL1OYB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:24:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72EB720715;
        Mon, 28 Dec 2020 14:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165401;
        bh=bTQkqp/PABeLeaAi/Wx0IXUkq0ZhYGPMbxJITZfMGUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HtrjKUKawmtuZnfyk/rEgGxbMDxM29FqxiO4K7BlvixPtDrMI0adcY4ySmvgky/g6
         rqDHReoq4UsxxjX4MRA1o67+Tzu0QNPdFzMk6KY5y8JcLE9f4sqxkoOLUOZd+4Ax7p
         vC2J+u61KhrzTTMl58oxIGJeOCETqtT3nFGNa9yc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 519/717] io_uring: fix ignoring xa_store errors
Date:   Mon, 28 Dec 2020 13:48:37 +0100
Message-Id: <20201228125045.824895237@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit a528b04ea40690ff40501f50d618a62a02b19620 upstream.

xa_store() may fail, check the result.

Cc: stable@vger.kernel.org # 5.10
Fixes: 0f2122045b946 ("io_uring: don't rely on weak ->files references")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8708,10 +8708,9 @@ static void io_uring_cancel_task_request
 static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
 {
 	struct io_uring_task *tctx = current->io_uring;
+	int ret;
 
 	if (unlikely(!tctx)) {
-		int ret;
-
 		ret = io_uring_alloc_task_context(current);
 		if (unlikely(ret))
 			return ret;
@@ -8722,7 +8721,12 @@ static int io_uring_add_task_file(struct
 
 		if (!old) {
 			get_file(file);
-			xa_store(&tctx->xa, (unsigned long)file, file, GFP_KERNEL);
+			ret = xa_err(xa_store(&tctx->xa, (unsigned long)file,
+						file, GFP_KERNEL));
+			if (ret) {
+				fput(file);
+				return ret;
+			}
 		}
 		tctx->last = file;
 	}


