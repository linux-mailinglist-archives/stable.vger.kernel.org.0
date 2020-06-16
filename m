Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F431FB8BE
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732972AbgFPPyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:54:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731851AbgFPPyT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:54:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42AA82168B;
        Tue, 16 Jun 2020 15:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322858;
        bh=UtpzrUWtxuDXO/k89lCw+FMl8V09G3DoAeSu9Qgqq0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xEQKFWy90NuPcMtmkk/doxtysE1nXg1gLLUs5RNy8utNDdkxiWvFmUBE20jVPNOfm
         UcpC7kPSoyEhTURnNw6aRGKrhipo65tl/OiGFPY/nXyCvjT5Xk1FHmHYseghfE24F/
         ftBWYldq01CzVZR1+jFDFgGI1FEJgqWZUvKcj5d4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.6 102/161] io_uring: fix flush req->refs underflow
Date:   Tue, 16 Jun 2020 17:34:52 +0200
Message-Id: <20200616153111.218747874@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 4518a3cc273cf82efdd36522fb1f13baad173c70 upstream.

In io_uring_cancel_files(), after refcount_sub_and_test() leaves 0
req->refs, it calls io_put_req(), which would also put a ref. Call
io_free_req() instead.

Cc: stable@vger.kernel.org
Fixes: 2ca10259b418 ("io_uring: prune request from overflow list on flush")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6529,7 +6529,7 @@ static void io_uring_cancel_files(struct
 			 * all we had, then we're done with this request.
 			 */
 			if (refcount_sub_and_test(2, &cancel_req->refs)) {
-				io_put_req(cancel_req);
+				io_free_req(cancel_req);
 				finish_wait(&ctx->inflight_wait, &wait);
 				continue;
 			}


