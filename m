Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1962B32903D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242770AbhCAUDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:03:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:58992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242526AbhCATxy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:53:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B91FB652A2;
        Mon,  1 Mar 2021 17:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621238;
        bh=ivzJRwFJJHmAtPjRNDulwNAPKSwQvZbiNSO9ckbIFxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fntg0mHSI52eYuO1Lv1lRH9VF0mgaA/zb8+uGigc+8NDSiFoBjMb5cF/VLW3oZ112
         QP9BOhe0/Pqe2FNAUpl64d6kU7A4LVmPH3ew45etpnrJ2QfTaBni1wdpbGoWB14G1P
         XEC6DfV0c5NKXEwuthRFJi42Z8meXQgckQ5rMvGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 444/775] powerpc/kuap: Restore AMR after replaying soft interrupts
Date:   Mon,  1 Mar 2021 17:10:12 +0100
Message-Id: <20210301161223.495816324@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit 60a707d0c99aff4eadb7fd334c5fd21df386723e ]

Since de78a9c42a79 ("powerpc: Add a framework for Kernel Userspace
Access Protection"), user access helpers call user_{read|write}_access_{begin|end}
when user space access is allowed.

Commit 890274c2dc4c ("powerpc/64s: Implement KUAP for Radix MMU") made
the mentioned helpers program a AMR special register to allow such
access for a short period of time, most of the time AMR is expected to
block user memory access by the kernel.

Since the code accesses the user space memory, unsafe_get_user() calls
might_fault() which calls arch_local_irq_restore() if either
CONFIG_PROVE_LOCKING or CONFIG_DEBUG_ATOMIC_SLEEP is enabled.
arch_local_irq_restore() then attempts to replay pending soft
interrupts as KUAP regions have hardware interrupts enabled.

If a pending interrupt happens to do user access (performance
interrupts do that), it enables access for a short period of time so
after returning from the replay, the user access state remains blocked
and if a user page fault happens - "Bug: Read fault blocked by AMR!"
appears and SIGSEGV is sent.

An example trace:
  Bug: Read fault blocked by AMR!
  WARNING: CPU: 0 PID: 1603 at /home/aik/p/kernel/arch/powerpc/include/asm/book3s/64/kup-radix.h:145
  CPU: 0 PID: 1603 Comm: amr Not tainted 5.10.0-rc6_v5.10-rc6_a+fstn1 #24
  NIP:  c00000000009ece8 LR: c00000000009ece4 CTR: 0000000000000000
  REGS: c00000000dc63560 TRAP: 0700   Not tainted  (5.10.0-rc6_v5.10-rc6_a+fstn1)
  MSR:  8000000000021033 <SF,ME,IR,DR,RI,LE>  CR: 28002888  XER: 20040000
  CFAR: c0000000001fa928 IRQMASK: 1
  GPR00: c00000000009ece4 c00000000dc637f0 c000000002397600 000000000000001f
  GPR04: c0000000020eb318 0000000000000000 c00000000dc63494 0000000000000027
  GPR08: c00000007fe4de68 c00000000dfe9180 0000000000000000 0000000000000001
  GPR12: 0000000000002000 c0000000030a0000 0000000000000000 0000000000000000
  GPR16: 0000000000000000 0000000000000000 0000000000000000 bfffffffffffffff
  GPR20: 0000000000000000 c0000000134a4020 c0000000019c2218 0000000000000fe0
  GPR24: 0000000000000000 0000000000000000 c00000000d106200 0000000040000000
  GPR28: 0000000000000000 0000000000000300 c00000000dc63910 c000000001946730
  NIP __do_page_fault+0xb38/0xde0
  LR  __do_page_fault+0xb34/0xde0
  Call Trace:
    __do_page_fault+0xb34/0xde0 (unreliable)
    handle_page_fault+0x10/0x2c
  --- interrupt: 300 at strncpy_from_user+0x290/0x440
      LR = strncpy_from_user+0x284/0x440
    strncpy_from_user+0x2f0/0x440 (unreliable)
    getname_flags+0x88/0x2c0
    do_sys_openat2+0x2d4/0x5f0
    do_sys_open+0xcc/0x140
    system_call_exception+0x160/0x240
    system_call_common+0xf0/0x27c

To fix it save/restore the AMR when replaying interrupts, and also
add a check if AMR was not blocked prior to replaying interrupts.

Originally found by syzkaller.

Fixes: 890274c2dc4c ("powerpc/64s: Implement KUAP for Radix MMU")
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
[mpe: Use normal commit citation format and add full oops log to
      change log, move kuap_check_amr() into the restore routine to
      avoid warnings about unreconciled IRQ state]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210202091541.36499-1-aik@ozlabs.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/irq.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index cc7a6271b6b4e..e8a548447dd68 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -269,6 +269,31 @@ again:
 	}
 }
 
+#if defined(CONFIG_PPC_BOOK3S_64) && defined(CONFIG_PPC_KUAP)
+static inline void replay_soft_interrupts_irqrestore(void)
+{
+	unsigned long kuap_state = get_kuap();
+
+	/*
+	 * Check if anything calls local_irq_enable/restore() when KUAP is
+	 * disabled (user access enabled). We handle that case here by saving
+	 * and re-locking AMR but we shouldn't get here in the first place,
+	 * hence the warning.
+	 */
+	kuap_check_amr();
+
+	if (kuap_state != AMR_KUAP_BLOCKED)
+		set_kuap(AMR_KUAP_BLOCKED);
+
+	replay_soft_interrupts();
+
+	if (kuap_state != AMR_KUAP_BLOCKED)
+		set_kuap(kuap_state);
+}
+#else
+#define replay_soft_interrupts_irqrestore() replay_soft_interrupts()
+#endif
+
 notrace void arch_local_irq_restore(unsigned long mask)
 {
 	unsigned char irq_happened;
@@ -332,7 +357,7 @@ notrace void arch_local_irq_restore(unsigned long mask)
 	irq_soft_mask_set(IRQS_ALL_DISABLED);
 	trace_hardirqs_off();
 
-	replay_soft_interrupts();
+	replay_soft_interrupts_irqrestore();
 	local_paca->irq_happened = 0;
 
 	trace_hardirqs_on();
-- 
2.27.0



