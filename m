Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90CD67D737
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731082AbfHAIUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:20:31 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34906 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731077AbfHAIUb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:20:31 -0400
Received: by mail-pf1-f193.google.com with SMTP id u14so33623662pfn.2
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kLSGaDTr3EMSfGVKyIoCGH7cLmpO8I4it2r2qsg5/0U=;
        b=S4Wz6HsrBZ4tFip1H1Xoh71BhAkngC7SSsG3Z60MGcWvZ1nYmLBFkZTCNc/gGBmYqp
         IvV13zZFKByRQ8qi8CH0XXNBfuFpCJIJLwbTMKFqjgMGKK/Q4D/xvBcx878dgpzncKb2
         I0T8P4TIuMTI9CQMhnwtBZulf8EcnVFJrTMqHvdD90TUaF6WWzyoL6U9mkF7srlQQjFa
         jrrGAfvzswQqiIE12EfSt7xGgA6uDsQhoKBwYmwaCADnasmiqQOzxOV2+9PQBa/QRjk8
         skcU3J2/Dw8xQoAvBxZXQBYWI3VkPxRydxL9jSpqww1lQY8LN2GiMi62LdIm56nUincD
         Senw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kLSGaDTr3EMSfGVKyIoCGH7cLmpO8I4it2r2qsg5/0U=;
        b=QwWpKo36W4H/xDz3OLiL9yQc//hftDTTbWT9HO81gF1pbR0xFMjS8SfGp4pYNoG3hK
         Lu/DwDIBFz6LXl1KA6R3ngVAGgnIKgH3G1FWDTI6QqRrJsorMgnK8rRcWCsIjq0newCh
         kfVZhVttah9Ue43tBgVKoW17HPjawIygBHI7ZoHKiW5D8QMwi2KuJkqekKsj0x2WDKW5
         q/5dtFjrYZlST6RvO56j2fTLGDhsrUTjBVX/lYXr0WFwT0fi/17TsBOjKxqSuxLt+IlD
         oLDFrE1wNnPzl5HcNeKF016dGeHa79alVPlmNvxIqhPybd13lOtVUayq3K9cBb8s9/gv
         kn/A==
X-Gm-Message-State: APjAAAVe3PWAthI9/eh94gXKy4oF9V0Tu6LFzgqp2usR32GZAtHMl686
        WPUCnl5gb57KjwJVa6qNt99Ws1p+DU8=
X-Google-Smtp-Source: APXvYqyE9scLeqfx5PxPM5uNMJWNAFC88KUToiImqlb+NU/VvG6/SwuL9DS//GEOKNt+2/e831kPFA==
X-Received: by 2002:a63:db47:: with SMTP id x7mr117148117pgi.375.1564647630247;
        Thu, 01 Aug 2019 01:20:30 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id v185sm80565687pfb.14.2019.08.01.01.20.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:20:29 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, guohanjun@huawei.com
Subject: [PATCH ARM32 v4.4 V2 21/47] ARM: spectre-v1: fix syscall entry
Date:   Thu,  1 Aug 2019 13:46:05 +0530
Message-Id: <64408fb0ea37930f27bb2135b8c7f11a3d16fe7a.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Commit 10573ae547c85b2c61417ff1a106cffbfceada35 upstream.

Prevent speculation at the syscall table decoding by clamping the index
used to zero on invalid system call numbers, and using the csdb
speculative barrier.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Boot-tested-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/kernel/entry-common.S | 18 +++++++-----------
 arch/arm/kernel/entry-header.S | 25 +++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 30a7228eaceb..e969b18d9ff9 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -223,9 +223,7 @@ ENTRY(vector_swi)
 	tst	r10, #_TIF_SYSCALL_WORK		@ are we tracing syscalls?
 	bne	__sys_trace
 
-	cmp	scno, #NR_syscalls		@ check upper syscall limit
-	badr	lr, ret_fast_syscall		@ return address
-	ldrcc	pc, [tbl, scno, lsl #2]		@ call sys_* routine
+	invoke_syscall tbl, scno, r10, ret_fast_syscall
 
 	add	r1, sp, #S_OFF
 2:	cmp	scno, #(__ARM_NR_BASE - __NR_SYSCALL_BASE)
@@ -258,14 +256,8 @@ ENDPROC(vector_swi)
 	mov	r1, scno
 	add	r0, sp, #S_OFF
 	bl	syscall_trace_enter
-
-	badr	lr, __sys_trace_return		@ return address
-	mov	scno, r0			@ syscall number (possibly new)
-	add	r1, sp, #S_R0 + S_OFF		@ pointer to regs
-	cmp	scno, #NR_syscalls		@ check upper syscall limit
-	ldmccia	r1, {r0 - r6}			@ have to reload r0 - r6
-	stmccia	sp, {r4, r5}			@ and update the stack args
-	ldrcc	pc, [tbl, scno, lsl #2]		@ call sys_* routine
+	mov	scno, r0
+	invoke_syscall tbl, scno, r10, __sys_trace_return, reload=1
 	cmp	scno, #-1			@ skip the syscall?
 	bne	2b
 	add	sp, sp, #S_OFF			@ restore stack
@@ -317,6 +309,10 @@ ENTRY(sys_call_table)
 		bic	scno, r0, #__NR_OABI_SYSCALL_BASE
 		cmp	scno, #__NR_syscall - __NR_SYSCALL_BASE
 		cmpne	scno, #NR_syscalls	@ check range
+#ifdef CONFIG_CPU_SPECTRE
+		movhs	scno, #0
+		csdb
+#endif
 		stmloia	sp, {r5, r6}		@ shuffle args
 		movlo	r0, r1
 		movlo	r1, r2
diff --git a/arch/arm/kernel/entry-header.S b/arch/arm/kernel/entry-header.S
index 6d243e830516..86dfee487e24 100644
--- a/arch/arm/kernel/entry-header.S
+++ b/arch/arm/kernel/entry-header.S
@@ -373,6 +373,31 @@
 #endif
 	.endm
 
+	.macro	invoke_syscall, table, nr, tmp, ret, reload=0
+#ifdef CONFIG_CPU_SPECTRE
+	mov	\tmp, \nr
+	cmp	\tmp, #NR_syscalls		@ check upper syscall limit
+	movcs	\tmp, #0
+	csdb
+	badr	lr, \ret			@ return address
+	.if	\reload
+	add	r1, sp, #S_R0 + S_OFF		@ pointer to regs
+	ldmccia	r1, {r0 - r6}			@ reload r0-r6
+	stmccia	sp, {r4, r5}			@ update stack arguments
+	.endif
+	ldrcc	pc, [\table, \tmp, lsl #2]	@ call sys_* routine
+#else
+	cmp	\nr, #NR_syscalls		@ check upper syscall limit
+	badr	lr, \ret			@ return address
+	.if	\reload
+	add	r1, sp, #S_R0 + S_OFF		@ pointer to regs
+	ldmccia	r1, {r0 - r6}			@ reload r0-r6
+	stmccia	sp, {r4, r5}			@ update stack arguments
+	.endif
+	ldrcc	pc, [\table, \nr, lsl #2]	@ call sys_* routine
+#endif
+	.endm
+
 /*
  * These are the registers used in the syscall handler, and allow us to
  * have in theory up to 7 arguments to a function - r0 to r6.
-- 
2.21.0.rc0.269.g1a574e7a288b

