Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1DF558370
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbiFWR3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234395AbiFWR2g (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:28:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F5577FE0;
        Thu, 23 Jun 2022 10:04:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AB06B8248F;
        Thu, 23 Jun 2022 17:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4284FC3411B;
        Thu, 23 Jun 2022 17:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003853;
        bh=NWvMlAI05IB/mQN1UuiQajR7DeI2LADwiDVtC9A8hu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A0zOD519sMMjxoFMCka4PtShNuUOKAO4am+fnp/Iih7uaJMgEBHEvgZO6lxyb1nGg
         0oYJo4stPeafIHW06GWThMKgpX8Wyr66UgbZrXNo7nJ3zRib96rM0Ei3ESAd2li773
         PPzFlcHcYCVt92UkahO0Hv4nO7ThpyxpN2uf88gs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 109/237] random: introduce drain_entropy() helper to declutter crng_reseed()
Date:   Thu, 23 Jun 2022 18:42:23 +0200
Message-Id: <20220623164346.286911336@linuxfoundation.org>
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

commit 246c03dd899164d0186b6d685d6387f228c28d93 upstream.

In preparation for separating responsibilities, break out the entropy
count management part of crng_reseed() into its own function.

No functional changes.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -260,6 +260,7 @@ static struct {
 };
 
 static void extract_entropy(void *buf, size_t nbytes);
+static bool drain_entropy(void *buf, size_t nbytes);
 
 static void crng_reseed(void);
 
@@ -454,23 +455,13 @@ static void crng_slow_load(const void *c
 static void crng_reseed(void)
 {
 	unsigned long flags;
-	int entropy_count;
 	unsigned long next_gen;
 	u8 key[CHACHA20_KEY_SIZE];
 	bool finalize_init = false;
 
-	/*
-	 * First we make sure we have POOL_MIN_BITS of entropy in the pool,
-	 * and then we drain all of it. Only then can we extract a new key.
-	 */
-	do {
-		entropy_count = READ_ONCE(input_pool.entropy_count);
-		if (entropy_count < POOL_MIN_BITS)
-			return;
-	} while (cmpxchg(&input_pool.entropy_count, entropy_count, 0) != entropy_count);
-	extract_entropy(key, sizeof(key));
-	wake_up_interruptible(&random_write_wait);
-	kill_fasync(&fasync, SIGIO, POLL_OUT);
+	/* Only reseed if we can, to prevent brute forcing a small amount of new bits. */
+	if (!drain_entropy(key, sizeof(key)))
+		return;
 
 	/*
 	 * We copy the new key into the base_crng, overwriting the old one,
@@ -898,6 +889,25 @@ static void extract_entropy(void *buf, s
 	memzero_explicit(&block, sizeof(block));
 }
 
+/*
+ * First we make sure we have POOL_MIN_BITS of entropy in the pool, and then we
+ * set the entropy count to zero (but don't actually touch any data). Only then
+ * can we extract a new key with extract_entropy().
+ */
+static bool drain_entropy(void *buf, size_t nbytes)
+{
+	unsigned int entropy_count;
+	do {
+		entropy_count = READ_ONCE(input_pool.entropy_count);
+		if (entropy_count < POOL_MIN_BITS)
+			return false;
+	} while (cmpxchg(&input_pool.entropy_count, entropy_count, 0) != entropy_count);
+	extract_entropy(buf, nbytes);
+	wake_up_interruptible(&random_write_wait);
+	kill_fasync(&fasync, SIGIO, POLL_OUT);
+	return true;
+}
+
 #define warn_unseeded_randomness(previous) \
 	_warn_unseeded_randomness(__func__, (void *)_RET_IP_, (previous))
 


