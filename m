Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05555A43E1
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 09:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiH2HkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 03:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiH2HkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 03:40:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90646CE19
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 00:40:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA4C461148
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 07:40:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9D7C433D6;
        Mon, 29 Aug 2022 07:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661758800;
        bh=8KUTEQ3jkWtXN79/2WQ1VLUG7d/kgxyk5R//7PGuRws=;
        h=Subject:To:Cc:From:Date:From;
        b=zFf0CETT6oGNt8WofdQICSmkzdNH1kg069zS0hR1SuPqZRtbdG3eL4PGNzZuxH1sR
         smQJ0Q+MjRT2rB5r2gbpd4QlkHigSYoZ0Qjk0DZlazp7GsrLpqQxBkRg1y5a8HSdAa
         qZe6vckgJ9yY8+K1invC+7kzp4EbmWMk0vmbosj4=
Subject: FAILED: patch "[PATCH] wait_on_bit: add an acquire memory barrier" failed to apply to 5.10-stable tree
To:     mpatocka@redhat.com, torvalds@linux-foundation.org, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Aug 2022 09:39:54 +0200
Message-ID: <16617587948472@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8238b4579866b7c1bb99883cfe102a43db5506ff Mon Sep 17 00:00:00 2001
From: Mikulas Patocka <mpatocka@redhat.com>
Date: Fri, 26 Aug 2022 09:17:08 -0400
Subject: [PATCH] wait_on_bit: add an acquire memory barrier

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

diff --git a/Documentation/atomic_bitops.txt b/Documentation/atomic_bitops.txt
index d8b101c97031..edea4656c5c0 100644
--- a/Documentation/atomic_bitops.txt
+++ b/Documentation/atomic_bitops.txt
@@ -58,13 +58,11 @@ Like with atomic_t, the rule of thumb is:
 
  - RMW operations that have a return value are fully ordered.
 
- - RMW operations that are conditional are unordered on FAILURE,
-   otherwise the above rules apply. In the case of test_and_set_bit_lock(),
-   if the bit in memory is unchanged by the operation then it is deemed to have
-   failed.
+ - RMW operations that are conditional are fully ordered.
 
-Except for a successful test_and_set_bit_lock() which has ACQUIRE semantics and
-clear_bit_unlock() which has RELEASE semantics.
+Except for a successful test_and_set_bit_lock() which has ACQUIRE semantics,
+clear_bit_unlock() which has RELEASE semantics and test_bit_acquire which has
+ACQUIRE semantics.
 
 Since a platform only has a single means of achieving atomic operations
 the same barriers as for atomic_t are used, see atomic_t.txt.
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 973c6bd17f98..0fe9de58af31 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -207,6 +207,20 @@ static __always_inline bool constant_test_bit(long nr, const volatile unsigned l
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
@@ -226,6 +240,13 @@ arch_test_bit(unsigned long nr, const volatile unsigned long *addr)
 					  variable_test_bit(nr, addr);
 }
 
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
diff --git a/include/asm-generic/bitops/generic-non-atomic.h b/include/asm-generic/bitops/generic-non-atomic.h
index 3d5ebd24652b..564a8c675d85 100644
--- a/include/asm-generic/bitops/generic-non-atomic.h
+++ b/include/asm-generic/bitops/generic-non-atomic.h
@@ -4,6 +4,7 @@
 #define __ASM_GENERIC_BITOPS_GENERIC_NON_ATOMIC_H
 
 #include <linux/bits.h>
+#include <asm/barrier.h>
 
 #ifndef _LINUX_BITOPS_H
 #error only <linux/bitops.h> can be included directly
@@ -127,6 +128,18 @@ generic_test_bit(unsigned long nr, const volatile unsigned long *addr)
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
 /*
  * const_*() definitions provide good compile-time optimizations when
  * the passed arguments can be resolved at compile time.
@@ -137,6 +150,7 @@ generic_test_bit(unsigned long nr, const volatile unsigned long *addr)
 #define const___test_and_set_bit	generic___test_and_set_bit
 #define const___test_and_clear_bit	generic___test_and_clear_bit
 #define const___test_and_change_bit	generic___test_and_change_bit
+#define const_test_bit_acquire		generic_test_bit_acquire
 
 /**
  * const_test_bit - Determine whether a bit is set
diff --git a/include/asm-generic/bitops/instrumented-non-atomic.h b/include/asm-generic/bitops/instrumented-non-atomic.h
index 988a3bbfba34..2b238b161a62 100644
--- a/include/asm-generic/bitops/instrumented-non-atomic.h
+++ b/include/asm-generic/bitops/instrumented-non-atomic.h
@@ -142,4 +142,16 @@ _test_bit(unsigned long nr, const volatile unsigned long *addr)
 	return arch_test_bit(nr, addr);
 }
 
+/**
+ * _test_bit_acquire - Determine, with acquire semantics, whether a bit is set
+ * @nr: bit number to test
+ * @addr: Address to start counting from
+ */
+static __always_inline bool
+_test_bit_acquire(unsigned long nr, const volatile unsigned long *addr)
+{
+	instrument_atomic_read(addr + BIT_WORD(nr), sizeof(long));
+	return arch_test_bit_acquire(nr, addr);
+}
+
 #endif /* _ASM_GENERIC_BITOPS_INSTRUMENTED_NON_ATOMIC_H */
