Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D91C3C47D8
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236449AbhGLGfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:35:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237666AbhGLGep (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:34:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AF1B60551;
        Mon, 12 Jul 2021 06:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071482;
        bh=Gjqxoy6zuCsX3PmidEoy9VJ+NjivXFTAkQdGcmPjcR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BcGCLfkpPQG+1G0ONxytN1oUk6ZWFQX7TXdMd93fu2ThLPC85SbzBahjXaym2NZR8
         nlVCCF2E8sdIZNpKgp8IXujoGfNGv76YDVGrlXpwD7BOzbFeKF9wr6cUnggifLkQ7C
         fCqBcxcpCGGCen07/7lvggsJjoUCAkQLVlssynqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 089/593] powerpc/stacktrace: Fix spurious "stale" traces in raise_backtrace_ipi()
Date:   Mon, 12 Jul 2021 08:04:09 +0200
Message-Id: <20210712060853.000563414@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 7c6986ade69e3c81bac831645bc72109cd798a80 upstream.

In raise_backtrace_ipi() we iterate through the cpumask of CPUs, sending
each an IPI asking them to do a backtrace, but we don't wait for the
backtrace to happen.

We then iterate through the CPU mask again, and if any CPU hasn't done
the backtrace and cleared itself from the mask, we print a trace on its
behalf, noting that the trace may be "stale".

This works well enough when a CPU is not responding, because in that
case it doesn't receive the IPI and the sending CPU is left to print the
trace. But when all CPUs are responding we are left with a race between
the sending and receiving CPUs, if the sending CPU wins the race then it
will erroneously print a trace.

This leads to spurious "stale" traces from the sending CPU, which can
then be interleaved messily with the receiving CPU, note the CPU
numbers, eg:

  [ 1658.929157][    C7] rcu: Stack dump where RCU GP kthread last ran:
  [ 1658.929223][    C7] Sending NMI from CPU 7 to CPUs 1:
  [ 1658.929303][    C1] NMI backtrace for cpu 1
  [ 1658.929303][    C7] CPU 1 didn't respond to backtrace IPI, inspecting paca.
  [ 1658.929362][    C1] CPU: 1 PID: 325 Comm: kworker/1:1H Tainted: G        W   E     5.13.0-rc2+ #46
  [ 1658.929405][    C7] irq_soft_mask: 0x01 in_mce: 0 in_nmi: 0 current: 325 (kworker/1:1H)
  [ 1658.929465][    C1] Workqueue: events_highpri test_work_fn [test_lockup]
  [ 1658.929549][    C7] Back trace of paca->saved_r1 (0xc0000000057fb400) (possibly stale):
  [ 1658.929592][    C1] NIP:  c00000000002cf50 LR: c008000000820178 CTR: c00000000002cfa0

To fix it, change the logic so that the sending CPU waits 5s for the
receiving CPU to print its trace. If the receiving CPU prints its trace
successfully then the sending CPU just continues, avoiding any spurious
"stale" trace.

This has the added benefit of allowing all CPUs to print their traces in
order and avoids any interleaving of their output.

Fixes: 5cc05910f26e ("powerpc/64s: Wire up arch_trigger_cpumask_backtrace()")
Cc: stable@vger.kernel.org # v4.18+
Reported-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210625140408.3351173-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/stacktrace.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

--- a/arch/powerpc/kernel/stacktrace.c
+++ b/arch/powerpc/kernel/stacktrace.c
@@ -230,17 +230,31 @@ static void handle_backtrace_ipi(struct
 
 static void raise_backtrace_ipi(cpumask_t *mask)
 {
+	struct paca_struct *p;
 	unsigned int cpu;
+	u64 delay_us;
 
 	for_each_cpu(cpu, mask) {
-		if (cpu == smp_processor_id())
+		if (cpu == smp_processor_id()) {
 			handle_backtrace_ipi(NULL);
-		else
-			smp_send_safe_nmi_ipi(cpu, handle_backtrace_ipi, 5 * USEC_PER_SEC);
-	}
+			continue;
+		}
 
-	for_each_cpu(cpu, mask) {
-		struct paca_struct *p = paca_ptrs[cpu];
+		delay_us = 5 * USEC_PER_SEC;
+
+		if (smp_send_safe_nmi_ipi(cpu, handle_backtrace_ipi, delay_us)) {
+			// Now wait up to 5s for the other CPU to do its backtrace
+			while (cpumask_test_cpu(cpu, mask) && delay_us) {
+				udelay(1);
+				delay_us--;
+			}
+
+			// Other CPU cleared itself from the mask
+			if (delay_us)
+				continue;
+		}
+
+		p = paca_ptrs[cpu];
 
 		cpumask_clear_cpu(cpu, mask);
 


