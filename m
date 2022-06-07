Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38DFC54101D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351397AbiFGTSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355482AbiFGTQC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:16:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A533196A9F;
        Tue,  7 Jun 2022 11:07:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC3EFB82349;
        Tue,  7 Jun 2022 18:07:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65F4C385A5;
        Tue,  7 Jun 2022 18:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625250;
        bh=NC3/9I5CrW1I+k0hMZefr0X4gn8kFk31fzUXfvgDPhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zCk0Vh9R7yamtX87PYSauQ2MmPvuUB0tR7uAy7LWkFY4lOJjBh7yIlUq9t8u5bcty
         pw/0YkYwj0dLhU8zWhTWyiC2qgj+34U4pUeWnh0Br5KrPKFIgCVnmM1qRqwAC0OllU
         wE9sjEoSt9lf2gkvsi2uO2vE2P7rhf4pmQheAYK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>, Jan Kara <jack@suse.cz>,
        Vlastimil Babka <vbabka@suse.cz>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 620/667] mm/page_alloc: always attempt to allocate at least one page during bulk allocation
Date:   Tue,  7 Jun 2022 19:04:45 +0200
Message-Id: <20220607164953.265458711@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>

commit c572e4888ad1be123c1516ec577ad30a700bbec4 upstream.

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
Cc: <stable@vger.kernel.org>	[5.13+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5299,8 +5299,8 @@ unsigned long __alloc_pages_bulk(gfp_t g
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


