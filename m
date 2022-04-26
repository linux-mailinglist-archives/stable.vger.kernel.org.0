Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD7F50F7D9
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346792AbiDZJLu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346921AbiDZJJ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:09:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5520C17ABD7;
        Tue, 26 Apr 2022 01:49:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7F946149A;
        Tue, 26 Apr 2022 08:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3924C385A4;
        Tue, 26 Apr 2022 08:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962961;
        bh=8KrmE0KfLpZ6Zj6gWZMaFJNNGs1Kvhw+34J7TsZNZJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wPLr9MAhq3iJld8G1lfNyu8VsLaZKJJfJza+x2fsErd64ZtcsLiy6+UYlyVwLiBKx
         SzmqUpm62dkrmHkTvxU7CG1OStae3u0lqELEeUjxFwLXbon7Sp8V6i8Z8jj7tWsny/
         0xrPCHb4FNMUFDVd2lBcQcRdDcdVMoR8W0FVA1xQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 106/146] powerpc/time: Always set decrementer in timer_interrupt()
Date:   Tue, 26 Apr 2022 10:21:41 +0200
Message-Id: <20220426081753.037463942@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit d2b9be1f4af5cabed1ee5bb341f887f64b1c1669 ]

This is a partial revert of commit 0faf20a1ad16 ("powerpc/64s/interrupt:
Don't enable MSR[EE] in irq handlers unless perf is in use").

Prior to that commit, we always set the decrementer in
timer_interrupt(), to clear the timer interrupt. Otherwise we could end
up continuously taking timer interrupts.

When high res timers are enabled there is no problem seen with leaving
the decrementer untouched in timer_interrupt(), because it will be
programmed via hrtimer_interrupt() -> tick_program_event() ->
clockevents_program_event() -> decrementer_set_next_event().

However with CONFIG_HIGH_RES_TIMERS=n or booting with highres=off, we
see a stall/lockup, because tick_nohz_handler() does not cause a
reprogram of the decrementer, leading to endless timer interrupts.
Example trace:

  [    1.898617][    T7] Freeing initrd memory: 2624K^M
  [   22.680919][    C1] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:^M
  [   22.682281][    C1] rcu:     0-....: (25 ticks this GP) idle=073/0/0x1 softirq=10/16 fqs=1050 ^M
  [   22.682851][    C1]  (detected by 1, t=2102 jiffies, g=-1179, q=476)^M
  [   22.683649][    C1] Sending NMI from CPU 1 to CPUs 0:^M
  [   22.685252][    C0] NMI backtrace for cpu 0^M
  [   22.685649][    C0] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.16.0-rc2-00185-g0faf20a1ad16 #145^M
  [   22.686393][    C0] NIP:  c000000000016d64 LR: c000000000f6cca4 CTR: c00000000019c6e0^M
  [   22.686774][    C0] REGS: c000000002833590 TRAP: 0500   Not tainted  (5.16.0-rc2-00185-g0faf20a1ad16)^M
  [   22.687222][    C0] MSR:  8000000000009033 <SF,EE,ME,IR,DR,RI,LE>  CR: 24000222  XER: 00000000^M
  [   22.688297][    C0] CFAR: c00000000000c854 IRQMASK: 0 ^M
  ...
  [   22.692637][    C0] NIP [c000000000016d64] arch_local_irq_restore+0x174/0x250^M
  [   22.694443][    C0] LR [c000000000f6cca4] __do_softirq+0xe4/0x3dc^M
  [   22.695762][    C0] Call Trace:^M
  [   22.696050][    C0] [c000000002833830] [c000000000f6cc80] __do_softirq+0xc0/0x3dc (unreliable)^M
  [   22.697377][    C0] [c000000002833920] [c000000000151508] __irq_exit_rcu+0xd8/0x130^M
  [   22.698739][    C0] [c000000002833950] [c000000000151730] irq_exit+0x20/0x40^M
  [   22.699938][    C0] [c000000002833970] [c000000000027f40] timer_interrupt+0x270/0x460^M
  [   22.701119][    C0] [c0000000028339d0] [c0000000000099a8] decrementer_common_virt+0x208/0x210^M

Possibly this should be fixed in the lowres timing code, but that would
be a generic change and could take some time and may not backport
easily, so for now make the programming of the decrementer unconditional
again in timer_interrupt() to avoid the stall/lockup.

Fixes: 0faf20a1ad16 ("powerpc/64s/interrupt: Don't enable MSR[EE] in irq handlers unless perf is in use")
Reported-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Link: https://lore.kernel.org/r/20220420141657.771442-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/time.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 384f58a3f373..5f8933aec75c 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -610,23 +610,22 @@ DEFINE_INTERRUPT_HANDLER_ASYNC(timer_interrupt)
 		return;
 	}
 
-	/* Conditionally hard-enable interrupts. */
-	if (should_hard_irq_enable()) {
-		/*
-		 * Ensure a positive value is written to the decrementer, or
-		 * else some CPUs will continue to take decrementer exceptions.
-		 * When the PPC_WATCHDOG (decrementer based) is configured,
-		 * keep this at most 31 bits, which is about 4 seconds on most
-		 * systems, which gives the watchdog a chance of catching timer
-		 * interrupt hard lockups.
-		 */
-		if (IS_ENABLED(CONFIG_PPC_WATCHDOG))
-			set_dec(0x7fffffff);
-		else
-			set_dec(decrementer_max);
+	/*
+	 * Ensure a positive value is written to the decrementer, or
+	 * else some CPUs will continue to take decrementer exceptions.
+	 * When the PPC_WATCHDOG (decrementer based) is configured,
+	 * keep this at most 31 bits, which is about 4 seconds on most
+	 * systems, which gives the watchdog a chance of catching timer
+	 * interrupt hard lockups.
+	 */
+	if (IS_ENABLED(CONFIG_PPC_WATCHDOG))
+		set_dec(0x7fffffff);
+	else
+		set_dec(decrementer_max);
 
+	/* Conditionally hard-enable interrupts. */
+	if (should_hard_irq_enable())
 		do_hard_irq_enable();
-	}
 
 #if defined(CONFIG_PPC32) && defined(CONFIG_PPC_PMAC)
 	if (atomic_read(&ppc_n_lost_interrupts) != 0)
-- 
2.35.1



