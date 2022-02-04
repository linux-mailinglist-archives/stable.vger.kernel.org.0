Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBF84A9323
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 05:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbiBDEtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 23:49:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbiBDEtP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 23:49:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A9BC061714;
        Thu,  3 Feb 2022 20:49:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 530AEB83669;
        Fri,  4 Feb 2022 04:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F58C004E1;
        Fri,  4 Feb 2022 04:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643950153;
        bh=T6HZzuF9kGoCDs+xTHJbPxAXenTBHTFYjDOPtEfogn0=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=pRtMXnfQgDH4cec97TvEXBzcUrEgQdiqZrqQg/QlHoigq+4M++UcCfiip4dbAqczf
         ntmVRfvP+eM6ebJOTyUZPypJz7poKn/nOZhBPWSRvsZ96MZe31sCrSDBxd0sP+05vE
         wR15nCGANM54UIPLffV7Bwf8KhLvEileBO4Hrk0w=
Received: by hp1 (sSMTP sendmail emulation); Thu, 03 Feb 2022 20:49:10 -0800
Date:   Thu, 03 Feb 2022 20:49:10 -0800
To:     ziy@nvidia.com, will@kernel.org, weixugc@google.com,
        stable@vger.kernel.org, songmuchun@bytedance.com, rppt@kernel.org,
        rientjes@google.com, pjt@google.com, mingo@redhat.com,
        jirislaby@kernel.org, hughd@google.com, hpa@zytor.com,
        gthelen@google.com, dave.hansen@linux.intel.com,
        anshuman.khandual@arm.com, aneesh.kumar@linux.ibm.com,
        pasha.tatashin@soleen.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220203204836.88dcebe504f440686cc63a60@linux-foundation.org>
Subject: [patch 02/10] mm/debug_vm_pgtable: remove pte entry from the page table
Message-Id: <20220204044911.75F58C004E1@smtp.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: mm/debug_vm_pgtable: remove pte entry from the page table

Patch series "page table check fixes and cleanups", v5.


This patch (of 4):

The pte entry that is used in pte_advanced_tests() is never removed from
the page table at the end of the test.

The issue is detected by page_table_check, to repro compile kernel with
the following configs:

CONFIG_DEBUG_VM_PGTABLE=y
CONFIG_PAGE_TABLE_CHECK=y
CONFIG_PAGE_TABLE_CHECK_ENFORCED=y

During the boot the following BUG is printed:

[    2.262821] debug_vm_pgtable: [debug_vm_pgtable         ]: Validating
               architecture page table helpers
[    2.276826] ------------[ cut here ]------------
[    2.280426] kernel BUG at mm/page_table_check.c:162!
[    2.284118] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[    2.287787] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
               5.16.0-11413-g2c271fe77d52 #3
[    2.293226] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
               BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org
               04/01/2014
...

The entry should be properly removed from the page table before the page
is released to the free list.

Link: https://lkml.kernel.org/r/20220131203249.2832273-1-pasha.tatashin@soleen.com
Link: https://lkml.kernel.org/r/20220131203249.2832273-2-pasha.tatashin@soleen.com
Fixes: a5c3b9ffb0f4 ("mm/debug_vm_pgtable: add tests validating advanced arch page table helpers")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Paul Turner <pjt@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>	[5.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-remove-pte-entry-from-the-page-table
+++ a/mm/debug_vm_pgtable.c
@@ -171,6 +171,8 @@ static void __init pte_advanced_tests(st
 	ptep_test_and_clear_young(args->vma, args->vaddr, args->ptep);
 	pte = ptep_get(args->ptep);
 	WARN_ON(pte_young(pte));
+
+	ptep_get_and_clear_full(args->mm, args->vaddr, args->ptep, 1);
 }
 
 static void __init pte_savedwrite_tests(struct pgtable_debug_args *args)
_
