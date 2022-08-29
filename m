Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3251D5A4405
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 09:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiH2Hm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 03:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiH2HmY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 03:42:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23554DF16
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 00:42:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E96D61140
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 07:42:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313FBC433C1;
        Mon, 29 Aug 2022 07:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661758941;
        bh=dM7vMC0qz8teQ/oLYWyCtAemmENhxxlNm/pEIsvl3CM=;
        h=Subject:To:Cc:From:Date:From;
        b=yJoqgw9Ghh3WLjLDGzQ4e3FtMsWGWytcF9EP2iEioGpi7OQcT8i1p8SiuxxXvpTsI
         t18zUkl53NYa2qn2lUu6wiKRdSNR97cH/4xWqkMHZTW1t22I0zcg/d1/rXKqfi57Qv
         91gyi/FihKWtORaEjXw8C7o0Tfj1Plmh9yjwYYgw=
Subject: FAILED: patch "[PATCH] provide arch_test_bit_acquire for architectures that define" failed to apply to 4.19-stable tree
To:     mpatocka@redhat.com, torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Aug 2022 09:42:04 +0200
Message-ID: <166175892411269@kroah.com>
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d6ffe6067a54972564552ea45d320fb98db1ac5e Mon Sep 17 00:00:00 2001
From: Mikulas Patocka <mpatocka@redhat.com>
Date: Fri, 26 Aug 2022 16:43:51 -0400
Subject: [PATCH] provide arch_test_bit_acquire for architectures that define
 test_bit

Some architectures define their own arch_test_bit and they also need
arch_test_bit_acquire, otherwise they won't compile.  We also clean up
the code by using the generic test_bit if that is equivalent to the
arch-specific version.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 8238b4579866 ("wait_on_bit: add an acquire memory barrier")
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/arch/alpha/include/asm/bitops.h b/arch/alpha/include/asm/bitops.h
index 492c7713ddae..bafb1c1f0fdc 100644
--- a/arch/alpha/include/asm/bitops.h
+++ b/arch/alpha/include/asm/bitops.h
@@ -283,11 +283,8 @@ arch___test_and_change_bit(unsigned long nr, volatile unsigned long *addr)
 	return (old & mask) != 0;
 }
 
-static __always_inline bool
-arch_test_bit(unsigned long nr, const volatile unsigned long *addr)
-{
-	return (1UL & (((const int *) addr)[nr >> 5] >> (nr & 31))) != 0UL;
-}
+#define arch_test_bit generic_test_bit
+#define arch_test_bit_acquire generic_test_bit_acquire
 
 /*
  * ffz = Find First Zero in word. Undefined if no zero exists,
diff --git a/arch/hexagon/include/asm/bitops.h b/arch/hexagon/include/asm/bitops.h
index da500471ac73..160d8f37fa1a 100644
--- a/arch/hexagon/include/asm/bitops.h
+++ b/arch/hexagon/include/asm/bitops.h
@@ -179,6 +179,21 @@ arch_test_bit(unsigned long nr, const volatile unsigned long *addr)
 	return retval;
 }
 
+static __always_inline bool
+arch_test_bit_acquire(unsigned long nr, const volatile unsigned long *addr)
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
 /*
  * ffz - find first zero in word.
  * @word: The word to search
diff --git a/arch/ia64/include/asm/bitops.h b/arch/ia64/include/asm/bitops.h
index 9f62af7fd7c4..1accb7842f58 100644
--- a/arch/ia64/include/asm/bitops.h
+++ b/arch/ia64/include/asm/bitops.h
@@ -331,11 +331,8 @@ arch___test_and_change_bit(unsigned long nr, volatile unsigned long *addr)
 	return (old & bit) != 0;
 }
 
-static __always_inline bool
-arch_test_bit(unsigned long nr, const volatile unsigned long *addr)
-{
-	return 1 & (((const volatile __u32 *) addr)[nr >> 5] >> (nr & 31));
-}
+#define arch_test_bit generic_test_bit
+#define arch_test_bit_acquire generic_test_bit_acquire
 
 /**
  * ffz - find the first zero bit in a long word
diff --git a/arch/m68k/include/asm/bitops.h b/arch/m68k/include/asm/bitops.h
index 470aed978590..e984af71df6b 100644
--- a/arch/m68k/include/asm/bitops.h
+++ b/arch/m68k/include/asm/bitops.h
@@ -157,11 +157,8 @@ arch___change_bit(unsigned long nr, volatile unsigned long *addr)
 	change_bit(nr, addr);
 }
 
-static __always_inline bool
-arch_test_bit(unsigned long nr, const volatile unsigned long *addr)
-{
-	return (addr[nr >> 5] & (1UL << (nr & 31))) != 0;
-}
+#define arch_test_bit generic_test_bit
+#define arch_test_bit_acquire generic_test_bit_acquire
 
 static inline int bset_reg_test_and_set_bit(int nr,
 					    volatile unsigned long *vaddr)
diff --git a/arch/s390/include/asm/bitops.h b/arch/s390/include/asm/bitops.h
index 9a7d15da966e..2de74fcd0578 100644
--- a/arch/s390/include/asm/bitops.h
+++ b/arch/s390/include/asm/bitops.h
@@ -176,14 +176,8 @@ arch___test_and_change_bit(unsigned long nr, volatile unsigned long *addr)
 	return old & mask;
 }
 
-static __always_inline bool
-arch_test_bit(unsigned long nr, const volatile unsigned long *addr)
-{
-	const volatile unsigned long *p = __bitops_word(nr, addr);
-	unsigned long mask = __bitops_mask(nr);
-
-	return *p & mask;
-}
+#define arch_test_bit generic_test_bit
+#define arch_test_bit_acquire generic_test_bit_acquire
 
 static inline bool arch_test_and_set_bit_lock(unsigned long nr,
 					      volatile unsigned long *ptr)
diff --git a/arch/sh/include/asm/bitops-op32.h b/arch/sh/include/asm/bitops-op32.h
index 565a85d8b7fb..5ace89b46507 100644
--- a/arch/sh/include/asm/bitops-op32.h
+++ b/arch/sh/include/asm/bitops-op32.h
@@ -135,16 +135,8 @@ arch___test_and_change_bit(unsigned long nr, volatile unsigned long *addr)
 	return (old & mask) != 0;
 }
 
-/**
- * arch_test_bit - Determine whether a bit is set
- * @nr: bit number to test
- * @addr: Address to start counting from
- */
-static __always_inline bool
-arch_test_bit(unsigned long nr, const volatile unsigned long *addr)
-{
-	return 1UL & (addr[BIT_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
-}
+#define arch_test_bit generic_test_bit
+#define arch_test_bit_acquire generic_test_bit_acquire
 
 #include <asm-generic/bitops/non-instrumented-non-atomic.h>
 

