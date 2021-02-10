Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDDE3168EF
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 15:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbhBJORy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 09:17:54 -0500
Received: from outbound-smtp18.blacknight.com ([46.22.139.245]:42159 "EHLO
        outbound-smtp18.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232069AbhBJORb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 09:17:31 -0500
X-Greylist: delayed 559 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Feb 2021 09:17:31 EST
Received: from mail.blacknight.com (pemlinmail02.blacknight.ie [81.17.254.11])
        by outbound-smtp18.blacknight.com (Postfix) with ESMTPS id 7B5D51C3865
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 14:07:14 +0000 (GMT)
Received: (qmail 5289 invoked from network); 10 Feb 2021 14:07:14 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 10 Feb 2021 14:07:14 -0000
Date:   Wed, 10 Feb 2021 14:07:12 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Catalin.Marinas@arm.com, akpm@linux-foundation.org,
        aneesh.kumar@linux.ibm.com, bharata@linux.ibm.com, cl@linux.com,
        guro@fb.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com,
        jannh@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        mhocko@kernel.org, rientjes@google.com, shakeelb@google.com,
        vincent.guittot@linaro.org, will@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm, slub: better heuristic for number of cpus when
 calculating slab order
Message-ID: <20210210140712.GB3697@techsingularity.net>
References: <aac07668-99a0-4c7e-5f8b-10751af364c5@suse.cz>
 <20210208134108.22286-1-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210208134108.22286-1-vbabka@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 02:41:08PM +0100, Vlastimil Babka wrote:
> When creating a new kmem cache, SLUB determines how large the slab pages will
> based on number of inputs, including the number of CPUs in the system. Larger
> slab pages mean that more objects can be allocated/free from per-cpu slabs
> before accessing shared structures, but also potentially more memory can be
> wasted due to low slab usage and fragmentation.
> The rough idea of using number of CPUs is that larger systems will be more
> likely to benefit from reduced contention, and also should have enough memory
> to spare.
> 
> <SNIP>
>
> So this patch tries to determine the best available value without specific arch
> knowledge.
> - num_present_cpus() if the number is larger than 1, as that means the arch is
> likely setting it properly
> - nr_cpu_ids otherwise
> 
> This should fix the reported regressions while also keeping the effect of
> 045ab8c9487b for PowerPC systems. It's possible there are configurations where
> num_present_cpus() is 1 during boot while nr_cpu_ids is at the same time
> bloated, so these (if they exist) would keep the large orders based on
> nr_cpu_ids as was before 045ab8c9487b.
> 

Tested-by: Mel Gorman <mgorman@techsingularity.net>

Only x86-64 tested, three machines, all showing similar results as would
be expected. One example;

hackbench-process-sockets
                          5.11.0-rc7             5.11.0-rc7             5.11.0-rc7
                             vanilla            revert-v1r1        vbabka-fix-v1r1
Amean     1        0.3873 (   0.00%)      0.4060 (  -4.82%)      0.3747 (   3.27%)
Amean     4        1.3767 (   0.00%)      0.7700 *  44.07%*      0.7790 *  43.41%*
Amean     7        2.4710 (   0.00%)      1.2753 *  48.39%*      1.2680 *  48.68%*
Amean     12       3.7103 (   0.00%)      1.9570 *  47.26%*      1.9470 *  47.52%*
Amean     21       5.9790 (   0.00%)      2.9760 *  50.23%*      2.9830 *  50.11%*
Amean     30       8.0467 (   0.00%)      4.0590 *  49.56%*      4.0410 *  49.78%*
Amean     48      12.8180 (   0.00%)      6.5167 *  49.16%*      6.4070 *  50.02%*
Amean     79      20.5150 (   0.00%)     10.3580 *  49.51%*     10.3740 *  49.43%*
Amean     110     25.5320 (   0.00%)     14.0453 *  44.99%*     14.0577 *  44.94%*
Amean     141     32.4170 (   0.00%)     17.3267 *  46.55%*     17.4977 *  46.02%*
Amean     172     40.0883 (   0.00%)     21.0360 *  47.53%*     21.1480 *  47.25%*
Amean     203     47.2923 (   0.00%)     25.2367 *  46.64%*     25.4923 *  46.10%*
Amean     234     55.2623 (   0.00%)     29.0720 *  47.39%*     29.3273 *  46.93%*
Amean     265     61.4513 (   0.00%)     33.0260 *  46.26%*     33.0617 *  46.20%*
Amean     296     73.2960 (   0.00%)     36.6920 *  49.94%*     37.2520 *  49.18%*

Comparing just a revert and the patch

                          5.11.0-rc7             5.11.0-rc7
                         revert-v1r1        vbabka-fix-v1r1
Amean     1        0.4060 (   0.00%)      0.3747 (   7.72%)
Amean     4        0.7700 (   0.00%)      0.7790 (  -1.17%)
Amean     7        1.2753 (   0.00%)      1.2680 (   0.58%)
Amean     12       1.9570 (   0.00%)      1.9470 (   0.51%)
Amean     21       2.9760 (   0.00%)      2.9830 (  -0.24%)
Amean     30       4.0590 (   0.00%)      4.0410 (   0.44%)
Amean     48       6.5167 (   0.00%)      6.4070 (   1.68%)
Amean     79      10.3580 (   0.00%)     10.3740 (  -0.15%)
Amean     110     14.0453 (   0.00%)     14.0577 (  -0.09%)
Amean     141     17.3267 (   0.00%)     17.4977 *  -0.99%*
Amean     172     21.0360 (   0.00%)     21.1480 (  -0.53%)
Amean     203     25.2367 (   0.00%)     25.4923 (  -1.01%)
Amean     234     29.0720 (   0.00%)     29.3273 (  -0.88%)
Amean     265     33.0260 (   0.00%)     33.0617 (  -0.11%)
Amean     296     36.6920 (   0.00%)     37.2520 (  -1.53%)

That's a negligible difference and all but one group (141) was within the
noise. Even for 141, it's very marginal and with the degree of overload
at that group count, it can be ignored.

Thanks!

-- 
Mel Gorman
SUSE Labs
