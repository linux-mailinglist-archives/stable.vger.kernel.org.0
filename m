Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4854BE8F4
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241584AbiBUJlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:41:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349320AbiBUJkH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:40:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9673BFA3;
        Mon, 21 Feb 2022 01:17:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C06C060F04;
        Mon, 21 Feb 2022 09:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6070C340EB;
        Mon, 21 Feb 2022 09:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435027;
        bh=jpZH6xrh9hccXtiZXWyWHqnt+rfjkT9gFkXP6XsvMPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EagVCQNwmWmN/WKIgAsDFiPmCJybQ9RJY4f6hOO7SSUO3Lm+Ti+DotrJwlxyNjD7S
         CFDy3T105/DxpgiEBBWajk+TkWVAr3Xha0tHhhgAIVXVLWSKoLslPUjMoI3KocQP6x
         jBzlZl1n9/sggH1EkdWg+k3c9lQkUQ2/Ul+eAd1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oded Gabbay <oded.gabbay@gmail.com>
Subject: [PATCH 5.16 019/227] mm: dont try to NUMA-migrate COW pages that have other uses
Date:   Mon, 21 Feb 2022 09:47:18 +0100
Message-Id: <20220221084935.476424505@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 80d47f5de5e311cbc0d01ebb6ee684e8f4c196c6 upstream.

Oded Gabbay reports that enabling NUMA balancing causes corruption with
his Gaudi accelerator test load:

 "All the details are in the bug, but the bottom line is that somehow,
  this patch causes corruption when the numa balancing feature is
  enabled AND we don't use process affinity AND we use GUP to pin pages
  so our accelerator can DMA to/from system memory.

  Either disabling numa balancing, using process affinity to bind to
  specific numa-node or reverting this patch causes the bug to
  disappear"

and Oded bisected the issue to commit 09854ba94c6a ("mm: do_wp_page()
simplification").

Now, the NUMA balancing shouldn't actually be changing the writability
of a page, and as such shouldn't matter for COW.  But it appears it
does.  Suspicious.

However, regardless of that, the condition for enabling NUMA faults in
change_pte_range() is nonsensical.  It uses "page_mapcount(page)" to
decide if a COW page should be NUMA-protected or not, and that makes
absolutely no sense.

The number of mappings a page has is irrelevant: not only does GUP get a
reference to a page as in Oded's case, but the other mappings migth be
paged out and the only reference to them would be in the page count.

Since we should never try to NUMA-balance a page that we can't move
anyway due to other references, just fix the code to use 'page_count()'.
Oded confirms that that fixes his issue.

Now, this does imply that something in NUMA balancing ends up changing
page protections (other than the obvious one of making the page
inaccessible to get the NUMA faulting information).  Otherwise the COW
simplification wouldn't matter - since doing the GUP on the page would
make sure it's writable.

The cause of that permission change would be good to figure out too,
since it clearly results in spurious COW events - but fixing the
nonsensical test that just happened to work before is obviously the
CorrectThing(tm) to do regardless.

Fixes: 09854ba94c6a ("mm: do_wp_page() simplification")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215616
Link: https://lore.kernel.org/all/CAFCwf10eNmwq2wD71xjUhqkvv5+_pJMR1nPug2RqNDcFT4H86Q@mail.gmail.com/
Reported-and-tested-by: Oded Gabbay <oded.gabbay@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mprotect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -94,7 +94,7 @@ static unsigned long change_pte_range(st
 
 				/* Also skip shared copy-on-write pages */
 				if (is_cow_mapping(vma->vm_flags) &&
-				    page_mapcount(page) != 1)
+				    page_count(page) != 1)
 					continue;
 
 				/*


