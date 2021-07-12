Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB5F3C4B80
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240012AbhGLG5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:57:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238138AbhGLG4p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:56:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C6F9613D8;
        Mon, 12 Jul 2021 06:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072835;
        bh=T514FKVQHpdtGynVP9Rb6yceVV44jJ/7xXUG8NIatSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jww5lTLunfCRJZ+7zSa3du19gtgwUpcAY/+TuGpN2pVUZUwNL6iGlZQBw9KLB2oXB
         uf8V/Q+AsvTmfsIeDfOGjEaVExT51AFK/qdWdvPNLIcSS0Wzjo8dz2HifdzJxIp6X4
         eeyqOdOZOEcB2BSrdUtihguygjKxAAE3d6oHTh7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.12 038/700] crypto: nx - Fix memcpy() over-reading in nonce
Date:   Mon, 12 Jul 2021 08:02:01 +0200
Message-Id: <20210712060930.019694796@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 74c66120fda6596ad57f41e1607b3a5d51ca143d upstream.

Fix typo in memcpy() where size should be CTR_RFC3686_NONCE_SIZE.

Fixes: 030f4e968741 ("crypto: nx - Fix reentrancy bugs")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/nx/nx-aes-ctr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/nx/nx-aes-ctr.c
+++ b/drivers/crypto/nx/nx-aes-ctr.c
@@ -118,7 +118,7 @@ static int ctr3686_aes_nx_crypt(struct s
 	struct nx_crypto_ctx *nx_ctx = crypto_skcipher_ctx(tfm);
 	u8 iv[16];
 
-	memcpy(iv, nx_ctx->priv.ctr.nonce, CTR_RFC3686_IV_SIZE);
+	memcpy(iv, nx_ctx->priv.ctr.nonce, CTR_RFC3686_NONCE_SIZE);
 	memcpy(iv + CTR_RFC3686_NONCE_SIZE, req->iv, CTR_RFC3686_IV_SIZE);
 	iv[12] = iv[13] = iv[14] = 0;
 	iv[15] = 1;


