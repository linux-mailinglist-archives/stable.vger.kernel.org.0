Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1976195A8
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 12:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbiKDLwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 07:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbiKDLwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 07:52:37 -0400
X-Greylist: delayed 391 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 04 Nov 2022 04:52:33 PDT
Received: from outbound-smtp35.blacknight.com (outbound-smtp35.blacknight.com [46.22.139.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0F02CE1B
        for <stable@vger.kernel.org>; Fri,  4 Nov 2022 04:52:33 -0700 (PDT)
Received: from mail.blacknight.com (pemlinmail04.blacknight.ie [81.17.254.17])
        by outbound-smtp35.blacknight.com (Postfix) with ESMTPS id CAF8A1F5D
        for <stable@vger.kernel.org>; Fri,  4 Nov 2022 11:46:00 +0000 (GMT)
Received: (qmail 3010 invoked from network); 4 Nov 2022 11:46:00 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.198.246])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 4 Nov 2022 11:46:00 -0000
Date:   Fri, 4 Nov 2022 11:45:59 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     NARIBAYASHI Akira <a.naribayashi@fujitsu.com>, vbabka@suse.cz,
        rientjes@google.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm, compaction: fix fast_isolate_around() to stay within
 boundaries
Message-ID: <20221104114559.k3gwykhqgfaxv7yf@techsingularity.net>
References: <20221026112438.236336-1-a.naribayashi@fujitsu.com>
 <20221027132557.5f724149bd5753036f41512a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20221027132557.5f724149bd5753036f41512a@linux-foundation.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 01:25:57PM -0700, Andrew Morton wrote:
> On Wed, 26 Oct 2022 20:24:38 +0900 NARIBAYASHI Akira <a.naribayashi@fujitsu.com> wrote:
> 
> > Depending on the memory configuration, isolate_freepages_block() may
> > scan pages out of the target range and causes panic.
> > 
> > The problem is that pfn as argument of fast_isolate_around() could
> > be out of the target range. Therefore we should consider the case
> > where pfn < start_pfn, and also the case where end_pfn < pfn.
> > 
> > This problem should have been addressd by the commit 6e2b7044c199
> > ("mm, compaction: make fast_isolate_freepages() stay within zone")
> > but there was an oversight.
> > 
> >  Case1: pfn < start_pfn
> > 
> >   <at memory compaction for node Y>
> >   |  node X's zone  | node Y's zone
> >   +-----------------+------------------------------...
> >    pageblock    ^   ^     ^
> >   +-----------+-----------+-----------+-----------+...
> >                 ^   ^     ^
> >                 ^   ^      end_pfn
> >                 ^    start_pfn = cc->zone->zone_start_pfn
> >                  pfn
> >                 <---------> scanned range by "Scan After"
> > 
> >  Case2: end_pfn < pfn
> > 
> >   <at memory compaction for node X>
> >   |  node X's zone  | node Y's zone
> >   +-----------------+------------------------------...
> >    pageblock  ^     ^   ^
> >   +-----------+-----------+-----------+-----------+...
> >               ^     ^   ^
> >               ^     ^    pfn
> >               ^      end_pfn
> >                start_pfn
> >               <---------> scanned range by "Scan Before"
> > 
> > It seems that there is no good reason to skip nr_isolated pages
> > just after given pfn. So let perform simple scan from start to end
> > instead of dividing the scan into "Before" and "After".
> 
> Under what circumstances will this panic occur? 

I'd also like to see a warning or oops report combined with the
/proc/zoneinfo file of the machine affected. This is to confirm it's an
actual bug and not a suspicion based on code inspection and a simplification
of the code. The answer determines whether this is a -stable candidate
or not.

Both Case 1 and 2 require that the initial pfn started outside the zone
which is unexpected. The clamping on zone boundary in fast_isolate_aropund()
is happening due to pageblock alignment as there is no guarantee that zones
are aligned on a hugepage boundary. pfn itself should have been fine as
it is the PFN of a page that was recently isolated.

The Scan After logic should also be ok. In the context it's called,
nr_isolated is the number of pages that were just isolated so 
pfn + nr_isolated is the end of the free page that was just isolated.

The patch itself should be functionally fine but it rescans a region that has
already been isolated which is a little wasteful but it is straight-forward
and the overhead is probably negligible.

-- 
Mel Gorman
SUSE Labs
