Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 558624E7420
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 14:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241721AbiCYNYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 09:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354539AbiCYNX6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 09:23:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E53D1CF9
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 06:22:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BABEF61A60
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 13:22:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE878C340E9;
        Fri, 25 Mar 2022 13:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648214536;
        bh=EmLUEYsU8VNn5bHrzMIL7qncZ9KcIzWXCCBYkiXdPxg=;
        h=Subject:To:Cc:From:Date:From;
        b=Ll7xfUOtlElwzkEikOV1cf5wVlX9qA942v4t5wRL6BRPQM03wEl6zUkxlUnKTIa+C
         At+bUeCN0+mrMX/kYi2EjhRx163+1mwza2+olovsTPzBuR9OnxbP7KESd/qnLdxWEj
         jlfFsEZYF+xZxbOu0qK6fmBcFRc26ToF4yeLAwM8=
Subject: FAILED: patch "[PATCH] uaccess: fix integer overflow on access_ok()" failed to apply to 5.10-stable tree
To:     arnd@arndb.de, David.Laight@aculab.com, hch@lst.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Mar 2022 14:22:05 +0100
Message-ID: <1648214525217167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 222ca305c9fd39e5ed8104da25c09b2b79a516a8 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 10 Feb 2022 16:24:30 +0100
Subject: [PATCH] uaccess: fix integer overflow on access_ok()

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

