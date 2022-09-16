Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4CC75BAEC8
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 16:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbiIPOCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 10:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbiIPOCI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 10:02:08 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2741AB1A4
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 07:01:52 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 207so12044070pgc.7
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 07:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=4zSOH3Z6KkTDJEQ+cQmmIS0RVrgB88hfSSMmQOPO6us=;
        b=eUR15at4aNusI+PjFG/lgQzljpUkRiIJzNuUM28aY5DOKObsqVUIcKczJfTIUzMsvO
         dj30WiDJiizdPHuU9ZjqASFXjZgQZnobYA4Ufc8yCTuplz2n9BADId2OFWRU8Si+3Q5I
         7kHc619AFYdJPgT5oVcgHGnTd3lqKg/Wa8ezc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=4zSOH3Z6KkTDJEQ+cQmmIS0RVrgB88hfSSMmQOPO6us=;
        b=zu7ny+oAomQXpAc9aQAqQar/xibD4teNxfmiqjlFjKMtaajF+0Zv63aKRH0Nb6E6pm
         5qddZlv7In0fhlJDY05qKpRvDYvDVXcWP/kAOrgSSCHSSO+5aAMvwdXgWC2Xxko/L9Y0
         XGXlAEBl06tZCU/DRey2XW24g+xbEPyEZjDujG7pzmRmxhTm7ac1k5u9btYGfAWqKnst
         Djt0gFXlNsX+5GyMXFv3xC1Z/ArBpzNQx8xf/kFf3F0JPKcCDVaczmwch5yfjgwhMgbK
         atX4ZD/IjGX+JZCZoMeZvBsmfXJDg7d26ciDAo00Ln8GW7gj30dOM1fkXz9Fx2IhUSFp
         BiLQ==
X-Gm-Message-State: ACrzQf32PqwlBrBdqZRMsvsGchqOvXBF8a8hnXBkCBDH4leCJR7huMbN
        zQBmqYOzfDq8yS2CP0SlOZcAbQ==
X-Google-Smtp-Source: AMsMyM4hpMmVEL3fm5C/uFzXCqSUsvPdqnXy/v7qQ0Az8FWPnaxfR3hpleYuI6fFeRyMeL3nN2QZIQ==
X-Received: by 2002:a63:d312:0:b0:438:5cd8:8d56 with SMTP id b18-20020a63d312000000b004385cd88d56mr4756595pgg.615.1663336911874;
        Fri, 16 Sep 2022 07:01:51 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t3-20020a170902e84300b001782a0d3eeasm12283789plg.115.2022.09.16.07.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 07:01:50 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Yu Zhao <yuzhao@google.com>, dev@der-flo.net,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-mm@kvack.org,
        linux-hardening@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 2/3] x86/dumpstack: Inline copy_from_user_nmi()
