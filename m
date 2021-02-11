Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876E1318DEB
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbhBKPO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:14:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:51400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229960AbhBKPKA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:10:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA0E664EBB;
        Thu, 11 Feb 2021 15:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055815;
        bh=xZE144G+sdkvJmIUh3w0jMMDaqGM44ImNyynqy6ZetY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jDTiKqfKSd6hqXtnFOmBXxYcgU+zjHoSdjnLxzMXvMWS36ppp2Gij7vAuB10uc+XJ
         1GcJ0qkQ/5xtivsivTZ37PYjRGYaXuDr2cXlzG9/8FVv/7QGYqIQekGW0k/vKEVEv2
         YZnsZgf3ERs6SenpqaJQrP44FQHnfJQAzPXdGf+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Raoni Fassina Firmino <raoni@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 18/54] powerpc/64/signal: Fix regression in __kernel_sigtramp_rt64() semantics
Date:   Thu, 11 Feb 2021 16:02:02 +0100
Message-Id: <20210211150153.670452994@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raoni Fassina Firmino <raoni@linux.ibm.com>

commit 24321ac668e452a4942598533d267805f291fdc9 upstream.

Commit 0138ba5783ae ("powerpc/64/signal: Balance return predictor
stack in signal trampoline") changed __kernel_sigtramp_rt64() VDSO and
trampoline code, and introduced a regression in the way glibc's
backtrace()[1] detects the signal-handler stack frame. Apart from the
practical implications, __kernel_sigtramp_rt64() was a VDSO function
with the semantics that it is a function you can call from userspace
to end a signal handling. Now this semantics are no longer valid.

I believe the aforementioned change affects all releases since 5.9.

This patch tries to fix both the semantics and practical aspect of
__kernel_sigtramp_rt64() returning it to the previous code, whilst
keeping the intended behaviour of 0138ba5783ae by adding a new symbol
to serve as the jump target from the kernel to the trampoline. Now the
trampoline has two parts, a new entry point and the old return point.

[1] https://lists.ozlabs.org/pipermail/linuxppc-dev/2021-January/223194.html

Fixes: 0138ba5783ae ("powerpc/64/signal: Balance return predictor stack in signal trampoline")
Cc: stable@vger.kernel.org # v5.9+
Signed-off-by: Raoni Fassina Firmino <raoni@linux.ibm.com>
Acked-by: Nicholas Piggin <npiggin@gmail.com>
[mpe: Minor tweaks to change log formatting, add stable tag]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210201200505.iz46ubcizipnkcxe@work-tp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/vdso.c              |    2 +-
 arch/powerpc/kernel/vdso64/sigtramp.S   |   11 ++++++++++-
 arch/powerpc/kernel/vdso64/vdso64.lds.S |    1 +
 3 files changed, 12 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/vdso.c
+++ b/arch/powerpc/kernel/vdso.c
@@ -475,7 +475,7 @@ static __init void vdso_setup_trampoline
 	 */
 
 #ifdef CONFIG_PPC64
-	vdso64_rt_sigtramp = find_function64(v64, "__kernel_sigtramp_rt64");
+	vdso64_rt_sigtramp = find_function64(v64, "__kernel_start_sigtramp_rt64");
 #endif
 	vdso32_sigtramp	   = find_function32(v32, "__kernel_sigtramp32");
 	vdso32_rt_sigtramp = find_function32(v32, "__kernel_sigtramp_rt32");
--- a/arch/powerpc/kernel/vdso64/sigtramp.S
+++ b/arch/powerpc/kernel/vdso64/sigtramp.S
@@ -15,11 +15,20 @@
 
 	.text
 
+/*
+ * __kernel_start_sigtramp_rt64 and __kernel_sigtramp_rt64 together
+ * are one function split in two parts. The kernel jumps to the former
+ * and the signal handler indirectly (by blr) returns to the latter.
+ * __kernel_sigtramp_rt64 needs to point to the return address so
+ * glibc can correctly identify the trampoline stack frame.
+ */
 	.balign 8
 	.balign IFETCH_ALIGN_BYTES
-V_FUNCTION_BEGIN(__kernel_sigtramp_rt64)
+V_FUNCTION_BEGIN(__kernel_start_sigtramp_rt64)
 .Lsigrt_start:
 	bctrl	/* call the handler */
+V_FUNCTION_END(__kernel_start_sigtramp_rt64)
+V_FUNCTION_BEGIN(__kernel_sigtramp_rt64)
 	addi	r1, r1, __SIGNAL_FRAMESIZE
 	li	r0,__NR_rt_sigreturn
 	sc
--- a/arch/powerpc/kernel/vdso64/vdso64.lds.S
+++ b/arch/powerpc/kernel/vdso64/vdso64.lds.S
@@ -150,6 +150,7 @@ VERSION
 		__kernel_get_tbfreq;
 		__kernel_sync_dicache;
 		__kernel_sync_dicache_p5;
+		__kernel_start_sigtramp_rt64;
 		__kernel_sigtramp_rt64;
 		__kernel_getcpu;
 		__kernel_time;


