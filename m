Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90CDD277E37
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 04:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgIYCwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 22:52:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbgIYCwe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Sep 2020 22:52:34 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54FFF20888;
        Fri, 25 Sep 2020 02:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601002353;
        bh=s/HdbBS1UehdyeCCPAL4AWwE5WTWtA8TK6q/2tWhzGQ=;
        h=Date:From:To:Subject:From;
        b=TiMYoJieFr0pCKTRvwNW/ZwYITLiuLIc96XgO47a8/ZAsoX3VgQLaNT5uW6W0rOHX
         v99ZIOv/mMit1KAgzOQZRSllLQgZSrN+yb+Ix9f8Q5aI6zVCDrsc4deXD5RTUSbK4o
         SfIjCEhpMBx6pmxahOUPKlCcBL0yZNuk50jqqbZY=
Date:   Thu, 24 Sep 2020 19:52:32 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songliubraving@fb.com, pasha.tatashin@soleen.com, oleg@redhat.com,
        mhocko@suse.com, kirill.shutemov@linux.intel.com,
        apais@microsoft.com, aarcange@redhat.com,
        vijayb@linux.microsoft.com
Subject:  [to-be-updated]
 mm-khugepaged-avoid-overriding-min_free_kbytes-set-by-user.patch removed from
 -mm tree
Message-ID: <20200925025232._Ro5x%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: khugepaged: avoid overriding min_free_kbytes set by user
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-avoid-overriding-min_free_kbytes-set-by-user.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vijay Balakrishna <vijayb@linux.microsoft.com>
Subject: mm: khugepaged: avoid overriding min_free_kbytes set by user

set_recommended_min_free_kbytes need to honor min_free_kbytes set by the
user.  Post start-of-day THP enable or memory hotplug operations can lose
user specified min_free_kbytes, in particular when it is higher than
calculated recommended value.  user_min_free_kbytes initialized to 0 to
avoid undesired result when comparing with "unsigned long" type.

Link: https://lkml.kernel.org/r/1600305709-2319-3-git-send-email-vijayb@linux.microsoft.com
Signed-off-by: Vijay Balakrishna <vijayb@linux.microsoft.com>
Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Allen Pais <apais@microsoft.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    3 ++-
 mm/page_alloc.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-avoid-overriding-min_free_kbytes-set-by-user
+++ a/mm/khugepaged.c
@@ -2283,7 +2283,8 @@ static void set_recommended_min_free_kby
 			      (unsigned long) nr_free_buffer_pages() / 20);
 	recommended_min <<= (PAGE_SHIFT-10);
 
-	if (recommended_min > min_free_kbytes) {
+	if (recommended_min > min_free_kbytes ||
+		recommended_min > user_min_free_kbytes) {
 		if (user_min_free_kbytes >= 0)
 			pr_info("raising min_free_kbytes from %d to %lu to help transparent hugepage allocations\n",
 				min_free_kbytes, recommended_min);
--- a/mm/page_alloc.c~mm-khugepaged-avoid-overriding-min_free_kbytes-set-by-user
+++ a/mm/page_alloc.c
@@ -315,7 +315,7 @@ compound_page_dtor * const compound_page
 };
 
 int min_free_kbytes = 1024;
-int user_min_free_kbytes = -1;
+int user_min_free_kbytes = 0;
 #ifdef CONFIG_DISCONTIGMEM
 /*
  * DiscontigMem defines memory ranges as separate pg_data_t even if the ranges
_

Patches currently in -mm which might be from vijayb@linux.microsoft.com are

mm-khugepaged-recalculate-min_free_kbytes-after-memory-hotplug-as-expected-by-khugepaged.patch

