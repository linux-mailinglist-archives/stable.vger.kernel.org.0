Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66C4C10179B
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729578AbfKSFlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:41:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:36390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728636AbfKSFlu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:41:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E77C21939;
        Tue, 19 Nov 2019 05:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142109;
        bh=lA9ReJAonRl749F32IGcIapOZ9Sgo4WuiE5TEmF+pk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ei2weQGZ1nM5lMssZPuEfY5wX02PjGL1B9ObXrRNhpDrSMLBOLwS5Uc5jmuM3ogXH
         d/wqgzqTtyzbjJ8DZtndhK52PhF850xQ5LLPpjmk132A1niSHb01M0DNccFOoIZaMY
         ckDWgxaFkAqKp3uZJHeIFBrpFg/2NWo6s4wTCxn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Dan Aloni <dan@kernelim.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 390/422] crypto: fix a memory leak in rsa-kcs1pads encryption mode
Date:   Tue, 19 Nov 2019 06:19:47 +0100
Message-Id: <20191119051424.384280022@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 9893dbfc1af45..812476e468213 100644
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



