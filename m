Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129863C55D0
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346642AbhGLIMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:12:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353938AbhGLIDK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7672461186;
        Mon, 12 Jul 2021 07:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076734;
        bh=CwL1dOH3+SCGzlENRnzVJKOJ9+JbVmTeYLz9v5W0UBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1d0S3gvVCpmU6XVDywyEIVEmWavkO3mJbjDrIDM9DOSt6y4vCQopeScUNc4k4AuF2
         rBywrG1xRvEIfcy9IKVopk7/YZUVCJ+S2WtPz6aulOUxc8CNl4Xo0eyUZ/ju31ATTy
         a1omfGvy5PwF7AiVkMqEP63BaF23zidn9pyaJLA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Michal Hocko <mhocko@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 771/800] mm: migrate: fix missing update page_private to hugetlb_page_subpool
Date:   Mon, 12 Jul 2021 08:13:14 +0200
Message-Id: <20210712061048.866691052@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

[ Upstream commit 6acfb5ba150cf75005ce85e0e25d79ef2fec287c ]

Since commit d6995da31122 ("hugetlb: use page.private for hugetlb specific
page flags") converts page.private for hugetlb specific page flags.  We
should use hugetlb_page_subpool() to get the subpool pointer instead of
page_private().

This 'could' prevent the migration of hugetlb pages.  page_private(hpage)
is now used for hugetlb page specific flags.  At migration time, the only
flag which could be set is HPageVmemmapOptimized.  This flag will only be
set if the new vmemmap reduction feature is enabled.  In addition,
!page_mapping() implies an anonymous mapping.  So, this will prevent
migration of hugetb pages in anonymous mappings if the vmemmap reduction
feature is enabled.

In addition, that if statement checked for the rare race condition of a
page being migrated while in the process of being freed.  Since that check
is now wrong, we could leak hugetlb subpool usage counts.

The commit forgot to update it in the page migration routine.  So fix it.

[songmuchun@bytedance.com: fix compiler error when !CONFIG_HUGETLB_PAGE reported by Randy]
  Link: https://lkml.kernel.org/r/20210521022747.35736-1-songmuchun@bytedance.com

Link: https://lkml.kernel.org/r/20210520025949.1866-1-songmuchun@bytedance.com
Fixes: d6995da31122 ("hugetlb: use page.private for hugetlb specific page flags")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reported-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Tested-by: Anshuman Khandual <anshuman.khandual@arm.com>	[arm64]
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hugetlb.h | 5 +++++
 mm/migrate.c            | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 3c0117656745..28a110ec2a0d 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -875,6 +875,11 @@ static inline void huge_ptep_modify_prot_commit(struct vm_area_struct *vma,
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 
+static inline struct hugepage_subpool *hugetlb_page_subpool(struct page *hpage)
+{
+	return NULL;
+}
+
 static inline int isolate_or_dissolve_huge_page(struct page *page,
 						struct list_head *list)
 {
diff --git a/mm/migrate.c b/mm/migrate.c
index 41ff2c9896c4..047209d6602e 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1288,7 +1288,7 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
 	 * page_mapping() set, hugetlbfs specific move page routine will not
 	 * be called and we could leak usage counts for subpools.
 	 */
-	if (page_private(hpage) && !page_mapping(hpage)) {
+	if (hugetlb_page_subpool(hpage) && !page_mapping(hpage)) {
 		rc = -EBUSY;
 		goto out_unlock;
 	}
-- 
2.30.2



