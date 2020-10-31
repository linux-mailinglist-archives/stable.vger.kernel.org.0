Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2340B2A1624
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbgJaLmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:42:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727086AbgJaLmQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:42:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53D69205F4;
        Sat, 31 Oct 2020 11:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144535;
        bh=nw28/nv4RREXmCNiONjPEjIKWC5A66d799+PkDq2d94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nr2uS8D3tkNGJUgYu3hG3c0Lzm9D95x4oSnBQyJJ0DfJLgqy33NuD2b1vmBMzBO24
         EDpicA2XT8w8g7xByq0HWsH7xSbqZs2S5++Pw31rWCMmLRTm/BVhXUcDafMERSYO6y
         7CDbr8b6CqKmprJciIqYhsMZdNSeKpdfx9cu+zBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwin Tsaur <erwin.tsaur@intel.com>,
        0day robot <lkp@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 5.8 25/70] x86/copy_mc: Introduce copy_mc_enhanced_fast_string()
Date:   Sat, 31 Oct 2020 12:35:57 +0100
Message-Id: <20201031113500.710656518@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

commit 5da8e4a658109e3b7e1f45ae672b7c06ac3e7158 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/lib/copy_mc.c    |   32 +++++++++++++++++++++++---------
 arch/x86/lib/copy_mc_64.S |   36 ++++++++++++++++++++++++++++++++++++
 tools/objtool/check.c     |    1 +
 3 files changed, 60 insertions(+), 9 deletions(-)

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
@@ -63,6 +67,8 @@ unsigned long __must_check copy_mc_to_ke
 {
 	if (copy_mc_fragile_enabled)
 		return copy_mc_fragile(dst, src, len);
+	if (static_cpu_has(X86_FEATURE_ERMS))
+		return copy_mc_enhanced_fast_string(dst, src, len);
 	memcpy(dst, src, len);
 	return 0;
 }
@@ -72,11 +78,19 @@ unsigned long __must_check copy_mc_to_us
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
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -550,6 +550,7 @@ static const char *uaccess_safe_builtin[
 	"csum_partial_copy_generic",
 	"copy_mc_fragile",
 	"copy_mc_fragile_handle_tail",
+	"copy_mc_enhanced_fast_string",
 	"ftrace_likely_update", /* CONFIG_TRACE_BRANCH_PROFILING */
 	NULL
 };


