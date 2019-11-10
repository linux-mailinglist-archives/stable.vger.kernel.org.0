Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC0D1F6332
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729663AbfKJCuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:50:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:33316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728517AbfKJCuQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:50:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBA0E229EF;
        Sun, 10 Nov 2019 02:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354215;
        bh=SbUN0yYZmzZAvFPcXi0mVND1v/e7vZHcGEaSQBWDqX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IsCsycMFTxQPXQpaGzznz1cSjrDPjJxtohI52dLmsrzVgAve+qRvpkhmMok3hu6Rk
         bTaWxwD3pvCSZ0GNG6pLFwrzDD9+Xwliuv5G0N7jbbZm0wj/9MqdmLWxsGH9j9GT7i
         qmNXEtSSmm3c7w7JwdrA6ySoL30geJSOLyn6Uccw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Aloni <dan@kernelim.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 54/66] crypto: fix a memory leak in rsa-kcs1pad's encryption mode
Date:   Sat,  9 Nov 2019 21:48:33 -0500
Message-Id: <20191110024846.32598-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024846.32598-1-sashal@kernel.org>
References: <20191110024846.32598-1-sashal@kernel.org>
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
index 7830d304dff6f..d58224d808675 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -267,15 +267,6 @@ static int pkcs1pad_encrypt(struct akcipher_request *req)
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

