Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 235C11A49A9
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 20:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgDJSGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Apr 2020 14:06:04 -0400
Received: from mga03.intel.com ([134.134.136.65]:15610 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgDJSGD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Apr 2020 14:06:03 -0400
IronPort-SDR: HqkMkvk7yuneWxikFvPyssXvEnJVCu+koYWgXKY8gNERiC1FMwHPjSp7IODDPufaGh32aj8jD3
 TAQ04MwL4uEg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2020 11:06:03 -0700
IronPort-SDR: qyy5FFgT/5+KDj3JmCdr9hbkLalbeN2Eq0BgeJ/4+M/kZvAiWGCVQxcH1fiW1eNgbj9uV4Wawu
 ktjLjvSQLBDg==
X-IronPort-AV: E=Sophos;i="5.72,367,1580803200"; 
   d="scan'208";a="425962259"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2020 11:06:03 -0700
Subject: [PATCH] x86/memcpy: Introduce memcpy_mcsafe_fast
From:   Dan Williams <dan.j.williams@intel.com>
To:     tglx@linutronix.de, mingo@redhat.com
Cc:     x86@kernel.org, stable@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Date:   Fri, 10 Apr 2020 10:49:55 -0700
Message-ID: <158654083112.1572482.8944305411228188871.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The original memcpy_mcsafe() implementation satisfied two primary
concerns. It provided a copy routine that avoided known unrecoverable
scenarios (poison consumption via fast-string instructions / accesses
across cacheline boundaries), and it provided a fallback to fast plain
memcpy if the platform did not indicate recovery capability.

However, the platform indication for recovery capability is not
architectural so it was always going to require an ever growing list of
opt-in quirks. Also, ongoing hardware improvements to recoverability
mean that the cross-cacheline-boundary and fast-string poison
consumption scenarios are no longer concerns on newer platforms. The
introduction of memcpy_mcsafe_fast(), and resulting reworks, recovers
performance for these newer CPUs, but without the maintenance burden of
an opt-in whitelist.

With memcpy_mcsafe_fast() the existing opt-in becomes a blacklist for
CPUs that benefit from a more careful slower implementation. Every other
CPU gets a fast, but optionally recoverable implementation.

With this in place memcpy_mcsafe() never falls back to plain memcpy().
It can be used in any scenario where the caller needs guarantees that
source or destination access faults / exceptions will be handled.
Systems without recovery support continue to default to a fast
implementation while newer systems both default to fast, and support
recovery, without needing an explicit quirk.

Cc: x86@kernel.org
Cc: <stable@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Tony Luck <tony.luck@intel.com>
Reported-by: Erwin Tsaur <erwin.tsaur@intel.com>
Tested-by: Erwin Tsaur <erwin.tsaur@intel.com>
Fixes: 92b0729c34ca ("x86/mm, x86/mce: Add memcpy_mcsafe()")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Note that I marked this for stable and included a Fixes tag because it
is arguably a regression that old kernels stop recovering from poison
consumption on new hardware.

 arch/x86/include/asm/string_64.h         |   24 ++++++-------
 arch/x86/include/asm/uaccess_64.h        |    7 +---
 arch/x86/kernel/cpu/mce/core.c           |    6 ++-
 arch/x86/kernel/quirks.c                 |    4 +-
 arch/x86/lib/memcpy_64.S                 |   57 +++++++++++++++++++++++++++---
 arch/x86/lib/usercopy_64.c               |    6 +--
 tools/objtool/check.c                    |    3 +-
 tools/perf/bench/mem-memcpy-x86-64-lib.c |    8 +---
 tools/testing/nvdimm/test/nfit.c         |    2 +
 9 files changed, 75 insertions(+), 42 deletions(-)

diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index 75314c3dbe47..07840fa3582a 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -83,21 +83,23 @@ int strcmp(const char *cs, const char *ct);
 #endif
 
 #define __HAVE_ARCH_MEMCPY_MCSAFE 1
-__must_check unsigned long __memcpy_mcsafe(void *dst, const void *src,
+__must_check unsigned long memcpy_mcsafe_slow(void *dst, const void *src,
 		size_t cnt);
-DECLARE_STATIC_KEY_FALSE(mcsafe_key);
+__must_check unsigned long memcpy_mcsafe_fast(void *dst, const void *src,
+		size_t cnt);
+DECLARE_STATIC_KEY_FALSE(mcsafe_slow_key);
 
 /**
- * memcpy_mcsafe - copy memory with indication if a machine check happened
+ * memcpy_mcsafe - copy memory with indication if an exception / fault happened
  *
  * @dst:	destination address
  * @src:	source address
  * @cnt:	number of bytes to copy
  *
- * Low level memory copy function that catches machine checks
- * We only call into the "safe" function on systems that can
- * actually do machine check recovery. Everyone else can just
- * use memcpy().
+ * The slow version is opted into by platform quirks. The fast version
+ * is equivalent to memcpy() regardless of CPU machine-check-recovery
+ * capability, but may still fall back to the slow version if the CPU
+ * lacks fast-string instruction support.
  *
  * Return 0 for success, or number of bytes not copied if there was an
  * exception.
@@ -106,12 +108,10 @@ static __always_inline __must_check unsigned long
 memcpy_mcsafe(void *dst, const void *src, size_t cnt)
 {
 #ifdef CONFIG_X86_MCE
-	if (static_branch_unlikely(&mcsafe_key))
-		return __memcpy_mcsafe(dst, src, cnt);
-	else
+	if (static_branch_unlikely(&mcsafe_slow_key))
+		return memcpy_mcsafe_slow(dst, src, cnt);
 #endif
-		memcpy(dst, src, cnt);
-	return 0;
+	return memcpy_mcsafe_fast(dst, src, cnt);
 }
 
 #ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 5cd1caa8bc65..f8c0d38c3f45 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -52,12 +52,7 @@ copy_to_user_mcsafe(void *to, const void *from, unsigned len)
 	unsigned long ret;
 
 	__uaccess_begin();
-	/*
-	 * Note, __memcpy_mcsafe() is explicitly used since it can
-	 * handle exceptions / faults.  memcpy_mcsafe() may fall back to
-	 * memcpy() which lacks this handling.
-	 */
-	ret = __memcpy_mcsafe(to, from, len);
+	ret = memcpy_mcsafe(to, from, len);
 	__uaccess_end();
 	return ret;
 }
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 2c4f949611e4..6bf94d39dc7f 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -2579,13 +2579,13 @@ static void __init mcheck_debugfs_init(void)
 static void __init mcheck_debugfs_init(void) { }
 #endif
 
-DEFINE_STATIC_KEY_FALSE(mcsafe_key);
-EXPORT_SYMBOL_GPL(mcsafe_key);
+DEFINE_STATIC_KEY_FALSE(mcsafe_slow_key);
+EXPORT_SYMBOL_GPL(mcsafe_slow_key);
 
 static int __init mcheck_late_init(void)
 {
 	if (mca_cfg.recovery)
-		static_branch_inc(&mcsafe_key);
+		static_branch_inc(&mcsafe_slow_key);
 
 	mcheck_debugfs_init();
 	cec_init();
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 896d74cb5081..89c88d9de5c4 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -636,7 +636,7 @@ static void quirk_intel_brickland_xeon_ras_cap(struct pci_dev *pdev)
 	pci_read_config_dword(pdev, 0x84, &capid0);
 
 	if (capid0 & 0x10)
-		static_branch_inc(&mcsafe_key);
+		static_branch_inc(&mcsafe_slow_key);
 }
 
 /* Skylake */
@@ -653,7 +653,7 @@ static void quirk_intel_purley_xeon_ras_cap(struct pci_dev *pdev)
 	 * enabled, so memory machine check recovery is also enabled.
 	 */
 	if ((capid0 & 0xc0) == 0xc0 || (capid5 & 0x1e0))
-		static_branch_inc(&mcsafe_key);
+		static_branch_inc(&mcsafe_slow_key);
 
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x0ec3, quirk_intel_brickland_xeon_ras_cap);
diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 56b243b14c3a..b5e4fc1cf99d 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -189,11 +189,18 @@ SYM_FUNC_END(memcpy_orig)
 MCSAFE_TEST_CTL
 
 /*
- * __memcpy_mcsafe - memory copy with machine check exception handling
- * Note that we only catch machine checks when reading the source addresses.
- * Writes to target are posted and don't generate machine checks.
+ * memcpy_mcsafe_slow() - memory copy with exception handling
+ *
+ * In contrast to memcpy_mcsafe_fast() this version is careful to
+ * never perform a read across a cacheline boundary, and not use
+ * fast-string instruction sequences which are known to be unrecoverable
+ * on CPUs identified by mcsafe_slow_key.
+ *
+ * Note that this only catches machine check exceptions when reading the
+ * source addresses.  Writes to target are posted and don't generate
+ * machine checks. However this does handle protection faults on writes.
  */
