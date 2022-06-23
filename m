Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F60255842F
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbiFWRk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234810AbiFWRiT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:38:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F5C26572;
        Thu, 23 Jun 2022 10:08:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2DF461408;
        Thu, 23 Jun 2022 17:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8B3C341C7;
        Thu, 23 Jun 2022 17:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004097;
        bh=9P2pvINs/sgb/fVH7QEjMuFU0EZR1PdrE2W4adZFrjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AI5/Ka3vRZS9WPnxmOAMawjkR8x6EsOZ0Dw1ob9bosB7SQ8DQ9+juKpknK+9RYmoP
         P8IEZUBkrkt4NcjA1CA9XeDRMwNFNViuagMI3fpeZyoPrGZeaJFrWMCWxQiHAtgMlg
         csxQG6SdJU+GIOMYy/xV/49YYt7C8nBTqo0Omcuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolai Stange <nstange@suse.de>,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 188/237] crypto: drbg - move dynamic ->reseed_threshold adjustments to __drbg_seed()
Date:   Thu, 23 Jun 2022 18:43:42 +0200
Message-Id: <20220623164348.556012308@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
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
 crypto/drbg.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1048,6 +1048,26 @@ static inline int __drbg_seed(struct drb
 	/* 10.1.1.2 / 10.1.1.3 step 5 */
 	drbg->reseed_ctr = 1;
 
+	switch (drbg->seeded) {
+	case DRBG_SEED_STATE_UNSEEDED:
+		/* Impossible, but handle it to silence compiler warnings. */
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
 
@@ -1096,9 +1116,6 @@ static void drbg_async_seed(struct work_
 
 	__drbg_seed(drbg, &seedlist, true, DRBG_SEED_STATE_FULL);
 
-	if (drbg->seeded == DRBG_SEED_STATE_FULL)
-		drbg->reseed_threshold = drbg_max_requests(drbg);
-
 unlock:
 	mutex_unlock(&drbg->drbg_mutex);
 
@@ -1532,12 +1549,6 @@ static int drbg_prepare_hrng(struct drbg
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
 


