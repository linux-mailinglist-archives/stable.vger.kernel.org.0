Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3104EF9BF
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 20:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349609AbiDASXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 14:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349738AbiDASXO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 14:23:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9AA4541A5;
        Fri,  1 Apr 2022 11:21:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AFEBB8259B;
        Fri,  1 Apr 2022 18:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFB4C340EE;
        Fri,  1 Apr 2022 18:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648837282;
        bh=vYYaHwg9vpXslMSd0ZFZlQDo++62jKaYBzliYeEXWkg=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=GozFqdhKKYkIw3R8FIKYuzDZb+VyC/g7gF8GjTzTU3JwO2TKFilRiJ/5wrHg3ZNEK
         aGvgbavKakWxT16JOePUjSEk5tzQ5IFDET9W3w1rVNesBx8cIV5wKdEDY8VR0SpcCZ
         /t2zpNaqolx1WwTy9VVfZfkAd7+rBvTx1dG6NiiY=
Date:   Fri, 01 Apr 2022 11:21:21 -0700
To:     stable@vger.kernel.org, osalvador@suse.de, naoya.horiguchi@nec.com,
        mgorman@suse.de, linmiaohe@huawei.com, hannes@cmpxchg.org,
        riel@surriel.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <l>
Subject: [patch 11/16] mm,hwpoison: unmap poisoned page before invalidation
Message-Id: <20220401182122.0AFB4C340EE@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rik van Riel <riel@surriel.com>
Subject: mm,hwpoison: unmap poisoned page before invalidation

In some cases it appears the invalidation of a hwpoisoned page fails
because the page is still mapped in another process.  This can cause a
program to be continuously restarted and die when it page faults on the
page that was not invalidated.  Avoid that problem by unmapping the
hwpoisoned page when we find it.

Another issue is that sometimes we end up oopsing in finish_fault, if the
code tries to do something with the now-NULL vmf->page.  I did not hit
this error when submitting the previous patch because there are several
opportunities for alloc_set_pte to bail out before accessing vmf->page,
and that apparently happened on those systems, and most of the time on
other systems, too.

However, across several million systems that error does occur a handful of
times a day.  It can be avoided by returning VM_FAULT_NOPAGE which will
cause do_read_fault to return before calling finish_fault.

Link: https://lkml.kernel.org/r/20220325161428.5068d97e@imladris.surriel.com
Fixes: e53ac7374e64 ("mm: invalidate hwpoison page cache page in fault path")
Signed-off-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Tested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mmhwpoison-unmap-poisoned-page-before-invalidation
+++ a/mm/memory.c
@@ -3918,14 +3918,18 @@ static vm_fault_t __do_fault(struct vm_f
 		return ret;
 
 	if (unlikely(PageHWPoison(vmf->page))) {
+		struct page *page = vmf->page;
 		vm_fault_t poisonret = VM_FAULT_HWPOISON;
 		if (ret & VM_FAULT_LOCKED) {
+			if (page_mapped(page))
+				unmap_mapping_pages(page_mapping(page),
+						    page->index, 1, false);
 			/* Retry if a clean page was removed from the cache. */
-			if (invalidate_inode_page(vmf->page))
-				poisonret = 0;
-			unlock_page(vmf->page);
+			if (invalidate_inode_page(page))
+				poisonret = VM_FAULT_NOPAGE;
+			unlock_page(page);
 		}
-		put_page(vmf->page);
+		put_page(page);
 		vmf->page = NULL;
 		return poisonret;
 	}
_
