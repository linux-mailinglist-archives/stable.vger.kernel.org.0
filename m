Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05D733AA19
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732017AbfFIQxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:53:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732496AbfFIQxw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:53:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61AAC204EC;
        Sun,  9 Jun 2019 16:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099230;
        bh=jn5STUV+VcC4A12rzncY3TQ86QUZFyuFr8waJzuPqhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rNxuJoHv6T/M4dfVv6m74Um4s+Bx0mmWZJx3YZz4ILkINWJuDoveX3lljK2bng10b
         66Z4OkEGCvcuADD9SXq8gzcHnadfaT7/1KCdRQ0M86+eXS+8G+T3GD7vr1z2GpQzxu
         Pwlp1MdILAj81BdJTrc0q/VFqRe4ql5mISYJ1AFI=
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
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.9 55/83] mm, gup: remove broken VM_BUG_ON_PAGE compound check for hugepages
Date:   Sun,  9 Jun 2019 18:42:25 +0200
Message-Id: <20190609164132.620872548@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
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
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/gup.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1316,7 +1316,6 @@ static int gup_huge_pmd(pmd_t orig, pmd_
 	head = pmd_page(orig);
 	page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 	do {
-		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 		pages[*nr] = page;
 		(*nr)++;
 		page++;
@@ -1351,7 +1350,6 @@ static int gup_huge_pud(pud_t orig, pud_
 	head = pud_page(orig);
 	page = head + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
 	do {
-		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 		pages[*nr] = page;
 		(*nr)++;
 		page++;
@@ -1387,7 +1385,6 @@ static int gup_huge_pgd(pgd_t orig, pgd_
 	head = pgd_page(orig);
 	page = head + ((addr & ~PGDIR_MASK) >> PAGE_SHIFT);
 	do {
-		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 		pages[*nr] = page;
 		(*nr)++;
 		page++;


