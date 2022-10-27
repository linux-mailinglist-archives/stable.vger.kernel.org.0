Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBAC60F67D
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 13:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235345AbiJ0Ls5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 07:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234021AbiJ0Ls4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 07:48:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 500CB58524
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 04:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666871333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=IxoXwFcxkiGOyIomt4QfvYdaODY3FcTb14V8kYs0i+o=;
        b=ZtbfHVUNvRjfgM8ygOW3jFYxLbTxwzoaIMhScOAQJEDzZwHfDqJJeLBDtJZsxU69x6nlIr
        L6u5fv21NKeWd0+E2rL17F/JivKFt+ehr5eDC/1n0Bn3EcLajQ8vCv8wuPrGOkQow9TWeL
        JVHcMa69SA/AHAt6yJAdTrfbZPK5C/4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-h_1nekxRPpS7WhlNpRW9qQ-1; Thu, 27 Oct 2022 07:48:52 -0400
X-MC-Unique: h_1nekxRPpS7WhlNpRW9qQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D11543C0F361;
        Thu, 27 Oct 2022 11:48:51 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CC6CC40C835A;
        Thu, 27 Oct 2022 11:48:51 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 29RBmpju010057;
        Thu, 27 Oct 2022 07:48:51 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 29RBmiQZ010052;
        Thu, 27 Oct 2022 07:48:49 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Thu, 27 Oct 2022 07:48:41 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Greg KH <gregkh@linuxfoundation.org>
cc:     stable@vger.kernel.org
Subject: [PATCH 5.10] wait_on_bit: add an acquire memory barrier
Message-ID: <alpine.LRH.2.21.2210270747580.3240@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 8238b4579866b7c1bb99883cfe102a43db5506ff upstream.

There are several places in the kernel where wait_on_bit is not followed
by a memory barrier (for example, in drivers/md/dm-bufio.c:new_read).

On architectures with weak memory ordering, it may happen that memory
accesses that follow wait_on_bit are reordered before wait_on_bit and
they may return invalid data.

Fix this class of bugs by introducing a new function "test_bit_acquire"
that works like test_bit, but has acquire memory ordering semantics.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Will Deacon <will@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

---
 arch/alpha/include/asm/bitops.h                      |    7 ++++++
 arch/arc/include/asm/bitops.h                        |    7 ++++++
 arch/h8300/include/asm/bitops.h                      |    3 +-
 arch/hexagon/include/asm/bitops.h                    |   15 +++++++++++++
 arch/ia64/include/asm/bitops.h                       |    7 ++++++
 arch/m68k/include/asm/bitops.h                       |    6 +++++
 arch/s390/include/asm/bitops.h                       |    7 ++++++
 arch/sh/include/asm/bitops-op32.h                    |    7 ++++++
 arch/x86/include/asm/bitops.h                        |   21 +++++++++++++++++++
 include/asm-generic/bitops/instrumented-non-atomic.h |   12 ++++++++++
 include/asm-generic/bitops/non-atomic.h              |   14 ++++++++++++
 include/linux/buffer_head.h                          |    2 -
 include/linux/wait_bit.h                             |    8 +++----
 kernel/sched/wait_bit.c                              |    2 -
 14 files changed, 111 insertions(+), 7 deletions(-)

Index: linux-stable/arch/x86/include/asm/bitops.h
===================================================================
--- linux-stable.orig/arch/x86/include/asm/bitops.h	2022-10-17 19:38:32.000000000 +0200
+++ linux-stable/arch/x86/include/asm/bitops.h	2022-10-17 19:38:32.000000000 +0200
@@ -207,6 +207,20 @@ static __always_inline bool constant_tes
 		(addr[nr >> _BITOPS_LONG_SHIFT])) != 0;
 }
 
+static __always_inline bool constant_test_bit_acquire(long nr, const volatile unsigned long *addr)
+{
+	bool oldbit;
+
+	asm volatile("testb %2,%1"
+		     CC_SET(nz)
+		     : CC_OUT(nz) (oldbit)
+		     : "m" (((unsigned char *)addr)[nr >> 3]),
+		       "i" (1 << (nr & 7))
+		     :"memory");
+
+	return oldbit;
+}
+
 static __always_inline bool variable_test_bit(long nr, volatile const unsigned long *addr)
 {
 	bool oldbit;
@@ -224,6 +238,13 @@ static __always_inline bool variable_tes
 	 ? constant_test_bit((nr), (addr))	\
 	 : variable_test_bit((nr), (addr)))
 
