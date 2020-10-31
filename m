Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC3E2A16D5
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbgJaLkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:40:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727443AbgJaLkl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:40:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62D2D20719;
        Sat, 31 Oct 2020 11:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144440;
        bh=TSQpCtaXfjRi2NBJMXf3BABXxbMtcv4CJGNFjBKsKCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lTk0aY/ZnnEWIBBEYQrs+RRgEEHHSp3ru3Yd2lvuYUNK8QfAG2OqHGEJyNjhr0PcY
         t+VhQxTnRgv/3Yp9GzGYz37bfpRSSa4SR27teNIQdcDbGRySbWSHX6SxPwK5dysYFD
         4v83Ut00jSbnedPBVJ7dY9Vfs6UDD0QJ1YVSdILg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 04/70] io_uring: move dropping of files into separate helper
Date:   Sat, 31 Oct 2020 12:35:36 +0100
Message-Id: <20201031113459.700823262@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit f573d384456b3025d3f8e58b3eafaeeb0f510784 upstream.

No functional changes in this patch, prep patch for grabbing references
to the files_struct.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1424,6 +1424,20 @@ static inline void io_put_file(struct io
 		fput(file);
 }
 
+static void io_req_drop_files(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->inflight_lock, flags);
+	list_del(&req->inflight_entry);
+	if (waitqueue_active(&ctx->inflight_wait))
+		wake_up(&ctx->inflight_wait);
+	spin_unlock_irqrestore(&ctx->inflight_lock, flags);
+	req->flags &= ~REQ_F_INFLIGHT;
+	req->work.files = NULL;
+}
+
 static void __io_req_aux_free(struct io_kiocb *req)
 {
 	if (req->flags & REQ_F_NEED_CLEANUP)
@@ -1440,16 +1454,8 @@ static void __io_free_req(struct io_kioc
 {
 	__io_req_aux_free(req);
 
-	if (req->flags & REQ_F_INFLIGHT) {
-		struct io_ring_ctx *ctx = req->ctx;
-		unsigned long flags;
-
-		spin_lock_irqsave(&ctx->inflight_lock, flags);
-		list_del(&req->inflight_entry);
-		if (waitqueue_active(&ctx->inflight_wait))
-			wake_up(&ctx->inflight_wait);
-		spin_unlock_irqrestore(&ctx->inflight_lock, flags);
-	}
+	if (req->flags & REQ_F_INFLIGHT)
+		io_req_drop_files(req);
 
 	percpu_ref_put(&req->ctx->refs);
 	if (likely(!io_is_fallback_req(req)))


