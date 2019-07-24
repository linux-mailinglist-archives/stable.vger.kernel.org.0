Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0163E73ED1
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387897AbfGXU1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:27:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:32878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388732AbfGXTff (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:35:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41B6920659;
        Wed, 24 Jul 2019 19:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996934;
        bh=fscD1M0kGe5cJAtTte+v+8R2IabriR1KWAiG6awfUMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fhdl4ZDgZpApnIJm5iThf3DcUpJvmdyJoMLszABo+6I8tj3z/vZD2SyO/Ug4lz7nx
         7yqf73BNTqHmRC4VY1IshEp/QeCqCJhVMF/GUbz+pXOWtETPbIs8nspDZ3zJsicl2n
         bBRxsL78X6qzXMI5lSzDvSrSENLPq7qW67mKctl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Elena Petrova <lenaptr@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.2 267/413] crypto: arm64/sha2-ce - correct digest for empty data in finup
Date:   Wed, 24 Jul 2019 21:19:18 +0200
Message-Id: <20190724191755.303808871@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Elena Petrova <lenaptr@google.com>

commit 6bd934de1e393466b319d29c4427598fda096c57 upstream.

The sha256-ce finup implementation for ARM64 produces wrong digest
for empty input (len=0). Expected: the actual digest, result: initial
value of SHA internal state. The error is in sha256_ce_finup:
for empty data `finalize` will be 1, so the code is relying on
sha2_ce_transform to make the final round. However, in
sha256_base_do_update, the block function will not be called when
len == 0.

Fix it by setting finalize to 0 if data is empty.

Fixes: 03802f6a80b3a ("crypto: arm64/sha2-ce - move SHA-224/256 ARMv8 implementation to base layer")
Cc: stable@vger.kernel.org
Signed-off-by: Elena Petrova <lenaptr@google.com>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/crypto/sha2-ce-glue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/crypto/sha2-ce-glue.c
+++ b/arch/arm64/crypto/sha2-ce-glue.c
@@ -57,7 +57,7 @@ static int sha256_ce_finup(struct shash_
 			   unsigned int len, u8 *out)
 {
 	struct sha256_ce_state *sctx = shash_desc_ctx(desc);
-	bool finalize = !sctx->sst.count && !(len % SHA256_BLOCK_SIZE);
+	bool finalize = !sctx->sst.count && !(len % SHA256_BLOCK_SIZE) && len;
 
 	if (!crypto_simd_usable()) {
 		if (len)


