Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A04593A6A
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242533AbiHOTgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245322AbiHOTe6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:34:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C76C2FD0B;
        Mon, 15 Aug 2022 11:45:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DB86B8105C;
        Mon, 15 Aug 2022 18:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0198C433D7;
        Mon, 15 Aug 2022 18:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589123;
        bh=WKxmQw5pSQ28FOzZrvEX54gflyZ++1SZChqQlk4GO/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u/Oedxpmmq8U4vbGJWPZpTxDE8nvpUtYr5C//6IDv86UAVAjVxqCb6vqkEsxpgvL2
         KmPc1/LBxpR4XkzU6hn3iE8AxZVZu+5FCbeQxqrihETJBi5dGxb5TMPAwV54Zjn+n1
         L4YjALbvH0dFtiTK/HH87DKVbwSvUS4SouR3gHhk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 620/779] s390/maccess: fix semantics of memcpy_real() and its callers
Date:   Mon, 15 Aug 2022 20:04:24 +0200
Message-Id: <20220815180403.880300415@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 303fd988ed644c7daa260410f3ac99266573557d ]

There is a confusion with regard to the source address of
memcpy_real() and calling functions. While the declared
type for a source assumes a virtual address, in fact it
always called with physical address of the source.

This confusion led to bugs in copy_oldmem_kernel() and
copy_oldmem_user() functions, where __pa() macro applied
mistakenly to physical addresses. It does not lead to a
real issue, since virtual and physical addresses are
currently the same.

Fix both the bugs and memcpy_real() prototype by making
type of source address consistent to the function name
and the way it actually used.

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/os_info.h   |  2 +-
 arch/s390/include/asm/processor.h |  2 +-
 arch/s390/include/asm/uaccess.h   |  2 +-
 arch/s390/kernel/crash_dump.c     | 58 +++++++++++++++----------------
 arch/s390/kernel/os_info.c        |  7 ++--
 arch/s390/kernel/smp.c            |  2 +-
 arch/s390/mm/maccess.c            |  4 +--
 drivers/s390/char/zcore.c         |  3 +-
 8 files changed, 38 insertions(+), 42 deletions(-)

diff --git a/arch/s390/include/asm/os_info.h b/arch/s390/include/asm/os_info.h
index 3c89279d2a4b..147a8d547ef9 100644
--- a/arch/s390/include/asm/os_info.h
+++ b/arch/s390/include/asm/os_info.h
@@ -39,7 +39,7 @@ u32 os_info_csum(struct os_info *os_info);
 
 #ifdef CONFIG_CRASH_DUMP
 void *os_info_old_entry(int nr, unsigned long *size);
