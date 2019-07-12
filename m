Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6473D66623
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbfGLF3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:29:12 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39418 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLF3L (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:29:11 -0400
Received: by mail-pg1-f195.google.com with SMTP id u17so4002137pgi.6
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kHvdeN9oObJ1DWOknB6wJwOgumkOXHrRy2jfFMpABJ8=;
        b=hM1jomaku7YbTVsAoc4MF43HHAKnEowYYJJHt/ujVKG5+gImW/mKJgOiMQ3Bt1wvjx
         t72Kf3zjoxonK9qtPyFBV7PaBIvF1BLLUigcCeozquAUDEqkeEjOx72qr2XpJ2/LKQpE
         C9X5M+NPSvf3J7HwTmzqm6RsYFChmRfJyvkjWYOXkCgXPToCESKDVaHgbssqbdwrT0zW
         YeeqDKjniFcGnDv7qgTjBNhzpi/kvK1zKpa/FPZUGKNu/M4NhxLPOLjaGBmzGj2baKWS
         LRNXHssnuKnY8Z5pH7O8slUYXXAeWGvFvM353Gi/FDsoWnGa8Axw/prb+0MK346eafhJ
         AkKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kHvdeN9oObJ1DWOknB6wJwOgumkOXHrRy2jfFMpABJ8=;
        b=CkqqrajIREGfKe8Jr0FeVR9vaz20FR+1bo9gOAE+hi9OlnC7CmY3J4CTbcl4xcO2Mv
         SH8W6inIvWdDBPwIavsETgTL/pGyExHFuHCafCgrXPFsWTbgHG1Mec90mkR6efsirqhj
         6Zip9BspQmeTtR+ZiKqgHE7oFdBsInm0vjvIfEHKp5Z2gO7eO7zBgmLEbSExwodygiFD
         99bsoHnuVQZrFeCCIsu3UMeWe8/s7F2RFvRnKA8gAzPMBT9XuuCtSjH5JqH/R23wI0/S
         l5cP6mXcZJ+6aWjps8lIo+VsvUD9jC9Aig7wTCTJbTLjnMuGCQf7vdvslFFjEw7lk2B0
         vj3w==
X-Gm-Message-State: APjAAAUJ8SQh9PyqNCNBenI6a5d12tXlCKDC5qQcwZuT4/y2lIMyugdX
        djAEexDPVxps65o7cl2n6U4cw28B2i0=
X-Google-Smtp-Source: APXvYqyP9/Df7wdYCYKedEiicK5+IIMsTu0a3lFSqHuijjNoBHQAp8Gxt/CH557Y4q1AR7Yh/eMbqQ==
X-Received: by 2002:a17:90a:17a6:: with SMTP id q35mr9421112pja.118.1562909350473;
        Thu, 11 Jul 2019 22:29:10 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id f17sm6063670pgv.16.2019.07.11.22.29.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:29:09 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 V2 04/43] arm64: Make USER_DS an inclusive limit
Date:   Fri, 12 Jul 2019 10:57:52 +0530
Message-Id: <c711de522a83025712b28fdb88d945f6a5c662fa.1562908074.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

commit 51369e398d0d33e8f524314e672b07e8cf870e79 upstream.

Currently, USER_DS represents an exclusive limit while KERNEL_DS is
inclusive. In order to do some clever trickery for speculation-safe
masking, we need them both to behave equivalently - there aren't enough
bits to make KERNEL_DS exclusive, so we have precisely one option. This
also happens to correct a longstanding false negative for a range
ending on the very top byte of kernel memory.

Mark Rutland points out that we've actually got the semantics of
addresses vs. segments muddled up in most of the places we need to
amend, so shuffle the {USER,KERNEL}_DS definitions around such that we
can correct those properly instead of just pasting "-1"s everywhere.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ 4.4: Dropped changes from fault.c and fixed minor rebase conflict ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/processor.h |  3 ++
 arch/arm64/include/asm/uaccess.h   | 45 +++++++++++++++++-------------
 arch/arm64/kernel/entry.S          |  4 +--
 3 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 75d9ef6c457c..ff1449c25bf4 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -21,6 +21,9 @@
 
 #define TASK_SIZE_64		(UL(1) << VA_BITS)
 
