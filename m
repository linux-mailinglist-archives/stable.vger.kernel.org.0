Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91B41BF31B
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 10:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgD3IlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 04:41:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:48108 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726842AbgD3IlS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 04:41:18 -0400
IronPort-SDR: 6O7VYp0qsZdxNi5lPNy/AyvASchQ8ylZSrhVhDP00aZwgaQ4qeOtaeCKLR04TEqrEhAOVKy90K
 AU7Zjuat1VKQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2020 01:41:13 -0700
IronPort-SDR: wGbYF17ypPu+8e97es3XMqxcr0qI9szz/vg/YSe7lud5XW2r8mSrX9yqMW7c+KdhO+Q2ksTW2z
 669rRNGkjfAQ==
X-IronPort-AV: E=Sophos;i="5.73,334,1583222400"; 
   d="scan'208";a="459496211"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2020 01:41:13 -0700
Subject: [PATCH v2 1/2] copy_safe: Rename memcpy_mcsafe() to copy_safe()
From:   Dan Williams <dan.j.williams@intel.com>
To:     tglx@linutronix.de, mingo@redhat.com
Cc:     x86@kernel.org, stable@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
Date:   Thu, 30 Apr 2020 01:25:03 -0700
Message-ID: <158823510324.2094061.12032081359821152024.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The scope of memcpy_mcsafe() changed in commit 12c89130a56a
("x86/asm/memcpy_mcsafe: Add write-protection-fault handling") where it
was no longer a facility focused on x86-machine-check exceptions, but a
generic copy routine that handles any hardware fault, trap, or
exception by aborting and reporting 'bytes successfully transferred'.

Now, the rename is motivated by this exchange with Linus and allows for
additional cleanups that further disconnect a "copy_safe()" facility
from the original x86-machine-check handling focused implementation:

    > The writes can mmu-fault now that memcpy_mcsafe() is also used by
    > _copy_to_iter_mcsafe(). This allows a clean bypass of the block layer
    > in fs/dax.c in addition to the pmem driver access of poisoned memory.
    > Now that the fallback is a sane rep; movs; it can be considered for
    > plain copy_to_iter() for other user copies so you get exception
    > handling on kernel access of poison outside of persistent memory. To
    > Andy's point I think a recoverable copy (for exceptions or faults) is
    > generally useful.

    I think that's completely independent.

    If we have good reasons for having targets with exception handling,
    then that has absolutely nothing to do with machine checks or buggy
    hardware.

    And it sure shouldn't be called "mcsafe", since it has nothing to do
    with that situation any more.

Note that the changes are purely a rename / code reorganization plus
changing the polarity of mcsafe_slow_key from an opt-in to a blacklist
in preparation for a future patch that introduces a common
x86::copy_safe_fast() that is independent of platform
machine-check-recovery capability.  Otherwise, the current awkward
situation of copy_safe() sometimes falling back to memcpy() (even on
CONFIG_ARCH_HAS_COPY_SAFE=y x86) is maintained for now until it can be
replaced with the new implementation that is always instrumented to handle
the abort case.

One side-effect of this reorganization is that separating copy_safe_64.S
to its own file means that perf no longer needs to track dependencies
for its memcpy_64.S benchmarks.

Cc: x86@kernel.org
Cc: <stable@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lore.kernel.org/r/CAHk-=wjSqtXAqfUJxFtWNwmguFASTgB0dz1dT3V-78Quiezqbg@mail.gmail.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/powerpc/Kconfig                               |    2 
 arch/powerpc/include/asm/string.h                  |    2 
 arch/powerpc/include/asm/uaccess.h                 |    4 -
 arch/powerpc/lib/Makefile                          |    2 
 arch/powerpc/lib/copy_safe.S                       |    4 -
 arch/x86/Kconfig                                   |    2 
 arch/x86/Kconfig.debug                             |    2 
 arch/x86/include/asm/copy_safe.h                   |   16 +++
 arch/x86/include/asm/copy_safe_test.h              |   75 ++++++++++++
 arch/x86/include/asm/mcsafe_test.h                 |   75 ------------
 arch/x86/include/asm/string_64.h                   |   32 -----
 arch/x86/include/asm/uaccess_64.h                  |   21 ---
 arch/x86/kernel/cpu/mce/core.c                     |    9 -
 arch/x86/kernel/quirks.c                           |   10 --
 arch/x86/lib/Makefile                              |    1 
 arch/x86/lib/copy_safe.c                           |   67 +++++++++++
 arch/x86/lib/copy_safe_64.S                        |  123 ++++++++++++++++++++
 arch/x86/lib/memcpy_64.S                           |  115 -------------------
 arch/x86/lib/usercopy_64.c                         |   21 ---
 drivers/md/dm-writecache.c                         |   12 +-
 drivers/nvdimm/claim.c                             |    2 
 drivers/nvdimm/pmem.c                              |    6 -
 include/linux/string.h                             |   17 ++-
 include/linux/uio.h                                |   10 +-
 lib/Kconfig                                        |    2 
 lib/iov_iter.c                                     |   36 +++---
 tools/arch/x86/include/asm/copy_safe_test.h        |   13 ++
 tools/arch/x86/include/asm/mcsafe_test.h           |   13 --
 tools/arch/x86/lib/memcpy_64.S                     |  115 -------------------
 tools/objtool/check.c                              |    4 -
 tools/perf/bench/Build                             |    1 
 tools/perf/bench/mem-memcpy-x86-64-lib.c           |   24 ----
 tools/testing/nvdimm/test/nfit.c                   |   49 ++++----
 .../testing/selftests/powerpc/copyloops/.gitignore |    2 
 tools/testing/selftests/powerpc/copyloops/Makefile |    6 -
 .../selftests/powerpc/copyloops/copy_safe.S        |    0 
 36 files changed, 387 insertions(+), 508 deletions(-)
 rename arch/powerpc/lib/{memcpy_mcsafe_64.S => copy_safe.S} (98%)
 create mode 100644 arch/x86/include/asm/copy_safe.h
 create mode 100644 arch/x86/include/asm/copy_safe_test.h
 delete mode 100644 arch/x86/include/asm/mcsafe_test.h
 create mode 100644 arch/x86/lib/copy_safe.c
 create mode 100644 arch/x86/lib/copy_safe_64.S
 create mode 100644 tools/arch/x86/include/asm/copy_safe_test.h
 delete mode 100644 tools/arch/x86/include/asm/mcsafe_test.h
 delete mode 100644 tools/perf/bench/mem-memcpy-x86-64-lib.c
 rename tools/testing/selftests/powerpc/copyloops/{memcpy_mcsafe_64.S => copy_safe.S} (100%)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 924c541a9260..ba4e7ff02d09 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -133,7 +133,7 @@ config PPC
 	select ARCH_HAS_STRICT_KERNEL_RWX	if ((PPC_BOOK3S_64 || PPC32) && !HIBERNATION)
 	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UACCESS_FLUSHCACHE
-	select ARCH_HAS_UACCESS_MCSAFE		if PPC64
+	select ARCH_HAS_COPY_SAFE		if PPC64
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_KEEP_MEMBLOCK
diff --git a/arch/powerpc/include/asm/string.h b/arch/powerpc/include/asm/string.h
index b72692702f35..9bf6dffb4090 100644
--- a/arch/powerpc/include/asm/string.h
+++ b/arch/powerpc/include/asm/string.h
@@ -53,9 +53,7 @@ void *__memmove(void *to, const void *from, __kernel_size_t n);
 #ifndef CONFIG_KASAN
 #define __HAVE_ARCH_MEMSET32
 #define __HAVE_ARCH_MEMSET64
-#define __HAVE_ARCH_MEMCPY_MCSAFE
 
-extern int memcpy_mcsafe(void *dst, const void *src, __kernel_size_t sz);
 extern void *__memset16(uint16_t *, uint16_t v, __kernel_size_t);
 extern void *__memset32(uint32_t *, uint32_t v, __kernel_size_t);
 extern void *__memset64(uint64_t *, uint64_t v, __kernel_size_t);
diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index 2f500debae21..0abca701fe38 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -416,12 +416,12 @@ raw_copy_to_user(void __user *to, const void *from, unsigned long n)
 }
 
 static __always_inline unsigned long __must_check
