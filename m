Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35D9C5F3057
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 14:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiJCMbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 08:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiJCMbr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 08:31:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94A64361F
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 05:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664800305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bLn0Wx/L9VsvIoBWDz6eSq5e5ZE2dF59TACopB2UODE=;
        b=FdD15mNtUMtMdNTu8zLt6hUYOWpfgxkfL1sRBv29DyL8C83bYD9VLELI1Cee5iv17jARgC
        cknDBDZehoOKANODIZB0xFZPBbBXep0aL9QgM0hCRuALhFO3pqw1zeXwonV6DTnRInuiKq
        DkBKlIYAfKXBPByMM3Lkc0l6XSiksBQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-17-HjTmp4YfNE6JlcHvE_T2qA-1; Mon, 03 Oct 2022 08:31:44 -0400
X-MC-Unique: HjTmp4YfNE6JlcHvE_T2qA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B66F81C07587;
        Mon,  3 Oct 2022 12:31:43 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B17CDC15BA4;
        Mon,  3 Oct 2022 12:31:43 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 293CVhOw009920;
        Mon, 3 Oct 2022 08:31:43 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 293CVhxe009916;
        Mon, 3 Oct 2022 08:31:43 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Mon, 3 Oct 2022 08:31:43 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Greg KH <gregkh@linuxfoundation.org>
cc:     stable@vger.kernel.org
Subject: [PATCH] provide arch_test_bit_acquire for architectures that define
 test_bit
In-Reply-To: <alpine.LRH.2.02.2210030459050.10514@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.2210030831330.10514@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2209301128030.23900@file01.intranet.prod.int.rdu2.redhat.com> <YzflXQMdGLsjPb70@kroah.com> <alpine.LRH.2.02.2210030459050.10514@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is backport of the upstream patch d6ffe6067a54972564552ea45d320fb98db1ac5e
for the stable branch 4.19

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
--- linux-stable.orig/arch/alpha/include/asm/bitops.h	2022-09-30 15:48:24.000000000 +0200
+++ linux-stable/arch/alpha/include/asm/bitops.h	2022-09-30 15:48:24.000000000 +0200
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
--- linux-stable.orig/arch/hexagon/include/asm/bitops.h	2022-09-30 15:48:24.000000000 +0200
+++ linux-stable/arch/hexagon/include/asm/bitops.h	2022-09-30 15:48:24.000000000 +0200
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
--- linux-stable.orig/arch/ia64/include/asm/bitops.h	2022-09-30 15:48:24.000000000 +0200
+++ linux-stable/arch/ia64/include/asm/bitops.h	2022-09-30 15:48:24.000000000 +0200
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
--- linux-stable.orig/arch/m68k/include/asm/bitops.h	2022-09-30 15:48:24.000000000 +0200
+++ linux-stable/arch/m68k/include/asm/bitops.h	2022-09-30 15:48:24.000000000 +0200
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
--- linux-stable.orig/arch/s390/include/asm/bitops.h	2022-09-30 15:48:24.000000000 +0200
+++ linux-stable/arch/s390/include/asm/bitops.h	2022-09-30 15:49:53.000000000 +0200
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
--- linux-stable.orig/arch/sh/include/asm/bitops-op32.h	2022-09-30 15:48:24.000000000 +0200
+++ linux-stable/arch/sh/include/asm/bitops-op32.h	2022-09-30 15:48:24.000000000 +0200
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

