Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B04F284475
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 05:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgJFD7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 23:59:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:36760 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbgJFD7A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 23:59:00 -0400
IronPort-SDR: 2vZXNhutZWrAfxCPbMLx6sCIoGF8ZuQX+6yPPElBtbUDUSvYSRkvEopN7AiQdijbVNot9wYKiT
 RZxxkQWWIB0Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="151270021"
X-IronPort-AV: E=Sophos;i="5.77,341,1596524400"; 
   d="scan'208";a="151270021"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 20:58:58 -0700
IronPort-SDR: bujbWSfLueXkxKq2cztZb+793JlesbU9H3RPddQ/N06nD8PoX1oyo1SR7q+Em8PaVVsHmedtcv
 BckjvUByW8eg==
X-IronPort-AV: E=Sophos;i="5.77,341,1596524400"; 
   d="scan'208";a="348128442"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 20:58:57 -0700
Subject: [PATCH v10 2/2] x86/copy_mc: Introduce
 copy_mc_enhanced_fast_string()
From:   Dan Williams <dan.j.williams@intel.com>
To:     bp@alien8.de
Cc:     x86@kernel.org, stable@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        0day robot <lkp@intel.com>, linux-kernel@vger.kernel.org,
        linux-nvdimm@lists.01.org, x86@kernel.org
Date:   Mon, 05 Oct 2020 20:40:25 -0700
Message-ID: <160195562556.2163339.18063423034951948973.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <160195561059.2163339.8787400120285484198.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <160195561059.2163339.8787400120285484198.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The original copy_mc_fragile() implementation had negative performance
implications since it did not use the fast-string instruction sequence
to perform copies. For this reason copy_mc_to_kernel() fell back to
plain memcpy() to preserve performance on platform that did not indicate
the capability to recover from machine check exceptions. However, that
capability detection was not architectural and now that some platforms
can recover from fast-string consumption of memory errors the memcpy()
fallback now causes these more capable platforms to fail.

Introduce copy_mc_enhanced_fast_string() as the fast default
implementation of copy_mc_to_kernel() and finalize the transition of
copy_mc_fragile() to be a platform quirk to indicate 'copy-carefully'.
With this in place copy_mc_to_kernel() is fast and recovery-ready by
default regardless of hardware capability.

Thanks to Vivek for identifying that copy_user_generic() is not suitable
as the copy_mc_to_user() backend since the #MC handler explicitly checks
ex_has_fault_handler(). Thanks to the 0day robot for catching a
performance bug in the x86/copy_mc_to_user implementation.

Cc: x86@kernel.org
Cc: <stable@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reported-by: Erwin Tsaur <erwin.tsaur@intel.com>
Tested-by: Erwin Tsaur <erwin.tsaur@intel.com>
Reported-by: 0day robot <lkp@intel.com>
Fixes: 92b0729c34ca ("x86/mm, x86/mce: Add memcpy_mcsafe()")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/lib/copy_mc.c    |   32 +++++++++++++++++++++++---------
 arch/x86/lib/copy_mc_64.S |   36 ++++++++++++++++++++++++++++++++++++
 tools/objtool/check.c     |    1 +
 3 files changed, 60 insertions(+), 9 deletions(-)

diff --git a/arch/x86/lib/copy_mc.c b/arch/x86/lib/copy_mc.c
index 2633635530b7..c13e8c9ee926 100644
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
index c3b613c4544a..892d8915f609 100644
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
index cf2d076f6ba5..42ac19e0299c 100644
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

