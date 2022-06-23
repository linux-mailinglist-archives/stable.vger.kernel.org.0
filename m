Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB2355802A
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbiFWQpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232256AbiFWQpl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:45:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034784833C;
        Thu, 23 Jun 2022 09:45:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DC6F61F8F;
        Thu, 23 Jun 2022 16:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67662C3411B;
        Thu, 23 Jun 2022 16:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002739;
        bh=c7LBNcvMhhsAsUMqWp+VBn0vH7ERX5o09Mf9lXocD3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ih55PDcSapR/OeiAyIAStDvpnNwaPD2nNJey3IYX2o85gHl0lLz/GucAuseA7snF3
         sW0jXDLGz3HyzuIbqSOL7q1rwmRXbMIDHNZ2Yr2Hbrx1LRsL5Gzt25qWmHnWGQ5qTN
         6BBf7VXQOZmGAa7Rz+GyjFg+KQyhaUHNJl8a5v7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.9 010/264] random: add wait_for_random_bytes() API
Date:   Thu, 23 Jun 2022 18:40:03 +0200
Message-Id: <20220623164344.354219091@linuxfoundation.org>
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

commit e297a783e41560b44e3c14f38e420cba518113b8 upstream.

This enables users of get_random_{bytes,u32,u64,int,long} to wait until
the pool is ready before using this function, in case they actually want
to have reliable randomness.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c  |   41 +++++++++++++++++++++++++++++++----------
 include/linux/random.h |    1 +
 2 files changed, 32 insertions(+), 10 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -927,11 +927,6 @@ static void crng_reseed(struct crng_stat
 	}
 }
 
-static inline void crng_wait_ready(void)
-{
-	wait_event_interruptible(crng_init_wait, crng_ready());
-}
-
 static void _extract_crng(struct crng_state *crng,
 			  __u8 out[CHACHA20_BLOCK_SIZE])
 {
@@ -1541,7 +1536,10 @@ static ssize_t extract_entropy_user(stru
  * number of good random numbers, suitable for key generation, seeding
  * TCP sequence numbers, etc.  It does not rely on the hardware random
  * number generator.  For random bytes direct from the hardware RNG
- * (when available), use get_random_bytes_arch().
+ * (when available), use get_random_bytes_arch(). In order to ensure
+ * that the randomness provided by this function is okay, the function
+ * wait_for_random_bytes() should be called and return 0 at least once
+ * at any point prior.
  */
 void get_random_bytes(void *buf, int nbytes)
 {
@@ -1571,6 +1569,24 @@ void get_random_bytes(void *buf, int nby
 EXPORT_SYMBOL(get_random_bytes);
 
 /*
+ * Wait for the urandom pool to be seeded and thus guaranteed to supply
+ * cryptographically secure random numbers. This applies to: the /dev/urandom
+ * device, the get_random_bytes function, and the get_random_{u32,u64,int,long}
+ * family of functions. Using any of these functions without first calling
+ * this function forfeits the guarantee of security.
+ *
+ * Returns: 0 if the urandom pool has been seeded.
+ *          -ERESTARTSYS if the function was interrupted by a signal.
+ */
+int wait_for_random_bytes(void)
+{
+	if (likely(crng_ready()))
+		return 0;
+	return wait_event_interruptible(crng_init_wait, crng_ready());
+}
+EXPORT_SYMBOL(wait_for_random_bytes);
+
+/*
  * Add a callback function that will be invoked when the nonblocking
  * pool is initialised.
  *
@@ -1927,6 +1943,8 @@ const struct file_operations urandom_fop
 SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
 		unsigned int, flags)
 {
+	int ret;
+
 	if (flags & ~(GRND_NONBLOCK|GRND_RANDOM))
 		return -EINVAL;
 
@@ -1939,9 +1957,9 @@ SYSCALL_DEFINE3(getrandom, char __user *
 	if (!crng_ready()) {
 		if (flags & GRND_NONBLOCK)
 			return -EAGAIN;
-		crng_wait_ready();
-		if (signal_pending(current))
-			return -ERESTARTSYS;
+		ret = wait_for_random_bytes();
+		if (unlikely(ret))
+			return ret;
 	}
 	return urandom_read(NULL, buf, count, NULL);
 }
@@ -2102,7 +2120,10 @@ static rwlock_t batched_entropy_reset_lo
 /*
  * Get a random word for internal kernel use only. The quality of the random
  * number is either as good as RDRAND or as good as /dev/urandom, with the
- * goal of being quite fast and not depleting entropy.
+ * goal of being quite fast and not depleting entropy. In order to ensure
+ * that the randomness provided by this function is okay, the function
+ * wait_for_random_bytes() should be called and return 0 at least once
+ * at any point prior.
  */
 static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u64);
 u64 get_random_u64(void)
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -34,6 +34,7 @@ extern void add_input_randomness(unsigne
 extern void add_interrupt_randomness(int irq, int irq_flags) __latent_entropy;
 
 extern void get_random_bytes(void *buf, int nbytes);
+extern int wait_for_random_bytes(void);
 extern int add_random_ready_callback(struct random_ready_callback *rdy);
 extern void del_random_ready_callback(struct random_ready_callback *rdy);
 extern void get_random_bytes_arch(void *buf, int nbytes);


