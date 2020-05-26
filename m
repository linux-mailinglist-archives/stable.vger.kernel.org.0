Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884871AC689
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389448AbgDPOk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:40:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409473AbgDPOBh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:01:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AF4B2078B;
        Thu, 16 Apr 2020 14:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045697;
        bh=f/MuBIwhf8lkkmoBHa26oyZAK+2rL9c6PazhpF9AxPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R9S0LSPjgWHFnIsZKJhQVvWCQ9oU1yZnRB1IpceuF5gaSpSjUhfQxaGCt4o4F4iGd
         wEgT3onKsgWRaNZebht6xlQFn7xOFI+RwjxG0kNUajwj+s5A6a7Y+B4CmQ8qr4ELla
         0l49uGGs6ByIO7Rfq9nRCfIAEqCQpnuLgvGtKkVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Donnellan <ajd@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Daniel Axtens <dja@axtens.net>
Subject: [PATCH 5.6 241/254] powerpc/64: Setup a paca before parsing device tree etc.
Date:   Thu, 16 Apr 2020 15:25:30 +0200
Message-Id: <20200416131355.973102977@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Axtens <dja@axtens.net>

commit d4a8e98621543d5798421eed177978bf2b3cdd11 upstream.

Currently we set up the paca after parsing the device tree for CPU
features. Prior to that, r13 contains random data, which means there
is random data in r13 while we're running the generic dt parsing code.

This random data varies depending on whether we boot through a vmlinux
or a zImage: for the vmlinux case it's usually around zero, but for
zImages we see random values like 912a72603d420015.

This is poor practice, and can also lead to difficult-to-debug
crashes. For example, when kcov is enabled, the kcov instrumentation
attempts to read preempt_count out of the current task, which goes via
the paca. This then crashes in the zImage case.

Similarly stack protector can cause crashes if r13 is bogus, by
reading from the stack canary in the paca.

To resolve this:

 - move the paca setup to before the CPU feature parsing.

 - because we no longer have access to CPU feature flags in paca
 setup, change the HV feature test in the paca setup path to consider
 the actual value of the MSR rather than the CPU feature.

Translations get switched on once we leave early_setup, so I think
we'd already catch any other cases where the paca or task aren't set
up.

Boot tested on a P9 guest and host.

Fixes: fb0b0a73b223 ("powerpc: Enable kcov")
Fixes: 06ec27aea9fc ("powerpc/64: add stack protector support")
Cc: stable@vger.kernel.org # v4.20+
Reviewed-by: Andrew Donnellan <ajd@linux.ibm.com>
Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Daniel Axtens <dja@axtens.net>
[mpe: Reword comments & change log a bit to mention stack protector]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200320032116.1024773-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/dt_cpu_ftrs.c |    1 -
 arch/powerpc/kernel/paca.c        |   10 +++++++---
 arch/powerpc/kernel/setup_64.c    |   30 ++++++++++++++++++++++++------
 3 files changed, 31 insertions(+), 10 deletions(-)

--- a/arch/powerpc/kernel/dt_cpu_ftrs.c
+++ b/arch/powerpc/kernel/dt_cpu_ftrs.c
@@ -139,7 +139,6 @@ static void __init cpufeatures_setup_cpu
 	/* Initialize the base environment -- clear FSCR/HFSCR.  */
 	hv_mode = !!(mfmsr() & MSR_HV);
 	if (hv_mode) {
-		/* CPU_FTR_HVMODE is used early in PACA setup */
 		cur_cpu_spec->cpu_features |= CPU_FTR_HVMODE;
 		mtspr(SPRN_HFSCR, 0);
 	}
--- a/arch/powerpc/kernel/paca.c
+++ b/arch/powerpc/kernel/paca.c
@@ -214,11 +214,15 @@ void setup_paca(struct paca_struct *new_
 	/* On Book3E, initialize the TLB miss exception frames */
 	mtspr(SPRN_SPRG_TLB_EXFRAME, local_paca->extlb);
 #else
-	/* In HV mode, we setup both HPACA and PACA to avoid problems
+	/*
+	 * In HV mode, we setup both HPACA and PACA to avoid problems
 	 * if we do a GET_PACA() before the feature fixups have been
-	 * applied
+	 * applied.
+	 *
+	 * Normally you should test against CPU_FTR_HVMODE, but CPU features
+	 * are not yet set up when we first reach here.
 	 */
-	if (early_cpu_has_feature(CPU_FTR_HVMODE))
+	if (mfmsr() & MSR_HV)
 		mtspr(SPRN_SPRG_HPACA, local_paca);
 #endif
 	mtspr(SPRN_SPRG_PACA, local_paca);
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -285,18 +285,36 @@ void __init early_setup(unsigned long dt
 
 	/* -------- printk is _NOT_ safe to use here ! ------- */
 
-	/* Try new device tree based feature discovery ... */
-	if (!dt_cpu_ftrs_init(__va(dt_ptr)))
-		/* Otherwise use the old style CPU table */
-		identify_cpu(0, mfspr(SPRN_PVR));
-
-	/* Assume we're on cpu 0 for now. Don't write to the paca yet! */
+	/*
+	 * Assume we're on cpu 0 for now.
+	 *
+	 * We need to load a PACA very early for a few reasons.
+	 *
+	 * The stack protector canary is stored in the paca, so as soon as we
+	 * call any stack protected code we need r13 pointing somewhere valid.
+	 *
+	 * If we are using kcov it will call in_task() in its instrumentation,
+	 * which relies on the current task from the PACA.
+	 *
+	 * dt_cpu_ftrs_init() calls into generic OF/fdt code, as well as
+	 * printk(), which can trigger both stack protector and kcov.
+	 *
+	 * percpu variables and spin locks also use the paca.
+	 *
+	 * So set up a temporary paca. It will be replaced below once we know
+	 * what CPU we are on.
+	 */
 	initialise_paca(&boot_paca, 0);
 	setup_paca(&boot_paca);
 	fixup_boot_paca();
 
 	/* -------- printk is now safe to use ------- */
 
+	/* Try new device tree based feature discovery ... */
+	if (!dt_cpu_ftrs_init(__va(dt_ptr)))
+		/* Otherwise use the old style CPU table */
+		identify_cpu(0, mfspr(SPRN_PVR));
+
 	/* Enable early debugging if any specified (see udbg.h) */
 	udbg_early_init();
 


