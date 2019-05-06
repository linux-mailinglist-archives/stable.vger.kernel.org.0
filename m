Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB4A814D9D
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbfEFOr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:47:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728798AbfEFOrY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:47:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA158214AE;
        Mon,  6 May 2019 14:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557154043;
        bh=AlTtKsKgZWXRO+VchEO+ZdakVY1Z7mSRhb03uM8VTsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/F/BCj1dIW3N47tAP1U7ftupgzJqcweIS5+suq/UxWLcqqWkH/+SsZThzRc/ZsWN
         scYgC98OQ4B5qm91Hk2I45VtiZ0VTOMIZS2fx2g5svYfiAx826jVd6BU6dDN+jUCOB
         QMzjCJIklP2kWcWrO1avlL4pp8+zKH1oBJ0PCJSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>
Subject: [PATCH 4.9 17/62] arm64: proc: Set PTE_NG for table entries to avoid traversing them twice
Date:   Mon,  6 May 2019 16:32:48 +0200
Message-Id: <20190506143052.549892170@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143051.102535767@linuxfoundation.org>
References: <20190506143051.102535767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit 2ce77f6d8a9ae9ce6d80397d88bdceb84a2004cd upstream.

When KASAN is enabled, the swapper page table contains many identical
mappings of the zero page, which can lead to a stall during boot whilst
the G -> nG code continually walks the same page table entries looking
for global mappings.

This patch sets the nG bit (bit 11, which is IGNORED) in table entries
after processing the subtree so we can easily skip them if we see them
a second time.

Tested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/mm/proc.S |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -181,7 +181,8 @@ ENDPROC(idmap_cpu_replace_ttbr1)
 	dc	cvac, cur_\()\type\()p		// Ensure any existing dirty
 	dmb	sy				// lines are written back before
 	ldr	\type, [cur_\()\type\()p]	// loading the entry
-	tbz	\type, #0, next_\()\type	// Skip invalid entries
+	tbz	\type, #0, skip_\()\type	// Skip invalid and
+	tbnz	\type, #11, skip_\()\type	// non-global entries
 	.endm
 
 	.macro __idmap_kpti_put_pgtable_ent_ng, type
@@ -241,8 +242,9 @@ ENTRY(idmap_kpti_install_ng_mappings)
 	add	end_pgdp, cur_pgdp, #(PTRS_PER_PGD * 8)
 do_pgd:	__idmap_kpti_get_pgtable_ent	pgd
 	tbnz	pgd, #1, walk_puds
-	__idmap_kpti_put_pgtable_ent_ng	pgd
 next_pgd:
+	__idmap_kpti_put_pgtable_ent_ng	pgd
+skip_pgd:
 	add	cur_pgdp, cur_pgdp, #8
 	cmp	cur_pgdp, end_pgdp
 	b.ne	do_pgd
@@ -270,8 +272,9 @@ walk_puds:
 	add	end_pudp, cur_pudp, #(PTRS_PER_PUD * 8)
 do_pud:	__idmap_kpti_get_pgtable_ent	pud
 	tbnz	pud, #1, walk_pmds
-	__idmap_kpti_put_pgtable_ent_ng	pud
 next_pud:
+	__idmap_kpti_put_pgtable_ent_ng	pud
+skip_pud:
 	add	cur_pudp, cur_pudp, 8
 	cmp	cur_pudp, end_pudp
 	b.ne	do_pud
@@ -290,8 +293,9 @@ walk_pmds:
 	add	end_pmdp, cur_pmdp, #(PTRS_PER_PMD * 8)
 do_pmd:	__idmap_kpti_get_pgtable_ent	pmd
 	tbnz	pmd, #1, walk_ptes
-	__idmap_kpti_put_pgtable_ent_ng	pmd
 next_pmd:
+	__idmap_kpti_put_pgtable_ent_ng	pmd
+skip_pmd:
 	add	cur_pmdp, cur_pmdp, #8
 	cmp	cur_pmdp, end_pmdp
 	b.ne	do_pmd
@@ -309,7 +313,7 @@ walk_ptes:
 	add	end_ptep, cur_ptep, #(PTRS_PER_PTE * 8)
 do_pte:	__idmap_kpti_get_pgtable_ent	pte
 	__idmap_kpti_put_pgtable_ent_ng	pte
-next_pte:
+skip_pte:
 	add	cur_ptep, cur_ptep, #8
 	cmp	cur_ptep, end_ptep
 	b.ne	do_pte


