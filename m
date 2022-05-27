Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE70D53618C
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238438AbiE0L6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353179AbiE0L4Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:56:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604CA134E3F;
        Fri, 27 May 2022 04:49:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1AE861D56;
        Fri, 27 May 2022 11:49:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC72FC385A9;
        Fri, 27 May 2022 11:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652196;
        bh=mZa8wpVOo+dJnkNkQMXBJ4VZGlqIRUrqht3GYNIezqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YU98psK8ECVovn56BuQyhCc1vT6/iTlAy1xIFmU4z1If5PW+jZKfkC05uNLK+/02R
         4WDPp3WKz2iuCLFW7L0buEwNmA2dsYxCO/Fcs+3m0PszHHlpEJKjVnUQ1KguzxpTyC
         7qLgFZ57/xcfbo7zwOYRMs3Diujw6yfNnbnaqatc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 088/145] random: make consistent usage of crng_ready()
Date:   Fri, 27 May 2022 10:49:49 +0200
Message-Id: <20220527084901.347242398@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084850.364560116@linuxfoundation.org>
References: <20220527084850.364560116@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit a96cfe2d427064325ecbf56df8816c6b871ec285 upstream.

Rather than sometimes checking `crng_init < 2`, we should always use the
crng_ready() macro, so that should we change anything later, it's
consistent. Additionally, that macro already has a likely() around it,
which means we don't need to open code our own likely() and unlikely()
annotations.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -125,18 +125,13 @@ static void try_to_generate_entropy(void
  */
 int wait_for_random_bytes(void)
 {
-	if (likely(crng_ready()))
-		return 0;
-
-	do {
+	while (!crng_ready()) {
 		int ret;
 		ret = wait_event_interruptible_timeout(crng_init_wait, crng_ready(), HZ);
 		if (ret)
 			return ret > 0 ? 0 : ret;
-
 		try_to_generate_entropy();
-	} while (!crng_ready());
-
+	}
 	return 0;
 }
 EXPORT_SYMBOL(wait_for_random_bytes);
@@ -293,7 +288,7 @@ static void crng_reseed(void)
 		++next_gen;
 	WRITE_ONCE(base_crng.generation, next_gen);
 	WRITE_ONCE(base_crng.birth, jiffies);
-	if (crng_init < 2) {
+	if (!crng_ready()) {
 		crng_init = 2;
 		finalize_init = true;
 	}
@@ -361,7 +356,7 @@ static void crng_make_state(u32 chacha_s
 	 * ready, we do fast key erasure with the base_crng directly, because
 	 * this is what crng_pre_init_inject() mutates during early init.
 	 */
-	if (unlikely(!crng_ready())) {
+	if (!crng_ready()) {
 		bool ready;
 
 		spin_lock_irqsave(&base_crng.lock, flags);
@@ -804,7 +799,7 @@ static void credit_entropy_bits(size_t n
 		entropy_count = min_t(unsigned int, POOL_BITS, orig + add);
 	} while (cmpxchg(&input_pool.entropy_count, orig, entropy_count) != orig);
 
-	if (crng_init < 2 && entropy_count >= POOL_MIN_BITS)
+	if (!crng_ready() && entropy_count >= POOL_MIN_BITS)
 		crng_reseed();
 }
 
@@ -961,7 +956,7 @@ int __init rand_initialize(void)
 	extract_entropy(base_crng.key, sizeof(base_crng.key));
 	++base_crng.generation;
 
-	if (arch_init && trust_cpu && crng_init < 2) {
+	if (arch_init && trust_cpu && !crng_ready()) {
 		crng_init = 2;
 		pr_notice("crng init done (trusting CPU's manufacturer)\n");
 	}
@@ -1550,7 +1545,7 @@ static long random_ioctl(struct file *f,
 	case RNDRESEEDCRNG:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
-		if (crng_init < 2)
+		if (!crng_ready())
 			return -ENODATA;
 		crng_reseed();
 		return 0;


