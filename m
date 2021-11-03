Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24CA74449D4
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 21:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbhKCU7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 16:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbhKCU7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 16:59:49 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB2FC061714;
        Wed,  3 Nov 2021 13:57:13 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id r5so3642343pls.1;
        Wed, 03 Nov 2021 13:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BFDd8LYLL9iLsk41I8B0uvCN8xqAE1pF4tRiEAvVNwE=;
        b=mU/lV2PDVhzl2apO/sKJObAt5f2aQJwQjF56oeVDNAVFILPaAuxYJqhe1INkvwqK4F
         LngVqgj0bbkDnnMIpWpgkEg0e1gJ0LjAb+Wa0Zl4FB/D1ubP7uxUhSGpeFZ/UyV3OVDE
         iboE6h8OZq9FAYalgtPZyloyJkImXmUB4SWh+r+uP5/FsZ736QljFfuaw+xVrDymxAB4
         N/D/ZuCnmbUzIGKyGSVySnFm/d5mC3XHS9nuPl4FkifJtkOBXUSHWmxEgGxCyGGR9Dhx
         LaYP4R60y2USvsvPyIpAax1BhdGd55TQ7J+x2lsDtzWDTlNrIBhyOX1s8ltU2lNK8Vw1
         /8Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BFDd8LYLL9iLsk41I8B0uvCN8xqAE1pF4tRiEAvVNwE=;
        b=Ev1RYRn+UVMbBhdg8iuYFTI8dZwgkfj9u7iG3xwft3D8637H/HdcrWhwbe7R/rOhbg
         ZumA4TaChBe3odUbnTkx+Tfo9nD+Q9rvToIdgJ8WF6m7dO9+ejZ3qKzFtXXcw1PPs/Xz
         t+AWReTeCSOQ9k238P00E9rjooqsAMkgBpD3NCAutnOolXuM2tmgCyXBjmiEgEe7z1DV
         FoX4mdunraD6lrSs8x+RWEEx1b52eQmE70vz7lUvFBWvBNQbWU8WxEk4ayhg7AbKMh46
         HumYxSn0YULX2MphLKXN6rngsbnXGRyZeQvIfuduBpbMF4hKXlvLW23QY+9bigvKuje4
         MNwA==
X-Gm-Message-State: AOAM530E7cx4nb9JiKFq+A46IC9/no/s4tqIJGowWA3OTjUMKs2aV27l
        KnyxxXK3Rap6wbnlGHFHo6keiJuWAV4=
X-Google-Smtp-Source: ABdhPJztIqZLojbQkcG9MLb1IIhhdLW0+uR0uxDfAsAAHrYl0w4LRAN+yau1elpkYyy4Jk6iCHIbXw==
X-Received: by 2002:a17:903:1c3:b0:142:3ae:5c09 with SMTP id e3-20020a17090301c300b0014203ae5c09mr14720727plh.52.1635973032210;
        Wed, 03 Nov 2021 13:57:12 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b18sm2554859pjo.31.2021.11.03.13.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 13:57:11 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Minchan Kim <minchan@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Borislav Petkov <bp@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Russell King <linux@armlinux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Arnd Bergmann <arnd@arndb.de>, Stefan Agner <stefan@agner.ch>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Mike Rapoport <rppt@linux.ibm.com>,
        linux-snps-arc@lists.infradead.org (open list:SYNOPSYS ARC ARCHITECTURE),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        linux-mips@linux-mips.org (open list:MIPS),
        linuxppc-dev@lists.ozlabs.org (open list:LINUX FOR POWERPC (32-BIT AND
        64-BIT)),
        linux-arch@vger.kernel.org (open list:GENERIC INCLUDE/ASM HEADER FILES)
Subject: [PATCH stable 4.14 1/2] mm/zsmalloc: Prepare to variable MAX_PHYSMEM_BITS
Date:   Wed,  3 Nov 2021 13:57:03 -0700
Message-Id: <20211103205704.374734-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211103205704.374734-1-f.fainelli@gmail.com>
References: <20211103205704.374734-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

commit 02390b87a9459937cdb299e6b34ff33992512ec7 upstream

With boot-time switching between paging mode we will have variable
MAX_PHYSMEM_BITS.

Let's use the maximum variable possible for CONFIG_X86_5LEVEL=y
configuration to define zsmalloc data structures.

The patch introduces MAX_POSSIBLE_PHYSMEM_BITS to cover such case.
It also suits well to handle PAE special case.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Nitin Gupta <ngupta@vflare.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-mm@kvack.org
Link: http://lkml.kernel.org/r/20180214111656.88514-3-kirill.shutemov@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/x86/include/asm/pgtable-3level_types.h |  1 +
 arch/x86/include/asm/pgtable_64_types.h     |  2 ++
 mm/zsmalloc.c                               | 13 +++++++------
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pgtable-3level_types.h b/arch/x86/include/asm/pgtable-3level_types.h
index 876b4c77d983..6a59a6d0cc50 100644
--- a/arch/x86/include/asm/pgtable-3level_types.h
+++ b/arch/x86/include/asm/pgtable-3level_types.h
@@ -44,5 +44,6 @@ typedef union {
  */
 #define PTRS_PER_PTE	512
 
+#define MAX_POSSIBLE_PHYSMEM_BITS	36
 
 #endif /* _ASM_X86_PGTABLE_3LEVEL_DEFS_H */
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index bf6d2692fc60..2bd79b7ae9d6 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -40,6 +40,8 @@ typedef struct { pteval_t pte; } pte_t;
 #define P4D_SIZE	(_AC(1, UL) << P4D_SHIFT)
 #define P4D_MASK	(~(P4D_SIZE - 1))
 
+#define MAX_POSSIBLE_PHYSMEM_BITS	52
+
 #else /* CONFIG_X86_5LEVEL */
 
 /*
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 6ed736ea9b59..633ebcac82f8 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -83,18 +83,19 @@
  * This is made more complicated by various memory models and PAE.
  */
 
-#ifndef MAX_PHYSMEM_BITS
-#ifdef CONFIG_HIGHMEM64G
-#define MAX_PHYSMEM_BITS 36
-#else /* !CONFIG_HIGHMEM64G */
+#ifndef MAX_POSSIBLE_PHYSMEM_BITS
+#ifdef MAX_PHYSMEM_BITS
+#define MAX_POSSIBLE_PHYSMEM_BITS MAX_PHYSMEM_BITS
+#else
 /*
  * If this definition of MAX_PHYSMEM_BITS is used, OBJ_INDEX_BITS will just
  * be PAGE_SHIFT
  */
-#define MAX_PHYSMEM_BITS BITS_PER_LONG
+#define MAX_POSSIBLE_PHYSMEM_BITS BITS_PER_LONG
 #endif
 #endif
-#define _PFN_BITS		(MAX_PHYSMEM_BITS - PAGE_SHIFT)
+
+#define _PFN_BITS		(MAX_POSSIBLE_PHYSMEM_BITS - PAGE_SHIFT)
 
 /*
  * Memory for allocating for handle keeps object position by
-- 
2.25.1