-copy_to_user_mcsafe(void __user *to, const void *from, unsigned long n)
+copy_to_user_safe(void __user *to, const void *from, unsigned long n)
 {
 	if (likely(check_copy_size(from, n, true))) {
 		if (access_ok(to, n)) {
 			allow_write_to_user(to, n);
-			n = memcpy_mcsafe((void *)to, from, n);
+			n = copy_safe((void *)to, from, n);
 			prevent_write_to_user(to, n);
 		}
 	}
diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index b8de3be10eb4..40a72a19d317 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -39,7 +39,7 @@ obj-$(CONFIG_PPC_BOOK3S_64) += copyuser_power7.o copypage_power7.o \
 			       memcpy_power7.o
 
 obj64-y	+= copypage_64.o copyuser_64.o mem_64.o hweight_64.o \
-	   memcpy_64.o memcpy_mcsafe_64.o
+	   memcpy_64.o copy_safe.o
 
 obj64-$(CONFIG_SMP)	+= locks.o
 obj64-$(CONFIG_ALTIVEC)	+= vmx-helper.o
diff --git a/arch/powerpc/lib/memcpy_mcsafe_64.S b/arch/powerpc/lib/copy_safe.S
similarity index 98%
rename from arch/powerpc/lib/memcpy_mcsafe_64.S
rename to arch/powerpc/lib/copy_safe.S
index cb882d9a6d8a..c0aef739531e 100644
--- a/arch/powerpc/lib/memcpy_mcsafe_64.S
+++ b/arch/powerpc/lib/copy_safe.S
@@ -50,7 +50,7 @@ err3;	stb	r0,0(r3)
 	blr
 
 
-_GLOBAL(memcpy_mcsafe)
+_GLOBAL(copy_safe)
 	mr	r7,r5
 	cmpldi	r5,16
 	blt	.Lshort_copy
@@ -239,4 +239,4 @@ err1;	stb	r0,0(r3)
 15:	li	r3,0
 	blr
 
-EXPORT_SYMBOL_GPL(memcpy_mcsafe);
+EXPORT_SYMBOL_GPL(copy_safe);
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c017c97a9c8e..2ac55243dc24 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -72,7 +72,7 @@ config X86
 	select ARCH_HAS_PTE_DEVMAP		if X86_64
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_UACCESS_FLUSHCACHE	if X86_64
-	select ARCH_HAS_UACCESS_MCSAFE		if X86_64 && X86_MCE
+	select ARCH_HAS_COPY_SAFE		if X86_64
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_SET_DIRECT_MAP
 	select ARCH_HAS_STRICT_KERNEL_RWX
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index f909d3ce36e6..fa83915ccd15 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -59,7 +59,7 @@ config EARLY_PRINTK_USB_XDBC
 	  You should normally say N here, unless you want to debug early
 	  crashes or need a very simple printk logging facility.
 
-config MCSAFE_TEST
+config COPY_SAFE_TEST
 	def_bool n
 
 config EFI_PGT_DUMP
diff --git a/arch/x86/include/asm/copy_safe.h b/arch/x86/include/asm/copy_safe.h
new file mode 100644
index 000000000000..1c130364dd61
--- /dev/null
+++ b/arch/x86/include/asm/copy_safe.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _COPY_SAFE_H_
+#define _COPY_SAFE_H_
+
+#ifdef CONFIG_ARCH_HAS_COPY_SAFE
+void enable_copy_safe_slow(void);
+#else
+static inline void enable_copy_safe_slow(void)
+{
+}
+#endif
+
+__must_check unsigned long
+copy_safe_slow(void *dst, const void *src, size_t cnt);
+
+#endif /* _COPY_SAFE_H_ */
diff --git a/arch/x86/include/asm/copy_safe_test.h b/arch/x86/include/asm/copy_safe_test.h
new file mode 100644
index 000000000000..6f81b1e5d3e8
--- /dev/null
+++ b/arch/x86/include/asm/copy_safe_test.h
@@ -0,0 +1,75 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _COPY_SAFE_TEST_H_
+#define _COPY_SAFE_TEST_H_
+
+#ifndef __ASSEMBLY__
+#ifdef CONFIG_COPY_SAFE_TEST
+extern unsigned long copy_safe_test_src;
+extern unsigned long copy_safe_test_dst;
+
+static inline void copy_safe_inject_src(void *addr)
+{
+	if (addr)
+		copy_safe_test_src = (unsigned long) addr;
+	else
+		copy_safe_test_src = ~0UL;
+}
+
+static inline void copy_safe_inject_dst(void *addr)
+{
+	if (addr)
+		copy_safe_test_dst = (unsigned long) addr;
+	else
+		copy_safe_test_dst = ~0UL;
+}
+#else /* CONFIG_COPY_SAFE_TEST */
+static inline void copy_safe_inject_src(void *addr)
+{
+}
+
+static inline void copy_safe_inject_dst(void *addr)
+{
+}
+#endif /* CONFIG_COPY_SAFE_TEST */
+
+#else /* __ASSEMBLY__ */
+#include <asm/export.h>
+
+#ifdef CONFIG_COPY_SAFE_TEST
+.macro COPY_SAFE_TEST_CTL
+	.pushsection .data
+	.align 8
+	.globl copy_safe_test_src
+	copy_safe_test_src:
+		.quad 0
+	EXPORT_SYMBOL_GPL(copy_safe_test_src)
+	.globl copy_safe_test_dst
+	copy_safe_test_dst:
+		.quad 0
+	EXPORT_SYMBOL_GPL(copy_safe_test_dst)
+	.popsection
+.endm
+
+.macro COPY_SAFE_TEST_SRC reg count target
+	leaq \count(\reg), %r9
+	cmp copy_safe_test_src, %r9
+	ja \target
+.endm
+
+.macro COPY_SAFE_TEST_DST reg count target
+	leaq \count(\reg), %r9
+	cmp copy_safe_test_dst, %r9
+	ja \target
+.endm
+#else
+.macro COPY_SAFE_TEST_CTL
+.endm
+
+.macro COPY_SAFE_TEST_SRC reg count target
+.endm
+
+.macro COPY_SAFE_TEST_DST reg count target
+.endm
+#endif /* CONFIG_COPY_SAFE_TEST */
+#endif /* __ASSEMBLY__ */
+#endif /* _COPY_SAFE_TEST_H_ */
diff --git a/arch/x86/include/asm/mcsafe_test.h b/arch/x86/include/asm/mcsafe_test.h
deleted file mode 100644
index eb59804b6201..000000000000
--- a/arch/x86/include/asm/mcsafe_test.h
+++ /dev/null
@@ -1,75 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _MCSAFE_TEST_H_
-#define _MCSAFE_TEST_H_
-
-#ifndef __ASSEMBLY__
-#ifdef CONFIG_MCSAFE_TEST
-extern unsigned long mcsafe_test_src;
-extern unsigned long mcsafe_test_dst;
-
-static inline void mcsafe_inject_src(void *addr)
-{
-	if (addr)
-		mcsafe_test_src = (unsigned long) addr;
-	else
-		mcsafe_test_src = ~0UL;
-}
-
-static inline void mcsafe_inject_dst(void *addr)
-{
-	if (addr)
-		mcsafe_test_dst = (unsigned long) addr;
-	else
-		mcsafe_test_dst = ~0UL;
-}
-#else /* CONFIG_MCSAFE_TEST */
-static inline void mcsafe_inject_src(void *addr)
-{
-}
-
-static inline void mcsafe_inject_dst(void *addr)
-{
-}
-#endif /* CONFIG_MCSAFE_TEST */
-
-#else /* __ASSEMBLY__ */
-#include <asm/export.h>
-
-#ifdef CONFIG_MCSAFE_TEST
-.macro MCSAFE_TEST_CTL
-	.pushsection .data
-	.align 8
-	.globl mcsafe_test_src
-	mcsafe_test_src:
-		.quad 0
-	EXPORT_SYMBOL_GPL(mcsafe_test_src)
-	.globl mcsafe_test_dst
-	mcsafe_test_dst:
-		.quad 0
-	EXPORT_SYMBOL_GPL(mcsafe_test_dst)
-	.popsection
-.endm
-
-.macro MCSAFE_TEST_SRC reg count target
-	leaq \count(\reg), %r9
-	cmp mcsafe_test_src, %r9
-	ja \target
-.endm
-
-.macro MCSAFE_TEST_DST reg count target
-	leaq \count(\reg), %r9
-	cmp mcsafe_test_dst, %r9
-	ja \target
-.endm
-#else
-.macro MCSAFE_TEST_CTL
-.endm
-
-.macro MCSAFE_TEST_SRC reg count target
-.endm
-
-.macro MCSAFE_TEST_DST reg count target
-.endm
-#endif /* CONFIG_MCSAFE_TEST */
-#endif /* __ASSEMBLY__ */
-#endif /* _MCSAFE_TEST_H_ */
diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index 75314c3dbe47..6e450827f677 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -82,38 +82,6 @@ int strcmp(const char *cs, const char *ct);
 
 #endif
 
-#define __HAVE_ARCH_MEMCPY_MCSAFE 1
-__must_check unsigned long __memcpy_mcsafe(void *dst, const void *src,
-		size_t cnt);
-DECLARE_STATIC_KEY_FALSE(mcsafe_key);
-
-/**
- * memcpy_mcsafe - copy memory with indication if a machine check happened
- *
- * @dst:	destination address
- * @src:	source address
- * @cnt:	number of bytes to copy
- *
- * Low level memory copy function that catches machine checks
- * We only call into the "safe" function on systems that can
- * actually do machine check recovery. Everyone else can just
- * use memcpy().
- *
- * Return 0 for success, or number of bytes not copied if there was an
- * exception.
- */
-static __always_inline __must_check unsigned long
-memcpy_mcsafe(void *dst, const void *src, size_t cnt)
-{
-#ifdef CONFIG_X86_MCE
-	if (static_branch_unlikely(&mcsafe_key))
-		return __memcpy_mcsafe(dst, src, cnt);
-	else
-#endif
-		memcpy(dst, src, cnt);
-	return 0;
-}
-
 #ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
 #define __HAVE_ARCH_MEMCPY_FLUSHCACHE 1
 void __memcpy_flushcache(void *dst, const void *src, size_t cnt);
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index bc10e3dc64fe..42111e95a7ca 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -46,21 +46,8 @@ copy_user_generic(void *to, const void *from, unsigned len)
 	return ret;
 }
 
