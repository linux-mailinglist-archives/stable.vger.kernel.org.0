Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57704536123
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352145AbiE0L6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352964AbiE0Lzr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:55:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7354115E48D;
        Fri, 27 May 2022 04:49:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F14261DCD;
        Fri, 27 May 2022 11:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13377C34100;
        Fri, 27 May 2022 11:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652163;
        bh=ChiaIZr1vsSofutuIfWteJdrMYIRuuJnUyBWrXPNdc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ADUxF9i8Gi408jjYHW1zuQFG+ocxabxrx/J4dvXUnYVDJ8KYaq5M8ofo5TnpSaQvQ
         BMY2Ajz8FnDDW3FNVaHiD92n/EW6f8JjLvuQg52Sm7Jb9kS5ISBIFXjNPWFedpm2uw
         /0E+HeSUJV33oPUQG6vYpkwrgN2+hemJO6KbyXTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 107/163] random: reseed more often immediately after booting
Date:   Fri, 27 May 2022 10:49:47 +0200
Message-Id: <20220527084842.940154861@linuxfoundation.org>
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

commit 7a7ff644aeaf071d433caffb3b8ea57354b55bd3 upstream.

In order to chip away at the "premature first" problem, we augment our
existing entropy accounting with more frequent reseedings at boot.

The idea is that at boot, we're getting entropy from various places, and
we're not very sure which of early boot entropy is good and which isn't.
Even when we're crediting the entropy, we're still not totally certain
that it's any good. Since boot is the one time (aside from a compromise)
that we have zero entropy, it's important that we shepherd entropy into
the crng fairly often.

At the same time, we don't want a "premature next" problem, whereby an
attacker can brute force individual bits of added entropy. In lieu of
going full-on Fortuna (for now), we can pick a simpler strategy of just
reseeding more often during the first 5 minutes after boot. This is
still bounded by the 256-bit entropy credit requirement, so we'll skip a
reseeding if we haven't reached that, but in case entropy /is/ coming
in, this ensures that it makes its way into the crng rather rapidly
during these early stages.

Ordinarily we reseed if the previous reseeding is 300 seconds old. This
commit changes things so that for the first 600 seconds of boot time, we
reseed if the previous reseeding is uptime / 2 seconds old. That means
that we'll reseed at the very least double the uptime of the previous
reseeding.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -338,6 +338,28 @@ static void crng_fast_key_erasure(u8 key
 }
 
 /*
+ * Return whether the crng seed is considered to be sufficiently
+ * old that a reseeding might be attempted. This happens if the last
+ * reseeding was CRNG_RESEED_INTERVAL ago, or during early boot, at
+ * an interval proportional to the uptime.
+ */
+static bool crng_has_old_seed(void)
+{
+	static bool early_boot = true;
+	unsigned long interval = CRNG_RESEED_INTERVAL;
+
+	if (unlikely(READ_ONCE(early_boot))) {
+		time64_t uptime = ktime_get_seconds();
+		if (uptime >= CRNG_RESEED_INTERVAL / HZ * 2)
+			WRITE_ONCE(early_boot, false);
+		else
+			interval = max_t(unsigned int, 5 * HZ,
+					 (unsigned int)uptime / 2 * HZ);
+	}
+	return time_after(jiffies, READ_ONCE(base_crng.birth) + interval);
+}
+
+/*
  * This function returns a ChaCha state that you may use for generating
  * random data. It also returns up to 32 bytes on its own of random data
  * that may be used; random_data_len may not be greater than 32.
@@ -370,10 +392,10 @@ static void crng_make_state(u32 chacha_s
 	}
 
 	/*
-	 * If the base_crng is more than 5 minutes old, we reseed, which
-	 * in turn bumps the generation counter that we check below.
+	 * If the base_crng is old enough, we try to reseed, which in turn
+	 * bumps the generation counter that we check below.
 	 */
-	if (unlikely(time_after(jiffies, READ_ONCE(base_crng.birth) + CRNG_RESEED_INTERVAL)))
+	if (unlikely(crng_has_old_seed()))
 		crng_reseed();
 
 	local_lock_irqsave(&crngs.lock, flags);


