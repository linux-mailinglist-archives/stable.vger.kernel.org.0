Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F3F551C65
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345221AbiFTNcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345367AbiFTNcW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:32:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A8725C7E;
        Mon, 20 Jun 2022 06:12:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE65C60EA0;
        Mon, 20 Jun 2022 13:12:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12F7C3411B;
        Mon, 20 Jun 2022 13:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730756;
        bh=YAUKsAuc2AWmejvbJm7d9pwZjKJnlLRzpTNJ8hmemsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UTQRJShqMOXB0Y0IN3t+GwPpixNAQt77iJ+5/jE5UHZXA1Xesuh8v3uE2T12b1Vka
         f44cQfRs/qQrTxW8GQf7Gv6SY+WDfx2Cm3/Dnkf0tRhsLK0sVZs1AmDHHSysNcffwB
         ntSX3i4wj72AuM06272gN4SNm0xxK2P0lO0ivSWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 046/240] random: early initialization of ChaCha constants
Date:   Mon, 20 Jun 2022 14:49:07 +0200
Message-Id: <20220620124739.403999643@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dominik Brodowski <linux@dominikbrodowski.net>

commit 96562f286884e2db89c74215b199a1084b5fb7f7 upstream.

Previously, the ChaCha constants for the primary pool were only
initialized in crng_initialize_primary(), called by rand_initialize().
However, some randomness is actually extracted from the primary pool
beforehand, e.g. by kmem_cache_create(). Therefore, statically
initialize the ChaCha constants for the primary pool.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <linux-crypto@vger.kernel.org>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c   |    5 ++++-
 include/crypto/chacha.h |   15 +++++++++++----
 2 files changed, 15 insertions(+), 5 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -458,6 +458,10 @@ struct crng_state {
 
 static struct crng_state primary_crng = {
 	.lock = __SPIN_LOCK_UNLOCKED(primary_crng.lock),
+	.state[0] = CHACHA_CONSTANT_EXPA,
+	.state[1] = CHACHA_CONSTANT_ND_3,
+	.state[2] = CHACHA_CONSTANT_2_BY,
+	.state[3] = CHACHA_CONSTANT_TE_K,
 };
 
 /*
@@ -824,7 +828,6 @@ static void crng_initialize_secondary(st
 
 static void __init crng_initialize_primary(struct crng_state *crng)
 {
-	chacha_init_consts(crng->state);
 	_extract_entropy(&input_pool, &crng->state[4], sizeof(__u32) * 12, 0);
 	if (crng_init_try_arch_early(crng) && trust_cpu && crng_init < 2) {
 		invalidate_batched_entropy();
--- a/include/crypto/chacha.h
+++ b/include/crypto/chacha.h
@@ -51,12 +51,19 @@ int crypto_chacha12_setkey(struct crypto
 int crypto_chacha_crypt(struct skcipher_request *req);
 int crypto_xchacha_crypt(struct skcipher_request *req);
 
+enum chacha_constants { /* expand 32-byte k */
+	CHACHA_CONSTANT_EXPA = 0x61707865U,
+	CHACHA_CONSTANT_ND_3 = 0x3320646eU,
+	CHACHA_CONSTANT_2_BY = 0x79622d32U,
+	CHACHA_CONSTANT_TE_K = 0x6b206574U
+};
+
 static inline void chacha_init_consts(u32 *state)
 {
-	state[0]  = 0x61707865; /* "expa" */
-	state[1]  = 0x3320646e; /* "nd 3" */
-	state[2]  = 0x79622d32; /* "2-by" */
-	state[3]  = 0x6b206574; /* "te k" */
+	state[0]  = CHACHA_CONSTANT_EXPA;
+	state[1]  = CHACHA_CONSTANT_ND_3;
+	state[2]  = CHACHA_CONSTANT_2_BY;
+	state[3]  = CHACHA_CONSTANT_TE_K;
 }
 
 #endif /* _CRYPTO_CHACHA_H */


