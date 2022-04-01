Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 457C34EEE33
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 15:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245191AbiDANfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 09:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240726AbiDANfn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 09:35:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5198490CD0
        for <stable@vger.kernel.org>; Fri,  1 Apr 2022 06:33:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EDBDB824C0
        for <stable@vger.kernel.org>; Fri,  1 Apr 2022 13:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FDAC340EC;
        Fri,  1 Apr 2022 13:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648820031;
        bh=CPqRVVqIpJgC/Sm9IK3F1GCyxZFP2Tqso6cT8IJJNKA=;
        h=Subject:To:Cc:From:Date:From;
        b=oWBAWB6JvKzUn+IbeFN5u17M5CesySlFxV99OlTj6yB00ofNQfMJeXIFWJHWRNIG0
         41Q1lKxz697ceQ1pc37imXhgx13/v/s5wxteIr+ChW8CQHbzreWJEw4/mSBn5XV/s8
         F1PdgpTM1Kdtv8cU7eO/mI3sV8qymeo+lDYKAnQM=
Subject: FAILED: patch "[PATCH] mm: invalidate hwpoison page cache page in fault path" failed to apply to 4.14-stable tree
To:     riel@surriel.com, akpm@linux-foundation.org, hannes@cmpxchg.org,
        jhubbard@nvidia.com, linmiaohe@huawei.com, mgorman@suse.de,
        naoya.horiguchi@nec.com, osalvador@suse.de, stable@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 01 Apr 2022 15:33:48 +0200
Message-ID: <164882002824865@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e53ac7374e64dede04d745ff0e70ff5048378d1f Mon Sep 17 00:00:00 2001
From: Rik van Riel <riel@surriel.com>
Date: Tue, 22 Mar 2022 14:44:09 -0700
Subject: [PATCH] mm: invalidate hwpoison page cache page in fault path

Sometimes the page offlining code can leave behind a hwpoisoned clean
page cache page.  This can lead to programs being killed over and over
and over again as they fault in the hwpoisoned page, get killed, and
then get re-spawned by whatever wanted to run them.

This is particularly embarrassing when the page was offlined due to
having too many corrected memory errors.  Now we are killing tasks due
to them trying to access memory that probably isn't even corrupted.

This problem can be avoided by invalidating the page from the page fault
handler, which already has a branch for dealing with these kinds of
pages.  With this patch we simply pretend the page fault was successful
if the page was invalidated, return to userspace, incur another page
fault, read in the file from disk (to a new memory page), and then
everything works again.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/memory.c b/mm/memory.c
index c96281458c83..1a55b4c5b5db 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3877,11 +3877,16 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
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

