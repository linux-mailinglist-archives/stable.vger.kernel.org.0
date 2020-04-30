Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0331BF31D
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 10:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgD3IlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 04:41:25 -0400
Received: from mga04.intel.com ([192.55.52.120]:54455 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbgD3IlT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 04:41:19 -0400
IronPort-SDR: hb36l5Z+cGYv9PL+GRSimDGOfbp1kaVW9I8FoxizZIf1NtmrDD1M5XTpirfGI2YbS6PPE9UCUH
 7ZgiMacguH5g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2020 01:41:19 -0700
IronPort-SDR: 9Q009KJtDX0U5mEh/Vb1gvGvryyqyuUiHJvnd4ywchno/7wp/uzjgf0gq2h1ROcgWMyeOHi73B
 NA/EaQp265Rw==
X-IronPort-AV: E=Sophos;i="5.73,334,1583222400"; 
   d="scan'208";a="282790726"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2020 01:41:18 -0700
Subject: [PATCH v2 2/2] x86/copy_safe: Introduce copy_safe_fast()
From:   Dan Williams <dan.j.williams@intel.com>
To:     tglx@linutronix.de, mingo@redhat.com
Cc:     x86@kernel.org, stable@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Erwin Tsaur <erwin.tsaur@intel.com>, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 30 Apr 2020 01:25:09 -0700
Message-ID: <158823510897.2094061.8955960257425244970.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <158823509800.2094061.9683997333958344535.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <158823509800.2094061.9683997333958344535.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The existing copy_safe() implementation satisfies two primary concerns.
It provides a copy routine that avoids known unrecoverable scenarios
(poison consumption via fast-string instructions / accesses across
cacheline boundaries), and it provides a fallback to fast plain memcpy
if the platform does not indicate recovery capability. The fallback is
broken for two reasons. It fails the expected copy_safe() semantics that
allow it to be used in scenarios where reads / writes trigger memory
protection faults and it fails to enable machine check recovery on
systems that do not need the careful semantics of copy_safe_slow().

With copy_safe_fast() in place copy_safe() never falls back to plain
memcpy(), and it is fast regardless in every other scenario outside of
the copy_safe_slow() blacklist scenario.

Cc: x86@kernel.org
Cc: <stable@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Erwin Tsaur <erwin.tsaur@intel.com>
Tested-by: Erwin Tsaur <erwin.tsaur@intel.com>
Fixes: 92b0729c34ca ("x86/mm, x86/mce: Add memcpy_mcsafe()")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/copy_safe.h |    2 ++
 arch/x86/lib/copy_safe.c         |    5 ++---
 arch/x86/lib/copy_safe_64.S      |   40 ++++++++++++++++++++++++++++++++++++++
 tools/objtool/check.c            |    1 +
 4 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/copy_safe.h b/arch/x86/include/asm/copy_safe.h
index 1c130364dd61..306248ca819f 100644
--- a/arch/x86/include/asm/copy_safe.h
+++ b/arch/x86/include/asm/copy_safe.h
@@ -12,5 +12,7 @@ static inline void enable_copy_safe_slow(void)
 
 __must_check unsigned long
 copy_safe_slow(void *dst, const void *src, size_t cnt);
+__must_check unsigned long
+copy_safe_fast(void *dst, const void *src, size_t cnt);
 
 #endif /* _COPY_SAFE_H_ */
diff --git a/arch/x86/lib/copy_safe.c b/arch/x86/lib/copy_safe.c
index 9dd3a831ff94..b8472e6a44d3 100644
--- a/arch/x86/lib/copy_safe.c
+++ b/arch/x86/lib/copy_safe.c
@@ -25,7 +25,7 @@ void enable_copy_safe_slow(void)
  *
  * We only call into the slow version on systems that have trouble
  * actually do machine check recovery. Everyone else can just
- * use memcpy().
+ * use copy_safe_fast().
  *
  * Return 0 for success, or number of bytes not copied if there was an
  * exception.
@@ -34,8 +34,7 @@ __must_check unsigned long copy_safe(void *dst, const void *src, size_t cnt)
 {
 	if (static_branch_unlikely(&copy_safe_slow_key))
 		return copy_safe_slow(dst, src, cnt);
-	memcpy(dst, src, cnt);
-	return 0;
+	return copy_safe_fast(dst, src, cnt);
 }
 EXPORT_SYMBOL_GPL(copy_safe);
 
diff --git a/arch/x86/lib/copy_safe_64.S b/arch/x86/lib/copy_safe_64.S
index 46dfdd832bde..551c781ae9fd 100644
--- a/arch/x86/lib/copy_safe_64.S
+++ b/arch/x86/lib/copy_safe_64.S
@@ -2,7 +2,9 @@
 /* Copyright(c) 2016-2020 Intel Corporation. All rights reserved. */
 
 #include <linux/linkage.h>
+#include <asm/alternative-asm.h>
 #include <asm/copy_safe_test.h>
+#include <asm/cpufeatures.h>
 #include <asm/export.h>
 #include <asm/asm.h>
 
@@ -120,4 +122,42 @@ EXPORT_SYMBOL_GPL(copy_safe_slow)
 	_ASM_EXTABLE(.L_write_leading_bytes, .E_leading_bytes)
 	_ASM_EXTABLE(.L_write_words, .E_write_words)
 	_ASM_EXTABLE(.L_write_trailing_bytes, .E_trailing_bytes)
+
+/*
+ * copy_safe_fast - memory copy with exception handling
+ *
+ * Fast string copy + fault / exception handling. If the CPU does
+ * support machine check exception recovery, but does not support
+ * recovering from fast-string exceptions then this CPU needs to be
+ * added to the copy_safe_slow_key set of quirks. Otherwise, absent any
+ * machine check recovery support this version should be no slower than
+ * standard memcpy.
+ */
+SYM_FUNC_START(copy_safe_fast)
+	ALTERNATIVE "jmp copy_safe_slow", "", X86_FEATURE_ERMS
+	movq %rdi, %rax
+	movq %rdx, %rcx
+.L_copy:
+	rep movsb
+	/* Copy successful. Return zero */
+	xorl %eax, %eax
+	ret
+SYM_FUNC_END(copy_safe_fast)
+EXPORT_SYMBOL_GPL(copy_safe_fast)
+
+	.section .fixup, "ax"
+.E_copy:
+	/*
+	 * On fault %rcx is updated such that the copy instruction could
+	 * optionally be restarted at the fault position, i.e. it
+	 * contains 'bytes remaining'. A non-zero return indicates error
+	 * to copy_safe() users, or indicate short transfers to
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
index be20eff8f358..e8b6e2438d31 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -533,6 +533,7 @@ static const char *uaccess_safe_builtin[] = {
 	"__ubsan_handle_shift_out_of_bounds",
 	/* misc */
 	"csum_partial_copy_generic",
+	"copy_safe_fast",
 	"copy_safe_slow",
 	"copy_safe_slow_handle_tail",
 	"ftrace_likely_update", /* CONFIG_TRACE_BRANCH_PROFILING */

