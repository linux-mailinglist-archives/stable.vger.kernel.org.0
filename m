Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0631DDABA
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730778AbgEUXEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:04:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:4802 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730658AbgEUXEH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 19:04:07 -0400
IronPort-SDR: fLJ1j8dp4YQvTRSrI6qZf6s6UZtuEkNOjcQ67m+XZMaPDoi2WYUDdEFuuFefUDQS0nIs5Vgm0x
 GDeNoWsjDjqQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 16:04:06 -0700
IronPort-SDR: 0Ks7DztqBRsmQK36PCIIUEB8W/YCU6eK6LrhDnwP8YBf3/cIrhB74iTnnwdx2ZkfNIOoUTnmVO
 fV2pPLy6Gp9Q==
X-IronPort-AV: E=Sophos;i="5.73,419,1583222400"; 
   d="scan'208";a="300483150"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 16:04:05 -0700
Subject: [PATCH v4 2/2] x86/copy_mc: Introduce copy_mc_generic()
From:   Dan Williams <dan.j.williams@intel.com>
To:     tglx@linutronix.de, mingo@redhat.com
Cc:     x86@kernel.org, stable@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Vivek Goyal <vgoyal@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Date:   Thu, 21 May 2020 15:47:53 -0700
Message-ID: <159010127377.975921.9608345973272408430.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <159010126119.975921.6614194205409771984.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <159010126119.975921.6614194205409771984.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
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

Introduce copy_mc_generic() as the fast default implementation of
copy_mc_to_kernel() and finalize the transition of copy_mc_fragile() to
be a platform quirk to indicate 'fragility'. With this in place
copy_mc_to_kernel() is fast and recovery-ready by default regardless of
hardware capability.

Thanks to Vivek for identifying that copy_user_generic() is not suitable
as the copy_mc_to_user() backend since the #MC handler explicitly checks
ex_has_fault_handler().

Cc: x86@kernel.org
Cc: <stable@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Erwin Tsaur <erwin.tsaur@intel.com>
Tested-by: Erwin Tsaur <erwin.tsaur@intel.com>
Fixes: 92b0729c34ca ("x86/mm, x86/mce: Add memcpy_mcsafe()")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/uaccess.h |    3 +++
 arch/x86/lib/copy_mc.c         |   12 +++++-------
 arch/x86/lib/copy_mc_64.S      |   40 ++++++++++++++++++++++++++++++++++++++++
 tools/objtool/check.c          |    1 +
 4 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 6e856e180096..05cf0acd65d1 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -464,6 +464,9 @@ copy_mc_to_user(void *to, const void *from, unsigned len);
 
 unsigned long __must_check
 copy_mc_fragile(void *dst, const void *src, unsigned cnt);
+
+unsigned long __must_check
+copy_mc_generic(void *dst, const void *src, unsigned cnt);
 #else
 static inline void enable_copy_mc_fragile(void)
 {
diff --git a/arch/x86/lib/copy_mc.c b/arch/x86/lib/copy_mc.c
index cdb8f5dc403d..9e6fac1ab72e 100644
--- a/arch/x86/lib/copy_mc.c
+++ b/arch/x86/lib/copy_mc.c
@@ -23,7 +23,7 @@ void enable_copy_mc_fragile(void)
  *
  * Call into the 'fragile' version on systems that have trouble
  * actually do machine check recovery. Everyone else can just
- * use memcpy().
+ * use copy_mc_generic().
  *
  * Return 0 for success, or number of bytes not copied if there was an
  * exception.
@@ -33,8 +33,7 @@ copy_mc_to_kernel(void *dst, const void *src, unsigned cnt)
 {
 	if (static_branch_unlikely(&copy_mc_fragile_key))
 		return copy_mc_fragile(dst, src, cnt);
-	memcpy(dst, src, cnt);
-	return 0;
+	return copy_mc_generic(dst, src, cnt);
 }
 EXPORT_SYMBOL_GPL(copy_mc_to_kernel);
 
@@ -56,11 +55,10 @@ copy_mc_to_user(void *to, const void *from, unsigned len)
 {
 	unsigned long ret;
 
-	if (!static_branch_unlikely(&copy_mc_fragile_key))
-		return copy_user_generic(to, from, len);
-
 	__uaccess_begin();
-	ret = copy_mc_fragile(to, from, len);
+	if (static_branch_unlikely(&copy_mc_fragile_key))
+		ret = copy_mc_fragile(to, from, len);
+	ret = copy_mc_generic(to, from, len);
 	__uaccess_end();
 	return ret;
 }
diff --git a/arch/x86/lib/copy_mc_64.S b/arch/x86/lib/copy_mc_64.S
index 35a67c50890b..a08e7a4d9e28 100644
--- a/arch/x86/lib/copy_mc_64.S
+++ b/arch/x86/lib/copy_mc_64.S
@@ -2,7 +2,9 @@
 /* Copyright(c) 2016-2020 Intel Corporation. All rights reserved. */
 
 #include <linux/linkage.h>
+#include <asm/alternative-asm.h>
 #include <asm/copy_mc_test.h>
+#include <asm/cpufeatures.h>
 #include <asm/export.h>
 #include <asm/asm.h>
 
@@ -122,4 +124,42 @@ EXPORT_SYMBOL_GPL(copy_mc_fragile)
 	_ASM_EXTABLE(.L_write_leading_bytes, .E_leading_bytes)
 	_ASM_EXTABLE(.L_write_words, .E_write_words)
 	_ASM_EXTABLE(.L_write_trailing_bytes, .E_trailing_bytes)
+
+/*
+ * copy_mc_generic - memory copy with exception handling
+ *
+ * Fast string copy + fault / exception handling. If the CPU does
+ * support machine check exception recovery, but does not support
+ * recovering from fast-string exceptions then this CPU needs to be
+ * added to the copy_mc_fragile_key set of quirks. Otherwise, absent any
+ * machine check recovery support this version should be no slower than
+ * standard memcpy.
+ */
+SYM_FUNC_START(copy_mc_generic)
+	ALTERNATIVE "jmp copy_mc_fragile", "", X86_FEATURE_ERMS
+	movq %rdi, %rax
+	movq %rdx, %rcx
+.L_copy:
+	rep movsb
+	/* Copy successful. Return zero */
+	xorl %eax, %eax
+	ret
+SYM_FUNC_END(copy_mc_generic)
+EXPORT_SYMBOL_GPL(copy_mc_generic)
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
 #endif
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index b62235004f0b..449a36101385 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -546,6 +546,7 @@ static const char *uaccess_safe_builtin[] = {
 	"__ubsan_handle_shift_out_of_bounds",
 	/* misc */
 	"csum_partial_copy_generic",
+	"copy_mc_generic",
 	"copy_mc_fragile",
 	"copy_mc_fragile_handle_tail",
 	"ftrace_likely_update", /* CONFIG_TRACE_BRANCH_PROFILING */

