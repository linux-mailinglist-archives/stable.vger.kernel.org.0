Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C380E558162
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbiFWQ7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbiFWQ6d (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:58:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B404EDEA;
        Thu, 23 Jun 2022 09:53:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFE9D61F80;
        Thu, 23 Jun 2022 16:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748AEC36AE3;
        Thu, 23 Jun 2022 16:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003226;
        bh=dcTr+3Cc/f8ArMXb7czVoUP7tPV4aeG9yNZI3oE3oZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O+ZQ7wwiwrz1p4QSM7tROFQ8qhXoWSzSYuU0HaPUa8YH+RQGVcM8CkbmqsSKaqNBk
         +1L3ylUJ3I1A3IFv0GWHBGOo1ScXvWW6DRLc5+QQX48GvK3dK3OvsXGgVm+jM7bgTn
         /zXp1SjWaq6hL7btK6ZcDv6JbtMn0XHBAptgDjYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 131/264] random: introduce drain_entropy() helper to declutter crng_reseed()
Date:   Thu, 23 Jun 2022 18:42:04 +0200
Message-Id: <20220623164347.772843859@linuxfoundation.org>
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
@@ -261,6 +261,7 @@ static struct {
 };
 
 static void extract_entropy(void *buf, size_t nbytes);
+static bool drain_entropy(void *buf, size_t nbytes);
 
 static void crng_reseed(void);
 
@@ -506,23 +507,13 @@ static void crng_slow_load(const void *c
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
@@ -950,6 +941,25 @@ static void extract_entropy(void *buf, s
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
 