diff --git a/include/asm-generic/bitops/non-atomic.h b/include/asm-generic/bitops/non-atomic.h
index 5c37ced343ae..71f8d54a5195 100644
--- a/include/asm-generic/bitops/non-atomic.h
+++ b/include/asm-generic/bitops/non-atomic.h
@@ -13,6 +13,7 @@
 #define arch___test_and_change_bit generic___test_and_change_bit
 
 #define arch_test_bit generic_test_bit
+#define arch_test_bit_acquire generic_test_bit_acquire
 
 #include <asm-generic/bitops/non-instrumented-non-atomic.h>
 
diff --git a/include/asm-generic/bitops/non-instrumented-non-atomic.h b/include/asm-generic/bitops/non-instrumented-non-atomic.h
index bdb9b1ffaee9..0ddc78dfc358 100644
--- a/include/asm-generic/bitops/non-instrumented-non-atomic.h
+++ b/include/asm-generic/bitops/non-instrumented-non-atomic.h
@@ -12,5 +12,6 @@
 #define ___test_and_change_bit	arch___test_and_change_bit
 
 #define _test_bit		arch_test_bit
+#define _test_bit_acquire	arch_test_bit_acquire
 
 #endif /* __ASM_GENERIC_BITOPS_NON_INSTRUMENTED_NON_ATOMIC_H */
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index cf9bf65039f2..3b89c64bcfd8 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -59,6 +59,7 @@ extern unsigned long __sw_hweight64(__u64 w);
 #define __test_and_clear_bit(nr, addr)	bitop(___test_and_clear_bit, nr, addr)
 #define __test_and_change_bit(nr, addr)	bitop(___test_and_change_bit, nr, addr)
 #define test_bit(nr, addr)		bitop(_test_bit, nr, addr)
+#define test_bit_acquire(nr, addr)	bitop(_test_bit_acquire, nr, addr)
 
 /*
  * Include this here because some architectures need generic_ffs/fls in
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index def8b8d30ccc..089c9ade4325 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -156,7 +156,7 @@ static __always_inline int buffer_uptodate(const struct buffer_head *bh)
 	 * make it consistent with folio_test_uptodate
 	 * pairs with smp_mb__before_atomic in set_buffer_uptodate
 	 */
-	return (smp_load_acquire(&bh->b_state) & (1UL << BH_Uptodate)) != 0;
+	return test_bit_acquire(BH_Uptodate, &bh->b_state);
 }
 
 #define bh_offset(bh)		((unsigned long)(bh)->b_data & ~PAGE_MASK)
diff --git a/include/linux/wait_bit.h b/include/linux/wait_bit.h
index 7dec36aecbd9..7725b7579b78 100644
--- a/include/linux/wait_bit.h
+++ b/include/linux/wait_bit.h
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
@@ -123,7 +123,7 @@ wait_on_bit_timeout(unsigned long *word, int bit, unsigned mode,
 		    unsigned long timeout)
 {
 	might_sleep();
-	if (!test_bit(bit, word))
+	if (!test_bit_acquire(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit_timeout(word, bit,
 					       bit_wait_timeout,
@@ -151,7 +151,7 @@ wait_on_bit_action(unsigned long *word, int bit, wait_bit_action_f *action,
 		   unsigned mode)
 {
 	might_sleep();
-	if (!test_bit(bit, word))
+	if (!test_bit_acquire(bit, word))
 		return 0;
 	return out_of_line_wait_on_bit(word, bit, action, mode);
 }
diff --git a/kernel/sched/wait_bit.c b/kernel/sched/wait_bit.c
index d4788f810b55..0b1cd985dc27 100644
--- a/kernel/sched/wait_bit.c
+++ b/kernel/sched/wait_bit.c
@@ -47,7 +47,7 @@ __wait_on_bit(struct wait_queue_head *wq_head, struct wait_bit_queue_entry *wbq_
 		prepare_to_wait(wq_head, &wbq_entry->wq_entry, mode);
 		if (test_bit(wbq_entry->key.bit_nr, wbq_entry->key.flags))
 			ret = (*action)(&wbq_entry->key, mode);
-	} while (test_bit(wbq_entry->key.bit_nr, wbq_entry->key.flags) && !ret);
+	} while (test_bit_acquire(wbq_entry->key.bit_nr, wbq_entry->key.flags) && !ret);
 
 	finish_wait(wq_head, &wbq_entry->wq_entry);
 

