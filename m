Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406C555825F
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbiFWRNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233266AbiFWRMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:12:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8281C4F1E4;
        Thu, 23 Jun 2022 09:58:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1566660AD7;
        Thu, 23 Jun 2022 16:58:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF684C3411B;
        Thu, 23 Jun 2022 16:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003500;
        bh=2goHVwbk9mKBRuXvhvhtF7Suji4GpOaNtXY66FgdJ/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NCvqX7fQbK+f29fnjFaFEEwUju259IJACS1jyr7v3D75bwvwR9Y1hEShYicLOikXG
         wCuwJNmgRatXCt0tZKhXSfnSb1sIVxVGO+A7n3QI2kTTr5q0zF/FDsWOedpOcrOnF1
         Kdsi6fpUNcFTwVkDvtGV3P6xaZbmXyuTu8kYW1Mg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolai Stange <nstange@suse.de>,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 218/264] crypto: drbg - track whether DRBG was seeded with !rng_is_initialized()
Date:   Thu, 23 Jun 2022 18:43:31 +0200
Message-Id: <20220623164350.245203822@linuxfoundation.org>
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
@@ -1037,14 +1037,14 @@ static const struct drbg_state_ops drbg_
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
 
@@ -1094,7 +1094,7 @@ static void drbg_async_seed(struct work_
 	 */
 	drbg->seeded = DRBG_SEED_STATE_UNSEEDED;
 
-	__drbg_seed(drbg, &seedlist, true);
+	__drbg_seed(drbg, &seedlist, true, DRBG_SEED_STATE_FULL);
 
 	if (drbg->seeded == DRBG_SEED_STATE_FULL)
 		drbg->reseed_threshold = drbg_max_requests(drbg);
@@ -1124,6 +1124,7 @@ static int drbg_seed(struct drbg_state *
 	unsigned int entropylen = drbg_sec_strength(drbg->core->flags);
 	struct drbg_string data1;
 	LIST_HEAD(seedlist);
+	enum drbg_seed_state new_seed_state = DRBG_SEED_STATE_FULL;
 
 	/* 9.1 / 9.2 / 9.3.1 step 3 */
 	if (pers && pers->len > (drbg_max_addtl(drbg))) {
@@ -1151,6 +1152,9 @@ static int drbg_seed(struct drbg_state *
 		BUG_ON((entropylen * 2) > sizeof(entropy));
 
 		/* Get seed from in-kernel /dev/urandom */
+		if (!rng_is_initialized())
+			new_seed_state = DRBG_SEED_STATE_PARTIAL;
+
 		ret = drbg_get_random_bytes(drbg, entropy, entropylen);
 		if (ret)
 			goto out;
@@ -1207,7 +1211,7 @@ static int drbg_seed(struct drbg_state *
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
 


