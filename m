Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8BB31FEEF0
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 11:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbgFRJqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 05:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728568AbgFRJqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 05:46:03 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BD3C06174E;
        Thu, 18 Jun 2020 02:46:02 -0700 (PDT)
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jlr7Q-0005Hl-Qe; Thu, 18 Jun 2020 11:46:00 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 67EDE1C0087;
        Thu, 18 Jun 2020 11:46:00 +0200 (CEST)
Date:   Thu, 18 Jun 2020 09:46:00 -0000
From:   "tip-bot2 for Kees Cook" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/cpu: Use pinning mask for CR4 bits needing to be 0
Cc:     Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <202006082013.71E29A42@keescook>
References: <202006082013.71E29A42@keescook>
MIME-Version: 1.0
Message-ID: <159247356012.16989.5410463148243669489.tip-bot2@tip-bot2>
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

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     a13b9d0b97211579ea63b96c606de79b963c0f47
Gitweb:        https://git.kernel.org/tip/a13b9d0b97211579ea63b96c606de79b963c0f47
Author:        Kees Cook <keescook@chromium.org>
AuthorDate:    Mon, 08 Jun 2020 20:15:09 -07:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Thu, 18 Jun 2020 11:41:32 +02:00

x86/cpu: Use pinning mask for CR4 bits needing to be 0

The X86_CR4_FSGSBASE bit of CR4 should not change after boot[1]. Older
kernels should enforce this bit to zero, and newer kernels need to
enforce it depending on boot-time configuration (e.g. "nofsgsbase").
To support a pinned bit being either 1 or 0, use an explicit mask in
combination with the expected pinned bit values.

[1] https://lore.kernel.org/lkml/20200527103147.GI325280@hirez.programming.kicks-ass.net

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/202006082013.71E29A42@keescook

---
 arch/x86/kernel/cpu/common.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 043d93c..95c090a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -347,6 +347,9 @@ out:
 	cr4_clear_bits(X86_CR4_UMIP);
 }
 
+/* These bits should not change their value after CPU init is finished. */
+static const unsigned long cr4_pinned_mask =
+	X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP | X86_CR4_FSGSBASE;
 static DEFINE_STATIC_KEY_FALSE_RO(cr_pinning);
 static unsigned long cr4_pinned_bits __ro_after_init;
 
@@ -371,20 +374,20 @@ EXPORT_SYMBOL(native_write_cr0);
 
 void native_write_cr4(unsigned long val)
 {
-	unsigned long bits_missing = 0;
+	unsigned long bits_changed = 0;
 
 set_register:
 	asm volatile("mov %0,%%cr4": "+r" (val), "+m" (cr4_pinned_bits));
 
 	if (static_branch_likely(&cr_pinning)) {
-		if (unlikely((val & cr4_pinned_bits) != cr4_pinned_bits)) {
-			bits_missing = ~val & cr4_pinned_bits;
-			val |= bits_missing;
+		if (unlikely((val & cr4_pinned_mask) != cr4_pinned_bits)) {
+			bits_changed = (val & cr4_pinned_mask) ^ cr4_pinned_bits;
+			val = (val & ~cr4_pinned_mask) | cr4_pinned_bits;
 			goto set_register;
 		}
-		/* Warn after we've set the missing bits. */
-		WARN_ONCE(bits_missing, "CR4 bits went missing: %lx!?\n",
-			  bits_missing);
+		/* Warn after we've corrected the changed bits. */
+		WARN_ONCE(bits_changed, "pinned CR4 bits changed: 0x%lx!?\n",
+			  bits_changed);
 	}
 }
 #if IS_MODULE(CONFIG_LKDTM)
@@ -419,7 +422,7 @@ void cr4_init(void)
 	if (boot_cpu_has(X86_FEATURE_PCID))
 		cr4 |= X86_CR4_PCIDE;
 	if (static_branch_likely(&cr_pinning))
-		cr4 |= cr4_pinned_bits;
+		cr4 = (cr4 & ~cr4_pinned_mask) | cr4_pinned_bits;
 
 	__write_cr4(cr4);
 
@@ -434,10 +437,7 @@ void cr4_init(void)
  */
 static void __init setup_cr_pinning(void)
 {
-	unsigned long mask;
-
-	mask = (X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP);
-	cr4_pinned_bits = this_cpu_read(cpu_tlbstate.cr4) & mask;
+	cr4_pinned_bits = this_cpu_read(cpu_tlbstate.cr4) & cr4_pinned_mask;
 	static_key_enable(&cr_pinning.key);
 }
 
