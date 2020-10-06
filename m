Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D68F2849D0
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 11:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgJFJ5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 05:57:14 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35510 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJFJ5O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Oct 2020 05:57:14 -0400
Date:   Tue, 06 Oct 2020 09:57:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601978230;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hBmgB5Er+vzqNYeqv063sBNK/0lCi0BcAlEwYTHTIw8=;
        b=TJOp5jQUiiz3U6d0uvkhfinDEEpfOWNnn/5c/NsxycLMhLZaYH4/FauJ+jGEv7h4cWYuqW
        VkxdLNJ0JUYLvV/G5tcIbYWaYBNNMey03dANvzbsQtuNcv1MNZRSAdbwu2HDIiGMo9tEqU
        4SSE4ggX9O11oEjMKkxR5XseLbgn99qwIN5N0+Y+SWO6aUGjS8tgEVibL4F4dDWBAIvT+b
        gzxOUWgeraR1YQdrmgMFciwZ557lZW90P4FyHIqAlK4skGrbm6Ej78hdPVMDCrd4to7pv/
        LOkElkA3zl5mMF/I/9PB4rTPjSUpia2P8bKI4wIcNoqjv9v/HvRHviWMFBNicw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601978230;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hBmgB5Er+vzqNYeqv063sBNK/0lCi0BcAlEwYTHTIw8=;
        b=TTjnryxmhU1ffnQi7l8yDjGA53sM8TQUs08AI9DAKVs2sRrE+hyWEnOdvKlb4cGhDxf68m
        m1M91WFhZUZPQWDg==
From:   "tip-bot2 for Dan Williams" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: ras/core] x86/copy_mc: Introduce copy_mc_enhanced_fast_string()
Cc:     Erwin Tsaur <erwin.tsaur@intel.com>, 0day robot <lkp@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        <stable@vger.kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: =?utf-8?q?=3C160195562556=2E2163339=2E18063423034951948973=2E?=
 =?utf-8?q?stgit=40dwillia2-desk3=2Eamr=2Ecorp=2Eintel=2Ecom=3E?=
References: =?utf-8?q?=3C160195562556=2E2163339=2E18063423034951948973=2Es?=
 =?utf-8?q?tgit=40dwillia2-desk3=2Eamr=2Ecorp=2Eintel=2Ecom=3E?=
MIME-Version: 1.0
Message-ID: <160197822925.7002.7850474514864790782.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the ras/core branch of tip:

Commit-ID:     5da8e4a658109e3b7e1f45ae672b7c06ac3e7158
Gitweb:        https://git.kernel.org/tip/5da8e4a658109e3b7e1f45ae672b7c06ac3e7158
Author:        Dan Williams <dan.j.williams@intel.com>
AuthorDate:    Mon, 05 Oct 2020 20:40:25 -07:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 06 Oct 2020 11:37:36 +02:00

x86/copy_mc: Introduce copy_mc_enhanced_fast_string()

The motivations to go rework memcpy_mcsafe() are that the benefit of
doing slow and careful copies is obviated on newer CPUs, and that the
current opt-in list of CPUs to instrument recovery is broken relative to
those CPUs.  There is no need to keep an opt-in list up to date on an
ongoing basis if pmem/dax operations are instrumented for recovery by
default. With recovery enabled by default the old "mcsafe_key" opt-in to
careful copying can be made a "fragile" opt-out. Where the "fragile"
list takes steps to not consume poison across cachelines.

The discussion with Linus made clear that the current "_mcsafe" suffix
was imprecise to a fault. The operations that are needed by pmem/dax are
to copy from a source address that might throw #MC to a destination that
may write-fault, if it is a user page.

So copy_to_user_mcsafe() becomes copy_mc_to_user() to indicate
the separate precautions taken on source and destination.
copy_mc_to_kernel() is introduced as a non-SMAP version that does not
expect write-faults on the destination, but is still prepared to abort
with an error code upon taking #MC.

The original copy_mc_fragile() implementation had negative performance
implications since it did not use the fast-string instruction sequence
to perform copies. For this reason copy_mc_to_kernel() fell back to
plain memcpy() to preserve performance on platforms that did not indicate
the capability to recover from machine check exceptions. However, that
capability detection was not architectural and now that some platforms
can recover from fast-string consumption of memory errors the memcpy()
fallback now causes these more capable platforms to fail.

Introduce copy_mc_enhanced_fast_string() as the fast default
implementation of copy_mc_to_kernel() and finalize the transition of
copy_mc_fragile() to be a platform quirk to indicate 'copy-carefully'.
With this in place, copy_mc_to_kernel() is fast and recovery-ready by
default regardless of hardware capability.

Thanks to Vivek for identifying that copy_user_generic() is not suitable
as the copy_mc_to_user() backend since the #MC handler explicitly checks
ex_has_fault_handler(). Thanks to the 0day robot for catching a
performance bug in the x86/copy_mc_to_user implementation.

 [ bp: Add the "why" for this change from the 0/2th message, massage. ]

