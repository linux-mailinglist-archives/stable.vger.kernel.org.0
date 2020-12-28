Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BCC2E4255
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391660AbgL1OBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:01:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:34674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408141AbgL1OBG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:01:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04D10207B6;
        Mon, 28 Dec 2020 14:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164050;
        bh=thLZbKnG6g3LPQyupPt7X0NvXP52kbbHpvI6KL6P03E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v9v19WrqpkZoVxKvnvSTN1b+PVif7iP2AdWpUwGv7pwkEytM2uOgcQlfhPS7L3wac
         D4pMVE7TLFG966EacMQuivTfWeR99w0Bcd5yXMqHSyCdSVzQexjCtC3enfNG8qze+G
         Yj5XNggeF/M9q4/7qM/661NI1INJ2Yee1gJJJUYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jordan Niethe <jniethe5@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/717] powerpc/64: Set up a kernel stack for secondaries before cpu_restore()
Date:   Mon, 28 Dec 2020 13:40:39 +0100
Message-Id: <20201228125022.955359659@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jordan Niethe <jniethe5@gmail.com>

[ Upstream commit 3c0b976bf20d236c57adcefa80f86a0a1d737727 ]

Currently in generic_secondary_smp_init(), cur_cpu_spec->cpu_restore()
is called before a stack has been set up in r1. This was previously fine
as the cpu_restore() functions were implemented in assembly and did not
use a stack. However commit 5a61ef74f269 ("powerpc/64s: Support new
device tree binding for discovering CPU features") used
__restore_cpu_cpufeatures() as the cpu_restore() function for a
device-tree features based cputable entry. This is a C function and
hence uses a stack in r1.

generic_secondary_smp_init() is entered on the secondary cpus via the
primary cpu using the OPAL call opal_start_cpu(). In OPAL, each hardware
thread has its own stack. The OPAL call is ran in the primary's hardware
thread. During the call, a job is scheduled on a secondary cpu that will
start executing at the address of generic_secondary_smp_init().  Hence
the value that will be left in r1 when the secondary cpu enters the
kernel is part of that secondary cpu's individual OPAL stack. This means
that __restore_cpu_cpufeatures() will write to that OPAL stack. This is
not horribly bad as each hardware thread has its own stack and the call
that enters the kernel from OPAL never returns, but it is still wrong
and should be corrected.

Create the temp kernel stack before calling cpu_restore().

As noted by mpe, for a kexec boot, the secondary CPUs are released from
the spin loop at address 0x60 by smp_release_cpus() and then jump to
generic_secondary_smp_init(). The call to smp_release_cpus() is in
setup_arch(), and it comes before the call to emergency_stack_init().
emergency_stack_init() allocates an emergency stack in the PACA for each
CPU.  This address in the PACA is what is used to set up the temp kernel
stack in generic_secondary_smp_init(). Move releasing the secondary CPUs
to after the PACAs have been allocated an emergency stack, otherwise the
PACA stack pointer will contain garbage and hence the temp kernel stack
created from it will be broken.

Fixes: 5a61ef74f269 ("powerpc/64s: Support new device tree binding for discovering CPU features")
Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201014072837.24539-1-jniethe5@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/head_64.S      | 8 ++++----
 arch/powerpc/kernel/setup-common.c | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index 1510b2a56669f..7b7c8c5ee6602 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -417,6 +417,10 @@ generic_secondary_common_init:
 	/* From now on, r24 is expected to be logical cpuid */
 	mr	r24,r5
 
+	/* Create a temp kernel stack for use before relocation is on.	*/
+	ld	r1,PACAEMERGSP(r13)
+	subi	r1,r1,STACK_FRAME_OVERHEAD
+
 	/* See if we need to call a cpu state restore handler */
 	LOAD_REG_ADDR(r23, cur_cpu_spec)
 	ld	r23,0(r23)
@@ -445,10 +449,6 @@ generic_secondary_common_init:
 	sync				/* order paca.run and cur_cpu_spec */
 	isync				/* In case code patching happened */
 
-	/* Create a temp kernel stack for use before relocation is on.	*/
-	ld	r1,PACAEMERGSP(r13)
-	subi	r1,r1,STACK_FRAME_OVERHEAD
-
 	b	__secondary_start
 #endif /* SMP */
 
diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 808ec9fab6052..da8c71f321ad3 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -919,8 +919,6 @@ void __init setup_arch(char **cmdline_p)
 
 	/* On BookE, setup per-core TLB data structures. */
 	setup_tlb_core_data();
-
-	smp_release_cpus();
 #endif
 
 	/* Print various info about the machine that has been gathered so far. */
@@ -944,6 +942,8 @@ void __init setup_arch(char **cmdline_p)
 	exc_lvl_early_init();
 	emergency_stack_init();
 
+	smp_release_cpus();
+
 	initmem_init();
 
 	early_memtest(min_low_pfn << PAGE_SHIFT, max_low_pfn << PAGE_SHIFT);
-- 
2.27.0



