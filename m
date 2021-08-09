Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18633E4409
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 12:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234201AbhHIKmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 06:42:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32351 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234281AbhHIKmt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 06:42:49 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210809104225epoutp0161bac77dadca3bcdc4ee63ca35a3c7fc~ZnVjrgbzM2859928599epoutp01X
        for <stable@vger.kernel.org>; Mon,  9 Aug 2021 10:42:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210809104225epoutp0161bac77dadca3bcdc4ee63ca35a3c7fc~ZnVjrgbzM2859928599epoutp01X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1628505745;
        bh=v0j5FQlm2GQWys106PT670RaeBMi9Wm8bT5hVvdf3mU=;
        h=From:To:Cc:Subject:Date:References:From;
        b=D5/snXVCdHEsZf17Y9HGYJpDBXe2Ul0BjK0bLvYRpbqiTnb17Zs4cnUzDWlvjkgNt
         +gpvseFipDue16/33oF6YV3TCHcYNEsMvRqnmFAQnNJGwqtsNPRzEp97EuZe6f5RJM
         sq6zBBwDD6QeW60SzZ9qBRLvKDm9IXug3DS/ASJY=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210809104225epcas2p4dbf694f333f499cd7bba5f91e35e49d1~ZnVjNtifj3231332313epcas2p4Z;
        Mon,  9 Aug 2021 10:42:25 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.185]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Gjt266P0Kz4x9Pv; Mon,  9 Aug
        2021 10:42:22 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E3.61.09541.E8601116; Mon,  9 Aug 2021 19:42:22 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210809104221epcas2p32224190e0e8fd461c28076f4f4451cef~ZnVgHlg3Z2101321013epcas2p3-;
        Mon,  9 Aug 2021 10:42:21 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210809104221epsmtrp1848568ca0288f5c28ee930eaec9b41a0~ZnVgG3ED60079200792epsmtrp1H;
        Mon,  9 Aug 2021 10:42:21 +0000 (GMT)
X-AuditID: b6c32a46-0abff70000002545-f8-6111068e8c64
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DD.53.08394.D8601116; Mon,  9 Aug 2021 19:42:21 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210809104221epsmtip2975c529cb9a886461e73f477e2dd204a~ZnVf33vAI2922529225epsmtip2Y;
        Mon,  9 Aug 2021 10:42:21 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Will Deacon <will@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        stable@vger.kernel.org, Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH] arm64: vdso: Avoid ISB after reading from cntvct_el0
Date:   Mon,  9 Aug 2021 19:44:50 +0900
Message-Id: <20210809104450.114771-1-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFKsWRmVeSWpSXmKPExsWy7bCmhW4fm2Ciwfb5Jhbvl/UwWlzer23R
        vHg9m8WmNdfYLBZsfMRosfffTxaLljumDuwea+atYfTYtKqTzWP/3DXsHn1bVjF6fN4kF8Aa
        lWOTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SEkkJZ
        Yk4pUCggsbhYSd/Opii/tCRVISO/uMRWKbUgJafA0LBArzgxt7g0L10vOT/XytDAwMgUqDIh
        J2PGnK2sBcc1KhbcmMPSwDhVsYuRg0NCwETi6myeLkZODiGBHYwSi7qluxi5gOxPjBL31s5l
        gUh8A3ImWYHYIPUP535hh4jvZZS4u90KouEjo8TTlpNgCTYBXYktz18xgtgiAmESB3d0s4HY
        zAIHGCXm/yoHsYUFXCU2nD4LFmcRUJXYuXoVE4jNK2Av8XjNUSaIZfISp5YdhIoLSpyc+YQF
        Yo68RPPW2cwgiyUEzrFLXHi3mQ2iwUWi5/lEFghbWOLV8S3sELaUxMv+NnaIhm5GidZH/6ES
        qxklOht9IGx7iV/Tt7CCgoVZQFNi/S59SAgpSxy5BbWXT6Lj8F92iDCvREebEESjusSB7dOh
        tspKdM/5zApR4iExe24IJKhiJU5u7GeewCg/C8kzs5A8Mwth7QJG5lWMYqkFxbnpqcVGBUbI
        EbqJEZwItdx2ME55+0HvECMTB+MhRgkOZiUR3vUz+BKFeFMSK6tSi/Lji0pzUosPMZoCg3ci
        s5Rocj4wFeeVxBuaGpmZGViaWpiaGVkoifNqxH1NEBJITyxJzU5NLUgtgulj4uCUamA6tfhQ
        pTnbz8qU9f07rx2fnj3PxFq1ltX/7eFtKqmrXBWzXgZ+mX5w/6nye/eeHTki6nikz+Z6wDcV
        lql1G1xKt4SIrWF6nnreQ4X7t1TFD/PTwvfK+a+6C+S9sTsuGb2co/zNw5ypjS261v5av584
        N22e9bxu0uTb8Vrz9bZp2EqfXuWhznD5T2D+fPGs1A0f/ts+uMOwY4soW8Juj7IejzVOC/4p
        MWy636Gx6ppi4GdfFaG91Yf5f3BMTEn/oX2W1zVg/Zf+s0eeHbr8onmq9PTmQP+V7f/sfnHM
        eXrjcoWO66wnGz3mKfgEnJ7cu8jgwoMZnbPTJbkvH1JguWvIbHAwraz44PT7h++o3sn+pcRS
        nJFoqMVcVJwIAOsUTtcNBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsWy7bCSvG4vm2CiwfkFShbvl/UwWlzer23R
        vHg9m8WmNdfYLBZsfMRosfffTxaLljumDuwea+atYfTYtKqTzWP/3DXsHn1bVjF6fN4kF8Aa
        xWWTkpqTWZZapG+XwJUxY85W1oLjGhULbsxhaWCcqtjFyMkhIWAi8XDuF/YuRi4OIYHdjBId
        J6ezQyRkJZ692wFlC0vcbznCClH0nlHiwfJdbCAJNgFdiS3PXzGC2CICYRK7FnaBFTELHGGU
        OL5jHRNIQljAVWLD6bNgDSwCqhI7V68Ci/MK2Es8XnOUCWKDvMSpZQeh4oISJ2c+YQGxmYHi
        zVtnM09g5JuFJDULSWoBI9MqRsnUguLc9NxiwwLDvNRyveLE3OLSvHS95PzcTYzgINXS3MG4
        fdUHvUOMTByMhxglOJiVRHjXz+BLFOJNSaysSi3Kjy8qzUktPsQozcGiJM57oetkvJBAemJJ
        anZqakFqEUyWiYNTqoFpg2VTVvuMD18vJKZ2M+Qeu7NMcc6ME+b+xXrdul+2T/t8oEC9Ys2J
        6lAhv+ZC//i7N6JCtR4as1x6rXZ+47GvL9RnXlz0zr6fJ9Xt9rU5WT0M5QuF9s5us14fWfdg
        Ueeqb7YuJ2bvDp1jWnrlt5HAY17OQKWpr/Zv/t6cZcdk/mqn9TSHWW3hC48dljthb3DU9tGX
        K3Pee2cuF3mp9X1dtU6/Wvq+/+cX+N9wOxw7+9ODCeud+pUV1UKmxi956XGB4fqOzw6P++1M
        n700mTb5h9fFx0x3/maWKDQf9drzLUN+k+SVvafuPb90JHTBhsLQ599vZddMebjZaketdpeG
        0MaF7n8jhPSkz77ZGaR+8oMSS3FGoqEWc1FxIgDJXkR6wQIAAA==
