Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8C41DB679
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgETOZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:25:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33152 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727056AbgETOW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:28 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbv-00035k-UW; Wed, 20 May 2020 15:22:20 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbv-007DSC-No; Wed, 20 May 2020 15:22:19 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        "Neelima Krishnan" <neelima.krishnan@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Pawan Gupta" <pawan.kumar.gupta@linux.intel.com>
Date:   Wed, 20 May 2020 15:14:22 +0100
Message-ID: <lsq.1589984008.274460399@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 54/99] x86/cpu: Update cached HLE state on write to
 TSX_CTRL_CPUID_CLEAR
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 5efc6fa9044c3356d6046c6e1da6d02572dbed6b upstream.

/proc/cpuinfo currently reports Hardware Lock Elision (HLE) feature to
be present on boot cpu even if it was disabled during the bootup. This
is because cpuinfo_x86->x86_capability HLE bit is not updated after TSX
state is changed via the new MSR IA32_TSX_CTRL.

Update the cached HLE bit also since it is expected to change after an
update to CPUID_CLEAR bit in MSR IA32_TSX_CTRL.

Fixes: 95c5824f75f3 ("x86/cpu: Add a "tsx=" cmdline option with TSX disabled by default")
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Neelima Krishnan <neelima.krishnan@intel.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/2529b99546294c893dfa1c89e2b3e46da3369a59.1578685425.git.pawan.kumar.gupta@linux.intel.com
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/cpu/tsx.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/cpu/tsx.c
+++ b/arch/x86/kernel/cpu/tsx.c
@@ -115,11 +115,12 @@ void __init tsx_init(void)
 		tsx_disable();
 
 		/*
-		 * tsx_disable() will change the state of the
-		 * RTM CPUID bit.  Clear it here since it is now
-		 * expected to be not set.
+		 * tsx_disable() will change the state of the RTM and HLE CPUID
+		 * bits. Clear them here since they are now expected to be not
+		 * set.
 		 */
 		setup_clear_cpu_cap(X86_FEATURE_RTM);
+		setup_clear_cpu_cap(X86_FEATURE_HLE);
 	} else if (tsx_ctrl_state == TSX_CTRL_ENABLE) {
 
 		/*
@@ -131,10 +132,10 @@ void __init tsx_init(void)
 		tsx_enable();
 
 		/*
-		 * tsx_enable() will change the state of the
-		 * RTM CPUID bit.  Force it here since it is now
-		 * expected to be set.
+		 * tsx_enable() will change the state of the RTM and HLE CPUID
+		 * bits. Force them here since they are now expected to be set.
 		 */
 		setup_force_cpu_cap(X86_FEATURE_RTM);
+		setup_force_cpu_cap(X86_FEATURE_HLE);
 	}
 }

