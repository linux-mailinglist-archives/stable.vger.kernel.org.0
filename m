Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 545D44E4896
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 22:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236327AbiCVVps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 17:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236364AbiCVVpk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 17:45:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEB15F8C4;
        Tue, 22 Mar 2022 14:44:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0B3461523;
        Tue, 22 Mar 2022 21:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F104C340EE;
        Tue, 22 Mar 2022 21:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985450;
        bh=SF8hrnVp1Izvv/ktKEWASEk7Ceno1vMJ7K7QQ6lIL2w=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=VQjs1azW94VO/FF1jDT92Agnqb3tDON5VXfStBJi6YdTiUhnVTs8OtM8pLpziPC4v
         QDFyio5XyUv4gVaW9DqIUc67HFA0ywD0XvEk2ImQF6XX7wkcjGNJwWCES+IedT6vGc
         w7kiwBdzRyrYNLzM1ULR7kgUj1HFeaPvFIzvvVP8=
Date:   Tue, 22 Mar 2022 14:44:09 -0700
To:     willy@infradead.org, stable@vger.kernel.org, osalvador@suse.de,
        naoya.horiguchi@nec.com, mgorman@suse.de, linmiaohe@huawei.com,
        jhubbard@nvidia.com, hannes@cmpxchg.org, riel@surriel.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 111/227] mm: invalidate hwpoison page cache page in fault path
Message-Id: <20220322214410.4F104C340EE@smtp.kernel.org>
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
