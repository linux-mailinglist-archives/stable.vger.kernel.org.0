Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3000366BF1
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 15:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241227AbhDUNIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 09:08:46 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:37991 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240229AbhDUNHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 09:07:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619010437; x=1650546437;
  h=subject:from:to:cc:references:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=qi9qpSSFejvHTma8np0UdFMojO/Y59AXXjDMbuDHHIA=;
  b=ItC5/VS62RnJv2M1gXRO4eioc7Ltm7J3S+fBIf9tG4fofB9Z25y4YW/U
   GpJXeGYu/wFYduHP5Auh9s7i4nG0wKWJJlWgV3QGNxadgmxIC8j0YRKr9
   VbuVE++9ZPsTiVg784g53w10VE5QdcdjYWDdvYM+y5p3jFOsEVSS8m3Ed
   Q=;
X-IronPort-AV: E=Sophos;i="5.82,240,1613433600"; 
   d="scan'208";a="108989348"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 21 Apr 2021 13:07:09 +0000
Received: from EX13D01EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com (Postfix) with ESMTPS id 51BAEA05D5;
        Wed, 21 Apr 2021 13:07:08 +0000 (UTC)
Received: from 8c859063385e.ant.amazon.com (10.43.160.119) by
 EX13D01EUA001.ant.amazon.com (10.43.165.121) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 21 Apr 2021 13:07:05 +0000
Subject: [PATCH 1/8] uaccess: Add strict non-pagefault kernel-space read,
 function
From:   "Zidenberg, Tsahi" <tsahee@amazon.com>
To:     <stable@vger.kernel.org>
CC:     Greg KH <greg@kroah.com>
References: <dda18ffd-0406-ec54-1014-b7d89a1bcd56@amazon.com>
Message-ID: <2caa3d3d-9787-ab33-d68b-c39c079078c0@amazon.com>
Date:   Wed, 21 Apr 2021 16:07:00 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <dda18ffd-0406-ec54-1014-b7d89a1bcd56@amazon.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.43.160.119]
X-ClientProxiedBy: EX13D20UWC002.ant.amazon.com (10.43.162.163) To
 EX13D01EUA001.ant.amazon.com (10.43.165.121)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 75a1a607bb7e6d918be3aca11ec2214a275392f4 upstream

Add two new probe_kernel_read_strict() and strncpy_from_unsafe_strict()
helpers which by default alias to the __probe_kernel_read() and the
__strncpy_from_unsafe(), respectively, but can be overridden by archs
which have non-overlapping address ranges for kernel space and user
space in order to bail out with -EFAULT when attempting to probe user
memory including non-canonical user access addresses [0]:

  4-level page tables:
    user-space mem: 0x0000000000000000 - 0x00007fffffffffff
    non-canonical:  0x0000800000000000 - 0xffff7fffffffffff

  5-level page tables:
    user-space mem: 0x0000000000000000 - 0x00ffffffffffffff
    non-canonical:  0x0100000000000000 - 0xfeffffffffffffff

The idea is that these helpers are complementary to the probe_user_read()
and strncpy_from_unsafe_user() which probe user-only memory. Both added
helpers here do the same, but for kernel-only addresses.

