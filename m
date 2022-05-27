Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB909536099
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352019AbiE0Lvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352351AbiE0LuU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:50:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754DE13F90C;
        Fri, 27 May 2022 04:44:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEB4461CF0;
        Fri, 27 May 2022 11:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDAAAC385A9;
        Fri, 27 May 2022 11:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651868;
        bh=Wf5YjyGS/Miwbxm5fWl0FgB1C4SqltlK0Q2dh7YVefI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dct5adY0hzrNS2wOKSorK4QFntmDPH99w5gCOLb1sXxWYuP7vX5vSzbMjxtGcqVnU
         STnRjaCR+mpxDTiVcQsOQroM/wlQ1EroQ1Kmb7ibZXKnDDC8PIOA/Rf2BXdCyX7syC
         9ZzfiakmEHdfexSC3axvSOiwbtXmRh/w/5135wn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 043/145] random: remove use_input_pool parameter from crng_reseed()
Date:   Fri, 27 May 2022 10:49:04 +0200
Message-Id: <20220527084856.086474331@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084850.364560116@linuxfoundation.org>
References: <20220527084850.364560116@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -365,7 +365,7 @@ static struct {
 
 static void extract_entropy(void *buf, size_t nbytes);
 
-static void crng_reseed(struct crng_state *crng, bool use_input_pool);
+static void crng_reseed(struct crng_state *crng);
 
 /*
  * This function adds bytes into the entropy "pool".  It does not
@@ -464,7 +464,7 @@ static void credit_entropy_bits(int nbit
 	trace_credit_entropy_bits(nbits, entropy_count, _RET_IP_);
 
 	if (crng_init < 2 && entropy_count >= POOL_MIN_BITS)
-		crng_reseed(&primary_crng, true);
+		crng_reseed(&primary_crng);
 }
 
 /*********************************************************************
@@ -701,7 +701,7 @@ static int crng_slow_load(const u8 *cp,
 	return 1;
 }
 
-static void crng_reseed(struct crng_state *crng, bool use_input_pool)
+static void crng_reseed(struct crng_state *crng)
 {
 	unsigned long flags;
 	int i;
@@ -710,7 +710,7 @@ static void crng_reseed(struct crng_stat
 		u32 key[8];
 	} buf;
 
-	if (use_input_pool) {
+	if (crng == &primary_crng) {
 		int entropy_count;
 		do {
 			entropy_count = READ_ONCE(input_pool.entropy_count);
@@ -748,7 +748,7 @@ static void _extract_crng(struct crng_st
 		init_time = READ_ONCE(crng->init_time);
 		if (time_after(READ_ONCE(crng_global_init_time), init_time) ||
 		    time_after(jiffies, init_time + CRNG_RESEED_INTERVAL))
-			crng_reseed(crng, crng == &primary_crng);
+			crng_reseed(crng);
 	}
 	spin_lock_irqsave(&crng->lock, flags);
 	chacha20_block(&crng->state[0], out);
@@ -1547,7 +1547,7 @@ static long random_ioctl(struct file *f,
 			return -EPERM;
 		if (crng_init < 2)
 			return -ENODATA;
-		crng_reseed(&primary_crng, true);
+		crng_reseed(&primary_crng);
 		WRITE_ONCE(crng_global_init_time, jiffies - 1);
 		return 0;
 	default:


