Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F244F55DAB7
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbiF0LXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234601AbiF0LXc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:23:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7F2656A;
        Mon, 27 Jun 2022 04:23:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 563BC61457;
        Mon, 27 Jun 2022 11:23:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59745C3411D;
        Mon, 27 Jun 2022 11:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329006;
        bh=1/lCkrF4vafEyVqiBKyPl5LKPvi2uvhMhbw8/hNNjLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+G7B87EYzSsEgXP1FJxfmMRkdWHWxDsMmDC7LMjs6QxU1+zmyM6CXk3TSGIa+qFd
         w7LZPp/esr+CfA/xVgxIobvqSz66Y250Prjf302YO+C4QTUKHgBLEwmrS0nn+mbhcG
         tDucGzzwrftlyWBi+Bqorsvd3yrkjQPHuMXqWcu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 002/102] random: schedule mix_interrupt_randomness() less often
Date:   Mon, 27 Jun 2022 13:20:13 +0200
Message-Id: <20220627111933.531539217@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
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
@@ -1001,7 +1001,7 @@ void add_interrupt_randomness(int irq)
 	if (new_count & MIX_INFLIGHT)
 		return;
 
-	if (new_count < 64 && !time_is_before_jiffies(fast_pool->last + HZ))
+	if (new_count < 1024 && !time_is_before_jiffies(fast_pool->last + HZ))
 		return;
 
 	if (unlikely(!fast_pool->mix.func))