Date:   Fri, 16 Sep 2022 06:59:55 -0700
Message-Id: <20220916135953.1320601-3-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220916135953.1320601-1-keescook@chromium.org>
References: <20220916135953.1320601-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7115; h=from:subject; bh=8gMTRWBZ8nM6q5PrKv/eYu8tnhlf0ctojtdeDb/b28g=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjJIFYRQM+ho9+tfYE5ObtAak9vEZzUoXIepUdlEy/ n60F5NiJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYySBWAAKCRCJcvTf3G3AJrPEEA CV+i8PMBeljvVCbWOjzo0O8yVEVDMQHLo4B7+8/wsgNYYMB/fq75YZkKuDzrTG35dJfdWvVsg2fCNM 114mIw5Ei2//eqHU7CwtXjbMVzLvO7TwApHxiyyWaF++dznIsROespnr3K1qlvaNWSZA4ZnIMc4q/l kh7kHK0aK6cPOq6Ez6g0LurkZJnIIWJfIEGgHePNXZsuxrb6BHJd3+4I4FlFLczQVKg+yogkwHiW4f kMv0COhxGLK4A2ZQkr4kMNwWLf/UGPi3VgcZi58LD1eahPDndgLnqvejAftrMt9BtMaxFQq4D0iUjD snSoc/mREjzZRWeF7uDep3ELCApHKCpihtNAzfmXOe9u/891SPcRU4wL6ejzq8Fd9QwDlMJlK4LHwW tQdSWb0im3g3W9TrqiZmmPc3Z9psJMHkCUYfAsUPFViBLOZBx6A2YoyQABl/FIkUByFeZwhD7D4n0C Tint5FCLiBs+NnYnF0srIY1rviLutQHbw5DI44R4esft49ANQPPKIMVl0Ffiifuh+vsvgI0kfY2HfE Xn/7LZfid5nL+vJ7jQczCfYeD0+ymEdDAUXlX2tKu2mdEUWIxcrygvaz+WTAlscKXJ6I8jhfd5bOcU Dnh3Yy45Qg/e5Kivm6aoTKxPgqZ7qMTgHj24kaqtoKWMh30UK5y3pn/YucSA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The check_object_size() helper under CONFIG_HARDENED_USERCOPY is
designed to skip any checks where the length is known at compile time as
a reasonable heuristic to avoid "likely known-good" cases. However, it can
only do this when the copy_*_user() helpers are, themselves, inline too.

Using find_vmap_area() requires taking a spinlock. The check_object_size()
helper can call find_vmap_area() when the destination is in vmap memory.
If show_regs() is called in interrupt context, it will attempt a call to
copy_from_user_nmi(), which may call check_object_size() and then
find_vmap_area(). If something in normal context happens to be in the
middle of calling find_vmap_area() (with the spinlock held), the interrupt
handler will hang forever.

The copy_from_user_nmi() call is actually being called with a fixed-size
length, so check_object_size() should never have been called in the
first place. In order for check_object_size() to see that the length is
a fixed size, inline copy_from_user_nmi(), as already done with all the
other uaccess helpers.

Reported-by: Yu Zhao <yuzhao@google.com>
Link: https://lore.kernel.org/all/CAOUHufaPshtKrTWOz7T7QFYUNVGFm0JBjvM700Nhf9qEL9b3EQ@mail.gmail.com
Reported-by: dev@der-flo.net
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Fixes: 0aef499f3172 ("mm/usercopy: Detect vmalloc overruns")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/uaccess.h |  2 --
 arch/x86/kernel/dumpstack.c    |  4 +--
 arch/x86/lib/Makefile          |  2 +-
 arch/x86/lib/usercopy.c        | 50 ----------------------------------
 include/linux/uaccess.h        | 41 ++++++++++++++++++++++++++++
 5 files changed, 44 insertions(+), 55 deletions(-)
 delete mode 100644 arch/x86/lib/usercopy.c

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index e9390eea861b..f47c0c752e7a 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -498,8 +498,6 @@ struct __large_struct { unsigned long buf[100]; };
 		: : ltype(x), "m" (__m(addr))				\
 		: : label)
 
-extern unsigned long
-copy_from_user_nmi(void *to, const void __user *from, unsigned long n);
 extern __must_check long
 strncpy_from_user(char *dst, const char __user *src, long count);
 
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index afae4dd77495..b59d59ef10d2 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -72,8 +72,8 @@ static void printk_stack_address(unsigned long address, int reliable,
 	printk("%s %s%pBb\n", log_lvl, reliable ? "" : "? ", (void *)address);
 }
 
