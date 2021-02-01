Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4D030B010
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 20:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbhBATHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 14:07:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:38588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231184AbhBATHT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Feb 2021 14:07:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E26A464E8D;
        Mon,  1 Feb 2021 19:06:37 +0000 (UTC)
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-arm-kernel@lists.infradead.org,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] arm64: Do not pass tagged addresses to __is_lm_address()
Date:   Mon,  1 Feb 2021 19:06:33 +0000
Message-Id: <20210201190634.22942-2-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210201190634.22942-1-catalin.marinas@arm.com>
References: <20210201190634.22942-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 519ea6f1c82f ("arm64: Fix kernel address detection of
__is_lm_address()") fixed the incorrect validation of addresses below
PAGE_OFFSET. However, it no longer allowed tagged addresses to be passed
to virt_addr_valid().

Fix this by explicitly resetting the pointer tag prior to invoking
__is_lm_address(). This is consistent with the __lm_to_phys() macro.

Fixes: 519ea6f1c82f ("arm64: Fix kernel address detection of __is_lm_address()")
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: <stable@vger.kernel.org> # 5.4.x
Cc: Will Deacon <will@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm64/include/asm/memory.h | 2 +-
 arch/arm64/mm/physaddr.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 99d7e1494aaa..3c1aaa522cbd 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -332,7 +332,7 @@ static inline void *phys_to_virt(phys_addr_t x)
 #endif /* !CONFIG_SPARSEMEM_VMEMMAP || CONFIG_DEBUG_VIRTUAL */
 
 #define virt_addr_valid(addr)	({					\
-	__typeof__(addr) __addr = addr;					\
+	__typeof__(addr) __addr = __tag_reset(addr);			\
 	__is_lm_address(__addr) && pfn_valid(virt_to_pfn(__addr));	\
 })
 
diff --git a/arch/arm64/mm/physaddr.c b/arch/arm64/mm/physaddr.c
index 67a9ba9eaa96..cde44c13dda1 100644
--- a/arch/arm64/mm/physaddr.c
+++ b/arch/arm64/mm/physaddr.c
@@ -9,7 +9,7 @@
 
 phys_addr_t __virt_to_phys(unsigned long x)
 {
-	WARN(!__is_lm_address(x),
+	WARN(!__is_lm_address(__tag_reset(x)),
 	     "virt_to_phys used for non-linear address: %pK (%pS)\n",
 	      (void *)x,
 	      (void *)x);
