Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A264E9357
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240662AbiC1LVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240765AbiC1LVc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:21:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3F656433;
        Mon, 28 Mar 2022 04:19:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5F6F6115A;
        Mon, 28 Mar 2022 11:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B37C36AE5;
        Mon, 28 Mar 2022 11:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466342;
        bh=cU6uh7a1/OiEj7lrsJfIHzA7eCc476ab7omtjpwN4XE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h31RnMjctE+SatqtSGsTB6aMcp4uawN2PCIN6akzDnXHsiCsLyuuielu0X5vVbbrt
         uCplnbO2aIp1s11taSLDCTQyV1T4MXDFKnrf5d+S3FNlzF6vHurgX4EyzAF0pyl4UQ
         hjZcsRJ/YJjJwph2vAvANDnF/Xr6QGQIh95QbM8OjNjZKvU4IrM5G8FWh0uNBuMnNN
         rsXmro8J+SE8y/jUwIOtO9ZJ06SBaLSC88sphDlNxmIZHxbB5wIgmnQg2rxqf56kTk
         Xc4ZvOQh617dQacZt/0DiG+G+IFloEw/aKmuDFqEFrHRQPTKcticS6x9WMljeFJ9fY
         udMnc9U+9cZkg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.17 18/43] random: absorb fast pool into input pool after fast load
Date:   Mon, 28 Mar 2022 07:18:02 -0400
Message-Id: <20220328111828.1554086-18-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328111828.1554086-1-sashal@kernel.org>
References: <20220328111828.1554086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit c30c575db4858f0bbe5e315ff2e529c782f33a1f ]

During crng_init == 0, we never credit entropy in add_interrupt_
randomness(), but instead dump it directly into the primary_crng. That's
fine, except for the fact that we then wind up throwing away that
entropy later when we switch to extracting from the input pool and
xoring into (and later in this series overwriting) the primary_crng key.
The two other early init sites -- add_hwgenerator_randomness()'s use
crng_fast_load() and add_device_ randomness()'s use of crng_slow_load()
-- always additionally give their inputs to the input pool. But not
add_interrupt_randomness().

This commit fixes that shortcoming by calling mix_pool_bytes() after
crng_fast_load() in add_interrupt_randomness(). That's partially
verboten on PREEMPT_RT, where it implies taking spinlock_t from an IRQ
handler. But this also only happens during early boot and then never
again after that. Plus it's a trylock so it has the same considerations
as calling crng_fast_load(), which we're already using.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Suggested-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/random.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 34ee34b30993..2f21c5473d86 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1075,6 +1075,10 @@ void add_interrupt_randomness(int irq)
 		    crng_fast_load((u8 *)fast_pool->pool, sizeof(fast_pool->pool)) > 0) {
 			fast_pool->count = 0;
 			fast_pool->last = now;
+			if (spin_trylock(&input_pool.lock)) {
+				_mix_pool_bytes(&fast_pool->pool, sizeof(fast_pool->pool));
+				spin_unlock(&input_pool.lock);
+			}
 		}
 		return;
 	}
-- 
2.34.1

