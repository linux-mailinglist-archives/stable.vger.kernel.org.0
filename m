Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40BF15580B1
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbiFWQxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233894AbiFWQvt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:51:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7983317E0F;
        Thu, 23 Jun 2022 09:51:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BD79B8248A;
        Thu, 23 Jun 2022 16:50:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6888C3411B;
        Thu, 23 Jun 2022 16:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003058;
        bh=CQMhwHR29zZJlh1Y+rYCyE6pbM6SkKc88NIVtRuqDZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b4ATf7nGAq66iZ/5ZVoNOlLUgnS3A6JWWjBJLgvSBMVT50FiID4BHlgoAFe2Ji0rQ
         4vMJ9cNBd5GZQjMMOX7emLub+b1tFK6afIJVHYHnIpLlYlyf+rcPJD5LISYJBXmYCa
         WuBHbLjHGIiECA24sab5n5riAglOsMERfa7nlTCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 115/264] random: remove use_input_pool parameter from crng_reseed()
Date:   Thu, 23 Jun 2022 18:41:48 +0200
Message-Id: <20220623164347.322756735@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@google.com>

commit 5d58ea3a31cc98b9fa563f6921d3d043bf0103d1 upstream.

The primary_crng is always reseeded from the input_pool, while the NUMA
crngs are always reseeded from the primary_crng.  Remove the redundant
'use_input_pool' parameter from crng_reseed() and just directly check
whether the crng is the primary_crng.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -366,7 +366,7 @@ static struct {
 
 static void extract_entropy(void *buf, size_t nbytes);
 
-static void crng_reseed(struct crng_state *crng, bool use_input_pool);
+static void crng_reseed(struct crng_state *crng);
 
 /*
  * This function adds bytes into the entropy "pool".  It does not
@@ -465,7 +465,7 @@ static void credit_entropy_bits(int nbit
 	trace_credit_entropy_bits(nbits, entropy_count, _RET_IP_);
 
 	if (crng_init < 2 && entropy_count >= POOL_MIN_BITS)
-		crng_reseed(&primary_crng, true);
+		crng_reseed(&primary_crng);
 }
 
 /*********************************************************************
@@ -752,7 +752,7 @@ static int crng_slow_load(const u8 *cp,
 	return 1;
 }
 
-static void crng_reseed(struct crng_state *crng, bool use_input_pool)
+static void crng_reseed(struct crng_state *crng)
 {
 	unsigned long flags;
 	int i;
@@ -761,7 +761,7 @@ static void crng_reseed(struct crng_stat
 		u32 key[8];
 	} buf;
 
-	if (use_input_pool) {
+	if (crng == &primary_crng) {
 		int entropy_count;
 		do {
 			entropy_count = READ_ONCE(input_pool.entropy_count);
@@ -799,7 +799,7 @@ static void _extract_crng(struct crng_st
 		init_time = READ_ONCE(crng->init_time);
 		if (time_after(READ_ONCE(crng_global_init_time), init_time) ||
 		    time_after(jiffies, init_time + CRNG_RESEED_INTERVAL))
-			crng_reseed(crng, crng == &primary_crng);
+			crng_reseed(crng);
 	}
 	spin_lock_irqsave(&crng->lock, flags);
 	chacha20_block(&crng->state[0], out);
@@ -1598,7 +1598,7 @@ static long random_ioctl(struct file *f,
 			return -EPERM;
 		if (crng_init < 2)
 			return -ENODATA;
-		crng_reseed(&primary_crng, true);
+		crng_reseed(&primary_crng);
 		WRITE_ONCE(crng_global_init_time, jiffies - 1);
 		return 0;
 	default:


