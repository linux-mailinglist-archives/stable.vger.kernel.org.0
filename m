Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99B64F9E84
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 00:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfKLXvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 18:51:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57312 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726973AbfKLXuf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 18:50:35 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iUfvc-0008I1-Vf; Tue, 12 Nov 2019 23:50:33 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iUfvc-00056a-Ef; Tue, 12 Nov 2019 23:50:32 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Neelima Krishnan" <neelima.krishnan@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>,
        "Mark Gross" <mgross@linux.intel.com>,
        "Borislav Petkov" <bp@suse.de>,
        "Pawan Gupta" <pawan.kumar.gupta@linux.intel.com>,
        "Tony Luck" <tony.luck@intel.com>
Date:   Tue, 12 Nov 2019 23:48:00 +0000
Message-ID: <lsq.1573602477.166595068@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 03/25] x86/msr: Add the IA32_TSX_CTRL MSR
In-Reply-To: <lsq.1573602477.548403712@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.77-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit c2955f270a84762343000f103e0640d29c7a96f3 upstream.

Transactional Synchronization Extensions (TSX) may be used on certain
processors as part of a speculative side channel attack.  A microcode
update for existing processors that are vulnerable to this attack will
add a new MSR - IA32_TSX_CTRL to allow the system administrator the
option to disable TSX as one of the possible mitigations.

The CPUs which get this new MSR after a microcode upgrade are the ones
which do not set MSR_IA32_ARCH_CAPABILITIES.MDS_NO (bit 5) because those
CPUs have CPUID.MD_CLEAR, i.e., the VERW implementation which clears all
CPU buffers takes care of the TAA case as well.

  [ Note that future processors that are not vulnerable will also
    support the IA32_TSX_CTRL MSR. ]

Add defines for the new IA32_TSX_CTRL MSR and its bits.

TSX has two sub-features:

1. Restricted Transactional Memory (RTM) is an explicitly-used feature
   where new instructions begin and end TSX transactions.
2. Hardware Lock Elision (HLE) is implicitly used when certain kinds of
   "old" style locks are used by software.

Bit 7 of the IA32_ARCH_CAPABILITIES indicates the presence of the
IA32_TSX_CTRL MSR.

There are two control bits in IA32_TSX_CTRL MSR:

  Bit 0: When set, it disables the Restricted Transactional Memory (RTM)
         sub-feature of TSX (will force all transactions to abort on the
	 XBEGIN instruction).

  Bit 1: When set, it disables the enumeration of the RTM and HLE feature
         (i.e. it will make CPUID(EAX=7).EBX{bit4} and
	  CPUID(EAX=7).EBX{bit11} read as 0).

The other TSX sub-feature, Hardware Lock Elision (HLE), is
unconditionally disabled by the new microcode but still enumerated
as present by CPUID(EAX=7).EBX{bit4}, unless disabled by
IA32_TSX_CTRL_MSR[1] - TSX_CTRL_CPUID_CLEAR.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Neelima Krishnan <neelima.krishnan@intel.com>
Reviewed-by: Mark Gross <mgross@linux.intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
[bwh: Backported to 3.16:
 - Don't use BIT() in msr-index.h because it's a UAPI header
 - Adjust filename, context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/uapi/asm/msr-index.h | 5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -70,10 +70,15 @@
 						    * Microarchitectural Data
 						    * Sampling (MDS) vulnerabilities.
 						    */
+#define ARCH_CAP_TSX_CTRL_MSR		(1UL << 7) /* MSR for TSX control is available. */
 
 #define MSR_IA32_BBL_CR_CTL		0x00000119
 #define MSR_IA32_BBL_CR_CTL3		0x0000011e
 
+#define MSR_IA32_TSX_CTRL		0x00000122
+#define TSX_CTRL_RTM_DISABLE		(1UL << 0) /* Disable RTM feature */
+#define TSX_CTRL_CPUID_CLEAR		(1UL << 1) /* Disable TSX enumeration */
+
 #define MSR_IA32_SYSENTER_CS		0x00000174
 #define MSR_IA32_SYSENTER_ESP		0x00000175
 #define MSR_IA32_SYSENTER_EIP		0x00000176

