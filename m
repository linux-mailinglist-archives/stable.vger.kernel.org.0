Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9F758696E
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbiHAMCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232696AbiHAL7w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:59:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991E741D3D;
        Mon,  1 Aug 2022 04:52:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E471B8116E;
        Mon,  1 Aug 2022 11:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F68BC433D7;
        Mon,  1 Aug 2022 11:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354767;
        bh=JvWgRStxtVIyShSCT19Zvnr6RM+mzrdL8AWi8sSfTGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sszTVa6ujlwSXztm4U3JYew/pRYMXUKGrmgrGMdURWeE/A2tdUr7wc8hc7DxQU/6a
         1e1xJ1JhdgKaRcsAPbpVv8J+AoLebjKNCmkxwcUwYNqR6djW78tJkTJEaWP9yMbZs8
         y1RDBB/4oILnBclcjuzEkyVOfeMj6hmedEm06kIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Rik van Riel <riel@surriel.com>, Chris Mason <clm@fb.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 06/69] mm: fix page leak with multiple threads mapping the same page
Date:   Mon,  1 Aug 2022 13:46:30 +0200
Message-Id: <20220801114134.726736393@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
References: <20220801114134.468284027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 3fe2895cfecd03ac74977f32102b966b6589f481 upstream.

We have an application with a lot of threads that use a shared mmap backed
by tmpfs mounted with -o huge=within_size.  This application started
leaking loads of huge pages when we upgraded to a recent kernel.

Using the page ref tracepoints and a BPF program written by Tejun Heo we
were able to determine that these pages would have multiple refcounts from
the page fault path, but when it came to unmap time we wouldn't drop the
number of refs we had added from the faults.

I wrote a reproducer that mmap'ed a file backed by tmpfs with -o
huge=always, and then spawned 20 threads all looping faulting random
offsets in this map, while using madvise(MADV_DONTNEED) randomly for huge
page aligned ranges.  This very quickly reproduced the problem.

The problem here is that we check for the case that we have multiple
threads faulting in a range that was previously unmapped.  One thread maps
the PMD, the other thread loses the race and then returns 0.  However at
this point we already have the page, and we are no longer putting this
page into the processes address space, and so we leak the page.  We
actually did the correct thing prior to f9ce0be71d1f, however it looks
like Kirill copied what we do in the anonymous page case.  In the
anonymous page case we don't yet have a page, so we don't have to drop a
reference on anything.  Previously we did the correct thing for file based
faults by returning VM_FAULT_NOPAGE so we correctly drop the reference on
the page we faulted in.

Fix this by returning VM_FAULT_NOPAGE in the pmd_devmap_trans_unstable()
case, this makes us drop the ref on the page properly, and now my
reproducer no longer leaks the huge pages.

[josef@toxicpanda.com: v2]
  Link: https://lkml.kernel.org/r/e90c8f0dbae836632b669c2afc434006a00d4a67.1657721478.git.josef@toxicpanda.com
Link: https://lkml.kernel.org/r/2b798acfd95c9ab9395fe85e8d5a835e2e10a920.1657051137.git.josef@toxicpanda.com
Fixes: f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault() codepaths")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Chris Mason <clm@fb.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4071,9 +4071,12 @@ vm_fault_t finish_fault(struct vm_fault
 		}
 	}
 
-	/* See comment in handle_pte_fault() */
+	/*
+	 * See comment in handle_pte_fault() for how this scenario happens, we
+	 * need to return NOPAGE so that we drop this page.
+	 */
 	if (pmd_devmap_trans_unstable(vmf->pmd))
-		return 0;
+		return VM_FAULT_NOPAGE;
 
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
 				      vmf->address, &vmf->ptl);


