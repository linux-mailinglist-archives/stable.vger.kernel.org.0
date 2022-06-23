Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02EC558526
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235477AbiFWRyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235191AbiFWRv5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:51:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 674FEA18D;
        Thu, 23 Jun 2022 10:12:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9861F61D1E;
        Thu, 23 Jun 2022 17:12:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854BBC3411B;
        Thu, 23 Jun 2022 17:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004355;
        bh=4+zUTGtNcS5lJ5osrctbx8IJCZEIwR0zeawXRMFO8s0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zF5bsGnIcfK9wG4M+PISXfICsOgAsxRoP4ewgduS+MjxeV5EV6QHnTrQvDJ9Ax7FV
         fPBUM5+ab//FQ4JeSaCXHDhTOcRMQ+jYI0dqWCpsvmrVqd2BjEhM1Ipdtndimorvz1
         sNPbKtVDfHa9B2l4pavM1/T7XaHfO028cAZQrpuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Keerthy <j-keerthy@ti.com>, Stephen Boyd <swboyd@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 012/234] random: Use wait_event_freezable() in add_hwgenerator_randomness()
Date:   Thu, 23 Jun 2022 18:41:19 +0200
Message-Id: <20220623164343.406758077@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
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

From: Stephen Boyd <swboyd@chromium.org>

commit 59b569480dc8bb9dce57cdff133853a842dfd805 upstream.

Sebastian reports that after commit ff296293b353 ("random: Support freezable
kthreads in add_hwgenerator_randomness()") we can call might_sleep() when the
task state is TASK_INTERRUPTIBLE (state=1). This leads to the following warning.

 do not call blocking ops when !TASK_RUNNING; state=1 set at [<00000000349d1489>] prepare_to_wait_event+0x5a/0x180
 WARNING: CPU: 0 PID: 828 at kernel/sched/core.c:6741 __might_sleep+0x6f/0x80
 Modules linked in:

 CPU: 0 PID: 828 Comm: hwrng Not tainted 5.3.0-rc7-next-20190903+ #46
 RIP: 0010:__might_sleep+0x6f/0x80

 Call Trace:
  kthread_freezable_should_stop+0x1b/0x60
  add_hwgenerator_randomness+0xdd/0x130
  hwrng_fillfn+0xbf/0x120
  kthread+0x10c/0x140
  ret_from_fork+0x27/0x50

We shouldn't call kthread_freezable_should_stop() from deep within the
wait_event code because the task state is still set as
TASK_INTERRUPTIBLE instead of TASK_RUNNING and
kthread_freezable_should_stop() will try to call into the freezer with
the task in the wrong state. Use wait_event_freezable() instead so that
it calls schedule() in the right place and tries to enter the freezer
when the task state is TASK_RUNNING instead.

Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Keerthy <j-keerthy@ti.com>
Fixes: ff296293b353 ("random: Support freezable kthreads in add_hwgenerator_randomness()")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -327,6 +327,7 @@
 #include <linux/percpu.h>
 #include <linux/cryptohash.h>
 #include <linux/fips.h>
+#include <linux/freezer.h>
 #include <linux/ptrace.h>
 #include <linux/workqueue.h>
 #include <linux/irq.h>
@@ -2483,7 +2484,6 @@ void add_hwgenerator_randomness(const ch
 				size_t entropy)
 {
 	struct entropy_store *poolp = &input_pool;
-	bool frozen = false;
 
 	if (unlikely(crng_init == 0)) {
 		crng_fast_load(buffer, count);
@@ -2494,13 +2494,11 @@ void add_hwgenerator_randomness(const ch
 	 * We'll be woken up again once below random_write_wakeup_thresh,
 	 * or when the calling thread is about to terminate.
 	 */
-	wait_event_interruptible(random_write_wait,
-			kthread_freezable_should_stop(&frozen) ||
+	wait_event_freezable(random_write_wait,
+			kthread_should_stop() ||
 			ENTROPY_BITS(&input_pool) <= random_write_wakeup_bits);
-	if (!frozen) {
-		mix_pool_bytes(poolp, buffer, count);
-		credit_entropy_bits(poolp, entropy);
-	}
+	mix_pool_bytes(poolp, buffer, count);
+	credit_entropy_bits(poolp, entropy);
 }
 EXPORT_SYMBOL_GPL(add_hwgenerator_randomness);
 


