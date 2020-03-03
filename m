Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5F4C1781B7
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388241AbgCCSFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:05:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:40950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733280AbgCCR6O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:58:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4E72206D5;
        Tue,  3 Mar 2020 17:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258294;
        bh=Q2MjtVvxC5xr/bDXpfVIwBo3Vncj7bgd4XFUIKTTnmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QFVmNy6j/jBF6spNEkoqtVzhuBPaED9etbwcfvA1CNQxIEZUE6lh+CHk2/bBiGeh2
         PxelSW7Hjb2OqWbUMYF0ozhxSPuAUSMvS5Hz/drCaXlmO2zXaK4EDfAjpKLWW0JPBr
         ecw4xA1smFDM/jOD4o89xzIhYAK34Sr0ypjvl1O8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Michal Hocko <mhocko@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        David Hildenbrand <david@redhat.com>, Qian Cai <cai@lca.pw>,
        Oscar Salvador <osalvador@suse.de>,
        Mel Gorman <mgorman@techsingularity.net>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 147/152] mm/debug.c: always print flags in dump_page()
Date:   Tue,  3 Mar 2020 18:44:05 +0100
Message-Id: <20200303174319.499629395@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>

commit 5b57b8f22709f07c0ab5921c94fd66e8c59c3e11 upstream.

Commit 76a1850e4572 ("mm/debug.c: __dump_page() prints an extra line")
inadvertently removed printing of page flags for pages that are neither
anon nor ksm nor have a mapping.  Fix that.

Using pr_cont() again would be a solution, but the commit explicitly
removed its use.  Avoiding the danger of mixing up split lines from
multiple CPUs might be beneficial for near-panic dumps like this, so fix
this without reintroducing pr_cont().

Link: http://lkml.kernel.org/r/9f884d5c-ca60-dc7b-219c-c081c755fab6@suse.cz
Fixes: 76a1850e4572 ("mm/debug.c: __dump_page() prints an extra line")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reported-by: Michal Hocko <mhocko@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Pavel Tatashin <pavel.tatashin@microsoft.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/debug.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/debug.c
+++ b/mm/debug.c
@@ -47,6 +47,7 @@ void __dump_page(struct page *page, cons
 	struct address_space *mapping;
 	bool page_poisoned = PagePoisoned(page);
 	int mapcount;
+	char *type = "";
 
 	/*
 	 * If struct page is poisoned don't access Page*() functions as that
@@ -78,9 +79,9 @@ void __dump_page(struct page *page, cons
 			page, page_ref_count(page), mapcount,
 			page->mapping, page_to_pgoff(page));
 	if (PageKsm(page))
-		pr_warn("ksm flags: %#lx(%pGp)\n", page->flags, &page->flags);
+		type = "ksm ";
 	else if (PageAnon(page))
-		pr_warn("anon flags: %#lx(%pGp)\n", page->flags, &page->flags);
+		type = "anon ";
 	else if (mapping) {
 		if (mapping->host && mapping->host->i_dentry.first) {
 			struct dentry *dentry;
@@ -88,10 +89,11 @@ void __dump_page(struct page *page, cons
 			pr_warn("%ps name:\"%pd\"\n", mapping->a_ops, dentry);
 		} else
 			pr_warn("%ps\n", mapping->a_ops);
-		pr_warn("flags: %#lx(%pGp)\n", page->flags, &page->flags);
 	}
 	BUILD_BUG_ON(ARRAY_SIZE(pageflag_names) != __NR_PAGEFLAGS + 1);
 
+	pr_warn("%sflags: %#lx(%pGp)\n", type, page->flags, &page->flags);
+
 hex_only:
 	print_hex_dump(KERN_WARNING, "raw: ", DUMP_PREFIX_NONE, 32,
 			sizeof(unsigned long), page,