+#define KERNEL_DS	UL(-1)
+#define USER_DS		(TASK_SIZE_64 - 1)
+
 #ifndef __ASSEMBLY__
 
 /*
diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index 829fa6d3e561..c625cc5531fc 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -56,10 +56,7 @@ struct exception_table_entry
 
 extern int fixup_exception(struct pt_regs *regs);
 
-#define KERNEL_DS	(-1UL)
 #define get_ds()	(KERNEL_DS)
-
-#define USER_DS		TASK_SIZE_64
 #define get_fs()	(current_thread_info()->addr_limit)
 
 static inline void set_fs(mm_segment_t fs)
@@ -87,22 +84,32 @@ static inline void set_fs(mm_segment_t fs)
  * Returns 1 if the range is valid, 0 otherwise.
  *
  * This is equivalent to the following test:
- * (u65)addr + (u65)size <= current->addr_limit
- *
- * This needs 65-bit arithmetic.
+ * (u65)addr + (u65)size <= (u65)current->addr_limit + 1
  */
-#define __range_ok(addr, size)						\
-({									\
-	unsigned long __addr = (unsigned long __force)(addr);		\
-	unsigned long flag, roksum;					\
-	__chk_user_ptr(addr);						\
-	asm("adds %1, %1, %3; ccmp %1, %4, #2, cc; cset %0, ls"		\
-		: "=&r" (flag), "=&r" (roksum)				\
-		: "1" (__addr), "Ir" (size),				\
-		  "r" (current_thread_info()->addr_limit)		\
-		: "cc");						\
-	flag;								\
-})
+static inline unsigned long __range_ok(unsigned long addr, unsigned long size)
+{
+	unsigned long limit = current_thread_info()->addr_limit;
+
+	__chk_user_ptr(addr);
+	asm volatile(
+	// A + B <= C + 1 for all A,B,C, in four easy steps:
+	// 1: X = A + B; X' = X % 2^64
+	"	adds	%0, %0, %2\n"
+	// 2: Set C = 0 if X > 2^64, to guarantee X' > C in step 4
+	"	csel	%1, xzr, %1, hi\n"
+	// 3: Set X' = ~0 if X >= 2^64. For X == 2^64, this decrements X'
+	//    to compensate for the carry flag being set in step 4. For
+	//    X > 2^64, X' merely has to remain nonzero, which it does.
+	"	csinv	%0, %0, xzr, cc\n"
+	// 4: For X < 2^64, this gives us X' - C - 1 <= 0, where the -1
+	//    comes from the carry in being clear. Otherwise, we are
+	//    testing X' - C == 0, subject to the previous adjustments.
+	"	sbcs	xzr, %0, %1\n"
+	"	cset	%0, ls\n"
+	: "+r" (addr), "+r" (limit) : "Ir" (size) : "cc");
+
+	return addr;
+}
 
 /*
  * When dealing with data aborts, watchpoints, or instruction traps we may end
@@ -111,7 +118,7 @@ static inline void set_fs(mm_segment_t fs)
  */
 #define untagged_addr(addr)		sign_extend64(addr, 55)
 
-#define access_ok(type, addr, size)	__range_ok(addr, size)
+#define access_ok(type, addr, size)	__range_ok((unsigned long)(addr), size)
 #define user_addr_max			get_fs
 
 /*
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index c849be9231bb..4c5013b09dcb 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -96,10 +96,10 @@
 	.else
 	add	x21, sp, #S_FRAME_SIZE
 	get_thread_info tsk
-	/* Save the task's original addr_limit and set USER_DS (TASK_SIZE_64) */
+	/* Save the task's original addr_limit and set USER_DS */
 	ldr	x20, [tsk, #TI_ADDR_LIMIT]
 	str	x20, [sp, #S_ORIG_ADDR_LIMIT]
-	mov	x20, #TASK_SIZE_64
+	mov	x20, #USER_DS
 	str	x20, [tsk, #TI_ADDR_LIMIT]
 	.endif /* \el == 0 */
 	mrs	x22, elr_el1
-- 
2.21.0.rc0.269.g1a574e7a288b

