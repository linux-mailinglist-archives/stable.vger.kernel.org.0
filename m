Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15EED551AE1
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347008AbiFTNgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345367AbiFTNed (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:34:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C268827B3E;
        Mon, 20 Jun 2022 06:13:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B548DCE13A2;
        Mon, 20 Jun 2022 13:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DD9C3411B;
        Mon, 20 Jun 2022 13:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730753;
        bh=EOyGJvefq2eF+pEG+3TukxCC4TntO2teRjLIgcGVDbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JNPGAy3K4HJ0TC+xSXCn33quZYLdWh5PXlJiJ7Rn+i/1KrM1HjIlbiBhta9QPky6P
         6p6coYlugh4+0AxNFEgV+TbmVaYSALC+0FDrjQLDWb/c4hK3/v+sZ/FQCfIKX9ied1
         gpHdFbNNpJrOoRHCzB7Q8nmzkd+n7RiXklVaSLBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Jann Horn <jannh@google.com>, Theodore Tso <tytso@mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 045/240] random: initialize ChaCha20 constants with correct endianness
Date:   Mon, 20 Jun 2022 14:49:06 +0200
Message-Id: <20220620124739.358974199@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@google.com>

commit a181e0fdb2164268274453b5b291589edbb9b22d upstream.

On big endian CPUs, the ChaCha20-based CRNG is using the wrong
endianness for the ChaCha20 constants.

This doesn't matter cryptographically, but technically it means it's not
ChaCha20 anymore.  Fix it to always use the standard constants.

Cc: linux-crypto@vger.kernel.org
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c   |    4 ++--
 include/crypto/chacha.h |    8 ++++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -816,7 +816,7 @@ static bool __init crng_init_try_arch_ea
 
 static void crng_initialize_secondary(struct crng_state *crng)
 {
-	memcpy(&crng->state[0], "expand 32-byte k", 16);
+	chacha_init_consts(crng->state);
 	_get_random_bytes(&crng->state[4], sizeof(__u32) * 12);
 	crng_init_try_arch(crng);
 	crng->init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
@@ -824,7 +824,7 @@ static void crng_initialize_secondary(st
 
 static void __init crng_initialize_primary(struct crng_state *crng)
 {
-	memcpy(&crng->state[0], "expand 32-byte k", 16);
+	chacha_init_consts(crng->state);
 	_extract_entropy(&input_pool, &crng->state[4], sizeof(__u32) * 12, 0);
 	if (crng_init_try_arch_early(crng) && trust_cpu && crng_init < 2) {
 		invalidate_batched_entropy();
--- a/include/crypto/chacha.h
+++ b/include/crypto/chacha.h
@@ -51,4 +51,12 @@ int crypto_chacha12_setkey(struct crypto
 int crypto_chacha_crypt(struct skcipher_request *req);
 int crypto_xchacha_crypt(struct skcipher_request *req);
 
+static inline void chacha_init_consts(u32 *state)
+{
+	state[0]  = 0x61707865; /* "expa" */
+	state[1]  = 0x3320646e; /* "nd 3" */
+	state[2]  = 0x79622d32; /* "2-by" */
+	state[3]  = 0x6b206574; /* "te k" */
+}
+
 #endif /* _CRYPTO_CHACHA_H */