-static __always_inline __must_check unsigned long
-copy_to_user_mcsafe(void *to, const void *from, unsigned len)
-{
-	unsigned long ret;
-
-	__uaccess_begin();
-	/*
-	 * Note, __memcpy_mcsafe() is explicitly used since it can
-	 * handle exceptions / faults.  memcpy_mcsafe() may fall back to
-	 * memcpy() which lacks this handling.
-	 */
-	ret = __memcpy_mcsafe(to, from, len);
-	__uaccess_end();
-	return ret;
-}
+extern __must_check unsigned long
+copy_to_user_safe(void *to, const void *from, unsigned len);
 
 static __always_inline __must_check unsigned long
 raw_copy_from_user(void *dst, const void __user *src, unsigned long size)
@@ -102,8 +89,4 @@ __copy_from_user_flushcache(void *dst, const void __user *src, unsigned size)
 	kasan_check_write(dst, size);
 	return __copy_user_flushcache(dst, src, size);
 }
-
-unsigned long
-mcsafe_handle_tail(char *to, char *from, unsigned len);
-
 #endif /* _ASM_X86_UACCESS_64_H */
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 02e1f165f148..0dc6d6adb0ea 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -40,12 +40,12 @@
 #include <linux/debugfs.h>
 #include <linux/irq_work.h>
 #include <linux/export.h>
-#include <linux/jump_label.h>
 #include <linux/set_memory.h>
 
 #include <asm/intel-family.h>
 #include <asm/processor.h>
 #include <asm/traps.h>
+#include <asm/copy_safe.h>
 #include <asm/tlbflush.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
@@ -1982,7 +1982,7 @@ void mce_disable_bank(int bank)
 	and older.
  * mce=nobootlog Don't log MCEs from before booting.
  * mce=bios_cmci_threshold Don't program the CMCI threshold
- * mce=recovery force enable memcpy_mcsafe()
+ * mce=recovery force enable copy_safe_slow()
  */
 static int __init mcheck_enable(char *str)
 {
@@ -2590,13 +2590,10 @@ static void __init mcheck_debugfs_init(void)
 static void __init mcheck_debugfs_init(void) { }
 #endif
 
-DEFINE_STATIC_KEY_FALSE(mcsafe_key);
-EXPORT_SYMBOL_GPL(mcsafe_key);
-
 static int __init mcheck_late_init(void)
 {
 	if (mca_cfg.recovery)
-		static_branch_inc(&mcsafe_key);
+		enable_copy_safe_slow();
 
 	mcheck_debugfs_init();
 
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 896d74cb5081..09ef9402b56e 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -8,6 +8,7 @@
 
 #include <asm/hpet.h>
 #include <asm/setup.h>
+#include <asm/copy_safe.h>
 
 #if defined(CONFIG_X86_IO_APIC) && defined(CONFIG_SMP) && defined(CONFIG_PCI)
 
@@ -624,10 +625,6 @@ static void amd_disable_seq_and_redirect_scrub(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F3,
 			amd_disable_seq_and_redirect_scrub);
 
-#if defined(CONFIG_X86_64) && defined(CONFIG_X86_MCE)
-#include <linux/jump_label.h>
-#include <asm/string_64.h>
-
 /* Ivy Bridge, Haswell, Broadwell */
 static void quirk_intel_brickland_xeon_ras_cap(struct pci_dev *pdev)
 {
@@ -636,7 +633,7 @@ static void quirk_intel_brickland_xeon_ras_cap(struct pci_dev *pdev)
 	pci_read_config_dword(pdev, 0x84, &capid0);
 
 	if (capid0 & 0x10)
-		static_branch_inc(&mcsafe_key);
+		enable_copy_safe_slow();
 }
 
 /* Skylake */
@@ -653,7 +650,7 @@ static void quirk_intel_purley_xeon_ras_cap(struct pci_dev *pdev)
 	 * enabled, so memory machine check recovery is also enabled.
 	 */
 	if ((capid0 & 0xc0) == 0xc0 || (capid5 & 0x1e0))
-		static_branch_inc(&mcsafe_key);
+		enable_copy_safe_slow();
 
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x0ec3, quirk_intel_brickland_xeon_ras_cap);
@@ -661,7 +658,6 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x2fc0, quirk_intel_brickland_xeon_
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x6fc0, quirk_intel_brickland_xeon_ras_cap);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x2083, quirk_intel_purley_xeon_ras_cap);
 #endif
-#endif
 
 bool x86_apple_machine;
 EXPORT_SYMBOL(x86_apple_machine);
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 6110bce7237b..b93cf4f3b10b 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -44,6 +44,7 @@ obj-$(CONFIG_SMP) += msr-smp.o cache-smp.o
 lib-y := delay.o misc.o cmdline.o cpu.o
 lib-y += usercopy_$(BITS).o usercopy.o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
+lib-$(CONFIG_ARCH_HAS_COPY_SAFE) += copy_safe.o copy_safe_64.o
 lib-$(CONFIG_INSTRUCTION_DECODER) += insn.o inat.o insn-eval.o
 lib-$(CONFIG_RANDOMIZE_BASE) += kaslr.o
 lib-$(CONFIG_FUNCTION_ERROR_INJECTION)	+= error-inject.o
