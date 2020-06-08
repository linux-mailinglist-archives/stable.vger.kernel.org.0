Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1DA1F23B7
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgFHXPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:15:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730113AbgFHXPx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 612C72068D;
        Mon,  8 Jun 2020 23:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658152;
        bh=MHKAOiHm1Z/teYhb9wUwXXq39DjYnPrzae8tSGd604I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=md3CudH3/oyGTf8xwf8b3PJ3O3Y1A+3Gt3AgAD69MB8Xozrqs5ZjRWDdy/P8Y/py2
         aKLLMoJjgwgqmbtDfem5PyF1PHjSR08andugOHOlx7WY+YIbHHI4HoXryVKu7Apag4
         +VgHg+gBBJj8ikyJAL7QjaluhrVPXKL46DsRA7yM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 184/606] s390/pci: Fix s390_mmio_read/write with MIO
Date:   Mon,  8 Jun 2020 19:05:09 -0400
Message-Id: <20200608231211.3363633-184-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit f058599e22d59e594e5aae1dc10560568d8f4a8b upstream.

The s390_mmio_read/write syscalls are currently broken when running with
MIO.

The new pcistb_mio/pcstg_mio/pcilg_mio instructions are executed
similiarly to normal load/store instructions and do address translation
in the current address space. That means inside the kernel they are
aware of mappings into kernel address space while outside the kernel
they use user space mappings (usually created through mmap'ing a PCI
device file).

Now when existing user space applications use the s390_pci_mmio_write
and s390_pci_mmio_read syscalls, they pass I/O addresses that are mapped
into user space so as to be usable with the new instructions without
needing a syscall. Accessing these addresses with the old instructions
as done currently leads to a kernel panic.

Also, for such a user space mapping there may not exist an equivalent
kernel space mapping which means we can't just use the new instructions
in kernel space.

Instead of replicating user mappings in the kernel which then might
collide with other mappings, we can conceptually execute the new
instructions as if executed by the user space application using the
secondary address space. This even allows us to directly store to the
user pointer without the need for copy_to/from_user().

Cc: stable@vger.kernel.org
Fixes: 71ba41c9b1d9 ("s390/pci: provide support for MIO instructions")
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/pci_io.h |  10 +-
 arch/s390/pci/pci_mmio.c       | 213 ++++++++++++++++++++++++++++++++-
 2 files changed, 219 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/pci_io.h b/arch/s390/include/asm/pci_io.h
index cd060b5dd8fd..e4dc64cc9c55 100644
--- a/arch/s390/include/asm/pci_io.h
+++ b/arch/s390/include/asm/pci_io.h
@@ -8,6 +8,10 @@
 #include <linux/slab.h>
 #include <asm/pci_insn.h>
 
+/* I/O size constraints */
+#define ZPCI_MAX_READ_SIZE	8
+#define ZPCI_MAX_WRITE_SIZE	128
+
 /* I/O Map */
 #define ZPCI_IOMAP_SHIFT		48
 #define ZPCI_IOMAP_ADDR_BASE		0x8000000000000000UL
