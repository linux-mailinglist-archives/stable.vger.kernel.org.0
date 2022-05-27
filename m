Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD289535CBF
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 11:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350304AbiE0I6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 04:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345982AbiE0I6E (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 04:58:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42323119909;
        Fri, 27 May 2022 01:54:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 666DA61D52;
        Fri, 27 May 2022 08:54:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3923AC385A9;
        Fri, 27 May 2022 08:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641685;
        bh=++xc5O0Pwzj5zTbMW+RdWvafvORy33rPu/1F0IGR7Uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eee3oIAUoQTm8G5AeFhfGPKj7MzpU8fGv/mBbXFpmPxVrJ9N63UZYoZ4tI6QaiiAl
         kd542vekUCQCCDlzaHrBlrgT3VvdfPnyui0HGu0bmJsbRBmIXjkQy4uQNvt1vON3B5
         jy2c3uP7fg7WURbG9ju2kdA/KPRfN9et2OrAYvCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.18 34/47] random: credit architectural init the exact amount
Date:   Fri, 27 May 2022 10:50:14 +0200
Message-Id: <20220527084807.032837553@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084801.223648383@linuxfoundation.org>
References: <20220527084801.223648383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 12e45a2a6308105469968951e6d563e8f4fea187 upstream.

RDRAND and RDSEED can fail sometimes, which is fine. We currently
initialize the RNG with 512 bits of RDRAND/RDSEED. We only need 256 bits
of those to succeed in order to initialize the RNG. Instead of the
current "all or nothing" approach, actually credit these contributions
the amount that is actually contributed.

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -899,9 +899,8 @@ early_param("random.trust_bootloader", p
  */
 int __init random_init(const char *command_line)
 {
-	size_t i;
 	ktime_t now = ktime_get_real();
-	bool arch_init = true;
+	unsigned int i, arch_bytes;
 	unsigned long rv;
 
 #if defined(LATENT_ENTROPY_PLUGIN)
@@ -909,11 +908,12 @@ int __init random_init(const char *comma
 	_mix_pool_bytes(compiletime_seed, sizeof(compiletime_seed));
 #endif
 
-	for (i = 0; i < BLAKE2S_BLOCK_SIZE; i += sizeof(rv)) {
+	for (i = 0, arch_bytes = BLAKE2S_BLOCK_SIZE;
+	     i < BLAKE2S_BLOCK_SIZE; i += sizeof(rv)) {
 		if (!arch_get_random_seed_long_early(&rv) &&
 		    !arch_get_random_long_early(&rv)) {
 			rv = random_get_entropy();
-			arch_init = false;
+			arch_bytes -= sizeof(rv);
 		}
 		_mix_pool_bytes(&rv, sizeof(rv));
 	}
@@ -924,8 +924,8 @@ int __init random_init(const char *comma
 
 	if (crng_ready())
 		crng_reseed();
-	else if (arch_init && trust_cpu)
-		credit_init_bits(BLAKE2S_BLOCK_SIZE * 8);
+	else if (trust_cpu)
+		credit_init_bits(arch_bytes * 8);
 
 	return 0;
 }


