Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E441E35A419
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 18:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhDIQ4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 12:56:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232642AbhDIQ4S (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 12:56:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E8A8610CA;
        Fri,  9 Apr 2021 16:56:03 +0000 (UTC)
Date:   Fri, 9 Apr 2021 17:56:01 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Vincenzo Frascino <vincenzo.frascino@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com, Will Deacon <will@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] arm64: mte: Move MTE TCF0 check in entry-common
Message-ID: <20210409165601.GE24031@arm.com>
References: <20210409132419.29965-1-vincenzo.frascino@arm.com>
 <20210409143247.GA58461@C02TD0UTHF1T.local>
 <20210409161030.GA60611@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409161030.GA60611@C02TD0UTHF1T.local>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 09, 2021 at 05:18:45PM +0100, Mark Rutland wrote:
> On Fri, Apr 09, 2021 at 03:32:47PM +0100, Mark Rutland wrote:
> > Hi Vincenzo,
> > 
> > On Fri, Apr 09, 2021 at 02:24:19PM +0100, Vincenzo Frascino wrote:
> > > The check_mte_async_tcf macro sets the TIF flag non-atomically. This can
> > > race with another CPU doing a set_tsk_thread_flag() and all the other flags
> > > can be lost in the process.
> > > 
> > > Move the tcf0 check to enter_from_user_mode() and clear tcf0 in
> > > exit_to_user_mode() to address the problem.
> > > 
> > > Note: Moving the check in entry-common allows to use set_thread_flag()
> > > which is safe.
> 
> I've dug into this a bit more, and as set_thread_flag() calls some
> potentially-instrumented helpers I don't think this is safe after all
> (as e.g. those might cause an EL1 exception and clobber the ESR/FAR/etc
> before the EL0 exception handler reads it).
> 
> Making that watertight is pretty hairy, as we either need to open-code
> set_thread_flag() or go rework a load of core code. If we can use STSET
> in the entry asm that'd be simpler, otherwise we'll need something more
> involved.

I hacked this up quickly:

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 9b4d629f7628..25efe83d68a4 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1646,6 +1646,7 @@ config ARM64_AS_HAS_MTE
 config ARM64_MTE
 	bool "Memory Tagging Extension support"
 	default y
+	depends on ARM64_LSE_ATOMICS
 	depends on ARM64_AS_HAS_MTE && ARM64_TAGGED_ADDR_ABI
 	depends on AS_HAS_ARMV8_5
 	# Required for tag checking in the uaccess routines
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index a45b4ebbfe7d..ad29892f2974 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -148,16 +148,18 @@ alternative_cb_end
 	.endm
 
 	/* Check for MTE asynchronous tag check faults */
-	.macro check_mte_async_tcf, flgs, tmp
+	.macro check_mte_async_tcf, tmp, ti_flags
 #ifdef CONFIG_ARM64_MTE
+	.arch_extension lse
 alternative_if_not ARM64_MTE
 	b	1f
 alternative_else_nop_endif
 	mrs_s	\tmp, SYS_TFSRE0_EL1
 	tbz	\tmp, #SYS_TFSR_EL1_TF0_SHIFT, 1f
 	/* Asynchronous TCF occurred for TTBR0 access, set the TI flag */
-	orr	\flgs, \flgs, #_TIF_MTE_ASYNC_FAULT
-	str	\flgs, [tsk, #TSK_TI_FLAGS]
+	mov	\tmp, #_TIF_MTE_ASYNC_FAULT
+	add	\ti_flags, tsk, #TSK_TI_FLAGS
+	stset	\tmp, [\ti_flags]
 	msr_s	SYS_TFSRE0_EL1, xzr
 1:
 #endif
@@ -244,7 +246,7 @@ alternative_else_nop_endif
 	disable_step_tsk x19, x20
 
 	/* Check for asynchronous tag check faults in user space */
-	check_mte_async_tcf x19, x22
+	check_mte_async_tcf x22, x23
 	apply_ssbd 1, x22, x23
 
 	ptrauth_keys_install_kernel tsk, x20, x22, x23

-- 
Catalin
