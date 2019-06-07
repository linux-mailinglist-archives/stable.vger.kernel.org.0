Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABA939796
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 23:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730775AbfFGVRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 17:17:51 -0400
Received: from terminus.zytor.com ([198.137.202.136]:52349 "EHLO
        terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730700AbfFGVRv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 17:17:51 -0400
Received: from terminus.zytor.com (localhost [127.0.0.1])
        by terminus.zytor.com (8.15.2/8.15.2) with ESMTPS id x57LH0iB2663557
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Fri, 7 Jun 2019 14:17:00 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x57LH0iB2663557
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2019051801; t=1559942220;
        bh=pcspIWbcUasCbDigRJvUefjE0KNrFLcytvAjYwz6uk0=;
        h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
        b=NZOPM/kSi4JSgPYd26hf9iebwQ+ZKu+6edt7WZ4o4ITqi7j9KBdtAEcqyoUOANUwY
         XI/VwzdazqApSHUNcTfNxXSbb2hX36VvnV6bQsQvtteidGjrPKNGMTxNyMgNHs2hl7
         msoYtCOivEUO0TcRzm8CXLZ533nVpMnM5AhgGJNurFcSIGbLDc6YOzrOt9bnkRcuJ0
         i7/ZOMQKeHL+ZzaPT/b1Ydv0EaS5js975tAKB0jII0cF7QIdPsMyRIhAxFAKhYyzkY
         4n0j6AtiLp+oOsefrSpOrULLQ9KeGi6YF43silL96Bp955XfO1bZgYNJJiGzl5++xb
         SRRFK4stWPOxw==
Received: (from tipbot@localhost)
        by terminus.zytor.com (8.15.2/8.15.2/Submit) id x57LGxHn2663554;
        Fri, 7 Jun 2019 14:16:59 -0700
Date:   Fri, 7 Jun 2019 14:16:59 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
From:   tip-bot for Baoquan He <tipbot@zytor.com>
Message-ID: <tip-00e5a2bbcc31d5fea853f8daeba0f06c1c88c3ff@git.kernel.org>
Cc:     keescook@chromium.org, kirill@linux.intel.com,
        dave.hansen@linux.intel.com, bp@suse.de, luto@kernel.org,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, bhe@redhat.com,
        mingo@kernel.org, stable@vger.kernel.org
Reply-To: tglx@linutronix.de, stable@vger.kernel.org, mingo@kernel.org,
          bhe@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org,
          peterz@infradead.org, keescook@chromium.org, bp@suse.de,
          luto@kernel.org, hpa@zytor.com, kirill@linux.intel.com,
          dave.hansen@linux.intel.com
In-Reply-To: <20190523025744.3756-1-bhe@redhat.com>
References: <20190523025744.3756-1-bhe@redhat.com>
To:     linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mm/KASLR: Compute the size of the vmemmap
 section properly
Git-Commit-ID: 00e5a2bbcc31d5fea853f8daeba0f06c1c88c3ff
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from
 these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Spam-Status: No, score=-2.5 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DATE_IN_FUTURE_96_Q,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF
        autolearn=no autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on terminus.zytor.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit-ID:  00e5a2bbcc31d5fea853f8daeba0f06c1c88c3ff
Gitweb:     https://git.kernel.org/tip/00e5a2bbcc31d5fea853f8daeba0f06c1c88c3ff
Author:     Baoquan He <bhe@redhat.com>
AuthorDate: Thu, 23 May 2019 10:57:44 +0800
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Fri, 7 Jun 2019 23:12:13 +0200

x86/mm/KASLR: Compute the size of the vmemmap section properly

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
---
 arch/x86/mm/kaslr.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
index dc3f058bdf9b..dc6182eecefa 100644
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
