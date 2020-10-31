Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17AB2A16BB
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbgJaLny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:43:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728068AbgJaLnx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:43:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EF27205F4;
        Sat, 31 Oct 2020 11:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144632;
        bh=9MNo33/97XDFaVpwEXAyQQYhUGq18mgUFOsG+tV2kAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qR1uglB1oi3Ti8KojZ9dtysICSMB1FD2b5H2kWwSXJlJbwCTnwDPQTN51H07Ll0dg
         9/n19fzw+D7Z5cAdZV34uRktyj1RKwJaK0sSxa6cfqrib1MOjQE/aW4kIummTi7ftX
         SxRxknyksCS0Dnpktpv77FmAdslkkZFFexmYBDt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 04/74] io_uring: move dropping of files into separate helper
Date:   Sat, 31 Oct 2020 12:35:46 +0100
Message-Id: <20201031113500.250690107@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 0444ce1e0b5967393447dcd5adbf2bb023a50aab upstream.

No functional changes in this patch, prep patch for grabbing references
to the files_struct.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5648,6 +5648,20 @@ static int io_req_defer(struct io_kiocb
 	return -EIOCBQUEUED;
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
 static void __io_clean_op(struct io_kiocb *req)
 {
 	struct io_async_ctx *io = req->io;
@@ -5697,17 +5711,8 @@ static void __io_clean_op(struct io_kioc
 		req->flags &= ~REQ_F_NEED_CLEANUP;
 	}
 
-	if (req->flags & REQ_F_INFLIGHT) {
-		struct io_ring_ctx *ctx = req->ctx;
-		unsigned long flags;
-
-		spin_lock_irqsave(&ctx->inflight_lock, flags);
-		list_del(&req->inflight_entry);
-		if (waitqueue_active(&ctx->inflight_wait))
-			wake_up(&ctx->inflight_wait);
-		spin_unlock_irqrestore(&ctx->inflight_lock, flags);
-		req->flags &= ~REQ_F_INFLIGHT;
-	}
+	if (req->flags & REQ_F_INFLIGHT)
+		io_req_drop_files(req);
 }
 
 static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,


