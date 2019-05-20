Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA2323639
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388910AbfETM20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:28:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389259AbfETM20 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:28:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D7A720645;
        Mon, 20 May 2019 12:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355305;
        bh=uKf8X+8LHCkX9dXwrACYWKfiDIHiFDti+WnPu1krtj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XE0BqvPkr/xVTiTi2gJ0mpCEOoUlsf/MBsuTcasjDtisb/CJAdW1iqw4LTeTj4B3j
         36oO3nVjp9XJo3I3mptgsJ2xB4Ahcoax8RSbwaZfyriGFHkCpFOX6prWtvUthIOUi3
         0Mohxe3oDdipNrKSqH6jkTv+FxJbYNjOzx/Sh8ko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kai Shen <shenkai8@huawei.com>,
        Feilong Lin <linfeilong@huawei.com>,
        Wang Wang <wangwang2@huawei.com>,
        Oscar Salvador <osalvador@suse.de>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.0 069/123] mm/hugetlb.c: dont put_page in lock of hugetlb_lock
Date:   Mon, 20 May 2019 14:14:09 +0200
Message-Id: <20190520115249.429414891@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Shen <shenkai8@huawei.com>

commit 2bf753e64b4a702e27ce26ff520c59563c62f96b upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/hugetlb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1573,8 +1573,9 @@ static struct page *alloc_surplus_huge_p
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


