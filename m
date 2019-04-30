Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48C52F657
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730539AbfD3LqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:46:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730169AbfD3LqU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:46:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F10D21707;
        Tue, 30 Apr 2019 11:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624779;
        bh=c88ScI8Uuvx5NjijKog5n0S0P2zYo9cGOcNXG3Coaa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=02vV3lYxajuSL/ejIxuD8htvAMTeoLEU4ETPmfIkaBulTMrLaDFJX7DqxIN3WRmom
         g0HmQQLU2nDpie32lU4LoC1H8sTBHubumcsjkhTHJCh8F+tply4DfrVvNM0Mw1YdpS
         GMwPtUkAzAj2pElqYy86yjXzn11uZDdnebgdszK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.19 069/100] aio: dont zero entire aio_kiocb aio_get_req()
Date:   Tue, 30 Apr 2019 13:38:38 +0200
Message-Id: <20190430113612.026422243@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 2bc4ca9bb600cbe36941da2b2a67189fc4302a04 upstream.

It's 192 bytes, fairly substantial. Most items don't need to be cleared,
especially not upfront. Clear the ones we do need to clear, and leave
the other ones for setup when the iocb is prepared and submitted.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1010,14 +1010,15 @@ static inline struct aio_kiocb *aio_get_
 {
 	struct aio_kiocb *req;
 
-	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL|__GFP_ZERO);
+	req = kmem_cache_alloc(kiocb_cachep, GFP_KERNEL);
 	if (unlikely(!req))
 		return NULL;
 
 	percpu_ref_get(&ctx->reqs);
+	req->ki_ctx = ctx;
 	INIT_LIST_HEAD(&req->ki_list);
 	refcount_set(&req->ki_refcnt, 0);
-	req->ki_ctx = ctx;
+	req->ki_eventfd = NULL;
 	return req;
 }
 
@@ -1738,6 +1739,10 @@ static ssize_t aio_poll(struct aio_kiocb
 	if (unlikely(!req->file))
 		return -EBADF;
 
+	req->head = NULL;
+	req->woken = false;
+	req->cancelled = false;
+
 	apt.pt._qproc = aio_poll_queue_proc;
 	apt.pt._key = req->events;
 	apt.iocb = aiocb;


