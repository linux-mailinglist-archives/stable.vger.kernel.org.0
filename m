Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99FCE31C8D
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728756AbfFANWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:22:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728136AbfFANWf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:22:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF97126E87;
        Sat,  1 Jun 2019 13:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395354;
        bh=gOZxUIYQsBEQRv9bk+M8JatOYaVu6PBPjijotTiPsns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wHZUqz32iMTPY1jA7ax4RY3fenLrXNAdaQmzNdANUaF0MH+Fi4Wbf/8ckv3ikjlzu
         +dIh+cdEP31vBOn84qlvACNtF+M1OInnwSmhPHsvChVfKw9Cw5UdERLv5Vc4lchfq9
         Iuw1+lrUeqVnQd3Dk8m3pMCZgbFaqveG6y9Glk/4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 4.19 013/141] mm: page_mkclean vs MADV_DONTNEED race
Date:   Sat,  1 Jun 2019 09:19:49 -0400
Message-Id: <20190601132158.25821-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132158.25821-1-sashal@kernel.org>
References: <20190601132158.25821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>

[ Upstream commit 024eee0e83f0df52317be607ca521e0fc572aa07 ]

MADV_DONTNEED is handled with mmap_sem taken in read mode.  We call
page_mkclean without holding mmap_sem.

MADV_DONTNEED implies that pages in the region are unmapped and subsequent
access to the pages in that range is handled as a new page fault.  This
implies that if we don't have parallel access to the region when
MADV_DONTNEED is run we expect those range to be unallocated.

w.r.t page_mkclean() we need to make sure that we don't break the
MADV_DONTNEED semantics.  MADV_DONTNEED check for pmd_none without holding
pmd_lock.  This implies we skip the pmd if we temporarily mark pmd none.
Avoid doing that while marking the page clean.

Keep the sequence same for dax too even though we don't support
MADV_DONTNEED for dax mapping

The bug was noticed by code review and I didn't observe any failures w.r.t
test run.  This is similar to

commit 58ceeb6bec86d9140f9d91d71a710e963523d063
Author: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Date:   Thu Apr 13 14:56:26 2017 -0700

    thp: fix MADV_DONTNEED vs. MADV_FREE race

commit ced108037c2aa542b3ed8b7afd1576064ad1362a
Author: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Date:   Thu Apr 13 14:56:20 2017 -0700

    thp: fix MADV_DONTNEED vs. numa balancing race

Link: http://lkml.kernel.org/r/20190321040610.14226-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc:"Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c  | 2 +-
 mm/rmap.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 004c8ac1117c4..75a289c31c7e5 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -908,7 +908,7 @@ static void dax_mapping_entry_mkclean(struct address_space *mapping,
 				goto unlock_pmd;
 
 			flush_cache_page(vma, address, pfn);
-			pmd = pmdp_huge_clear_flush(vma, address, pmdp);
+			pmd = pmdp_invalidate(vma, address, pmdp);
 			pmd = pmd_wrprotect(pmd);
 			pmd = pmd_mkclean(pmd);
 			set_pmd_at(vma->vm_mm, address, pmdp, pmd);
diff --git a/mm/rmap.c b/mm/rmap.c
index 85b7f94233526..f048c2651954b 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -926,7 +926,7 @@ static bool page_mkclean_one(struct page *page, struct vm_area_struct *vma,
 				continue;
 
 			flush_cache_page(vma, address, page_to_pfn(page));
-			entry = pmdp_huge_clear_flush(vma, address, pmd);
+			entry = pmdp_invalidate(vma, address, pmd);
 			entry = pmd_wrprotect(entry);
 			entry = pmd_mkclean(entry);
 			set_pmd_at(vma->vm_mm, address, pmd, entry);
-- 
2.20.1

