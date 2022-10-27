Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD0760F7DC
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 14:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235776AbiJ0MrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 08:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235808AbiJ0Mq4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 08:46:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1347016D545
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 05:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666874804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=ZeQ5jhYdnTuRE5NxoxTk//V15mt2iDtDrTg2kvt23Lg=;
        b=A+AB2j2RfaHo7t9rszZqxOFTeBbqHyI4tAkiqw07Rn/W3NT92LkY08P3TIgMoAqQdNaiNv
        oBvEkcO1bxIYkPti5D0G8cxQFUtGWWsUse6pNQ0r2RZkvz2tN4bfOnrD2XwLcQryaabq3E
        aMtp2jJ3VT46XXnZtAu8ZM4H9xUiX5Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-253-dEenaqYcNRiVRZCyz8GR9w-1; Thu, 27 Oct 2022 08:46:41 -0400
X-MC-Unique: dEenaqYcNRiVRZCyz8GR9w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 995F786F12F;
        Thu, 27 Oct 2022 12:46:41 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 954821415117;
        Thu, 27 Oct 2022 12:46:41 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 29RCkfvR022747;
        Thu, 27 Oct 2022 08:46:41 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 29RCkfaR022743;
        Thu, 27 Oct 2022 08:46:41 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Thu, 27 Oct 2022 08:46:41 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Greg KH <gregkh@linuxfoundation.org>
cc:     stable@vger.kernel.org
Subject: [PATCH 4.14 2/2] provide arch_test_bit_acquire for architectures
 that define test_bit
Message-ID: <alpine.LRH.2.21.2210270846190.22202@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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
 arch/arc/include/asm/bitops.h     |    7 +++++++
 arch/frv/include/asm/bitops.h     |    7 +++++++
 arch/h8300/include/asm/bitops.h   |    3 ++-
 arch/hexagon/include/asm/bitops.h |   15 +++++++++++++++
 arch/ia64/include/asm/bitops.h    |    7 +++++++
 arch/m68k/include/asm/bitops.h    |    6 ++++++
 arch/mn10300/include/asm/bitops.h |    7 +++++++
 arch/s390/include/asm/bitops.h    |    7 +++++++
 arch/sh/include/asm/bitops-op32.h |    7 +++++++
 10 files changed, 72 insertions(+), 1 deletion(-)

