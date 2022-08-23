Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B0359E0EB
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355762AbiHWKsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354826AbiHWKpU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:45:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6F727CD3;
        Tue, 23 Aug 2022 02:10:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07AB060DB4;
        Tue, 23 Aug 2022 09:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E003C433D6;
        Tue, 23 Aug 2022 09:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245858;
        bh=DbugGScHIkvIP6Pd4hT6Ur37vKutWJFJ6tLVmCrkrCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UTd+VMp21Tf9tsI7FW9OGqi93UkB6qfIQ0cr9X3+IdmO9P8ugc0DyQXCNnyx4YYUb
         Vd9Gue25bE3T8pkaSBtYkVf0pRJafjdin6azq8c/p4V+Xo3e6rkI7KXPP6mF7joa3Y
         EjZNsOTuwp0e5dszlypwz4YZyrmXYKXtcRnEGNtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.19 213/287] powerpc/mm: Split dump_pagelinuxtables flag_array table
Date:   Tue, 23 Aug 2022 10:26:22 +0200
Message-Id: <20220823080108.114894774@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 97026b5a5ac26541b3d294146f5c941491a9e609 upstream.

To reduce the complexity of flag_array, and allow the removal of
default 0 value of non existing flags, lets have one flag_array
table for each platform family with only the really existing flags.

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/mm/Makefile                        |    7 +
 arch/powerpc/mm/dump_linuxpagetables-8xx.c      |   82 ++++++++++++
 arch/powerpc/mm/dump_linuxpagetables-book3s64.c |  115 +++++++++++++++++
 arch/powerpc/mm/dump_linuxpagetables-generic.c  |   82 ++++++++++++
 arch/powerpc/mm/dump_linuxpagetables.c          |  155 ------------------------
 arch/powerpc/mm/dump_linuxpagetables.h          |   19 ++
 6 files changed, 307 insertions(+), 153 deletions(-)
 create mode 100644 arch/powerpc/mm/dump_linuxpagetables-8xx.c
 create mode 100644 arch/powerpc/mm/dump_linuxpagetables-book3s64.c
 create mode 100644 arch/powerpc/mm/dump_linuxpagetables-generic.c
 create mode 100644 arch/powerpc/mm/dump_linuxpagetables.h

--- a/arch/powerpc/mm/Makefile
+++ b/arch/powerpc/mm/Makefile
@@ -43,5 +43,12 @@ obj-$(CONFIG_HIGHMEM)		+= highmem.o
 obj-$(CONFIG_PPC_COPRO_BASE)	+= copro_fault.o
 obj-$(CONFIG_SPAPR_TCE_IOMMU)	+= mmu_context_iommu.o
 obj-$(CONFIG_PPC_PTDUMP)	+= dump_linuxpagetables.o
+ifdef CONFIG_PPC_PTDUMP
+obj-$(CONFIG_4xx)		+= dump_linuxpagetables-generic.o
+obj-$(CONFIG_PPC_8xx)		+= dump_linuxpagetables-8xx.o
+obj-$(CONFIG_PPC_BOOK3E_MMU)	+= dump_linuxpagetables-generic.o
+obj-$(CONFIG_PPC_BOOK3S_32)	+= dump_linuxpagetables-generic.o
+obj-$(CONFIG_PPC_BOOK3S_64)	+= dump_linuxpagetables-book3s64.o
+endif
 obj-$(CONFIG_PPC_HTDUMP)	+= dump_hashpagetable.o
 obj-$(CONFIG_PPC_MEM_KEYS)	+= pkeys.o