+static __always_inline bool
+arch_test_bit_acquire(unsigned long nr, const volatile unsigned long *addr)
+{
+	return __builtin_constant_p(nr) ? constant_test_bit_acquire(nr, addr) :
+					  variable_test_bit(nr, addr);
+}
+
 /**
  * __ffs - find first set bit in word
  * @word: The word to search
Index: linux-stable/include/asm-generic/bitops/instrumented-non-atomic.h
===================================================================
--- linux-stable.orig/include/asm-generic/bitops/instrumented-non-atomic.h	2022-10-17 19:38:32.000000000 +0200
+++ linux-stable/include/asm-generic/bitops/instrumented-non-atomic.h	2022-10-17 19:38:32.000000000 +0200
@@ -135,4 +135,16 @@ static inline bool test_bit(long nr, con
 	return arch_test_bit(nr, addr);
 }
 
+/**
+ * _test_bit_acquire - Determine, with acquire semantics, whether a bit is set
+ * @nr: bit number to test
+ * @addr: Address to start counting from
+ */
+static __always_inline bool
+test_bit_acquire(unsigned long nr, const volatile unsigned long *addr)
+{
+	instrument_atomic_read(addr + BIT_WORD(nr), sizeof(long));
+	return arch_test_bit_acquire(nr, addr);
+}
+
 #endif /* _ASM_GENERIC_BITOPS_INSTRUMENTED_NON_ATOMIC_H */
Index: linux-stable/include/asm-generic/bitops/non-atomic.h
===================================================================
--- linux-stable.orig/include/asm-generic/bitops/non-atomic.h	2022-10-17 19:38:32.000000000 +0200
+++ linux-stable/include/asm-generic/bitops/non-atomic.h	2022-10-17 19:38:32.000000000 +0200
@@ -3,6 +3,7 @@
 #define _ASM_GENERIC_BITOPS_NON_ATOMIC_H_
 
 #include <asm/types.h>
+#include <asm/barrier.h>
 
 /**
  * __set_bit - Set a bit in memory
@@ -106,4 +107,17 @@ static inline int test_bit(int nr, const
 	return 1UL & (addr[BIT_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
 }
 
+/**
+ * arch_test_bit_acquire - Determine, with acquire semantics, whether a bit is set
+ * @nr: bit number to test
+ * @addr: Address to start counting from
+ */
+static __always_inline bool
+arch_test_bit_acquire(unsigned long nr, const volatile unsigned long *addr)
+{
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+	return 1UL & (smp_load_acquire(p) >> (nr & (BITS_PER_LONG-1)));
+}
+#define test_bit_acquire arch_test_bit_acquire
+
 #endif /* _ASM_GENERIC_BITOPS_NON_ATOMIC_H_ */
Index: linux-stable/include/linux/buffer_head.h
===================================================================
--- linux-stable.orig/include/linux/buffer_head.h	2022-10-17 19:38:32.000000000 +0200
+++ linux-stable/include/linux/buffer_head.h	2022-10-17 19:38:32.000000000 +0200
@@ -166,7 +166,7 @@ static __always_inline int buffer_uptoda
 	 * make it consistent with folio_test_uptodate
 	 * pairs with smp_mb__before_atomic in set_buffer_uptodate
 	 */
-	return (smp_load_acquire(&bh->b_state) & (1UL << BH_Uptodate)) != 0;
+	return test_bit_acquire(BH_Uptodate, &bh->b_state);
 }
 
 #define bh_offset(bh)		((unsigned long)(bh)->b_data & ~PAGE_MASK)
