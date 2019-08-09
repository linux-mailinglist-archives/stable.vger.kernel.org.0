Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38CBD87BEB
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407004AbfHINs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:48:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436615AbfHINrh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 09:47:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF6C921783;
        Fri,  9 Aug 2019 13:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565358456;
        bh=PcCLp6hmVyQHCu8sFTqDXx0DaytFtjt19eNkZBBxTnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EgzGQWML4gTDB1g9FzImnN5T21lAlF0hngIHpnfGfDI1YE5pViH4EzCjByAK32XzF
         B7rRYCnQ5h01tQ2CClQcUS1Xur0teQodUZRmPJfz5GpZ9Lvy5ICIm/O6L6RyV5JBK2
         NJ99ezxMZLCjYEpFR8aE8ET3RHForIfV6/Fl9cIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 30/32] x86/speculation: Enable Spectre v1 swapgs mitigations
Date:   Fri,  9 Aug 2019 15:45:33 +0200
Message-Id: <20190809133923.899266794@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809133922.945349906@linuxfoundation.org>
References: <20190809133922.945349906@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit a2059825986a1c8143fd6698774fa9d83733bb11 upstream.

The previous commit added macro calls in the entry code which mitigate the
Spectre v1 swapgs issue if the X86_FEATURE_FENCE_SWAPGS_* features are
enabled.  Enable those features where applicable.

The mitigations may be disabled with "nospectre_v1" or "mitigations=off".

There are different features which can affect the risk of attack:

- When FSGSBASE is enabled, unprivileged users are able to place any
  value in GS, using the wrgsbase instruction.  This means they can
  write a GS value which points to any value in kernel space, which can
  be useful with the following gadget in an interrupt/exception/NMI
  handler:

	if (coming from user space)
		swapgs
	mov %gs:<percpu_offset>, %reg1
	// dependent load or store based on the value of %reg
	// for example: mov %(reg1), %reg2

  If an interrupt is coming from user space, and the entry code
  speculatively skips the swapgs (due to user branch mistraining), it
  may speculatively execute the GS-based load and a subsequent dependent
  load or store, exposing the kernel data to an L1 side channel leak.

  Note that, on Intel, a similar attack exists in the above gadget when
  coming from kernel space, if the swapgs gets speculatively executed to
  switch back to the user GS.  On AMD, this variant isn't possible
  because swapgs is serializing with respect to future GS-based
  accesses.

  NOTE: The FSGSBASE patch set hasn't been merged yet, so the above case
	doesn't exist quite yet.

- When FSGSBASE is disabled, the issue is mitigated somewhat because
  unprivileged users must use prctl(ARCH_SET_GS) to set GS, which
  restricts GS values to user space addresses only.  That means the
  gadget would need an additional step, since the target kernel address
  needs to be read from user space first.  Something like:

	if (coming from user space)
		swapgs
	mov %gs:<percpu_offset>, %reg1
	mov (%reg1), %reg2
	// dependent load or store based on the value of %reg2
	// for example: mov %(reg2), %reg3

  It's difficult to audit for this gadget in all the handlers, so while
  there are no known instances of it, it's entirely possible that it
  exists somewhere (or could be introduced in the future).  Without
  tooling to analyze all such code paths, consider it vulnerable.

  Effects of SMAP on the !FSGSBASE case:

  - If SMAP is enabled, and the CPU reports RDCL_NO (i.e., not
    susceptible to Meltdown), the kernel is prevented from speculatively
    reading user space memory, even L1 cached values.  This effectively
    disables the !FSGSBASE attack vector.

  - If SMAP is enabled, but the CPU *is* susceptible to Meltdown, SMAP
    still prevents the kernel from speculatively reading user space
    memory.  But it does *not* prevent the kernel from reading the
    user value from L1, if it has already been cached.  This is probably
    only a small hurdle for an attacker to overcome.

Thanks to Dave Hansen for contributing the speculative_smap() function.

Thanks to Andrew Cooper for providing the inside scoop on whether swapgs
is serializing on AMD.

