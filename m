Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96FB5F510E
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 10:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiJEIno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 04:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiJEInk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 04:43:40 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA9F74DCD;
        Wed,  5 Oct 2022 01:43:39 -0700 (PDT)
Date:   Wed, 5 Oct 2022 10:43:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1664959417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YUhdeTLnxdYmOvPifFFeBXKgsqaD5X82FItEAMBhlJs=;
        b=jf1ERVTQJq95KzHJs4mQ+Ex9Nk5qcqDGUzkVtDWaoryRrOW4Q2l+IjAB9/Weqb6sHIt+zp
        Bi2QV5GHqGM7pIB1Fn8OZ8DLHDr9w5KDspoAcTyF+QvnE49P8N70vAcX+UIpBeDuTEzPe/
        JuWIaLbxJMVV83FfNH/8AsvjH5JFi/HEgp6VgIZhHYy+JBjKdyuaRJVkaepkkTJpH/AV+W
        f/O3YI54rgWEGeXZYtbcnPRNgBl120CNo5H8Q288uX75xCOxcyu1JiKeRty4lVydn1g/BK
        4rHMH/Sp9dqYWQwKAVThXWpmz28570bIRGfQyU3/749OVZk6PqAqgkaWllCVRw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1664959417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YUhdeTLnxdYmOvPifFFeBXKgsqaD5X82FItEAMBhlJs=;
        b=XbcNL3z6wgdaLRSoUCdqCVEJRC2zAmXggWWsidjcCIA6M8cGlotu7uAowm/UVkhK1VUUP3
        ODDeiB2CDS8g26Dw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     stable@vger.kernel.org
Cc:     linux-rt-users@vger.kernel.org,
        Danilo Cezar Zanella <danilo.zanella@iag.usp.br>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] ARM: fix function graph tracer and unwinder dependencies
Message-ID: <Yz1DtlYj+W7jfJLK@linutronix.de>
References: <CAAxUTH4zpibkhOS+NPzcYsXFqx1bJfSU19gdt0eCAOrpWAkinA@mail.gmail.com>
 <YyTXIUjq9tmFPTDi@linutronix.de>
 <CAAxUTH4xawCFpnwpRkcaZ5fdzMEbZZmPOyVDoqdMrPrf+G64dg@mail.gmail.com>
 <YzLZIX+Pi6lyIr1f@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YzLZIX+Pi6lyIr1f@linutronix.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Danilo Cezar Zanella reported broken function graph tracer in the v4.19
tree. This was caused by the backport of commit
   f9b58e8c7d031 ("ARM: 8800/1: use choice for kernel unwinders")

which ended in the v4.19-stable tree as of v4.19.222.
It is also part of v4.14-stable since v4.14.259.
It is also part of v4.9-stable since v4.9.299.

------->8---------

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Tue, 23 Apr 2019 17:09:38 +0100
Subject: [PATCH] ARM: fix function graph tracer and unwinder dependencies

Upstream commit 503621628b32782a07b2318e4112bd4372aa3401

Naresh Kamboju recently reported that the function-graph tracer crashes
on ARM. The function-graph tracer assumes that the kernel is built with
frame pointers.

We explicitly disabled the function-graph tracer when building Thumb2,
since the Thumb2 ABI doesn't have frame pointers.

We recently changed the way the unwinder method was selected, which
seems to have made it more likely that we can end up with the function-
graph tracer enabled but without the kernel built with frame pointers.

Fix up the function graph tracer dependencies so the option is not
available when we have no possibility of having frame pointers, and
adjust the dependencies on the unwinder option to hide the non-frame
pointer unwinder options if the function-graph tracer is enabled.

Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reported-by: Danilo Cezar Zanella <danilo.zanella@iag.usp.br>
---
 arch/arm/Kconfig       | 2 +-
 arch/arm/Kconfig.debug | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index d89d013f586cb..fce7e85f3ef57 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -68,7 +68,7 @@ config ARM
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS if (CPU_V6 || CPU_V6K || CPU_V7) && MMU
 	select HAVE_EXIT_THREAD
 	select HAVE_FTRACE_MCOUNT_RECORD if (!XIP_KERNEL)
-	select HAVE_FUNCTION_GRAPH_TRACER if (!THUMB2_KERNEL)
+	select HAVE_FUNCTION_GRAPH_TRACER if (!THUMB2_KERNEL && !CC_IS_CLANG)
 	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
 	select HAVE_FUTEX_CMPXCHG if FUTEX
 	select HAVE_GCC_PLUGINS
diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 01c760929c9e4..b931fac129a1b 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -47,8 +47,8 @@ config DEBUG_WX
 
 choice
 	prompt "Choose kernel unwinder"
-	default UNWINDER_ARM if AEABI && !FUNCTION_GRAPH_TRACER
-	default UNWINDER_FRAME_POINTER if !AEABI || FUNCTION_GRAPH_TRACER
+	default UNWINDER_ARM if AEABI
+	default UNWINDER_FRAME_POINTER if !AEABI
 	help
 	  This determines which method will be used for unwinding kernel stack
 	  traces for panics, oopses, bugs, warnings, perf, /proc/<pid>/stack,
@@ -65,7 +65,7 @@ config UNWINDER_FRAME_POINTER
 
 config UNWINDER_ARM
 	bool "ARM EABI stack unwinder"
-	depends on AEABI
+	depends on AEABI && !FUNCTION_GRAPH_TRACER
 	select ARM_UNWIND
 	help
 	  This option enables stack unwinding support in the kernel
-- 
2.37.2

