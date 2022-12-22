Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCEF654793
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 21:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235522AbiLVU4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 15:56:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235507AbiLVU4M (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 15:56:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14101CB08
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 12:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671742524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F0EDg+aKW31sZt/nNenws8XeVzJOg6ps93oALzUHu5c=;
        b=GgqHZClNgNKOKOvjijCdPJ4tv+P/4wRmaylL0axN5Tzn+qXm13GQ2pKviFyuYmhkjZkZwG
        r39Am+2qaFLvmItqKJ6KeVWspS7ElvwGnzJgG3KHEOC4iM+1YKL9JnNlKQqHymfkpcybL6
        rNoMW0Dehtf/Gj+nwhlcoh4WhuYOZJY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-Gw7L4NaePVO3xdU5CBBExw-1; Thu, 22 Dec 2022 15:55:20 -0500
X-MC-Unique: Gw7L4NaePVO3xdU5CBBExw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31C301C05AE6;
        Thu, 22 Dec 2022 20:55:20 +0000 (UTC)
Received: from t480s.fritz.box (unknown [10.39.193.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 168CE40C2064;
        Thu, 22 Dec 2022 20:55:17 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Peter Xu <peterx@redhat.com>,
        Muchun Song <muchun.song@linux.dev>,
        Miaohe Lin <linmiaohe@huawei.com>, stable@vger.kernel.org
Subject: [PATCH v1 2/2] mm/hugetlb: fix uffd-wp handling for migration entries in hugetlb_change_protection()
Date:   Thu, 22 Dec 2022 21:55:11 +0100
Message-Id: <20221222205511.675832-3-david@redhat.com>
In-Reply-To: <20221222205511.675832-1-david@redhat.com>
References: <20221222205511.675832-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We have to update the uffd-wp SWP PTE bit independent of the type of
migration entry. Currently, if we're unlucky and we want to install/clear
the uffd-wp bit just while we're migrating a read-only mapped hugetlb page,
we would miss to set/clear the uffd-wp bit.

Further, if we're processing a readable-exclusive
migration entry and neither want to set or clear the uffd-wp bit, we
could currently end up losing the uffd-wp bit. Note that the same would
hold for writable migrating entries, however, having a writable
migration entry with the uffd-wp bit set would already mean that
something went wrong.

Note that the change from !is_readable_migration_entry ->
writable_migration_entry is harmless and actually cleaner, as raised by
Miaohe Lin and discussed in [1].

[1] https://lkml.kernel.org/r/90dd6a93-4500-e0de-2bf0-bf522c311b0c@huawei.com

Fixes: 60dfaad65aa9 ("mm/hugetlb: allow uffd wr-protect none ptes")
Cc: <stable@vger.kernel.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/hugetlb.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 3a94f519304f..9552a6d1a281 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6516,10 +6516,9 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 		} else if (unlikely(is_hugetlb_entry_migration(pte))) {
 			swp_entry_t entry = pte_to_swp_entry(pte);
 			struct page *page = pfn_swap_entry_to_page(entry);
+			pte_t newpte = pte;
 
-			if (!is_readable_migration_entry(entry)) {
-				pte_t newpte;
-
+			if (is_writable_migration_entry(entry)) {
 				if (PageAnon(page))
 					entry = make_readable_exclusive_migration_entry(
 								swp_offset(entry));
@@ -6527,13 +6526,15 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 					entry = make_readable_migration_entry(
 								swp_offset(entry));
 				newpte = swp_entry_to_pte(entry);
-				if (uffd_wp)
-					newpte = pte_swp_mkuffd_wp(newpte);
-				else if (uffd_wp_resolve)
-					newpte = pte_swp_clear_uffd_wp(newpte);
-				set_huge_pte_at(mm, address, ptep, newpte);
 				pages++;
 			}
+
+			if (uffd_wp)
+				newpte = pte_swp_mkuffd_wp(newpte);
+			else if (uffd_wp_resolve)
+				newpte = pte_swp_clear_uffd_wp(newpte);
+			if (!pte_same(pte, newpte))
+				set_huge_pte_at(mm, address, ptep, newpte);
 		} else if (unlikely(is_pte_marker(pte))) {
 			/* No other markers apply for now. */
 			WARN_ON_ONCE(!pte_marker_uffd_wp(pte));
-- 
2.38.1

