Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 074B9274A7
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 04:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbfEWC5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 22:57:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60514 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727305AbfEWC5y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 22:57:54 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5F6E559463;
        Thu, 23 May 2019 02:57:54 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (ovpn-12-100.pek2.redhat.com [10.72.12.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C1FB7DF688;
        Thu, 23 May 2019 02:57:50 +0000 (UTC)
From:   Baoquan He <bhe@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     x86@kernel.org, tglx@linutronix.de, mingo@kernel.org, bp@alien8.de,
        hpa@zytor.com, kirill.shutemov@linux.intel.com,
        keescook@chromium.org, Baoquan He <bhe@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH v5] x86/mm/KASLR: Fix the size of vmemmap section
Date:   Thu, 23 May 2019 10:57:44 +0800
Message-Id: <20190523025744.3756-1-bhe@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Thu, 23 May 2019 02:57:54 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

kernel_randomize_memory() hardcodes the size of vmemmap section as 1 TB,
to support the maximum amount of system RAM in 4-level paging mode, 64 TB.

However, 1 TB is not enough for vmemmap in 5-level paging mode. Assuming
the size of struct page is 64 Bytes, to support 4 PB system RAM in 5-level,
64 TB of vmemmap area is needed. The wrong hardcoding may cause vmemmap
stamping into the following cpu_entry_area section, if KASLR puts vmemmap
very close to cpu_entry_area , and the actual area of vmemmap is much
bigger than 1 TB.

So here calculate the actual size of vmemmap region, then align up to 1 TB
boundary. In 4-level it's always 1 TB. In 5-level it's adjusted on demand.
The current code reserves 0.5 PB for vmemmap in 5-level. In this new way,
the left space can be saved to join randomization to increase the entropy.

Fiexes: eedb92abb9bb ("x86/mm: Make virtual memory layout dynamic for CONFIG_X86_5LEVEL=y")
Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Kirill A. Shutemov <kirill@linux.intel.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
---
v4->v5:
  Add Fixes tag and Cc to stable.
v3->v4:
  Fix the incorrect style of code comment;
  Add ack tags from Kirill and Kees.
v3 discussion is here:
  http://lkml.kernel.org/r/20190422091045.GB3584@localhost.localdomain
 arch/x86/mm/kaslr.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
index dc3f058bdf9b..c0eedb85a92f 100644
--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -52,7 +52,7 @@ static __initdata struct kaslr_memory_region {
 } kaslr_regions[] = {
 	{ &page_offset_base, 0 },
 	{ &vmalloc_base, 0 },
-	{ &vmemmap_base, 1 },
+	{ &vmemmap_base, 0 },
 };
 
 /* Get size in bytes used by the memory region */
@@ -78,6 +78,7 @@ void __init kernel_randomize_memory(void)
 	unsigned long rand, memory_tb;
 	struct rnd_state rand_state;
 	unsigned long remain_entropy;
+	unsigned long vmemmap_size;
 
 	vaddr_start = pgtable_l5_enabled() ? __PAGE_OFFSET_BASE_L5 : __PAGE_OFFSET_BASE_L4;
 	vaddr = vaddr_start;
@@ -109,6 +110,14 @@ void __init kernel_randomize_memory(void)
 	if (memory_tb < kaslr_regions[0].size_tb)
 		kaslr_regions[0].size_tb = memory_tb;
 
+	/*
+	 * Calculate how many TB vmemmap region needs, and aligned to
+	 * 1TB boundary.
+	 */
+	vmemmap_size = (kaslr_regions[0].size_tb << (TB_SHIFT - PAGE_SHIFT)) *
+		sizeof(struct page);
+	kaslr_regions[2].size_tb = DIV_ROUND_UP(vmemmap_size, 1UL << TB_SHIFT);
+
 	/* Calculate entropy available between regions */
 	remain_entropy = vaddr_end - vaddr_start;
 	for (i = 0; i < ARRAY_SIZE(kaslr_regions); i++)
-- 
2.17.2

