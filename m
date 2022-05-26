Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA8053531A
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 20:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239771AbiEZSFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 14:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiEZSF3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 14:05:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE875A76E7;
        Thu, 26 May 2022 11:05:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81F5BB82053;
        Thu, 26 May 2022 18:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275A9C34116;
        Thu, 26 May 2022 18:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653588324;
        bh=+NJb8Kdj3a3U/ZXqNggQ5xmvnrIEU1xTrnczpeU/xR8=;
        h=Date:To:From:Subject:From;
        b=dq8GdGiek9yraxzfwK2b44u+Mk+SwJ2bSPExqTvT7zu61SUsAgrBPe/hnT3UStiQY
         o8s32SQ9NUAm2N0aODgO4pPtW/rvWiPZJzzd/8wGmCGsDWaKZapaNeQGn5NPox+HLy
         bhX4DC/VvxYe/vez5srRH/D2SBRVln+PuCPNN5tU=
Date:   Thu, 26 May 2022 11:05:23 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org,
        jack@suse.cz, djwong@kernel.org, dchinner@redhat.com,
        chuck.lever@oracle.com, brouer@redhat.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-always-attempt-to-allocate-at-least-one-page-during-bulk-allocation.patch added to mm-hotfixes-unstable branch
Message-Id: <20220526180524.275A9C34116@smtp.kernel.org>
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
     Subject: mm/page_alloc: always attempt to allocate at least one page during bulk allocation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-always-attempt-to-allocate-at-least-one-page-during-bulk-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-always-attempt-to-allocate-at-least-one-page-during-bulk-allocation.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: always attempt to allocate at least one page during bulk allocation
Date: Thu, 26 May 2022 10:12:10 +0100

Peter Pavlisko reported the following problem on kernel bugzilla 216007.

	When I try to extract an uncompressed tar archive (2.6 milion
	files, 760.3 GiB in size) on newly created (empty) XFS file system,
	after first low tens of gigabytes extracted the process hangs in
	iowait indefinitely. One CPU core is 100% occupied with iowait,
	the other CPU core is idle (on 2-core Intel Celeron G1610T).

It was bisected to c9fa563072e1 ("xfs: use alloc_pages_bulk_array() for
buffers") but XFS is only the messenger.  The problem is that nothing is
waking kswapd to reclaim some pages at a time the PCP lists cannot be
refilled until some reclaim happens.  The bulk allocator checks that there
are some pages in the array and the original intent was that a bulk
allocator did not necessarily need all the requested pages and it was best
to return as quickly as possible.

This was fine for the first user of the API but both NFS and XFS require
the requested number of pages be available before making progress.  Both
could be adjusted to call the page allocator directly if a bulk allocation
fails but it puts a burden on users of the API.  Adjust the semantics to
attempt at least one allocation via __alloc_pages() before returning so
kswapd is woken if necessary.

It was reported via bugzilla that the patch addressed the problem and that
the tar extraction completed successfully.  This may also address bug
215975 but has yet to be confirmed.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=216007
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=215975
Link: https://lkml.kernel.org/r/20220526091210.GC3441@techsingularity.net
Fixes: 387ba26fb1cb ("mm/page_alloc: add a bulk page allocator")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: <stable@vger.kernel.org> # v5.13+
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-always-attempt-to-allocate-at-least-one-page-during-bulk-allocation
+++ a/mm/page_alloc.c
@@ -5324,8 +5324,8 @@ unsigned long __alloc_pages_bulk(gfp_t g
 		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
 								pcp, pcp_list);
 		if (unlikely(!page)) {
-			/* Try and get at least one page */
-			if (!nr_populated)
+			/* Try and allocate at least one page */
+			if (!nr_account)
 				goto failed_irq;
 			break;
 		}
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-always-attempt-to-allocate-at-least-one-page-during-bulk-allocation.patch
mm-page_alloc-add-page-buddy_list-and-page-pcp_list.patch
mm-page_alloc-use-only-one-pcp-list-for-thp-sized-allocations.patch
mm-page_alloc-split-out-buddy-removal-code-from-rmqueue-into-separate-helper.patch
mm-page_alloc-protect-pcp-lists-with-a-spinlock.patch

