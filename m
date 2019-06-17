Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4A434940A
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729716AbfFQVX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:23:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726723AbfFQVX1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:23:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6110520657;
        Mon, 17 Jun 2019 21:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806606;
        bh=WRt3hZwVhxYc1hGY5XlW7OH/gGDtHJG3c1BdxS3erHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BCfCbjb99QFjwZbrzkRV8NYwNyxFgal4g8ds133Dn3L26bRunwua0gt/XsEF+yTt5
         ADhno82q7/uosIgOg95LOSgu4ZEAn/rVGOxEzlgepfqyyhiOatKn+cHDkB38JuoDJ8
         iJ9tTIuZMF6I/TnMcSat1u4IJdfkpXEDgVmkB9hE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baoquan He <bhe@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Kees Cook <keescook@chromium.org>,
        "Kirill A. Shutemov" <kirill@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        kirill.shutemov@linux.intel.com,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>
Subject: [PATCH 5.1 110/115] x86/mm/KASLR: Compute the size of the vmemmap section properly
Date:   Mon, 17 Jun 2019 23:10:10 +0200
Message-Id: <20190617210805.524763038@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baoquan He <bhe@redhat.com>

commit 00e5a2bbcc31d5fea853f8daeba0f06c1c88c3ff upstream.

The size of the vmemmap section is hardcoded to 1 TB to support the
maximum amount of system RAM in 4-level paging mode - 64 TB.

However, 1 TB is not enough for vmemmap in 5-level paging mode. Assuming
the size of struct page is 64 Bytes, to support 4 PB system RAM in 5-level,
64 TB of vmemmap area is needed:

  4 * 1000^5 PB / 4096 bytes page size * 64 bytes per page struct / 1000^4 TB = 62.5 TB.

This hardcoding may cause vmemmap to corrupt the following
cpu_entry_area section, if KASLR puts vmemmap very close to it and the
actual vmemmap size is bigger than 1 TB.

So calculate the actual size of the vmemmap region needed and then align
it up to 1 TB boundary.

In 4-level paging mode it is always 1 TB. In 5-level it's adjusted on
demand. The current code reserves 0.5 PB for vmemmap on 5-level. With
this change, the space can be saved and thus used to increase entropy
for the randomization.

 [ bp: Spell out how the 64 TB needed for vmemmap is computed and massage commit
   message. ]

Fixes: eedb92abb9bb ("x86/mm: Make virtual memory layout dynamic for CONFIG_X86_5LEVEL=y")
Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Kirill A. Shutemov <kirill@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: kirill.shutemov@linux.intel.com
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable <stable@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20190523025744.3756-1-bhe@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/mm/kaslr.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -52,7 +52,7 @@ static __initdata struct kaslr_memory_re
 } kaslr_regions[] = {
 	{ &page_offset_base, 0 },
 	{ &vmalloc_base, 0 },
-	{ &vmemmap_base, 1 },
+	{ &vmemmap_base, 0 },
 };
 
 /* Get size in bytes used by the memory region */
@@ -78,6 +78,7 @@ void __init kernel_randomize_memory(void
 	unsigned long rand, memory_tb;
 	struct rnd_state rand_state;
 	unsigned long remain_entropy;
+	unsigned long vmemmap_size;
 
 	vaddr_start = pgtable_l5_enabled() ? __PAGE_OFFSET_BASE_L5 : __PAGE_OFFSET_BASE_L4;
 	vaddr = vaddr_start;
@@ -109,6 +110,14 @@ void __init kernel_randomize_memory(void
 	if (memory_tb < kaslr_regions[0].size_tb)
 		kaslr_regions[0].size_tb = memory_tb;
 
+	/*
+	 * Calculate the vmemmap region size in TBs, aligned to a TB
+	 * boundary.
+	 */
+	vmemmap_size = (kaslr_regions[0].size_tb << (TB_SHIFT - PAGE_SHIFT)) *
+			sizeof(struct page);
+	kaslr_regions[2].size_tb = DIV_ROUND_UP(vmemmap_size, 1UL << TB_SHIFT);
+
 	/* Calculate entropy available between regions */
 	remain_entropy = vaddr_end - vaddr_start;
 	for (i = 0; i < ARRAY_SIZE(kaslr_regions); i++)


