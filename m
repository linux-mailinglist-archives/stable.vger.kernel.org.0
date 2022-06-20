Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE5B551D92
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbiFTOCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350101AbiFTNxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:53:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0487710FA;
        Mon, 20 Jun 2022 06:19:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCC6B60FF1;
        Mon, 20 Jun 2022 13:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24B9C3411B;
        Mon, 20 Jun 2022 13:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731103;
        bh=hRZMYByAsJuYFlX6lCGD6LXmVQmTNQi+k/s7lBT7He8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EY0mLiKCoN4usoYgWSt9LdclvNtT4ys54H/i5p8Wxcf5Zji9rVFUu7yAcVixidQNx
         HdiX61t0zOyvtoWUrIxQqriQkpNnUqCtm02OtLqbhVpCAnYN2UieBoVI0qYAtSLsED
         kNQZIVtIMKItjBH2XCPNU0L6B/894TYr/c5XgGWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 113/240] random: replace custom notifier chain with standard one
Date:   Mon, 20 Jun 2022 14:50:14 +0200
Message-Id: <20220620124742.289307252@linuxfoundation.org>
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

commit 5acd35487dc911541672b3ffc322851769c32a56 upstream.

We previously rolled our own randomness readiness notifier, which only
has two users in the whole kernel. Replace this with a more standard
atomic notifier block that serves the same purpose with less code. Also
unexport the symbols, because no modules use it, only unconditional
builtins. The only drawback is that it's possible for a notification
handler returning the "stop" code to prevent further processing, but
given that there are only two users, and that we're unexporting this
anyway, that doesn't seem like a significant drawback for the
simplification we receive here.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
[Jason: for stable, also backported to crypto/drbg.c, not unexporting.]
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/drbg.c          |   17 +++++-------
 drivers/char/random.c  |   69 ++++++++++++++-----------------------------------
 include/crypto/drbg.h  |    2 -
 include/linux/random.h |   10 ++-----
 lib/random32.c         |   13 +++++----
 lib/vsprintf.c         |   10 ++++---
 6 files changed, 47 insertions(+), 74 deletions(-)

--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1478,12 +1478,13 @@ static int drbg_generate_long(struct drb
 	return 0;
 }
 
