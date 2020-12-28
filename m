Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7672E3FEC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732148AbgL1OqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:46:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:60210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502999AbgL1OYH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:24:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47BDA22AEC;
        Mon, 28 Dec 2020 14:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165407;
        bh=kogepKgP2qSS/eTnmVk/QoKuTHbO64aWOs1Lu8EteTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zjvt9PnDk7jY+vGZ52/7mMspnYV00vYnXotv91y8wn2mqbsL6wjdBod/z588qdkKB
         UVNPhxRBE/QWzx82KrHRfx3B+1osyQHDpISwL5KhQikymi7dLs12pvW15mNzRX2A8z
         CJ8xWC0oPSlgpL39ZqWKRIxTmY/TJmmdtOYwMLH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 521/717] io_uring: make ctx cancel on exit targeted to actual ctx
Date:   Mon, 28 Dec 2020 13:48:39 +0100
Message-Id: <20201228125045.924030517@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit 00c18640c2430c4bafaaeede1f9dd6f7ec0e4b25 upstream.

Before IORING_SETUP_ATTACH_WQ, we could just cancel everything on the
io-wq when exiting. But that's not the case if they are shared, so
cancel for the specific ctx instead.

Cc: stable@vger.kernel.org
Fixes: 24369c2e3bb0 ("io_uring: add io-wq workqueue sharing")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8401,6 +8401,13 @@ static void io_ring_exit_work(struct wor
 	io_ring_ctx_free(ctx);
 }
 
+static bool io_cancel_ctx_cb(struct io_wq_work *work, void *data)
+{
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+
+	return req->ctx == data;
+}
+
 static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 {
 	mutex_lock(&ctx->uring_lock);
@@ -8415,7 +8422,7 @@ static void io_ring_ctx_wait_and_kill(st
 	io_poll_remove_all(ctx, NULL);
 
 	if (ctx->io_wq)
-		io_wq_cancel_all(ctx->io_wq);
+		io_wq_cancel_cb(ctx->io_wq, io_cancel_ctx_cb, ctx, true);
 
 	/* if we failed setting up the ctx, we might not have any rings */
 	io_iopoll_try_reap_events(ctx);


