Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5C65360B5
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241986AbiE0Lvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352552AbiE0Lue (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:50:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F02715350F;
        Fri, 27 May 2022 04:44:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B200BB824DD;
        Fri, 27 May 2022 11:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC02CC385A9;
        Fri, 27 May 2022 11:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651886;
        bh=XxK0OtvwNhgUMCOyhriJ/+qNy/K+HjGgOW3wfyCgR3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UQRSsTAjTWeY1zPLwxjXovycztF++NMEBywwsEnhcN3GKemdv9+lru7nYcPKFF1bC
         0R/e3dZZn9uaaTvt2cTjHErXyEMYnQhmVTnN3RHiwIH9Kr7oPlSRtzMEpx9RKiBAmt
         iWw8naPP187ytx5tr4NqznS48IlWgygBiCdawkh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 067/163] random: ensure early RDSEED goes through mixer on init
Date:   Fri, 27 May 2022 10:49:07 +0200
Message-Id: <20220527084837.297905410@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
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

commit a02cf3d0dd77244fd5333ac48d78871de459ae6d upstream.

Continuing the reasoning of "random: use RDSEED instead of RDRAND in
entropy extraction" from this series, at init time we also don't want to
be xoring RDSEED directly into the crng. Instead it's safer to put it
into our entropy collector and then re-extract it, so that it goes
through a hash function with preimage resistance. As a matter of hygiene,
we also order these now so that the RDSEED byte are hashed in first,
followed by the bytes that are likely more predictable (e.g. utsname()).

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1208,24 +1208,18 @@ int __init rand_initialize(void)
 	bool arch_init = true;
 	unsigned long rv;
 
-	mix_pool_bytes(&now, sizeof(now));
 	for (i = BLAKE2S_BLOCK_SIZE; i > 0; i -= sizeof(rv)) {
-		if (!arch_get_random_seed_long(&rv) &&
-		    !arch_get_random_long(&rv))
-			rv = random_get_entropy();
-		mix_pool_bytes(&rv, sizeof(rv));
-	}
-	mix_pool_bytes(utsname(), sizeof(*(utsname())));
-
-	extract_entropy(&primary_crng.state[4], sizeof(u32) * 12);
-	for (i = 4; i < 16; i++) {
 		if (!arch_get_random_seed_long_early(&rv) &&
 		    !arch_get_random_long_early(&rv)) {
 			rv = random_get_entropy();
 			arch_init = false;
 		}
-		primary_crng.state[i] ^= rv;
+		mix_pool_bytes(&rv, sizeof(rv));
 	}
+	mix_pool_bytes(&now, sizeof(now));
+	mix_pool_bytes(utsname(), sizeof(*(utsname())));
+
+	extract_entropy(&primary_crng.state[4], sizeof(u32) * 12);
 	if (arch_init && trust_cpu && crng_init < 2) {
 		invalidate_batched_entropy();
 		crng_init = 2;


