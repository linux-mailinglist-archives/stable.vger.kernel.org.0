Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C98B8558205
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiFWRJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233934AbiFWRI3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:08:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5AF54BFE;
        Thu, 23 Jun 2022 09:57:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A91A60AE7;
        Thu, 23 Jun 2022 16:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C0CC341C5;
        Thu, 23 Jun 2022 16:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003418;
        bh=G1HhTB/ni4xta0LtrEap2YX3FQEIHfqQnjNSgsOz9D0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zn9yjJdnkOyIn+8cwqTkZt0DOMYlX7iKRkNXPGN8DaL454qDczKltST1EqpRHtrbM
         UH2/3NdEIXtla7T3soBlRFzTG7+btEkO2egfcs3tsjNwjEtmPQuXqAGyqPaCovNJgf
         O4Xt/fabnm8d6I2BCUHWZ03XHj5xpVoklSXI6Diw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Mueller <smueller@chronox.de>,
        Yann Droneaud <ydroneaud@opteya.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 215/264] crypto: drbg - add FIPS 140-2 CTRNG for noise source
Date:   Thu, 23 Jun 2022 18:43:28 +0200
Message-Id: <20220623164350.158407689@linuxfoundation.org>
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

From: Stephan Mueller <smueller@chronox.de>

commit db07cd26ac6a418dc2823187958edcfdb415fa83 upstream.

FIPS 140-2 section 4.9.2 requires a continuous self test of the noise
source. Up to kernel 4.8 drivers/char/random.c provided this continuous
self test. Afterwards it was moved to a location that is inconsistent
with the FIPS 140-2 requirements. The relevant patch was
e192be9d9a30555aae2ca1dc3aad37cba484cd4a .

Thus, the FIPS 140-2 CTRNG is added to the DRBG when it obtains the
seed. This patch resurrects the function drbg_fips_continous_test that
existed some time ago and applies it to the noise sources. The patch
that removed the drbg_fips_continous_test was
b3614763059b82c26bdd02ffcb1c016c1132aad0 .

The Jitter RNG implements its own FIPS 140-2 self test and thus does not
need to be subjected to the test in the DRBG.

The patch contains a tiny fix to ensure proper zeroization in case of an
error during the Jitter RNG data gathering.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
Reviewed-by: Yann Droneaud <ydroneaud@opteya.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/drbg.c         |   94 ++++++++++++++++++++++++++++++++++++++++++++++++--
 include/crypto/drbg.h |    2 +
 2 files changed, 93 insertions(+), 3 deletions(-)

--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -220,6 +220,57 @@ static inline unsigned short drbg_sec_st
 }
 
 /*
+ * FIPS 140-2 continuous self test for the noise source
+ * The test is performed on the noise source input data. Thus, the function
+ * implicitly knows the size of the buffer to be equal to the security
+ * strength.
+ *
+ * Note, this function disregards the nonce trailing the entropy data during
+ * initial seeding.
+ *
+ * drbg->drbg_mutex must have been taken.
+ *
+ * @drbg DRBG handle
+ * @entropy buffer of seed data to be checked
+ *
+ * return:
+ *	0 on success
+ *	-EAGAIN on when the CTRNG is not yet primed
+ *	< 0 on error
+ */
+static int drbg_fips_continuous_test(struct drbg_state *drbg,
+				     const unsigned char *entropy)
+{
+	unsigned short entropylen = drbg_sec_strength(drbg->core->flags);
+	int ret = 0;
+
+	if (!IS_ENABLED(CONFIG_CRYPTO_FIPS))
+		return 0;
+
+	/* skip test if we test the overall system */
+	if (list_empty(&drbg->test_data.list))
+		return 0;
+	/* only perform test in FIPS mode */
+	if (!fips_enabled)
+		return 0;
+
+	if (!drbg->fips_primed) {
+		/* Priming of FIPS test */
+		memcpy(drbg->prev, entropy, entropylen);
+		drbg->fips_primed = true;
+		/* priming: another round is needed */
+		return -EAGAIN;
+	}
+	ret = memcmp(drbg->prev, entropy, entropylen);
+	if (!ret)
+		panic("DRBG continuous self test failed\n");
+	memcpy(drbg->prev, entropy, entropylen);
+
+	/* the test shall pass when the two values are not equal */
+	return 0;
+}
+
+/*
  * Convert an integer into a byte representation of this integer.
  * The byte representation is big-endian
  *
@@ -1000,6 +1051,22 @@ static inline int __drbg_seed(struct drb
 	return ret;
 }
 
+static inline int drbg_get_random_bytes(struct drbg_state *drbg,
+					unsigned char *entropy,
+					unsigned int entropylen)
+{
+	int ret;
+
+	do {
+		get_random_bytes(entropy, entropylen);
+		ret = drbg_fips_continuous_test(drbg, entropy);
+		if (ret && ret != -EAGAIN)
+			return ret;
+	} while (ret);
+
+	return 0;
+}
+
 static void drbg_async_seed(struct work_struct *work)
 {
 	struct drbg_string data;
@@ -1008,16 +1075,20 @@ static void drbg_async_seed(struct work_
 					       seed_work);
 	unsigned int entropylen = drbg_sec_strength(drbg->core->flags);
 	unsigned char entropy[32];
+	int ret;
 
 	BUG_ON(!entropylen);
 	BUG_ON(entropylen > sizeof(entropy));
-	get_random_bytes(entropy, entropylen);
 
 	drbg_string_fill(&data, entropy, entropylen);
 	list_add_tail(&data.list, &seedlist);
 
 	mutex_lock(&drbg->drbg_mutex);
 
+	ret = drbg_get_random_bytes(drbg, entropy, entropylen);
+	if (ret)
+		goto unlock;
+
 	/* If nonblocking pool is initialized, deactivate Jitter RNG */
 	crypto_free_rng(drbg->jent);
 	drbg->jent = NULL;
