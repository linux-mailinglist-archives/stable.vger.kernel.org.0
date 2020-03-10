Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 308E117FEB0
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgCJMlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:41:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726403AbgCJMlv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:41:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3751324693;
        Tue, 10 Mar 2020 12:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844110;
        bh=Wdzp1WQaX/ZtsYxayS5j8xWH4uUbKag1yCaHTZi9KXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AFXoIHjIn7lrRnfNYcpoYAsyTfqJeBGrsKKJ1ia+pNCCOEYcYXkZWmf6w5mPHsVF7
         QCGXsye9zjDPTkvoLIVmlI4HXXeyVypJ7rkhuQZBLOwIEkJDZLgn03qDkfbGlyHuP6
         ZFV0XFQiu8h5dE/RlojrF2xiflf2JgA7/EXZpUA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Punit Agrawal <punit.agrawal@arm.com>,
        Steve Capper <steve.capper@arm.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Hillf Danton <hillf.zj@alibaba-inc.com>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>,
        Ajay Kaher <akaher@vmware.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 4.4 34/72] mm, gup: remove broken VM_BUG_ON_PAGE compound check for hugepages
Date:   Tue, 10 Mar 2020 13:38:47 +0100
Message-Id: <20200310123609.676607449@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123601.053680753@linuxfoundation.org>
References: <20200310123601.053680753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit a3e328556d41bb61c55f9dfcc62d6a826ea97b85 upstream.

When operating on hugepages with DEBUG_VM enabled, the GUP code checks
the compound head for each tail page prior to calling
page_cache_add_speculative.  This is broken, because on the fast-GUP
path (where we don't hold any page table locks) we can be racing with a
concurrent invocation of split_huge_page_to_list.

split_huge_page_to_list deals with this race by using page_ref_freeze to
freeze the page and force concurrent GUPs to fail whilst the component
pages are modified.  This modification includes clearing the
compound_head field for the tail pages, so checking this prior to a
successful call to page_cache_add_speculative can lead to false
positives: In fact, page_cache_add_speculative *already* has this check
once the page refcount has been successfully updated, so we can simply
remove the broken calls to VM_BUG_ON_PAGE.

Link: http://lkml.kernel.org/r/20170522133604.11392-2-punit.agrawal@arm.com
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Acked-by: Steve Capper <steve.capper@arm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
Signed-off-by: Ajay Kaher <akaher@vmware.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/gup.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1134,7 +1134,6 @@ static int gup_huge_pmd(pmd_t orig, pmd_
 	page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 	tail = page;
 	do {
-		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 		pages[*nr] = page;
 		(*nr)++;
 		page++;
@@ -1181,7 +1180,6 @@ static int gup_huge_pud(pud_t orig, pud_
 	page = head + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
 	tail = page;
 	do {
-		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 		pages[*nr] = page;
 		(*nr)++;
 		page++;
@@ -1224,7 +1222,6 @@ static int gup_huge_pgd(pgd_t orig, pgd_
 	page = head + ((addr & ~PGDIR_MASK) >> PAGE_SHIFT);
 	tail = page;
 	do {
-		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 		pages[*nr] = page;
 		(*nr)++;
 		page++;