-int copy_oldmem_kernel(void *dst, void *src, size_t count);
+int copy_oldmem_kernel(void *dst, unsigned long src, size_t count);
 #else
 static inline void *os_info_old_entry(int nr, unsigned long *size)
 {
diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index 879b8e3f609c..e9db8efd50f2 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -318,7 +318,7 @@ extern void (*s390_base_pgm_handler_fn)(void);
 
 #define ARCH_LOW_ADDRESS_LIMIT	0x7fffffffUL
 
-extern int memcpy_real(void *, void *, size_t);
+extern int memcpy_real(void *, unsigned long, size_t);
 extern void memcpy_absolute(void *, void *, size_t);
 
 #define mem_assign_absolute(dest, val) do {			\
diff --git a/arch/s390/include/asm/uaccess.h b/arch/s390/include/asm/uaccess.h
index ce550d06abc3..3379694e9a42 100644
--- a/arch/s390/include/asm/uaccess.h
+++ b/arch/s390/include/asm/uaccess.h
@@ -245,7 +245,7 @@ static inline unsigned long __must_check clear_user(void __user *to, unsigned lo
 	return __clear_user(to, n);
 }
 
-int copy_to_user_real(void __user *dest, void *src, unsigned long count);
+int copy_to_user_real(void __user *dest, unsigned long src, unsigned long count);
 void *s390_kernel_write(void *dst, const void *src, size_t size);
 
 #define HAVE_GET_KERNEL_NOFAULT
diff --git a/arch/s390/kernel/crash_dump.c b/arch/s390/kernel/crash_dump.c
index 9c2597be28dc..199f136d1644 100644
--- a/arch/s390/kernel/crash_dump.c
+++ b/arch/s390/kernel/crash_dump.c
@@ -132,28 +132,27 @@ static inline void *load_real_addr(void *addr)
 /*
  * Copy memory of the old, dumped system to a kernel space virtual address
  */
-int copy_oldmem_kernel(void *dst, void *src, size_t count)
+int copy_oldmem_kernel(void *dst, unsigned long src, size_t count)
 {
-	unsigned long from, len;
+	unsigned long len;
 	void *ra;
 	int rc;
 
 	while (count) {
-		from = __pa(src);
-		if (!oldmem_data.start && from < sclp.hsa_size) {
+		if (!oldmem_data.start && src < sclp.hsa_size) {
 			/* Copy from zfcp/nvme dump HSA area */
-			len = min(count, sclp.hsa_size - from);
-			rc = memcpy_hsa_kernel(dst, from, len);
+			len = min(count, sclp.hsa_size - src);
+			rc = memcpy_hsa_kernel(dst, src, len);
 			if (rc)
 				return rc;
 		} else {
 			/* Check for swapped kdump oldmem areas */
-			if (oldmem_data.start && from - oldmem_data.start < oldmem_data.size) {
-				from -= oldmem_data.start;
-				len = min(count, oldmem_data.size - from);
-			} else if (oldmem_data.start && from < oldmem_data.size) {
-				len = min(count, oldmem_data.size - from);
-				from += oldmem_data.start;
+			if (oldmem_data.start && src - oldmem_data.start < oldmem_data.size) {
+				src -= oldmem_data.start;
+				len = min(count, oldmem_data.size - src);
+			} else if (oldmem_data.start && src < oldmem_data.size) {
+				len = min(count, oldmem_data.size - src);
+				src += oldmem_data.start;
 			} else {
 				len = count;
 			}
@@ -163,7 +162,7 @@ int copy_oldmem_kernel(void *dst, void *src, size_t count)
 			} else {
 				ra = dst;
 			}
-			if (memcpy_real(ra, (void *) from, len))
+			if (memcpy_real(ra, src, len))
 				return -EFAULT;
 		}
 		dst += len;
@@ -176,31 +175,30 @@ int copy_oldmem_kernel(void *dst, void *src, size_t count)
 /*
  * Copy memory of the old, dumped system to a user space virtual address
  */
-static int copy_oldmem_user(void __user *dst, void *src, size_t count)
+static int copy_oldmem_user(void __user *dst, unsigned long src, size_t count)
 {
-	unsigned long from, len;
+	unsigned long len;
 	int rc;
 
 	while (count) {
-		from = __pa(src);
-		if (!oldmem_data.start && from < sclp.hsa_size) {
+		if (!oldmem_data.start && src < sclp.hsa_size) {
 			/* Copy from zfcp/nvme dump HSA area */
-			len = min(count, sclp.hsa_size - from);
-			rc = memcpy_hsa_user(dst, from, len);
+			len = min(count, sclp.hsa_size - src);
+			rc = memcpy_hsa_user(dst, src, len);
 			if (rc)
 				return rc;
 		} else {
 			/* Check for swapped kdump oldmem areas */
-			if (oldmem_data.start && from - oldmem_data.start < oldmem_data.size) {
-				from -= oldmem_data.start;
-				len = min(count, oldmem_data.size - from);
-			} else if (oldmem_data.start && from < oldmem_data.size) {
-				len = min(count, oldmem_data.size - from);
-				from += oldmem_data.start;
+			if (oldmem_data.start && src - oldmem_data.start < oldmem_data.size) {
+				src -= oldmem_data.start;
+				len = min(count, oldmem_data.size - src);
+			} else if (oldmem_data.start && src < oldmem_data.size) {
+				len = min(count, oldmem_data.size - src);
+				src += oldmem_data.start;
 			} else {
 				len = count;
 			}
-			rc = copy_to_user_real(dst, (void *) from, count);
+			rc = copy_to_user_real(dst, src, count);
 			if (rc)
 				return rc;
 		}
@@ -217,12 +215,12 @@ static int copy_oldmem_user(void __user *dst, void *src, size_t count)
 ssize_t copy_oldmem_page(unsigned long pfn, char *buf, size_t csize,
 			 unsigned long offset, int userbuf)
 {
-	void *src;
+	unsigned long src;
 	int rc;
 
 	if (!csize)
 		return 0;
-	src = (void *) (pfn << PAGE_SHIFT) + offset;
+	src = pfn_to_phys(pfn) + offset;
 	if (userbuf)
 		rc = copy_oldmem_user((void __force __user *) buf, src, csize);
 	else
@@ -429,10 +427,10 @@ static void *nt_prpsinfo(void *ptr)
 static void *get_vmcoreinfo_old(unsigned long *size)
 {
 	char nt_name[11], *vmcoreinfo;
+	unsigned long addr;
 	Elf64_Nhdr note;
-	void *addr;
 
-	if (copy_oldmem_kernel(&addr, (void *)__LC_VMCORE_INFO, sizeof(addr)))
+	if (copy_oldmem_kernel(&addr, __LC_VMCORE_INFO, sizeof(addr)))
 		return NULL;
 	memset(nt_name, 0, sizeof(nt_name));
 	if (copy_oldmem_kernel(&note, addr, sizeof(note)))
diff --git a/arch/s390/kernel/os_info.c b/arch/s390/kernel/os_info.c
index 198f9694e439..e548844dde28 100644
--- a/arch/s390/kernel/os_info.c
+++ b/arch/s390/kernel/os_info.c
@@ -91,7 +91,7 @@ static void os_info_old_alloc(int nr, int align)
 		goto fail;
 	}
 	buf_align = PTR_ALIGN(buf, align);
-	if (copy_oldmem_kernel(buf_align, (void *) addr, size)) {
+	if (copy_oldmem_kernel(buf_align, addr, size)) {
 		msg = "copy failed";
 		goto fail_free;
 	}
@@ -124,15 +124,14 @@ static void os_info_old_init(void)
 		return;
 	if (!oldmem_data.start)
 		goto fail;
-	if (copy_oldmem_kernel(&addr, (void *)__LC_OS_INFO, sizeof(addr)))
+	if (copy_oldmem_kernel(&addr, __LC_OS_INFO, sizeof(addr)))
 		goto fail;
 	if (addr == 0 || addr % PAGE_SIZE)
 		goto fail;
 	os_info_old = kzalloc(sizeof(*os_info_old), GFP_KERNEL);
 	if (!os_info_old)
 		goto fail;
-	if (copy_oldmem_kernel(os_info_old, (void *) addr,
-			       sizeof(*os_info_old)))
+	if (copy_oldmem_kernel(os_info_old, addr, sizeof(*os_info_old)))
 		goto fail_free;
 	if (os_info_old->magic != OS_INFO_MAGIC)
 		goto fail_free;
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 1a04e5bdf655..e57eb2260b90 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -675,7 +675,7 @@ static __init void smp_save_cpu_regs(struct save_area *sa, u16 addr,
 	void *regs = (void *) page;
 
 	if (is_boot_cpu)
-		copy_oldmem_kernel(regs, (void *) __LC_FPREGS_SAVE_AREA, 512);
+		copy_oldmem_kernel(regs, __LC_FPREGS_SAVE_AREA, 512);
 	else
 		__pcpu_sigp_relax(addr, SIGP_STORE_STATUS_AT_ADDRESS, page);
 	save_area_add_regs(sa, regs);
diff --git a/arch/s390/mm/maccess.c b/arch/s390/mm/maccess.c
index 9663ce3625bc..2ed198b4f7d0 100644
--- a/arch/s390/mm/maccess.c
+++ b/arch/s390/mm/maccess.c
@@ -123,7 +123,7 @@ static unsigned long __no_sanitize_address _memcpy_real(unsigned long dest,
 /*
  * Copy memory in real mode (kernel to kernel)
  */
-int memcpy_real(void *dest, void *src, size_t count)
+int memcpy_real(void *dest, unsigned long src, size_t count)
 {
 	unsigned long _dest  = (unsigned long)dest;
 	unsigned long _src   = (unsigned long)src;
@@ -175,7 +175,7 @@ void memcpy_absolute(void *dest, void *src, size_t count)
 /*
  * Copy memory from kernel (real) to user (virtual)
  */
-int copy_to_user_real(void __user *dest, void *src, unsigned long count)
+int copy_to_user_real(void __user *dest, unsigned long src, unsigned long count)
 {
 	int offs = 0, size, rc;
 	char *buf;
diff --git a/drivers/s390/char/zcore.c b/drivers/s390/char/zcore.c
index 3ba2d934a3e8..516783ba950f 100644
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -229,8 +229,7 @@ static int __init zcore_reipl_init(void)
 		rc = memcpy_hsa_kernel(zcore_ipl_block, ipib_info.ipib,
 				       PAGE_SIZE);
 	else
-		rc = memcpy_real(zcore_ipl_block, (void *) ipib_info.ipib,
-				 PAGE_SIZE);
+		rc = memcpy_real(zcore_ipl_block, ipib_info.ipib, PAGE_SIZE);
 	if (rc || (__force u32)csum_partial(zcore_ipl_block, zcore_ipl_block->hdr.len, 0) !=
 	    ipib_info.checksum) {
 		TRACE("Checksum does not match\n");
-- 
2.35.1



