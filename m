Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE4FCB456
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 08:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388051AbfJDGLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 02:11:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387618AbfJDGLo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 02:11:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9299520862;
        Fri,  4 Oct 2019 06:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570169502;
        bh=DABffYYFWZJ/GYY032Yu0DYAxWMtO3AA6U+PIER5Nr8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CIsyivs3KtWJDHOX21tQgHy0KSmpz5Z2ABW61LdDfxgsijTULgDd7Du7RxT031zXk
         a8rKMo3iPnzbjeF3JD30ekihAIL0nzD5p8y4N/gTpQktIiQrE0dVwgb784q5/1wOnr
         8tBV0NGA/7FL0f+nCW9k8+LLoyMfMjdnlStdKDaE=
Date:   Fri, 4 Oct 2019 08:11:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xuewei Zhang <xueweiz@google.com>
Cc:     Phil Auld <pauld@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
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
Message-ID: <20191004061139.GA845981@kroah.com>
References: <20191004001243.140897-1-xueweiz@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004001243.140897-1-xueweiz@google.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 05:12:43PM -0700, Xuewei Zhang wrote:
> quota/period ratio is used to ensure a child task group won't get more
> bandwidth than the parent task group, and is calculated as:
> normalized_cfs_quota() = [(quota_us << 20) / period_us]
> 
> If the quota/period ratio was changed during this scaling due to
> precision loss, it will cause inconsistency between parent and child
> task groups. See below example:
> A userspace container manager (kubelet) does three operations:
> 1) Create a parent cgroup, set quota to 1,000us and period to 10,000us.
> 2) Create a few children cgroups.
> 3) Set quota to 1,000us and period to 10,000us on a child cgroup.
> 
> These operations are expected to succeed. However, if the scaling of
> 147/128 happens before step 3), quota and period of the parent cgroup
> will be changed:
> new_quota: 1148437ns, 1148us
> new_period: 11484375ns, 11484us
> 
> And when step 3) comes in, the ratio of the child cgroup will be 104857,
> which will be larger than the parent cgroup ratio (104821), and will
> fail.
> 
> Scaling them by a factor of 2 will fix the problem.
> 
> Fixes: 2e8e19226398 ("sched/fair: Limit sched_cfs_period_timer() loop to avoid hard lockup")
> Signed-off-by: Xuewei Zhang <xueweiz@google.com>
> ---
>  kernel/sched/fair.c | 36 ++++++++++++++++++++++--------------
>  1 file changed, 22 insertions(+), 14 deletions(-)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