--- /dev/null
+++ b/arch/powerpc/mm/dump_linuxpagetables-8xx.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * From split of dump_linuxpagetables.c
+ * Copyright 2016, Rashmica Gupta, IBM Corp.
+ *
+ */
+#include <linux/kernel.h>
+#include <asm/pgtable.h>
+
+#include "dump_linuxpagetables.h"
+
+static const struct flag_info flag_array[] = {
+	{
+		.mask	= _PAGE_PRIVILEGED,
+		.val	= 0,
+		.set	= "user",
+		.clear	= "    ",
+	}, {
+		.mask	= _PAGE_RO | _PAGE_NA,
+		.val	= 0,
+		.set	= "rw",
+	}, {
+		.mask	= _PAGE_RO | _PAGE_NA,
+		.val	= _PAGE_RO,
+		.set	= "r ",
+	}, {
+		.mask	= _PAGE_RO | _PAGE_NA,
+		.val	= _PAGE_NA,
+		.set	= "  ",
+	}, {
+		.mask	= _PAGE_EXEC,
+		.val	= _PAGE_EXEC,
+		.set	= " X ",
+		.clear	= "   ",
+	}, {
+		.mask	= _PAGE_PRESENT,
+		.val	= _PAGE_PRESENT,
+		.set	= "present",
+		.clear	= "       ",
+	}, {
+		.mask	= _PAGE_GUARDED,
+		.val	= _PAGE_GUARDED,
+		.set	= "guarded",
+		.clear	= "       ",
+	}, {
+		.mask	= _PAGE_DIRTY,
+		.val	= _PAGE_DIRTY,
+		.set	= "dirty",
+		.clear	= "     ",
+	}, {
+		.mask	= _PAGE_ACCESSED,
+		.val	= _PAGE_ACCESSED,
+		.set	= "accessed",
+		.clear	= "        ",
+	}, {
+		.mask	= _PAGE_NO_CACHE,
+		.val	= _PAGE_NO_CACHE,
+		.set	= "no cache",
+		.clear	= "        ",
+	}, {
+		.mask	= _PAGE_SPECIAL,
+		.val	= _PAGE_SPECIAL,
+		.set	= "special",
+	}
+};
+
+struct pgtable_level pg_level[5] = {
+	{
+	}, { /* pgd */
+		.flag	= flag_array,
+		.num	= ARRAY_SIZE(flag_array),
+	}, { /* pud */
+		.flag	= flag_array,
+		.num	= ARRAY_SIZE(flag_array),
+	}, { /* pmd */
+		.flag	= flag_array,
+		.num	= ARRAY_SIZE(flag_array),
+	}, { /* pte */
+		.flag	= flag_array,
+		.num	= ARRAY_SIZE(flag_array),
+	},
+};
--- /dev/null
+++ b/arch/powerpc/mm/dump_linuxpagetables-book3s64.c
@@ -0,0 +1,115 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * From split of dump_linuxpagetables.c
+ * Copyright 2016, Rashmica Gupta, IBM Corp.
+ *
+ */
+#include <linux/kernel.h>
+#include <asm/pgtable.h>
+
+#include "dump_linuxpagetables.h"
+
+static const struct flag_info flag_array[] = {
+	{
+		.mask	= _PAGE_PRIVILEGED,
+		.val	= 0,
+		.set	= "user",
+		.clear	= "    ",
+	}, {
+		.mask	= _PAGE_READ,
+		.val	= _PAGE_READ,
+		.set	= "r",
+		.clear	= " ",
+	}, {
+		.mask	= _PAGE_WRITE,
+		.val	= _PAGE_WRITE,
+		.set	= "w",
+		.clear	= " ",
+	}, {
+		.mask	= _PAGE_EXEC,
+		.val	= _PAGE_EXEC,
+		.set	= " X ",
+		.clear	= "   ",
+	}, {
+		.mask	= _PAGE_PTE,
+		.val	= _PAGE_PTE,
+		.set	= "pte",
+		.clear	= "   ",
+	}, {
+		.mask	= _PAGE_PRESENT,
+		.val	= _PAGE_PRESENT,
+		.set	= "present",
+		.clear	= "       ",
+	}, {
+		.mask	= H_PAGE_HASHPTE,
+		.val	= H_PAGE_HASHPTE,
+		.set	= "hpte",
+		.clear	= "    ",
+	}, {
+		.mask	= _PAGE_DIRTY,
+		.val	= _PAGE_DIRTY,
+		.set	= "dirty",
+		.clear	= "     ",
+	}, {
+		.mask	= _PAGE_ACCESSED,
+		.val	= _PAGE_ACCESSED,
+		.set	= "accessed",
+		.clear	= "        ",
+	}, {
+		.mask	= _PAGE_NON_IDEMPOTENT,
+		.val	= _PAGE_NON_IDEMPOTENT,
+		.set	= "non-idempotent",
+		.clear	= "              ",
+	}, {
+		.mask	= _PAGE_TOLERANT,
+		.val	= _PAGE_TOLERANT,
+		.set	= "tolerant",
+		.clear	= "        ",
+	}, {
+		.mask	= H_PAGE_BUSY,
+		.val	= H_PAGE_BUSY,
+		.set	= "busy",
+	}, {
+#ifdef CONFIG_PPC_64K_PAGES
+		.mask	= H_PAGE_COMBO,
+		.val	= H_PAGE_COMBO,
+		.set	= "combo",
+	}, {
+		.mask	= H_PAGE_4K_PFN,
+		.val	= H_PAGE_4K_PFN,
+		.set	= "4K_pfn",
+	}, {
+#else /* CONFIG_PPC_64K_PAGES */
+		.mask	= H_PAGE_F_GIX,
+		.val	= H_PAGE_F_GIX,
+		.set	= "f_gix",
+		.is_val	= true,
+		.shift	= H_PAGE_F_GIX_SHIFT,
+	}, {
+		.mask	= H_PAGE_F_SECOND,
+		.val	= H_PAGE_F_SECOND,
+		.set	= "f_second",
+	}, {
+#endif /* CONFIG_PPC_64K_PAGES */
+		.mask	= _PAGE_SPECIAL,
+		.val	= _PAGE_SPECIAL,
+		.set	= "special",
+	}
+};
+
+struct pgtable_level pg_level[5] = {
+	{
+	}, { /* pgd */
+		.flag	= flag_array,
+		.num	= ARRAY_SIZE(flag_array),
+	}, { /* pud */
+		.flag	= flag_array,
+		.num	= ARRAY_SIZE(flag_array),
+	}, { /* pmd */
+		.flag	= flag_array,
+		.num	= ARRAY_SIZE(flag_array),
+	}, { /* pte */
+		.flag	= flag_array,
+		.num	= ARRAY_SIZE(flag_array),
+	},
+};
--- /dev/null
+++ b/arch/powerpc/mm/dump_linuxpagetables-generic.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * From split of dump_linuxpagetables.c
+ * Copyright 2016, Rashmica Gupta, IBM Corp.
+ *
+ */
+#include <linux/kernel.h>
+#include <asm/pgtable.h>
+
+#include "dump_linuxpagetables.h"
+
+static const struct flag_info flag_array[] = {
+	{
+		.mask	= _PAGE_USER,
+		.val	= _PAGE_USER,
+		.set	= "user",
+		.clear	= "    ",
+	}, {
+		.mask	= _PAGE_RW,
+		.val	= _PAGE_RW,
+		.set	= "rw",
+		.clear	= "r ",
+	}, {
+#ifndef CONFIG_PPC_BOOK3S_32
+		.mask	= _PAGE_EXEC,
+		.val	= _PAGE_EXEC,
+		.set	= " X ",
+		.clear	= "   ",
+	}, {
+#endif
+		.mask	= _PAGE_PRESENT,
+		.val	= _PAGE_PRESENT,
+		.set	= "present",
+		.clear	= "       ",
+	}, {
+		.mask	= _PAGE_GUARDED,
+		.val	= _PAGE_GUARDED,
+		.set	= "guarded",
+		.clear	= "       ",
+	}, {
+		.mask	= _PAGE_DIRTY,
+		.val	= _PAGE_DIRTY,
+		.set	= "dirty",
+		.clear	= "     ",
+	}, {
+		.mask	= _PAGE_ACCESSED,
+		.val	= _PAGE_ACCESSED,
+		.set	= "accessed",
+		.clear	= "        ",
+	}, {
+		.mask	= _PAGE_WRITETHRU,
+		.val	= _PAGE_WRITETHRU,
+		.set	= "write through",
+		.clear	= "             ",
+	}, {
+		.mask	= _PAGE_NO_CACHE,
+		.val	= _PAGE_NO_CACHE,
+		.set	= "no cache",
+		.clear	= "        ",
+	}, {
+		.mask	= _PAGE_SPECIAL,
+		.val	= _PAGE_SPECIAL,
+		.set	= "special",
+	}
+};
+
+struct pgtable_level pg_level[5] = {
+	{
+	}, { /* pgd */
+		.flag	= flag_array,
+		.num	= ARRAY_SIZE(flag_array),
+	}, { /* pud */
+		.flag	= flag_array,
+		.num	= ARRAY_SIZE(flag_array),
+	}, { /* pmd */
+		.flag	= flag_array,
+		.num	= ARRAY_SIZE(flag_array),
+	}, { /* pte */
+		.flag	= flag_array,
+		.num	= ARRAY_SIZE(flag_array),
+	},
+};
--- a/arch/powerpc/mm/dump_linuxpagetables.c
+++ b/arch/powerpc/mm/dump_linuxpagetables.c
@@ -28,6 +28,8 @@
 #include <asm/page.h>
 #include <asm/pgalloc.h>
 
