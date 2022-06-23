Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4677558233
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbiFWRLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiFWRKM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:10:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2E6562E3;
        Thu, 23 Jun 2022 09:57:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C8FFB8248F;
        Thu, 23 Jun 2022 16:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9E2C3411B;
        Thu, 23 Jun 2022 16:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003451;
        bh=ipRS0EUJ98S9tQS9u0oR40qjSmp9Ac1uORIC/7P/V1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0EFUHUnogBPaSk5CBHcmKtWPJMAPftGnI0xq/IF2BsUw899Be9JhQ/0+dX2b0BRd7
         Vt2QZ0c8EyXAwmMO8mV2aGZQSMwJBXLq4169zZFcE+jqleiB1JsKmLcXtPyqVeBDYP
         +1KPCSTmp5B4jaJxuPaFgD5+En4tTJ+JpTRbUeoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 216/264] crypto: drbg - always seeded with SP800-90B compliant noise source
Date:   Thu, 23 Jun 2022 18:43:29 +0200
Message-Id: <20220623164350.187964250@linuxfoundation.org>
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

From: "Stephan Müller" <smueller@chronox.de>

commit 97f2650e504033376e8813691cb6eccf73151676 upstream.

As the Jitter RNG provides an SP800-90B compliant noise source, use this
noise source always for the (re)seeding of the DRBG.

To make sure the DRBG is always properly seeded, the reseed threshold
is reduced to 1<<20 generate operations.

The Jitter RNG may report health test failures. Such health test
failures are treated as transient as follows. The DRBG will not reseed
from the Jitter RNG (but from get_random_bytes) in case of a health
test failure. Though, it produces the requested random number.

The Jitter RNG has a failure counter where at most 1024 consecutive
resets due to a health test failure are considered as a transient error.
If more consecutive resets are required, the Jitter RNG will return
a permanent error which is returned to the caller by the DRBG. With this
approach, the worst case reseed threshold is significantly lower than
mandated by SP800-90A in order to seed with an SP800-90B noise source:
the DRBG has a reseed threshold of 2^20 * 1024 = 2^30 generate requests.

Yet, in case of a transient Jitter RNG health test failure, the DRBG is
seeded with the data obtained from get_random_bytes.

However, if the Jitter RNG fails during the initial seeding operation
even due to a health test error, the DRBG will send an error to the
caller because at that time, the DRBG has received no seed that is
SP800-90B compliant.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/drbg.c         |   26 +++++++++++++++++++-------
 include/crypto/drbg.h |    6 +-----
 2 files changed, 20 insertions(+), 12 deletions(-)

--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1089,10 +1089,6 @@ static void drbg_async_seed(struct work_
 	if (ret)
 		goto unlock;
 
-	/* If nonblocking pool is initialized, deactivate Jitter RNG */
-	crypto_free_rng(drbg->jent);
-	drbg->jent = NULL;
-
 	/* Set seeded to false so that if __drbg_seed fails the
 	 * next generate call will trigger a reseed.
 	 */
@@ -1170,7 +1166,23 @@ static int drbg_seed(struct drbg_state *
 						   entropylen);
 			if (ret) {
 				pr_devel("DRBG: jent failed with %d\n", ret);
-				goto out;
+
+				/*
+				 * Do not treat the transient failure of the
+				 * Jitter RNG as an error that needs to be
+				 * reported. The combined number of the
+				 * maximum reseed threshold times the maximum
+				 * number of Jitter RNG transient errors is
+				 * less than the reseed threshold required by
+				 * SP800-90A allowing us to treat the
+				 * transient errors as such.
+				 *
+				 * However, we mandate that at least the first
+				 * seeding operation must succeed with the
+				 * Jitter RNG.
+				 */
+				if (!reseed || ret != -EAGAIN)
+					goto out;
 			}
 
 			drbg_string_fill(&data1, entropy, entropylen * 2);
@@ -1495,6 +1507,8 @@ static int drbg_prepare_hrng(struct drbg
 	if (list_empty(&drbg->test_data.list))
 		return 0;
 
+	drbg->jent = crypto_alloc_rng("jitterentropy_rng", 0, 0);
+
 	INIT_WORK(&drbg->seed_work, drbg_async_seed);
 
 	drbg->random_ready.notifier_call = drbg_schedule_async_seed;
@@ -1513,8 +1527,6 @@ static int drbg_prepare_hrng(struct drbg
 		return err;
 	}
 
-	drbg->jent = crypto_alloc_rng("jitterentropy_rng", 0, 0);
-
 	/*
 	 * Require frequent reseeds until the seed source is fully
 	 * initialized.
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -186,11 +186,7 @@ static inline size_t drbg_max_addtl(stru
 static inline size_t drbg_max_requests(struct drbg_state *drbg)
 {
 	/* SP800-90A requires 2**48 maximum requests before reseeding */
-#if (__BITS_PER_LONG == 32)
-	return SIZE_MAX;
-#else
-	return (1UL<<48);
-#endif
+	return (1<<20);
 }
 
 /*


