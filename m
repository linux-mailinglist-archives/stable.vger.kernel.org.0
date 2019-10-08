Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88590CF817
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 13:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730156AbfJHL0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 07:26:39 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59516 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729876AbfJHL0j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 07:26:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=QzG9uxqVaWu2Py++vRepIVOXKbIJ3yM+1U+4xpiRQXU=; b=JjllhKoY7qqd4rYbCBXvE6gNh
        qv27J0/uXStkQWkcXHLPXLt8u53loVBn+pBWo1PcUzZ3fu4V2+HrhI4ZI0NeclHZ08G5VyLDfxYSz
        MJb2c6aOEX4oJt/S8dLjXnWe91nzdInaMbOf73mgxpJzaC1UVUnwJCuVKPoTh2RECfbtllWD1RrkU
        KboP/7ZXTEmrgy3gpWO40uJqIyk+gzGJ8rlRrC1sGts3fXHgUXDEkpCfTTbNir5c5jR2eW69QQ7Ki
        t2SyUN6vfrkOT8JgqDAtJ72yS6+50BQeE9mSmxUizjg0EXpIopYDHTl1ZBVsqZCIX7vrVbI+kH9ia
        obuCjHKEA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iHnd7-0004LE-2M; Tue, 08 Oct 2019 11:26:13 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 513C2305E1D;
        Tue,  8 Oct 2019 13:25:18 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A3C3529BBAD03; Tue,  8 Oct 2019 13:26:09 +0200 (CEST)
Date:   Tue, 8 Oct 2019 13:26:09 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Phil Auld <pauld@redhat.com>
Cc:     Xuewei Zhang <xueweiz@google.com>, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Anton Blanchard <anton@ozlabs.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] sched/fair: scale quota and period without losing
 quota/period ratio precision
Message-ID: <20191008112609.GL2294@hirez.programming.kicks-ass.net>
References: <20191004001243.140897-1-xueweiz@google.com>
 <20191007151425.GD22412@pauld.bos.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007151425.GD22412@pauld.bos.csb>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 07, 2019 at 11:14:25AM -0400, Phil Auld wrote:
> On Thu, Oct 03, 2019 at 05:12:43PM -0700 Xuewei Zhang wrote:
> > quota/period ratio is used to ensure a child task group won't get more
> > bandwidth than the parent task group, and is calculated as:
> > normalized_cfs_quota() = [(quota_us << 20) / period_us]
> > 
> > If the quota/period ratio was changed during this scaling due to
> > precision loss, it will cause inconsistency between parent and child
> > task groups. See below example:
> > A userspace container manager (kubelet) does three operations:
> > 1) Create a parent cgroup, set quota to 1,000us and period to 10,000us.
> > 2) Create a few children cgroups.
> > 3) Set quota to 1,000us and period to 10,000us on a child cgroup.
> > 
> > These operations are expected to succeed. However, if the scaling of
> > 147/128 happens before step 3), quota and period of the parent cgroup
> > will be changed:
> > new_quota: 1148437ns, 1148us
> > new_period: 11484375ns, 11484us
> > 
> > And when step 3) comes in, the ratio of the child cgroup will be 104857,
> > which will be larger than the parent cgroup ratio (104821), and will
> > fail.
> > 
> > Scaling them by a factor of 2 will fix the problem.
> > 
> > Fixes: 2e8e19226398 ("sched/fair: Limit sched_cfs_period_timer() loop to avoid hard lockup")
> > Signed-off-by: Xuewei Zhang <xueweiz@google.com>
> 
> 
> I managed to get it to trigger the second case. It took 50,000 children (20x my initial tests).
> 
> [ 1367.850630] cfs_period_timer[cpu11]: period too short, scaling up (new cfs_period_us = 4340, cfs_quota_us = 250000)
> [ 1370.390832] cfs_period_timer[cpu11]: period too short, scaling up (new cfs_period_us = 8680, cfs_quota_us = 500000)
> [ 1372.914689] cfs_period_timer[cpu11]: period too short, scaling up (new cfs_period_us = 17360, cfs_quota_us = 1000000)
> [ 1375.447431] cfs_period_timer[cpu11]: period too short, scaling up (new cfs_period_us = 34720, cfs_quota_us = 2000000)
> [ 1377.982785] cfs_period_timer[cpu11]: period too short, scaling up (new cfs_period_us = 69440, cfs_quota_us = 4000000)
> [ 1380.481702] cfs_period_timer[cpu11]: period too short, scaling up (new cfs_period_us = 138880, cfs_quota_us = 8000000)
> [ 1382.894692] cfs_period_timer[cpu11]: period too short, scaling up (new cfs_period_us = 277760, cfs_quota_us = 16000000)
> [ 1385.264872] cfs_period_timer[cpu11]: period too short, scaling up (new cfs_period_us = 555520, cfs_quota_us = 32000000)
> [ 1393.965140] cfs_period_timer[cpu11]: period too short, but cannot scale up without losing precision (cfs_period_us = 555520, cfs_quota_us = 32000000)
> 
> I suspect going higher could cause the original lockup, but that'd be the case with the old code as well. 
> And this also gets us out of it faster.
> 
> 
> Tested-by: Phil Auld <pauld@redhat.com>

Thanks!
