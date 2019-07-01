Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30E1120BF9
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfEPQAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:00:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43010 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727074AbfEPP6r (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:47 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImK-0006zm-AQ; Thu, 16 May 2019 16:58:44 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImE-0001S9-QF; Thu, 16 May 2019 16:58:38 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jon Masters" <jcm@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Borislav Petkov" <bp@suse.de>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.797315136@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 72/86] x86/speculation/mds: Add mitigation mode VMWERV
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 22dd8365088b6403630b82423cf906491859b65e upstream.

In virtualized environments it can happen that the host has the microcode
update which utilizes the VERW instruction to clear CPU buffers, but the
hypervisor is not yet updated to expose the X86_FEATURE_MD_CLEAR CPUID bit
to guests.

Introduce an internal mitigation mode VMWERV which enables the invocation
of the CPU buffer clearing even if X86_FEATURE_MD_CLEAR is not set. If the
system has no updated microcode this results in a pointless execution of
the VERW instruction wasting a few CPU cycles. If the microcode is updated,
but not exposed to a guest then the CPU buffers will be cleared.

That said: Virtual Machines Will Eventually Receive Vaccine

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Jon Masters <jcm@redhat.com>
Tested-by: Jon Masters <jcm@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/Documentation/x86/mds.rst
+++ b/Documentation/x86/mds.rst
@@ -93,11 +93,38 @@ The kernel provides a function to invoke
 The mitigation is invoked on kernel/userspace, hypervisor/guest and C-state
 (idle) transitions.
 
+As a special quirk to address virtualization scenarios where the host has
+the microcode updated, but the hypervisor does not (yet) expose the
+MD_CLEAR CPUID bit to guests, the kernel issues the VERW instruction in the
+hope that it might actually clear the buffers. The state is reflected
+accordingly.
+
 According to current knowledge additional mitigations inside the kernel
 itself are not required because the necessary gadgets to expose the leaked
 data cannot be controlled in a way which allows exploitation from malicious
 user space or VM guests.
 
+Kernel internal mitigation modes
+--------------------------------
+
+ ======= ============================================================
+ off      Mitigation is disabled. Either the CPU is not affected or
+          mds=off is supplied on the kernel command line
+
+ full     Mitigation is eanbled. CPU is affected and MD_CLEAR is
+          advertised in CPUID.
+
+ vmwerv	  Mitigation is enabled. CPU is affected and MD_CLEAR is not
+	  advertised in CPUID. That is mainly for virtualization
+	  scenarios where the host has the updated microcode but the
+	  hypervisor does not expose MD_CLEAR in CPUID. It's a best
+	  effort approach without guarantee.
+ ======= ============================================================
+
+If the CPU is affected and mds=off is not supplied on the kernel command
+line then the kernel selects the appropriate mitigation mode depending on
+the availability of the MD_CLEAR CPUID bit.
+
 Mitigation points
 -----------------
 
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -957,6 +957,7 @@ void df_debug(struct pt_regs *regs, long
 enum mds_mitigations {
 	MDS_MITIGATION_OFF,
 	MDS_MITIGATION_FULL,
+	MDS_MITIGATION_VMWERV,
 };
 
 #endif /* _ASM_X86_PROCESSOR_H */
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -279,7 +279,8 @@ static enum mds_mitigations mds_mitigati
 
 static const char * const mds_strings[] = {
 	[MDS_MITIGATION_OFF]	= "Vulnerable",
-	[MDS_MITIGATION_FULL]	= "Mitigation: Clear CPU buffers"
+	[MDS_MITIGATION_FULL]	= "Mitigation: Clear CPU buffers",
+	[MDS_MITIGATION_VMWERV]	= "Vulnerable: Clear CPU buffers attempted, no microcode",
 };
 
 static void __init mds_select_mitigation(void)
@@ -290,10 +291,9 @@ static void __init mds_select_mitigation
 	}
 
 	if (mds_mitigation == MDS_MITIGATION_FULL) {
-		if (boot_cpu_has(X86_FEATURE_MD_CLEAR))
-			static_branch_enable(&mds_user_clear);
-		else
-			mds_mitigation = MDS_MITIGATION_OFF;
+		if (!boot_cpu_has(X86_FEATURE_MD_CLEAR))
+			mds_mitigation = MDS_MITIGATION_VMWERV;
+		static_branch_enable(&mds_user_clear);
 	}
 	pr_info("%s\n", mds_strings[mds_mitigation]);
 }
@@ -753,8 +753,14 @@ void arch_smt_update(void)
 		break;
 	}
 
-	if (mds_mitigation == MDS_MITIGATION_FULL)
+	switch (mds_mitigation) {
+	case MDS_MITIGATION_FULL:
+	case MDS_MITIGATION_VMWERV:
 		update_mds_branch_idle();
+		break;
+	case MDS_MITIGATION_OFF:
+		break;
+	}
 
 	mutex_unlock(&spec_ctrl_mutex);
 }

