Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647783E80A2
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235866AbhHJRvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:51:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236737AbhHJRtl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:49:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90EF26115C;
        Tue, 10 Aug 2021 17:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617315;
        bh=AvNYSlBrEKEXQrAUJnoa3zL/BEXfezpG86BC/KMqIg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mh0wv7FQA/PW0b2NYoSUMA03ntPxEjQLBZsEwPHJhLqVDVGz+pDFeM2rFQajP7SYv
         s55K4aN6Tn/AVbCG7RYgdYPy/9m4lHOmF3g7L+VwTsR23lAzh6wcHmBCSxT23PNVLc
         6Lj+w0aNSp53qQQbh2o7Sqo/2ZxEjm0VkC5CwclA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH 5.10 113/135] arm64: vdso: Avoid ISB after reading from cntvct_el0
Date:   Tue, 10 Aug 2021 19:30:47 +0200
Message-Id: <20210810172959.632306472@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit 77ec462536a13d4b428a1eead725c4818a49f0b1 upstream.

We can avoid the expensive ISB instruction after reading the counter in
the vDSO gettime functions by creating a fake address hazard against a
dummy stack read, just like we do inside the kernel.

Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Link: https://lore.kernel.org/r/20210318170738.7756-5-will@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 arch/arm64/include/asm/arch_timer.h        |   21 ---------------------
 arch/arm64/include/asm/barrier.h           |   19 +++++++++++++++++++
 arch/arm64/include/asm/vdso/gettimeofday.h |    6 +-----
 3 files changed, 20 insertions(+), 26 deletions(-)

--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -165,25 +165,6 @@ static inline void arch_timer_set_cntkct
 	isb();
 }
 
-/*
- * Ensure that reads of the counter are treated the same as memory reads
- * for the purposes of ordering by subsequent memory barriers.
- *
- * This insanity brought to you by speculative system register reads,
- * out-of-order memory accesses, sequence locks and Thomas Gleixner.
- *
- * http://lists.infradead.org/pipermail/linux-arm-kernel/2019-February/631195.html
- */
-#define arch_counter_enforce_ordering(val) do {				\
-	u64 tmp, _val = (val);						\
-									\
-	asm volatile(							\
-	"	eor	%0, %1, %1\n"					\
-	"	add	%0, sp, %0\n"					\
-	"	ldr	xzr, [%0]"					\
-	: "=r" (tmp) : "r" (_val));					\
-} while (0)
-
 static __always_inline u64 __arch_counter_get_cntpct_stable(void)
 {
 	u64 cnt;
@@ -224,8 +205,6 @@ static __always_inline u64 __arch_counte
 	return cnt;
 }
 
-#undef arch_counter_enforce_ordering
-
 static inline int arch_timer_arch_init(void)
 {
 	return 0;
--- a/arch/arm64/include/asm/barrier.h
+++ b/arch/arm64/include/asm/barrier.h
@@ -70,6 +70,25 @@ static inline unsigned long array_index_
 	return mask;
 }
 
+/*
+ * Ensure that reads of the counter are treated the same as memory reads
+ * for the purposes of ordering by subsequent memory barriers.
+ *
+ * This insanity brought to you by speculative system register reads,
+ * out-of-order memory accesses, sequence locks and Thomas Gleixner.
+ *
+ * http://lists.infradead.org/pipermail/linux-arm-kernel/2019-February/631195.html
+ */
+#define arch_counter_enforce_ordering(val) do {				\
+	u64 tmp, _val = (val);						\
+									\
+	asm volatile(							\
+	"	eor	%0, %1, %1\n"					\
+	"	add	%0, sp, %0\n"					\
+	"	ldr	xzr, [%0]"					\
+	: "=r" (tmp) : "r" (_val));					\
+} while (0)
+
 #define __smp_mb()	dmb(ish)
 #define __smp_rmb()	dmb(ishld)
 #define __smp_wmb()	dmb(ishst)
--- a/arch/arm64/include/asm/vdso/gettimeofday.h
+++ b/arch/arm64/include/asm/vdso/gettimeofday.h
@@ -83,11 +83,7 @@ static __always_inline u64 __arch_get_hw
 	 */
 	isb();
 	asm volatile("mrs %0, cntvct_el0" : "=r" (res) :: "memory");
-	/*
-	 * This isb() is required to prevent that the seq lock is
-	 * speculated.#
-	 */
-	isb();
+	arch_counter_enforce_ordering(res);
 
 	return res;
 }