X-CMS-MailID: 20210809104221epcas2p32224190e0e8fd461c28076f4f4451cef
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210809104221epcas2p32224190e0e8fd461c28076f4f4451cef
References: <CGME20210809104221epcas2p32224190e0e8fd461c28076f4f4451cef@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit 77ec462536a13d4b428a1eead725c4818a49f0b1 upstream.
(The upstream patch was not marked as fixed but this can fix
Fixes: 28b1a824a4f4 ("arm64: vdso: Substitute gettimeofday() with C implementation")
sysbench memory comparison:
- Before: 3072.00 MB transferred (2601.11 MB/sec)
- After:  3072.00 MB transferred (3217.86 MB/sec)
)

We can avoid the expensive ISB instruction after reading the counter in
the vDSO gettime functions by creating a fake address hazard against a
dummy stack read, just like we do inside the kernel.

Fixes: 28b1a824a4f4 ("arm64: vdso: Substitute gettimeofday() with C implementation")
Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Link: https://lore.kernel.org/r/20210318170738.7756-5-will@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
CC: stable@vger.kernel.org
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
I found this regression while executing below sysbench benchmark command.
It showed lower score compared with internal 4.19 version. The
regression can be seen from 5.4/5.10 kernel version.

$ sysbench --test=memory --memory-block-size=1K --memory-scope=global --memory-total-size=3G --memory-oper=read run
- Before: 3072.00 MB transferred (2601.11 MB/sec)
- After:  3072.00 MB transferred (3217.86 MB/sec)

I also tested this patch with below simple program and can showed
similar result.

- Before: Iter: 1000000 Diff: 65182.000000 usec
- After : Iter: 1000000 Diff: 48707.000000 usec

#include <stdio.h>
#include <sys/time.h>

#define LOOPCNT	1000000

int main(void)
{
	struct timeval tv, start, end;
	int i;
	double diff;

	gettimeofday(&start, NULL);
	for (i = 0; i < LOOPCNT; i++)
		gettimeofday(&tv, NULL);
	gettimeofday(&end, NULL);

	diff = (end.tv_sec * 1000000 + end.tv_usec) - (start.tv_sec * 1000000 + start.tv_usec);

	printf("Iter: %d Diff: %f usec\n", LOOPCNT, diff);

	return 0;
}

 arch/arm64/include/asm/arch_timer.h        | 21 ---------------------
 arch/arm64/include/asm/barrier.h           | 19 +++++++++++++++++++
 arch/arm64/include/asm/vdso/gettimeofday.h |  6 +-----
 3 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index 9f0ec21d6327..88d20f04c64a 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -165,25 +165,6 @@ static inline void arch_timer_set_cntkctl(u32 cntkctl)
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
@@ -224,8 +205,6 @@ static __always_inline u64 __arch_counter_get_cntvct(void)
 	return cnt;
 }
 
-#undef arch_counter_enforce_ordering
-
 static inline int arch_timer_arch_init(void)
 {
 	return 0;
diff --git a/arch/arm64/include/asm/barrier.h b/arch/arm64/include/asm/barrier.h
index c3009b0e5239..37d891af8ea5 100644
--- a/arch/arm64/include/asm/barrier.h
+++ b/arch/arm64/include/asm/barrier.h
@@ -70,6 +70,25 @@ static inline unsigned long array_index_mask_nospec(unsigned long idx,
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
diff --git a/arch/arm64/include/asm/vdso/gettimeofday.h b/arch/arm64/include/asm/vdso/gettimeofday.h
index 631ab1281633..4b4c0dac0e14 100644
--- a/arch/arm64/include/asm/vdso/gettimeofday.h
+++ b/arch/arm64/include/asm/vdso/gettimeofday.h
@@ -83,11 +83,7 @@ static __always_inline u64 __arch_get_hw_counter(s32 clock_mode,
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
-- 
2.32.0

