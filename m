Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E69FA19576
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 00:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfEIWy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 18:54:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbfEIWy5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 18:54:57 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01D3C2182B;
        Thu,  9 May 2019 22:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557442496;
        bh=PI9D7tEDOSDMcgBY7udVmhJ9UiBtDAFFDeXNDwMn6Xc=;
        h=Date:From:To:Subject:From;
        b=dwIn0dUeDuLPppteK9pmIcqzD4KwVSEg30ROpZZOIq+CHK2vYla9Kky8wTrRZU3OC
         5eolPoI8ldkhRaw0LmuACOKrLGSzmVEfEkjF3wp6Z3UdSUityonDEE6QXb0ewd2F67
         J/rdt4JLkwysBtPHSvYYcufI1ZVl7tUAX6F8srzo=
Date:   Thu, 09 May 2019 15:54:55 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, linfeilong@huawei.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, shenkai8@huawei.com, stable@vger.kernel.org,
        wangwang2@huawei.com
Subject:  + mm-hugetlb-dont-put_page-in-lock-of-hugetlb_lock.patch
 added to -mm tree
Message-ID: <20190509225455.7CBPIwsHY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: don't put_page in lock of hugetlb_lock
has been added to the -mm tree.  Its filename is
     mm-hugetlb-dont-put_page-in-lock-of-hugetlb_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-dont-put_page-in-lock-of-hugetlb_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-dont-put_page-in-lock-of-hugetlb_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kai Shen <shenkai8@huawei.com>
Subject: mm/hugetlb.c: don't put_page in lock of hugetlb_lock

spinlock recursion happened when do LTP test:
#!/bin/bash
./runltp -p -f hugetlb &
./runltp -p -f hugetlb &
./runltp -p -f hugetlb &
./runltp -p -f hugetlb &
./runltp -p -f hugetlb &

The dtor returned by get_compound_page_dtor in __put_compound_page may be
the function of free_huge_page which will lock the hugetlb_lock, so don't
put_page in lock of hugetlb_lock.

 BUG: spinlock recursion on CPU#0, hugemmap05/1079
  lock: hugetlb_lock+0x0/0x18, .magic: dead4ead, .owner: hugemmap05/1079, .owner_cpu: 0
 Call trace:
  dump_backtrace+0x0/0x198
  show_stack+0x24/0x30
  dump_stack+0xa4/0xcc
  spin_dump+0x84/0xa8
  do_raw_spin_lock+0xd0/0x108
  _raw_spin_lock+0x20/0x30
  free_huge_page+0x9c/0x260
  __put_compound_page+0x44/0x50
  __put_page+0x2c/0x60
  alloc_surplus_huge_page.constprop.19+0xf0/0x140
  hugetlb_acct_memory+0x104/0x378
  hugetlb_reserve_pages+0xe0/0x250
  hugetlbfs_file_mmap+0xc0/0x140
  mmap_region+0x3e8/0x5b0
  do_mmap+0x280/0x460
  vm_mmap_pgoff+0xf4/0x128
  ksys_mmap_pgoff+0xb4/0x258
  __arm64_sys_mmap+0x34/0x48
  el0_svc_common+0x78/0x130
  el0_svc_handler+0x38/0x78
  el0_svc+0x8/0xc

Link: http://lkml.kernel.org/r/b8ade452-2d6b-0372-32c2-703644032b47@huawei.com
Fixes: 9980d744a0 ("mm, hugetlb: get rid of surplus page accounting tricks")
Signed-off-by: Kai Shen <shenkai8@huawei.com>
Signed-off-by: Feilong Lin <linfeilong@huawei.com>
Reported-by: Wang Wang <wangwang2@huawei.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-dont-put_page-in-lock-of-hugetlb_lock
+++ a/mm/hugetlb.c
@@ -1574,8 +1574,9 @@ static struct page *alloc_surplus_huge_p
 	 */
 	if (h->surplus_huge_pages >= h->nr_overcommit_huge_pages) {
 		SetPageHugeTemporary(page);
+		spin_unlock(&hugetlb_lock);
 		put_page(page);
-		page = NULL;
+		return NULL;
 	} else {
 		h->surplus_huge_pages++;
 		h->surplus_huge_pages_node[page_to_nid(page)]++;
_

Patches currently in -mm which might be from shenkai8@huawei.com are

mm-hugetlb-dont-put_page-in-lock-of-hugetlb_lock.patch

