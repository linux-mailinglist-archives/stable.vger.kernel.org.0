Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8788F217207
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbgGGP1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:27:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729613AbgGGP0x (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:26:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76A6D2078D;
        Tue,  7 Jul 2020 15:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135612;
        bh=0y18ZHgiz26Tm4pcX6CTElfyBW51TPaISFDBGKZ4z9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XDMOxePUAogxwVfTc51jg3b5Ry6zFbo3H0t2NjJqRemCFvDRDJLY3npRCWtntp1Cm
         GVByeUGAE6xZYMxpGR4Yt80ahdtvLB9pDF8uq98XXEc+/K9+4yx0QR5yZybFTIgLcH
         2dHKUGFiBzrqzsAFLo6LjhSmc2WlVhSW4NgeQVVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.7 109/112] mm/hugetlb.c: fix pages per hugetlb calculation
Date:   Tue,  7 Jul 2020 17:17:54 +0200
Message-Id: <20200707145806.156348388@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>

commit 1139d336fff425f9a20374945cdd28eb44d09fa8 upstream.

The routine hpage_nr_pages() was incorrectly used to calculate the number
of base pages in a hugetlb page.  hpage_nr_pages is designed to be called
for THP pages and will return HPAGE_PMD_NR for hugetlb pages of any size.

Due to the context in which hpage_nr_pages was called, it is unlikely to
produce a user visible error.  The routine with the incorrect call is only
exercised in the case of hugetlb memory error or migration.  In addition,
this would need to be on an architecture which supports huge page sizes
less than PMD_SIZE.  And, the vma containing the huge page would also need
to smaller than PMD_SIZE.

Fixes: c0d0381ade79 ("hugetlbfs: use i_mmap_rwsem for more pmd sharing synchronization")
Reported-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200629185003.97202-1-mike.kravetz@oracle.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1594,7 +1594,7 @@ static struct address_space *_get_hugetl
 
 	/* Use first found vma */
 	pgoff_start = page_to_pgoff(hpage);
-	pgoff_end = pgoff_start + hpage_nr_pages(hpage) - 1;
+	pgoff_end = pgoff_start + pages_per_huge_page(page_hstate(hpage)) - 1;
 	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root,
 					pgoff_start, pgoff_end) {
 		struct vm_area_struct *vma = avc->vma;


