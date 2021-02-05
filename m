Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41AD631144F
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbhBEWDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:03:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:44982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230170AbhBEOyw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:54:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D51D6505A;
        Fri,  5 Feb 2021 14:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534349;
        bh=JDTuSXzEilPQorvKVII5BkHu2GyI2daOiBcGSTjm18Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hJKNk9bKoali/bpdvV1CatnDnYJ4kD9Y+VkWwp7/muVksRyIukhBgkM1frzcQvvwA
         +aRgAykPY9t7R4QL/mEUFhiW3bqleI4Kv34ruD5V0TXZHIX6Iz3EzYq6x6bCefU98T
         x0NNe84Kp+NgV8TTEh4z2droTyGfQcY5jQoqwZm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: [PATCH 5.4 06/32] arm64: Fix kernel address detection of __is_lm_address()
Date:   Fri,  5 Feb 2021 15:07:21 +0100
Message-Id: <20210205140652.618550818@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140652.348864025@linuxfoundation.org>
References: <20210205140652.348864025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincenzo Frascino <vincenzo.frascino@arm.com>

commit 519ea6f1c82fcdc9842908155ae379de47818778 upstream.

Currently, the __is_lm_address() check just masks out the top 12 bits
of the address, but if they are 0, it still yields a true result.
This has as a side effect that virt_addr_valid() returns true even for
invalid virtual addresses (e.g. 0x0).

Fix the detection checking that it's actually a kernel address starting
at PAGE_OFFSET.

Fixes: 68dd8ef32162 ("arm64: memory: Fix virt_addr_valid() using __is_lm_address()")
Cc: <stable@vger.kernel.org> # 5.4.x
Cc: Will Deacon <will@kernel.org>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Link: https://lore.kernel.org/r/20210126134056.45747-1-vincenzo.frascino@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/memory.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -247,11 +247,11 @@ static inline const void *__tag_set(cons
 
 
 /*
- * The linear kernel range starts at the bottom of the virtual address
- * space. Testing the top bit for the start of the region is a
- * sufficient check and avoids having to worry about the tag.
+ * Check whether an arbitrary address is within the linear map, which
+ * lives in the [PAGE_OFFSET, PAGE_END) interval at the bottom of the
+ * kernel's TTBR1 address range.
  */
-#define __is_lm_address(addr)	(!(((u64)addr) & BIT(vabits_actual - 1)))
+#define __is_lm_address(addr)	(((u64)(addr) ^ PAGE_OFFSET) < (PAGE_END - PAGE_OFFSET))
 
 #define __lm_to_phys(addr)	(((addr) & ~PAGE_OFFSET) + PHYS_OFFSET)
 #define __kimg_to_phys(addr)	((addr) - kimage_voffset)


