Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9E36ECD2E
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbjDXNVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbjDXNVN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:21:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC5C24EF2
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:20:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA47D62209
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:20:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6C2C433D2;
        Mon, 24 Apr 2023 13:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342455;
        bh=LhLp7Cd/mA4zk176ZLEqEwVxAX4Hqt2ksJnLLdlHI1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aLBuAyEHgkVN4fWWXg3ToHRoENcApSw7Zbbbpeq0umu1DEU70xw5DIkb6FqaNh/dm
         xajTTwxMEFLDJhzsDwauiXac1lkbT1bhUPMQFNqhyeXv8LWSBMtDZF6I9ws5BzEW+R
         u0i72Vb1X3aUhpW2z1qjZTzUzEzx0160edsHExTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mel Gorman <mgorman@techsingularity.net>,
        Yuanxi Liu <y.liu@naruida.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 44/73] mm: page_alloc: skip regions with hugetlbfs pages when allocating 1G pages
Date:   Mon, 24 Apr 2023 15:16:58 +0200
Message-Id: <20230424131130.607360128@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
References: <20230424131129.040707961@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>

commit 4d73ba5fa710fe7d432e0b271e6fecd252aef66e upstream.

A bug was reported by Yuanxi Liu where allocating 1G pages at runtime is
taking an excessive amount of time for large amounts of memory.  Further
testing allocating huge pages that the cost is linear i.e.  if allocating
1G pages in batches of 10 then the time to allocate nr_hugepages from
10->20->30->etc increases linearly even though 10 pages are allocated at
each step.  Profiles indicated that much of the time is spent checking the
validity within already existing huge pages and then attempting a
migration that fails after isolating the range, draining pages and a whole
lot of other useless work.

Commit eb14d4eefdc4 ("mm,page_alloc: drop unnecessary checks from
pfn_range_valid_contig") removed two checks, one which ignored huge pages
for contiguous allocations as huge pages can sometimes migrate.  While
there may be value on migrating a 2M page to satisfy a 1G allocation, it's
potentially expensive if the 1G allocation fails and it's pointless to try
moving a 1G page for a new 1G allocation or scan the tail pages for valid
PFNs.

Reintroduce the PageHuge check and assume any contiguous region with
hugetlbfs pages is unsuitable for a new 1G allocation.

The hpagealloc test allocates huge pages in batches and reports the
average latency per page over time.  This test happens just after boot
when fragmentation is not an issue.  Units are in milliseconds.

hpagealloc
                               6.3.0-rc6              6.3.0-rc6              6.3.0-rc6
                                 vanilla   hugeallocrevert-v1r1   hugeallocsimple-v1r2
Min       Latency       26.42 (   0.00%)        5.07 (  80.82%)       18.94 (  28.30%)
1st-qrtle Latency      356.61 (   0.00%)        5.34 (  98.50%)       19.85 (  94.43%)
2nd-qrtle Latency      697.26 (   0.00%)        5.47 (  99.22%)       20.44 (  97.07%)
3rd-qrtle Latency      972.94 (   0.00%)        5.50 (  99.43%)       20.81 (  97.86%)
Max-1     Latency       26.42 (   0.00%)        5.07 (  80.82%)       18.94 (  28.30%)
Max-5     Latency       82.14 (   0.00%)        5.11 (  93.78%)       19.31 (  76.49%)
Max-10    Latency      150.54 (   0.00%)        5.20 (  96.55%)       19.43 (  87.09%)
Max-90    Latency     1164.45 (   0.00%)        5.53 (  99.52%)       20.97 (  98.20%)
Max-95    Latency     1223.06 (   0.00%)        5.55 (  99.55%)       21.06 (  98.28%)
Max-99    Latency     1278.67 (   0.00%)        5.57 (  99.56%)       22.56 (  98.24%)
Max       Latency     1310.90 (   0.00%)        8.06 (  99.39%)       26.62 (  97.97%)
Amean     Latency      678.36 (   0.00%)        5.44 *  99.20%*       20.44 *  96.99%*

                   6.3.0-rc6   6.3.0-rc6   6.3.0-rc6
                     vanilla   revert-v1   hugeallocfix-v2
Duration User           0.28        0.27        0.30
Duration System       808.66       17.77       35.99
Duration Elapsed      830.87       18.08       36.33

The vanilla kernel is poor, taking up to 1.3 second to allocate a huge
page and almost 10 minutes in total to run the test.  Reverting the
problematic commit reduces it to 8ms at worst and the patch takes 26ms.
This patch fixes the main issue with skipping huge pages but leaves the
page_count() out because a page with an elevated count potentially can
migrate.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=217022
Link: https://lkml.kernel.org/r/20230414141429.pwgieuwluxwez3rj@techsingularity.net
Fixes: eb14d4eefdc4 ("mm,page_alloc: drop unnecessary checks from pfn_range_valid_contig")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: Yuanxi Liu <y.liu@naruida.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -9239,6 +9239,9 @@ static bool pfn_range_valid_contig(struc
 
 		if (PageReserved(page))
 			return false;
+
+		if (PageHuge(page))
+			return false;
 	}
 	return true;
 }


