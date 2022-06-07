Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E8053BFB0
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 22:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235654AbiFBUXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 16:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238934AbiFBUXM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 16:23:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0ED958D
        for <stable@vger.kernel.org>; Thu,  2 Jun 2022 13:23:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35B8561812
        for <stable@vger.kernel.org>; Thu,  2 Jun 2022 20:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E06C385A5;
        Thu,  2 Jun 2022 20:23:09 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Ez6gw8Lm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654201388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Wlq6TzZ/52YI6QZ9R+bkfIL0Q30vCuratjjSX2zF7M=;
        b=Ez6gw8LmlQYQbQrJFm63lai37/HqtZsKwE5+kj5REckTzpe/SXRv6znCuueqPdCnDAVTOI
        EEH3af8WdSEc/qopJ+vFF/PLEdt6tR3o//PgxEfl2KDj4cXpOaXLFcocNKkpK+1dJFZHPG
        0y4YbmCNMx5SqV3xqufkq040JPNRMwM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f159fe8e (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 2 Jun 2022 20:23:07 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Subject: [PATCH stable 5.10.y 5/5] crypto: drbg - make reseeding from get_random_bytes() synchronous
Date:   Thu,  2 Jun 2022 22:22:32 +0200
Message-Id: <20220602202232.281326-6-Jason@zx2c4.com>
In-Reply-To: <20220602202232.281326-1-Jason@zx2c4.com>
References: <20220602202232.281326-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolai Stange <nstange@suse.de>

commit 074bcd4000e0d812bc253f86fedc40f81ed59ccc upstream.

get_random_bytes() usually hasn't full entropy available by the time DRBG
instances are first getting seeded from it during boot. Thus, the DRBG
implementation registers random_ready_callbacks which would in turn
schedule some work for reseeding the DRBGs once get_random_bytes() has
sufficient entropy available.

For reference, the relevant history around handling DRBG (re)seeding in
the context of a not yet fully seeded get_random_bytes() is:

  commit 16b369a91d0d ("random: Blocking API for accessing
                        nonblocking_pool")
  commit 4c7879907edd ("crypto: drbg - add async seeding operation")

  commit 205a525c3342 ("random: Add callback API for random pool
                        readiness")
  commit 57225e679788 ("crypto: drbg - Use callback API for random
                        readiness")
  commit c2719503f5e1 ("random: Remove kernel blocking API")

However, some time later, the initialization state of get_random_bytes()
has been made queryable via rng_is_initialized() introduced with commit
9a47249d444d ("random: Make crng state queryable"). This primitive now
allows for streamlining the DRBG reseeding from get_random_bytes() by
replacing that aforementioned asynchronous work scheduling from
random_ready_callbacks with some simpler, synchronous code in
drbg_generate() next to the related logic already present therein. Apart
from improving overall code readability, this change will also enable DRBG
users to rely on wait_for_random_bytes() for ensuring that the initial
seeding has completed, if desired.

The previous patches already laid the grounds by making drbg_seed() to
record at each DRBG instance whether it was being seeded at a time when
rng_is_initialized() still had been false as indicated by
->seeded == DRBG_SEED_STATE_PARTIAL.

All that remains to be done now is to make drbg_generate() check for this
condition, determine whether rng_is_initialized() has flipped to true in
the meanwhile and invoke a reseed from get_random_bytes() if so.

Make this move:
- rename the former drbg_async_seed() work handler, i.e. the one in charge
  of reseeding a DRBG instance from get_random_bytes(), to
  "drbg_seed_from_random()",
- change its signature as appropriate, i.e. make it take a struct
  drbg_state rather than a work_struct and change its return type from
  "void" to "int" in order to allow for passing error information from
  e.g. its __drbg_seed() invocation onwards to callers,
- make drbg_generate() invoke this drbg_seed_from_random() once it
  encounters a DRBG instance with ->seeded == DRBG_SEED_STATE_PARTIAL by
  the time rng_is_initialized() has flipped to true and
- prune everything related to the former, random_ready_callback based
  mechanism.

As drbg_seed_from_random() is now getting invoked from drbg_generate() with
the ->drbg_mutex being held, it must not attempt to recursively grab it
once again. Remove the corresponding mutex operations from what is now
drbg_seed_from_random(). Furthermore, as drbg_seed_from_random() can now
report errors directly to its caller, there's no need for it to temporarily
switch the DRBG's ->seeded state to DRBG_SEED_STATE_UNSEEDED so that a
failure of the subsequently invoked __drbg_seed() will get signaled to
drbg_generate(). Don't do it then.

Signed-off-by: Nicolai Stange <nstange@suse.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[Jason: for stable, undid the modifications for the backport of 5acd3548.]
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 crypto/drbg.c         | 61 ++++++++-----------------------------------
 drivers/char/random.c |  2 --
 include/crypto/drbg.h |  2 --
 3 files changed, 11 insertions(+), 54 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index bec9dd3fc761..a4b5d6dbe99d 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1086,12 +1086,10 @@ static inline int drbg_get_random_bytes(struct drbg_state *drbg,
 	return 0;
 }
 
-static void drbg_async_seed(struct work_struct *work)
+static int drbg_seed_from_random(struct drbg_state *drbg)
 {
 	struct drbg_string data;
 	LIST_HEAD(seedlist);
-	struct drbg_state *drbg = container_of(work, struct drbg_state,
-					       seed_work);
 	unsigned int entropylen = drbg_sec_strength(drbg->core->flags);
 	unsigned char entropy[32];
 	int ret;
@@ -1102,23 +1100,15 @@ static void drbg_async_seed(struct work_struct *work)
 	drbg_string_fill(&data, entropy, entropylen);
 	list_add_tail(&data.list, &seedlist);
 
-	mutex_lock(&drbg->drbg_mutex);
-
 	ret = drbg_get_random_bytes(drbg, entropy, entropylen);
 	if (ret)
-		goto unlock;
-
-	/* Reset ->seeded so that if __drbg_seed fails the next
-	 * generate call will trigger a reseed.
-	 */
-	drbg->seeded = DRBG_SEED_STATE_UNSEEDED;
-
-	__drbg_seed(drbg, &seedlist, true, DRBG_SEED_STATE_FULL);
+		goto out;
 
-unlock:
-	mutex_unlock(&drbg->drbg_mutex);
+	ret = __drbg_seed(drbg, &seedlist, true, DRBG_SEED_STATE_FULL);
 
+out:
 	memzero_explicit(entropy, entropylen);
+	return ret;
 }
 
 /*
@@ -1421,6 +1411,11 @@ static int drbg_generate(struct drbg_state *drbg,
 			goto err;
 		/* 9.3.1 step 7.4 */
 		addtl = NULL;
+	} else if (rng_is_initialized() &&
+		   drbg->seeded == DRBG_SEED_STATE_PARTIAL) {
+		len = drbg_seed_from_random(drbg);
+		if (len)
+			goto err;
 	}
 
 	if (addtl && 0 < addtl->len)
@@ -1513,44 +1508,15 @@ static int drbg_generate_long(struct drbg_state *drbg,
 	return 0;
 }
 
-static int drbg_schedule_async_seed(struct notifier_block *nb, unsigned long action, void *data)
-{
-	struct drbg_state *drbg = container_of(nb, struct drbg_state,
-					       random_ready);
-
-	schedule_work(&drbg->seed_work);
-	return 0;
-}
-
 static int drbg_prepare_hrng(struct drbg_state *drbg)
 {
-	int err;
-
 	/* We do not need an HRNG in test mode. */
 	if (list_empty(&drbg->test_data.list))
 		return 0;
 
 	drbg->jent = crypto_alloc_rng("jitterentropy_rng", 0, 0);
 
-	INIT_WORK(&drbg->seed_work, drbg_async_seed);
-
-	drbg->random_ready.notifier_call = drbg_schedule_async_seed;
-	err = register_random_ready_notifier(&drbg->random_ready);
-
-	switch (err) {
-	case 0:
-		break;
-
-	case -EALREADY:
-		err = 0;
-		fallthrough;
-
-	default:
-		drbg->random_ready.notifier_call = NULL;
-		return err;
-	}
-
-	return err;
+	return 0;
 }
 
 /*
@@ -1644,11 +1610,6 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
  */
 static int drbg_uninstantiate(struct drbg_state *drbg)
 {
-	if (drbg->random_ready.notifier_call) {
-		unregister_random_ready_notifier(&drbg->random_ready);
-		cancel_work_sync(&drbg->seed_work);
-	}
-
 	if (!IS_ERR_OR_NULL(drbg->jent))
 		crypto_free_rng(drbg->jent);
 	drbg->jent = NULL;
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 00b50ccc9fae..c206db96f60a 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -163,7 +163,6 @@ int __cold register_random_ready_notifier(struct notifier_block *nb)
 	spin_unlock_irqrestore(&random_ready_chain_lock, flags);
 	return ret;
 }
-EXPORT_SYMBOL(register_random_ready_notifier);
 
 /*
  * Delete a previously registered readiness callback function.
@@ -178,7 +177,6 @@ int __cold unregister_random_ready_notifier(struct notifier_block *nb)
 	spin_unlock_irqrestore(&random_ready_chain_lock, flags);
 	return ret;
 }
-EXPORT_SYMBOL(unregister_random_ready_notifier);
 
 static void __cold process_random_ready_list(void)
 {
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index 01caab5e65de..a6c3b8e7deb6 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -137,12 +137,10 @@ struct drbg_state {
 	bool pr;		/* Prediction resistance enabled? */
 	bool fips_primed;	/* Continuous test primed? */
 	unsigned char *prev;	/* FIPS 140-2 continuous test value */
-	struct work_struct seed_work;	/* asynchronous seeding support */
 	struct crypto_rng *jent;
 	const struct drbg_state_ops *d_ops;
 	const struct drbg_core *core;
 	struct drbg_string test_data;
-	struct notifier_block random_ready;
 };
 
 static inline __u8 drbg_statelen(struct drbg_state *drbg)
-- 
2.35.1

