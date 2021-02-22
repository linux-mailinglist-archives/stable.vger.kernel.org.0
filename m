Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADD7321732
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhBVMoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:44:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:53432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231374AbhBVMmM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:42:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A06D64F26;
        Mon, 22 Feb 2021 12:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997572;
        bh=UJpuyH9VDtyGKbKla09NNeb4DvUagLcl7ZynoO+Dckg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wi1H/s2YHoDXgpvX+rfqKOVCBQC/2aQt6E04wnz44OTolgIZikLD0z0u4o3CCmt+p
         J4m/CwaQA6dfPhVRFm8BO2QTs2YpjdDhkiPHIXmD83/M36THlhyHsxvQ0sVU+x675q
         ngIK5qjNxt9vRlFpVq6udCghbSYGlxOn/7vDZfq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Gushchin <guro@fb.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Hocko <mhocko@kernel.org>,
        Rik van Riel <riel@surriel.com>,
        Wonhyuk Yang <vvghjk1234@gmail.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 14/35] memblock: do not start bottom-up allocations with kernel_end
Date:   Mon, 22 Feb 2021 13:36:10 +0100
Message-Id: <20210222121019.452837496@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121013.581198717@linuxfoundation.org>
References: <20210222121013.581198717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Gushchin <guro@fb.com>

[ Upstream commit 2dcb3964544177c51853a210b6ad400de78ef17d ]

With kaslr the kernel image is placed at a random place, so starting the
bottom-up allocation with the kernel_end can result in an allocation
failure and a warning like this one:

  hugetlb_cma: reserve 2048 MiB, up to 2048 MiB per node
  ------------[ cut here ]------------
  memblock: bottom-up allocation failed, memory hotremove may be affected
  WARNING: CPU: 0 PID: 0 at mm/memblock.c:332 memblock_find_in_range_node+0x178/0x25a
  Modules linked in:
  CPU: 0 PID: 0 Comm: swapper Not tainted 5.10.0+ #1169
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1.fc33 04/01/2014
  RIP: 0010:memblock_find_in_range_node+0x178/0x25a
  Code: e9 6d ff ff ff 48 85 c0 0f 85 da 00 00 00 80 3d 9b 35 df 00 00 75 15 48 c7 c7 c0 75 59 88 c6 05 8b 35 df 00 01 e8 25 8a fa ff <0f> 0b 48 c7 44 24 20 ff ff ff ff 44 89 e6 44 89 ea 48 c7 c1 70 5c
  RSP: 0000:ffffffff88803d18 EFLAGS: 00010086 ORIG_RAX: 0000000000000000
  RAX: 0000000000000000 RBX: 0000000240000000 RCX: 00000000ffffdfff
  RDX: 00000000ffffdfff RSI: 00000000ffffffea RDI: 0000000000000046
  RBP: 0000000100000000 R08: ffffffff88922788 R09: 0000000000009ffb
  R10: 00000000ffffe000 R11: 3fffffffffffffff R12: 0000000000000000
  R13: 0000000000000000 R14: 0000000080000000 R15: 00000001fb42c000
  FS:  0000000000000000(0000) GS:ffffffff88f71000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffffa080fb401000 CR3: 00000001fa80a000 CR4: 00000000000406b0
  Call Trace:
    memblock_alloc_range_nid+0x8d/0x11e
    cma_declare_contiguous_nid+0x2c4/0x38c
    hugetlb_cma_reserve+0xdc/0x128
    flush_tlb_one_kernel+0xc/0x20
    native_set_fixmap+0x82/0xd0
    flat_get_apic_id+0x5/0x10
    register_lapic_address+0x8e/0x97
    setup_arch+0x8a5/0xc3f
    start_kernel+0x66/0x547
    load_ucode_bsp+0x4c/0xcd
    secondary_startup_64_no_verify+0xb0/0xbb
  random: get_random_bytes called from __warn+0xab/0x110 with crng_init=0
  ---[ end trace f151227d0b39be70 ]---

At the same time, the kernel image is protected with memblock_reserve(),
so we can just start searching at PAGE_SIZE.  In this case the bottom-up
allocation has the same chances to success as a top-down allocation, so
there is no reason to fallback in the case of a failure.  All together it
simplifies the logic.

Link: https://lkml.kernel.org/r/20201217201214.3414100-2-guro@fb.com
Fixes: 8fabc623238e ("powerpc: Ensure that swiotlb buffer is allocated from low memory")
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Wonhyuk Yang <vvghjk1234@gmail.com>
Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memblock.c | 49 ++++++-------------------------------------------
 1 file changed, 6 insertions(+), 43 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index f8fab45bfdb75..ff51a37eb86be 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -189,14 +189,6 @@ __memblock_find_range_top_down(phys_addr_t start, phys_addr_t end,
  *
  * Find @size free area aligned to @align in the specified range and node.
  *
- * When allocation direction is bottom-up, the @start should be greater
- * than the end of the kernel image. Otherwise, it will be trimmed. The
- * reason is that we want the bottom-up allocation just near the kernel
- * image so it is highly likely that the allocated memory and the kernel
- * will reside in the same node.
- *
- * If bottom-up allocation failed, will try to allocate memory top-down.
- *
  * RETURNS:
  * Found address on success, 0 on failure.
  */
@@ -204,8 +196,6 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t size,
 					phys_addr_t align, phys_addr_t start,
 					phys_addr_t end, int nid, ulong flags)
 {
-	phys_addr_t kernel_end, ret;
-
 	/* pump up @end */
 	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
 		end = memblock.current_limit;
@@ -213,40 +203,13 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t size,
 	/* avoid allocating the first page */
 	start = max_t(phys_addr_t, start, PAGE_SIZE);
 	end = max(start, end);
-	kernel_end = __pa_symbol(_end);
-
-	/*
-	 * try bottom-up allocation only when bottom-up mode
-	 * is set and @end is above the kernel image.
-	 */
-	if (memblock_bottom_up() && end > kernel_end) {
-		phys_addr_t bottom_up_start;
-
-		/* make sure we will allocate above the kernel */
-		bottom_up_start = max(start, kernel_end);
 
-		/* ok, try bottom-up allocation first */
-		ret = __memblock_find_range_bottom_up(bottom_up_start, end,
-						      size, align, nid, flags);
-		if (ret)
-			return ret;
-
-		/*
-		 * we always limit bottom-up allocation above the kernel,
-		 * but top-down allocation doesn't have the limit, so
-		 * retrying top-down allocation may succeed when bottom-up
-		 * allocation failed.
-		 *
-		 * bottom-up allocation is expected to be fail very rarely,
-		 * so we use WARN_ONCE() here to see the stack trace if
-		 * fail happens.
-		 */
-		WARN_ONCE(1, "memblock: bottom-up allocation failed, "
-			     "memory hotunplug may be affected\n");
-	}
-
-	return __memblock_find_range_top_down(start, end, size, align, nid,
-					      flags);
+	if (memblock_bottom_up())
+		return __memblock_find_range_bottom_up(start, end, size, align,
+						       nid, flags);
+	else
+		return __memblock_find_range_top_down(start, end, size, align,
+						      nid, flags);
 }
 
 /**
-- 
2.27.0



