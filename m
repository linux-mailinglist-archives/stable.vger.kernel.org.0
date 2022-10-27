Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFD660F68A
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 13:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiJ0Lv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 07:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235239AbiJ0Lv5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 07:51:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CBDA3B7F
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 04:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666871514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=PfZ5+tW9/UW6nZDkozOgE7ktXF5qCDIe2H1y/ubeKEY=;
        b=T1OiWqRwrQF7xl5zDq04ycRjrJsMi2Ro44qsTxbJ55qo/pecKauq0wXMrQqutGHeECqryV
        fLuf3N4iyrt6FoOI3R2gNLDr1tSLWkeSlpjRKXH+pT3q3H6dYuo5G1RCfw379sQKuOBSa6
        DF3npHmH7nxMsm904P2yzhrEkg71r8w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-362-_fCMGWKvOGKhGMR1gWgl-A-1; Thu, 27 Oct 2022 07:51:51 -0400
X-MC-Unique: _fCMGWKvOGKhGMR1gWgl-A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9C8B85A59D;
        Thu, 27 Oct 2022 11:51:50 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B4AEA492B09;
        Thu, 27 Oct 2022 11:51:50 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 29RBpou7017684;
        Thu, 27 Oct 2022 07:51:50 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 29RBpoKr017680;
        Thu, 27 Oct 2022 07:51:50 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Thu, 27 Oct 2022 07:51:50 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Greg KH <gregkh@linuxfoundation.org>
cc:     stable@vger.kernel.org
Subject: [PATCH 4.9] wait_on_bit: add an acquire memory barrier
Message-ID: <alpine.LRH.2.21.2210270751140.3240@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
 arch/alpha/include/asm/bitops.h         |    7 +++++++
 arch/arc/include/asm/bitops.h           |    7 +++++++
 arch/frv/include/asm/bitops.h           |    7 +++++++
 arch/h8300/include/asm/bitops.h         |    3 ++-
 arch/hexagon/include/asm/bitops.h       |   15 +++++++++++++++
 arch/ia64/include/asm/bitops.h          |    7 +++++++
 arch/m68k/include/asm/bitops.h          |    6 ++++++
 arch/mn10300/include/asm/bitops.h       |    7 +++++++
 arch/s390/include/asm/bitops.h          |    7 +++++++
 arch/sh/include/asm/bitops-op32.h       |    7 +++++++
 arch/x86/include/asm/bitops.h           |   21 +++++++++++++++++++++
 include/asm-generic/bitops/non-atomic.h |   14 ++++++++++++++
 include/linux/buffer_head.h             |    2 +-
 include/linux/wait.h                    |    8 ++++----
 kernel/sched/wait.c                     |    2 +-
 15 files changed, 113 insertions(+), 7 deletions(-)

Index: linux-stable/arch/x86/include/asm/bitops.h
===================================================================
--- linux-stable.orig/arch/x86/include/asm/bitops.h	2022-10-17 20:43:20.000000000 +0200
+++ linux-stable/arch/x86/include/asm/bitops.h	2022-10-17 20:43:20.000000000 +0200
@@ -314,6 +314,20 @@ static __always_inline bool constant_tes
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
@@ -340,6 +354,13 @@ static bool test_bit(int nr, const volat
 	 ? constant_test_bit((nr), (addr))	\
 	 : variable_test_bit((nr), (addr)))
 
+static __always_inline bool
+test_bit_acquire(unsigned long nr, const volatile unsigned long *addr)
+{
+	return __builtin_constant_p(nr) ? constant_test_bit_acquire(nr, addr) :
+					  variable_test_bit(nr, addr);
+}
+
 /**
  * __ffs - find first set bit in word
  * @word: The word to search
Index: linux-stable/include/asm-generic/bitops/non-atomic.h
===================================================================
--- linux-stable.orig/include/asm-generic/bitops/non-atomic.h	2022-10-17 20:43:20.000000000 +0200
+++ linux-stable/include/asm-generic/bitops/non-atomic.h	2022-10-17 20:43:20.000000000 +0200
@@ -2,6 +2,7 @@
 #define _ASM_GENERIC_BITOPS_NON_ATOMIC_H_
 
 #include <asm/types.h>
+#include <asm/barrier.h>
 
 /**
  * __set_bit - Set a bit in memory
@@ -105,4 +106,17 @@ static inline int test_bit(int nr, const
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
--- linux-stable.orig/include/linux/buffer_head.h	2022-10-17 20:43:20.000000000 +0200
+++ linux-stable/include/linux/buffer_head.h	2022-10-17 20:43:20.000000000 +0200
@@ -162,7 +162,7 @@ static __always_inline int buffer_uptoda
 	 * make it consistent with folio_test_uptodate
 	 * pairs with smp_mb__before_atomic in set_buffer_uptodate
 	 */
-	return (smp_load_acquire(&bh->b_state) & (1UL << BH_Uptodate)) != 0;
+	return test_bit_acquire(BH_Uptodate, &bh->b_state);
 }
 
 #define bh_offset(bh)		((unsigned long)(bh)->b_data & ~PAGE_MASK)