@@ -140,7 +144,8 @@ static inline int zpci_memcpy_fromio(void *dst,
 
 	while (n > 0) {
 		size = zpci_get_max_write_size((u64 __force) src,
-					       (u64) dst, n, 8);
+					       (u64) dst, n,
+					       ZPCI_MAX_READ_SIZE);
 		rc = zpci_read_single(dst, src, size);
 		if (rc)
 			break;
@@ -161,7 +166,8 @@ static inline int zpci_memcpy_toio(volatile void __iomem *dst,
 
 	while (n > 0) {
 		size = zpci_get_max_write_size((u64 __force) dst,
-					       (u64) src, n, 128);
+					       (u64) src, n,
+					       ZPCI_MAX_WRITE_SIZE);
 		if (size > 8) /* main path */
 			rc = zpci_write_block(dst, src, size);
 		else
diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
index 7d42a8794f10..020a2c514d96 100644
--- a/arch/s390/pci/pci_mmio.c
+++ b/arch/s390/pci/pci_mmio.c
@@ -11,6 +11,113 @@
 #include <linux/mm.h>
 #include <linux/errno.h>
 #include <linux/pci.h>
+#include <asm/pci_io.h>
+#include <asm/pci_debug.h>
+
+static inline void zpci_err_mmio(u8 cc, u8 status, u64 offset)
+{
+	struct {
+		u64 offset;
+		u8 cc;
+		u8 status;
+	} data = {offset, cc, status};
+
+	zpci_err_hex(&data, sizeof(data));
+}
+
+static inline int __pcistb_mio_inuser(
+		void __iomem *ioaddr, const void __user *src,
+		u64 len, u8 *status)
+{
+	int cc = -ENXIO;
+
+	asm volatile (
+		"       sacf 256\n"
+		"0:     .insn   rsy,0xeb00000000d4,%[len],%[ioaddr],%[src]\n"
+		"1:     ipm     %[cc]\n"
+		"       srl     %[cc],28\n"
+		"2:     sacf 768\n"
+		EX_TABLE(0b, 2b) EX_TABLE(1b, 2b)
+		: [cc] "+d" (cc), [len] "+d" (len)
+		: [ioaddr] "a" (ioaddr), [src] "Q" (*((u8 __force *)src))
+		: "cc", "memory");
+	*status = len >> 24 & 0xff;
+	return cc;
+}
+
+static inline int __pcistg_mio_inuser(
+		void __iomem *ioaddr, const void __user *src,
+		u64 ulen, u8 *status)
+{
+	register u64 addr asm("2") = (u64 __force) ioaddr;
+	register u64 len asm("3") = ulen;
+	int cc = -ENXIO;
+	u64 val = 0;
+	u64 cnt = ulen;
+	u8 tmp;
+
+	/*
+	 * copy 0 < @len <= 8 bytes from @src into the right most bytes of
+	 * a register, then store it to PCI at @ioaddr while in secondary
+	 * address space. pcistg then uses the user mappings.
+	 */
+	asm volatile (
+		"       sacf    256\n"
+		"0:     llgc    %[tmp],0(%[src])\n"
+		"       sllg    %[val],%[val],8\n"
+		"       aghi    %[src],1\n"
+		"       ogr     %[val],%[tmp]\n"
+		"       brctg   %[cnt],0b\n"
+		"1:     .insn   rre,0xb9d40000,%[val],%[ioaddr]\n"
+		"2:     ipm     %[cc]\n"
+		"       srl     %[cc],28\n"
+		"3:     sacf    768\n"
+		EX_TABLE(0b, 3b) EX_TABLE(1b, 3b) EX_TABLE(2b, 3b)
+		:
+		[src] "+a" (src), [cnt] "+d" (cnt),
+		[val] "+d" (val), [tmp] "=d" (tmp),
+		[len] "+d" (len), [cc] "+d" (cc),
+		[ioaddr] "+a" (addr)
+		:: "cc", "memory");
+	*status = len >> 24 & 0xff;
+
+	/* did we read everything from user memory? */
+	if (!cc && cnt != 0)
+		cc = -EFAULT;
+
+	return cc;
+}
+
+static inline int __memcpy_toio_inuser(void __iomem *dst,
+				   const void __user *src, size_t n)
+{
+	int size, rc = 0;
+	u8 status = 0;
+	mm_segment_t old_fs;
+
+	if (!src)
+		return -EINVAL;
+
+	old_fs = enable_sacf_uaccess();
+	while (n > 0) {
+		size = zpci_get_max_write_size((u64 __force) dst,
+					       (u64 __force) src, n,
+					       ZPCI_MAX_WRITE_SIZE);
+		if (size > 8) /* main path */
+			rc = __pcistb_mio_inuser(dst, src, size, &status);
+		else
+			rc = __pcistg_mio_inuser(dst, src, size, &status);
+		if (rc)
+			break;
+		src += size;
+		dst += size;
+		n -= size;
+	}
+	disable_sacf_uaccess(old_fs);
+	if (rc)
+		zpci_err_mmio(rc, status, (__force u64) dst);
+	return rc;
+}
 
 static long get_pfn(unsigned long user_addr, unsigned long access,
 		    unsigned long *pfn)
@@ -46,6 +153,20 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
 
 	if (length <= 0 || PAGE_SIZE - (mmio_addr & ~PAGE_MASK) < length)
 		return -EINVAL;
+
+	/*
+	 * Only support read access to MIO capable devices on a MIO enabled
+	 * system. Otherwise we would have to check for every address if it is
+	 * a special ZPCI_ADDR and we would have to do a get_pfn() which we
+	 * don't need for MIO capable devices.
+	 */
+	if (static_branch_likely(&have_mio)) {
+		ret = __memcpy_toio_inuser((void  __iomem *) mmio_addr,
+					user_buffer,
+					length);
+		return ret;
+	}
+
 	if (length > 64) {
 		buf = kmalloc(length, GFP_KERNEL);
 		if (!buf)
@@ -56,7 +177,8 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
 	ret = get_pfn(mmio_addr, VM_WRITE, &pfn);
 	if (ret)
 		goto out;
-	io_addr = (void __iomem *)((pfn << PAGE_SHIFT) | (mmio_addr & ~PAGE_MASK));
+	io_addr = (void __iomem *)((pfn << PAGE_SHIFT) |
+			(mmio_addr & ~PAGE_MASK));
 
 	ret = -EFAULT;
 	if ((unsigned long) io_addr < ZPCI_IOMAP_ADDR_BASE)
@@ -72,6 +194,78 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
 	return ret;
 }
 
+static inline int __pcilg_mio_inuser(
+		void __user *dst, const void __iomem *ioaddr,
+		u64 ulen, u8 *status)
+{
+	register u64 addr asm("2") = (u64 __force) ioaddr;
+	register u64 len asm("3") = ulen;
+	u64 cnt = ulen;
+	int shift = ulen * 8;
+	int cc = -ENXIO;
+	u64 val, tmp;
+
+	/*
+	 * read 0 < @len <= 8 bytes from the PCI memory mapped at @ioaddr (in
+	 * user space) into a register using pcilg then store these bytes at
+	 * user address @dst
+	 */
+	asm volatile (
+		"       sacf    256\n"
+		"0:     .insn   rre,0xb9d60000,%[val],%[ioaddr]\n"
+		"1:     ipm     %[cc]\n"
+		"       srl     %[cc],28\n"
+		"       ltr     %[cc],%[cc]\n"
+		"       jne     4f\n"
+		"2:     ahi     %[shift],-8\n"
+		"       srlg    %[tmp],%[val],0(%[shift])\n"
+		"3:     stc     %[tmp],0(%[dst])\n"
+		"       aghi    %[dst],1\n"
+		"       brctg   %[cnt],2b\n"
+		"4:     sacf    768\n"
+		EX_TABLE(0b, 4b) EX_TABLE(1b, 4b) EX_TABLE(3b, 4b)
+		:
+		[cc] "+d" (cc), [val] "=d" (val), [len] "+d" (len),
+		[dst] "+a" (dst), [cnt] "+d" (cnt), [tmp] "=d" (tmp),
+		[shift] "+d" (shift)
+		:
+		[ioaddr] "a" (addr)
+		: "cc", "memory");
+
+	/* did we write everything to the user space buffer? */
+	if (!cc && cnt != 0)
+		cc = -EFAULT;
+
+	*status = len >> 24 & 0xff;
+	return cc;
+}
+
+static inline int __memcpy_fromio_inuser(void __user *dst,
+				     const void __iomem *src,
+				     unsigned long n)
+{
+	int size, rc = 0;
+	u8 status;
+	mm_segment_t old_fs;
+
+	old_fs = enable_sacf_uaccess();
+	while (n > 0) {
+		size = zpci_get_max_write_size((u64 __force) src,
+					       (u64 __force) dst, n,
+					       ZPCI_MAX_READ_SIZE);
+		rc = __pcilg_mio_inuser(dst, src, size, &status);
+		if (rc)
+			break;
+		src += size;
+		dst += size;
+		n -= size;
+	}
+	disable_sacf_uaccess(old_fs);
+	if (rc)
+		zpci_err_mmio(rc, status, (__force u64) dst);
+	return rc;
+}
+
 SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned long, mmio_addr,
 		void __user *, user_buffer, size_t, length)
 {
@@ -86,12 +280,27 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned long, mmio_addr,
 
 	if (length <= 0 || PAGE_SIZE - (mmio_addr & ~PAGE_MASK) < length)
 		return -EINVAL;
+
+	/*
+	 * Only support write access to MIO capable devices on a MIO enabled
+	 * system. Otherwise we would have to check for every address if it is
+	 * a special ZPCI_ADDR and we would have to do a get_pfn() which we
+	 * don't need for MIO capable devices.
+	 */
+	if (static_branch_likely(&have_mio)) {
+		ret = __memcpy_fromio_inuser(
+				user_buffer, (const void __iomem *)mmio_addr,
+				length);
+		return ret;
+	}
+
 	if (length > 64) {
 		buf = kmalloc(length, GFP_KERNEL);
 		if (!buf)
 			return -ENOMEM;
-	} else
+	} else {
 		buf = local_buf;
+	}
 
 	ret = get_pfn(mmio_addr, VM_READ, &pfn);
 	if (ret)
-- 
2.25.1

