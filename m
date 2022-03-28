Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E74074EA180
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 22:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345800AbiC1Ua2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 16:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345811AbiC1Ua0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 16:30:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B287414085;
        Mon, 28 Mar 2022 13:28:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6457C60ED9;
        Mon, 28 Mar 2022 20:28:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B296FC340ED;
        Mon, 28 Mar 2022 20:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648499321;
        bh=SNWUr/AycHWkjdXz/AGkNvmnUQgBzSkJ+3Rend7O/Rw=;
        h=Date:To:From:Subject:From;
        b=Q70OX5Zo6Din9jQEAQx1j3CGq5nyEUoHWBqPpceSeEZbENBcuJxSN7uR2Ob+vPe5T
         4KWgFmkFzZwdyl7T87JdJCUgZ8xMFnpXOgAQBXOrlNtcrWQllWjoO9zgj2n6M5V15u
         b71PW1y1a1RuExg0SoPZ4jk35NhT8nXBKq9hB85Q=
Date:   Mon, 28 Mar 2022 13:28:41 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        osalvador@suse.de, naoya.horiguchi@nec.com, mgorman@suse.de,
        linmiaohe@huawei.com, hannes@cmpxchg.org, riel@surriel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmhwpoison-unmap-poisoned-page-before-invalidation.patch added to -mm tree
Message-Id: <20220328202841.B296FC340ED@smtp.kernel.org>
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
     Subject: mm,hwpoison: unmap poisoned page before invalidation
has been added to the -mm tree.  Its filename is
     mmhwpoison-unmap-poisoned-page-before-invalidation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-unmap-poisoned-page-before-invalidation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-unmap-poisoned-page-before-invalidation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Tested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
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

Patches currently in -mm which might be from riel@surriel.com are

mmhwpoison-unmap-poisoned-page-before-invalidation.patch

