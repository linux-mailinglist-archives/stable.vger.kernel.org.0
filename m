Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDC9541E82
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350152AbiFGWcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382057AbiFGW3A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:29:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C84274B5F;
        Tue,  7 Jun 2022 12:23:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 613D860B14;
        Tue,  7 Jun 2022 19:23:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72BADC385A2;
        Tue,  7 Jun 2022 19:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629824;
        bh=cJcaACk93XZiwSdeQhL4bIIlasHe+pa17GOztwySCbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ySKyICo/Kt3rxDR/7q/6u4r5NbisQRSwmANpuQrr26jdkzemLDG9qt/Nb/AOgfeWB
         imZrjGieUBCWyCEMVj9euQYhSLLhQcPYFAvCnrqaXUY5TSSc9Q5JQpvUWzrQ2kWiUe
         QnjUTnAdwpnBqh/xZ6ONVsOMGp6A0DHA0ksINfmA=
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
Subject: [PATCH 5.18 830/879] mm/page_alloc: always attempt to allocate at least one page during bulk allocation
Date:   Tue,  7 Jun 2022 19:05:48 +0200
Message-Id: <20220607165026.946543643@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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


