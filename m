Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B759E64E044
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 19:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiLOSLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 13:11:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiLOSLP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 13:11:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DA9442EF
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 10:11:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26BBA61EA5
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 18:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E92C433EF;
        Thu, 15 Dec 2022 18:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671127870;
        bh=rrzhKR2FFhMqbzJKotAzYjuGZ0s/GYt8tzIN8ch8lzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VzF5qjWL7U4Ij4cfcvnc25GGk6bx5OiLp8AzeYy4Yf2Pyyh0+BZh3AF7nepGBkoFm
         4qXjYvSISWPxFzV34eJnNqc3vgaNREKWjL1mQP/uUyXAdMBQADY2bUp0GbZi4ypOI1
         913pnQxSbALWiUlrarC+NakNs/Zq5GmPUSx5hqew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qian Cai <cai@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH 5.4 2/9] x86/smpboot:  Move rcu_cpu_starting() earlier
Date:   Thu, 15 Dec 2022 19:10:29 +0100
Message-Id: <20221215172905.559686010@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221215172905.468656378@linuxfoundation.org>
References: <20221215172905.468656378@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

commit 29368e09392123800e5e2bf0f3eda91f16972e52 upstream.

The call to rcu_cpu_starting() in mtrr_ap_init() is not early enough
in the CPU-hotplug onlining process, which results in lockdep splats
as follows:

=============================
WARNING: suspicious RCU usage
5.9.0+ #268 Not tainted
-----------------------------
kernel/kprobes.c:300 RCU-list traversed in non-reader section!!

other info that might help us debug this:

RCU used illegally from offline CPU!
rcu_scheduler_active = 1, debug_locks = 1
no locks held by swapper/1/0.

stack backtrace:
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.9.0+ #268
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1 04/01/2014
Call Trace:
 dump_stack+0x77/0x97
 __is_insn_slot_addr+0x15d/0x170
 kernel_text_address+0xba/0xe0
 ? get_stack_info+0x22/0xa0
 __kernel_text_address+0x9/0x30
 show_trace_log_lvl+0x17d/0x380
 ? dump_stack+0x77/0x97
 dump_stack+0x77/0x97
 __lock_acquire+0xdf7/0x1bf0
 lock_acquire+0x258/0x3d0
 ? vprintk_emit+0x6d/0x2c0
 _raw_spin_lock+0x27/0x40
 ? vprintk_emit+0x6d/0x2c0
 vprintk_emit+0x6d/0x2c0
 printk+0x4d/0x69
 start_secondary+0x1c/0x100
 secondary_startup_64_no_verify+0xb8/0xbb

This is avoided by moving the call to rcu_cpu_starting up near
the beginning of the start_secondary() function.  Note that the
raw_smp_processor_id() is required in order to avoid calling into lockdep
before RCU has declared the CPU to be watched for readers.

Link: https://lore.kernel.org/lkml/160223032121.7002.1269740091547117869.tip-bot2@tip-bot2/
Reported-by: Qian Cai <cai@redhat.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Joel Fernandes <joel@joelfernandes.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mtrr/mtrr.c |    2 --
 arch/x86/kernel/smpboot.c       |    1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/mtrr/mtrr.c
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.c
@@ -794,8 +794,6 @@ void mtrr_ap_init(void)
 	if (!use_intel() || mtrr_aps_delayed_init)
 		return;
 
-	rcu_cpu_starting(smp_processor_id());
-
 	/*
 	 * Ideally we should hold mtrr_mutex here to avoid mtrr entries
 	 * changed, but this routine will be called in cpu boot time,
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -224,6 +224,7 @@ static void notrace start_secondary(void
 #endif
 	load_current_idt();
 	cpu_init();
+	rcu_cpu_starting(raw_smp_processor_id());
 	x86_cpuinit.early_percpu_clock_init();
 	preempt_disable();
 	smp_callin();