diff --git a/arch/x86/lib/copy_safe.c b/arch/x86/lib/copy_safe.c
new file mode 100644
index 000000000000..9dd3a831ff94
--- /dev/null
+++ b/arch/x86/lib/copy_safe.c
@@ -0,0 +1,67 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2016-2020 Intel Corporation. All rights reserved. */
+
+#include <linux/jump_label.h>
+#include <linux/uaccess.h>
+#include <linux/export.h>
+#include <linux/string.h>
+#include <linux/types.h>
+
+#include <asm/copy_safe.h>
+
+static DEFINE_STATIC_KEY_FALSE(copy_safe_slow_key);
+
+void enable_copy_safe_slow(void)
+{
+	static_branch_inc(&copy_safe_slow_key);
+}
+
+/**
+ * copy_safe - memory copy that aborts on faults or exceptions
+ *
+ * @dst:	destination address
+ * @src:	source address
+ * @cnt:	number of bytes to copy
+ *
+ * We only call into the slow version on systems that have trouble
+ * actually do machine check recovery. Everyone else can just
+ * use memcpy().
+ *
+ * Return 0 for success, or number of bytes not copied if there was an
+ * exception.
+ */
+__must_check unsigned long copy_safe(void *dst, const void *src, size_t cnt)
+{
+	if (static_branch_unlikely(&copy_safe_slow_key))
+		return copy_safe_slow(dst, src, cnt);
+	memcpy(dst, src, cnt);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(copy_safe);
+
+/*
+ * Similar to copy_user_handle_tail, probe for the write fault point, or
+ * source exception point.
+ */
+__visible notrace unsigned long
+copy_safe_slow_handle_tail(char *to, char *from, unsigned len)
+{
+	for (; len; --len, to++, from++)
+		if (copy_safe_slow(to, from, 1))
+			break;
+	return len;
+}
+
+__must_check unsigned long
+copy_to_user_safe(void *to, const void *from, unsigned len)
+{
+	unsigned long ret;
+
+	if (!static_branch_unlikely(&copy_safe_slow_key))
+		return copy_user_generic(to, from, len);
+
+	__uaccess_begin();
+	ret = copy_safe_slow(to, from, len);
+	__uaccess_end();
+	return ret;
+}
diff --git a/arch/x86/lib/copy_safe_64.S b/arch/x86/lib/copy_safe_64.S
new file mode 100644
index 000000000000..46dfdd832bde
--- /dev/null
+++ b/arch/x86/lib/copy_safe_64.S
@@ -0,0 +1,123 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2016-2020 Intel Corporation. All rights reserved. */
+
+#include <linux/linkage.h>
+#include <asm/copy_safe_test.h>
+#include <asm/export.h>
+#include <asm/asm.h>
+
+#ifndef CONFIG_UML
+
+COPY_SAFE_TEST_CTL
+
+/*
+ * copy_safe_slow - copy memory with indication if an exception / fault happened
+ *
+ * The slow version is opted into by platform quirks. The fast version
+ * is equivalent to memcpy() regardless of CPU machine-check-recovery
+ * capability.
+ */
+SYM_FUNC_START(copy_safe_slow)
+	cmpl $8, %edx
+	/* Less than 8 bytes? Go to byte copy loop */
+	jb .L_no_whole_words
+
+	/* Check for bad alignment of source */
+	testl $7, %esi
+	/* Already aligned */
+	jz .L_8byte_aligned
+
+	/* Copy one byte at a time until source is 8-byte aligned */
+	movl %esi, %ecx
+	andl $7, %ecx
+	subl $8, %ecx
+	negl %ecx
+	subl %ecx, %edx
+.L_read_leading_bytes:
+	movb (%rsi), %al
+	COPY_SAFE_TEST_SRC %rsi 1 .E_leading_bytes
+	COPY_SAFE_TEST_DST %rdi 1 .E_leading_bytes
+.L_write_leading_bytes:
+	movb %al, (%rdi)
+	incq %rsi
+	incq %rdi
+	decl %ecx
+	jnz .L_read_leading_bytes
+
+.L_8byte_aligned:
+	movl %edx, %ecx
+	andl $7, %edx
+	shrl $3, %ecx
+	jz .L_no_whole_words
+
+.L_read_words:
+	movq (%rsi), %r8
+	COPY_SAFE_TEST_SRC %rsi 8 .E_read_words
+	COPY_SAFE_TEST_DST %rdi 8 .E_write_words
+.L_write_words:
+	movq %r8, (%rdi)
+	addq $8, %rsi
+	addq $8, %rdi
+	decl %ecx
+	jnz .L_read_words
+
+	/* Any trailing bytes? */
+.L_no_whole_words:
+	andl %edx, %edx
+	jz .L_done_memcpy_trap
+
+	/* Copy trailing bytes */
+	movl %edx, %ecx
+.L_read_trailing_bytes:
+	movb (%rsi), %al
+	COPY_SAFE_TEST_SRC %rsi 1 .E_trailing_bytes
+	COPY_SAFE_TEST_DST %rdi 1 .E_trailing_bytes
+.L_write_trailing_bytes:
+	movb %al, (%rdi)
+	incq %rsi
+	incq %rdi
+	decl %ecx
+	jnz .L_read_trailing_bytes
+
+	/* Copy successful. Return zero */
+.L_done_memcpy_trap:
+	xorl %eax, %eax
+.L_done:
+	ret
+SYM_FUNC_END(copy_safe_slow)
+EXPORT_SYMBOL_GPL(copy_safe_slow)
+
+	.section .fixup, "ax"
+	/*
+	 * Return number of bytes not copied for any failure. Note that
+	 * there is no "tail" handling since the source buffer is 8-byte
+	 * aligned and poison is cacheline aligned.
+	 */
+.E_read_words:
+	shll	$3, %ecx
+.E_leading_bytes:
+	addl	%edx, %ecx
+.E_trailing_bytes:
+	mov	%ecx, %eax
+	jmp	.L_done
+
+	/*
+	 * For write fault handling, given the destination is unaligned,
+	 * we handle faults on multi-byte writes with a byte-by-byte
+	 * copy up to the write-protected page.
+	 */
+.E_write_words:
+	shll	$3, %ecx
+	addl	%edx, %ecx
+	movl	%ecx, %edx
+	jmp copy_safe_slow_handle_tail
+
+	.previous
+
+	_ASM_EXTABLE_FAULT(.L_read_leading_bytes, .E_leading_bytes)
+	_ASM_EXTABLE_FAULT(.L_read_words, .E_read_words)
+	_ASM_EXTABLE_FAULT(.L_read_trailing_bytes, .E_trailing_bytes)
+	_ASM_EXTABLE(.L_write_leading_bytes, .E_leading_bytes)
+	_ASM_EXTABLE(.L_write_words, .E_write_words)
+	_ASM_EXTABLE(.L_write_trailing_bytes, .E_trailing_bytes)
+#endif
diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 56b243b14c3a..4ed8d87b3b48 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -4,7 +4,6 @@
 #include <linux/linkage.h>
 #include <asm/errno.h>
 #include <asm/cpufeatures.h>
-#include <asm/mcsafe_test.h>
 #include <asm/alternative-asm.h>
 #include <asm/export.h>
 
@@ -183,117 +182,3 @@ SYM_FUNC_START_LOCAL(memcpy_orig)
 .Lend:
 	retq
 SYM_FUNC_END(memcpy_orig)
-
-#ifndef CONFIG_UML
-
-MCSAFE_TEST_CTL
-
-/*
- * __memcpy_mcsafe - memory copy with machine check exception handling
- * Note that we only catch machine checks when reading the source addresses.
- * Writes to target are posted and don't generate machine checks.
- */
-SYM_FUNC_START(__memcpy_mcsafe)
-	cmpl $8, %edx
-	/* Less than 8 bytes? Go to byte copy loop */
-	jb .L_no_whole_words
-
-	/* Check for bad alignment of source */
-	testl $7, %esi
-	/* Already aligned */
-	jz .L_8byte_aligned
-
-	/* Copy one byte at a time until source is 8-byte aligned */
-	movl %esi, %ecx
-	andl $7, %ecx
-	subl $8, %ecx
-	negl %ecx
-	subl %ecx, %edx
-.L_read_leading_bytes:
-	movb (%rsi), %al
-	MCSAFE_TEST_SRC %rsi 1 .E_leading_bytes
-	MCSAFE_TEST_DST %rdi 1 .E_leading_bytes
-.L_write_leading_bytes:
-	movb %al, (%rdi)
-	incq %rsi
-	incq %rdi
-	decl %ecx
-	jnz .L_read_leading_bytes
-
-.L_8byte_aligned:
-	movl %edx, %ecx
-	andl $7, %edx
-	shrl $3, %ecx
-	jz .L_no_whole_words
-
-.L_read_words:
-	movq (%rsi), %r8
-	MCSAFE_TEST_SRC %rsi 8 .E_read_words
-	MCSAFE_TEST_DST %rdi 8 .E_write_words
-.L_write_words:
-	movq %r8, (%rdi)
-	addq $8, %rsi
-	addq $8, %rdi
-	decl %ecx
-	jnz .L_read_words
-
-	/* Any trailing bytes? */
-.L_no_whole_words:
-	andl %edx, %edx
-	jz .L_done_memcpy_trap
-
-	/* Copy trailing bytes */
-	movl %edx, %ecx
-.L_read_trailing_bytes:
-	movb (%rsi), %al
-	MCSAFE_TEST_SRC %rsi 1 .E_trailing_bytes
-	MCSAFE_TEST_DST %rdi 1 .E_trailing_bytes
-.L_write_trailing_bytes:
-	movb %al, (%rdi)
-	incq %rsi
-	incq %rdi
-	decl %ecx
-	jnz .L_read_trailing_bytes
-
-	/* Copy successful. Return zero */
-.L_done_memcpy_trap:
-	xorl %eax, %eax
-.L_done:
-	ret
-SYM_FUNC_END(__memcpy_mcsafe)
-EXPORT_SYMBOL_GPL(__memcpy_mcsafe)
-
-	.section .fixup, "ax"
-	/*
-	 * Return number of bytes not copied for any failure. Note that
-	 * there is no "tail" handling since the source buffer is 8-byte
-	 * aligned and poison is cacheline aligned.
-	 */
-.E_read_words:
-	shll	$3, %ecx
-.E_leading_bytes:
-	addl	%edx, %ecx
-.E_trailing_bytes:
-	mov	%ecx, %eax
-	jmp	.L_done
-
-	/*
-	 * For write fault handling, given the destination is unaligned,
-	 * we handle faults on multi-byte writes with a byte-by-byte
-	 * copy up to the write-protected page.
-	 */
-.E_write_words:
-	shll	$3, %ecx
-	addl	%edx, %ecx
-	movl	%ecx, %edx
-	jmp mcsafe_handle_tail
-
-	.previous
-
-	_ASM_EXTABLE_FAULT(.L_read_leading_bytes, .E_leading_bytes)
-	_ASM_EXTABLE_FAULT(.L_read_words, .E_read_words)
-	_ASM_EXTABLE_FAULT(.L_read_trailing_bytes, .E_trailing_bytes)
-	_ASM_EXTABLE(.L_write_leading_bytes, .E_leading_bytes)
-	_ASM_EXTABLE(.L_write_words, .E_write_words)
-	_ASM_EXTABLE(.L_write_trailing_bytes, .E_trailing_bytes)
-#endif
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index fff28c6f73a2..a3f9c93efc42 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -55,27 +55,6 @@ unsigned long clear_user(void __user *to, unsigned long n)
 }
 EXPORT_SYMBOL(clear_user);
 
