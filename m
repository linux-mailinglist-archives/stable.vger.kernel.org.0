Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7EB55814B
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbiFWQ6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbiFWQ5p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:57:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31ED4DF5F;
        Thu, 23 Jun 2022 09:53:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBC1B61FC3;
        Thu, 23 Jun 2022 16:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89440C3411B;
        Thu, 23 Jun 2022 16:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003205;
        bh=57SbyPKMHG44GOEQhal2/dWHCZGuGBAKpNxfCh5ah0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ox1q93al8OwGwkE5t4YUB0GGJTG2k6p2brF+lvUtnqiqw/1/p6GLMG8mWBXDurhXQ
         E6A2YzS41/V8jwepE2CHUtN4ht+tvtnVVXOlW6qGStBM+XRjZM3ibgUOpmAgsIdF+L
         jkLbyLfN6/eQw+cDpfy6jbeTRPuKJz+D+xuJwzW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 163/264] random: make consistent usage of crng_ready()
Date:   Thu, 23 Jun 2022 18:42:36 +0200
Message-Id: <20220623164348.676582900@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
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
@@ -126,18 +126,13 @@ static void try_to_generate_entropy(void
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
@@ -292,7 +287,7 @@ static void crng_reseed(void)
 		++next_gen;
 	WRITE_ONCE(base_crng.generation, next_gen);
 	WRITE_ONCE(base_crng.birth, jiffies);
-	if (crng_init < 2) {
+	if (!crng_ready()) {
 		crng_init = 2;
 		finalize_init = true;
 	}
@@ -360,7 +355,7 @@ static void crng_make_state(u32 chacha_s
 	 * ready, we do fast key erasure with the base_crng directly, because
 	 * this is what crng_pre_init_inject() mutates during early init.
 	 */
-	if (unlikely(!crng_ready())) {
+	if (!crng_ready()) {
 		bool ready;
 
 		spin_lock_irqsave(&base_crng.lock, flags);
@@ -800,7 +795,7 @@ static void credit_entropy_bits(size_t n
 		entropy_count = min_t(unsigned int, POOL_BITS, orig + add);
 	} while (cmpxchg(&input_pool.entropy_count, orig, entropy_count) != orig);
 
-	if (crng_init < 2 && entropy_count >= POOL_MIN_BITS)
+	if (!crng_ready() && entropy_count >= POOL_MIN_BITS)
 		crng_reseed();
 }
 
@@ -957,7 +952,7 @@ int __init rand_initialize(void)
 	extract_entropy(base_crng.key, sizeof(base_crng.key));
 	++base_crng.generation;
 
-	if (arch_init && trust_cpu && crng_init < 2) {
+	if (arch_init && trust_cpu && !crng_ready()) {
 		crng_init = 2;
 		pr_notice("crng init done (trusting CPU's manufacturer)\n");
 	}
@@ -1546,7 +1541,7 @@ static long random_ioctl(struct file *f,
 	case RNDRESEEDCRNG:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
-		if (crng_init < 2)
+		if (!crng_ready())
 			return -ENODATA;
 		crng_reseed();
 		return 0;