Both set of helpers are going to be used for BPF tracing. They also
explicitly avoid throwing the splat for non-canonical user addresses from
00c42373d397 ("x86-64: add warning for non-canonical user access address
dereferences").

For compat, the current probe_kernel_read() and strncpy_from_unsafe() are
left as-is.

  [0] Documentation/x86/x86_64/mm.txt

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: x86@kernel.org
Link: https://lore.kernel.org/bpf/eefeefd769aa5a013531f491a71f0936779e916b.1572649915.git.daniel@iogearbox.net
Cc: <stable@vger.kernel.org> # 5.4
Signed-off-by: Tsahi Zidenberg <tsahee@amazon.com>
---
 arch/x86/mm/Makefile    |  2 +-
 arch/x86/mm/maccess.c   | 43 +++++++++++++++++++++++++++++++++++++++++
 include/linux/uaccess.h |  4 ++++
 mm/maccess.c            | 25 +++++++++++++++++++++++-
 4 files changed, 72 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/mm/maccess.c

diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 84373dc9b341..bbc68a54795e 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -13,7 +13,7 @@ CFLAGS_REMOVE_mem_encrypt_identity.o    = -pg
 endif
 
 obj-y    :=  init.o init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o \
-        pat.o pgtable.o physaddr.o setup_nx.o tlb.o cpu_entry_area.o
+        pat.o pgtable.o physaddr.o setup_nx.o tlb.o cpu_entry_area.o maccess.o
 
 # Make sure __phys_addr has no stackprotector
 nostackp := $(call cc-option, -fno-stack-protector)
diff --git a/arch/x86/mm/maccess.c b/arch/x86/mm/maccess.c
new file mode 100644
index 000000000000..f5b85bdc0535
--- /dev/null
+++ b/arch/x86/mm/maccess.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/uaccess.h>
+#include <linux/kernel.h>
+
+#ifdef CONFIG_X86_64
+static __always_inline u64 canonical_address(u64 vaddr, u8 vaddr_bits)
+{
+    return ((s64)vaddr << (64 - vaddr_bits)) >> (64 - vaddr_bits);
+}
+
+static __always_inline bool invalid_probe_range(u64 vaddr)
+{
+    /*
+     * Range covering the highest possible canonical userspace address
+     * as well as non-canonical address range. For the canonical range
+     * we also need to include the userspace guard page.
+     */
+    return vaddr < TASK_SIZE_MAX + PAGE_SIZE ||
+           canonical_address(vaddr, boot_cpu_data.x86_virt_bits) != vaddr;
+}
+#else
+static __always_inline bool invalid_probe_range(u64 vaddr)
+{
+    return vaddr < TASK_SIZE_MAX;
+}
+#endif
+
+long probe_kernel_read_strict(void *dst, const void *src, size_t size)
+{
+    if (unlikely(invalid_probe_range((unsigned long)src)))
+        return -EFAULT;
+
+    return __probe_kernel_read(dst, src, size);
+}
+
+long strncpy_from_unsafe_strict(char *dst, const void *unsafe_addr, long count)
+{
+    if (unlikely(invalid_probe_range((unsigned long)unsafe_addr)))
+        return -EFAULT;
+
+    return __strncpy_from_unsafe(dst, unsafe_addr, count);
+}
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 38555435a64a..67f016010aad 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -311,6 +311,7 @@ copy_struct_from_user(void *dst, size_t ksize, const void __user *src,
  * happens, handle that and return -EFAULT.
  */
 extern long probe_kernel_read(void *dst, const void *src, size_t size);
+extern long probe_kernel_read_strict(void *dst, const void *src, size_t size);
 extern long __probe_kernel_read(void *dst, const void *src, size_t size);
 
 /*
@@ -350,6 +351,9 @@ extern long notrace probe_user_write(void __user *dst, const void *src, size_t s
 extern long notrace __probe_user_write(void __user *dst, const void *src, size_t size);
 
 extern long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
+extern long strncpy_from_unsafe_strict(char *dst, const void *unsafe_addr,
+                       long count);
+extern long __strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
 extern long strncpy_from_unsafe_user(char *dst, const void __user *unsafe_addr,
                      long count);
 extern long strnlen_unsafe_user(const void __user *unsafe_addr, long count);
diff --git a/mm/maccess.c b/mm/maccess.c
index 2d3c3d01064c..3ca8d97e5010 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -43,11 +43,20 @@ probe_write_common(void __user *dst, const void *src, size_t size)
  * do_page_fault() doesn't attempt to take mmap_sem.  This makes
  * probe_kernel_read() suitable for use within regions where the caller
  * already holds mmap_sem, or other locks which nest inside mmap_sem.
+ *
+ * probe_kernel_read_strict() is the same as probe_kernel_read() except for
+ * the case where architectures have non-overlapping user and kernel address
+ * ranges: probe_kernel_read_strict() will additionally return -EFAULT for
+ * probing memory on a user address range where probe_user_read() is supposed
+ * to be used instead.
  */
 
 long __weak probe_kernel_read(void *dst, const void *src, size_t size)
     __attribute__((alias("__probe_kernel_read")));
 
+long __weak probe_kernel_read_strict(void *dst, const void *src, size_t size)
+    __attribute__((alias("__probe_kernel_read")));
+
 long __probe_kernel_read(void *dst, const void *src, size_t size)
 {
     long ret;
@@ -157,8 +166,22 @@ EXPORT_SYMBOL_GPL(probe_user_write);
  *
  * If @count is smaller than the length of the string, copies @count-1 bytes,
  * sets the last byte of @dst buffer to NUL and returns @count.
+ *
+ * strncpy_from_unsafe_strict() is the same as strncpy_from_unsafe() except
+ * for the case where architectures have non-overlapping user and kernel address
+ * ranges: strncpy_from_unsafe_strict() will additionally return -EFAULT for
+ * probing memory on a user address range where strncpy_from_unsafe_user() is
+ * supposed to be used instead.
  */
-long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
+
+long __weak strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
+    __attribute__((alias("__strncpy_from_unsafe")));
+
+long __weak strncpy_from_unsafe_strict(char *dst, const void *unsafe_addr,
+                       long count)
+    __attribute__((alias("__strncpy_from_unsafe")));
+
+long __strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
 {
     mm_segment_t old_fs = get_fs();
     const void *src = unsafe_addr;
-- 
2.25.1


