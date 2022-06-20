Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D99551E7C
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343722AbiFTOAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350456AbiFTNxi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:53:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C91E60C2;
        Mon, 20 Jun 2022 06:19:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D111B811C6;
        Mon, 20 Jun 2022 13:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B859C3411B;
        Mon, 20 Jun 2022 13:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731169;
        bh=oC6QagsnF4doJQEB+8vZSfJ7w5GsUc1qORD/HSm3HiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ueJJbq/gU3W2YsNhfCP0fKBesGgTd88Gv+mCFovB0HVPoXAjBVq4n91t0hQCCn0J3
         99tQFU0vXDmAbuWyol2Z0SzEBiZ4fH8cuG+OCFXdTe8dgQegjPXws6OhqnPDb0n0mn
         ni/QiRdyZTZwGl4b1afzdjXjsVc0Mpt00tZvFig8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolai Stange <nstange@suse.de>,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 175/240] crypto: drbg - move dynamic ->reseed_threshold adjustments to __drbg_seed()
Date:   Mon, 20 Jun 2022 14:51:16 +0200
Message-Id: <20220620124744.065967203@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/drbg.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1046,6 +1046,27 @@ static inline int __drbg_seed(struct drb
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
 
@@ -1094,9 +1115,6 @@ static void drbg_async_seed(struct work_
 
 	__drbg_seed(drbg, &seedlist, true, DRBG_SEED_STATE_FULL);
 
-	if (drbg->seeded == DRBG_SEED_STATE_FULL)
-		drbg->reseed_threshold = drbg_max_requests(drbg);
-
 unlock:
 	mutex_unlock(&drbg->drbg_mutex);
 
@@ -1532,12 +1550,6 @@ static int drbg_prepare_hrng(struct drbg
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
 


