Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84553033B0
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729981AbhAZFDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:03:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730906AbhAYSwd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:52:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D22C2063A;
        Mon, 25 Jan 2021 18:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600711;
        bh=1yUwA90lzmW+4t40YjFZ/GcNuPnmM+e7HuCFl6f8ZkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ufQ46OFpzeOYvqBED82WYURMlEXO0U7/NYh6qLmT+F6BRA8eoayHcvGlPJVkTz0FV
         0SfojRo4JfJec/1/OSSHy+7m06AaTa/7VKpkW5zNB5SmsvJWx8hbOw6L3qzPrahJDa
         bo6k6iY7DxvDQNjRlj1Su3Remgrdor+Q6wGVmv7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        David Hildenbrand <david@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Qian Cai <cai@lca.pw>, Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 120/199] x86/setup: dont remove E820_TYPE_RAM for pfn 0
Date:   Mon, 25 Jan 2021 19:39:02 +0100
Message-Id: <20210125183221.294324295@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

commit bde9cfa3afe4324ec251e4af80ebf9b7afaf7afe upstream.

Patch series "mm: fix initialization of struct page for holes in  memory layout", v3.

Commit 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions
rather that check each PFN") exposed several issues with the memory map
initialization and these patches fix those issues.

Initially there were crashes during compaction that Qian Cai reported
back in April [1].  It seemed back then that the problem was fixed, but
a few weeks ago Andrea Arcangeli hit the same bug [2] and there was an
additional discussion at [3].

[1] https://lore.kernel.org/lkml/8C537EB7-85EE-4DCF-943E-3CC0ED0DF56D@lca.pw
[2] https://lore.kernel.org/lkml/20201121194506.13464-1-aarcange@redhat.com
[3] https://lore.kernel.org/mm-commits/20201206005401.qKuAVgOXr%akpm@linux-foundation.org

This patch (of 2):

The first 4Kb of memory is a BIOS owned area and to avoid its allocation
for the kernel it was not listed in e820 tables as memory.  As the result,
pfn 0 was never recognised by the generic memory management and it is not
a part of neither node 0 nor ZONE_DMA.

If set_pfnblock_flags_mask() would be ever called for the pageblock
corresponding to the first 2Mbytes of memory, having pfn 0 outside of
ZONE_DMA would trigger

	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);

Along with reserving the first 4Kb in e820 tables, several first pages are
reserved with memblock in several places during setup_arch().  These
reservations are enough to ensure the kernel does not touch the BIOS area
and it is not necessary to remove E820_TYPE_RAM for pfn 0.

Remove the update of e820 table that changes the type of pfn 0 and move
the comment describing why it was done to trim_low_memory_range() that
reserves the beginning of the memory.

Link: https://lkml.kernel.org/r/20210111194017.22696-2-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qian Cai <cai@lca.pw>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/setup.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -666,17 +666,6 @@ static void __init trim_platform_memory_
 static void __init trim_bios_range(void)
 {
 	/*
-	 * A special case is the first 4Kb of memory;
-	 * This is a BIOS owned area, not kernel ram, but generally
-	 * not listed as such in the E820 table.
-	 *
-	 * This typically reserves additional memory (64KiB by default)
-	 * since some BIOSes are known to corrupt low memory.  See the
-	 * Kconfig help text for X86_RESERVE_LOW.
-	 */
-	e820__range_update(0, PAGE_SIZE, E820_TYPE_RAM, E820_TYPE_RESERVED);
-
-	/*
 	 * special case: Some BIOSes report the PC BIOS
 	 * area (640Kb -> 1Mb) as RAM even though it is not.
 	 * take them out.
@@ -733,6 +722,15 @@ early_param("reservelow", parse_reservel
 
 static void __init trim_low_memory_range(void)
 {
+	/*
+	 * A special case is the first 4Kb of memory;
+	 * This is a BIOS owned area, not kernel ram, but generally
+	 * not listed as such in the E820 table.
+	 *
+	 * This typically reserves additional memory (64KiB by default)
+	 * since some BIOSes are known to corrupt low memory.  See the
+	 * Kconfig help text for X86_RESERVE_LOW.
+	 */
 	memblock_reserve(0, ALIGN(reserve_low, PAGE_SIZE));
 }
 	


