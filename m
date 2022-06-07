Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3134B5360A9
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235978AbiE0LxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352871AbiE0Lu5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:50:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC84276;
        Fri, 27 May 2022 04:46:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 529FF61D96;
        Fri, 27 May 2022 11:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638D1C385A9;
        Fri, 27 May 2022 11:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651975;
        bh=Ml2drK8wflGx1WqYyuyVWtr3gasKF1wxogQ6AqqIt3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A1FXYeaQ07CvAsXTdV0Z2A1IP+qZyw1EeeDBHOuMAG6KxvUiUDrcdp57IAMHQ5AMg
         lNWmwpZ6pLjk8exz79R3b751fOcwz397oA158caODy5gLELojfWJplk1sHpSnX/oRr
         1o7iUdvnzVXhlPqEi8mPODv4jRnV/GxuPcxLpSJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Joe Perches <joe@perches.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.17 092/111] random: use symbolic constants for crng_init states
Date:   Fri, 27 May 2022 10:50:04 +0200
Message-Id: <20220527084832.450066928@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084819.133490171@linuxfoundation.org>
References: <20220527084819.133490171@linuxfoundation.org>
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

commit e3d2c5e79a999aa4e7d6f0127e16d3da5a4ff70d upstream.

crng_init represents a state machine, with three states, and various
rules for transitions. For the longest time, we've been managing these
with "0", "1", and "2", and expecting people to figure it out. To make
the code more obvious, replace these with proper enum values
representing the transition, and then redocument what each of these
states mean.

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -70,16 +70,16 @@
  *********************************************************************/
 
 /*
- * crng_init =  0 --> Uninitialized
- *		1 --> Initialized
- *		2 --> Initialized from input_pool
- *
  * crng_init is protected by base_crng->lock, and only increases
- * its value (from 0->1->2).
+ * its value (from empty->early->ready).
  */
-static int crng_init = 0;
-#define crng_ready() (likely(crng_init > 1))
-/* Various types of waiters for crng_init->2 transition. */
+static enum {
+	CRNG_EMPTY = 0, /* Little to no entropy collected */
+	CRNG_EARLY = 1, /* At least POOL_EARLY_BITS collected */
+	CRNG_READY = 2  /* Fully initialized with POOL_READY_BITS collected */
+} crng_init = CRNG_EMPTY;
+#define crng_ready() (likely(crng_init >= CRNG_READY))
+/* Various types of waiters for crng_init->CRNG_READY transition. */
 static DECLARE_WAIT_QUEUE_HEAD(crng_init_wait);
 static struct fasync_struct *fasync;
 static DEFINE_SPINLOCK(random_ready_chain_lock);
@@ -282,7 +282,7 @@ static void crng_reseed(void)
 	WRITE_ONCE(base_crng.generation, next_gen);
 	WRITE_ONCE(base_crng.birth, jiffies);
 	if (!crng_ready()) {
-		crng_init = 2;
+		crng_init = CRNG_READY;
 		finalize_init = true;
 	}
 	spin_unlock_irqrestore(&base_crng.lock, flags);
@@ -376,7 +376,7 @@ static void crng_make_state(u32 chacha_s
 	 * For the fast path, we check whether we're ready, unlocked first, and
 	 * then re-check once locked later. In the case where we're really not
 	 * ready, we do fast key erasure with the base_crng directly, extracting
-	 * when crng_init==0.
+	 * when crng_init is CRNG_EMPTY.
 	 */
 	if (!crng_ready()) {
 		bool ready;
@@ -384,7 +384,7 @@ static void crng_make_state(u32 chacha_s
 		spin_lock_irqsave(&base_crng.lock, flags);
 		ready = crng_ready();
 		if (!ready) {
-			if (crng_init == 0)
+			if (crng_init == CRNG_EMPTY)
 				extract_entropy(base_crng.key, sizeof(base_crng.key));
 			crng_fast_key_erasure(base_crng.key, chacha_state,
 					      random_data, random_data_len);
@@ -738,8 +738,8 @@ EXPORT_SYMBOL(get_random_bytes_arch);
 
 enum {
 	POOL_BITS = BLAKE2S_HASH_SIZE * 8,
-	POOL_INIT_BITS = POOL_BITS, /* No point in settling for less. */
-	POOL_FAST_INIT_BITS = POOL_INIT_BITS / 2
+	POOL_READY_BITS = POOL_BITS, /* When crng_init->CRNG_READY */
+	POOL_EARLY_BITS = POOL_READY_BITS / 2 /* When crng_init->CRNG_EARLY */
 };
 
 static struct {
@@ -834,13 +834,13 @@ static void credit_init_bits(size_t nbit
 		init_bits = min_t(unsigned int, POOL_BITS, orig + add);
 	} while (cmpxchg(&input_pool.init_bits, orig, init_bits) != orig);
 
-	if (!crng_ready() && init_bits >= POOL_INIT_BITS)
+	if (!crng_ready() && init_bits >= POOL_READY_BITS)
 		crng_reseed();
-	else if (unlikely(crng_init == 0 && init_bits >= POOL_FAST_INIT_BITS)) {
+	else if (unlikely(crng_init == CRNG_EMPTY && init_bits >= POOL_EARLY_BITS)) {
 		spin_lock_irqsave(&base_crng.lock, flags);
-		if (crng_init == 0) {
+		if (crng_init == CRNG_EMPTY) {
 			extract_entropy(base_crng.key, sizeof(base_crng.key));
-			crng_init = 1;
+			crng_init = CRNG_EARLY;
 		}
 		spin_unlock_irqrestore(&base_crng.lock, flags);
 	}
@@ -1515,7 +1515,7 @@ const struct file_operations urandom_fop
  *
  * - write_wakeup_threshold - the amount of entropy in the input pool
  *   below which write polls to /dev/random will unblock, requesting
- *   more entropy, tied to the POOL_INIT_BITS constant. It is writable
+ *   more entropy, tied to the POOL_READY_BITS constant. It is writable
  *   to avoid breaking old userspaces, but writing to it does not
  *   change any behavior of the RNG.
  *
@@ -1530,7 +1530,7 @@ const struct file_operations urandom_fop
 #include <linux/sysctl.h>
 
 static int sysctl_random_min_urandom_seed = CRNG_RESEED_INTERVAL / HZ;
-static int sysctl_random_write_wakeup_bits = POOL_INIT_BITS;
+static int sysctl_random_write_wakeup_bits = POOL_READY_BITS;
 static int sysctl_poolsize = POOL_BITS;
 static u8 sysctl_bootid[UUID_SIZE];
 


