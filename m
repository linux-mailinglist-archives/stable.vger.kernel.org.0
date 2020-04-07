Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4359A1A0351
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 02:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgDGAIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 20:08:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726787AbgDGABY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Apr 2020 20:01:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF90D20768;
        Tue,  7 Apr 2020 00:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217683;
        bh=3Vs63+aEjIvgdM5+/6W7uU0ycfp6fA/ZX0hVu/dRn94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VEBg6EqBs0ZMaJfS4wZWSYKtfGDA3hwRcOBkbx+r8DYeAX9lvSk31vwgGd+vxsKNp
         h/TbUay/BszzZuEWBtQQvCNx/uCTE9MxM0noXLP0FKKjrpH6IDuE78e9KXaWV7LR+F
         vsjfbuVHCcOm9JCUzUC51a49AbiROy+7M2HuKYz4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greentime Hu <greentime.hu@sifive.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 19/35] riscv: uaccess should be used in nommu mode
Date:   Mon,  6 Apr 2020 20:00:41 -0400
Message-Id: <20200407000058.16423-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000058.16423-1-sashal@kernel.org>
References: <20200407000058.16423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greentime Hu <greentime.hu@sifive.com>

[ Upstream commit adccfb1a805ea84d2db38eb53032533279bdaa97 ]

It might have the unaligned access exception when trying to exchange data
with user space program. In this case, it failed in tty_ioctl(). Therefore
we should enable uaccess.S for NOMMU mode since the generic code doesn't
handle the unaligned access cases.

   0x8013a212 <tty_ioctl+462>:  ld      a5,460(s1)

[    0.115279] Oops - load address misaligned [#1]
[    0.115284] CPU: 0 PID: 29 Comm: sh Not tainted 5.4.0-rc5-00020-gb4c27160d562-dirty #36
[    0.115294] epc: 000000008013a212 ra : 000000008013a212 sp : 000000008f48dd50
[    0.115303]  gp : 00000000801cac28 tp : 000000008fb80000 t0 : 00000000000000e8
[    0.115312]  t1 : 000000008f58f108 t2 : 0000000000000009 s0 : 000000008f48ddf0
[    0.115321]  s1 : 000000008f8c6220 a0 : 0000000000000001 a1 : 000000008f48dd28
[    0.115330]  a2 : 000000008fb80000 a3 : 00000000801a7398 a4 : 0000000000000000
[    0.115339]  a5 : 0000000000000000 a6 : 000000008f58f0c6 a7 : 000000000000001d
[    0.115348]  s2 : 000000008f8c6308 s3 : 000000008f78b7c8 s4 : 000000008fb834c0
[    0.115357]  s5 : 0000000000005413 s6 : 0000000000000000 s7 : 000000008f58f2b0
[    0.115366]  s8 : 000000008f858008 s9 : 000000008f776818 s10: 000000008f776830
[    0.115375]  s11: 000000008fb840a8 t3 : 1999999999999999 t4 : 000000008f78704c
[    0.115384]  t5 : 0000000000000005 t6 : 0000000000000002
[    0.115391] status: 0000000200001880 badaddr: 000000008f8c63ec cause: 0000000000000004
[    0.115401] ---[ end trace 00d490c6a8b6c9ac ]---

This failure could be fixed after this patch applied.

[    0.002282] Run /init as init process
Initializing random number generator... [    0.005573] random: dd: uninitialized urandom read (512 bytes read)
done.

Welcome to Buildroot
buildroot login: root
Password:
Jan  1 00:00:00 login[62]: root login on 'ttySIF0'
~ #

Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Reviewed-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/Kconfig               |  1 -
 arch/riscv/include/asm/uaccess.h | 36 ++++++++++++++++----------------
 arch/riscv/lib/Makefile          |  2 +-
 3 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 1be11c23fa335..50cfa272f9e3d 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -52,7 +52,6 @@ config RISCV
 	select PCI_DOMAINS_GENERIC if PCI
 	select PCI_MSI if PCI
 	select RISCV_TIMER
-	select UACCESS_MEMCPY if !MMU
 	select GENERIC_IRQ_MULTI_HANDLER
 	select GENERIC_ARCH_TOPOLOGY if SMP
 	select ARCH_HAS_PTE_SPECIAL
diff --git a/arch/riscv/include/asm/uaccess.h b/arch/riscv/include/asm/uaccess.h
index f462a183a9c23..8ce9d607b53dc 100644
--- a/arch/riscv/include/asm/uaccess.h
+++ b/arch/riscv/include/asm/uaccess.h
@@ -11,6 +11,24 @@
 /*
  * User space memory access functions
  */
+
+extern unsigned long __must_check __asm_copy_to_user(void __user *to,
+	const void *from, unsigned long n);
+extern unsigned long __must_check __asm_copy_from_user(void *to,
+	const void __user *from, unsigned long n);
+
+static inline unsigned long
+raw_copy_from_user(void *to, const void __user *from, unsigned long n)
+{
+	return __asm_copy_from_user(to, from, n);
+}
+
+static inline unsigned long
+raw_copy_to_user(void __user *to, const void *from, unsigned long n)
+{
+	return __asm_copy_to_user(to, from, n);
+}
+
 #ifdef CONFIG_MMU
 #include <linux/errno.h>
 #include <linux/compiler.h>
@@ -367,24 +385,6 @@ do {								\
 		-EFAULT;					\
 })
 
-
-extern unsigned long __must_check __asm_copy_to_user(void __user *to,
-	const void *from, unsigned long n);
-extern unsigned long __must_check __asm_copy_from_user(void *to,
-	const void __user *from, unsigned long n);
-
-static inline unsigned long
-raw_copy_from_user(void *to, const void __user *from, unsigned long n)
-{
-	return __asm_copy_from_user(to, from, n);
-}
-
-static inline unsigned long
-raw_copy_to_user(void __user *to, const void *from, unsigned long n)
-{
-	return __asm_copy_to_user(to, from, n);
-}
-
 extern long strncpy_from_user(char *dest, const char __user *src, long count);
 
 extern long __must_check strlen_user(const char __user *str);
diff --git a/arch/riscv/lib/Makefile b/arch/riscv/lib/Makefile
index 47e7a82044608..0d0db80800c4e 100644
--- a/arch/riscv/lib/Makefile
+++ b/arch/riscv/lib/Makefile
@@ -2,5 +2,5 @@
 lib-y			+= delay.o
 lib-y			+= memcpy.o
 lib-y			+= memset.o
-lib-$(CONFIG_MMU)	+= uaccess.o
+lib-y			+= uaccess.o
 lib-$(CONFIG_64BIT)	+= tishift.o
-- 
2.20.1

