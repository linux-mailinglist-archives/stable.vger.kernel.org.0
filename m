Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A38182366F
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389317AbfETMpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:45:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389314AbfETM03 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:26:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05D32216E3;
        Mon, 20 May 2019 12:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355188;
        bh=34pvu7oNa5wqsc3tntV2i9diO3rjJi8DbuOwL65B550=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bGiv9rBhQiH1vVMptygXdJH6o+tf+3kpqxgjynFxCksdhanHL3yvPRQaiu89w8Vkq
         fm7d5IZ9kTLsZ2pSDiais0TZy69IYsMG47YO9Z/Ek6UgzzhKfiV3kxyayWtTvbRDyt
         4Jbv4Tus7X6V1L+O+w9+IzmfOa7bp4TBlr8zmuSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Lamparter <chunkeey@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.0 025/123] crypto: crypto4xx - fix ctr-aes missing output IV
Date:   Mon, 20 May 2019 14:13:25 +0200
Message-Id: <20190520115246.489707940@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>

commit 25baaf8e2c93197d063b372ef7b62f2767c7ac0b upstream.

Commit 8efd972ef96a ("crypto: testmgr - support checking skcipher output IV")
caused the crypto4xx driver to produce the following error:

| ctr-aes-ppc4xx encryption test failed (wrong output IV)
| on test vector 0, cfg="in-place"

This patch fixes this by reworking the crypto4xx_setkey_aes()
function to:

 - not save the iv for ECB (as per 18.2.38 CRYP0_SA_CMD_0:
   "This bit mut be cleared for DES ECB mode or AES ECB mode,
   when no IV is used.")

 - instruct the hardware to save the generated IV for all
   other modes of operations that have IV and then supply
   it back to the callee in pretty much the same way as we
   do it for cbc-aes already.

 - make it clear that the DIR_(IN|OUT)BOUND is the important
   bit that tells the hardware to encrypt or decrypt the data.
   (this is cosmetic - but it hopefully prevents me from
    getting confused again).

 - don't load any bogus hash when we don't use any hash
   operation to begin with.

Cc: stable@vger.kernel.org
Fixes: f2a13e7cba9e ("crypto: crypto4xx - enable AES RFC3686, ECB, CFB and OFB offloads")
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/amcc/crypto4xx_alg.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -141,9 +141,10 @@ static int crypto4xx_setkey_aes(struct c
 	/* Setup SA */
 	sa = ctx->sa_in;
 
-	set_dynamic_sa_command_0(sa, SA_NOT_SAVE_HASH, (cm == CRYPTO_MODE_CBC ?
-				 SA_SAVE_IV : SA_NOT_SAVE_IV),
-				 SA_LOAD_HASH_FROM_SA, SA_LOAD_IV_FROM_STATE,
+	set_dynamic_sa_command_0(sa, SA_NOT_SAVE_HASH, (cm == CRYPTO_MODE_ECB ?
+				 SA_NOT_SAVE_IV : SA_SAVE_IV),
+				 SA_NOT_LOAD_HASH, (cm == CRYPTO_MODE_ECB ?
+				 SA_LOAD_IV_FROM_SA : SA_LOAD_IV_FROM_STATE),
 				 SA_NO_HEADER_PROC, SA_HASH_ALG_NULL,
 				 SA_CIPHER_ALG_AES, SA_PAD_TYPE_ZERO,
 				 SA_OP_GROUP_BASIC, SA_OPCODE_DECRYPT,
@@ -162,6 +163,11 @@ static int crypto4xx_setkey_aes(struct c
 	memcpy(ctx->sa_out, ctx->sa_in, ctx->sa_len * 4);
 	sa = ctx->sa_out;
 	sa->sa_command_0.bf.dir = DIR_OUTBOUND;
+	/*
+	 * SA_OPCODE_ENCRYPT is the same value as SA_OPCODE_DECRYPT.
+	 * it's the DIR_(IN|OUT)BOUND that matters
+	 */
+	sa->sa_command_0.bf.opcode = SA_OPCODE_ENCRYPT;
 
 	return 0;
 }


