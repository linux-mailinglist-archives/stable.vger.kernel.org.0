Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D56110BB84
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387435AbfK0VNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:13:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:45498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731515AbfK0VNV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:13:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E61F32086A;
        Wed, 27 Nov 2019 21:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889200;
        bh=TcgEOZy2tdbZnFR7pwvTCI0uoNIrtmp6FAYmtxIsDF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gdn8ISF8o9OsmOu7aPTeDIY7j0Xj/e2JhB+O5gCd0Fyj52GVJ5YR2gQEjwCmWWzQm
         bDe3JmkSmQjfRF0K7//GiqDttCLXiq0EgkYm2ldAS0s2DGKD5cJ7as3yu+LLkgEC4t
         LIg9GMdWiPgO/Kw5/JEWbYX3eE+JN/TU5fNK8X0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>, stable@kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.4 26/66] x86/pti/32: Calculate the various PTI cpu_entry_area sizes correctly, make the CPU_ENTRY_AREA_PAGES assert precise
Date:   Wed, 27 Nov 2019 21:32:21 +0100
Message-Id: <20191127202659.227959442@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202632.536277063@linuxfoundation.org>
References: <20191127202632.536277063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

commit 05b042a1944322844eaae7ea596d5f154166d68a upstream.

When two recent commits that increased the size of the 'struct cpu_entry_area'
were merged in -tip, the 32-bit defconfig build started failing on the following
build time assert:

  ./include/linux/compiler.h:391:38: error: call to ‘__compiletime_assert_189’ declared with attribute error: BUILD_BUG_ON failed: CPU_ENTRY_AREA_PAGES * PAGE_SIZE < CPU_ENTRY_AREA_MAP_SIZE
  arch/x86/mm/cpu_entry_area.c:189:2: note: in expansion of macro ‘BUILD_BUG_ON’
  In function ‘setup_cpu_entry_area_ptes’,

Which corresponds to the following build time assert:

	BUILD_BUG_ON(CPU_ENTRY_AREA_PAGES * PAGE_SIZE < CPU_ENTRY_AREA_MAP_SIZE);

The purpose of this assert is to sanity check the fixed-value definition of
CPU_ENTRY_AREA_PAGES arch/x86/include/asm/pgtable_32_types.h:

	#define CPU_ENTRY_AREA_PAGES    (NR_CPUS * 41)

The '41' is supposed to match sizeof(struct cpu_entry_area)/PAGE_SIZE, which value
we didn't want to define in such a low level header, because it would cause
dependency hell.

Every time the size of cpu_entry_area is changed, we have to adjust CPU_ENTRY_AREA_PAGES
accordingly - and this assert is checking that constraint.

But the assert is both imprecise and buggy, primarily because it doesn't
include the single readonly IDT page that is mapped at CPU_ENTRY_AREA_BASE
(which begins at a PMD boundary).

This bug was hidden by the fact that by accident CPU_ENTRY_AREA_PAGES is defined
too large upstream (v5.4-rc8):

	#define CPU_ENTRY_AREA_PAGES    (NR_CPUS * 40)

While 'struct cpu_entry_area' is 155648 bytes, or 38 pages. So we had two extra
pages, which hid the bug.

The following commit (not yet upstream) increased the size to 40 pages:

  x86/iopl: ("Restrict iopl() permission scope")

... but increased CPU_ENTRY_AREA_PAGES only 41 - i.e. shortening the gap
to just 1 extra page.

Then another not-yet-upstream commit changed the size again:

  880a98c33996: ("x86/cpu_entry_area: Add guard page for entry stack on 32bit")

Which increased the cpu_entry_area size from 38 to 39 pages, but
didn't change CPU_ENTRY_AREA_PAGES (kept it at 40). This worked
fine, because we still had a page left from the accidental 'reserve'.

But when these two commits were merged into the same tree, the
combined size of cpu_entry_area grew from 38 to 40 pages, while
CPU_ENTRY_AREA_PAGES finally caught up to 40 as well.

Which is fine in terms of functionality, but the assert broke:

	BUILD_BUG_ON(CPU_ENTRY_AREA_PAGES * PAGE_SIZE < CPU_ENTRY_AREA_MAP_SIZE);

because CPU_ENTRY_AREA_MAP_SIZE is the total size of the area,
which is 1 page larger due to the IDT page.

To fix all this, change the assert to two precise asserts:

	BUILD_BUG_ON((CPU_ENTRY_AREA_PAGES+1)*PAGE_SIZE != CPU_ENTRY_AREA_MAP_SIZE);
	BUILD_BUG_ON(CPU_ENTRY_AREA_TOTAL_SIZE != CPU_ENTRY_AREA_MAP_SIZE);

This takes the IDT page into account, and also connects the size-based
define of CPU_ENTRY_AREA_TOTAL_SIZE with the address-subtraction based
define of CPU_ENTRY_AREA_MAP_SIZE.

Also clean up some of the names which made it rather confusing:

 - 'CPU_ENTRY_AREA_TOT_SIZE' wasn't actually the 'total' size of
   the cpu-entry-area, but the per-cpu array size, so rename this
   to CPU_ENTRY_AREA_ARRAY_SIZE.

 - Introduce CPU_ENTRY_AREA_TOTAL_SIZE that _is_ the total mapping
   size, with the IDT included.

 - Add comments where '+1' denotes the IDT mapping - it wasn't
   obvious and took me about 3 hours to decode...

Finally, because this particular commit is actually applied after
this patch:

  880a98c33996: ("x86/cpu_entry_area: Add guard page for entry stack on 32bit")

