Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7416214BF
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235016AbiKHOEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235020AbiKHOEn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:04:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE919686B6
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:04:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64991B816DD
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70A4C433C1;
        Tue,  8 Nov 2022 14:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916279;
        bh=rs33bjNvafXEJMUhblviiX/pbkIb1ODk6GO9JlPNCJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+pTrL8YJLArlvAf88n3K44BW1kWwvCnh0xMBcm6zQ42kGD3QoclQhPTAGHzZL7eY
         r5SKwTaefZlvCstF5cF3q3HE2GiVbgoS9ybvuNjmlC9uYS0Bc+jm6ghoKGGmRhFCiV
         S3ClahlwMvZv4FMLT4J0LRwarrOfohSKjhXX2Fuc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.15 116/144] arm64: entry: avoid kprobe recursion
Date:   Tue,  8 Nov 2022 14:39:53 +0100
Message-Id: <20221108133350.199794260@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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

From: Mark Rutland <mark.rutland@arm.com>

commit 024f4b2e1f874934943eb2d3d288ebc52c79f55c upstream.

The cortex_a76_erratum_1463225_debug_handler() function is called when
handling debug exceptions (and synchronous exceptions from BRK
instructions), and so is called when a probed function executes. If the
compiler does not inline cortex_a76_erratum_1463225_debug_handler(), it
can be probed.

If cortex_a76_erratum_1463225_debug_handler() is probed, any debug
exception or software breakpoint exception will result in recursive
exceptions leading to a stack overflow. This can be triggered with the
ftrace multiple_probes selftest, and as per the example splat below.

This is a regression caused by commit:

  6459b8469753e9fe ("arm64: entry: consolidate Cortex-A76 erratum 1463225 workaround")

... which removed the NOKPROBE_SYMBOL() annotation associated with the
function.

My intent was that cortex_a76_erratum_1463225_debug_handler() would be
inlined into its caller, el1_dbg(), which is marked noinstr and cannot
be probed. Mark cortex_a76_erratum_1463225_debug_handler() as
__always_inline to ensure this.

Example splat prior to this patch (with recursive entries elided):

| # echo p cortex_a76_erratum_1463225_debug_handler > /sys/kernel/debug/tracing/kprobe_events
| # echo p do_el0_svc >> /sys/kernel/debug/tracing/kprobe_events
| # echo 1 > /sys/kernel/debug/tracing/events/kprobes/enable
| Insufficient stack space to handle exception!
| ESR: 0x0000000096000047 -- DABT (current EL)
| FAR: 0xffff800009cefff0
| Task stack:     [0xffff800009cf0000..0xffff800009cf4000]
| IRQ stack:      [0xffff800008000000..0xffff800008004000]
| Overflow stack: [0xffff00007fbc00f0..0xffff00007fbc10f0]
| CPU: 0 PID: 145 Comm: sh Not tainted 6.0.0 #2
| Hardware name: linux,dummy-virt (DT)
| pstate: 604003c5 (nZCv DAIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
| pc : arm64_enter_el1_dbg+0x4/0x20
| lr : el1_dbg+0x24/0x5c
| sp : ffff800009cf0000
| x29: ffff800009cf0000 x28: ffff000002c74740 x27: 0000000000000000
| x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
| x23: 00000000604003c5 x22: ffff80000801745c x21: 0000aaaac95ac068
| x20: 00000000f2000004 x19: ffff800009cf0040 x18: 0000000000000000
| x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
| x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
| x11: 0000000000000010 x10: ffff800008c87190 x9 : ffff800008ca00d0
| x8 : 000000000000003c x7 : 0000000000000000 x6 : 0000000000000000
| x5 : 0000000000000000 x4 : 0000000000000000 x3 : 00000000000043a4
| x2 : 00000000f2000004 x1 : 00000000f2000004 x0 : ffff800009cf0040
| Kernel panic - not syncing: kernel stack overflow
| CPU: 0 PID: 145 Comm: sh Not tainted 6.0.0 #2
| Hardware name: linux,dummy-virt (DT)
| Call trace:
|  dump_backtrace+0xe4/0x104
|  show_stack+0x18/0x4c
|  dump_stack_lvl+0x64/0x7c
|  dump_stack+0x18/0x38
|  panic+0x14c/0x338
|  test_taint+0x0/0x2c
|  panic_bad_stack+0x104/0x118
|  handle_bad_stack+0x34/0x48
|  __bad_stack+0x78/0x7c
|  arm64_enter_el1_dbg+0x4/0x20
|  el1h_64_sync_handler+0x40/0x98
|  el1h_64_sync+0x64/0x68
|  cortex_a76_erratum_1463225_debug_handler+0x0/0x34
...
|  el1h_64_sync_handler+0x40/0x98
|  el1h_64_sync+0x64/0x68
|  cortex_a76_erratum_1463225_debug_handler+0x0/0x34
...
|  el1h_64_sync_handler+0x40/0x98
|  el1h_64_sync+0x64/0x68
|  cortex_a76_erratum_1463225_debug_handler+0x0/0x34
|  el1h_64_sync_handler+0x40/0x98
|  el1h_64_sync+0x64/0x68
|  do_el0_svc+0x0/0x28
|  el0t_64_sync_handler+0x84/0xf0
|  el0t_64_sync+0x18c/0x190
| Kernel Offset: disabled
| CPU features: 0x0080,00005021,19001080
| Memory Limit: none
| ---[ end Kernel panic - not syncing: kernel stack overflow ]---

With this patch, cortex_a76_erratum_1463225_debug_handler() is inlined
into el1_dbg(), and el1_dbg() cannot be probed:

| # echo p cortex_a76_erratum_1463225_debug_handler > /sys/kernel/debug/tracing/kprobe_events
| sh: write error: No such file or directory
| # grep -w cortex_a76_erratum_1463225_debug_handler /proc/kallsyms | wc -l
| 0
| # echo p el1_dbg > /sys/kernel/debug/tracing/kprobe_events
| sh: write error: Invalid argument
| # grep -w el1_dbg /proc/kallsyms | wc -l
| 1

Fixes: 6459b8469753 ("arm64: entry: consolidate Cortex-A76 erratum 1463225 workaround")
Cc: <stable@vger.kernel.org> # 5.12.x
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20221017090157.2881408-1-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/entry-common.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -320,7 +320,8 @@ static void cortex_a76_erratum_1463225_s
 	__this_cpu_write(__in_cortex_a76_erratum_1463225_wa, 0);
 }
 
-static bool cortex_a76_erratum_1463225_debug_handler(struct pt_regs *regs)
+static __always_inline bool
+cortex_a76_erratum_1463225_debug_handler(struct pt_regs *regs)
 {
 	if (!__this_cpu_read(__in_cortex_a76_erratum_1463225_wa))
 		return false;


