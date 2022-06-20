Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0562F551CE1
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346930AbiFTNkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347400AbiFTNi2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:38:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433002873D;
        Mon, 20 Jun 2022 06:14:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CF8860A52;
        Mon, 20 Jun 2022 13:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C5BC3411B;
        Mon, 20 Jun 2022 13:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730856;
        bh=IRIB/nfddzpYszgOCi6TNfrnOf4M5Ta9hww7v3gomiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zE2GHv73BP0MqJcipfDrggimtGr5B2g4tXSu6yr7os35OwB4Lsj7Nn5DCwuhSWJyY
         Ls7oILxI8sxbKo6lAkyNlxAWTQss5dyhM11ceCoAdRNpWePUgKP4vU2BYz8Rs5aiXk
         TRc7l3Qk816vMLWt6mn2W4eEE+w0mTkwLR0NYmQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 078/240] random: absorb fast pool into input pool after fast load
Date:   Mon, 20 Jun 2022 14:49:39 +0200
Message-Id: <20220620124741.016486257@linuxfoundation.org>
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

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit c30c575db4858f0bbe5e315ff2e529c782f33a1f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -850,6 +850,10 @@ void add_interrupt_randomness(int irq)
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


