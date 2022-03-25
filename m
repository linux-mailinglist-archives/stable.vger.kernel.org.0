Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25CAD4E7B96
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 01:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbiCYU0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 16:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbiCYU0p (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 16:26:45 -0400
X-Greylist: delayed 633 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 25 Mar 2022 13:25:11 PDT
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477176EB1E;
        Fri, 25 Mar 2022 13:25:10 -0700 (PDT)
Received: from [2603:3005:d05:2b00:6e0b:84ff:fee2:98bb] (helo=imladris.surriel.com)
        by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <riel@shelob.surriel.com>)
        id 1nXqKL-0000sb-7e; Fri, 25 Mar 2022 16:14:29 -0400
Date:   Fri, 25 Mar 2022 16:14:28 -0400
From:   Rik van Riel <riel@surriel.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, kernel-team@fb.com,
        Oscar Salvador <osalvador@suse.de>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [PATCH] mm,hwpoison: unmap poisoned page before invalidation
Message-ID: <20220325161428.5068d97e@imladris.surriel.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: riel@shelob.surriel.com
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In some cases it appears the invalidation of a hwpoisoned page
fails because the page is still mapped in another process. This
can cause a program to be continuously restarted and die when
it page faults on the page that was not invalidated. Avoid that
problem by unmapping the hwpoisoned page when we find it.

Another issue is that sometimes we end up oopsing in finish_fault,
if the code tries to do something with the now-NULL vmf->page.
I did not hit this error when submitting the previous patch because
there are several opportunities for alloc_set_pte to bail out before
accessing vmf->page, and that apparently happened on those systems,
and most of the time on other systems, too.

However, across several million systems that error does occur a
handful of times a day. It can be avoided by returning VM_FAULT_NOPAGE
which will cause do_read_fault to return before calling finish_fault.

Fixes: e53ac7374e64 ("mm: invalidate hwpoison page cache page in fault path")
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
---
 mm/memory.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index be44d0b36b18..76e3af9639d9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3918,14 +3918,18 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
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
-- 
2.35.1