-static void drbg_schedule_async_seed(struct random_ready_callback *rdy)
+static int drbg_schedule_async_seed(struct notifier_block *nb, unsigned long action, void *data)
 {
-	struct drbg_state *drbg = container_of(rdy, struct drbg_state,
+	struct drbg_state *drbg = container_of(nb, struct drbg_state,
 					       random_ready);
 
 	schedule_work(&drbg->seed_work);
+	return 0;
 }
 
 static int drbg_prepare_hrng(struct drbg_state *drbg)
@@ -1496,10 +1497,8 @@ static int drbg_prepare_hrng(struct drbg
 
 	INIT_WORK(&drbg->seed_work, drbg_async_seed);
 
-	drbg->random_ready.owner = THIS_MODULE;
-	drbg->random_ready.func = drbg_schedule_async_seed;
-
-	err = add_random_ready_callback(&drbg->random_ready);
+	drbg->random_ready.notifier_call = drbg_schedule_async_seed;
+	err = register_random_ready_notifier(&drbg->random_ready);
 
 	switch (err) {
 	case 0:
@@ -1510,7 +1509,7 @@ static int drbg_prepare_hrng(struct drbg
 		/* fall through */
 
 	default:
-		drbg->random_ready.func = NULL;
+		drbg->random_ready.notifier_call = NULL;
 		return err;
 	}
 
@@ -1616,8 +1615,8 @@ free_everything:
  */
 static int drbg_uninstantiate(struct drbg_state *drbg)
 {
-	if (drbg->random_ready.func) {
-		del_random_ready_callback(&drbg->random_ready);
+	if (drbg->random_ready.notifier_call) {
+		unregister_random_ready_notifier(&drbg->random_ready);
 		cancel_work_sync(&drbg->seed_work);
 		crypto_free_rng(drbg->jent);
 		drbg->jent = NULL;
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -83,8 +83,8 @@ static int crng_init = 0;
 /* Various types of waiters for crng_init->2 transition. */
 static DECLARE_WAIT_QUEUE_HEAD(crng_init_wait);
 static struct fasync_struct *fasync;
-static DEFINE_SPINLOCK(random_ready_list_lock);
-static LIST_HEAD(random_ready_list);
+static DEFINE_SPINLOCK(random_ready_chain_lock);
+static RAW_NOTIFIER_HEAD(random_ready_chain);
 
 /* Control how we warn userspace. */
 static struct ratelimit_state unseeded_warning =
@@ -147,72 +147,45 @@ EXPORT_SYMBOL(wait_for_random_bytes);
  *
  * returns: 0 if callback is successfully added
  *	    -EALREADY if pool is already initialised (callback not called)
- *	    -ENOENT if module for callback is not alive
  */
-int add_random_ready_callback(struct random_ready_callback *rdy)
+int register_random_ready_notifier(struct notifier_block *nb)
 {
-	struct module *owner;
 	unsigned long flags;
-	int err = -EALREADY;
+	int ret = -EALREADY;
 
 	if (crng_ready())
-		return err;
+		return ret;
 
-	owner = rdy->owner;
-	if (!try_module_get(owner))
-		return -ENOENT;
-
-	spin_lock_irqsave(&random_ready_list_lock, flags);
-	if (crng_ready())
-		goto out;
-
-	owner = NULL;
-
-	list_add(&rdy->list, &random_ready_list);
-	err = 0;
-
-out:
-	spin_unlock_irqrestore(&random_ready_list_lock, flags);
-
-	module_put(owner);
-
-	return err;
+	spin_lock_irqsave(&random_ready_chain_lock, flags);
+	if (!crng_ready())
+		ret = raw_notifier_chain_register(&random_ready_chain, nb);
+	spin_unlock_irqrestore(&random_ready_chain_lock, flags);
+	return ret;
 }
-EXPORT_SYMBOL(add_random_ready_callback);
+EXPORT_SYMBOL(register_random_ready_notifier);
 
 /*
  * Delete a previously registered readiness callback function.
  */
-void del_random_ready_callback(struct random_ready_callback *rdy)
+int unregister_random_ready_notifier(struct notifier_block *nb)
 {
 	unsigned long flags;
-	struct module *owner = NULL;
-
-	spin_lock_irqsave(&random_ready_list_lock, flags);
-	if (!list_empty(&rdy->list)) {
-		list_del_init(&rdy->list);
-		owner = rdy->owner;
-	}
-	spin_unlock_irqrestore(&random_ready_list_lock, flags);
+	int ret;
 
-	module_put(owner);
+	spin_lock_irqsave(&random_ready_chain_lock, flags);
+	ret = raw_notifier_chain_unregister(&random_ready_chain, nb);
+	spin_unlock_irqrestore(&random_ready_chain_lock, flags);
+	return ret;
 }
-EXPORT_SYMBOL(del_random_ready_callback);
+EXPORT_SYMBOL(unregister_random_ready_notifier);
 
 static void process_random_ready_list(void)
 {
 	unsigned long flags;
-	struct random_ready_callback *rdy, *tmp;
 
-	spin_lock_irqsave(&random_ready_list_lock, flags);
-	list_for_each_entry_safe(rdy, tmp, &random_ready_list, list) {
-		struct module *owner = rdy->owner;
-
-		list_del_init(&rdy->list);
-		rdy->func(rdy);
-		module_put(owner);
-	}
-	spin_unlock_irqrestore(&random_ready_list_lock, flags);
+	spin_lock_irqsave(&random_ready_chain_lock, flags);
+	raw_notifier_call_chain(&random_ready_chain, 0, NULL);
+	spin_unlock_irqrestore(&random_ready_chain_lock, flags);
 }
 
 #define warn_unseeded_randomness(previous) \
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -136,7 +136,7 @@ struct drbg_state {
 	const struct drbg_state_ops *d_ops;
 	const struct drbg_core *core;
 	struct drbg_string test_data;
-	struct random_ready_callback random_ready;
+	struct notifier_block random_ready;
 };
 
 static inline __u8 drbg_statelen(struct drbg_state *drbg)
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -10,11 +10,7 @@
 
 #include <uapi/linux/random.h>
 
-struct random_ready_callback {
-	struct list_head list;
-	void (*func)(struct random_ready_callback *rdy);
-	struct module *owner;
-};
+struct notifier_block;
 
 extern void add_device_randomness(const void *, size_t);
 extern void add_bootloader_randomness(const void *, size_t);
@@ -39,8 +35,8 @@ extern void get_random_bytes(void *buf,
 extern int wait_for_random_bytes(void);
 extern int __init rand_initialize(void);
 extern bool rng_is_initialized(void);
-extern int add_random_ready_callback(struct random_ready_callback *rdy);
-extern void del_random_ready_callback(struct random_ready_callback *rdy);
+extern int register_random_ready_notifier(struct notifier_block *nb);
+extern int unregister_random_ready_notifier(struct notifier_block *nb);
 extern size_t __must_check get_random_bytes_arch(void *buf, size_t nbytes);
 
 #ifndef MODULE
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -40,6 +40,7 @@
 #include <linux/sched.h>
 #include <linux/bitops.h>
 #include <linux/slab.h>
+#include <linux/notifier.h>
 #include <asm/unaligned.h>
 
 /**
@@ -546,9 +547,11 @@ static void prandom_reseed(struct timer_
  * To avoid worrying about whether it's safe to delay that interrupt
  * long enough to seed all CPUs, just schedule an immediate timer event.
  */
-static void prandom_timer_start(struct random_ready_callback *unused)
+static int prandom_timer_start(struct notifier_block *nb,
+			       unsigned long action, void *data)
 {
 	mod_timer(&seed_timer, jiffies);
+	return 0;
 }
 
 /*
@@ -557,13 +560,13 @@ static void prandom_timer_start(struct r
  */
 static int __init prandom_init_late(void)
 {
-	static struct random_ready_callback random_ready = {
-		.func = prandom_timer_start
+	static struct notifier_block random_ready = {
+		.notifier_call = prandom_timer_start
 	};
-	int ret = add_random_ready_callback(&random_ready);
+	int ret = register_random_ready_notifier(&random_ready);
 
 	if (ret == -EALREADY) {
-		prandom_timer_start(&random_ready);
+		prandom_timer_start(&random_ready, 0, NULL);
 		ret = 0;
 	}
 	return ret;
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -731,14 +731,16 @@ static void enable_ptr_key_workfn(struct
 
 static DECLARE_WORK(enable_ptr_key_work, enable_ptr_key_workfn);
 
-static void fill_random_ptr_key(struct random_ready_callback *unused)
+static int fill_random_ptr_key(struct notifier_block *nb,
+			       unsigned long action, void *data)
 {
 	/* This may be in an interrupt handler. */
 	queue_work(system_unbound_wq, &enable_ptr_key_work);
+	return 0;
 }
 
-static struct random_ready_callback random_ready = {
-	.func = fill_random_ptr_key
+static struct notifier_block random_ready = {
+	.notifier_call = fill_random_ptr_key
 };
 
 static int __init initialize_ptr_random(void)
@@ -752,7 +754,7 @@ static int __init initialize_ptr_random(
 		return 0;
 	}
 
-	ret = add_random_ready_callback(&random_ready);
+	ret = register_random_ready_notifier(&random_ready);
 	if (!ret) {
 		return 0;
 	} else if (ret == -EALREADY) {