@@ -1032,6 +1103,7 @@ static void drbg_async_seed(struct work_
 	if (drbg->seeded)
 		drbg->reseed_threshold = drbg_max_requests(drbg);
 
+unlock:
 	mutex_unlock(&drbg->drbg_mutex);
 
 	memzero_explicit(entropy, entropylen);
@@ -1083,7 +1155,9 @@ static int drbg_seed(struct drbg_state *
 		BUG_ON((entropylen * 2) > sizeof(entropy));
 
 		/* Get seed from in-kernel /dev/urandom */
-		get_random_bytes(entropy, entropylen);
+		ret = drbg_get_random_bytes(drbg, entropy, entropylen);
+		if (ret)
+			goto out;
 
 		if (!drbg->jent) {
 			drbg_string_fill(&data1, entropy, entropylen);
@@ -1096,7 +1170,7 @@ static int drbg_seed(struct drbg_state *
 						   entropylen);
 			if (ret) {
 				pr_devel("DRBG: jent failed with %d\n", ret);
-				return ret;
+				goto out;
 			}
 
 			drbg_string_fill(&data1, entropy, entropylen * 2);
@@ -1123,6 +1197,7 @@ static int drbg_seed(struct drbg_state *
 
 	ret = __drbg_seed(drbg, &seedlist, reseed);
 
+out:
 	memzero_explicit(entropy, entropylen * 2);
 
 	return ret;
@@ -1144,6 +1219,11 @@ static inline void drbg_dealloc_state(st
 	drbg->reseed_ctr = 0;
 	drbg->d_ops = NULL;
 	drbg->core = NULL;
+	if (IS_ENABLED(CONFIG_CRYPTO_FIPS)) {
+		kzfree(drbg->prev);
+		drbg->prev = NULL;
+		drbg->fips_primed = false;
+	}
 }
 
 /*
@@ -1213,6 +1293,14 @@ static inline int drbg_alloc_state(struc
 		drbg->scratchpad = PTR_ALIGN(drbg->scratchpadbuf, ret + 1);
 	}
 
+	if (IS_ENABLED(CONFIG_CRYPTO_FIPS)) {
+		drbg->prev = kzalloc(drbg_sec_strength(drbg->core->flags),
+				     GFP_KERNEL);
+		if (!drbg->prev)
+			goto fini;
+		drbg->fips_primed = false;
+	}
+
 	return 0;
 
 fini:
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -131,6 +131,8 @@ struct drbg_state {
 
 	bool seeded;		/* DRBG fully seeded? */
 	bool pr;		/* Prediction resistance enabled? */
+	bool fips_primed;	/* Continuous test primed? */
+	unsigned char *prev;	/* FIPS 140-2 continuous test value */
 	struct work_struct seed_work;	/* asynchronous seeding support */
 	struct crypto_rng *jent;
 	const struct drbg_state_ops *d_ops;


