Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 030CD535C66
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 11:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242711AbiE0JDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 05:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350224AbiE0I6r (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 04:58:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316201238B5;
        Fri, 27 May 2022 01:55:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E387FB823DD;
        Fri, 27 May 2022 08:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4C6C385A9;
        Fri, 27 May 2022 08:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641707;
        bh=nyNsl1FhrSkC5K3QNeXt8djsHyg/84AZ3Q0j/O2PnJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TI3mt4fLsuENM51eDHjohTwaCgus6Ho/gGt75AwOeSporjjCrby/nRlhIab8aLsIX
         IZb7PqOZLTq0S8HzzIbGvBGK8jrH9omXgzpAV3A8XJZPc7/GMqViCHdzAjL0IYk0xa
         5x/M/qyF4tyFWrJ6bNFoO83F6vK8+5r1cjtKwRQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.17 022/111] random: fix locking for crng_init in crng_reseed()
Date:   Fri, 27 May 2022 10:48:54 +0200
Message-Id: <20220527084822.577367876@linuxfoundation.org>
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

From: Dominik Brodowski <linux@dominikbrodowski.net>

commit 7191c628fe07b70d3f37de736d173d1b115396ed upstream.

crng_init is protected by primary_crng->lock. Therefore, we need
to hold this lock when increasing crng_init to 2. As we shouldn't
hold this lock for too long, only hold it for those parts which
require protection.

Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -502,6 +502,7 @@ static void crng_reseed(void)
 	int entropy_count;
 	unsigned long next_gen;
 	u8 key[CHACHA_KEY_SIZE];
+	bool finalize_init = false;
 
 	/*
 	 * First we make sure we have POOL_MIN_BITS of entropy in the pool,
@@ -529,12 +530,14 @@ static void crng_reseed(void)
 		++next_gen;
 	WRITE_ONCE(base_crng.generation, next_gen);
 	WRITE_ONCE(base_crng.birth, jiffies);
-	spin_unlock_irqrestore(&base_crng.lock, flags);
-	memzero_explicit(key, sizeof(key));
-
 	if (crng_init < 2) {
 		invalidate_batched_entropy();
 		crng_init = 2;
+		finalize_init = true;
+	}
+	spin_unlock_irqrestore(&base_crng.lock, flags);
+	memzero_explicit(key, sizeof(key));
+	if (finalize_init) {
 		process_random_ready_list();
 		wake_up_interruptible(&crng_init_wait);
 		kill_fasync(&fasync, SIGIO, POLL_IN);


