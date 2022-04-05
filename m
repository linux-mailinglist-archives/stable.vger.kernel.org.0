Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A58F4F2530
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbiDEHsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232429AbiDEHqe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:46:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F3293186;
        Tue,  5 Apr 2022 00:42:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A8E2B81B18;
        Tue,  5 Apr 2022 07:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E57C3410F;
        Tue,  5 Apr 2022 07:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144534;
        bh=XamnRL9+WDS32nCTYYt9TqlmML6yO8Co3rb5YczgAAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kupnPU5+wMNsHUiCa2ATzrXJLYxdoQthca9POXwnxfmHR3S/Ihl/fwDcwCjqk3Pl0
         iYG1dzlRaAZfeKMFex937zFxLvIQuXwMegzCTO8B0vOJJlLWAucdjbkSUx9Mn0PMV1
         99CqzfYfgRkjMDTQAQK7lUmQteB4ufEx/1N7UK90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rik van Riel <riel@surriel.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Oscar Salvador <osalvador@suse.de>,
        John Hubbard <jhubbard@nvidia.com>,
        Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.17 0079/1126] mm: invalidate hwpoison page cache page in fault path
Date:   Tue,  5 Apr 2022 09:13:46 +0200
Message-Id: <20220405070409.888284953@linuxfoundation.org>
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

commit e53ac7374e64dede04d745ff0e70ff5048378d1f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3893,11 +3893,16 @@ static vm_fault_t __do_fault(struct vm_f
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