Index: linux-stable/arch/alpha/include/asm/bitops.h
===================================================================
--- linux-stable.orig/arch/alpha/include/asm/bitops.h	2022-10-27 14:24:02.000000000 +0200
+++ linux-stable/arch/alpha/include/asm/bitops.h	2022-10-27 14:24:02.000000000 +0200
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
--- linux-stable.orig/arch/hexagon/include/asm/bitops.h	2022-10-27 14:24:02.000000000 +0200
+++ linux-stable/arch/hexagon/include/asm/bitops.h	2022-10-27 14:24:02.000000000 +0200
@@ -186,7 +186,22 @@ static inline int __test_bit(int nr, con
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
--- linux-stable.orig/arch/ia64/include/asm/bitops.h	2022-10-27 14:24:02.000000000 +0200
+++ linux-stable/arch/ia64/include/asm/bitops.h	2022-10-27 14:24:02.000000000 +0200
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
--- linux-stable.orig/arch/m68k/include/asm/bitops.h	2022-10-27 14:24:02.000000000 +0200
+++ linux-stable/arch/m68k/include/asm/bitops.h	2022-10-27 14:24:02.000000000 +0200
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
--- linux-stable.orig/arch/s390/include/asm/bitops.h	2022-10-27 14:24:02.000000000 +0200
+++ linux-stable/arch/s390/include/asm/bitops.h	2022-10-27 14:24:02.000000000 +0200
@@ -215,6 +215,13 @@ static inline int test_bit(unsigned long
 	return (*addr >> (nr & 7)) & 1;
 }
 
+static __always_inline bool
+test_bit_acquire(unsigned long nr, const volatile unsigned long *addr)
+{
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+	return 1UL & (smp_load_acquire(p) >> (nr & (BITS_PER_LONG-1)));
+}
+
 static inline int test_and_set_bit_lock(unsigned long nr,
 					volatile unsigned long *ptr)
 {
Index: linux-stable/arch/sh/include/asm/bitops-op32.h
===================================================================
--- linux-stable.orig/arch/sh/include/asm/bitops-op32.h	2022-10-27 14:24:02.000000000 +0200
+++ linux-stable/arch/sh/include/asm/bitops-op32.h	2022-10-27 14:24:02.000000000 +0200
@@ -140,4 +140,11 @@ static inline int test_bit(int nr, const
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
Index: linux-stable/arch/arc/include/asm/bitops.h
===================================================================
--- linux-stable.orig/arch/arc/include/asm/bitops.h	2022-10-27 14:24:02.000000000 +0200
+++ linux-stable/arch/arc/include/asm/bitops.h	2022-10-27 14:24:02.000000000 +0200
@@ -254,6 +254,13 @@ test_bit(unsigned int nr, const volatile
 	return ((mask & *addr) != 0);
 }
 
+static __always_inline bool
+test_bit_acquire(unsigned long nr, const volatile unsigned long *addr)
+{
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+	return 1UL & (smp_load_acquire(p) >> (nr & (BITS_PER_LONG-1)));
+}
+
 #ifdef CONFIG_ISA_ARCOMPACT
 
 /*
Index: linux-stable/arch/h8300/include/asm/bitops.h
===================================================================
--- linux-stable.orig/arch/h8300/include/asm/bitops.h	2022-10-27 14:24:02.000000000 +0200
+++ linux-stable/arch/h8300/include/asm/bitops.h	2022-10-27 14:24:02.000000000 +0200
@@ -89,7 +89,8 @@ static inline int test_bit(int nr, const
 	return ret;
 }
 
-#define __test_bit(nr, addr) test_bit(nr, addr)
+#define __test_bit(nr, addr)		test_bit(nr, addr)
+#define test_bit_acquire(nr, addr)	test_bit(nr, addr)
 
 #define H8300_GEN_TEST_BITOP(FNNAME, OP)				\
 static inline int FNNAME(int nr, void *addr)				\
Index: linux-stable/arch/frv/include/asm/bitops.h
===================================================================
--- linux-stable.orig/arch/frv/include/asm/bitops.h	2022-10-27 14:24:02.000000000 +0200
+++ linux-stable/arch/frv/include/asm/bitops.h	2022-10-27 14:24:02.000000000 +0200
@@ -156,6 +156,13 @@ static inline int __test_bit(unsigned lo
  __constant_test_bit((nr),(addr)) : \
  __test_bit((nr),(addr)))
 
+static __always_inline bool
+test_bit_acquire(unsigned long nr, const volatile unsigned long *addr)
+{
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+	return 1UL & (smp_load_acquire(p) >> (nr & (BITS_PER_LONG-1)));
+}
+
 #include <asm-generic/bitops/find.h>
 
 /**
Index: linux-stable/arch/mn10300/include/asm/bitops.h
===================================================================
--- linux-stable.orig/arch/mn10300/include/asm/bitops.h	2022-10-27 14:24:02.000000000 +0200
+++ linux-stable/arch/mn10300/include/asm/bitops.h	2022-10-27 14:24:02.000000000 +0200
@@ -73,6 +73,13 @@ static inline int test_bit(unsigned long
 	return 1UL & (((const volatile unsigned int *) addr)[nr >> 5] >> (nr & 31));
 }
 
+static __always_inline bool
+test_bit_acquire(unsigned long nr, const volatile unsigned long *addr)
+{
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+	return 1UL & (smp_load_acquire(p) >> (nr & (BITS_PER_LONG-1)));
+}
+
 /*
  * change bit
  */

