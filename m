Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6D47F77F
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbfD3L7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:59:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729990AbfD3LqW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:46:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5D9C21734;
        Tue, 30 Apr 2019 11:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624782;
        bh=0IQLCnlNZZsIMt2HNVM24VI5HBS5IPEulCItCd5mVww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMWpXfOEqld8uhQIDIuwddPeX4XrQ1t9Ui+D5VGj19F/nUPZxBgWEhjkhUuvCgcKs
         8wX24bG4326OdrRYCjzTIZ4USDX1OO8Y1GRv1gE9xXOiO6ZICyRxZbUHRfBbbiJsyc
         ZLrr0uKM4M2kK8g7UnvKys3GzEbp8AEdEQi2SMYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.19 070/100] aio: use iocb_put() instead of open coding it
Date:   Tue, 30 Apr 2019 13:38:39 +0200
Message-Id: <20190430113612.067935546@linuxfoundation.org>
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

commit 71ebc6fef0f53459f37fb39e1466792232fa52ee upstream.

Replace the percpu_ref_put() + kmem_cache_free() with a call to
iocb_put() instead.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1886,10 +1886,9 @@ static int io_submit_one(struct kioctx *
 		goto out_put_req;
 	return 0;
 out_put_req:
-	percpu_ref_put(&ctx->reqs);
 	if (req->ki_eventfd)
 		eventfd_ctx_put(req->ki_eventfd);
-	kmem_cache_free(kiocb_cachep, req);
+	iocb_put(req);
 out_put_reqs_available:
 	put_reqs_available(ctx, 1);
 	return ret;


