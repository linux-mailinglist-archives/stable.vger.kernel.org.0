Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB262F9024
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 03:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbhAQCLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Jan 2021 21:11:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:41566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727786AbhAQCLf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Jan 2021 21:11:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FCB222D05;
        Sun, 17 Jan 2021 02:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610849454;
        bh=LHSUh/fUQrExIhJtrdayIHHAUvh5yQ/wqLxsITVQcTI=;
        h=Date:From:To:Subject:From;
        b=k/YLJQ472cMVN+D7XDSCb8uKrm9ucbQKcXqshivc7xe5Uy7wD5NFM6p+8+m5fDW1O
         WRZrsWBz/MXGcs1VUSe+ZJiTI53V6r6ADmn8lzxuFDKeFoSr0ThymaaoA57yha/UnL
         dFN6NNQEE3eqSylusWlr864arwMoHILy22gkEPc8=
Date:   Sat, 16 Jan 2021 18:10:54 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, luoshijie1@huawei.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        urezki@gmail.com
Subject:  [merged] mm-vmallocc-fix-potential-memory-leak.patch
 removed from -mm tree
Message-ID: <20210117021054.5BTRxoFeg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: fix potential memory leak
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-fix-potential-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmalloc.c: fix potential memory leak

In VM_MAP_PUT_PAGES case, we should put pages and free array in vfree. 
But we missed to set area->nr_pages in vmap().  So we would failed to put
pages in __vunmap() because area->nr_pages = 0.

Link: https://lkml.kernel.org/r/20210107123541.39206-1-linmiaohe@huawei.com
Fixes: b944afc9d64d ("mm: add a VM_MAP_PUT_PAGES flag for vmap")
Signed-off-by: Shijie Luo <luoshijie1@huawei.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmallocc-fix-potential-memory-leak
+++ a/mm/vmalloc.c
@@ -2420,8 +2420,10 @@ void *vmap(struct page **pages, unsigned
 		return NULL;
 	}
 
-	if (flags & VM_MAP_PUT_PAGES)
+	if (flags & VM_MAP_PUT_PAGES) {
 		area->pages = pages;
+		area->nr_pages = count;
+	}
 	return area->addr;
 }
 EXPORT_SYMBOL(vmap);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch
mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked.patch

