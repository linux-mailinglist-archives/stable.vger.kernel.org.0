Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8E82EE99F
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 00:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbhAGXLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 18:11:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:50082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728736AbhAGXLH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 18:11:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C49B6235FC;
        Thu,  7 Jan 2021 23:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610061027;
        bh=9jYHLHrnCz2bEF4z1gDwVKSBxGWfpLn/Cyn7M+kAV7g=;
        h=Date:From:To:Subject:From;
        b=fbGQ9ttSqEBgcmEV6JNarsKU9UhfpnvsoM34NF9EzW2VhO/xbUiT2NZrNXUAm5xm4
         opNV1X17lgds26XG+0wDHlU/mqZsPOPZtzuCfZiTCxJ9ALfghVD9Ot0HuJOzFNO4OA
         /iwJCljb2UzlbeEljYj/66kl05XaJArXKb4s/8Sc=
Date:   Thu, 07 Jan 2021 15:10:26 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, luoshijie1@huawei.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        urezki@gmail.com
Subject:  + mm-vmallocc-fix-potential-memory-leak.patch added to
 -mm tree
Message-ID: <20210107231026.7lTC7nPXP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: fix potential memory leak
has been added to the -mm tree.  Its filename is
     mm-vmallocc-fix-potential-memory-leak.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmallocc-fix-potential-memory-leak.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmallocc-fix-potential-memory-leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-vmallocc-fix-potential-memory-leak.patch

