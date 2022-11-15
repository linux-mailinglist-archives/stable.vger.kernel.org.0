Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E523629F68
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 17:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiKOQpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 11:45:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbiKOQpP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 11:45:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B4D1F3
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 08:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668530657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=CCaP7VzxXKrHqkjO7CMs+GeBvNnu7kx/icJ2xyAnoBI=;
        b=djzgjckCyxQtuu64xNFkSKUm4v13ZUdAUpjIPPJWfnzTm9bjf4BZ8vTQEC45Rj40/oz0mu
        QbfD/31jsCcibRO18JNmdHlXFnxYjxzJjRfNUNCMI0tmfsy44W5uLzvuUF0+pgcdIwoZDr
        +BEQKEL041BapXTsG3v/IbducMOzdVg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-dqcz9A2aNySqsJ7cH6rUWw-1; Tue, 15 Nov 2022 11:44:15 -0500
X-MC-Unique: dqcz9A2aNySqsJ7cH6rUWw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A3F58828C0;
        Tue, 15 Nov 2022 16:44:15 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 65E131121314;
        Tue, 15 Nov 2022 16:44:15 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 2AFGiFv0001530;
        Tue, 15 Nov 2022 11:44:15 -0500
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 2AFGiFeI001517;
        Tue, 15 Nov 2022 11:44:15 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 15 Nov 2022 11:44:15 -0500 (EST)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Greg KH <gregkh@linuxfoundation.org>
cc:     stable@vger.kernel.org
Subject: [PATCH 5.15 2/3] wait_on_bit: add an acquire memory barrier
Message-ID: <alpine.LRH.2.21.2211151143200.32285@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 arch/x86/include/asm/bitops.h                        |   21 +++++++++++++++++++
 include/asm-generic/bitops/generic-non-atomic.h      |   13 +++++++++++
 include/asm-generic/bitops/instrumented-non-atomic.h |   12 ++++++++++
 include/asm-generic/bitops/non-atomic.h              |    3 ++
 include/linux/buffer_head.h                          |    2 -
 include/linux/wait_bit.h                             |    8 +++----
 kernel/sched/wait_bit.c                              |    2 -
 7 files changed, 55 insertions(+), 6 deletions(-)

Index: linux-stable/arch/x86/include/asm/bitops.h
===================================================================
--- linux-stable.orig/arch/x86/include/asm/bitops.h	2022-11-14 22:17:32.000000000 +0100
+++ linux-stable/arch/x86/include/asm/bitops.h	2022-11-14 22:17:32.000000000 +0100
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
--- linux-stable.orig/include/asm-generic/bitops/instrumented-non-atomic.h	2022-11-14 22:17:32.000000000 +0100
+++ linux-stable/include/asm-generic/bitops/instrumented-non-atomic.h	2022-11-14 22:17:32.000000000 +0100
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
--- linux-stable.orig/include/asm-generic/bitops/non-atomic.h	2022-11-14 22:17:32.000000000 +0100
+++ linux-stable/include/asm-generic/bitops/non-atomic.h	2022-11-14 22:17:32.000000000 +0100
@@ -25,4 +25,7 @@
 #define arch_test_bit generic_test_bit
 #define test_bit arch_test_bit
 
+#define arch_test_bit_acquire generic_test_bit_acquire
+#define test_bit_acquire arch_test_bit_acquire
+
 #endif /* _ASM_GENERIC_BITOPS_NON_ATOMIC_H_ */
Index: linux-stable/include/linux/buffer_head.h
===================================================================
--- linux-stable.orig/include/linux/buffer_head.h	2022-11-14 22:17:32.000000000 +0100
+++ linux-stable/include/linux/buffer_head.h	2022-11-14 22:17:32.000000000 +0100
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
--- linux-stable.orig/include/linux/wait_bit.h	2022-11-14 22:17:32.000000000 +0100
+++ linux-stable/include/linux/wait_bit.h	2022-11-14 22:17:32.000000000 +0100
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
--- linux-stable.orig/kernel/sched/wait_bit.c	2022-11-14 22:17:32.000000000 +0100
+++ linux-stable/kernel/sched/wait_bit.c	2022-11-14 22:17:32.000000000 +0100
@@ -47,7 +47,7 @@ __wait_on_bit(struct wait_queue_head *wq
 		prepare_to_wait(wq_head, &wbq_entry->wq_entry, mode);
 		if (test_bit(wbq_entry->key.bit_nr, wbq_entry->key.flags))
 			ret = (*action)(&wbq_entry->key, mode);
-	} while (test_bit(wbq_entry->key.bit_nr, wbq_entry->key.flags) && !ret);
+	} while (test_bit_acquire(wbq_entry->key.bit_nr, wbq_entry->key.flags) && !ret);
 
 	finish_wait(wq_head, &wbq_entry->wq_entry);
 
Index: linux-stable/include/asm-generic/bitops/generic-non-atomic.h
===================================================================
--- linux-stable.orig/include/asm-generic/bitops/generic-non-atomic.h	2022-11-14 22:17:32.000000000 +0100
+++ linux-stable/include/asm-generic/bitops/generic-non-atomic.h	2022-11-14 22:17:32.000000000 +0100
@@ -4,6 +4,7 @@
 #define __ASM_GENERIC_BITOPS_GENERIC_NON_ATOMIC_H
 
 #include <linux/bits.h>
+#include <asm/barrier.h>
 
 #ifndef _LINUX_BITOPS_H
 #error only <linux/bitops.h> can be included directly
@@ -127,4 +128,16 @@ generic_test_bit(unsigned int nr, const
 	return 1UL & (addr[BIT_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
 }
 
+/**
+ * generic_test_bit_acquire - Determine, with acquire semantics, whether a bit is set
+ * @nr: bit number to test
+ * @addr: Address to start counting from
+ */
+static __always_inline bool
+generic_test_bit_acquire(unsigned long nr, const volatile unsigned long *addr)
+{
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+	return 1UL & (smp_load_acquire(p) >> (nr & (BITS_PER_LONG-1)));
+}
+
 #endif /* __ASM_GENERIC_BITOPS_GENERIC_NON_ATOMIC_H */

