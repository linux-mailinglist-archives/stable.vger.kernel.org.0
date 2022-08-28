Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00B9A5A3FC9
	for <lists+stable@lfdr.de>; Sun, 28 Aug 2022 23:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiH1VDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Aug 2022 17:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiH1VDh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Aug 2022 17:03:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA5F31216;
        Sun, 28 Aug 2022 14:03:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F23360E96;
        Sun, 28 Aug 2022 21:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43B9C433C1;
        Sun, 28 Aug 2022 21:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661720612;
        bh=nXh/K/2atXdubHzwfBz3VNLYBd2mtDjcq59xpw7h/mw=;
        h=Date:To:From:Subject:From;
        b=uUUMR4D9K3OaQVclhB6gUFC2mVLAe97WLeWwXY5sRaXXBBWxBqCNgzaJD6dz0sNbE
         JzBRoSd3n7Bj6pTMbC270KSLJ1jkUG141TbcdFCSrvbVeVJgtwZ94LZk+vXqgm27o7
         a31ewxjGZttn/0TUwmL3+VQtWhsnpXE14R3PTk+4=
Date:   Sun, 28 Aug 2022 14:03:31 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, songmuchun@bytedance.com,
        osalvador@suse.de, mike.kravetz@oracle.com, liushixin2@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] bootmem-remove-the-vmemmap-pages-from-kmemleak-in-put_page_bootmem.patch removed from -mm tree
Message-Id: <20220828210332.A43B9C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: bootmem: remove the vmemmap pages from kmemleak in put_page_bootmem
has been removed from the -mm tree.  Its filename was
     bootmem-remove-the-vmemmap-pages-from-kmemleak-in-put_page_bootmem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

frontswap-skip-frontswap_ops-init-if-zswap-init-failed.patch
frontswap-invoke-ops-init-for-online-swap-device-in-frontswap_register_ops.patch
mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state.patch
mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement.patch
mm-zswap-skip-confusing-print-info.patch

