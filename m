Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAED0551E04
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244008AbiFTOCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350770AbiFTNxu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:53:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DCB5FC1;
        Mon, 20 Jun 2022 06:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AE49B811E3;
        Mon, 20 Jun 2022 13:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D95FC3411B;
        Mon, 20 Jun 2022 13:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731166;
        bh=8L1thByr+96y7LiwJjwBO7DzEBZc6NqjlE7eg/BZEZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zojaVqKGmbMClPf3kDTG5+MM2qlUNZ244c3WqiqMX3K7aXlVkLoU4wgUAdhYCZFfb
         WRuDrElAtn4cNOYsYbbn4HsVHixyhmVGqbLxhZJvM5hbcz1uGlUKmQ0oGBQZrNO9RU
         40zdFbMijHjeFI3LUgT2dOs+IJnPFcLjskztZdSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolai Stange <nstange@suse.de>,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 174/240] crypto: drbg - track whether DRBG was seeded with !rng_is_initialized()
Date:   Mon, 20 Jun 2022 14:51:15 +0200
Message-Id: <20220620124744.038354260@linuxfoundation.org>
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

From: Nicolai Stange <nstange@suse.de>

commit 2bcd25443868aa8863779a6ebc6c9319633025d2 upstream.

Currently, the DRBG implementation schedules asynchronous works from
random_ready_callbacks for reseeding the DRBG instances with output from
get_random_bytes() once the latter has sufficient entropy available.

However, as the get_random_bytes() initialization state can get queried by
means of rng_is_initialized() now, there is no real need for this
asynchronous reseeding logic anymore and it's better to keep things simple
by doing it synchronously when needed instead, i.e. from drbg_generate()
once rng_is_initialized() has flipped to true.

Of course, for this to work, drbg_generate() would need some means by which
it can tell whether or not rng_is_initialized() has flipped to true since
the last seeding from get_random_bytes(). Or equivalently, whether or not
the last seed from get_random_bytes() has happened when
rng_is_initialized() was still evaluating to false.

As it currently stands, enum drbg_seed_state allows for the representation
of two different DRBG seeding states: DRBG_SEED_STATE_UNSEEDED and
DRBG_SEED_STATE_FULL. The former makes drbg_generate() to invoke a full
reseeding operation involving both, the rather expensive jitterentropy as
well as the get_random_bytes() randomness sources. The DRBG_SEED_STATE_FULL
state on the other hand implies that no reseeding at all is required for a
!->pr DRBG variant.

Introduce the new DRBG_SEED_STATE_PARTIAL state to enum drbg_seed_state for
representing the condition that a DRBG was being seeded when
rng_is_initialized() had still been false. In particular, this new state
implies that
- the given DRBG instance has been fully seeded from the jitterentropy
  source (if enabled)
- and drbg_generate() is supposed to reseed from get_random_bytes()
  *only* once rng_is_initialized() turns to true.

Up to now, the __drbg_seed() helper used to set the given DRBG instance's
->seeded state to constant DRBG_SEED_STATE_FULL. Introduce a new argument
allowing for the specification of the to be written ->seeded value instead.
Make the first of its two callers, drbg_seed(), determine the appropriate
value based on rng_is_initialized(). The remaining caller,
drbg_async_seed(), is known to get invoked only once rng_is_initialized()
is true, hence let it pass constant DRBG_SEED_STATE_FULL for the new
argument to __drbg_seed().

There is no change in behaviour, except for that the pr_devel() in
drbg_generate() would now report "unseeded" for ->pr DRBG instances which
had last been seeded when rng_is_initialized() was still evaluating to
false.

Signed-off-by: Nicolai Stange <nstange@suse.de>
Reviewed-by: Stephan Müller <smueller@chronox.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/drbg.c         |   12 ++++++++----
 include/crypto/drbg.h |    1 +
 2 files changed, 9 insertions(+), 4 deletions(-)

--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1035,14 +1035,14 @@ static const struct drbg_state_ops drbg_
  ******************************************************************/
 
 static inline int __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
-			      int reseed)
+			      int reseed, enum drbg_seed_state new_seed_state)
 {
 	int ret = drbg->d_ops->update(drbg, seed, reseed);
 
 	if (ret)
 		return ret;
 
-	drbg->seeded = DRBG_SEED_STATE_FULL;
+	drbg->seeded = new_seed_state;
 	/* 10.1.1.2 / 10.1.1.3 step 5 */
 	drbg->reseed_ctr = 1;
 
@@ -1092,7 +1092,7 @@ static void drbg_async_seed(struct work_
 	 */
 	drbg->seeded = DRBG_SEED_STATE_UNSEEDED;
 
-	__drbg_seed(drbg, &seedlist, true);
+	__drbg_seed(drbg, &seedlist, true, DRBG_SEED_STATE_FULL);
 
 	if (drbg->seeded == DRBG_SEED_STATE_FULL)
 		drbg->reseed_threshold = drbg_max_requests(drbg);
@@ -1122,6 +1122,7 @@ static int drbg_seed(struct drbg_state *
 	unsigned int entropylen = drbg_sec_strength(drbg->core->flags);
 	struct drbg_string data1;
 	LIST_HEAD(seedlist);
+	enum drbg_seed_state new_seed_state = DRBG_SEED_STATE_FULL;
 
 	/* 9.1 / 9.2 / 9.3.1 step 3 */
 	if (pers && pers->len > (drbg_max_addtl(drbg))) {
@@ -1149,6 +1150,9 @@ static int drbg_seed(struct drbg_state *
 		BUG_ON((entropylen * 2) > sizeof(entropy));
 
 		/* Get seed from in-kernel /dev/urandom */
+		if (!rng_is_initialized())
+			new_seed_state = DRBG_SEED_STATE_PARTIAL;
+
 		ret = drbg_get_random_bytes(drbg, entropy, entropylen);
 		if (ret)
 			goto out;
@@ -1205,7 +1209,7 @@ static int drbg_seed(struct drbg_state *
 		memset(drbg->C, 0, drbg_statelen(drbg));
 	}
 
-	ret = __drbg_seed(drbg, &seedlist, reseed);
+	ret = __drbg_seed(drbg, &seedlist, reseed, new_seed_state);
 
 out:
 	memzero_explicit(entropy, entropylen * 2);
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -107,6 +107,7 @@ struct drbg_test_data {
 
 enum drbg_seed_state {
 	DRBG_SEED_STATE_UNSEEDED,
+	DRBG_SEED_STATE_PARTIAL, /* Seeded with !rng_is_initialized() */
 	DRBG_SEED_STATE_FULL,
 };
 


