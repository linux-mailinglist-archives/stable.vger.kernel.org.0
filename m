Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE264EF9DA
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 20:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351032AbiDASap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 14:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351041AbiDASad (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 14:30:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491C81BBF42;
        Fri,  1 Apr 2022 11:28:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA19460F6B;
        Fri,  1 Apr 2022 18:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0CBC2BBE4;
        Fri,  1 Apr 2022 18:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648837723;
        bh=vYYaHwg9vpXslMSd0ZFZlQDo++62jKaYBzliYeEXWkg=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=dfHN+Fa48o8coCPjwcWVvhV6e7pROTphszxDtFB7RdfcSkQYs68OpCqkD8Geath81
         +aAlcZBgbhbah4q7rA/pSEgVUJCfff9+14WUABu/KzM7aANJJBI73oRx8r+SNISnE9
         GP/nUK8UFubmX05mE4CNWCmPLECV2TBTF3urUNB8=
Date:   Fri, 01 Apr 2022 11:28:42 -0700
To:     stable@vger.kernel.org, osalvador@suse.de, naoya.horiguchi@nec.com,
        mgorman@suse.de, linmiaohe@huawei.com, hannes@cmpxchg.org,
        riel@surriel.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220401112740.351496714b370467a92207a6@linux-foundation.org>
Subject: [patch 11/16] mm,hwpoison: unmap poisoned page before invalidation
Message-Id: <20220401182843.3C0CBC2BBE4@smtp.kernel.org>
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
