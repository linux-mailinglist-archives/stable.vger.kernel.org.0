Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDE067F403
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403838AbfHBJnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:43:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405041AbfHBJnX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:43:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20EB62086A;
        Fri,  2 Aug 2019 09:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739002;
        bh=LAmkjEwhid63sirkScRRXNDpcozyqShGeB5vrWUB9zU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0ZsLGmLObgbQln/mx5rYKgN1LnSjZ35xhfcWuJqBWtKj6+tmsWkY2Hvqk+tpGhEw
         55Vuv00RST56fHfrVsDBe++ubxVcIb/l0+7aikXe67rNDl8jsvm1sKO+dIScFnnYCx
         x8+MIGu3kQKMWTD1tDjQ2cZZxD/5NV/qdVBt97YY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Elena Petrova <lenaptr@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.9 079/223] crypto: arm64/sha1-ce - correct digest for empty data in finup
Date:   Fri,  2 Aug 2019 11:35:04 +0200
Message-Id: <20190802092244.028452893@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Elena Petrova <lenaptr@google.com>

commit 1d4aaf16defa86d2665ae7db0259d6cb07e2091f upstream.

The sha1-ce finup implementation for ARM64 produces wrong digest
for empty input (len=0). Expected: da39a3ee..., result: 67452301...
(initial value of SHA internal state). The error is in sha1_ce_finup:
for empty data `finalize` will be 1, so the code is relying on
sha1_ce_transform to make the final round. However, in
sha1_base_do_update, the block function will not be called when
len == 0.

Fix it by setting finalize to 0 if data is empty.

Fixes: 07eb54d306f4 ("crypto: arm64/sha1-ce - move SHA-1 ARMv8 implementation to base layer")
Cc: stable@vger.kernel.org
Signed-off-by: Elena Petrova <lenaptr@google.com>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/crypto/sha1-ce-glue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/crypto/sha1-ce-glue.c
+++ b/arch/arm64/crypto/sha1-ce-glue.c
@@ -50,7 +50,7 @@ static int sha1_ce_finup(struct shash_de
 			 unsigned int len, u8 *out)
 {
 	struct sha1_ce_state *sctx = shash_desc_ctx(desc);
-	bool finalize = !sctx->sst.count && !(len % SHA1_BLOCK_SIZE);
+	bool finalize = !sctx->sst.count && !(len % SHA1_BLOCK_SIZE) && len;
 
 	/*
 	 * Allow the asm code to perform the finalization if there is no


