Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A65CC635917
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236251AbiKWKHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236468AbiKWKGO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:06:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A779F112C67
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:56:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45F9A61B40
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087CBC433C1;
        Wed, 23 Nov 2022 09:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197399;
        bh=UPQ7gVctsHoQavNTrTATOQJKVBME4/aT954rMC+rZ8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RwvnbMcYA/EXRLUxJ4eiZb73B4/LhiSLsJafmZENKEOxGJoPwupIyUCqtknmsSFL7
         QRKIDDv+MJHD3x5yr8uViP4y4HpAU5NUqr8QytBHobXxTqcxxrEf17IghG2VnjYNcH
         MRLzjKASHz9cdISVNgNROAToeJk7KNjF/uzTrqMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+b8ded3e2e2c6adde4990@syzkaller.appspotmail.com,
        Marco Elver <elver@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 284/314] perf: Improve missing SIGTRAP checking
Date:   Wed, 23 Nov 2022 09:52:09 +0100
Message-Id: <20221123084638.400684318@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Marco Elver <elver@google.com>

[ Upstream commit bb88f9695460bec25aa30ba9072595025cf6c8af ]

To catch missing SIGTRAP we employ a WARN in __perf_event_overflow(),
which fires if pending_sigtrap was already set: returning to user space
without consuming pending_sigtrap, and then having the event fire again
would re-enter the kernel and trigger the WARN.

This, however, seemed to miss the case where some events not associated
with progress in the user space task can fire and the interrupt handler
runs before the IRQ work meant to consume pending_sigtrap (and generate
the SIGTRAP).

syzbot gifted us this stack trace:

 | WARNING: CPU: 0 PID: 3607 at kernel/events/core.c:9313 __perf_event_overflow
 | Modules linked in:
 | CPU: 0 PID: 3607 Comm: syz-executor100 Not tainted 6.1.0-rc2-syzkaller-00073-g88619e77b33d #0
 | Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/11/2022
 | RIP: 0010:__perf_event_overflow+0x498/0x540 kernel/events/core.c:9313
 | <...>
 | Call Trace:
 |  <TASK>
 |  perf_swevent_hrtimer+0x34f/0x3c0 kernel/events/core.c:10729
 |  __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
 |  __hrtimer_run_queues+0x1c6/0xfb0 kernel/time/hrtimer.c:1749
 |  hrtimer_interrupt+0x31c/0x790 kernel/time/hrtimer.c:1811
 |  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1096 [inline]
 |  __sysvec_apic_timer_interrupt+0x17c/0x640 arch/x86/kernel/apic/apic.c:1113
 |  sysvec_apic_timer_interrupt+0x40/0xc0 arch/x86/kernel/apic/apic.c:1107
 |  asm_sysvec_apic_timer_interrupt+0x16/0x20 arch/x86/include/asm/idtentry.h:649
 | <...>
 |  </TASK>

In this case, syzbot produced a program with event type
PERF_TYPE_SOFTWARE and config PERF_COUNT_SW_CPU_CLOCK. The hrtimer
manages to fire again before the IRQ work got a chance to run, all while
never having returned to user space.

Improve the WARN to check for real progress in user space: approximate
this by storing a 32-bit hash of the current IP into pending_sigtrap,
and if an event fires while pending_sigtrap still matches the previous
IP, we assume no progress (false negatives are possible given we could
return to user space and trigger again on the same IP).

Fixes: ca6c21327c6a ("perf: Fix missing SIGTRAPs")
Reported-by: syzbot+b8ded3e2e2c6adde4990@syzkaller.appspotmail.com
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20221031093513.3032814-1-elver@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 072ab26269c0..bec18d81b116 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9282,14 +9282,27 @@ static int __perf_event_overflow(struct perf_event *event,
 	}
 
 	if (event->attr.sigtrap) {
-		/*
-		 * Should not be able to return to user space without processing
-		 * pending_sigtrap (kernel events can overflow multiple times).
-		 */
-		WARN_ON_ONCE(event->pending_sigtrap && event->attr.exclude_kernel);
+		unsigned int pending_id = 1;
+
+		if (regs)
+			pending_id = hash32_ptr((void *)instruction_pointer(regs)) ?: 1;
 		if (!event->pending_sigtrap) {
-			event->pending_sigtrap = 1;
+			event->pending_sigtrap = pending_id;
 			local_inc(&event->ctx->nr_pending);
+		} else if (event->attr.exclude_kernel) {
+			/*
+			 * Should not be able to return to user space without
+			 * consuming pending_sigtrap; with exceptions:
+			 *
+			 *  1. Where !exclude_kernel, events can overflow again
+			 *     in the kernel without returning to user space.
+			 *
+			 *  2. Events that can overflow again before the IRQ-
+			 *     work without user space progress (e.g. hrtimer).
+			 *     To approximate progress (with false negatives),
+			 *     check 32-bit hash of the current IP.
+			 */
+			WARN_ON_ONCE(event->pending_sigtrap != pending_id);
 		}
 		event->pending_addr = data->addr;
 		irq_work_queue(&event->pending_irq);
-- 
2.35.1



