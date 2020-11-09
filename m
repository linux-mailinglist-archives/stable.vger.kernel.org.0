Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E292ABAB0
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388093AbgKINVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:21:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388090AbgKINVf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:21:35 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A230F2065D;
        Mon,  9 Nov 2020 13:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604928094;
        bh=OrBBqNpj4um0W3Z1ypB0ujgiH2V8/kvdg9LB+qdIoPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NzwuPw99Qqbj6jico3MB8LeNn7cDPM95LcjoHkwVcS1VvzFSTIjcB7c/+Z+SulzTC
         yYHap40/1G3gyWoYwsN20xI67synImweqEbLCpXv/QOC5iUQAY8cuZNf/RHikqiuwk
         wXEnYK533wcHlVwof0N2RxEwvk+A6fs0PFLxG5zk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 124/133] io_uring: fix link lookup racing with link timeout
Date:   Mon,  9 Nov 2020 13:56:26 +0100
Message-Id: <20201109125036.650991539@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 9a472ef7a3690ac0b77ebfb04c88fa795de2adea upstream.

We can't just go over linked requests because it may race with linked
timeouts. Take ctx->completion_lock in that case.

Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8176,7 +8176,21 @@ static bool io_timeout_remove_link(struc
 
 static bool io_cancel_link_cb(struct io_wq_work *work, void *data)
 {
-	return io_match_link(container_of(work, struct io_kiocb, work), data);
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	bool ret;
+
+	if (req->flags & REQ_F_LINK_TIMEOUT) {
+		unsigned long flags;
+		struct io_ring_ctx *ctx = req->ctx;
+
+		/* protect against races with linked timeouts */
+		spin_lock_irqsave(&ctx->completion_lock, flags);
+		ret = io_match_link(req, data);
+		spin_unlock_irqrestore(&ctx->completion_lock, flags);
+	} else {
+		ret = io_match_link(req, data);
+	}
+	return ret;
 }
 
 static void io_attempt_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)


