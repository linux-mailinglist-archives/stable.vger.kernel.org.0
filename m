Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1252253CF6E
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345518AbiFCRxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346815AbiFCRvc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:51:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817F557B00;
        Fri,  3 Jun 2022 10:49:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2391B82419;
        Fri,  3 Jun 2022 17:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495DEC385B8;
        Fri,  3 Jun 2022 17:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278565;
        bh=TIS2GoTaI2/zpFafNEpWpq5sRvOtRLPlkLlhchtllhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E6Oz771+h058gH4BVniw3drqvTvpvd3Cw7vUhIXYqaEktyxq9BWzXCmVaiHaqSVdi
         NGQONY3J/ZB+oTG//wqJDHTgloX0hdYqY37Pag5gum479eNtAOArwYL/rysCfHFRlm
         VfiQ+vZL4pgGhiflW74opXMrYp3HJhmpbLfb5TOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolai Stange <nstange@suse.de>,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 20/66] crypto: drbg - prepare for more fine-grained tracking of seeding state
Date:   Fri,  3 Jun 2022 19:43:00 +0200
Message-Id: <20220603173821.247230562@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/drbg.c         |   19 ++++++++++---------
 include/crypto/drbg.h |    7 ++++++-
 2 files changed, 16 insertions(+), 10 deletions(-)

--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1043,7 +1043,7 @@ static inline int __drbg_seed(struct drb
 	if (ret)
 		return ret;
 
-	drbg->seeded = true;
+	drbg->seeded = DRBG_SEED_STATE_FULL;
 	/* 10.1.1.2 / 10.1.1.3 step 5 */
 	drbg->reseed_ctr = 1;
 
@@ -1088,14 +1088,14 @@ static void drbg_async_seed(struct work_
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
@@ -1386,13 +1386,14 @@ static int drbg_generate(struct drbg_sta
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
@@ -1577,7 +1578,7 @@ static int drbg_instantiate(struct drbg_
 	if (!drbg->core) {
 		drbg->core = &drbg_cores[coreref];
 		drbg->pr = pr;
-		drbg->seeded = false;
+		drbg->seeded = DRBG_SEED_STATE_UNSEEDED;
 		drbg->reseed_threshold = drbg_max_requests(drbg);
 
 		ret = drbg_alloc_state(drbg);
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


