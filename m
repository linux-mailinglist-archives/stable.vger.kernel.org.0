Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE3C629F70
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 17:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbiKOQp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 11:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbiKOQp4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 11:45:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3AC1E3E9
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 08:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668530698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=f6ZRgTNQMjHS0d3pTO0gBFEybzft8PH/GYU0cDN1up4=;
        b=T8oFxcyrVrDNnWVBxAyG8VGpYL6adI2hRzNtn1g8gLlzTHn4Md9rdntli+dr3vN8BpIV7p
        GUdREEjEjcjhZrYb4R8NkPMNLfFYRBm6krhxcaDNhF1O/sjZBmiuBPxxWtotME/woqRoMN
        Oe4ITxQAS/l7U/Zs652tT0rtswiAjdM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-277-sSYKG-gOMU2n-1KJ-B0N-w-1; Tue, 15 Nov 2022 11:44:56 -0500
X-MC-Unique: sSYKG-gOMU2n-1KJ-B0N-w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6AC12185A792;
        Tue, 15 Nov 2022 16:44:56 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 665E24EA49;
        Tue, 15 Nov 2022 16:44:56 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 2AFGiupZ001742;
        Tue, 15 Nov 2022 11:44:56 -0500
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 2AFGiueh001738;
        Tue, 15 Nov 2022 11:44:56 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 15 Nov 2022 11:44:56 -0500 (EST)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Greg KH <gregkh@linuxfoundation.org>
cc:     stable@vger.kernel.org
Subject: [PATCH 5.15 3/3] provide arch_test_bit_acquire for architectures
 that define test_bit
Message-ID: <alpine.LRH.2.21.2211151144190.32285@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit d6ffe6067a54972564552ea45d320fb98db1ac5e upstream.

Some architectures define their own arch_test_bit and they also need
arch_test_bit_acquire, otherwise they won't compile.  We also clean up
the code by using the generic test_bit if that is equivalent to the
arch-specific version.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 8238b4579866 ("wait_on_bit: add an acquire memory barrier")
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

---
 arch/alpha/include/asm/bitops.h   |    8 +++-----
 arch/h8300/include/asm/bitops.h   |    3 ++-
 arch/hexagon/include/asm/bitops.h |   15 +++++++++++++++
 arch/ia64/include/asm/bitops.h    |    8 +++-----
 arch/m68k/include/asm/bitops.h    |    8 +++-----
 arch/s390/include/asm/bitops.h    |   11 +++--------
 arch/sh/include/asm/bitops-op32.h |   11 ++---------
 7 files changed, 31 insertions(+), 33 deletions(-)

Index: linux-stable/arch/alpha/include/asm/bitops.h
===================================================================
--- linux-stable.orig/arch/alpha/include/asm/bitops.h	2022-11-14 22:17:32.000000000 +0100
+++ linux-stable/arch/alpha/include/asm/bitops.h	2022-11-14 22:17:32.000000000 +0100
@@ -8,6 +8,7 @@
 
 #include <asm/compiler.h>
 #include <asm/barrier.h>
