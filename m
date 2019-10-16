Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBC4D9F49
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394929AbfJPVx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:53:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394921AbfJPVx4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:53:56 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23BDC21928;
        Wed, 16 Oct 2019 21:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262836;
        bh=IWbkgjFM4VUyv7V+rPvBS5sdHICp3mRmFkMFPqIWsbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kdmdzEcWCJ4XMQNLDvtMiwd/jFOXeE20VYiP9NkZFvTaOq+qqY1mjprjcPCOayVSb
         SX9zm+5JFVexraZrEUx4ub6DJ1oEew9F255yhfjJzYyxFzoGFOnulZnCdww7hJbh7h
         sQSIXXleG711awHkst7xrWPtulgrlrml4J0KT0TU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.4 78/79] x86/asm: Fix MWAITX C-state hint value
Date:   Wed, 16 Oct 2019 14:50:53 -0700
Message-Id: <20191016214834.350008615@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
References: <20191016214729.758892904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>

commit 454de1e7d970d6bc567686052329e4814842867c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/mwait.h |    2 +-
 arch/x86/lib/delay.c         |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/mwait.h
+++ b/arch/x86/include/asm/mwait.h
@@ -19,7 +19,7 @@
 #define MWAIT_ECX_INTERRUPT_BREAK	0x1
 #define MWAITX_ECX_TIMER_ENABLE		BIT(1)
 #define MWAITX_MAX_LOOPS		((u32)-1)
-#define MWAITX_DISABLE_CSTATES		0xf
+#define MWAITX_DISABLE_CSTATES		0xf0
 
 static inline void __monitor(const void *eax, unsigned long ecx,
 			     unsigned long edx)
--- a/arch/x86/lib/delay.c
+++ b/arch/x86/lib/delay.c
@@ -112,8 +112,8 @@ static void delay_mwaitx(unsigned long _
 		__monitorx(this_cpu_ptr(&cpu_tss), 0, 0);
 
 		/*
-		 * AMD, like Intel, supports the EAX hint and EAX=0xf
-		 * means, do not enter any deep C-state and we use it
+		 * AMD, like Intel's MWAIT version, supports the EAX hint and
+		 * EAX=0xf0 means, do not enter any deep C-state and we use it
 		 * here in delay() to minimize wakeup latency.
 		 */
 		__mwaitx(MWAITX_DISABLE_CSTATES, delay, MWAITX_ECX_TIMER_ENABLE);


