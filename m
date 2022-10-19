Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEEA603F03
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233549AbiJSJ01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233791AbiJSJY6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:24:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9925E09FA;
        Wed, 19 Oct 2022 02:11:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FB216186A;
        Wed, 19 Oct 2022 09:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B708DC433D6;
        Wed, 19 Oct 2022 09:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170428;
        bh=3Gfi9agU9cU+uff4O12IY+gLmC0ZvLn3iv815Gceu7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yk1vgJG3QqXONevtsnu0Q2QKCmVG0dHDb4rrKGcUU6wsR3/G5Rb8uw07rFODAVVuf
         Q6J2ISnjT4T1VSN5Qd97NJEPTNpuR5MCLeSAYISdpW+7EHJ63bHEJVJ3Sz2B3i+uHN
         NFp50uSFb6sY3+N/Tdgx2d58D/YO94Q1uupmSse0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Sultan Alsawaf <sultan@kerneltoast.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 652/862] random: schedule jitter credit for next jiffy, not in two jiffies
Date:   Wed, 19 Oct 2022 10:32:19 +0200
Message-Id: <20221019083318.739414078@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

[ Upstream commit 122733471384be8c23f019fbbd46bdf7be561dcd ]

Counterintuitively, mod_timer(..., jiffies + 1) will cause the timer to
fire not in the next jiffy, but in two jiffies. The way to cause
the timer to fire in the next jiffy is with mod_timer(..., jiffies).
Doing so then lets us bump the upper bound back up again.

Fixes: 50ee7529ec45 ("random: try to actively add entropy rather than passively wait for it")
Fixes: 829d680e82a9 ("random: cap jitter samples per bit to factor of HZ")
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sultan Alsawaf <sultan@kerneltoast.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/random.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 060f999dcffb..46d6100fa3a7 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1195,7 +1195,7 @@ static void __cold entropy_timer(struct timer_list *timer)
  */
 static void __cold try_to_generate_entropy(void)
 {
-	enum { NUM_TRIAL_SAMPLES = 8192, MAX_SAMPLES_PER_BIT = HZ / 30 };
+	enum { NUM_TRIAL_SAMPLES = 8192, MAX_SAMPLES_PER_BIT = HZ / 15 };
 	struct entropy_timer_state stack;
 	unsigned int i, num_different = 0;
 	unsigned long last = random_get_entropy();
@@ -1214,7 +1214,7 @@ static void __cold try_to_generate_entropy(void)
 	timer_setup_on_stack(&stack.timer, entropy_timer, 0);
 	while (!crng_ready() && !signal_pending(current)) {
 		if (!timer_pending(&stack.timer))
-			mod_timer(&stack.timer, jiffies + 1);
+			mod_timer(&stack.timer, jiffies);
 		mix_pool_bytes(&stack.entropy, sizeof(stack.entropy));
 		schedule();
 		stack.entropy = random_get_entropy();
-- 
2.35.1



