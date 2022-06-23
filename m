Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E180F558090
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbiFWQwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233826AbiFWQvm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:51:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DDD183;
        Thu, 23 Jun 2022 09:50:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 121ECB8248A;
        Thu, 23 Jun 2022 16:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B08C3411B;
        Thu, 23 Jun 2022 16:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002999;
        bh=Y9mVDio3WEFZZp4RGG01fMDPYBjNy9mVBmjuXp065Q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j+k4n5xcw8UnFvt9MKwMo8L+iJsp1DogziU7FfE+vPTTBndSfXFLjIva/SrpN1cVR
         6EQafH6WNgTyA4xdQjzG49T0xRlmE3aPWMn4uy0PbkJlnq+NulF+Kf3EPqQXkcRqNH
         RgPYIRhQPAgLUXA0ebV0wQ1tvwaVJeaUYvA01O28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 097/264] random: remove incomplete last_data logic
Date:   Thu, 23 Jun 2022 18:41:30 +0200
Message-Id: <20220623164346.815943386@linuxfoundation.org>
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

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit a4bfa9b31802c14ff5847123c12b98d5e36b3985 upstream.

There were a few things added under the "if (fips_enabled)" banner,
which never really got completed, and the FIPS people anyway are
choosing a different direction. Rather than keep around this halfbaked
code, get rid of it so that we can focus on a single design of the RNG
rather than two designs.

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   40 ++++------------------------------------
 1 file changed, 4 insertions(+), 36 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -337,8 +337,6 @@
 #include <linux/spinlock.h>
 #include <linux/kthread.h>
 #include <linux/percpu.h>
-#include <linux/cryptohash.h>
-#include <linux/fips.h>
 #include <linux/ptrace.h>
 #include <linux/kmemcheck.h>
 #include <linux/workqueue.h>
@@ -519,14 +517,12 @@ struct entropy_store {
 	u16 add_ptr;
 	u16 input_rotate;
 	int entropy_count;
-	unsigned int last_data_init:1;
-	u8 last_data[EXTRACT_SIZE];
 };
 
 static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 			       size_t nbytes, int min, int rsvd);
 static ssize_t _extract_entropy(struct entropy_store *r, void *buf,
-				size_t nbytes, int fips);
+				size_t nbytes);
 
 static void crng_reseed(struct crng_state *crng, struct entropy_store *r);
 static u32 input_pool_data[INPUT_POOL_WORDS] __latent_entropy;
@@ -822,7 +818,7 @@ static void crng_initialize_secondary(st
 
 static void __init crng_initialize_primary(struct crng_state *crng)
 {
-	_extract_entropy(&input_pool, &crng->state[4], sizeof(u32) * 12, 0);
+	_extract_entropy(&input_pool, &crng->state[4], sizeof(u32) * 12);
 	if (crng_init_try_arch_early(crng) && trust_cpu && crng_init < 2) {
 		invalidate_batched_entropy();
 		numa_crng_init();
@@ -1478,22 +1474,13 @@ static void extract_buf(struct entropy_s
 }
 
 static ssize_t _extract_entropy(struct entropy_store *r, void *buf,
-				size_t nbytes, int fips)
+				size_t nbytes)
 {
 	ssize_t ret = 0, i;
 	u8 tmp[EXTRACT_SIZE];
-	unsigned long flags;
 
 	while (nbytes) {
 		extract_buf(r, tmp);
-
-		if (fips) {
-			spin_lock_irqsave(&r->lock, flags);
-			if (!memcmp(tmp, r->last_data, EXTRACT_SIZE))
-				panic("Hardware RNG duplicated output!\n");
-			memcpy(r->last_data, tmp, EXTRACT_SIZE);
-			spin_unlock_irqrestore(&r->lock, flags);
-		}
 		i = min_t(int, nbytes, EXTRACT_SIZE);
 		memcpy(buf, tmp, i);
 		nbytes -= i;
@@ -1519,28 +1506,9 @@ static ssize_t _extract_entropy(struct e
 static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 				 size_t nbytes, int min, int reserved)
 {
-	u8 tmp[EXTRACT_SIZE];
-	unsigned long flags;
-
-	/* if last_data isn't primed, we need EXTRACT_SIZE extra bytes */
-	if (fips_enabled) {
-		spin_lock_irqsave(&r->lock, flags);
-		if (!r->last_data_init) {
-			r->last_data_init = 1;
-			spin_unlock_irqrestore(&r->lock, flags);
-			trace_extract_entropy(r->name, EXTRACT_SIZE,
-					      ENTROPY_BITS(r), _RET_IP_);
-			extract_buf(r, tmp);
-			spin_lock_irqsave(&r->lock, flags);
-			memcpy(r->last_data, tmp, EXTRACT_SIZE);
-		}
-		spin_unlock_irqrestore(&r->lock, flags);
-	}
-
 	trace_extract_entropy(r->name, nbytes, ENTROPY_BITS(r), _RET_IP_);
 	nbytes = account(r, nbytes, min, reserved);
-
-	return _extract_entropy(r, buf, nbytes, fips_enabled);
+	return _extract_entropy(r, buf, nbytes);
 }
 
 #define warn_unseeded_randomness(previous) \


