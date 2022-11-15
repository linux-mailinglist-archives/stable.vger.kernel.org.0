Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E712A629F5E
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 17:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiKOQoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 11:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238797AbiKOQoF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 11:44:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20A32F661
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 08:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668530578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=tjf2ovz5CetGXXERgU1FGQBjb75qC75LyUtRcTlrnnE=;
        b=WMgQ6qnLVdAgKzm96ibW2ePhlmgdcN8ikgf3sHhXKlpcPdgIc+fDEnR43veT94LgB0Vey7
        S8psNKpqoGFRJZC/Hb8SIekhw6j9AafvyYnGb87mr3c3z6jQzd3H8HQeKq7F1/+D4hzf6Y
        AQdEnhivxVOVMRtsHJIlOkXqKwbl7dA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-F_X1YuKKO0CjaOtIWk2KcA-1; Tue, 15 Nov 2022 11:42:55 -0500
X-MC-Unique: F_X1YuKKO0CjaOtIWk2KcA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 489A585A583;
        Tue, 15 Nov 2022 16:42:55 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 445801401C21;
        Tue, 15 Nov 2022 16:42:55 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 2AFGgt1H032495;
        Tue, 15 Nov 2022 11:42:55 -0500
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 2AFGgtgK032491;
        Tue, 15 Nov 2022 11:42:55 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 15 Nov 2022 11:42:55 -0500 (EST)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Greg KH <gregkh@linuxfoundation.org>
cc:     stable@vger.kernel.org
Subject: [PATCH 5.15 1/3] bitops: always define asm-generic non-atomic
 bitops
Message-ID: <alpine.LRH.2.21.2211151139030.32285@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 21bb8af513d35c005c401706030f4eb469538d1d upstream.

Move generic non-atomic bitops from the asm-generic header which
gets included only when there are no architecture-specific
alternatives, to a separate independent file to make them always
available.
Almost no actual code changes, only one comment added to
generic_test_bit() saying that it's an atomic operation itself
and thus `volatile` must always stay there with no cast-aways.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com> # comment
Suggested-by: Marco Elver <elver@google.com> # reference to kernel-doc
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Marco Elver <elver@google.com>
Signed-off-by: Yury Norov <yury.norov@gmail.com>

---
 include/asm-generic/bitops/generic-non-atomic.h |  130 ++++++++++++++++++++++++
 include/asm-generic/bitops/non-atomic.h         |  110 +-------------------
 2 files changed, 138 insertions(+), 102 deletions(-)

