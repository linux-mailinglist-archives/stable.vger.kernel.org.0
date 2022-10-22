Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B431608A04
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234751AbiJVIqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235177AbiJVIot (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:44:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696A12CB8D0;
        Sat, 22 Oct 2022 01:08:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E85160B9C;
        Sat, 22 Oct 2022 07:58:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2193CC433D6;
        Sat, 22 Oct 2022 07:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425533;
        bh=XyPVQJbFTLvipGXK1VZ5NAIpvAx/eXTeDvTak5V8T+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PdEzsNcLljOQGtWkv+98ElY2+y8Oqai9rmVIPXlXAjG3XxbZQA8Zcuzpj9yRArh9l
         o1lK+QuNnUr3ReH4ksGGFD+OZ7SHDVKxxvKZPggKsVw4Xvs9KvU8guXxe2RyTVMHfG
         bH7KRePhQjhyFsXGNpmpPqNwNQxdgBGHrwzWCrsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Sultan Alsawaf <sultan@kerneltoast.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 533/717] random: schedule jitter credit for next jiffy, not in two jiffies
Date:   Sat, 22 Oct 2022 09:26:52 +0200
Message-Id: <20221022072521.900794646@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 8dfb28d5ae3f..5defbc479a5c 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1178,7 +1178,7 @@ static void __cold entropy_timer(struct timer_list *timer)
  */
 static void __cold try_to_generate_entropy(void)
 {
-	enum { NUM_TRIAL_SAMPLES = 8192, MAX_SAMPLES_PER_BIT = HZ / 30 };
+	enum { NUM_TRIAL_SAMPLES = 8192, MAX_SAMPLES_PER_BIT = HZ / 15 };
 	struct entropy_timer_state stack;
 	unsigned int i, num_different = 0;
 	unsigned long last = random_get_entropy();
@@ -1197,7 +1197,7 @@ static void __cold try_to_generate_entropy(void)
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



