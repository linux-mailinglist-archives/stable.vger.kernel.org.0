Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D0D53604C
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351887AbiE0Lr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351957AbiE0LrY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:47:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01A414ACAA;
        Fri, 27 May 2022 04:43:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 728CE61D51;
        Fri, 27 May 2022 11:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80047C385A9;
        Fri, 27 May 2022 11:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651790;
        bh=ZDfu5CQCYc0Tiz0YhFCXWlPQPKh8EEqa7qJFhykOJGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UmDxHezdF+LBQqPYbl8qrivt11XkgHEVEkcUL7AIfqiTHkUisfaqWbceNxqOSvAmk
         ubKecuykbn5PurstGs+vXZgfqUztil7QoFM1595+zEMEkLfauWiHrSpoXFZygcMLR9
         t/Pai5xavMNdhIVv/BW9V8rvn4GbrFYUpf6jJvpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 050/163] random: access input_pool_data directly rather than through pointer
Date:   Fri, 27 May 2022 10:48:50 +0200
Message-Id: <20220527084835.015625227@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
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

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 6c0eace6e1499712583b6ee62d95161e8b3449f5 upstream.

This gets rid of another abstraction we no longer need. It would be nice
if we could instead make pool an array rather than a pointer, but the
latent entropy plugin won't be able to do its magic in that case. So
instead we put all accesses to the input pool's actual data through the
input_pool_data array directly.

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -496,17 +496,12 @@ MODULE_PARM_DESC(ratelimit_disable, "Dis
 static u32 input_pool_data[POOL_WORDS] __latent_entropy;
 
 static struct {
-	/* read-only data: */
-	u32 *pool;
-
-	/* read-write data: */
 	spinlock_t lock;
 	u16 add_ptr;
 	u16 input_rotate;
 	int entropy_count;
 } input_pool = {
 	.lock = __SPIN_LOCK_UNLOCKED(input_pool.lock),
-	.pool = input_pool_data
 };
 
 static ssize_t extract_entropy(void *buf, size_t nbytes, int min);
@@ -544,15 +539,15 @@ static void _mix_pool_bytes(const void *
 		i = (i - 1) & POOL_WORDMASK;
 
 		/* XOR in the various taps */
-		w ^= input_pool.pool[i];
-		w ^= input_pool.pool[(i + POOL_TAP1) & POOL_WORDMASK];
-		w ^= input_pool.pool[(i + POOL_TAP2) & POOL_WORDMASK];
-		w ^= input_pool.pool[(i + POOL_TAP3) & POOL_WORDMASK];
-		w ^= input_pool.pool[(i + POOL_TAP4) & POOL_WORDMASK];
-		w ^= input_pool.pool[(i + POOL_TAP5) & POOL_WORDMASK];
+		w ^= input_pool_data[i];
+		w ^= input_pool_data[(i + POOL_TAP1) & POOL_WORDMASK];
+		w ^= input_pool_data[(i + POOL_TAP2) & POOL_WORDMASK];
+		w ^= input_pool_data[(i + POOL_TAP3) & POOL_WORDMASK];
+		w ^= input_pool_data[(i + POOL_TAP4) & POOL_WORDMASK];
+		w ^= input_pool_data[(i + POOL_TAP5) & POOL_WORDMASK];
 
 		/* Mix the result back in with a twist */
-		input_pool.pool[i] = (w >> 3) ^ twist_table[w & 7];
+		input_pool_data[i] = (w >> 3) ^ twist_table[w & 7];
 
 		/*
 		 * Normally, we add 7 bits of rotation to the pool.
@@ -1369,7 +1364,7 @@ static void extract_buf(u8 *out)
 
 	/* Generate a hash across the pool */
 	spin_lock_irqsave(&input_pool.lock, flags);
-	blake2s_update(&state, (const u8 *)input_pool.pool, POOL_BYTES);
+	blake2s_update(&state, (const u8 *)input_pool_data, POOL_BYTES);
 	blake2s_final(&state, hash); /* final zeros out state */
 
 	/*


