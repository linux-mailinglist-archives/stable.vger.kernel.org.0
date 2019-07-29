Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE4C179918
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbfG2T3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:29:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728828AbfG2T3o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:29:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 173A22070B;
        Mon, 29 Jul 2019 19:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428583;
        bh=YeaONwwOYtzz3Ca9+yCTMwQL28bim9Ud+LLFomi6VwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JNRoRsmqXIR1TrFjP5wkjfx6FwRvbE24obLqHenxhB1B0jzB+mFR7n9mWabRPR/+a
         ZP747MQvotJdnWysIGn9GAvLr21K+uBmFNQLB39E/WzxN1YXKjNlLJ+oIgSzQKOz2U
         KPXX1uS4dYGiithb+Zm0Dr49jKExvG1SsUZ5d170=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Elena Petrova <lenaptr@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.14 122/293] crypto: arm64/sha2-ce - correct digest for empty data in finup
Date:   Mon, 29 Jul 2019 21:20:13 +0200
Message-Id: <20190729190833.942059019@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
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
@@ -59,7 +59,7 @@ static int sha256_ce_finup(struct shash_
 			   unsigned int len, u8 *out)
 {
 	struct sha256_ce_state *sctx = shash_desc_ctx(desc);
-	bool finalize = !sctx->sst.count && !(len % SHA256_BLOCK_SIZE);
+	bool finalize = !sctx->sst.count && !(len % SHA256_BLOCK_SIZE) && len;
 
 	if (!may_use_simd()) {
 		if (len)