-/*
- * Similar to copy_user_handle_tail, probe for the write fault point,
- * but reuse __memcpy_mcsafe in case a new read error is encountered.
- * clac() is handled in _copy_to_iter_mcsafe().
- */
-__visible notrace unsigned long
-mcsafe_handle_tail(char *to, char *from, unsigned len)
-{
-	for (; len; --len, to++, from++) {
-		/*
-		 * Call the assembly routine back directly since
-		 * memcpy_mcsafe() may silently fallback to memcpy.
-		 */
-		unsigned long rem = __memcpy_mcsafe(to, from, 1);
-
-		if (rem)
-			break;
-	}
-	return len;
-}
-
 #ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
 /**
  * clean_cache_range - write back a cache range with CLWB
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 114927da9cc9..edd14472b740 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -49,7 +49,7 @@ do {								\
 #define pmem_assign(dest, src)	((dest) = (src))
 #endif
 
-#if defined(__HAVE_ARCH_MEMCPY_MCSAFE) && defined(DM_WRITECACHE_HAS_PMEM)
+#if defined(__HAVE_ARCH_COPY_SAFE) && defined(DM_WRITECACHE_HAS_PMEM)
 #define DM_WRITECACHE_HANDLE_HARDWARE_ERRORS
 #endif
 
@@ -954,7 +954,7 @@ static void writecache_resume(struct dm_target *ti)
 	}
 	wc->freelist_size = 0;
 
-	r = memcpy_mcsafe(&sb_seq_count, &sb(wc)->seq_count, sizeof(uint64_t));
+	r = copy_safe(&sb_seq_count, &sb(wc)->seq_count, sizeof(uint64_t));
 	if (r) {
 		writecache_error(wc, r, "hardware memory error when reading superblock: %d", r);
 		sb_seq_count = cpu_to_le64(0);
@@ -970,7 +970,7 @@ static void writecache_resume(struct dm_target *ti)
 			e->seq_count = -1;
 			continue;
 		}
-		r = memcpy_mcsafe(&wme, memory_entry(wc, e), sizeof(struct wc_memory_entry));
+		r = copy_safe(&wme, memory_entry(wc, e), sizeof(struct wc_memory_entry));
 		if (r) {
 			writecache_error(wc, r, "hardware memory error when reading metadata entry %lu: %d",
 					 (unsigned long)b, r);
@@ -1132,7 +1132,7 @@ static void bio_copy_block(struct dm_writecache *wc, struct bio *bio, void *data
 
 		if (rw == READ) {
 			int r;
-			r = memcpy_mcsafe(buf, data, size);
+			r = copy_safe(buf, data, size);
 			flush_dcache_page(bio_page(bio));
 			if (unlikely(r)) {
 				writecache_error(wc, r, "hardware memory error when reading data: %d", r);
@@ -2275,7 +2275,7 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		}
 	}
 
-	r = memcpy_mcsafe(&s, sb(wc), sizeof(struct wc_memory_superblock));
+	r = copy_safe(&s, sb(wc), sizeof(struct wc_memory_superblock));
 	if (r) {
 		ti->error = "Hardware memory error when reading superblock";
 		goto bad;
@@ -2286,7 +2286,7 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 			ti->error = "Unable to initialize device";
 			goto bad;
 		}
-		r = memcpy_mcsafe(&s, sb(wc), sizeof(struct wc_memory_superblock));
+		r = copy_safe(&s, sb(wc), sizeof(struct wc_memory_superblock));
 		if (r) {
 			ti->error = "Hardware memory error when reading superblock";
 			goto bad;
diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index 45964acba944..3f18c2119751 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -268,7 +268,7 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
 	if (rw == READ) {
 		if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align)))
 			return -EIO;
-		if (memcpy_mcsafe(buf, nsio->addr + offset, size) != 0)
+		if (copy_safe(buf, nsio->addr + offset, size) != 0)
 			return -EIO;
 		return 0;
 	}
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 2df6994acf83..197d76885316 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -124,7 +124,7 @@ static blk_status_t read_pmem(struct page *page, unsigned int off,
 	while (len) {
 		mem = kmap_atomic(page);
 		chunk = min_t(unsigned int, len, PAGE_SIZE - off);
-		rem = memcpy_mcsafe(mem + off, pmem_addr, chunk);
+		rem = copy_safe(mem + off, pmem_addr, chunk);
 		kunmap_atomic(mem);
 		if (rem)
 			return BLK_STS_IOERR;
@@ -302,7 +302,7 @@ static long pmem_dax_direct_access(struct dax_device *dax_dev,
 
 /*
  * Use the 'no check' versions of copy_from_iter_flushcache() and
- * copy_to_iter_mcsafe() to bypass HARDENED_USERCOPY overhead. Bounds
+ * copy_to_iter_safe() to bypass HARDENED_USERCOPY overhead. Bounds
  * checking, both file offset and device offset, is handled by
  * dax_iomap_actor()
  */
