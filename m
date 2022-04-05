Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678234F25AD
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbiDEHvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbiDEHrY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:47:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5198E972E5;
        Tue,  5 Apr 2022 00:43:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE661616C4;
        Tue,  5 Apr 2022 07:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D82C340EE;
        Tue,  5 Apr 2022 07:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144612;
        bh=cvKdZ6StMfm6zRKMs64+nsuqFYWwxL633CUZBelPVRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VLw2pkbEcUmqxE77Vdnh9AKrVmhFReFgcdU6n3/wwlXI09uCK8WutkEWPAUZcFrQJ
         942pSCMLALOXF2lSTJ51CfQTa5h2C5UPZo6ihVRiTYbOTUqRMHr9rg6AnEhZ3WR59C
         OvdF31FjWBXvUzy0FDhVIFr6VVgdcT+NAxZ11vsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rik van Riel <riel@surriel.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Oscar Salvador <osalvador@suse.de>,
        Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.17 0108/1126] mm,hwpoison: unmap poisoned page before invalidation
Date:   Tue,  5 Apr 2022 09:14:15 +0200
Message-Id: <20220405070410.740756156@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Rik van Riel <riel@surriel.com>

commit 3149c79f3cb0e2e3bafb7cfadacec090cbd250d3 upstream.

In some cases it appears the invalidation of a hwpoisoned page fails
because the page is still mapped in another process.  This can cause a
program to be continuously restarted and die when it page faults on the
page that was not invalidated.  Avoid that problem by unmapping the
hwpoisoned page when we find it.

Another issue is that sometimes we end up oopsing in finish_fault, if
the code tries to do something with the now-NULL vmf->page.  I did not
hit this error when submitting the previous patch because there are
several opportunities for alloc_set_pte to bail out before accessing
vmf->page, and that apparently happened on those systems, and most of
the time on other systems, too.

However, across several million systems that error does occur a handful
of times a day.  It can be avoided by returning VM_FAULT_NOPAGE which
will cause do_read_fault to return before calling finish_fault.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3893,14 +3893,18 @@ static vm_fault_t __do_fault(struct vm_f
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


