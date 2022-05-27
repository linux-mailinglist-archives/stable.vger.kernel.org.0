Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0C5053609E
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346310AbiE0LwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352793AbiE0Luw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:50:52 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5501269B6;
        Fri, 27 May 2022 04:45:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D2C1ACE1164;
        Fri, 27 May 2022 11:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65B5C385A9;
        Fri, 27 May 2022 11:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651919;
        bh=s6T+HuT78bAP0HH1vMwcpZGWnTvNxrhKCd8tLlgc4lE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kskKI+FT047460vEP/Q6bHt/q1i89kVyK+EsQnyo2MsMYD3f06qDcGydsO/GXBK4f
         Uj2Mc24qQb+BJOMdon6FsFGYSyGl3oggLisB6CoC+EwbAS01vlZBGWA1qTjF2T9ir7
         cZD3ETAGDqMHlv2STKBujq5E/M3gclZIJrRrB26A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.17 093/111] random: avoid initializing twice in credit race
Date:   Fri, 27 May 2022 10:50:05 +0200
Message-Id: <20220527084832.577576318@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084819.133490171@linuxfoundation.org>
References: <20220527084819.133490171@linuxfoundation.org>
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

commit fed7ef061686cc813b1f3d8d0edc6c35b4d3537b upstream.

Since all changes of crng_init now go through credit_init_bits(), we can
fix a long standing race in which two concurrent callers of
credit_init_bits() have the new bit count >= some threshold, but are
doing so with crng_init as a lower threshold, checked outside of a lock,
resulting in crng_reseed() or similar being called twice.

In order to fix this, we can use the original cmpxchg value of the bit
count, and only change crng_init when the bit count transitions from
below a threshold to meeting the threshold.

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -821,7 +821,7 @@ static void extract_entropy(void *buf, s
 
 static void credit_init_bits(size_t nbits)
 {
-	unsigned int init_bits, orig, add;
+	unsigned int new, orig, add;
 	unsigned long flags;
 
 	if (crng_ready() || !nbits)
@@ -831,12 +831,12 @@ static void credit_init_bits(size_t nbit
 
 	do {
 		orig = READ_ONCE(input_pool.init_bits);
-		init_bits = min_t(unsigned int, POOL_BITS, orig + add);
-	} while (cmpxchg(&input_pool.init_bits, orig, init_bits) != orig);
+		new = min_t(unsigned int, POOL_BITS, orig + add);
+	} while (cmpxchg(&input_pool.init_bits, orig, new) != orig);
 
-	if (!crng_ready() && init_bits >= POOL_READY_BITS)
+	if (orig < POOL_READY_BITS && new >= POOL_READY_BITS)
 		crng_reseed();
-	else if (unlikely(crng_init == CRNG_EMPTY && init_bits >= POOL_EARLY_BITS)) {
+	else if (orig < POOL_EARLY_BITS && new >= POOL_EARLY_BITS) {
 		spin_lock_irqsave(&base_crng.lock, flags);
 		if (crng_init == CRNG_EMPTY) {
 			extract_entropy(base_crng.key, sizeof(base_crng.key));