Index: linux-stable/include/linux/wait.h
===================================================================
--- linux-stable.orig/include/linux/wait.h	2022-10-17 20:43:20.000000000 +0200
+++ linux-stable/include/linux/wait.h	2022-10-17 20:43:20.000000000 +0200
@@ -1066,7 +1066,7 @@ static inline int
 wait_on_bit(unsigned long *word, int bit, unsigned mode)
 {
 	might_sleep();
-	if (!test_bit(bit, word))
+	if (!test_bit_acquire(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit(word, bit,
 				       bit_wait,
@@ -1091,7 +1091,7 @@ static inline int
 wait_on_bit_io(unsigned long *word, int bit, unsigned mode)
 {
 	might_sleep();
-	if (!test_bit(bit, word))
+	if (!test_bit_acquire(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit(word, bit,
 				       bit_wait_io,
@@ -1118,7 +1118,7 @@ wait_on_bit_timeout(unsigned long *word,
 		    unsigned long timeout)
 {
 	might_sleep();
-	if (!test_bit(bit, word))
+	if (!test_bit_acquire(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit_timeout(word, bit,
 					       bit_wait_timeout,
@@ -1146,7 +1146,7 @@ wait_on_bit_action(unsigned long *word,
 		   unsigned mode)
 {
 	might_sleep();
-	if (!test_bit(bit, word))
+	if (!test_bit_acquire(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit(word, bit, action, mode);
 }
Index: linux-stable/kernel/sched/wait.c
===================================================================
--- linux-stable.orig/kernel/sched/wait.c	2022-10-17 20:43:20.000000000 +0200
+++ linux-stable/kernel/sched/wait.c	2022-10-17 20:43:20.000000000 +0200
@@ -389,7 +389,7 @@ __wait_on_bit(wait_queue_head_t *wq, str
 		prepare_to_wait(wq, &q->wait, mode);
 		if (test_bit(q->key.bit_nr, q->key.flags))
 			ret = (*action)(&q->key, mode);
-	} while (test_bit(q->key.bit_nr, q->key.flags) && !ret);
+	} while (test_bit_acquire(q->key.bit_nr, q->key.flags) && !ret);
 	finish_wait(wq, &q->wait);
 	return ret;
 }
Index: linux-stable/arch/alpha/include/asm/bitops.h
===================================================================
--- linux-stable.orig/arch/alpha/include/asm/bitops.h	2022-10-17 20:43:20.000000000 +0200
+++ linux-stable/arch/alpha/include/asm/bitops.h	2022-10-17 20:43:20.000000000 +0200
@@ -288,6 +288,13 @@ test_bit(int nr, const volatile void * a
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
--- linux-stable.orig/arch/hexagon/include/asm/bitops.h	2022-10-17 20:43:20.000000000 +0200
+++ linux-stable/arch/hexagon/include/asm/bitops.h	2022-10-17 20:43:20.000000000 +0200
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
--- linux-stable.orig/arch/ia64/include/asm/bitops.h	2022-10-17 20:43:20.000000000 +0200
+++ linux-stable/arch/ia64/include/asm/bitops.h	2022-10-17 20:43:20.000000000 +0200
@@ -336,6 +336,13 @@ test_bit (int nr, const volatile void *a
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
--- linux-stable.orig/arch/m68k/include/asm/bitops.h	2022-10-17 20:43:20.000000000 +0200
+++ linux-stable/arch/m68k/include/asm/bitops.h	2022-10-17 20:43:20.000000000 +0200
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
--- linux-stable.orig/arch/s390/include/asm/bitops.h	2022-10-17 20:43:20.000000000 +0200
+++ linux-stable/arch/s390/include/asm/bitops.h	2022-10-17 20:43:20.000000000 +0200
@@ -270,6 +270,13 @@ static inline int test_bit(unsigned long
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
--- linux-stable.orig/arch/sh/include/asm/bitops-op32.h	2022-10-17 20:43:20.000000000 +0200
+++ linux-stable/arch/sh/include/asm/bitops-op32.h	2022-10-17 20:43:20.000000000 +0200
@@ -139,4 +139,11 @@ static inline int test_bit(int nr, const
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
--- linux-stable.orig/arch/arc/include/asm/bitops.h	2022-10-17 20:43:20.000000000 +0200
+++ linux-stable/arch/arc/include/asm/bitops.h	2022-10-17 20:43:20.000000000 +0200
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
--- linux-stable.orig/arch/h8300/include/asm/bitops.h	2022-10-17 20:43:20.000000000 +0200
+++ linux-stable/arch/h8300/include/asm/bitops.h	2022-10-17 20:43:20.000000000 +0200
@@ -88,7 +88,8 @@ static inline int test_bit(int nr, const
 	return ret;
 }
 
-#define __test_bit(nr, addr) test_bit(nr, addr)
+#define __test_bit(nr, addr)		test_bit(nr, addr)
+#define test_bit_acquire(nr, addr)	test_bit(nr, addr)
 
 #define H8300_GEN_TEST_BITOP(FNNAME, OP)				\
 static inline int FNNAME(int nr, void *addr)				\
Index: linux-stable/arch/frv/include/asm/bitops.h
===================================================================
--- linux-stable.orig/arch/frv/include/asm/bitops.h	2022-10-17 20:43:20.000000000 +0200
+++ linux-stable/arch/frv/include/asm/bitops.h	2022-10-17 20:43:20.000000000 +0200
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
--- linux-stable.orig/arch/mn10300/include/asm/bitops.h	2022-10-17 20:43:20.000000000 +0200
+++ linux-stable/arch/mn10300/include/asm/bitops.h	2022-10-17 20:43:20.000000000 +0200
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