[ tglx: Fixed the USER fence decision and polished the comment as suggested
  	by Dave Hansen ]

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Dave Hansen <dave.hansen@intel.com>
[bwh: Backported to 4.9:
 - Check for X86_FEATURE_KAISER instead of X86_FEATURE_PTI
 - mitigations= parameter is x86-only here
 - Adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/kernel-parameters.txt |    9 +-
 arch/x86/kernel/cpu/bugs.c          |  115 +++++++++++++++++++++++++++++++++---
 2 files changed, 111 insertions(+), 13 deletions(-)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2484,6 +2484,7 @@ bytes respectively. Such letter suffixes
 				improves system performance, but it may also
 				expose users to several CPU vulnerabilities.
 				Equivalent to: nopti [X86]
+					       nospectre_v1 [X86]
 					       nospectre_v2 [X86]
 					       spectre_v2_user=off [X86]
 					       spec_store_bypass_disable=off [X86]
@@ -2819,10 +2820,6 @@ bytes respectively. Such letter suffixes
 
 	nohugeiomap	[KNL,x86] Disable kernel huge I/O mappings.
 
-	nospectre_v1	[PPC] Disable mitigations for Spectre Variant 1 (bounds
-			check bypass). With this option data leaks are possible
-			in the system.
-
 	nosmt		[KNL,S390] Disable symmetric multithreading (SMT).
 			Equivalent to smt=1.
 
@@ -2830,6 +2827,10 @@ bytes respectively. Such letter suffixes
 			nosmt=force: Force disable SMT, cannot be undone
 				     via the sysfs control file.
 
+	nospectre_v1	[X86,PPC] Disable mitigations for Spectre Variant 1
+			(bounds check bypass). With this option data leaks are
+			possible in the system.
+
 	nospectre_v2	[X86,PPC_FSL_BOOK3E] Disable all mitigations for the Spectre variant 2
 			(indirect branch prediction) vulnerability. System may
 			allow data leaks with this option, which is equivalent
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -31,6 +31,7 @@
 #include <asm/intel-family.h>
 #include <asm/e820.h>
 
+static void __init spectre_v1_select_mitigation(void);
 static void __init spectre_v2_select_mitigation(void);
 static void __init ssb_select_mitigation(void);
 static void __init l1tf_select_mitigation(void);
@@ -95,17 +96,11 @@ void __init check_bugs(void)
 	if (boot_cpu_has(X86_FEATURE_STIBP))
 		x86_spec_ctrl_mask |= SPEC_CTRL_STIBP;
 
-	/* Select the proper spectre mitigation before patching alternatives */
+	/* Select the proper CPU mitigations before patching alternatives: */
+	spectre_v1_select_mitigation();
 	spectre_v2_select_mitigation();
-
-	/*
-	 * Select proper mitigation for any exposure to the Speculative Store
-	 * Bypass vulnerability.
-	 */
 	ssb_select_mitigation();
-
 	l1tf_select_mitigation();
-
 	mds_select_mitigation();
 
 	arch_smt_update();
@@ -271,6 +266,108 @@ static int __init mds_cmdline(char *str)
 early_param("mds", mds_cmdline);
 
 #undef pr_fmt
+#define pr_fmt(fmt)     "Spectre V1 : " fmt
+
+enum spectre_v1_mitigation {
+	SPECTRE_V1_MITIGATION_NONE,
+	SPECTRE_V1_MITIGATION_AUTO,
+};
+
+static enum spectre_v1_mitigation spectre_v1_mitigation __ro_after_init =
+	SPECTRE_V1_MITIGATION_AUTO;
+
+static const char * const spectre_v1_strings[] = {
+	[SPECTRE_V1_MITIGATION_NONE] = "Vulnerable: __user pointer sanitization and usercopy barriers only; no swapgs barriers",
+	[SPECTRE_V1_MITIGATION_AUTO] = "Mitigation: usercopy/swapgs barriers and __user pointer sanitization",
+};
+
+static bool is_swapgs_serializing(void)
+{
+	/*
+	 * Technically, swapgs isn't serializing on AMD (despite it previously
+	 * being documented as such in the APM).  But according to AMD, %gs is
+	 * updated non-speculatively, and the issuing of %gs-relative memory
+	 * operands will be blocked until the %gs update completes, which is
+	 * good enough for our purposes.
+	 */
+	return boot_cpu_data.x86_vendor == X86_VENDOR_AMD;
+}
+
+/*
+ * Does SMAP provide full mitigation against speculative kernel access to
+ * userspace?
+ */
+static bool smap_works_speculatively(void)
+{
+	if (!boot_cpu_has(X86_FEATURE_SMAP))
+		return false;
+
+	/*
+	 * On CPUs which are vulnerable to Meltdown, SMAP does not
+	 * prevent speculative access to user data in the L1 cache.
+	 * Consider SMAP to be non-functional as a mitigation on these
+	 * CPUs.
+	 */
+	if (boot_cpu_has(X86_BUG_CPU_MELTDOWN))
+		return false;
+
+	return true;
+}
+
+static void __init spectre_v1_select_mitigation(void)
+{
+	if (!boot_cpu_has_bug(X86_BUG_SPECTRE_V1) || cpu_mitigations_off()) {
+		spectre_v1_mitigation = SPECTRE_V1_MITIGATION_NONE;
+		return;
+	}
+
+	if (spectre_v1_mitigation == SPECTRE_V1_MITIGATION_AUTO) {
+		/*
+		 * With Spectre v1, a user can speculatively control either
+		 * path of a conditional swapgs with a user-controlled GS
+		 * value.  The mitigation is to add lfences to both code paths.
+		 *
+		 * If FSGSBASE is enabled, the user can put a kernel address in
+		 * GS, in which case SMAP provides no protection.
+		 *
+		 * [ NOTE: Don't check for X86_FEATURE_FSGSBASE until the
+		 *	   FSGSBASE enablement patches have been merged. ]
+		 *
+		 * If FSGSBASE is disabled, the user can only put a user space
+		 * address in GS.  That makes an attack harder, but still
+		 * possible if there's no SMAP protection.
+		 */
+		if (!smap_works_speculatively()) {
+			/*
+			 * Mitigation can be provided from SWAPGS itself or
+			 * PTI as the CR3 write in the Meltdown mitigation
+			 * is serializing.
+			 *
+			 * If neither is there, mitigate with an LFENCE.
+			 */
+			if (!is_swapgs_serializing() && !boot_cpu_has(X86_FEATURE_KAISER))
+				setup_force_cpu_cap(X86_FEATURE_FENCE_SWAPGS_USER);
+
+			/*
+			 * Enable lfences in the kernel entry (non-swapgs)
+			 * paths, to prevent user entry from speculatively
+			 * skipping swapgs.
+			 */
+			setup_force_cpu_cap(X86_FEATURE_FENCE_SWAPGS_KERNEL);
+		}
+	}
+
+	pr_info("%s\n", spectre_v1_strings[spectre_v1_mitigation]);
+}
+
+static int __init nospectre_v1_cmdline(char *str)
+{
+	spectre_v1_mitigation = SPECTRE_V1_MITIGATION_NONE;
+	return 0;
+}
+early_param("nospectre_v1", nospectre_v1_cmdline);
+
+#undef pr_fmt
 #define pr_fmt(fmt)     "Spectre V2 : " fmt
 
 static enum spectre_v2_mitigation spectre_v2_enabled __ro_after_init =
@@ -1265,7 +1362,7 @@ static ssize_t cpu_show_common(struct de
 		break;
 
 	case X86_BUG_SPECTRE_V1:
-		return sprintf(buf, "Mitigation: __user pointer sanitization\n");
+		return sprintf(buf, "%s\n", spectre_v1_strings[spectre_v1_mitigation]);
 
 	case X86_BUG_SPECTRE_V2:
 		return sprintf(buf, "%s%s%s%s%s%s\n", spectre_v2_strings[spectre_v2_enabled],