+#include <asm-generic/bitops/generic-non-atomic.h>
 
 /*
  * Copyright 1994, Linus Torvalds.
@@ -283,11 +284,8 @@ __test_and_change_bit(unsigned long nr,
 	return (old & mask) != 0;
 }
 
-static inline int
-test_bit(int nr, const volatile void * addr)
-{
-	return (1UL & (((const int *) addr)[nr >> 5] >> (nr & 31))) != 0UL;
-}
+#define test_bit generic_test_bit
+#define test_bit_acquire generic_test_bit_acquire
 
 /*
  * ffz = Find First Zero in word. Undefined if no zero exists,
Index: linux-stable/arch/hexagon/include/asm/bitops.h
===================================================================
--- linux-stable.orig/arch/hexagon/include/asm/bitops.h	2022-11-14 22:17:32.000000000 +0100
+++ linux-stable/arch/hexagon/include/asm/bitops.h	2022-11-14 22:17:32.000000000 +0100
@@ -172,7 +172,22 @@ static inline int __test_bit(int nr, con
 	return retval;
 }
 
+static inline int __test_bit_acquire(int nr, const volatile unsigned long *addr)
+{
+	int retval;
+
+	asm volatile(
+	"{P0 = tstbit(%1,%2); if (P0.new) %0 = #1; if (!P0.new) %0 = #0;}\n"
+	: "=&r" (retval)
+	: "r" (addr[BIT_WORD(nr)]), "r" (nr % BITS_PER_LONG)
+	: "p0", "memory"
+	);
+
+	return retval;
+}
+
 #define test_bit(nr, addr) __test_bit(nr, addr)
+#define test_bit_acquire(nr, addr) __test_bit_acquire(nr, addr)
 
 /*
  * ffz - find first zero in word.
Index: linux-stable/arch/ia64/include/asm/bitops.h
===================================================================
--- linux-stable.orig/arch/ia64/include/asm/bitops.h	2022-11-14 22:17:32.000000000 +0100
+++ linux-stable/arch/ia64/include/asm/bitops.h	2022-11-14 22:17:32.000000000 +0100
@@ -18,6 +18,7 @@
 #include <linux/types.h>
 #include <asm/intrinsics.h>
 #include <asm/barrier.h>
+#include <asm-generic/bitops/generic-non-atomic.h>
 
 /**
  * set_bit - Atomically set a bit in memory
@@ -331,11 +332,8 @@ __test_and_change_bit (int nr, void *add
 	return (old & bit) != 0;
 }
 
-static __inline__ int
-test_bit (int nr, const volatile void *addr)
-{
-	return 1 & (((const volatile __u32 *) addr)[nr >> 5] >> (nr & 31));
-}
+#define test_bit generic_test_bit
+#define test_bit_acquire generic_test_bit_acquire
 
 /**
  * ffz - find the first zero bit in a long word
Index: linux-stable/arch/m68k/include/asm/bitops.h
===================================================================
--- linux-stable.orig/arch/m68k/include/asm/bitops.h	2022-11-14 22:17:32.000000000 +0100
+++ linux-stable/arch/m68k/include/asm/bitops.h	2022-11-14 22:17:32.000000000 +0100
@@ -14,6 +14,7 @@
 
 #include <linux/compiler.h>
 #include <asm/barrier.h>
+#include <asm-generic/bitops/generic-non-atomic.h>
 
 /*
  *	Bit access functions vary across the ColdFire and 68k families.
@@ -148,11 +149,8 @@ static inline void bfchg_mem_change_bit(
 #define __change_bit(nr, vaddr)	change_bit(nr, vaddr)
 
 
-static inline int test_bit(int nr, const volatile unsigned long *vaddr)
-{
-	return (vaddr[nr >> 5] & (1UL << (nr & 31))) != 0;
-}
-
+#define test_bit generic_test_bit
+#define test_bit_acquire generic_test_bit_acquire
 
 static inline int bset_reg_test_and_set_bit(int nr,
 					    volatile unsigned long *vaddr)
Index: linux-stable/arch/s390/include/asm/bitops.h
===================================================================
--- linux-stable.orig/arch/s390/include/asm/bitops.h	2022-11-14 22:17:32.000000000 +0100
+++ linux-stable/arch/s390/include/asm/bitops.h	2022-11-14 22:17:32.000000000 +0100
@@ -38,6 +38,7 @@
 #include <linux/types.h>
 #include <asm/atomic_ops.h>
 #include <asm/barrier.h>
+#include <asm-generic/bitops/generic-non-atomic.h>
 
 #define __BITOPS_WORDS(bits) (((bits) + BITS_PER_LONG - 1) / BITS_PER_LONG)
 
@@ -175,14 +176,8 @@ static inline bool arch___test_and_chang
 	return old & mask;
 }
 
-static inline bool arch_test_bit(unsigned long nr,
-				 const volatile unsigned long *ptr)
-{
-	const volatile unsigned long *addr = __bitops_word(nr, ptr);
-	unsigned long mask = __bitops_mask(nr);
-
-	return *addr & mask;
-}
+#define arch_test_bit generic_test_bit
+#define arch_test_bit_acquire generic_test_bit_acquire
 
 static inline bool arch_test_and_set_bit_lock(unsigned long nr,
 					      volatile unsigned long *ptr)
Index: linux-stable/arch/sh/include/asm/bitops-op32.h
===================================================================
--- linux-stable.orig/arch/sh/include/asm/bitops-op32.h	2022-11-14 22:17:32.000000000 +0100
+++ linux-stable/arch/sh/include/asm/bitops-op32.h	2022-11-14 22:17:32.000000000 +0100
@@ -128,14 +128,7 @@ static inline int __test_and_change_bit(
 	return (old & mask) != 0;
 }
 
-/**
- * test_bit - Determine whether a bit is set
- * @nr: bit number to test
- * @addr: Address to start counting from
- */
-static inline int test_bit(int nr, const volatile unsigned long *addr)
-{
-	return 1UL & (addr[BIT_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
-}
+#define test_bit generic_test_bit
+#define test_bit_acquire generic_test_bit_acquire
 
 #endif /* __ASM_SH_BITOPS_OP32_H */
Index: linux-stable/arch/h8300/include/asm/bitops.h
===================================================================
--- linux-stable.orig/arch/h8300/include/asm/bitops.h	2022-11-14 22:17:32.000000000 +0100
+++ linux-stable/arch/h8300/include/asm/bitops.h	2022-11-14 22:17:32.000000000 +0100
@@ -87,7 +87,8 @@ static inline int test_bit(int nr, const
 	return ret;
 }
 
-#define __test_bit(nr, addr) test_bit(nr, addr)
+#define __test_bit(nr, addr)		test_bit(nr, addr)
+#define test_bit_acquire(nr, addr)	test_bit(nr, addr)
 
 #define H8300_GEN_TEST_BITOP(FNNAME, OP)				\
 static inline int FNNAME(int nr, void *addr)				\

