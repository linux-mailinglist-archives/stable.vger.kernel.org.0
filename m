Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 001466D82D1
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 18:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235105AbjDEQD0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 12:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232866AbjDEQDZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 12:03:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41DD4ECD
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 09:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680710564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9SgMl0U05ydcYM0cFwFg6RkUkX/SVGBlhLdBNLErgqU=;
        b=ed68qEC0XWcHDp2iV+nuV6h1uEYi/RqYZbPYDGZGMn7E5LDWUYtgYNuul0yXe6TCX6SKf9
        SnJ5EGl5vXqaFTptY+yFzfpGDgjD2wslflBe4qGu9mOfTbhexJouL23V2PNP7Yd2BhXkgR
        skeXxXMTnKxBS70bdwFGYTn7dhbNnLc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-QqiIz_h_NguASfvv2dusNA-1; Wed, 05 Apr 2023 12:02:40 -0400
X-MC-Unique: QqiIz_h_NguASfvv2dusNA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27BE238221CD;
        Wed,  5 Apr 2023 16:02:40 +0000 (UTC)
Received: from t480s.fritz.box (unknown [10.39.195.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD0DF492C14;
        Wed,  5 Apr 2023 16:02:38 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/2] mm/userfaultfd: fix uffd-wp handling for THP migration entries
Date:   Wed,  5 Apr 2023 18:02:35 +0200
Message-Id: <20230405160236.587705-2-david@redhat.com>
In-Reply-To: <20230405160236.587705-1-david@redhat.com>
References: <20230405160236.587705-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks like what we fixed for hugetlb in commit 44f86392bdd1 ("mm/hugetlb:
fix uffd-wp handling for migration entries in hugetlb_change_protection()")
similarly applies to THP.

Setting/clearing uffd-wp on THP migration entries is not implemented
properly. Further, while removing migration PMDs considers the uffd-wp
bit, inserting migration PMDs does not consider the uffd-wp bit.

We have to set/clear independently of the migration entry type in
change_huge_pmd() and properly copy the uffd-wp bit in
set_pmd_migration_entry().

Verified using a simple reproducer that triggers migration of a THP, that
the set_pmd_migration_entry() no longer loses the uffd-wp bit.

Fixes: f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration")
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/huge_memory.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 032fb0ef9cd1..e3706a2b34b2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1838,10 +1838,10 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	if (is_swap_pmd(*pmd)) {
 		swp_entry_t entry = pmd_to_swp_entry(*pmd);
 		struct page *page = pfn_swap_entry_to_page(entry);
+		pmd_t newpmd;
 
 		VM_BUG_ON(!is_pmd_migration_entry(*pmd));
 		if (is_writable_migration_entry(entry)) {
-			pmd_t newpmd;
 			/*
 			 * A protection check is difficult so
 			 * just be safe and disable write
@@ -1855,8 +1855,16 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 				newpmd = pmd_swp_mksoft_dirty(newpmd);
 			if (pmd_swp_uffd_wp(*pmd))
 				newpmd = pmd_swp_mkuffd_wp(newpmd);
-			set_pmd_at(mm, addr, pmd, newpmd);
+		} else {
+			newpmd = *pmd;
 		}
+
+		if (uffd_wp)
+			newpmd = pmd_swp_mkuffd_wp(newpmd);
+		else if (uffd_wp_resolve)
+			newpmd = pmd_swp_clear_uffd_wp(newpmd);
+		if (!pmd_same(*pmd, newpmd))
+			set_pmd_at(mm, addr, pmd, newpmd);
 		goto unlock;
 	}
 #endif
@@ -3251,6 +3259,8 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 	pmdswp = swp_entry_to_pmd(entry);
 	if (pmd_soft_dirty(pmdval))
 		pmdswp = pmd_swp_mksoft_dirty(pmdswp);
+	if (pmd_uffd_wp(pmdval))
+		pmdswp = pmd_swp_mkuffd_wp(pmdswp);
 	set_pmd_at(mm, address, pvmw->pmd, pmdswp);
 	page_remove_rmap(page, vma, true);
 	put_page(page);
-- 
2.39.2

