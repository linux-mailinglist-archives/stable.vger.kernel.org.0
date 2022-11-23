Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC3C635A60
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235606AbiKWKnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235971AbiKWKls (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:41:48 -0500
Received: from outbound-smtp14.blacknight.com (outbound-smtp14.blacknight.com [46.22.139.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F1585A12
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 02:25:54 -0800 (PST)
Received: from mail.blacknight.com (pemlinmail06.blacknight.ie [81.17.255.152])
        by outbound-smtp14.blacknight.com (Postfix) with ESMTPS id 519271C3B31
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 10:25:53 +0000 (GMT)
Received: (qmail 2725 invoked from network); 23 Nov 2022 10:25:53 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.198.246])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 23 Nov 2022 10:25:52 -0000
Date:   Wed, 23 Nov 2022 10:25:50 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     "Akira Naribayashi (Fujitsu)" <a.naribayashi@fujitsu.com>
Cc:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "rientjes@google.com" <rientjes@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] mm, compaction: fix fast_isolate_around() to stay within
 boundaries
Message-ID: <20221123102550.kbsd3xclsr6o27up@techsingularity.net>
References: <20221027132557.5f724149bd5753036f41512a@linux-foundation.org>
 <20221031073559.36021-1-a.naribayashi@fujitsu.com>
 <TYCPR01MB77752C15C512BB7EC952F05BE53C9@TYCPR01MB7775.jpnprd01.prod.outlook.com>
 <20221107154350.34brdl3ms2ve5wud@techsingularity.net>
 <TYCPR01MB7775D957483C895456CFE146E53E9@TYCPR01MB7775.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <TYCPR01MB7775D957483C895456CFE146E53E9@TYCPR01MB7775.jpnprd01.prod.outlook.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 09, 2022 at 05:41:12AM +0000, Akira Naribayashi (Fujitsu) wrote:
> On Mon, 7 Nov 2022 15:43:56 +0000, Mei Gorman wrote:
> > On Mon, Nov 07, 2022 at 12:32:34PM +0000, Akira Naribayashi (Fujitsu) wrote:
> > > > Under what circumstances will this panic occur?  I assume those
> > > > circumstnces are pretty rare, give that 6e2b7044c1992 was nearly two
> > > > years ago.
> > > > 
> > > > Did you consider the desirability of backporting this fix into earlier
> > > > kernels?
> > > 
> > > 
> > > Panic can occur on systems with multiple zones in a single pageblock.
> > > 
> > 
> > Please provide an example of the panic and the zoneinfo.
> 
> This issue is occurring in our customer's environment and cannot 
> be shared publicly as it contains customer information.
> Also, the panic is occurring with the kernel in RHEL and may not 
> panic with Upstream's community kernel.
> In other words, it is possible to panic on older kernels.
> I think this fix should be backported to stable kernel series.
> 
> > > The reason it is rare is that it only happens in special configurations.
> > 
> > How is this special configuration created?
> 
> This is the case when the node boundary is not aligned to pageblock boundary.

In that case, does this work to avoid rescanning an area that was already
isolated?

diff --git a/mm/compaction.c b/mm/compaction.c
index c51f7f545afe..58cf73ff20ff 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1346,7 +1346,7 @@ move_freelist_tail(struct list_head *freelist, struct page *freepage)
 static void
 fast_isolate_around(struct compact_control *cc, unsigned long pfn, unsigned long nr_isolated)
 {
-	unsigned long start_pfn, end_pfn;
+	unsigned long start_pfn, end_pfn, isolated_end;
 	struct page *page;
 
 	/* Do not search around if there are enough pages already */
@@ -1361,6 +1361,10 @@ fast_isolate_around(struct compact_control *cc, unsigned long pfn, unsigned long
 	start_pfn = max(pageblock_start_pfn(pfn), cc->zone->zone_start_pfn);
 	end_pfn = min(pageblock_end_pfn(pfn), zone_end_pfn(cc->zone));
 
+	/* Pageblock may straddle zone/node boundaries */
+	isolated_end = pfn + nr_isolated;
+	pfn = clamp(pfn, start_pfn, end_pfn);
+
 	page = pageblock_pfn_to_page(start_pfn, end_pfn, cc->zone);
 	if (!page)
 		return;
@@ -1373,7 +1377,7 @@ fast_isolate_around(struct compact_control *cc, unsigned long pfn, unsigned long
 	}
 
 	/* Scan after */
-	start_pfn = pfn + nr_isolated;
+	start_pfn = isolated_end;
 	if (start_pfn < end_pfn)
 		isolate_freepages_block(cc, &start_pfn, end_pfn, &cc->freepages, 1, false);
 
