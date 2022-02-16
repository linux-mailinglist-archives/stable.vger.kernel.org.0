Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEAB14B88B0
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 14:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbiBPNQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 08:16:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiBPNQG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 08:16:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E6B2731E3;
        Wed, 16 Feb 2022 05:15:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE57A6165A;
        Wed, 16 Feb 2022 13:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B6BC004E1;
        Wed, 16 Feb 2022 13:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645017353;
        bh=dnkJIXtWvebNCasCXkRnJYZ7sRLI8mvE+toudMu0he4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mbkiU5PLLn4NDIE1XXLiEo1F9hdUdlYNtT43C6pnWMSMEnNcHeJT08TjKBv9wlavO
         TQIHyKwAX3Q9yO2QLTbU3OYm3uPc3/YkZ7pvQBmT2THInQo7TYroawkDZaAXL5vyhh
         FllPpmvpmlFK45kZzrO4qDSCsDu3EPqfKeJG9TFGZya4fxeNHv6Rte483uYLNxYD13
         uQuYSntQKyv0TTj0RFsVxxEjWwl8zLgAtYDmfXlqvhM3RTaEiIW4u8rxBHtNMi1TA2
         hi7WMFYafgmDnF458kFmL7tjX5qbqMQ6ZZzVXXp+YJKjhVUKCguz4UEfdreoEfaVtr
         MztkrmPVbc3qw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, linux-api@vger.kernel.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Cc:     linux@armlinux.org.uk, will@kernel.org, guoren@kernel.org,
        bcain@codeaurora.org, geert@linux-m68k.org, monstr@monstr.eu,
        tsbogend@alpha.franken.de, nickhu@andestech.com,
        green.hu@gmail.com, dinguyen@kernel.org, shorne@gmail.com,
        deller@gmx.de, mpe@ellerman.id.au, peterz@infradead.org,
        mingo@redhat.com, mark.rutland@arm.com, hca@linux.ibm.com,
        dalias@libc.org, davem@davemloft.net, richard@nod.at,
        x86@kernel.org, jcmvbkbc@gmail.com, ebiederm@xmission.com,
        akpm@linux-foundation.org, ardb@kernel.org,
        linux-alpha@vger.kernel.org, linux-snps-arc@lists.infradead.org,
        linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linux-mips@vger.kernel.org, openrisc@lists.librecores.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-um@lists.infradead.org, linux-xtensa@linux-xtensa.org,
        stable@vger.kernel.org, David Laight <David.Laight@aculab.com>
Subject: [PATCH v2 01/18] uaccess: fix integer overflow on access_ok()
Date:   Wed, 16 Feb 2022 14:13:15 +0100
Message-Id: <20220216131332.1489939-2-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220216131332.1489939-1-arnd@kernel.org>
References: <20220216131332.1489939-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Three architectures check the end of a user access against the
address limit without taking a possible overflow into account.
Passing a negative length or another overflow in here returns
success when it should not.

Use the most common correct implementation here, which optimizes
for a constant 'size' argument, and turns the common case into a
single comparison.

Cc: stable@vger.kernel.org
Fixes: da551281947c ("csky: User access")
Fixes: f663b60f5215 ("microblaze: Fix uaccess_ok macro")
Fixes: 7567746e1c0d ("Hexagon: Add user access functions")
Reported-by: David Laight <David.Laight@aculab.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/csky/include/asm/uaccess.h       |  7 +++----
 arch/hexagon/include/asm/uaccess.h    | 18 +++++++++---------
 arch/microblaze/include/asm/uaccess.h | 19 ++++---------------
 3 files changed, 16 insertions(+), 28 deletions(-)

diff --git a/arch/csky/include/asm/uaccess.h b/arch/csky/include/asm/uaccess.h
index c40f06ee8d3e..ac5a54f57d40 100644
--- a/arch/csky/include/asm/uaccess.h
+++ b/arch/csky/include/asm/uaccess.h
@@ -3,14 +3,13 @@
 #ifndef __ASM_CSKY_UACCESS_H
 #define __ASM_CSKY_UACCESS_H
 
-#define user_addr_max() \
-	(uaccess_kernel() ? KERNEL_DS.seg : get_fs().seg)
+#define user_addr_max() (current_thread_info()->addr_limit.seg)
 
 static inline int __access_ok(unsigned long addr, unsigned long size)
 {
-	unsigned long limit = current_thread_info()->addr_limit.seg;
+	unsigned long limit = user_addr_max();
 
-	return ((addr < limit) && ((addr + size) < limit));
+	return (size <= limit) && (addr <= (limit - size));
 }
 #define __access_ok __access_ok
 
diff --git a/arch/hexagon/include/asm/uaccess.h b/arch/hexagon/include/asm/uaccess.h
index ef5bfef8d490..719ba3f3c45c 100644
--- a/arch/hexagon/include/asm/uaccess.h
+++ b/arch/hexagon/include/asm/uaccess.h
@@ -25,17 +25,17 @@
  * Returns true (nonzero) if the memory block *may* be valid, false (zero)
  * if it is definitely invalid.
  *
- * User address space in Hexagon, like x86, goes to 0xbfffffff, so the
- * simple MSB-based tests used by MIPS won't work.  Some further
- * optimization is probably possible here, but for now, keep it
- * reasonably simple and not *too* slow.  After all, we've got the
- * MMU for backup.
  */
+#define uaccess_kernel() (get_fs().seg == KERNEL_DS.seg)
+#define user_addr_max() (uaccess_kernel() ? ~0UL : TASK_SIZE)
 
-#define __access_ok(addr, size) \
-	((get_fs().seg == KERNEL_DS.seg) || \
-	(((unsigned long)addr < get_fs().seg) && \
-	  (unsigned long)size < (get_fs().seg - (unsigned long)addr)))
+static inline int __access_ok(unsigned long addr, unsigned long size)
+{
+	unsigned long limit = TASK_SIZE;
+
+	return (size <= limit) && (addr <= (limit - size));
+}
+#define __access_ok __access_ok
 
 /*
  * When a kernel-mode page fault is taken, the faulting instruction
diff --git a/arch/microblaze/include/asm/uaccess.h b/arch/microblaze/include/asm/uaccess.h
index d2a8ef9f8978..5b6e0e7788f4 100644
--- a/arch/microblaze/include/asm/uaccess.h
+++ b/arch/microblaze/include/asm/uaccess.h
@@ -39,24 +39,13 @@
 
 # define uaccess_kernel()	(get_fs().seg == KERNEL_DS.seg)
 
-static inline int access_ok(const void __user *addr, unsigned long size)
+static inline int __access_ok(unsigned long addr, unsigned long size)
 {
-	if (!size)
-		goto ok;
+	unsigned long limit = user_addr_max();
 
-	if ((get_fs().seg < ((unsigned long)addr)) ||
-			(get_fs().seg < ((unsigned long)addr + size - 1))) {
-		pr_devel("ACCESS fail at 0x%08x (size 0x%x), seg 0x%08x\n",
-			(__force u32)addr, (u32)size,
-			(u32)get_fs().seg);
-		return 0;
-	}
-ok:
-	pr_devel("ACCESS OK at 0x%08x (size 0x%x), seg 0x%08x\n",
-			(__force u32)addr, (u32)size,
-			(u32)get_fs().seg);
-	return 1;
+	return (size <= limit) && (addr <= (limit - size));
 }
+#define access_ok(addr, size) __access_ok((unsigned long)addr, size)
 
 # define __FIXUP_SECTION	".section .fixup,\"ax\"\n"
 # define __EX_TABLE_SECTION	".section __ex_table,\"a\"\n"
-- 
2.29.2

