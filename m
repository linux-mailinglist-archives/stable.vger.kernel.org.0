Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F31915C785
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729702AbgBMQLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:11:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:59484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727848AbgBMPWX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:22:23 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA9BA24690;
        Thu, 13 Feb 2020 15:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607343;
        bh=Wapkas+waZEDrUTxeCmaU37Zgapt29th2rLS2nZtvWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQ/n3Jkf4LriLbANqT0ySfQBFKurTPEWm/rsffxxVBPVUBEPrlXsEtRLykVpVK4KZ
         DxYwvP2JASr+PzIO2FPhs1EiU47KLheUFQjHrgX7bdNMmsRRMwr2rjSt3a5O9rB2AR
         TnZhYFNupu+AtegwN965yvJ90aGncC0x2Fbtygvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Neelima Krishnan <neelima.krishnan@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 02/91] x86/cpu: Update cached HLE state on write to TSX_CTRL_CPUID_CLEAR
Date:   Thu, 13 Feb 2020 07:19:19 -0800
Message-Id: <20200213151822.199748174@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
References: <20200213151821.384445454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

[ Upstream commit 5efc6fa9044c3356d6046c6e1da6d02572dbed6b ]

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
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/2529b99546294c893dfa1c89e2b3e46da3369a59.1578685425.git.pawan.kumar.gupta@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/tsx.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/tsx.c b/arch/x86/kernel/cpu/tsx.c
index c2a9dd816c5c6..9a7983968ba86 100644
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
-- 
2.20.1