@@ -315,7 +315,7 @@ static size_t pmem_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 static size_t pmem_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *i)
 {
-	return _copy_to_iter_mcsafe(addr, bytes, i);
+	return _copy_to_iter_safe(addr, bytes, i);
 }
 
 static const struct dax_operations pmem_dax_ops = {
diff --git a/include/linux/string.h b/include/linux/string.h
index 6dfbb2efa815..2c7de8317c43 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -161,20 +161,25 @@ extern int bcmp(const void *,const void *,__kernel_size_t);
 #ifndef __HAVE_ARCH_MEMCHR
 extern void * memchr(const void *,int,__kernel_size_t);
 #endif
-#ifndef __HAVE_ARCH_MEMCPY_MCSAFE
-static inline __must_check unsigned long memcpy_mcsafe(void *dst,
-		const void *src, size_t cnt)
+#ifndef __HAVE_ARCH_MEMCPY_FLUSHCACHE
+static inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
 {
 	memcpy(dst, src, cnt);
-	return 0;
 }
 #endif
-#ifndef __HAVE_ARCH_MEMCPY_FLUSHCACHE
-static inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
+
+#ifdef CONFIG_ARCH_HAS_COPY_SAFE
+extern __must_check unsigned long copy_safe(void *dst, const void *src,
+		size_t cnt);
+#else /* CONFIG_ARCH_HAS_COPY_SAFE */
+static inline __must_check unsigned long copy_safe(void *dst, const void *src,
+		size_t cnt)
 {
 	memcpy(dst, src, cnt);
+	return 0;
 }
 #endif
+
 void *memchr_inv(const void *s, int c, size_t n);
 char *strreplace(char *s, char old, char new);
 
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 9576fd8158d7..069d590d3fcc 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -186,10 +186,10 @@ size_t _copy_from_iter_flushcache(void *addr, size_t bytes, struct iov_iter *i);
 #define _copy_from_iter_flushcache _copy_from_iter_nocache
 #endif
 
-#ifdef CONFIG_ARCH_HAS_UACCESS_MCSAFE
-size_t _copy_to_iter_mcsafe(const void *addr, size_t bytes, struct iov_iter *i);
+#ifdef CONFIG_ARCH_HAS_COPY_SAFE
+size_t _copy_to_iter_safe(const void *addr, size_t bytes, struct iov_iter *i);
 #else
-#define _copy_to_iter_mcsafe _copy_to_iter
+#define _copy_to_iter_safe _copy_to_iter
 #endif
 
 static __always_inline __must_check
@@ -202,12 +202,12 @@ size_t copy_from_iter_flushcache(void *addr, size_t bytes, struct iov_iter *i)
 }
 
 static __always_inline __must_check
-size_t copy_to_iter_mcsafe(void *addr, size_t bytes, struct iov_iter *i)
+size_t copy_to_iter_safe(void *addr, size_t bytes, struct iov_iter *i)
 {
 	if (unlikely(!check_copy_size(addr, bytes, true)))
 		return 0;
 	else
-		return _copy_to_iter_mcsafe(addr, bytes, i);
+		return _copy_to_iter_safe(addr, bytes, i);
 }
 
 size_t iov_iter_zero(size_t bytes, struct iov_iter *);
diff --git a/lib/Kconfig b/lib/Kconfig
index e831e1f01767..ed0e92828285 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -628,7 +628,7 @@ config UACCESS_MEMCPY
 config ARCH_HAS_UACCESS_FLUSHCACHE
 	bool
 
-config ARCH_HAS_UACCESS_MCSAFE
+config ARCH_HAS_COPY_SAFE
 	bool
 
 # Temporary. Goes away when all archs are cleaned up
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index bf538c2bec77..df7b475b5018 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -636,30 +636,30 @@ size_t _copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
 }
 EXPORT_SYMBOL(_copy_to_iter);
 
-#ifdef CONFIG_ARCH_HAS_UACCESS_MCSAFE
-static int copyout_mcsafe(void __user *to, const void *from, size_t n)
+#ifdef CONFIG_ARCH_HAS_COPY_SAFE
+static int copyout_safe(void __user *to, const void *from, size_t n)
 {
 	if (access_ok(to, n)) {
 		instrument_copy_to_user(to, from, n);
-		n = copy_to_user_mcsafe((__force void *) to, from, n);
+		n = copy_to_user_safe((__force void *) to, from, n);
 	}
 	return n;
 }
 
