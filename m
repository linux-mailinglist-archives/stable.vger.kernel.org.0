Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7D45F3059
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 14:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiJCMcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 08:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiJCMcX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 08:32:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE602A94C
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 05:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664800341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SIrSVqbwQLveH7/l0ub5IGmwX2RdselGXus2LTILb8w=;
        b=CzqdSgMG9tC31/CcCrFcCzfjJvieAgJZkIuc9rU6teRHBFscZSyfe3zYgqXsY8DWGUYSd5
        fkaC1Ov4FppFdIwQ/GeJZRSWs0qGfv2Dc17+2gco7D6kGrOaZKZSCyK0Heoaby8KSOI4Fn
        qOFBkEEvW6UXIfwwEoasqGlrhyndfr0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-44-asFb3a7YMxauTl1Oo4HBhA-1; Mon, 03 Oct 2022 08:32:18 -0400
X-MC-Unique: asFb3a7YMxauTl1Oo4HBhA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F4EE185A7A3;
        Mon,  3 Oct 2022 12:32:18 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A90A40C6EC2;
        Mon,  3 Oct 2022 12:32:18 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 293CWIr7009961;
        Mon, 3 Oct 2022 08:32:18 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 293CWIk6009957;
        Mon, 3 Oct 2022 08:32:18 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Mon, 3 Oct 2022 08:32:18 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Greg KH <gregkh@linuxfoundation.org>
cc:     stable@vger.kernel.org
Subject: [PATCH] provide arch_test_bit_acquire for architectures that define
 test_bit
In-Reply-To: <alpine.LRH.2.02.2210030459050.10514@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.2210030832050.10514@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2209301128030.23900@file01.intranet.prod.int.rdu2.redhat.com> <YzflXQMdGLsjPb70@kroah.com> <alpine.LRH.2.02.2210030459050.10514@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is backport of the upstream patch d6ffe6067a54972564552ea45d320fb98db1ac5e
for the stable branch 4.9

provide arch_test_bit_acquire for architectures that define test_bit

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
 arch/hexagon/include/asm/bitops.h |   15 +++++++++++++++
 arch/ia64/include/asm/bitops.h    |    7 +++++++
 arch/m68k/include/asm/bitops.h    |    6 ++++++
 arch/s390/include/asm/bitops.h    |    7 +++++++
 arch/sh/include/asm/bitops-op32.h |    7 +++++++
 6 files changed, 49 insertions(+)

Index: linux-stable/arch/alpha/include/asm/bitops.h
===================================================================
--- linux-stable.orig/arch/alpha/include/asm/bitops.h	2022-09-30 16:03:22.000000000 +0200
+++ linux-stable/arch/alpha/include/asm/bitops.h	2022-09-30 16:03:22.000000000 +0200
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
--- linux-stable.orig/arch/hexagon/include/asm/bitops.h	2022-09-30 16:03:22.000000000 +0200
+++ linux-stable/arch/hexagon/include/asm/bitops.h	2022-09-30 16:03:22.000000000 +0200
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
--- linux-stable.orig/arch/ia64/include/asm/bitops.h	2022-09-30 16:03:22.000000000 +0200
+++ linux-stable/arch/ia64/include/asm/bitops.h	2022-09-30 16:03:22.000000000 +0200
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
--- linux-stable.orig/arch/m68k/include/asm/bitops.h	2022-09-30 16:03:22.000000000 +0200
+++ linux-stable/arch/m68k/include/asm/bitops.h	2022-09-30 16:03:22.000000000 +0200
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
--- linux-stable.orig/arch/s390/include/asm/bitops.h	2022-09-30 16:03:22.000000000 +0200
+++ linux-stable/arch/s390/include/asm/bitops.h	2022-09-30 16:03:22.000000000 +0200
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
--- linux-stable.orig/arch/sh/include/asm/bitops-op32.h	2022-09-30 16:03:22.000000000 +0200
+++ linux-stable/arch/sh/include/asm/bitops-op32.h	2022-09-30 16:03:22.000000000 +0200
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

