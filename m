Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB3714E6C03
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 02:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238490AbiCYBdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 21:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357536AbiCYBdP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 21:33:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EE23DA66;
        Thu, 24 Mar 2022 18:31:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01B3B6192B;
        Fri, 25 Mar 2022 01:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C00DC340EC;
        Fri, 25 Mar 2022 01:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171898;
        bh=ZL4XEj4JbbLdiABvHGiuyGGg6GB+Xddaz2jksCfzH5E=;
        h=Date:To:From:Subject:From;
        b=BJhF01uFN2LlvQrSMAMWU71D4GDlme3WUKj4Yrdvcku43rQNwJqudYfgiwvxmxIfl
         CwgXI1Ni13bQyKIm9l/DkwHm4z6sC8eICHkYIqFUm8w5qPEPOvUSoZstkhlTT5RK3w
         F1FOkbPPefiqYi4UjLcQfBBGCY6ostd5Bmocu1kI=
Date:   Thu, 24 Mar 2022 18:31:37 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, osalvador@suse.de, naoya.horiguchi@nec.com,
        mgorman@suse.de, linmiaohe@huawei.com, jhubbard@nvidia.com,
        hannes@cmpxchg.org, riel@surriel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-clean-up-hwpoison-page-cache-page-in-fault-path.patch removed from -mm tree
Message-Id: <20220325013138.5C00DC340EC@smtp.kernel.org>
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
     Subject: mm: invalidate hwpoison page cache page in fault path
has been removed from the -mm tree.  Its filename was
     mm-clean-up-hwpoison-page-cache-page-in-fault-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rik van Riel <riel@surriel.com>
Subject: mm: invalidate hwpoison page cache page in fault path

Sometimes the page offlining code can leave behind a hwpoisoned clean page
cache page.  This can lead to programs being killed over and over and over
again as they fault in the hwpoisoned page, get killed, and then get
re-spawned by whatever wanted to run them.

This is particularly embarrassing when the page was offlined due to having
too many corrected memory errors.  Now we are killing tasks due to them
trying to access memory that probably isn't even corrupted.

This problem can be avoided by invalidating the page from the page fault
handler, which already has a branch for dealing with these kinds of pages.
With this patch we simply pretend the page fault was successful if the
page was invalidated, return to userspace, incur another page fault, read
in the file from disk (to a new memory page), and then everything works
again.

Link: https://lkml.kernel.org/r/20220212213740.423efcea@imladris.surriel.com
Signed-off-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-clean-up-hwpoison-page-cache-page-in-fault-path
+++ a/mm/memory.c
@@ -3877,11 +3877,16 @@ static vm_fault_t __do_fault(struct vm_f
 		return ret;
 
 	if (unlikely(PageHWPoison(vmf->page))) {
-		if (ret & VM_FAULT_LOCKED)
+		vm_fault_t poisonret = VM_FAULT_HWPOISON;
+		if (ret & VM_FAULT_LOCKED) {
+			/* Retry if a clean page was removed from the cache. */
+			if (invalidate_inode_page(vmf->page))
+				poisonret = 0;
 			unlock_page(vmf->page);
+		}
 		put_page(vmf->page);
 		vmf->page = NULL;
-		return VM_FAULT_HWPOISON;
+		return poisonret;
 	}
 
 	if (unlikely(!(ret & VM_FAULT_LOCKED)))
_

Patches currently in -mm which might be from riel@surriel.com are