-SYM_FUNC_START(__memcpy_mcsafe)
+SYM_FUNC_START(memcpy_mcsafe_slow)
 	cmpl $8, %edx
 	/* Less than 8 bytes? Go to byte copy loop */
 	jb .L_no_whole_words
@@ -260,8 +267,8 @@ SYM_FUNC_START(__memcpy_mcsafe)
 	xorl %eax, %eax
 .L_done:
 	ret
-SYM_FUNC_END(__memcpy_mcsafe)
-EXPORT_SYMBOL_GPL(__memcpy_mcsafe)
+SYM_FUNC_END(memcpy_mcsafe_slow)
+EXPORT_SYMBOL_GPL(memcpy_mcsafe_slow)
 
 	.section .fixup, "ax"
 	/*
@@ -296,4 +303,42 @@ EXPORT_SYMBOL_GPL(__memcpy_mcsafe)
 	_ASM_EXTABLE(.L_write_leading_bytes, .E_leading_bytes)
 	_ASM_EXTABLE(.L_write_words, .E_write_words)
 	_ASM_EXTABLE(.L_write_trailing_bytes, .E_trailing_bytes)
+
+/*
+ * memcpy_mcsafe_fast - memory copy with exception handling
+ *
+ * Fast string copy + exception handling. If the CPU does support
+ * machine check exception recovery, but does not support recovering
+ * from fast-string exceptions then this CPU needs to be added to the
+ * mcsafe_slow_key set of quirks. Otherwise, absent any machine check
+ * recovery support this version should be no slower than standard
+ * memcpy.
+ */
+SYM_FUNC_START(memcpy_mcsafe_fast)
+	ALTERNATIVE "jmp memcpy_mcsafe_slow", "", X86_FEATURE_ERMS
+	movq %rdi, %rax
+	movq %rdx, %rcx
+.L_copy:
+	rep movsb
+	/* Copy successful. Return zero */
+	xorl %eax, %eax
+	ret
+SYM_FUNC_END(memcpy_mcsafe_fast)
+EXPORT_SYMBOL_GPL(memcpy_mcsafe_fast)
+
+	.section .fixup, "ax"
+.E_copy:
+	/*
+	 * On fault %rcx is updated such that the copy instruction could
+	 * optionally be restarted at the fault position, i.e. it
+	 * contains 'bytes remaining'. A non-zero return indicates error
+	 * to memcpy_mcsafe() users, or indicate short transfers to
+	 * user-copy routines.
+	 */
+	movq %rcx, %rax
+	ret
+
+	.previous
+
+	_ASM_EXTABLE_FAULT(.L_copy, .E_copy)
 #endif
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index fff28c6f73a2..348c9331748e 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -64,11 +64,7 @@ __visible notrace unsigned long
 mcsafe_handle_tail(char *to, char *from, unsigned len)
 {
 	for (; len; --len, to++, from++) {
-		/*
-		 * Call the assembly routine back directly since
-		 * memcpy_mcsafe() may silently fallback to memcpy.
-		 */
-		unsigned long rem = __memcpy_mcsafe(to, from, 1);
+		unsigned long rem = memcpy_mcsafe(to, from, 1);
 
 		if (rem)
 			break;
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 4768d91c6d68..bae1f77aae90 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -485,7 +485,8 @@ static const char *uaccess_safe_builtin[] = {
 	"__ubsan_handle_shift_out_of_bounds",
 	/* misc */
 	"csum_partial_copy_generic",
-	"__memcpy_mcsafe",
+	"memcpy_mcsafe_slow",
+	"memcpy_mcsafe_fast",
 	"mcsafe_handle_tail",
 	"ftrace_likely_update", /* CONFIG_TRACE_BRANCH_PROFILING */
 	NULL
diff --git a/tools/perf/bench/mem-memcpy-x86-64-lib.c b/tools/perf/bench/mem-memcpy-x86-64-lib.c
index 4130734dde84..23e1747b3a67 100644
--- a/tools/perf/bench/mem-memcpy-x86-64-lib.c
+++ b/tools/perf/bench/mem-memcpy-x86-64-lib.c
@@ -5,17 +5,13 @@
  */
 #include <linux/types.h>
 
-unsigned long __memcpy_mcsafe(void *dst, const void *src, size_t cnt);
+unsigned long memcpy_mcsafe(void *dst, const void *src, size_t cnt);
 unsigned long mcsafe_handle_tail(char *to, char *from, unsigned len);
 
 unsigned long mcsafe_handle_tail(char *to, char *from, unsigned len)
 {
 	for (; len; --len, to++, from++) {
-		/*
-		 * Call the assembly routine back directly since
-		 * memcpy_mcsafe() may silently fallback to memcpy.
-		 */
-		unsigned long rem = __memcpy_mcsafe(to, from, 1);
+		unsigned long rem = memcpy_mcsafe(to, from, 1);
 
 		if (rem)
 			break;
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index bf6422a6af7f..282722d96f8e 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -3136,7 +3136,7 @@ void mcsafe_test(void)
 			}
 
 			mcsafe_test_init(dst, src, 512);
-			rem = __memcpy_mcsafe(dst, src, 512);
+			rem = memcpy_mcsafe_slow(dst, src, 512);
 			valid = mcsafe_test_validate(dst, src, 512, expect);
 			if (rem == expect && valid)
 				continue;

