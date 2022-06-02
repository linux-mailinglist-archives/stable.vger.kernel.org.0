Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C45E53BFAF
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 22:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238938AbiFBUXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 16:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238987AbiFBUXK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 16:23:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86499A180
        for <stable@vger.kernel.org>; Thu,  2 Jun 2022 13:23:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B120B82187
        for <stable@vger.kernel.org>; Thu,  2 Jun 2022 20:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BA8C34115;
        Thu,  2 Jun 2022 20:23:05 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="JJ2HI6xN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654201384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SGXdy7XW6V8eZzj7GdMO8EZUcbMpX3CCddAkJ+Ze/LU=;
        b=JJ2HI6xNm9FgXLmyMQWUPMrB+ahTKeoyQ2jBojpz5hPIbnV2rYuah1Cl7stgyVx0HeURqR
        XVeUNGIvovntq+m07jDnHWD+e+QY8J6xnjL8yYGLIYWFLLVxYhbeetK6Q2W+GOpZJx04Wq
        /UVtJHBIkVqFi1aUJYCkVXKWEKv01D8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e7c1fa7f (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 2 Jun 2022 20:23:04 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Subject: [PATCH stable 5.10.y 4/5] crypto: drbg - move dynamic ->reseed_threshold adjustments to __drbg_seed()
Date:   Thu,  2 Jun 2022 22:22:31 +0200
Message-Id: <20220602202232.281326-5-Jason@zx2c4.com>
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

commit 262d83a4290c331cd4f617a457408bdb82fbb738 upstream.

Since commit 42ea507fae1a ("crypto: drbg - reseed often if seedsource is
degraded"), the maximum seed lifetime represented by ->reseed_threshold
gets temporarily lowered if the get_random_bytes() source cannot provide
sufficient entropy yet, as is common during boot, and restored back to
the original value again once that has changed.

More specifically, if the add_random_ready_callback() invoked from
drbg_prepare_hrng() in the course of DRBG instantiation does not return
-EALREADY, that is, if get_random_bytes() has not been fully initialized
at this point yet, drbg_prepare_hrng() will lower ->reseed_threshold
to a value of 50. The drbg_async_seed() scheduled from said
random_ready_callback will eventually restore the original value.

A future patch will replace the random_ready_callback based notification
mechanism and thus, there will be no add_random_ready_callback() return
value anymore which could get compared to -EALREADY.

However, there's __drbg_seed() which gets invoked in the course of both,
the DRBG instantiation as well as the eventual reseeding from
get_random_bytes() in aforementioned drbg_async_seed(), if any. Moreover,
it knows about the get_random_bytes() initialization state by the time the
seed data had been obtained from it: the new_seed_state argument introduced
with the previous patch would get set to DRBG_SEED_STATE_PARTIAL in case
get_random_bytes() had not been fully initialized yet and to
DRBG_SEED_STATE_FULL otherwise. Thus, __drbg_seed() provides a convenient
alternative for managing that ->reseed_threshold lowering and restoring at
a central place.

Move all ->reseed_threshold adjustment code from drbg_prepare_hrng() and
drbg_async_seed() respectively to __drbg_seed(). Make __drbg_seed()
lower the ->reseed_threshold to 50 in case its new_seed_state argument
equals DRBG_SEED_STATE_PARTIAL and let it restore the original value
otherwise.

There is no change in behaviour.

Signed-off-by: Nicolai Stange <nstange@suse.de>
Reviewed-by: Stephan Müller <smueller@chronox.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 crypto/drbg.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 7723d6e494aa..bec9dd3fc761 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1046,6 +1046,27 @@ static inline int __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
 	/* 10.1.1.2 / 10.1.1.3 step 5 */
 	drbg->reseed_ctr = 1;
 
+	switch (drbg->seeded) {
+	case DRBG_SEED_STATE_UNSEEDED:
+		/* Impossible, but handle it to silence compiler warnings. */
+		fallthrough;
+	case DRBG_SEED_STATE_PARTIAL:
+		/*
+		 * Require frequent reseeds until the seed source is
+		 * fully initialized.
+		 */
+		drbg->reseed_threshold = 50;
+		break;
+
+	case DRBG_SEED_STATE_FULL:
+		/*
+		 * Seed source has become fully initialized, frequent
+		 * reseeds no longer required.
+		 */
+		drbg->reseed_threshold = drbg_max_requests(drbg);
+		break;
+	}
+
 	return ret;
 }
 
@@ -1094,9 +1115,6 @@ static void drbg_async_seed(struct work_struct *work)
 
 	__drbg_seed(drbg, &seedlist, true, DRBG_SEED_STATE_FULL);
 
-	if (drbg->seeded == DRBG_SEED_STATE_FULL)
-		drbg->reseed_threshold = drbg_max_requests(drbg);
-
 unlock:
 	mutex_unlock(&drbg->drbg_mutex);
 
@@ -1532,12 +1550,6 @@ static int drbg_prepare_hrng(struct drbg_state *drbg)
 		return err;
 	}
 
-	/*
-	 * Require frequent reseeds until the seed source is fully
-	 * initialized.
-	 */
-	drbg->reseed_threshold = 50;
-
 	return err;
 }
 
-- 
2.35.1