-static unsigned long memcpy_mcsafe_to_page(struct page *page, size_t offset,
+static unsigned long copy_safe_to_page(struct page *page, size_t offset,
 		const char *from, size_t len)
 {
 	unsigned long ret;
 	char *to;
 
 	to = kmap_atomic(page);
-	ret = memcpy_mcsafe(to + offset, from, len);
+	ret = copy_safe(to + offset, from, len);
 	kunmap_atomic(to);
 
 	return ret;
 }
 
-static size_t copy_pipe_to_iter_mcsafe(const void *addr, size_t bytes,
+static size_t copy_pipe_to_iter_safe(const void *addr, size_t bytes,
 				struct iov_iter *i)
 {
 	struct pipe_inode_info *pipe = i->pipe;
@@ -677,7 +677,7 @@ static size_t copy_pipe_to_iter_mcsafe(const void *addr, size_t bytes,
 		size_t chunk = min_t(size_t, n, PAGE_SIZE - off);
 		unsigned long rem;
 
-		rem = memcpy_mcsafe_to_page(pipe->bufs[i_head & p_mask].page,
+		rem = copy_safe_to_page(pipe->bufs[i_head & p_mask].page,
 					    off, addr, chunk);
 		i->head = i_head;
 		i->iov_offset = off + chunk - rem;
@@ -694,7 +694,7 @@ static size_t copy_pipe_to_iter_mcsafe(const void *addr, size_t bytes,
 }
 
 /**
- * _copy_to_iter_mcsafe - copy to user with source-read error exception handling
+ * _copy_to_iter_safe - copy to user with source-read error exception handling
  * @addr: source kernel address
  * @bytes: total transfer length
  * @iter: destination iterator
@@ -702,8 +702,8 @@ static size_t copy_pipe_to_iter_mcsafe(const void *addr, size_t bytes,
  * The pmem driver arranges for filesystem-dax to use this facility via
  * dax_copy_to_iter() for protecting read/write to persistent memory.
  * Unless / until an architecture can guarantee identical performance
- * between _copy_to_iter_mcsafe() and _copy_to_iter() it would be a
- * performance regression to switch more users to the mcsafe version.
+ * between _copy_to_iter_safe() and _copy_to_iter() it would be a
+ * performance regression to switch more users to the safe version.
  *
  * Otherwise, the main differences between this and typical _copy_to_iter().
  *
@@ -717,21 +717,21 @@ static size_t copy_pipe_to_iter_mcsafe(const void *addr, size_t bytes,
  *   Compare to copy_to_iter() where only ITER_IOVEC attempts might return
  *   a short copy.
  *
- * See MCSAFE_TEST for self-test.
+ * See COPY_SAFE_TEST for self-test.
  */
-size_t _copy_to_iter_mcsafe(const void *addr, size_t bytes, struct iov_iter *i)
+size_t _copy_to_iter_safe(const void *addr, size_t bytes, struct iov_iter *i)
 {
 	const char *from = addr;
 	unsigned long rem, curr_addr, s_addr = (unsigned long) addr;
 
 	if (unlikely(iov_iter_is_pipe(i)))
-		return copy_pipe_to_iter_mcsafe(addr, bytes, i);
+		return copy_pipe_to_iter_safe(addr, bytes, i);
 	if (iter_is_iovec(i))
 		might_fault();
 	iterate_and_advance(i, bytes, v,
-		copyout_mcsafe(v.iov_base, (from += v.iov_len) - v.iov_len, v.iov_len),
+		copyout_safe(v.iov_base, (from += v.iov_len) - v.iov_len, v.iov_len),
 		({
-		rem = memcpy_mcsafe_to_page(v.bv_page, v.bv_offset,
+		rem = copy_safe_to_page(v.bv_page, v.bv_offset,
                                (from += v.bv_len) - v.bv_len, v.bv_len);
 		if (rem) {
 			curr_addr = (unsigned long) from;
@@ -740,7 +740,7 @@ size_t _copy_to_iter_mcsafe(const void *addr, size_t bytes, struct iov_iter *i)
 		}
 		}),
 		({
-		rem = memcpy_mcsafe(v.iov_base, (from += v.iov_len) - v.iov_len,
+		rem = copy_safe(v.iov_base, (from += v.iov_len) - v.iov_len,
 				v.iov_len);
 		if (rem) {
 			curr_addr = (unsigned long) from;
@@ -752,8 +752,8 @@ size_t _copy_to_iter_mcsafe(const void *addr, size_t bytes, struct iov_iter *i)
 
 	return bytes;
 }
-EXPORT_SYMBOL_GPL(_copy_to_iter_mcsafe);
-#endif /* CONFIG_ARCH_HAS_UACCESS_MCSAFE */
+EXPORT_SYMBOL_GPL(_copy_to_iter_safe);
+#endif /* CONFIG_ARCH_HAS_COPY_SAFE */
 
 size_t _copy_from_iter(void *addr, size_t bytes, struct iov_iter *i)
 {
diff --git a/tools/arch/x86/include/asm/copy_safe_test.h b/tools/arch/x86/include/asm/copy_safe_test.h
new file mode 100644
index 000000000000..1a70c7d424cf
--- /dev/null
+++ b/tools/arch/x86/include/asm/copy_safe_test.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _COPY_SAFE_TEST_H_
+#define _COPY_SAFE_TEST_H_
+
+.macro COPY_SAFE_TEST_CTL
+.endm
+
+.macro COPY_SAFE_TEST_SRC reg count target
+.endm
+
+.macro COPY_SAFE_TEST_DST reg count target
+.endm
+#endif /* _COPY_SAFE_TEST_H_ */
diff --git a/tools/arch/x86/include/asm/mcsafe_test.h b/tools/arch/x86/include/asm/mcsafe_test.h
deleted file mode 100644
index 2ccd588fbad4..000000000000
--- a/tools/arch/x86/include/asm/mcsafe_test.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _MCSAFE_TEST_H_
-#define _MCSAFE_TEST_H_
-
-.macro MCSAFE_TEST_CTL
-.endm
-
-.macro MCSAFE_TEST_SRC reg count target
-.endm
-
-.macro MCSAFE_TEST_DST reg count target
-.endm
-#endif /* _MCSAFE_TEST_H_ */
diff --git a/tools/arch/x86/lib/memcpy_64.S b/tools/arch/x86/lib/memcpy_64.S
index df767afc690f..6e45d3d1a96e 100644
--- a/tools/arch/x86/lib/memcpy_64.S
+++ b/tools/arch/x86/lib/memcpy_64.S
@@ -4,7 +4,6 @@
 #include <linux/linkage.h>
 #include <asm/errno.h>
 #include <asm/cpufeatures.h>
-#include <asm/mcsafe_test.h>
 #include <asm/alternative-asm.h>
 #include <asm/export.h>
 
@@ -183,117 +182,3 @@ SYM_FUNC_START(memcpy_orig)
 .Lend:
 	retq
 SYM_FUNC_END(memcpy_orig)
-
-#ifndef CONFIG_UML
-
-MCSAFE_TEST_CTL
-
-/*
- * __memcpy_mcsafe - memory copy with machine check exception handling
- * Note that we only catch machine checks when reading the source addresses.
- * Writes to target are posted and don't generate machine checks.
- */
-SYM_FUNC_START(__memcpy_mcsafe)
-	cmpl $8, %edx
-	/* Less than 8 bytes? Go to byte copy loop */
-	jb .L_no_whole_words
-
-	/* Check for bad alignment of source */
-	testl $7, %esi
-	/* Already aligned */
-	jz .L_8byte_aligned
-
-	/* Copy one byte at a time until source is 8-byte aligned */
-	movl %esi, %ecx
-	andl $7, %ecx
-	subl $8, %ecx
-	negl %ecx
-	subl %ecx, %edx
-.L_read_leading_bytes:
-	movb (%rsi), %al
-	MCSAFE_TEST_SRC %rsi 1 .E_leading_bytes
-	MCSAFE_TEST_DST %rdi 1 .E_leading_bytes
-.L_write_leading_bytes:
-	movb %al, (%rdi)
-	incq %rsi
-	incq %rdi
-	decl %ecx
-	jnz .L_read_leading_bytes
-
-.L_8byte_aligned:
-	movl %edx, %ecx
-	andl $7, %edx
-	shrl $3, %ecx
-	jz .L_no_whole_words
-
-.L_read_words:
-	movq (%rsi), %r8
-	MCSAFE_TEST_SRC %rsi 8 .E_read_words
-	MCSAFE_TEST_DST %rdi 8 .E_write_words
-.L_write_words:
-	movq %r8, (%rdi)
-	addq $8, %rsi
-	addq $8, %rdi
-	decl %ecx
-	jnz .L_read_words
-
-	/* Any trailing bytes? */
-.L_no_whole_words:
-	andl %edx, %edx
-	jz .L_done_memcpy_trap
-
-	/* Copy trailing bytes */
-	movl %edx, %ecx
-.L_read_trailing_bytes:
-	movb (%rsi), %al
-	MCSAFE_TEST_SRC %rsi 1 .E_trailing_bytes
-	MCSAFE_TEST_DST %rdi 1 .E_trailing_bytes
-.L_write_trailing_bytes:
-	movb %al, (%rdi)
-	incq %rsi
-	incq %rdi
-	decl %ecx
-	jnz .L_read_trailing_bytes
-
-	/* Copy successful. Return zero */
-.L_done_memcpy_trap:
-	xorl %eax, %eax
-.L_done:
-	ret
-SYM_FUNC_END(__memcpy_mcsafe)
-EXPORT_SYMBOL_GPL(__memcpy_mcsafe)
-
-	.section .fixup, "ax"
-	/*
-	 * Return number of bytes not copied for any failure. Note that
-	 * there is no "tail" handling since the source buffer is 8-byte
-	 * aligned and poison is cacheline aligned.
-	 */
-.E_read_words:
-	shll	$3, %ecx
-.E_leading_bytes:
-	addl	%edx, %ecx
-.E_trailing_bytes:
-	mov	%ecx, %eax
-	jmp	.L_done
-
-	/*
-	 * For write fault handling, given the destination is unaligned,
-	 * we handle faults on multi-byte writes with a byte-by-byte
-	 * copy up to the write-protected page.
-	 */
-.E_write_words:
-	shll	$3, %ecx
-	addl	%edx, %ecx
-	movl	%ecx, %edx
-	jmp mcsafe_handle_tail
-
-	.previous
-
-	_ASM_EXTABLE_FAULT(.L_read_leading_bytes, .E_leading_bytes)
-	_ASM_EXTABLE_FAULT(.L_read_words, .E_read_words)
-	_ASM_EXTABLE_FAULT(.L_read_trailing_bytes, .E_trailing_bytes)
-	_ASM_EXTABLE(.L_write_leading_bytes, .E_leading_bytes)
-	_ASM_EXTABLE(.L_write_words, .E_write_words)
-	_ASM_EXTABLE(.L_write_trailing_bytes, .E_trailing_bytes)
-#endif
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 0c732d586924..be20eff8f358 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -533,8 +533,8 @@ static const char *uaccess_safe_builtin[] = {
 	"__ubsan_handle_shift_out_of_bounds",
 	/* misc */
 	"csum_partial_copy_generic",
-	"__memcpy_mcsafe",
-	"mcsafe_handle_tail",
+	"copy_safe_slow",
+	"copy_safe_slow_handle_tail",
 	"ftrace_likely_update", /* CONFIG_TRACE_BRANCH_PROFILING */
 	NULL
 };
diff --git a/tools/perf/bench/Build b/tools/perf/bench/Build
index 042827385c87..5cc1ee5fd520 100644
--- a/tools/perf/bench/Build
+++ b/tools/perf/bench/Build
@@ -10,7 +10,6 @@ perf-y += epoll-wait.o
 perf-y += epoll-ctl.o
 perf-y += synthesize.o
 
-perf-$(CONFIG_X86_64) += mem-memcpy-x86-64-lib.o
 perf-$(CONFIG_X86_64) += mem-memcpy-x86-64-asm.o
 perf-$(CONFIG_X86_64) += mem-memset-x86-64-asm.o
 
diff --git a/tools/perf/bench/mem-memcpy-x86-64-lib.c b/tools/perf/bench/mem-memcpy-x86-64-lib.c
deleted file mode 100644
index 4130734dde84..000000000000
--- a/tools/perf/bench/mem-memcpy-x86-64-lib.c
+++ /dev/null
@@ -1,24 +0,0 @@
-/*
- * From code in arch/x86/lib/usercopy_64.c, copied to keep tools/ copy
- * of the kernel's arch/x86/lib/memcpy_64.s used in 'perf bench mem memcpy'
- * happy.
- */
-#include <linux/types.h>
-
-unsigned long __memcpy_mcsafe(void *dst, const void *src, size_t cnt);
-unsigned long mcsafe_handle_tail(char *to, char *from, unsigned len);
-
-unsigned long mcsafe_handle_tail(char *to, char *from, unsigned len)
-{
-	for (; len; --len, to++, from++) {
-		/*
-		 * Call the assembly routine back directly since
-		 * memcpy_mcsafe() may silently fallback to memcpy.
-		 */
-		unsigned long rem = __memcpy_mcsafe(to, from, 1);
-
-		if (rem)
-			break;
-	}
-	return len;
-}
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index a8ee5c4d41eb..ac5c1fa796de 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -23,7 +23,8 @@
 #include "nfit_test.h"
 #include "../watermark.h"
 
-#include <asm/mcsafe_test.h>
+#include <asm/copy_safe_test.h>
+#include <asm/copy_safe.h>
 
 /*
  * Generate an NFIT table to describe the following topology:
@@ -3052,7 +3053,7 @@ static struct platform_driver nfit_test_driver = {
 	.id_table = nfit_test_id,
 };
 
-static char mcsafe_buf[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
+static char copy_safe_buf[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
 
 enum INJECT {
 	INJECT_NONE,
@@ -3060,7 +3061,7 @@ enum INJECT {
 	INJECT_DST,
 };
 
-static void mcsafe_test_init(char *dst, char *src, size_t size)
+static void copy_safe_test_init(char *dst, char *src, size_t size)
 {
 	size_t i;
 
@@ -3069,7 +3070,7 @@ static void mcsafe_test_init(char *dst, char *src, size_t size)
 		src[i] = (char) i;
 }
 
-static bool mcsafe_test_validate(unsigned char *dst, unsigned char *src,
+static bool copy_safe_test_validate(unsigned char *dst, unsigned char *src,
 		size_t size, unsigned long rem)
 {
 	size_t i;
@@ -3090,12 +3091,12 @@ static bool mcsafe_test_validate(unsigned char *dst, unsigned char *src,
 	return true;
 }
 
-void mcsafe_test(void)
+void copy_safe_test(void)
 {
 	char *inject_desc[] = { "none", "source", "destination" };
 	enum INJECT inj;
 
-	if (IS_ENABLED(CONFIG_MCSAFE_TEST)) {
+	if (IS_ENABLED(CONFIG_COPY_SAFE_TEST)) {
 		pr_info("%s: run...\n", __func__);
 	} else {
 		pr_info("%s: disabled, skip.\n", __func__);
@@ -3113,31 +3114,31 @@ void mcsafe_test(void)
 
 			switch (inj) {
 			case INJECT_NONE:
-				mcsafe_inject_src(NULL);
-				mcsafe_inject_dst(NULL);
-				dst = &mcsafe_buf[2048];
-				src = &mcsafe_buf[1024 - i];
+				copy_safe_inject_src(NULL);
+				copy_safe_inject_dst(NULL);
+				dst = &copy_safe_buf[2048];
+				src = &copy_safe_buf[1024 - i];
 				expect = 0;
 				break;
 			case INJECT_SRC:
-				mcsafe_inject_src(&mcsafe_buf[1024]);
-				mcsafe_inject_dst(NULL);
-				dst = &mcsafe_buf[2048];
-				src = &mcsafe_buf[1024 - i];
+				copy_safe_inject_src(&copy_safe_buf[1024]);
+				copy_safe_inject_dst(NULL);
+				dst = &copy_safe_buf[2048];
+				src = &copy_safe_buf[1024 - i];
 				expect = 512 - i;
 				break;
 			case INJECT_DST:
-				mcsafe_inject_src(NULL);
-				mcsafe_inject_dst(&mcsafe_buf[2048]);
-				dst = &mcsafe_buf[2048 - i];
-				src = &mcsafe_buf[1024];
+				copy_safe_inject_src(NULL);
+				copy_safe_inject_dst(&copy_safe_buf[2048]);
+				dst = &copy_safe_buf[2048 - i];
+				src = &copy_safe_buf[1024];
 				expect = 512 - i;
 				break;
 			}
 
-			mcsafe_test_init(dst, src, 512);
-			rem = __memcpy_mcsafe(dst, src, 512);
-			valid = mcsafe_test_validate(dst, src, 512, expect);
+			copy_safe_test_init(dst, src, 512);
+			rem = copy_safe_slow(dst, src, 512);
+			valid = copy_safe_test_validate(dst, src, 512, expect);
 			if (rem == expect && valid)
 				continue;
 			pr_info("%s: copy(%#lx, %#lx, %d) off: %d rem: %ld %s expect: %ld\n",
@@ -3149,8 +3150,8 @@ void mcsafe_test(void)
 		}
 	}
 
-	mcsafe_inject_src(NULL);
-	mcsafe_inject_dst(NULL);
+	copy_safe_inject_src(NULL);
+	copy_safe_inject_dst(NULL);
 }
 
 static __init int nfit_test_init(void)
@@ -3161,7 +3162,7 @@ static __init int nfit_test_init(void)
 	libnvdimm_test();
 	acpi_nfit_test();
 	device_dax_test();
-	mcsafe_test();
+	copy_safe_test();
 	dax_pmem_test();
 	dax_pmem_core_test();
 #ifdef CONFIG_DEV_DAX_PMEM_COMPAT
diff --git a/tools/testing/selftests/powerpc/copyloops/.gitignore b/tools/testing/selftests/powerpc/copyloops/.gitignore
index ddaf140b8255..5187f69e3789 100644
--- a/tools/testing/selftests/powerpc/copyloops/.gitignore
+++ b/tools/testing/selftests/powerpc/copyloops/.gitignore
@@ -12,4 +12,4 @@ memcpy_p7_t1
 copyuser_64_exc_t0
 copyuser_64_exc_t1
 copyuser_64_exc_t2
-memcpy_mcsafe_64
+copy_safe
diff --git a/tools/testing/selftests/powerpc/copyloops/Makefile b/tools/testing/selftests/powerpc/copyloops/Makefile
index 0917983a1c78..2bec0eccdf7d 100644
--- a/tools/testing/selftests/powerpc/copyloops/Makefile
+++ b/tools/testing/selftests/powerpc/copyloops/Makefile
@@ -12,7 +12,7 @@ ASFLAGS = $(CFLAGS) -Wa,-mpower4
 TEST_GEN_PROGS := copyuser_64_t0 copyuser_64_t1 copyuser_64_t2 \
 		copyuser_p7_t0 copyuser_p7_t1 \
 		memcpy_64_t0 memcpy_64_t1 memcpy_64_t2 \
-		memcpy_p7_t0 memcpy_p7_t1 memcpy_mcsafe_64 \
+		memcpy_p7_t0 memcpy_p7_t1 copy_safe \
 		copyuser_64_exc_t0 copyuser_64_exc_t1 copyuser_64_exc_t2
 
 EXTRA_SOURCES := validate.c ../harness.c stubs.S
@@ -45,9 +45,9 @@ $(OUTPUT)/memcpy_p7_t%:	memcpy_power7.S $(EXTRA_SOURCES)
 		-D SELFTEST_CASE=$(subst memcpy_p7_t,,$(notdir $@)) \
 		-o $@ $^
 
-$(OUTPUT)/memcpy_mcsafe_64: memcpy_mcsafe_64.S $(EXTRA_SOURCES)
+$(OUTPUT)/copy_safe: copy_safe.S $(EXTRA_SOURCES)
 	$(CC) $(CPPFLAGS) $(CFLAGS) \
-		-D COPY_LOOP=test_memcpy_mcsafe \
+		-D COPY_LOOP=test_copy_safe \
 		-o $@ $^
 
 $(OUTPUT)/copyuser_64_exc_t%: copyuser_64.S exc_validate.c ../harness.c \
diff --git a/tools/testing/selftests/powerpc/copyloops/memcpy_mcsafe_64.S b/tools/testing/selftests/powerpc/copyloops/copy_safe.S
similarity index 100%
rename from tools/testing/selftests/powerpc/copyloops/memcpy_mcsafe_64.S
rename to tools/testing/selftests/powerpc/copyloops/copy_safe.S