+#include "dump_linuxpagetables.h"
+
 #ifdef CONFIG_PPC32
 #define KERN_VIRT_START	0
 #endif
@@ -102,159 +104,6 @@ static struct addr_marker address_marker
 	{ -1,	NULL },
 };
 
-struct flag_info {
-	u64		mask;
-	u64		val;
-	const char	*set;
-	const char	*clear;
-	bool		is_val;
-	int		shift;
-};
-
-static const struct flag_info flag_array[] = {
-	{
-		.mask	= _PAGE_USER | _PAGE_PRIVILEGED,
-		.val	= _PAGE_USER,
-		.set	= "user",
-		.clear	= "    ",
-	}, {
-		.mask	= _PAGE_RW | _PAGE_RO | _PAGE_NA,
-		.val	= _PAGE_RW,
-		.set	= "rw",
-	}, {
-		.mask	= _PAGE_RW | _PAGE_RO | _PAGE_NA,
-		.val	= _PAGE_RO,
-		.set	= "ro",
-	}, {
-#if _PAGE_NA != 0
-		.mask	= _PAGE_RW | _PAGE_RO | _PAGE_NA,
-		.val	= _PAGE_RO,
-		.set	= "na",
-	}, {
-#endif
-		.mask	= _PAGE_EXEC,
-		.val	= _PAGE_EXEC,
-		.set	= " X ",
-		.clear	= "   ",
-	}, {
-		.mask	= _PAGE_PTE,
-		.val	= _PAGE_PTE,
-		.set	= "pte",
-		.clear	= "   ",
-	}, {
-		.mask	= _PAGE_PRESENT,
-		.val	= _PAGE_PRESENT,
-		.set	= "present",
-		.clear	= "       ",
-	}, {
-#ifdef CONFIG_PPC_BOOK3S_64
-		.mask	= H_PAGE_HASHPTE,
-		.val	= H_PAGE_HASHPTE,
-#else
-		.mask	= _PAGE_HASHPTE,
-		.val	= _PAGE_HASHPTE,
-#endif
-		.set	= "hpte",
-		.clear	= "    ",
-	}, {
-#ifndef CONFIG_PPC_BOOK3S_64
-		.mask	= _PAGE_GUARDED,
-		.val	= _PAGE_GUARDED,
-		.set	= "guarded",
-		.clear	= "       ",
-	}, {
-#endif
-		.mask	= _PAGE_DIRTY,
-		.val	= _PAGE_DIRTY,
-		.set	= "dirty",
-		.clear	= "     ",
-	}, {
-		.mask	= _PAGE_ACCESSED,
-		.val	= _PAGE_ACCESSED,
-		.set	= "accessed",
-		.clear	= "        ",
-	}, {
-#ifndef CONFIG_PPC_BOOK3S_64
-		.mask	= _PAGE_WRITETHRU,
-		.val	= _PAGE_WRITETHRU,
-		.set	= "write through",
-		.clear	= "             ",
-	}, {
-#endif
-#ifndef CONFIG_PPC_BOOK3S_64
-		.mask	= _PAGE_NO_CACHE,
-		.val	= _PAGE_NO_CACHE,
-		.set	= "no cache",
-		.clear	= "        ",
-	}, {
-#else
-		.mask	= _PAGE_NON_IDEMPOTENT,
-		.val	= _PAGE_NON_IDEMPOTENT,
-		.set	= "non-idempotent",
-		.clear	= "              ",
-	}, {
-		.mask	= _PAGE_TOLERANT,
-		.val	= _PAGE_TOLERANT,
-		.set	= "tolerant",
-		.clear	= "        ",
-	}, {
-#endif
-#ifdef CONFIG_PPC_BOOK3S_64
-		.mask	= H_PAGE_BUSY,
-		.val	= H_PAGE_BUSY,
-		.set	= "busy",
-	}, {
-#ifdef CONFIG_PPC_64K_PAGES
-		.mask	= H_PAGE_COMBO,
-		.val	= H_PAGE_COMBO,
-		.set	= "combo",
-	}, {
-		.mask	= H_PAGE_4K_PFN,
-		.val	= H_PAGE_4K_PFN,
-		.set	= "4K_pfn",
-	}, {
-#else /* CONFIG_PPC_64K_PAGES */
-		.mask	= H_PAGE_F_GIX,
-		.val	= H_PAGE_F_GIX,
-		.set	= "f_gix",
-		.is_val	= true,
-		.shift	= H_PAGE_F_GIX_SHIFT,
-	}, {
-		.mask	= H_PAGE_F_SECOND,
-		.val	= H_PAGE_F_SECOND,
-		.set	= "f_second",
-	}, {
-#endif /* CONFIG_PPC_64K_PAGES */
-#endif
-		.mask	= _PAGE_SPECIAL,
-		.val	= _PAGE_SPECIAL,
-		.set	= "special",
-	}
-};
-
-struct pgtable_level {
-	const struct flag_info *flag;
-	size_t num;
-	u64 mask;
-};
-
-static struct pgtable_level pg_level[] = {
-	{
-	}, { /* pgd */
-		.flag	= flag_array,
-		.num	= ARRAY_SIZE(flag_array),
-	}, { /* pud */
-		.flag	= flag_array,
-		.num	= ARRAY_SIZE(flag_array),
-	}, { /* pmd */
-		.flag	= flag_array,
-		.num	= ARRAY_SIZE(flag_array),
-	}, { /* pte */
-		.flag	= flag_array,
-		.num	= ARRAY_SIZE(flag_array),
-	},
-};
-
 static void dump_flag_info(struct pg_state *st, const struct flag_info
 		*flag, u64 pte, int num)
 {
--- /dev/null
+++ b/arch/powerpc/mm/dump_linuxpagetables.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/types.h>
+
+struct flag_info {
+	u64		mask;
+	u64		val;
+	const char	*set;
+	const char	*clear;
+	bool		is_val;
+	int		shift;
+};
+
+struct pgtable_level {
+	const struct flag_info *flag;
+	size_t num;
+	u64 mask;
+};
+
+extern struct pgtable_level pg_level[5];