Index: linux-stable/include/linux/wait_bit.h
===================================================================
--- linux-stable.orig/include/linux/wait_bit.h	2022-10-17 19:38:32.000000000 +0200
+++ linux-stable/include/linux/wait_bit.h	2022-10-17 19:38:32.000000000 +0200
@@ -71,7 +71,7 @@ static inline int
 wait_on_bit(unsigned long *word, int bit, unsigned mode)
 {
 	might_sleep();
-	if (!test_bit(bit, word))
+	if (!test_bit_acquire(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit(word, bit,
 				       bit_wait,
@@ -96,7 +96,7 @@ static inline int
 wait_on_bit_io(unsigned long *word, int bit, unsigned mode)
 {
 	might_sleep();
-	if (!test_bit(bit, word))
+	if (!test_bit_acquire(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit(word, bit,
 				       bit_wait_io,
@@ -123,7 +123,7 @@ wait_on_bit_timeout(unsigned long *word,
 		    unsigned long timeout)
 {
 	might_sleep();
-	if (!test_bit(bit, word))
+	if (!test_bit_acquire(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit_timeout(word, bit,
 					       bit_wait_timeout,
@@ -151,7 +151,7 @@ wait_on_bit_action(unsigned long *word,
 		   unsigned mode)
 {
 	might_sleep();
-	if (!test_bit(bit, word))
+	if (!test_bit_acquire(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit(word, bit, action, mode);
 }
Index: linux-stable/kernel/sched/wait_bit.c
===================================================================
--- linux-stable.orig/kernel/sched/wait_bit.c	2022-10-17 19:38:32.000000000 +0200
+++ linux-stable/kernel/sched/wait_bit.c	2022-10-17 19:38:32.000000000 +0200
@@ -47,7 +47,7 @@ __wait_on_bit(struct wait_queue_head *wq
 		prepare_to_wait(wq_head, &wbq_entry->wq_entry, mode);
 		if (test_bit(wbq_entry->key.bit_nr, wbq_entry->key.flags))
 			ret = (*action)(&wbq_entry->key, mode);
-	} while (test_bit(wbq_entry->key.bit_nr, wbq_entry->key.flags) && !ret);
+	} while (test_bit_acquire(wbq_entry->key.bit_nr, wbq_entry->key.flags) && !ret);
 
 	finish_wait(wq_head, &wbq_entry->wq_entry);
 
Index: linux-stable/arch/alpha/include/asm/bitops.h
===================================================================
--- linux-stable.orig/arch/alpha/include/asm/bitops.h	2022-10-17 19:38:32.000000000 +0200
+++ linux-stable/arch/alpha/include/asm/bitops.h	2022-10-17 19:38:32.000000000 +0200
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
--- linux-stable.orig/arch/hexagon/include/asm/bitops.h	2022-10-17 19:38:32.000000000 +0200
+++ linux-stable/arch/hexagon/include/asm/bitops.h	2022-10-17 19:38:32.000000000 +0200
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
--- linux-stable.orig/arch/ia64/include/asm/bitops.h	2022-10-17 19:38:32.000000000 +0200
+++ linux-stable/arch/ia64/include/asm/bitops.h	2022-10-17 19:38:32.000000000 +0200
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
--- linux-stable.orig/arch/m68k/include/asm/bitops.h	2022-10-17 19:38:32.000000000 +0200
+++ linux-stable/arch/m68k/include/asm/bitops.h	2022-10-17 19:38:32.000000000 +0200
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
--- linux-stable.orig/arch/s390/include/asm/bitops.h	2022-10-17 19:38:32.000000000 +0200
+++ linux-stable/arch/s390/include/asm/bitops.h	2022-10-17 19:38:32.000000000 +0200
@@ -219,6 +219,13 @@ static inline bool arch_test_bit(unsigne
 	return (*addr >> (nr & 7)) & 1;
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
--- linux-stable.orig/arch/sh/include/asm/bitops-op32.h	2022-10-17 19:38:32.000000000 +0200
+++ linux-stable/arch/sh/include/asm/bitops-op32.h	2022-10-17 19:38:32.000000000 +0200
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
--- linux-stable.orig/arch/h8300/include/asm/bitops.h	2022-10-17 19:38:32.000000000 +0200
+++ linux-stable/arch/h8300/include/asm/bitops.h	2022-10-17 19:38:32.000000000 +0200
@@ -83,7 +83,8 @@ static inline int test_bit(int nr, const
 	return ret;
 }
 
-#define __test_bit(nr, addr) test_bit(nr, addr)
+#define __test_bit(nr, addr)		test_bit(nr, addr)
+#define test_bit_acquire(nr, addr)	test_bit(nr, addr)
 
 #define H8300_GEN_TEST_BITOP(FNNAME, OP)				\
 static inline int FNNAME(int nr, void *addr)				\
Index: linux-stable/arch/arc/include/asm/bitops.h
===================================================================
--- linux-stable.orig/arch/arc/include/asm/bitops.h	2022-10-17 19:35:36.000000000 +0200
+++ linux-stable/arch/arc/include/asm/bitops.h	2022-10-17 19:41:07.000000000 +0200
@@ -197,6 +197,13 @@ test_bit(unsigned int nr, const volatile
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