Index: linux-stable/include/asm-generic/bitops/generic-non-atomic.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-stable/include/asm-generic/bitops/generic-non-atomic.h	2022-11-14 22:17:30.000000000 +0100
@@ -0,0 +1,130 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __ASM_GENERIC_BITOPS_GENERIC_NON_ATOMIC_H
+#define __ASM_GENERIC_BITOPS_GENERIC_NON_ATOMIC_H
+
+#include <linux/bits.h>
+
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
+/*
+ * Generic definitions for bit operations, should not be used in regular code
+ * directly.
+ */
+
+/**
+ * generic___set_bit - Set a bit in memory
+ * @nr: the bit to set
+ * @addr: the address to start counting from
+ *
+ * Unlike set_bit(), this function is non-atomic and may be reordered.
+ * If it's called on the same region of memory simultaneously, the effect
+ * may be that only one operation succeeds.
+ */
+static __always_inline void
+generic___set_bit(unsigned int nr, volatile unsigned long *addr)
+{
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+
+	*p  |= mask;
+}
+
+static __always_inline void
+generic___clear_bit(unsigned int nr, volatile unsigned long *addr)
+{
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+
+	*p &= ~mask;
+}
+
+/**
+ * generic___change_bit - Toggle a bit in memory
+ * @nr: the bit to change
+ * @addr: the address to start counting from
+ *
+ * Unlike change_bit(), this function is non-atomic and may be reordered.
+ * If it's called on the same region of memory simultaneously, the effect
+ * may be that only one operation succeeds.
+ */
+static __always_inline
+void generic___change_bit(unsigned int nr, volatile unsigned long *addr)
+{
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+
+	*p ^= mask;
+}
+
+/**
+ * generic___test_and_set_bit - Set a bit and return its old value
+ * @nr: Bit to set
+ * @addr: Address to count from
+ *
+ * This operation is non-atomic and can be reordered.
+ * If two examples of this operation race, one can appear to succeed
+ * but actually fail.  You must protect multiple accesses with a lock.
+ */
+static __always_inline int
+generic___test_and_set_bit(unsigned int nr, volatile unsigned long *addr)
+{
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+	unsigned long old = *p;
+
+	*p = old | mask;
+	return (old & mask) != 0;
+}
+
+/**
+ * generic___test_and_clear_bit - Clear a bit and return its old value
+ * @nr: Bit to clear
+ * @addr: Address to count from
+ *
+ * This operation is non-atomic and can be reordered.
+ * If two examples of this operation race, one can appear to succeed
+ * but actually fail.  You must protect multiple accesses with a lock.
+ */
+static __always_inline int
+generic___test_and_clear_bit(unsigned int nr, volatile unsigned long *addr)
+{
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+	unsigned long old = *p;
+
+	*p = old & ~mask;
+	return (old & mask) != 0;
+}
+
+/* WARNING: non atomic and it can be reordered! */
+static __always_inline int
+generic___test_and_change_bit(unsigned int nr, volatile unsigned long *addr)
+{
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+	unsigned long old = *p;
+
+	*p = old ^ mask;
+	return (old & mask) != 0;
+}
+
+/**
+ * generic_test_bit - Determine whether a bit is set
+ * @nr: bit number to test
+ * @addr: Address to start counting from
+ */
+static __always_inline int
+generic_test_bit(unsigned int nr, const volatile unsigned long *addr)
+{
+	/*
+	 * Unlike the bitops with the '__' prefix above, this one *is* atomic,
+	 * so `volatile` must always stay here with no cast-aways. See
+	 * `Documentation/atomic_bitops.txt` for the details.
+	 */
+	return 1UL & (addr[BIT_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
+}
+
+#endif /* __ASM_GENERIC_BITOPS_GENERIC_NON_ATOMIC_H */
Index: linux-stable/include/asm-generic/bitops/non-atomic.h
===================================================================
--- linux-stable.orig/include/asm-generic/bitops/non-atomic.h	2022-11-14 22:17:30.000000000 +0100
+++ linux-stable/include/asm-generic/bitops/non-atomic.h	2022-11-14 22:17:30.000000000 +0100
@@ -2,121 +2,27 @@
 #ifndef _ASM_GENERIC_BITOPS_NON_ATOMIC_H_
 #define _ASM_GENERIC_BITOPS_NON_ATOMIC_H_
 
-#include <asm/types.h>
+#include <asm-generic/bitops/generic-non-atomic.h>
 
-/**
- * arch___set_bit - Set a bit in memory
- * @nr: the bit to set
- * @addr: the address to start counting from
- *
- * Unlike set_bit(), this function is non-atomic and may be reordered.
- * If it's called on the same region of memory simultaneously, the effect
- * may be that only one operation succeeds.
- */
-static __always_inline void
-arch___set_bit(unsigned int nr, volatile unsigned long *addr)
-{
-	unsigned long mask = BIT_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
-
-	*p  |= mask;
-}
+#define arch___set_bit generic___set_bit
 #define __set_bit arch___set_bit
 
-static __always_inline void
-arch___clear_bit(unsigned int nr, volatile unsigned long *addr)
-{
-	unsigned long mask = BIT_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
-
-	*p &= ~mask;
-}
+#define arch___clear_bit generic___clear_bit
 #define __clear_bit arch___clear_bit
 
-/**
- * arch___change_bit - Toggle a bit in memory
- * @nr: the bit to change
- * @addr: the address to start counting from
- *
- * Unlike change_bit(), this function is non-atomic and may be reordered.
- * If it's called on the same region of memory simultaneously, the effect
- * may be that only one operation succeeds.
- */
-static __always_inline
-void arch___change_bit(unsigned int nr, volatile unsigned long *addr)
-{
-	unsigned long mask = BIT_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
-
-	*p ^= mask;
-}
+#define arch___change_bit generic___change_bit
 #define __change_bit arch___change_bit
 
-/**
- * arch___test_and_set_bit - Set a bit and return its old value
- * @nr: Bit to set
- * @addr: Address to count from
- *
- * This operation is non-atomic and can be reordered.
- * If two examples of this operation race, one can appear to succeed
- * but actually fail.  You must protect multiple accesses with a lock.
- */
-static __always_inline int
-arch___test_and_set_bit(unsigned int nr, volatile unsigned long *addr)
-{
-	unsigned long mask = BIT_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
-	unsigned long old = *p;
-
-	*p = old | mask;
-	return (old & mask) != 0;
-}
+#define arch___test_and_set_bit generic___test_and_set_bit
 #define __test_and_set_bit arch___test_and_set_bit
 
-/**
- * arch___test_and_clear_bit - Clear a bit and return its old value
- * @nr: Bit to clear
- * @addr: Address to count from
- *
- * This operation is non-atomic and can be reordered.
- * If two examples of this operation race, one can appear to succeed
- * but actually fail.  You must protect multiple accesses with a lock.
- */
-static __always_inline int
-arch___test_and_clear_bit(unsigned int nr, volatile unsigned long *addr)
-{
-	unsigned long mask = BIT_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
-	unsigned long old = *p;
-
-	*p = old & ~mask;
-	return (old & mask) != 0;
-}
+#define arch___test_and_clear_bit generic___test_and_clear_bit
 #define __test_and_clear_bit arch___test_and_clear_bit
 
-/* WARNING: non atomic and it can be reordered! */
-static __always_inline int
-arch___test_and_change_bit(unsigned int nr, volatile unsigned long *addr)
-{
-	unsigned long mask = BIT_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
-	unsigned long old = *p;
-
-	*p = old ^ mask;
-	return (old & mask) != 0;
-}
+#define arch___test_and_change_bit generic___test_and_change_bit
 #define __test_and_change_bit arch___test_and_change_bit
 
-/**
- * arch_test_bit - Determine whether a bit is set
- * @nr: bit number to test
- * @addr: Address to start counting from
- */
-static __always_inline int
-arch_test_bit(unsigned int nr, const volatile unsigned long *addr)
-{
-	return 1UL & (addr[BIT_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
-}
+#define arch_test_bit generic_test_bit
 #define test_bit arch_test_bit
 
 #endif /* _ASM_GENERIC_BITOPS_NON_ATOMIC_H_ */

