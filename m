Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8331F2AE
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbfEOLJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:09:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728719AbfEOLJT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:09:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05BC32166E;
        Wed, 15 May 2019 11:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918558;
        bh=E/QplMbYRvZFMcE7kvxtMT1Yn314I8iaQxe4vB216Jo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x9S2RKiyZQ5cVBHUFR70gE5pO2gRhmVlnXBmEDUvj1YkQyDkGDPf00jhFKCBCOBaC
         r4ItFLMVMP4MqmW0FLjx/VV+yQjXlsRIw8X1OaGACrapff4Tts0WgSWvRQCpqp/kMk
         c5L9p0plhsTbJrF3pj4QiMP5tdvatLSAwMzK74AU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 179/266] x86/microcode/intel: Add a helper which gives the microcode revision
Date:   Wed, 15 May 2019 12:54:46 +0200
Message-Id: <20190515090728.982698665@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

commit 4167709bbf826512a52ebd6aafda2be104adaec9 upstream.

Since on Intel we're required to do CPUID(1) first, before reading
the microcode revision MSR, let's add a special helper which does the
required steps so that we don't forget to do them next time, when we
want to read the microcode revision.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/20170109114147.5082-4-bp@alien8.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 4.4:
 - Don't touch prev_rev variable in apply_microcode()
 - Keep using sync_core(), which will alway includes the necessary CPUID
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/microcode_intel.h |   15 ++++++++++++
 arch/x86/kernel/cpu/intel.c            |   11 ++-------
 arch/x86/kernel/cpu/microcode/intel.c  |   39 +++++++++------------------------
 3 files changed, 29 insertions(+), 36 deletions(-)

--- a/arch/x86/include/asm/microcode_intel.h
+++ b/arch/x86/include/asm/microcode_intel.h
@@ -53,6 +53,21 @@ struct extended_sigtable {
 
 #define exttable_size(et) ((et)->count * EXT_SIGNATURE_SIZE + EXT_HEADER_SIZE)
 
+static inline u32 intel_get_microcode_revision(void)
+{
+	u32 rev, dummy;
+
+	native_wrmsrl(MSR_IA32_UCODE_REV, 0);
+
+	/* As documented in the SDM: Do a CPUID 1 here */
+	sync_core();
+
+	/* get the current revision from MSR 0x8B */
+	native_rdmsr(MSR_IA32_UCODE_REV, dummy, rev);
+
+	return rev;
+}
+
 extern int has_newer_microcode(void *mc, unsigned int csig, int cpf, int rev);
 extern int microcode_sanity_check(void *mc, int print_err);
 extern int find_matching_signature(void *mc, unsigned int csig, int cpf);
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -14,6 +14,7 @@
 #include <asm/bugs.h>
 #include <asm/cpu.h>
 #include <asm/intel-family.h>
+#include <asm/microcode_intel.h>
 
 #ifdef CONFIG_X86_64
 #include <linux/topology.h>
@@ -102,14 +103,8 @@ static void early_init_intel(struct cpui
 		(c->x86 == 0x6 && c->x86_model >= 0x0e))
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 
-	if (c->x86 >= 6 && !cpu_has(c, X86_FEATURE_IA64)) {
-		unsigned lower_word;
-
-		wrmsr(MSR_IA32_UCODE_REV, 0, 0);
-		/* Required by the SDM */
-		sync_core();
-		rdmsr(MSR_IA32_UCODE_REV, lower_word, c->microcode);
-	}
+	if (c->x86 >= 6 && !cpu_has(c, X86_FEATURE_IA64))
+		c->microcode = intel_get_microcode_revision();
 
 	/* Now if any of them are set, check the blacklist and clear the lot */
 	if ((cpu_has(c, X86_FEATURE_SPEC_CTRL) ||
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -376,15 +376,8 @@ static int collect_cpu_info_early(struct
 		native_rdmsr(MSR_IA32_PLATFORM_ID, val[0], val[1]);
 		csig.pf = 1 << ((val[1] >> 18) & 7);
 	}
-	native_wrmsr(MSR_IA32_UCODE_REV, 0, 0);
 
-	/* As documented in the SDM: Do a CPUID 1 here */
-	sync_core();
-
-	/* get the current revision from MSR 0x8B */
-	native_rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
-
-	csig.rev = val[1];
+	csig.rev = intel_get_microcode_revision();
 
 	uci->cpu_sig = csig;
 	uci->valid = 1;
@@ -654,7 +647,7 @@ static inline void print_ucode(struct uc
 static int apply_microcode_early(struct ucode_cpu_info *uci, bool early)
 {
 	struct microcode_intel *mc_intel;
-	unsigned int val[2];
+	u32 rev;
 
 	mc_intel = uci->mc;
 	if (mc_intel == NULL)
@@ -664,21 +657,16 @@ static int apply_microcode_early(struct
 	native_wrmsr(MSR_IA32_UCODE_WRITE,
 	      (unsigned long) mc_intel->bits,
 	      (unsigned long) mc_intel->bits >> 16 >> 16);
-	native_wrmsr(MSR_IA32_UCODE_REV, 0, 0);
 
-	/* As documented in the SDM: Do a CPUID 1 here */
-	sync_core();
-
-	/* get the current revision from MSR 0x8B */
-	native_rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
-	if (val[1] != mc_intel->hdr.rev)
+	rev = intel_get_microcode_revision();
+	if (rev != mc_intel->hdr.rev)
 		return -1;
 
 #ifdef CONFIG_X86_64
 	/* Flush global tlb. This is precaution. */
 	flush_tlb_early();
 #endif
-	uci->cpu_sig.rev = val[1];
+	uci->cpu_sig.rev = rev;
 
 	if (early)
 		print_ucode(uci);
@@ -852,7 +840,7 @@ static int apply_microcode_intel(int cpu
 {
 	struct microcode_intel *mc_intel;
 	struct ucode_cpu_info *uci;
-	unsigned int val[2];
+	u32 rev;
 	int cpu_num = raw_smp_processor_id();
 	struct cpuinfo_x86 *c = &cpu_data(cpu_num);
 
@@ -877,27 +865,22 @@ static int apply_microcode_intel(int cpu
 	wrmsr(MSR_IA32_UCODE_WRITE,
 	      (unsigned long) mc_intel->bits,
 	      (unsigned long) mc_intel->bits >> 16 >> 16);
-	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
-
-	/* As documented in the SDM: Do a CPUID 1 here */
-	sync_core();
 
-	/* get the current revision from MSR 0x8B */
-	rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
+	rev = intel_get_microcode_revision();
 
-	if (val[1] != mc_intel->hdr.rev) {
+	if (rev != mc_intel->hdr.rev) {
 		pr_err("CPU%d update to revision 0x%x failed\n",
 		       cpu_num, mc_intel->hdr.rev);
 		return -1;
 	}
 	pr_info("CPU%d updated to revision 0x%x, date = %04x-%02x-%02x\n",
-		cpu_num, val[1],
+		cpu_num, rev,
 		mc_intel->hdr.date & 0xffff,
 		mc_intel->hdr.date >> 24,
 		(mc_intel->hdr.date >> 16) & 0xff);
 
-	uci->cpu_sig.rev = val[1];
-	c->microcode = val[1];
+	uci->cpu_sig.rev = rev;
+	c->microcode = rev;
 
 	return 0;
 }


