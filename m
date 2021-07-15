Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A482F3CA786
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239147AbhGOSzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:55:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240342AbhGOSx6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:53:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BCF6613CC;
        Thu, 15 Jul 2021 18:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375062;
        bh=ntoSeY1may51ety/atua3izw2+UANxCK4CoOIwGTNRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Uf8J9jJpxQ9ICepmaznyxkVeTiDaXFhHrvTca+S2jySp04WuAbhlvZ/NJOZXWI0J
         4I8RQjYcMkFxP49+GN8MJL86bqZXY19CNeHC9E+ONGHT1Nzo4A01pZW/V8O+suHj6w
         WU8coyBWNFaOAPfp8STAxOp9JapkfcdO0ILo7HPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yejune Deng <yejune.deng@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 5.10 141/215] io_uring: simplify io_remove_personalities()
Date:   Thu, 15 Jul 2021 20:38:33 +0200
Message-Id: <20210715182624.489114043@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yejune Deng <yejune.deng@gmail.com>

commit 0bead8cd39b9c9c7c4e902018ccf129107ac50ef upstream.

The function io_remove_personalities() is very similar to
io_unregister_personality(),so implement io_remove_personalities()
calling io_unregister_personality().

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8505,9 +8505,8 @@ static int io_uring_fasync(int fd, struc
 	return fasync_helper(fd, file, on, &ctx->cq_fasync);
 }
 
-static int io_remove_personalities(int id, void *p, void *data)
+static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
 {
-	struct io_ring_ctx *ctx = data;
 	struct io_identity *iod;
 
 	iod = idr_remove(&ctx->personality_idr, id);
@@ -8515,7 +8514,17 @@ static int io_remove_personalities(int i
 		put_cred(iod->creds);
 		if (refcount_dec_and_test(&iod->count))
 			kfree(iod);
+		return 0;
 	}
+
+	return -EINVAL;
+}
+
+static int io_remove_personalities(int id, void *p, void *data)
+{
+	struct io_ring_ctx *ctx = data;
+
+	io_unregister_personality(ctx, id);
 	return 0;
 }
 
@@ -9606,21 +9615,6 @@ static int io_register_personality(struc
 	return ret;
 }
 
-static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
-{
-	struct io_identity *iod;
-
-	iod = idr_remove(&ctx->personality_idr, id);
-	if (iod) {
-		put_cred(iod->creds);
-		if (refcount_dec_and_test(&iod->count))
-			kfree(iod);
-		return 0;
-	}
-
-	return -EINVAL;
-}
-
 static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
 				    unsigned int nr_args)
 {


