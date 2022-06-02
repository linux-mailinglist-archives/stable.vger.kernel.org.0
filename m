Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 885E653BFB5
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 22:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238152AbiFBUXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 16:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238934AbiFBUXD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 16:23:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FC8767A
        for <stable@vger.kernel.org>; Thu,  2 Jun 2022 13:23:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 003DBB8218A
        for <stable@vger.kernel.org>; Thu,  2 Jun 2022 20:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74398C385A5;
        Thu,  2 Jun 2022 20:22:58 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Lo+lK85u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654201377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FQ9hm3QAxiHT7j2Ybl7nudkg2qJvI0Rc8R+xYfwE8V0=;
        b=Lo+lK85u1wk6B+oYm80oc8cl/+JUMtie/f7rSL7y6ebGDIknOZXk6535AGtb6wlEVP06dp
        bNv5CQJ3p7ePUSg8CtghGkQnkGK6/S5vHlow2TWDyuO7LTOIoeXSTDo8/Cr8JkruDnNJqL
        3/UYFRkGt3QGKrR5NVqzDKC1+nxfTYw=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5df6008b (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 2 Jun 2022 20:22:56 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Subject: [PATCH stable 5.10.y 2/5] crypto: drbg - prepare for more fine-grained tracking of seeding state
Date:   Thu,  2 Jun 2022 22:22:29 +0200
Message-Id: <20220602202232.281326-3-Jason@zx2c4.com>
In-Reply-To: <20220602202232.281326-1-Jason@zx2c4.com>
References: <20220602202232.281326-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

commit ce8ce31b2c5c8b18667784b8c515650c65d57b4e upstream.

There are two different randomness sources the DRBGs are getting seeded
from, namely the jitterentropy source (if enabled) and get_random_bytes().
At initial DRBG seeding time during boot, the latter might not have
collected sufficient entropy for seeding itself yet and thus, the DRBG
implementation schedules a reseed work from a random_ready_callback once
that has happened. This is particularly important for the !->pr DRBG
instances, for which (almost) no further reseeds are getting triggered
during their lifetime.

Because collecting data from the jitterentropy source is a rather expensive
operation, the aforementioned asynchronously scheduled reseed work
restricts itself to get_random_bytes() only. That is, it in some sense
amends the initial DRBG seed derived from jitterentropy output at full
(estimated) entropy with fresh randomness obtained from get_random_bytes()
once that has been seeded with sufficient entropy itself.

With the advent of rng_is_initialized(), there is no real need for doing
the reseed operation from an asynchronously scheduled work anymore and a
subsequent patch will make it synchronous by moving it next to related
logic already present in drbg_generate().

However, for tracking whether a full reseed including the jitterentropy
source is required or a "partial" reseed involving only get_random_bytes()
would be sufficient already, the boolean struct drbg_state's ->seeded
member must become a tristate value.

Prepare for this by introducing the new enum drbg_seed_state and change
struct drbg_state's ->seeded member's type from bool to that type.

For facilitating review, enum drbg_seed_state is made to only contain
two members corresponding to the former ->seeded values of false and true
resp. at this point: DRBG_SEED_STATE_UNSEEDED and DRBG_SEED_STATE_FULL. A
third one for tracking the intermediate state of "seeded from jitterentropy
only" will be introduced with a subsequent patch.

There is no change in behaviour at this point.

Signed-off-by: Nicolai Stange <nstange@suse.de>
Reviewed-by: Stephan Müller <smueller@chronox.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 crypto/drbg.c         | 19 ++++++++++---------
 include/crypto/drbg.h |  7 ++++++-
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 19ea8d6628ff..87f97da5d0ba 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1042,7 +1042,7 @@ static inline int __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
 	if (ret)
 		return ret;
 
-	drbg->seeded = true;
+	drbg->seeded = DRBG_SEED_STATE_FULL;
 	/* 10.1.1.2 / 10.1.1.3 step 5 */
 	drbg->reseed_ctr = 1;
 
@@ -1087,14 +1087,14 @@ static void drbg_async_seed(struct work_struct *work)
 	if (ret)
 		goto unlock;
 
-	/* Set seeded to false so that if __drbg_seed fails the
-	 * next generate call will trigger a reseed.
+	/* Reset ->seeded so that if __drbg_seed fails the next
+	 * generate call will trigger a reseed.
 	 */
-	drbg->seeded = false;
+	drbg->seeded = DRBG_SEED_STATE_UNSEEDED;
 
 	__drbg_seed(drbg, &seedlist, true);
 
-	if (drbg->seeded)
+	if (drbg->seeded == DRBG_SEED_STATE_FULL)
 		drbg->reseed_threshold = drbg_max_requests(drbg);
 
 unlock:
@@ -1385,13 +1385,14 @@ static int drbg_generate(struct drbg_state *drbg,
 	 * here. The spec is a bit convoluted here, we make it simpler.
 	 */
 	if (drbg->reseed_threshold < drbg->reseed_ctr)
-		drbg->seeded = false;
+		drbg->seeded = DRBG_SEED_STATE_UNSEEDED;
 
-	if (drbg->pr || !drbg->seeded) {
+	if (drbg->pr || drbg->seeded == DRBG_SEED_STATE_UNSEEDED) {
 		pr_devel("DRBG: reseeding before generation (prediction "
 			 "resistance: %s, state %s)\n",
 			 drbg->pr ? "true" : "false",
-			 drbg->seeded ? "seeded" : "unseeded");
+			 (drbg->seeded ==  DRBG_SEED_STATE_FULL ?
+			  "seeded" : "unseeded"));
 		/* 9.3.1 steps 7.1 through 7.3 */
 		len = drbg_seed(drbg, addtl, true);
 		if (len)
@@ -1576,7 +1577,7 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 	if (!drbg->core) {
 		drbg->core = &drbg_cores[coreref];
 		drbg->pr = pr;
-		drbg->seeded = false;
+		drbg->seeded = DRBG_SEED_STATE_UNSEEDED;
 		drbg->reseed_threshold = drbg_max_requests(drbg);
 
 		ret = drbg_alloc_state(drbg);
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index 88e4d145f7cd..2db72121d568 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -105,6 +105,11 @@ struct drbg_test_data {
 	struct drbg_string *testentropy; /* TEST PARAMETER: test entropy */
 };
 
+enum drbg_seed_state {
+	DRBG_SEED_STATE_UNSEEDED,
+	DRBG_SEED_STATE_FULL,
+};
+
 struct drbg_state {
 	struct mutex drbg_mutex;	/* lock around DRBG */
 	unsigned char *V;	/* internal state 10.1.1.1 1a) */
@@ -127,7 +132,7 @@ struct drbg_state {
 	struct crypto_wait ctr_wait;		/* CTR mode async wait obj */
 	struct scatterlist sg_in, sg_out;	/* CTR mode SGLs */
 
-	bool seeded;		/* DRBG fully seeded? */
+	enum drbg_seed_state seeded;		/* DRBG fully seeded? */
 	bool pr;		/* Prediction resistance enabled? */
 	bool fips_primed;	/* Continuous test primed? */
 	unsigned char *prev;	/* FIPS 140-2 continuous test value */
-- 
2.35.1

