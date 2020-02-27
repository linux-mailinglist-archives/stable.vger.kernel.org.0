Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 244281710DE
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 07:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbgB0GRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 01:17:15 -0500
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:1632 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727349AbgB0GRP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 01:17:15 -0500
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Feb 2020 01:17:14 EST
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Wed, 26 Feb 2020 22:02:10 -0800
Received: from localhost.localdomain (unknown [10.197.103.150])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 9744640101;
        Wed, 26 Feb 2020 22:02:11 -0800 (PST)
From:   Vikash Bansal <bvikas@vmware.com>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <srivatsab@vmware.com>,
        <srivatsa@csail.mit.edu>, <amakhalov@vmware.com>,
        <srinidhir@vmware.com>, <bvikas@vmware.com>, <anishs@vmware.com>,
        <vsirnapalli@vmware.com>, <sharathg@vmware.com>,
        <srostedt@vmware.com>, <akaher@vmware.com>, <rostedt@goodmis.org>,
        Stephan Mueller <smueller@chronox.de>,
        Yann Droneaud <ydroneaud@opteya.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v4.19.y, v4.14.y, v4.9.y] crypto: drbg - add FIPS 140-2 CTRNG for noise source
Date:   Thu, 27 Feb 2020 05:58:05 +0000
Message-ID: <20200227055805.3011-1-bvikas@vmware.com>
X-Mailer: git-send-email 2.23.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: bvikas@vmware.com does not
 designate permitted sender hosts)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Mueller <smueller@chronox.de>

commit db07cd26ac6a418dc2823187958edcfdb415fa83 upstream

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
Signed-off-by: Vikash Bansal <bvikas@vmware.com>
---
 crypto/drbg.c         | 94 +++++++++++++++++++++++++++++++++++++++++--
 include/crypto/drbg.h |  2 +
 2 files changed, 93 insertions(+), 3 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 2a5b16bb000c..b6929eb5f565 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -219,6 +219,57 @@ static inline unsigned short drbg_sec_strength(drbg_flag_t flags)
 	}
 }
 
+/*
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
 /*
  * Convert an integer into a byte representation of this integer.
  * The byte representation is big-endian
@@ -998,6 +1049,22 @@ static inline int __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
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
@@ -1006,16 +1073,20 @@ static void drbg_async_seed(struct work_struct *work)
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
@@ -1030,6 +1101,7 @@ static void drbg_async_seed(struct work_struct *work)
 	if (drbg->seeded)
 		drbg->reseed_threshold = drbg_max_requests(drbg);
 
+unlock:
 	mutex_unlock(&drbg->drbg_mutex);
 
 	memzero_explicit(entropy, entropylen);
@@ -1081,7 +1153,9 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 		BUG_ON((entropylen * 2) > sizeof(entropy));
 
 		/* Get seed from in-kernel /dev/urandom */
-		get_random_bytes(entropy, entropylen);
+		ret = drbg_get_random_bytes(drbg, entropy, entropylen);
+		if (ret)
+			goto out;
 
 		if (!drbg->jent) {
 			drbg_string_fill(&data1, entropy, entropylen);
@@ -1094,7 +1168,7 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 						   entropylen);
 			if (ret) {
 				pr_devel("DRBG: jent failed with %d\n", ret);
-				return ret;
+				goto out;
 			}
 
 			drbg_string_fill(&data1, entropy, entropylen * 2);
@@ -1121,6 +1195,7 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 
 	ret = __drbg_seed(drbg, &seedlist, reseed);
 
+out:
 	memzero_explicit(entropy, entropylen * 2);
 
 	return ret;
@@ -1142,6 +1217,11 @@ static inline void drbg_dealloc_state(struct drbg_state *drbg)
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
@@ -1211,6 +1291,14 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
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
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index 3fb581bf3b87..8c9af21efce1 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -129,6 +129,8 @@ struct drbg_state {
 
 	bool seeded;		/* DRBG fully seeded? */
 	bool pr;		/* Prediction resistance enabled? */
+	bool fips_primed;	/* Continuous test primed? */
+	unsigned char *prev;	/* FIPS 140-2 continuous test value */
 	struct work_struct seed_work;	/* asynchronous seeding support */
 	struct crypto_rng *jent;
 	const struct drbg_state_ops *d_ops;
-- 
2.19.0

