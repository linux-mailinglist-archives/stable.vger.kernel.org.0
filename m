Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7757B303F0A
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 14:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392694AbhAZNmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 08:42:32 -0500
Received: from foss.arm.com ([217.140.110.172]:40152 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404692AbhAZNmM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 08:42:12 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 623C831B;
        Tue, 26 Jan 2021 05:41:24 -0800 (PST)
Received: from e119884-lin.cambridge.arm.com (e119884-lin.cambridge.arm.com [10.1.196.72])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 45C933F68F;
        Tue, 26 Jan 2021 05:41:23 -0800 (PST)
From:   Vincenzo Frascino <vincenzo.frascino@arm.com>
To:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com
Cc:     Vincenzo Frascino <vincenzo.frascino@arm.com>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH] arm64: Fix kernel address detection of __is_lm_address()
Date:   Tue, 26 Jan 2021 13:40:56 +0000
Message-Id: <20210126134056.45747-1-vincenzo.frascino@arm.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, the __is_lm_address() check just masks out the top 12 bits
of the address, but if they are 0, it still yields a true result.
This has as a side effect that virt_addr_valid() returns true even for
invalid virtual addresses (e.g. 0x0).

Fix the detection checking that it's actually a kernel address starting
at PAGE_OFFSET.

Fixes: f4693c2716b35 ("arm64: mm: extend linear region for 52-bit VA configurations")
Cc: <stable@vger.kernel.org> # 5.4.x
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
---
 arch/arm64/include/asm/memory.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 18fce223b67b..99d7e1494aaa 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -247,9 +247,11 @@ static inline const void *__tag_set(const void *addr, u8 tag)
 
 
 /*
- * The linear kernel range starts at the bottom of the virtual address space.
+ * Check whether an arbitrary address is within the linear map, which
+ * lives in the [PAGE_OFFSET, PAGE_END) interval at the bottom of the
+ * kernel's TTBR1 address range.
  */
-#define __is_lm_address(addr)	(((u64)(addr) & ~PAGE_OFFSET) < (PAGE_END - PAGE_OFFSET))
+#define __is_lm_address(addr)	(((u64)(addr) ^ PAGE_OFFSET) < (PAGE_END - PAGE_OFFSET))
 
 #define __lm_to_phys(addr)	(((addr) & ~PAGE_OFFSET) + PHYS_OFFSET)
 #define __kimg_to_phys(addr)	((addr) - kimage_voffset)
-- 
2.30.0

