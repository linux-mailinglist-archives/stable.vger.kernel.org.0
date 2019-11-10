Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30452F6416
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729468AbfKJC4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:56:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:47276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729432AbfKJC4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:56:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87037224BD;
        Sun, 10 Nov 2019 02:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354092;
        bh=yNy5f3Bw3KkD7wJrL+SQzTMJT5C/90GVEYL0GQQQ3zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bt4baJuhfbcLsBNC2TpXD4jAMaMETTBhfbeekqCL0T9fRwGrLB0dzxgZJ2Gd+6syG
         /TKrSbkdLJI3xhmag5YjVTW4xa1M15bwBQIy7ik6numb9K7dHzjfcgaDYVO8avO96p
         NBKSjacOU8fIrMb5IiAyV1k9hYBEiOD0F2tcHisc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Aloni <dan@kernelim.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 087/109] crypto: fix a memory leak in rsa-kcs1pad's encryption mode
Date:   Sat,  9 Nov 2019 21:45:19 -0500
Message-Id: <20191110024541.31567-87-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Aloni <dan@kernelim.com>

[ Upstream commit 3944f139d5592790b70bc64f197162e643a8512b ]

The encryption mode of pkcs1pad never uses out_sg and out_buf, so
there's no need to allocate the buffer, which presently is not even
being freed.

CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: linux-crypto@vger.kernel.org
CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Dan Aloni <dan@kernelim.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/rsa-pkcs1pad.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 407c64bdcdd9a..3279b457c4ede 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -261,15 +261,6 @@ static int pkcs1pad_encrypt(struct akcipher_request *req)
 	pkcs1pad_sg_set_buf(req_ctx->in_sg, req_ctx->in_buf,
 			ctx->key_size - 1 - req->src_len, req->src);
 
-	req_ctx->out_buf = kmalloc(ctx->key_size, GFP_KERNEL);
-	if (!req_ctx->out_buf) {
-		kfree(req_ctx->in_buf);
-		return -ENOMEM;
-	}
-
-	pkcs1pad_sg_set_buf(req_ctx->out_sg, req_ctx->out_buf,
-			ctx->key_size, NULL);
-
 	akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
 	akcipher_request_set_callback(&req_ctx->child_req, req->base.flags,
 			pkcs1pad_encrypt_sign_complete_cb, req);
-- 
2.20.1

