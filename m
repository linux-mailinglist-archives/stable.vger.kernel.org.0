Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A89E551BBD
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346440AbiFTNjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346930AbiFTNiC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:38:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F651F2DA;
        Mon, 20 Jun 2022 06:14:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F41FB60A21;
        Mon, 20 Jun 2022 13:14:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008FDC3411C;
        Mon, 20 Jun 2022 13:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730850;
        bh=XxK0OtvwNhgUMCOyhriJ/+qNy/K+HjGgOW3wfyCgR3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iy0fn3K5kTz3c8H0QVEhk0cqLfticW76N0FARTivMB9rylQiSDG+cXeeDEfBfJ95v
         2747trTdywZdAdIAkbeBYx+S+810mM8QTz9XSR+vxowdHgMxv5Msvo8is0Q8WSDWg1
         GLe1Egt8tWo7YLniNftM+bHlpXBpO/SeKwm1jdiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 076/240] random: ensure early RDSEED goes through mixer on init
Date:   Mon, 20 Jun 2022 14:49:37 +0200
Message-Id: <20220620124740.824953394@linuxfoundation.org>
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


