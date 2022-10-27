Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463DF60F7A6
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 14:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbiJ0MmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 08:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbiJ0MmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 08:42:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F146E3AB10
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 05:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666874527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=21v+kGZYRTzWROiSgmVDRAstxK45zqJCCp/cHB/x46s=;
        b=XhDzR2GCRzj7nzG3kvnbbfcCPHl/p4hxmHhldQ5bRCIEbCrBB/tEcG1wotasXQ7kjvJu/7
        OeU4XAdaMpUEIvrcsWFIvlO4t3JXsNEdYWFYpdNY3ARxSTxKqDNbKMsKIuoTzAyy06tp6y
        luAluMmGrwfGDdIR+OkVBCini92HRv4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-srQpX1c_Mz-DeV7Whut1xg-1; Thu, 27 Oct 2022 08:42:05 -0400
X-MC-Unique: srQpX1c_Mz-DeV7Whut1xg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A76F805AC8;
        Thu, 27 Oct 2022 12:42:00 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B3E2401D4A;
        Thu, 27 Oct 2022 12:41:58 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 29RCfqCt022403;
        Thu, 27 Oct 2022 08:41:53 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 29RCfoeB022384;
        Thu, 27 Oct 2022 08:41:52 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Thu, 27 Oct 2022 08:41:45 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Greg KH <gregkh@linuxfoundation.org>
cc:     stable@vger.kernel.org
Subject: [PATCH 5.15 2/2] provide arch_test_bit_acquire for architectures
 that define test_bit
Message-ID: <alpine.LRH.2.21.2210270841040.22202@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 arch/alpha/include/asm/bitops.h   |    7 +++++++
 arch/h8300/include/asm/bitops.h   |    3 ++-
 arch/hexagon/include/asm/bitops.h |   15 +++++++++++++++
 arch/ia64/include/asm/bitops.h    |    7 +++++++
 arch/m68k/include/asm/bitops.h    |    6 ++++++
 arch/s390/include/asm/bitops.h    |    7 +++++++
 arch/sh/include/asm/bitops-op32.h |    7 +++++++
 7 files changed, 51 insertions(+), 1 deletion(-)

Index: linux-stable/arch/alpha/include/asm/bitops.h
===================================================================
--- linux-stable.orig/arch/alpha/include/asm/bitops.h	2022-10-27 14:22:01.000000000 +0200
+++ linux-stable/arch/alpha/include/asm/bitops.h	2022-10-27 14:22:01.000000000 +0200
@@ -289,6 +289,13 @@ test_bit(int nr, const volatile void * a
 	return (1UL & (((const int *) addr)[nr >> 5] >> (nr & 31))) != 0UL;
 }
 
+static __always_inline bool
+test_bit_acquire(unsigned long nr, const volatile unsigned long *addr)
+{
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+	return 1UL & (smp_load_acquire(p) >> (nr & (BITS_PER_LONG-1)));
+}
+
 /*
  * ffz = Find First Zero in word. Undefined if no zero exists,
  * so code should check against ~0UL first..
Index: linux-stable/arch/hexagon/include/asm/bitops.h
===================================================================
--- linux-stable.orig/arch/hexagon/include/asm/bitops.h	2022-10-27 14:22:01.000000000 +0200
+++ linux-stable/arch/hexagon/include/asm/bitops.h	2022-10-27 14:22:01.000000000 +0200
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
--- linux-stable.orig/arch/ia64/include/asm/bitops.h	2022-10-27 14:22:01.000000000 +0200
+++ linux-stable/arch/ia64/include/asm/bitops.h	2022-10-27 14:22:01.000000000 +0200
@@ -337,6 +337,13 @@ test_bit (int nr, const volatile void *a
 	return 1 & (((const volatile __u32 *) addr)[nr >> 5] >> (nr & 31));
 }
 
+static __always_inline bool
+test_bit_acquire(unsigned long nr, const volatile unsigned long *addr)
+{
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+	return 1UL & (smp_load_acquire(p) >> (nr & (BITS_PER_LONG-1)));
+}
+
 /**
  * ffz - find the first zero bit in a long word
  * @x: The long word to find the bit in
Index: linux-stable/arch/m68k/include/asm/bitops.h
===================================================================
--- linux-stable.orig/arch/m68k/include/asm/bitops.h	2022-10-27 14:22:01.000000000 +0200
+++ linux-stable/arch/m68k/include/asm/bitops.h	2022-10-27 14:22:01.000000000 +0200
@@ -153,6 +153,12 @@ static inline int test_bit(int nr, const
 	return (vaddr[nr >> 5] & (1UL << (nr & 31))) != 0;
 }
 
+static __always_inline bool
+test_bit_acquire(unsigned long nr, const volatile unsigned long *addr)
+{
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+	return 1UL & (smp_load_acquire(p) >> (nr & (BITS_PER_LONG-1)));
+}
 
 static inline int bset_reg_test_and_set_bit(int nr,
 					    volatile unsigned long *vaddr)
Index: linux-stable/arch/s390/include/asm/bitops.h
===================================================================
--- linux-stable.orig/arch/s390/include/asm/bitops.h	2022-10-27 14:22:01.000000000 +0200
+++ linux-stable/arch/s390/include/asm/bitops.h	2022-10-27 14:22:01.000000000 +0200
@@ -184,6 +184,13 @@ static inline bool arch_test_bit(unsigne
 	return *addr & mask;
 }
 
+static __always_inline bool
+arch_test_bit_acquire(unsigned long nr, const volatile unsigned long *addr)
+{
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+	return 1UL & (smp_load_acquire(p) >> (nr & (BITS_PER_LONG-1)));
+}
+
 static inline bool arch_test_and_set_bit_lock(unsigned long nr,
 					      volatile unsigned long *ptr)
 {
Index: linux-stable/arch/sh/include/asm/bitops-op32.h
===================================================================
--- linux-stable.orig/arch/sh/include/asm/bitops-op32.h	2022-10-27 14:22:01.000000000 +0200
+++ linux-stable/arch/sh/include/asm/bitops-op32.h	2022-10-27 14:22:01.000000000 +0200
@@ -138,4 +138,11 @@ static inline int test_bit(int nr, const
 	return 1UL & (addr[BIT_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
 }
 
+static __always_inline bool
+test_bit_acquire(unsigned long nr, const volatile unsigned long *addr)
+{
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+	return 1UL & (smp_load_acquire(p) >> (nr & (BITS_PER_LONG-1)));
+}
+
 #endif /* __ASM_SH_BITOPS_OP32_H */
Index: linux-stable/arch/h8300/include/asm/bitops.h
===================================================================
--- linux-stable.orig/arch/h8300/include/asm/bitops.h	2022-10-27 14:22:01.000000000 +0200
+++ linux-stable/arch/h8300/include/asm/bitops.h	2022-10-27 14:22:01.000000000 +0200
@@ -87,7 +87,8 @@ static inline int test_bit(int nr, const
 	return ret;
 }
 
-#define __test_bit(nr, addr) test_bit(nr, addr)
+#define __test_bit(nr, addr)		test_bit(nr, addr)
+#define test_bit_acquire(nr, addr)	test_bit(nr, addr)
 
 #define H8300_GEN_TEST_BITOP(FNNAME, OP)				\
 static inline int FNNAME(int nr, void *addr)				\

