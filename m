Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D45153CF94
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345773AbiFCRyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346883AbiFCRvk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:51:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05B75A177;
        Fri,  3 Jun 2022 10:49:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63D43B82419;
        Fri,  3 Jun 2022 17:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF10C385B8;
        Fri,  3 Jun 2022 17:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278575;
        bh=ipZcC2jtV5Q4Qj1Dp9l8yK4rjUTbEqlUrAnsKnOmn2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cugaINUMe+RNfRHwbQ/4wE2H4MYC8HLs9cMBj1s+qc5nLBYnpGswrIVt21Ne3rOPm
         KdgvYUlNkZNRTEMqOf/Ak2KaNJ0gJ5pRQxWnMxD8VTSHuK3+EgAbagh26gNZAMhYBk
         4IvpY1Q7ka4d2dGaQszrDYSqA/wKYLCrg7rOrDw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolai Stange <nstange@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 23/66] crypto: drbg - make reseeding from get_random_bytes() synchronous
Date:   Fri,  3 Jun 2022 19:43:03 +0200
Message-Id: <20220603173821.330116342@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.663747061@linuxfoundation.org>
References: <20220603173820.663747061@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/drbg.c         |   61 +++++++++-----------------------------------------
 drivers/char/random.c |    2 -
 include/crypto/drbg.h |    2 -
 3 files changed, 11 insertions(+), 54 deletions(-)

--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1087,12 +1087,10 @@ static inline int drbg_get_random_bytes(
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
@@ -1103,23 +1101,15 @@ static void drbg_async_seed(struct work_
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
+		goto out;
 
-	__drbg_seed(drbg, &seedlist, true, DRBG_SEED_STATE_FULL);
-
-unlock:
-	mutex_unlock(&drbg->drbg_mutex);
+	ret = __drbg_seed(drbg, &seedlist, true, DRBG_SEED_STATE_FULL);
 
+out:
 	memzero_explicit(entropy, entropylen);
+	return ret;
 }
 
 /*
@@ -1422,6 +1412,11 @@ static int drbg_generate(struct drbg_sta
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
@@ -1514,44 +1509,15 @@ static int drbg_generate_long(struct drb
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
@@ -1645,11 +1611,6 @@ free_everything:
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
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -163,7 +163,6 @@ int __cold register_random_ready_notifie
 	spin_unlock_irqrestore(&random_ready_chain_lock, flags);
 	return ret;
 }
-EXPORT_SYMBOL(register_random_ready_notifier);
 
 /*
  * Delete a previously registered readiness callback function.
@@ -178,7 +177,6 @@ int __cold unregister_random_ready_notif
 	spin_unlock_irqrestore(&random_ready_chain_lock, flags);
 	return ret;
 }
-EXPORT_SYMBOL(unregister_random_ready_notifier);
 
 static void __cold process_random_ready_list(void)
 {
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


