Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C742F59A7A2
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 23:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352408AbiHSVYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 17:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352401AbiHSVYD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 17:24:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1E35754D;
        Fri, 19 Aug 2022 14:24:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA6E7B8291D;
        Fri, 19 Aug 2022 21:24:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D8BC433D6;
        Fri, 19 Aug 2022 21:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660944239;
        bh=RGCq+yclmqz/4K4fKBxGLV3MGUpC7HXWYy6B5tp8OhE=;
        h=Date:To:From:Subject:From;
        b=pGU1uX3VF9tgqVx2ApVkZclMm1hSraNgI3ryo19XTPQfOjh2yVnIZGe5Iqpk+WE7x
         VSr7UHJ7M9biPmHxziaUsloRxus8FkYd9QNUthFVgFZsyZvY70D80prBk92qXG2mrd
         O1QgE3Z7EsZ76hSGo6yR9P6tN/ntc53GonvQEYrs=
Date:   Fri, 19 Aug 2022 14:23:58 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, songmuchun@bytedance.com,
        osalvador@suse.de, mike.kravetz@oracle.com, liushixin2@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + bootmem-remove-the-vmemmap-pages-from-kmemleak-in-put_page_bootmem.patch added to mm-hotfixes-unstable branch
Message-Id: <20220819212359.84D8BC433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: bootmem: remove the vmemmap pages from kmemleak in put_page_bootmem
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     bootmem-remove-the-vmemmap-pages-from-kmemleak-in-put_page_bootmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bootmem-remove-the-vmemmap-pages-from-kmemleak-in-put_page_bootmem.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: bootmem: remove the vmemmap pages from kmemleak in put_page_bootmem
Date: Fri, 19 Aug 2022 17:40:05 +0800

The vmemmap pages is marked by kmemleak when allocated from memblock. 
Remove it from kmemleak when freeing the page.  Otherwise, when we reuse
the page, kmemleak may report such an error and then stop working.

 kmemleak: Cannot insert 0xffff98fb6eab3d40 into the object search tree (overlaps existing)
 kmemleak: Kernel memory leak detector disabled
 kmemleak: Object 0xffff98fb6be00000 (size 335544320):
 kmemleak:   comm "swapper", pid 0, jiffies 4294892296
 kmemleak:   min_count = 0
 kmemleak:   count = 0
 kmemleak:   flags = 0x1
 kmemleak:   checksum = 0
 kmemleak:   backtrace:

Link: https://lkml.kernel.org/r/20220819094005.2928241-1-liushixin2@huawei.com
Fixes: f41f2ed43ca5 (mm: hugetlb: free the vmemmap pages associated with each HugeTLB page)
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem_info.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/bootmem_info.c~bootmem-remove-the-vmemmap-pages-from-kmemleak-in-put_page_bootmem
+++ a/mm/bootmem_info.c
@@ -12,6 +12,7 @@
 #include <linux/memblock.h>
 #include <linux/bootmem_info.h>
 #include <linux/memory_hotplug.h>
+#include <linux/kmemleak.h>
 
 void get_page_bootmem(unsigned long info, struct page *page, unsigned long type)
 {
@@ -33,6 +34,7 @@ void put_page_bootmem(struct page *page)
 		ClearPagePrivate(page);
 		set_page_private(page, 0);
 		INIT_LIST_HEAD(&page->lru);
+		kmemleak_free_part(page_to_virt(page), PAGE_SIZE);
 		free_reserved_page(page);
 	}
 }
_

Patches currently in -mm which might be from liushixin2@huawei.com are

bootmem-remove-the-vmemmap-pages-from-kmemleak-in-free_bootmem_page.patch
bootmem-remove-the-vmemmap-pages-from-kmemleak-in-put_page_bootmem.patch

