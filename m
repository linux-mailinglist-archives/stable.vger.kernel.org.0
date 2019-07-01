Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2D51F28A
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbfEOLMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:12:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729692AbfEOLMC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:12:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D1212084E;
        Wed, 15 May 2019 11:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918721;
        bh=/Tbe6qeLDDvit17MLfzrZarMMLypuT7YzG0hJorRKFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=upL9r9ZgE9aNRckM6UzRNE6JJ9nVRNYsINPhCl8hVnTeCkT/ztFomZcvnUPokM3kT
         wIOvhe71Nwp76xpXnaFiBGocH84RWwfOaBZXtkxmOmK8HtXE4wxlIAfMDzRjFcrfLH
         +IF/AEO7kP/Tr1xfK7ZgiOE2PdV/8E2jfdiIg6IY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>, Jon Masters <jcm@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 239/266] x86/speculation/mds: Add mitigation mode VMWERV
Date:   Wed, 15 May 2019 12:55:46 +0200
Message-Id: <20190515090731.087091202@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/x86/mds.rst        |   27 +++++++++++++++++++++++++++
 arch/x86/include/asm/processor.h |    1 +
 arch/x86/kernel/cpu/bugs.c       |   18 ++++++++++++------
 3 files changed, 40 insertions(+), 6 deletions(-)

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
@@ -849,6 +849,7 @@ void df_debug(struct pt_regs *regs, long
 enum mds_mitigations {
 	MDS_MITIGATION_OFF,
 	MDS_MITIGATION_FULL,
+	MDS_MITIGATION_VMWERV,
 };
 
 #endif /* _ASM_X86_PROCESSOR_H */
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -213,7 +213,8 @@ static enum mds_mitigations mds_mitigati
 
 static const char * const mds_strings[] = {
 	[MDS_MITIGATION_OFF]	= "Vulnerable",
-	[MDS_MITIGATION_FULL]	= "Mitigation: Clear CPU buffers"
+	[MDS_MITIGATION_FULL]	= "Mitigation: Clear CPU buffers",
+	[MDS_MITIGATION_VMWERV]	= "Vulnerable: Clear CPU buffers attempted, no microcode",
 };
 
 static void __init mds_select_mitigation(void)
@@ -224,10 +225,9 @@ static void __init mds_select_mitigation
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
@@ -687,8 +687,14 @@ void arch_smt_update(void)
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


