Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD15561C2D
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 15:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235970AbiF3N5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235973AbiF3N4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:56:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6613F13B44A;
        Thu, 30 Jun 2022 06:50:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9912B82AEF;
        Thu, 30 Jun 2022 13:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26AC9C34115;
        Thu, 30 Jun 2022 13:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597050;
        bh=h1N85u9a3APp1yw2woC9p/8mzkK2TLZrhyjIps8M9WU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2aUKgXUZIvKoSK3E9Uwo8xtAfobOIz7Bg4aftZZmf54QCtzEs6dKH4q1Zh6WCG2vn
         NLMgE0dTPvpyoceMrgU20YNwkfjegIZkFb2ie6MVKlYqh9qDlFiyvTTahoSI9+ihUx
         aZwK0X65ZB498eenuRbXKqwV0WkXgOdxaJH16QX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 02/49] random: schedule mix_interrupt_randomness() less often
Date:   Thu, 30 Jun 2022 15:46:15 +0200
Message-Id: <20220630133233.982703219@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133233.910803744@linuxfoundation.org>
References: <20220630133233.910803744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 534d2eaf1970274150596fdd2bf552721e65d6b2 upstream.

It used to be that mix_interrupt_randomness() would credit 1 bit each
time it ran, and so add_interrupt_randomness() would schedule mix() to
run every 64 interrupts, a fairly arbitrary number, but nonetheless
considered to be a decent enough conservative estimate.

Since e3e33fc2ea7f ("random: do not use input pool from hard IRQs"),
mix() is now able to credit multiple bits, depending on the number of
calls to add(). This was done for reasons separate from this commit, but
it has the nice side effect of enabling this patch to schedule mix()
less often.

Currently the rules are:
a) Credit 1 bit for every 64 calls to add().
b) Schedule mix() once a second that add() is called.
c) Schedule mix() once every 64 calls to add().

Rules (a) and (c) no longer need to be coupled. It's still important to
have _some_ value in (c), so that we don't "over-saturate" the fast
pool, but the once per second we get from rule (b) is a plenty enough
baseline. So, by increasing the 64 in rule (c) to something larger, we
avoid calling queue_work_on() as frequently during irq storms.

This commit changes that 64 in rule (c) to be 1024, which means we
schedule mix() 16 times less often. And it does *not* need to change the
64 in rule (a).

Fixes: 58340f8e952b ("random: defer fast pool mixing to worker")
Cc: stable@vger.kernel.org
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -996,7 +996,7 @@ void add_interrupt_randomness(int irq)
 	if (new_count & MIX_INFLIGHT)
 		return;
 
-	if (new_count < 64 && !time_is_before_jiffies(fast_pool->last + HZ))
+	if (new_count < 1024 && !time_is_before_jiffies(fast_pool->last + HZ))
 		return;
 
 	if (unlikely(!fast_pool->mix.func))


