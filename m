Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 798DC5A486D
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbiH2LKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbiH2LJk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:09:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59DE67148;
        Mon, 29 Aug 2022 04:06:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77E01611B0;
        Mon, 29 Aug 2022 11:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8454EC433D6;
        Mon, 29 Aug 2022 11:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771092;
        bh=d3HKlBsXcLeK4mkuebyAltdj5guPsJxMc7cwL4yHCM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GYBQnLmd9ECJk9L3lFMFg63vkBhJvRoWSMPl203CEuYzZP3YXFA/hZrSs178VfJ3k
         Wig+qsc0y4YuGjyqJxj47noYMN6Xm4Al3DAvPUnHcakUu8EyE2GYH0BMXhYI7tliIC
         TtLNHB6JGguXlfTOF3f8FVseAVz8aoVL/riKhahg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        Yang Shi <shy828301@gmail.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Huang Ying <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 20/86] mm/smaps: dont access young/dirty bit if pte unpresent
Date:   Mon, 29 Aug 2022 12:58:46 +0200
Message-Id: <20220829105757.352116900@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
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

From: Peter Xu <peterx@redhat.com>

[ Upstream commit efd4149342db2df41b1bbe68972ead853b30e444 ]

These bits should only be valid when the ptes are present.  Introducing
two booleans for it and set it to false when !pte_present() for both pte
and pmd accountings.

The bug is found during code reading and no real world issue reported, but
logically such an error can cause incorrect readings for either smaps or
smaps_rollup output on quite a few fields.

For example, it could cause over-estimate on values like Shared_Dirty,
Private_Dirty, Referenced.  Or it could also cause under-estimate on
values like LazyFree, Shared_Clean, Private_Clean.

Link: https://lkml.kernel.org/r/20220805160003.58929-1-peterx@redhat.com
Fixes: b1d4d9e0cbd0 ("proc/smaps: carefully handle migration entries")
Fixes: c94b6923fa0a ("/proc/PID/smaps: Add PMD migration entry parsing")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/task_mmu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index ba98371e9d164..ef18f0d71b11b 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -503,10 +503,12 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 	struct vm_area_struct *vma = walk->vma;
 	bool locked = !!(vma->vm_flags & VM_LOCKED);
 	struct page *page = NULL;
-	bool migration = false;
+	bool migration = false, young = false, dirty = false;
 
 	if (pte_present(*pte)) {
 		page = vm_normal_page(vma, addr, *pte);
+		young = pte_young(*pte);
+		dirty = pte_dirty(*pte);
 	} else if (is_swap_pte(*pte)) {
 		swp_entry_t swpent = pte_to_swp_entry(*pte);
 
@@ -540,8 +542,7 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 	if (!page)
 		return;
 
-	smaps_account(mss, page, false, pte_young(*pte), pte_dirty(*pte),
-		      locked, migration);
+	smaps_account(mss, page, false, young, dirty, locked, migration);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-- 
2.35.1



