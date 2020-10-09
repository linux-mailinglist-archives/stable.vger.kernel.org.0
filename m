Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949A7289BF3
	for <lists+stable@lfdr.de>; Sat, 10 Oct 2020 00:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389409AbgJIWwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 18:52:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731960AbgJIWwd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Oct 2020 18:52:33 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8CFD206A5;
        Fri,  9 Oct 2020 22:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602283953;
        bh=1gXRaxwG8B326B91LsmErsWVWHKi/vIR20AFfj5ck50=;
        h=Date:From:To:Subject:From;
        b=NcXVvkdmhBo0HLIAkOKYmiFf5SdWdBxXW+9LpSIhlMLzTuZAI/7uTsMiIUwIV3Eq6
         eMNSMZdM9R8+IgTUzasWph8BCNiYi6G1vaPip4rH+MbKBgbndlDpLJTmnmn4nA1w8S
         eEninRdLy9oc/QJ7Vs0IPaAk+9DhM0wxq7XMxUYQ=
Date:   Fri, 09 Oct 2020 15:52:32 -0700
From:   akpm@linux-foundation.org
To:     bsingharora@gmail.com, hannes@cmpxchg.org, ira.weiny@intel.com,
        jglisse@redhat.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, stable@vger.kernel.org,
        vdavydov.dev@gmail.com
Subject:  + mm-memcg-fix-device-private-memcg-accounting.patch
 added to -mm tree
Message-ID: <20201009225232.JEIXFRhOc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/memcg: fix device private memcg accounting
has been added to the -mm tree.  Its filename is
     mm-memcg-fix-device-private-memcg-accounting.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-fix-device-private-memcg-accounting.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-fix-device-private-memcg-accounting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/memcg: fix device private memcg accounting

The code in mc_handle_swap_pte() checks for non_swap_entry() and returns
NULL before checking is_device_private_entry() so device private pages are
never handled.  Fix this by checking for non_swap_entry() after handling
device private swap PTEs.

Link: https://lkml.kernel.org/r/20201009215952.2726-1-rcampbell@nvidia.com
Fixes: c733a82874a7 ("mm/memcontrol: support MEMORY_DEVICE_PRIVATE")
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-fix-device-private-memcg-accounting
+++ a/mm/memcontrol.c
@@ -5516,7 +5516,7 @@ static struct page *mc_handle_swap_pte(s
 	struct page *page = NULL;
 	swp_entry_t ent = pte_to_swp_entry(ptent);
 
-	if (!(mc.flags & MOVE_ANON) || non_swap_entry(ent))
+	if (!(mc.flags & MOVE_ANON))
 		return NULL;
 
 	/*
@@ -5535,6 +5535,9 @@ static struct page *mc_handle_swap_pte(s
 		return page;
 	}
 
+	if (non_swap_entry(ent))
+		return NULL;
+
 	/*
 	 * Because lookup_swap_cache() updates some statistics counter,
 	 * we call find_get_page() with swapper_space directly.
_

Patches currently in -mm which might be from rcampbell@nvidia.com are

mm-memcg-fix-device-private-memcg-accounting.patch
mm-test-use-the-new-skip-macro.patch
hmm-test-remove-unused-dmirror_zero_page.patch
mm-move-call-to-compound_head-in-release_pages.patch
mm-migrate-remove-cpages-in-migrate_vma_finalize.patch
mm-migrate-remove-obsolete-comment-about-device-public.patch