-static int copy_code(struct pt_regs *regs, u8 *buf, unsigned long src,
-		     unsigned int nbytes)
+static __always_inline int
+copy_code(struct pt_regs *regs, u8 *buf, unsigned long src, unsigned int nbytes)
 {
 	if (!user_mode(regs))
 		return copy_from_kernel_nofault(buf, (u8 *)src, nbytes);
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index f76747862bd2..aeb5cd634e27 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -42,7 +42,7 @@ clean-files := inat-tables.c
 obj-$(CONFIG_SMP) += msr-smp.o cache-smp.o
 
 lib-y := delay.o misc.o cmdline.o cpu.o
-lib-y += usercopy_$(BITS).o usercopy.o getuser.o putuser.o
+lib-y += usercopy_$(BITS).o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
 lib-y += pc-conf-reg.o
 lib-$(CONFIG_ARCH_HAS_COPY_MC) += copy_mc.o copy_mc_64.o
diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
deleted file mode 100644
index 959489f2f814..000000000000
--- a/arch/x86/lib/usercopy.c
+++ /dev/null
@@ -1,50 +0,0 @@
-/*
- * User address space access functions.
- *
- *  For licencing details see kernel-base/COPYING
- */
-
-#include <linux/uaccess.h>
-#include <linux/export.h>
-
-/**
- * copy_from_user_nmi - NMI safe copy from user
- * @to:		Pointer to the destination buffer
- * @from:	Pointer to a user space address of the current task
- * @n:		Number of bytes to copy
- *
- * Returns: The number of not copied bytes. 0 is success, i.e. all bytes copied
- *
- * Contrary to other copy_from_user() variants this function can be called
- * from NMI context. Despite the name it is not restricted to be called
- * from NMI context. It is safe to be called from any other context as
- * well. It disables pagefaults across the copy which means a fault will
- * abort the copy.
- *
- * For NMI context invocations this relies on the nested NMI work to allow
- * atomic faults from the NMI path; the nested NMI paths are careful to
- * preserve CR2.
- */
-unsigned long
-copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
-{
-	unsigned long ret;
-
-	if (!__access_ok(from, n))
-		return n;
-
-	if (!nmi_uaccess_okay())
-		return n;
-
-	/*
-	 * Even though this function is typically called from NMI/IRQ context
-	 * disable pagefaults so that its behaviour is consistent even when
-	 * called from other contexts.
-	 */
-	pagefault_disable();
-	ret = __copy_from_user_inatomic(to, from, n);
-	pagefault_enable();
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(copy_from_user_nmi);
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 065e121d2a86..fee141ed8f95 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -273,6 +273,47 @@ __copy_from_user_inatomic_nocache(void *to, const void __user *from,
 
 #endif		/* ARCH_HAS_NOCACHE_UACCESS */
 
+/**
+ * copy_from_user_nmi - NMI safe copy from user
+ * @to:		Pointer to the destination buffer
+ * @from:	Pointer to a user space address of the current task
+ * @n:		Number of bytes to copy
+ *
+ * Returns: The number of not copied bytes. 0 is success, i.e. all bytes copied
+ *
+ * Contrary to other copy_from_user() variants this function can be called
+ * from NMI context. Despite the name it is not restricted to be called
+ * from NMI context. It is safe to be called from any other context as
+ * well. It disables pagefaults across the copy which means a fault will
+ * abort the copy.
+ *
+ * For NMI context invocations this relies on the nested NMI work to allow
+ * atomic faults from the NMI path; the nested NMI paths are careful to
+ * preserve CR2.
+ */
+static __always_inline unsigned long
+copy_from_user_nmi(void *to, const void __user *from, const unsigned long n)
+{
+	unsigned long ret;
+
+	if (!__access_ok(from, n))
+		return n;
+
+	if (!nmi_uaccess_okay())
+		return n;
+
+	/*
+	 * Even though this function is typically called from NMI/IRQ context
+	 * disable pagefaults so that its behaviour is consistent even when
+	 * called from other contexts.
+	 */
+	pagefault_disable();
+	ret = __copy_from_user_inatomic(to, from, n);
+	pagefault_enable();
+
+	return ret;
+}
+
 extern __must_check int check_zeroed_user(const void __user *from, size_t size);
 
 /**
-- 
2.34.1

