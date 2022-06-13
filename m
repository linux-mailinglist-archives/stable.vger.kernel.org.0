Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB70548180
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 10:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbiFMIJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 04:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239553AbiFMIJJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 04:09:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363891E3CC
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 01:09:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3ADAB80D9B
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 08:09:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7873BC34114;
        Mon, 13 Jun 2022 08:09:04 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="K7naIEW2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1655107743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PkHDkh5htAaPjOIzAT54jwJt+Fef7oNi00rZklkuNrc=;
        b=K7naIEW2qHkzQCdBeTHMznKloQmSqGMAfpCYMSnUanIStjMut+4K+bUbg7xzvcodjec+jP
        aB4VPQ/Scto8QRCoEYxKuSPIEpZofsqCfCWb+S9Gg8GUARak6+zxVsGRRyE6yLnEsY6nCv
        pXrpNAYGCmEV+Ydom0ClNXmg6uS5u+c=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7bba6be0 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 13 Jun 2022 08:09:03 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Subject: [PATCH stable 5.18 5.17 5.15 5.10 3/3] random: account for arch randomness in bits
Date:   Mon, 13 Jun 2022 10:07:49 +0200
Message-Id: <20220613080749.153222-4-Jason@zx2c4.com>
In-Reply-To: <20220613080749.153222-1-Jason@zx2c4.com>
References: <20220613080749.153222-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 77fc95f8c0dc9e1f8e620ec14d2fb65028fb7adc upstream.

Rather than accounting in bytes and multiplying (shifting), we can just
account in bits and avoid the shift. The main motivation for this is
there are other patches in flux that expand this code a bit, and
avoiding the duplication of "* 8" everywhere makes things a bit clearer.

Cc: stable@vger.kernel.org
Fixes: 12e45a2a6308 ("random: credit architectural init the exact amount")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/char/random.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index d09e78e6f24b..82f9ee440406 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -809,7 +809,7 @@ early_param("random.trust_bootloader", parse_trust_bootloader);
 int __init random_init(const char *command_line)
 {
 	ktime_t now = ktime_get_real();
-	unsigned int i, arch_bytes;
+	unsigned int i, arch_bits;
 	unsigned long entropy;
 
 #if defined(LATENT_ENTROPY_PLUGIN)
@@ -817,12 +817,12 @@ int __init random_init(const char *command_line)
 	_mix_pool_bytes(compiletime_seed, sizeof(compiletime_seed));
 #endif
 
-	for (i = 0, arch_bytes = BLAKE2S_BLOCK_SIZE;
+	for (i = 0, arch_bits = BLAKE2S_BLOCK_SIZE * 8;
 	     i < BLAKE2S_BLOCK_SIZE; i += sizeof(entropy)) {
 		if (!arch_get_random_seed_long_early(&entropy) &&
 		    !arch_get_random_long_early(&entropy)) {
 			entropy = random_get_entropy();
-			arch_bytes -= sizeof(entropy);
+			arch_bits -= sizeof(entropy) * 8;
 		}
 		_mix_pool_bytes(&entropy, sizeof(entropy));
 	}
@@ -834,7 +834,7 @@ int __init random_init(const char *command_line)
 	if (crng_ready())
 		crng_reseed();
 	else if (trust_cpu)
-		_credit_init_bits(arch_bytes * 8);
+		_credit_init_bits(arch_bits);
 
 	return 0;
 }
-- 
2.35.1