Fixes: 92b0729c34ca ("x86/mm, x86/mce: Add memcpy_mcsafe()")
Reported-by: Erwin Tsaur <erwin.tsaur@intel.com>
Reported-by: 0day robot <lkp@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Tested-by: Erwin Tsaur <erwin.tsaur@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/160195562556.2163339.18063423034951948973.stgit@dwillia2-desk3.amr.corp.intel.com
---
 arch/x86/lib/copy_mc.c    | 32 +++++++++++++++++++++++---------
 arch/x86/lib/copy_mc_64.S | 36 ++++++++++++++++++++++++++++++++++++
 tools/objtool/check.c     |  1 +
 3 files changed, 60 insertions(+), 9 deletions(-)

diff --git a/arch/x86/lib/copy_mc.c b/arch/x86/lib/copy_mc.c
index 2633635..c13e8c9 100644
--- a/arch/x86/lib/copy_mc.c
+++ b/arch/x86/lib/copy_mc.c
@@ -45,6 +45,8 @@ void enable_copy_mc_fragile(void)
 #define copy_mc_fragile_enabled (0)
 #endif
 
+unsigned long copy_mc_enhanced_fast_string(void *dst, const void *src, unsigned len);
+
 /**
  * copy_mc_to_kernel - memory copy that handles source exceptions
  *
@@ -52,9 +54,11 @@ void enable_copy_mc_fragile(void)
  * @src:	source address
  * @len:	number of bytes to copy
  *
- * Call into the 'fragile' version on systems that have trouble
- * actually do machine check recovery. Everyone else can just
- * use memcpy().
+ * Call into the 'fragile' version on systems that benefit from avoiding
+ * corner case poison consumption scenarios, For example, accessing
+ * poison across 2 cachelines with a single instruction. Almost all
+ * other uses case can use copy_mc_enhanced_fast_string() for a fast
+ * recoverable copy, or fallback to plain memcpy.
  *
  * Return 0 for success, or number of bytes not copied if there was an
  * exception.
@@ -63,6 +67,8 @@ unsigned long __must_check copy_mc_to_kernel(void *dst, const void *src, unsigne
 {
 	if (copy_mc_fragile_enabled)
 		return copy_mc_fragile(dst, src, len);
+	if (static_cpu_has(X86_FEATURE_ERMS))
+		return copy_mc_enhanced_fast_string(dst, src, len);
 	memcpy(dst, src, len);
 	return 0;
 }
@@ -72,11 +78,19 @@ unsigned long __must_check copy_mc_to_user(void *dst, const void *src, unsigned 
 {
 	unsigned long ret;
 
-	if (!copy_mc_fragile_enabled)
-		return copy_user_generic(dst, src, len);
+	if (copy_mc_fragile_enabled) {
+		__uaccess_begin();
+		ret = copy_mc_fragile(dst, src, len);
+		__uaccess_end();
+		return ret;
+	}
+
+	if (static_cpu_has(X86_FEATURE_ERMS)) {
+		__uaccess_begin();
+		ret = copy_mc_enhanced_fast_string(dst, src, len);
+		__uaccess_end();
+		return ret;
+	}
 
-	__uaccess_begin();
-	ret = copy_mc_fragile(dst, src, len);
-	__uaccess_end();
-	return ret;
+	return copy_user_generic(dst, src, len);
 }
diff --git a/arch/x86/lib/copy_mc_64.S b/arch/x86/lib/copy_mc_64.S
index c3b613c..892d891 100644
--- a/arch/x86/lib/copy_mc_64.S
+++ b/arch/x86/lib/copy_mc_64.S
@@ -124,4 +124,40 @@ EXPORT_SYMBOL_GPL(copy_mc_fragile)
 	_ASM_EXTABLE(.L_write_words, .E_write_words)
 	_ASM_EXTABLE(.L_write_trailing_bytes, .E_trailing_bytes)
 #endif /* CONFIG_X86_MCE */
+
+/*
+ * copy_mc_enhanced_fast_string - memory copy with exception handling
+ *
+ * Fast string copy + fault / exception handling. If the CPU does
+ * support machine check exception recovery, but does not support
+ * recovering from fast-string exceptions then this CPU needs to be
+ * added to the copy_mc_fragile_key set of quirks. Otherwise, absent any
+ * machine check recovery support this version should be no slower than
+ * standard memcpy.
+ */
+SYM_FUNC_START(copy_mc_enhanced_fast_string)
+	movq %rdi, %rax
+	movq %rdx, %rcx
+.L_copy:
+	rep movsb
+	/* Copy successful. Return zero */
+	xorl %eax, %eax
+	ret
+SYM_FUNC_END(copy_mc_enhanced_fast_string)
+
+	.section .fixup, "ax"
+.E_copy:
+	/*
+	 * On fault %rcx is updated such that the copy instruction could
+	 * optionally be restarted at the fault position, i.e. it
+	 * contains 'bytes remaining'. A non-zero return indicates error
+	 * to copy_mc_generic() users, or indicate short transfers to
+	 * user-copy routines.
+	 */
+	movq %rcx, %rax
+	ret
+
+	.previous
+
+	_ASM_EXTABLE_FAULT(.L_copy, .E_copy)
 #endif /* !CONFIG_UML */
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 893f021..b3e4efc 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -550,6 +550,7 @@ static const char *uaccess_safe_builtin[] = {
 	"csum_partial_copy_generic",
 	"copy_mc_fragile",
 	"copy_mc_fragile_handle_tail",
+	"copy_mc_enhanced_fast_string",
 	"ftrace_likely_update", /* CONFIG_TRACE_BRANCH_PROFILING */
 	NULL
 };