Fix the CPU_ENTRY_AREA_PAGES value from 40 pages to the correct 39 pages.

All future commits that change cpu_entry_area will have to adjust
this value precisely.

As a side note, we should probably attempt to remove CPU_ENTRY_AREA_PAGES
and derive its value directly from the structure, without causing
header hell - but that is an adventure for another day! :-)

Fixes: 880a98c33996: ("x86/cpu_entry_area: Add guard page for entry stack on 32bit")
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: stable@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/cpu_entry_area.h   |   12 +++++++-----
 arch/x86/include/asm/pgtable_32_types.h |    8 ++++----
 arch/x86/mm/cpu_entry_area.c            |    4 +++-
 3 files changed, 14 insertions(+), 10 deletions(-)

--- a/arch/x86/include/asm/cpu_entry_area.h
+++ b/arch/x86/include/asm/cpu_entry_area.h
@@ -98,7 +98,6 @@ struct cpu_entry_area {
 	 */
 	struct cea_exception_stacks estacks;
 #endif
-#ifdef CONFIG_CPU_SUP_INTEL
 	/*
 	 * Per CPU debug store for Intel performance monitoring. Wastes a
 	 * full page at the moment.
@@ -109,11 +108,13 @@ struct cpu_entry_area {
 	 * Reserve enough fixmap PTEs.
 	 */
 	struct debug_store_buffers cpu_debug_buffers;
-#endif
 };
 
-#define CPU_ENTRY_AREA_SIZE	(sizeof(struct cpu_entry_area))
-#define CPU_ENTRY_AREA_TOT_SIZE	(CPU_ENTRY_AREA_SIZE * NR_CPUS)
+#define CPU_ENTRY_AREA_SIZE		(sizeof(struct cpu_entry_area))
+#define CPU_ENTRY_AREA_ARRAY_SIZE	(CPU_ENTRY_AREA_SIZE * NR_CPUS)
+
+/* Total size includes the readonly IDT mapping page as well: */
+#define CPU_ENTRY_AREA_TOTAL_SIZE	(CPU_ENTRY_AREA_ARRAY_SIZE + PAGE_SIZE)
 
 DECLARE_PER_CPU(struct cpu_entry_area *, cpu_entry_area);
 DECLARE_PER_CPU(struct cea_exception_stacks *, cea_exception_stacks);
@@ -121,13 +122,14 @@ DECLARE_PER_CPU(struct cea_exception_sta
 extern void setup_cpu_entry_areas(void);
 extern void cea_set_pte(void *cea_vaddr, phys_addr_t pa, pgprot_t flags);
 
+/* Single page reserved for the readonly IDT mapping: */
 #define	CPU_ENTRY_AREA_RO_IDT		CPU_ENTRY_AREA_BASE
 #define CPU_ENTRY_AREA_PER_CPU		(CPU_ENTRY_AREA_RO_IDT + PAGE_SIZE)
 
 #define CPU_ENTRY_AREA_RO_IDT_VADDR	((void *)CPU_ENTRY_AREA_RO_IDT)
 
 #define CPU_ENTRY_AREA_MAP_SIZE			\
-	(CPU_ENTRY_AREA_PER_CPU + CPU_ENTRY_AREA_TOT_SIZE - CPU_ENTRY_AREA_BASE)
+	(CPU_ENTRY_AREA_PER_CPU + CPU_ENTRY_AREA_ARRAY_SIZE - CPU_ENTRY_AREA_BASE)
 
 extern struct cpu_entry_area *get_cpu_entry_area(int cpu);
 
--- a/arch/x86/include/asm/pgtable_32_types.h
+++ b/arch/x86/include/asm/pgtable_32_types.h
@@ -44,11 +44,11 @@ extern bool __vmalloc_start_set; /* set
  * Define this here and validate with BUILD_BUG_ON() in pgtable_32.c
  * to avoid include recursion hell
  */
-#define CPU_ENTRY_AREA_PAGES	(NR_CPUS * 40)
+#define CPU_ENTRY_AREA_PAGES	(NR_CPUS * 39)
 
-#define CPU_ENTRY_AREA_BASE						\
-	((FIXADDR_TOT_START - PAGE_SIZE * (CPU_ENTRY_AREA_PAGES + 1))   \
-	 & PMD_MASK)
+/* The +1 is for the readonly IDT page: */
+#define CPU_ENTRY_AREA_BASE	\
+	((FIXADDR_TOT_START - PAGE_SIZE*(CPU_ENTRY_AREA_PAGES+1)) & PMD_MASK)
 
 #define LDT_BASE_ADDR		\
 	((CPU_ENTRY_AREA_BASE - PAGE_SIZE) & PMD_MASK)
--- a/arch/x86/mm/cpu_entry_area.c
+++ b/arch/x86/mm/cpu_entry_area.c
@@ -178,7 +178,9 @@ static __init void setup_cpu_entry_area_
 #ifdef CONFIG_X86_32
 	unsigned long start, end;
 
-	BUILD_BUG_ON(CPU_ENTRY_AREA_PAGES * PAGE_SIZE < CPU_ENTRY_AREA_MAP_SIZE);
+	/* The +1 is for the readonly IDT: */
+	BUILD_BUG_ON((CPU_ENTRY_AREA_PAGES+1)*PAGE_SIZE != CPU_ENTRY_AREA_MAP_SIZE);
+	BUILD_BUG_ON(CPU_ENTRY_AREA_TOTAL_SIZE != CPU_ENTRY_AREA_MAP_SIZE);
 	BUG_ON(CPU_ENTRY_AREA_BASE & ~PMD_MASK);
 
 	start = CPU_ENTRY_AREA_BASE;


