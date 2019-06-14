Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C93545263
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbfFNDMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:12:09 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45611 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDMJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:12:09 -0400
Received: by mail-pf1-f194.google.com with SMTP id r1so476411pfq.12
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jM3DSSQ5QlZXEONoZT9K+P8C++Y23zetJjpY6WsFYS8=;
        b=hBCJXZ9T5rigkGtisPLeaNWQAqyrRUj2ZgHPm2y7iDH6diBfYxhmzU8hOKt3ZaXamK
         2Y1OGoXRoCAyflZlrfyE5IE48ZTOh8LM2OefFE5Hf+DNft2GN4OqskqBGJGsmugNMdFt
         zBEOm41x2PhNvmk0ARTG4AVFrStmDOxF/T9Rt9tNs9bKaaQ8ERB0NIlaWVvRxvqwEayX
         iLI/2ihNHk1NZ9eAlfuHKsihkm2KIHRT3d2QNEZv5sZx+XWTM8KFPOnsl82rRx9Qt5XT
         WNuhFgOeqQo/1ujIDrC/tQQx4oz5TCckXqLulhZWVW5SX/U+V/cniN5fSXvOdIQ5VkP+
         UqsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jM3DSSQ5QlZXEONoZT9K+P8C++Y23zetJjpY6WsFYS8=;
        b=UDmbb2B4eNmAHyMKq5OnLBisUmKX2g7UPY9Gyc+fK9e0npRWlhuSuJO4QBCnxuk2Xx
         LQUQ3QSQtEo4xKIF9LrO3Ssp9pXf8t+8nfL0+jJ3/lZVsjwYKKLXs54lbmaBmaVIay5e
         po7OS1uUVeZbpcidbGtSCOpNytDD/GSIrZeNgxNMgJgUf46/qYvcb7ZZkrPPyQ71XI0I
         QM3OffSeXwrhhm7mb4iXGFg9NkazuM60W/uw4spn+p6ZQf4Ytc85DBwJ6f7gI3SMiaZu
         dRtx9CF5bZ3dFdcaygEDZtaSmmjVqCJ/xlWtRjxGA8T3tlWdU7o61lUGlsAEgzdD7COI
         sZvw==
X-Gm-Message-State: APjAAAVCzKA/rBI7WnIshc5gqfDdyafX6q4DZho9MtHrjqbfmTSEpg6Y
        t/rKMX0FynrPuqcQPJqCZW9YKg==
X-Google-Smtp-Source: APXvYqzWFlyC3EJ/bVwwN3mi8OsYWxdTJ66D3uyl+Z/F0Uvt5mWUspb0ZlZluW6jd+3CS16mwNdxRw==
X-Received: by 2002:aa7:8e54:: with SMTP id d20mr7531785pfr.16.1560481927612;
        Thu, 13 Jun 2019 20:12:07 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id l20sm1008268pff.102.2019.06.13.20.12.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:12:07 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     linux-arm-kernel@lists.infradead.org,
        Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 05/45] arm64: Make USER_DS an inclusive limit
Date:   Fri, 14 Jun 2019 08:37:48 +0530
Message-Id: <86a5655ffd342f6f62ae1280cd5131868abfa6de.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
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
index 12d5b2b97f04..c49597ae529d 100644
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

