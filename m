Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6063F2F40BF
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 01:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392221AbhAMAnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 19:43:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:46076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391945AbhALXuB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 18:50:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EE3D23136;
        Tue, 12 Jan 2021 23:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610495358;
        bh=Fyfc3St6XcETCyfxluudtDudj6bhhgxSuzF95j2USdc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=aokZhffsiHHbXlNGDfx4+YHl54EUfd5rsVedet7FuCJ5HSJ8fpcLzkDxa2ohR+iaE
         TWkG7gEcBaoFNOtJeSGNKgK2s4qlmXhT8kViDNC4RIyRPM9aEJ3wV3dyHF/lpeJIO4
         Y68S7c+ZiI+shG+PeQWjwH4QZVSphrbGtlhS662E=
Date:   Tue, 12 Jan 2021 15:49:18 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, luoshijie1@huawei.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, urezki@gmail.com
Subject:  [patch 05/10] mm/vmalloc.c: fix potential memory leak
Message-ID: <20210112234918.AY5LtPz7k%akpm@linux-foundation.org>
In-Reply-To: <20210112154839.abeb6e57de79480059fd9b0e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
