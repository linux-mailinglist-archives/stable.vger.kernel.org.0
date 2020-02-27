Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F37E81729AA
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 21:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729733AbgB0Ups (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 15:45:48 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:35257 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgB0Ups (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 15:45:48 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1j7Q2Q-0004in-Ts; Thu, 27 Feb 2020 21:45:43 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 771831C217A;
        Thu, 27 Feb 2020 21:45:42 +0100 (CET)
Date:   Thu, 27 Feb 2020 20:45:42 -0000
From:   "tip-bot2 for Tony Luck" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: ras/urgent] x86/mce: Fix logic and comments around MSR_PPIN_CTL
Cc:     Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@suse.de>,
        <stable@vger.kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200226011737.9958-1-tony.luck@intel.com>
References: <20200226011737.9958-1-tony.luck@intel.com>
MIME-Version: 1.0
Message-ID: <158283634211.28353.177653676147385432.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the ras/urgent branch of tip:

Commit-ID:     59b5809655bdafb0767d3fd00a3e41711aab07e6
Gitweb:        https://git.kernel.org/tip/59b5809655bdafb0767d3fd00a3e41711aab07e6
Author:        Tony Luck <tony.luck@intel.com>
AuthorDate:    Tue, 25 Feb 2020 17:17:37 -08:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Thu, 27 Feb 2020 21:36:42 +01:00

x86/mce: Fix logic and comments around MSR_PPIN_CTL

There are two implemented bits in the PPIN_CTL MSR:

Bit 0: LockOut (R/WO)
      Set 1 to prevent further writes to MSR_PPIN_CTL.

Bit 1: Enable_PPIN (R/W)
       If 1, enables MSR_PPIN to be accessible using RDMSR.
       If 0, an attempt to read MSR_PPIN will cause #GP.

So there are four defined values:
	0: PPIN is disabled, PPIN_CTL may be updated
	1: PPIN is disabled. PPIN_CTL is locked against updates
	2: PPIN is enabled. PPIN_CTL may be updated
	3: PPIN is enabled. PPIN_CTL is locked against updates

Code would only enable the X86_FEATURE_INTEL_PPIN feature for case "2".
When it should have done so for both case "2" and case "3".

Fix the final test to just check for the enable bit. Also fix some of
the other comments in this function.

Fixes: 3f5a7896a509 ("x86/mce: Include the PPIN in MCE records when available")
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20200226011737.9958-1-tony.luck@intel.com
---
 arch/x86/kernel/cpu/mce/intel.c |  9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/intel.c b/arch/x86/kernel/cpu/mce/intel.c
index 5627b10..f996ffb 100644
--- a/arch/x86/kernel/cpu/mce/intel.c
+++ b/arch/x86/kernel/cpu/mce/intel.c
@@ -493,17 +493,18 @@ static void intel_ppin_init(struct cpuinfo_x86 *c)
 			return;
 
 		if ((val & 3UL) == 1UL) {
-			/* PPIN available but disabled: */
+			/* PPIN locked in disabled mode */
 			return;
 		}
 
-		/* If PPIN is disabled, but not locked, try to enable: */
-		if (!(val & 3UL)) {
+		/* If PPIN is disabled, try to enable */
+		if (!(val & 2UL)) {
 			wrmsrl_safe(MSR_PPIN_CTL,  val | 2UL);
 			rdmsrl_safe(MSR_PPIN_CTL, &val);
 		}
 
-		if ((val & 3UL) == 2UL)
+		/* Is the enable bit set? */
+		if (val & 2UL)
 			set_cpu_cap(c, X86_FEATURE_INTEL_PPIN);
 	}
 }
