Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A90F17FB57
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbgCJNND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:13:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730937AbgCJNNB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:13:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA77320409;
        Tue, 10 Mar 2020 13:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845980;
        bh=64dyv7LUHdrDrxpw8t1UmC6M0VJ1Ztk8f2HrYqIaXD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2GFN3opIrnAClDL5yuK3WiLe5GsuTJwm79dej4BIe7Meu4nWmNmDjyQ6yJbAx16iw
         PnV2PTxozMiZ8a7oTpQYCZ+FTJJyJyMQcv8ZZWUSfAqbrfElBxv5Uj/70OPk/N1xSO
         69kDT3dY2kqLL+tJo6xa24W9Sbs2v5CzXvwOvoR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Huang, Ying" <ying.huang@intel.com>, Zi Yan <ziy@nvidia.com>,
        William Kucharski <william.kucharski@oracle.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 43/86] mm: fix possible PMD dirty bit lost in set_pmd_migration_entry()
Date:   Tue, 10 Mar 2020 13:45:07 +0100
Message-Id: <20200310124533.116095383@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124530.808338541@linuxfoundation.org>
References: <20200310124530.808338541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

commit 8a8683ad9ba48b4b52a57f013513d1635c1ca5c4 upstream.

In set_pmd_migration_entry(), pmdp_invalidate() is used to change PMD
atomically.  But the PMD is read before that with an ordinary memory
reading.  If the THP (transparent huge page) is written between the PMD
reading and pmdp_invalidate(), the PMD dirty bit may be lost, and cause
data corruption.  The race window is quite small, but still possible in
theory, so need to be fixed.

The race is fixed via using the return value of pmdp_invalidate() to get
the original content of PMD, which is a read/modify/write atomic
operation.  So no THP writing can occur in between.

The race has been introduced when the THP migration support is added in
the commit 616b8371539a ("mm: thp: enable thp migration in generic path").
But this fix depends on the commit d52605d7cb30 ("mm: do not lose dirty
and accessed bits in pmdp_invalidate()").  So it's easy to be backported
after v4.16.  But the race window is really small, so it may be fine not
to backport the fix at all.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Link: http://lkml.kernel.org/r/20200220075220.2327056-1-ying.huang@intel.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/huge_memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2949,8 +2949,7 @@ void set_pmd_migration_entry(struct page
 		return;
 
 	flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
-	pmdval = *pvmw->pmd;
-	pmdp_invalidate(vma, address, pvmw->pmd);
+	pmdval = pmdp_invalidate(vma, address, pvmw->pmd);
 	if (pmd_dirty(pmdval))
 		set_page_dirty(page);
 	entry = make_migration_entry(page, pmd_write(pmdval));


