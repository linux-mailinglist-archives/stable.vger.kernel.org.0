Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBEE511AF9C
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730934AbfLKPON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:14:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:39130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731598AbfLKPOM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:14:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D561524682;
        Wed, 11 Dec 2019 15:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077252;
        bh=2j01xrxU82dvx7hc0Z9HeqJbY1k1vJAGGnbMsKIBhaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B9PnWj4+dPe787OHLrW3zogRQ0fFNCdvXN1dPXGvfKu3gJbJpgczJ35UHhPMAwKNA
         0wEJ471Ak1gRUbONMJimr2tKCbOW3RHYPVbit9ItyXFoizqO9Pwq8cImrTmAE2OnML
         OvAnK/H6do5W7bUlSHhYYeoPwtHTWc8vQnqHxe9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andres Freund <andres@anarazel.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.3 047/105] io_uring: ensure req->submit is copied when req is deferred
Date:   Wed, 11 Dec 2019 16:05:36 +0100
Message-Id: <20191211150240.986496848@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

There's an issue with deferred requests through drain, where if we do
need to defer, we're not copying over the sqe_submit state correctly.
This can result in using uninitialized data when we then later go and
submit the deferred request, like this check in __io_submit_sqe():

         if (unlikely(s->index >= ctx->sq_entries))
                 return -EINVAL;

with 's' being uninitialized, we can randomly fail this check. Fix this
by copying sqe_submit state when we defer a request.

Because it was fixed as part of a cleanup series in mainline, before
anyone realized we had this issue. That removed the separate states
of ->index vs ->submit.sqe. That series is not something I was
comfortable putting into stable, hence the much simpler addition.
Here's the patch in the series that fixes the same issue:

commit cf6fd4bd559ee61a4454b161863c8de6f30f8dca
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Mon Nov 25 23:14:39 2019 +0300

    io_uring: inline struct sqe_submit

Reported-by: Andres Freund <andres@anarazel.de>
Reported-by: Tomáš Chaloupka
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1787,7 +1787,7 @@ static int io_poll_add(struct io_kiocb *
 }
 
 static int io_req_defer(struct io_ring_ctx *ctx, struct io_kiocb *req,
-			const struct io_uring_sqe *sqe)
+			struct sqe_submit *s)
 {
 	struct io_uring_sqe *sqe_copy;
 
@@ -1805,7 +1805,8 @@ static int io_req_defer(struct io_ring_c
 		return 0;
 	}
 
-	memcpy(sqe_copy, sqe, sizeof(*sqe_copy));
+	memcpy(&req->submit, s, sizeof(*s));
+	memcpy(sqe_copy, s->sqe, sizeof(*sqe_copy));
 	req->submit.sqe = sqe_copy;
 
 	INIT_WORK(&req->work, io_sq_wq_submit_work);
@@ -2114,7 +2115,7 @@ static int io_queue_sqe(struct io_ring_c
 {
 	int ret;
 
-	ret = io_req_defer(ctx, req, s->sqe);
+	ret = io_req_defer(ctx, req, s);
 	if (ret) {
 		if (ret != -EIOCBQUEUED) {
 			io_free_req(req);


