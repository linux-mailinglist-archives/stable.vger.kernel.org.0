Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF177177FA9
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732104AbgCCRwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:52:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:60390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730562AbgCCRwI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:52:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86CA721739;
        Tue,  3 Mar 2020 17:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257928;
        bh=Q2MjtVvxC5xr/bDXpfVIwBo3Vncj7bgd4XFUIKTTnmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pJBGJpgZmn7CnZrt4SpANzmZ1vQvD0MqNE8fkNwGN8Ud0TW3lSyyYu4NynNqkGNik
         fqe0G5ulxr+6zrQgjuaNHJCPQhqYU7a6LOeNGHWD1k/H14ROPavosGlAmyEp6c7qjs
         gBZfBkTMP2YrmBClKi6ToBRKtfBLxW/jY0IBS+Kk=
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
Subject: [PATCH 5.5 171/176] mm/debug.c: always print flags in dump_page()
Date:   Tue,  3 Mar 2020 18:43:55 +0100
Message-Id: <20200303174323.716579374@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
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


