Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4AF340E5E5
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242510AbhIPRQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:16:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345449AbhIPRHK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:07:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6804061401;
        Thu, 16 Sep 2021 16:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810158;
        bh=3YzuJpnFC6++lS73Cjev2j2VE/KDl8KjmZAwuijIgWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZgrExLQPe+qBCZmlRA2/uAGY/VXbv3T7d0tiO8/Jd+6iSq6X37Znr5aA+mUss7n6a
         V5un6TK5JCe/MiWai3CaH4wwcJpwytoRtiCsO5aaxnPvUOJbnPeHJYI/i4/kyNWa07
         HaNE/CVIS6xGkv0nhi26Po0TgOXiqiEDfa1hnVrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Steve Capper <steve.capper@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.14 039/432] arm64: head: avoid over-mapping in map_memory
Date:   Thu, 16 Sep 2021 17:56:28 +0200
Message-Id: <20210916155812.144477991@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

commit 90268574a3e8a6b883bd802d702a2738577e1006 upstream.

The `compute_indices` and `populate_entries` macros operate on inclusive
bounds, and thus the `map_memory` macro which uses them also operates
on inclusive bounds.

We pass `_end` and `_idmap_text_end` to `map_memory`, but these are
exclusive bounds, and if one of these is sufficiently aligned (as a
result of kernel configuration, physical placement, and KASLR), then:

* In `compute_indices`, the computed `iend` will be in the page/block *after*
  the final byte of the intended mapping.

* In `populate_entries`, an unnecessary entry will be created at the end
  of each level of table. At the leaf level, this entry will map up to
  SWAPPER_BLOCK_SIZE bytes of physical addresses that we did not intend
  to map.

As we may map up to SWAPPER_BLOCK_SIZE bytes more than intended, we may
violate the boot protocol and map physical address past the 2MiB-aligned
end address we are permitted to map. As we map these with Normal memory
attributes, this may result in further problems depending on what these
physical addresses correspond to.

The final entry at each level may require an additional table at that
level. As EARLY_ENTRIES() calculates an inclusive bound, we allocate
enough memory for this.

Avoid the extraneous mapping by having map_memory convert the exclusive
end address to an inclusive end address by subtracting one, and do
likewise in EARLY_ENTRIES() when calculating the number of required
tables. For clarity, comments are updated to more clearly document which
boundaries the macros operate on.  For consistency with the other
macros, the comments in map_memory are also updated to describe `vstart`
and `vend` as virtual addresses.

Fixes: 0370b31e4845 ("arm64: Extend early page table code to allow for larger kernels")
Cc: <stable@vger.kernel.org> # 4.16.x
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Steve Capper <steve.capper@arm.com>
Cc: Will Deacon <will@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20210823101253.55567-1-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kernel-pgtable.h |    4 ++--
 arch/arm64/kernel/head.S                |   11 ++++++-----
 2 files changed, 8 insertions(+), 7 deletions(-)

--- a/arch/arm64/include/asm/kernel-pgtable.h
+++ b/arch/arm64/include/asm/kernel-pgtable.h
@@ -65,8 +65,8 @@
 #define EARLY_KASLR	(0)
 #endif
 
-#define EARLY_ENTRIES(vstart, vend, shift) (((vend) >> (shift)) \
-					- ((vstart) >> (shift)) + 1 + EARLY_KASLR)
+#define EARLY_ENTRIES(vstart, vend, shift) \
+	((((vend) - 1) >> (shift)) - ((vstart) >> (shift)) + 1 + EARLY_KASLR)
 
 #define EARLY_PGDS(vstart, vend) (EARLY_ENTRIES(vstart, vend, PGDIR_SHIFT))
 
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -177,7 +177,7 @@ SYM_CODE_END(preserve_boot_args)
  * to be composed of multiple pages. (This effectively scales the end index).
  *
  *	vstart:	virtual address of start of range
- *	vend:	virtual address of end of range
+ *	vend:	virtual address of end of range - we map [vstart, vend]
  *	shift:	shift used to transform virtual address into index
  *	ptrs:	number of entries in page table
  *	istart:	index in table corresponding to vstart
@@ -214,17 +214,18 @@ SYM_CODE_END(preserve_boot_args)
  *
  *	tbl:	location of page table
  *	rtbl:	address to be used for first level page table entry (typically tbl + PAGE_SIZE)
- *	vstart:	start address to map
- *	vend:	end address to map - we map [vstart, vend]
+ *	vstart:	virtual address of start of range
+ *	vend:	virtual address of end of range - we map [vstart, vend - 1]
  *	flags:	flags to use to map last level entries
  *	phys:	physical address corresponding to vstart - physical memory is contiguous
  *	pgds:	the number of pgd entries
  *
  * Temporaries:	istart, iend, tmp, count, sv - these need to be different registers
- * Preserves:	vstart, vend, flags
- * Corrupts:	tbl, rtbl, istart, iend, tmp, count, sv
+ * Preserves:	vstart, flags
+ * Corrupts:	tbl, rtbl, vend, istart, iend, tmp, count, sv
  */
 	.macro map_memory, tbl, rtbl, vstart, vend, flags, phys, pgds, istart, iend, tmp, count, sv
+	sub \vend, \vend, #1
 	add \rtbl, \tbl, #PAGE_SIZE
 	mov \sv, \rtbl
 	mov \count, #0


