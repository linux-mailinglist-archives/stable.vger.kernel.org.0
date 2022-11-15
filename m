Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7ED629FAD
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 17:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238414AbiKOQzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 11:55:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238277AbiKOQyz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 11:54:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B0D13F86
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 08:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668531240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=idPTgTbdK4Afj0IzDa+V/4oZp35c3zab8lKWnm64ceU=;
        b=N0iPOJmCYCEP/omI6gyg2fvzdwgbQGQppmbmyBHmN4qbT29Ab9dGZ2EYYVTkES3rgsfkLx
        tBn3/lY2i7AL1ps7luICFilU9h8AZrzEXrLcOwmC23GsPmihyRkNJZmojUXub9Ru0eXCvv
        1wzKsvdAd2xT6A7jlIMFGY9V/RhstbI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-281-akLoeZdBNK6fMv3dfQ46bg-1; Tue, 15 Nov 2022 11:53:59 -0500
X-MC-Unique: akLoeZdBNK6fMv3dfQ46bg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C9F381C09C87;
        Tue, 15 Nov 2022 16:53:58 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C58CC1121314;
        Tue, 15 Nov 2022 16:53:58 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 2AFGrwP0002349;
        Tue, 15 Nov 2022 11:53:58 -0500
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 2AFGrwEn002344;
        Tue, 15 Nov 2022 11:53:58 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 15 Nov 2022 11:53:58 -0500 (EST)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Greg KH <gregkh@linuxfoundation.org>
cc:     stable@vger.kernel.org
Subject: [PATCH 4.14 1/3] bitops: always define asm-generic non-atomic
 bitops
Message-ID: <alpine.LRH.2.21.2211151153260.32285@file01.intranet.prod.int.rdu2.redhat.com>
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
 1 file changed, 130 insertions(+)

Index: linux-stable/include/asm-generic/bitops/generic-non-atomic.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-stable/include/asm-generic/bitops/generic-non-atomic.h	2022-11-14 22:15:42.000000000 +0100
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

