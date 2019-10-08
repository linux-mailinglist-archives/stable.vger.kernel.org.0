Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C00B7CF859
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 13:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730793AbfJHLdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 07:33:39 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:47857 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730710AbfJHLdj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 07:33:39 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iHnkA-0008Fn-ND; Tue, 08 Oct 2019 13:33:30 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 4D6C01C0895;
        Tue,  8 Oct 2019 13:33:30 +0200 (CEST)
Date:   Tue, 08 Oct 2019 11:33:30 -0000
From:   "tip-bot2 for Janakarajan Natarajan" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/asm: Fix MWAITX C-state hint value
Cc:     Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        <stable@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20191007190011.4859-1-Janakarajan.Natarajan@amd.com>
References: <20191007190011.4859-1-Janakarajan.Natarajan@amd.com>
MIME-Version: 1.0
Message-ID: <157053441025.9978.1547875174433233773.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     454de1e7d970d6bc567686052329e4814842867c
Gitweb:        https://git.kernel.org/tip/454de1e7d970d6bc567686052329e4814842867c
Author:        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
AuthorDate:    Mon, 07 Oct 2019 19:00:22 
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Tue, 08 Oct 2019 13:25:24 +02:00

x86/asm: Fix MWAITX C-state hint value

As per "AMD64 Architecture Programmer's Manual Volume 3: General-Purpose
and System Instructions", MWAITX EAX[7:4]+1 specifies the optional hint
of the optimized C-state. For C0 state, EAX[7:4] should be set to 0xf.

Currently, a value of 0xf is set for EAX[3:0] instead of EAX[7:4]. Fix
this by changing MWAITX_DISABLE_CSTATES from 0xf to 0xf0.

This hasn't had any implications so far because setting reserved bits in
EAX is simply ignored by the CPU.

 [ bp: Fixup comment in delay_mwaitx() and massage. ]

Signed-off-by: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "x86@kernel.org" <x86@kernel.org>
Cc: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20191007190011.4859-1-Janakarajan.Natarajan@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/mwait.h | 2 +-
 arch/x86/lib/delay.c         | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
index e28f8b7..9d5252c 100644
--- a/arch/x86/include/asm/mwait.h
+++ b/arch/x86/include/asm/mwait.h
@@ -21,7 +21,7 @@
 #define MWAIT_ECX_INTERRUPT_BREAK	0x1
 #define MWAITX_ECX_TIMER_ENABLE		BIT(1)
 #define MWAITX_MAX_LOOPS		((u32)-1)
-#define MWAITX_DISABLE_CSTATES		0xf
+#define MWAITX_DISABLE_CSTATES		0xf0
 
 static inline void __monitor(const void *eax, unsigned long ecx,
 			     unsigned long edx)
diff --git a/arch/x86/lib/delay.c b/arch/x86/lib/delay.c
index b7375dc..c126571 100644
--- a/arch/x86/lib/delay.c
+++ b/arch/x86/lib/delay.c
@@ -113,8 +113,8 @@ static void delay_mwaitx(unsigned long __loops)
 		__monitorx(raw_cpu_ptr(&cpu_tss_rw), 0, 0);
 
 		/*
-		 * AMD, like Intel, supports the EAX hint and EAX=0xf
-		 * means, do not enter any deep C-state and we use it
+		 * AMD, like Intel's MWAIT version, supports the EAX hint and
+		 * EAX=0xf0 means, do not enter any deep C-state and we use it
 		 * here in delay() to minimize wakeup latency.
 		 */
 		__mwaitx(MWAITX_DISABLE_CSTATES, delay, MWAITX_ECX_TIMER_ENABLE);
