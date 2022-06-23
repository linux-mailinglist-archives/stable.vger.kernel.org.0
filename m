Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06773558448
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234434AbiFWRkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234726AbiFWRiJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:38:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE435522DF;
        Thu, 23 Jun 2022 10:07:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C94AB82499;
        Thu, 23 Jun 2022 17:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F083DC341C4;
        Thu, 23 Jun 2022 17:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004063;
        bh=IVqg8u+gF0ORv3w81IDPWbZ8HpMy12YNLIg3Mycg8fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G3c+Asdo/bCRibrZZGcg7vCAlIgDnRxr7kfjXMNP7ZR8HXqtkBSjSR6nJUDoBM8SS
         WvW4cQLwOtIlisnjGbpcSmVjV2b8uCMOALoWVkhc4IoAjJ5wD/mRetIqj7+rlviL7h
         TSLVdiQWPa/Mwcm2jeNExPoNj9Z9uGfYbJo9Thrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 174/237] random: credit architectural init the exact amount
Date:   Thu, 23 Jun 2022 18:43:28 +0200
Message-Id: <20220623164348.157793674@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
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
@@ -891,9 +891,8 @@ early_param("random.trust_bootloader", p
  */
 int __init random_init(const char *command_line)
 {
-	size_t i;
 	ktime_t now = ktime_get_real();
-	bool arch_init = true;
+	unsigned int i, arch_bytes;
 	unsigned long rv;
 
 #if defined(LATENT_ENTROPY_PLUGIN)
@@ -901,11 +900,12 @@ int __init random_init(const char *comma
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
@@ -916,8 +916,8 @@ int __init random_init(const char *comma
 
 	if (crng_ready())
 		crng_reseed();
-	else if (arch_init && trust_cpu)
-		credit_init_bits(BLAKE2S_BLOCK_SIZE * 8);
+	else if (trust_cpu)
+		credit_init_bits(arch_bytes * 8);
 
 	return 0;
 }


