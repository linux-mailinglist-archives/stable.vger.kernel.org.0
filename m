Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7349F468482
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 12:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384801AbhLDLiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Dec 2021 06:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384799AbhLDLiH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Dec 2021 06:38:07 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF69C061751;
        Sat,  4 Dec 2021 03:34:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RcNzHUNX3EEmYfNiycUBXscMa+FJs+tAlKOz7nOSxLY=; b=ePMvWSYDm+6PJd+5CWtIjZJPDR
        htzS4nQxLYERY/pDV8M1sYdy94w+8I0UCJN584W3QdMS54maFnRQhG2nBG359cIFMMxwpeq9xfYIm
        4yHvSrRzW4fZoJ+b8MHNzga27+x4u63MrFBYbd8LDe2kfUrslEw8TRtHm82G2g4X37b95KpgT87ox
        WlAo09vGzJlZhZiis4imeFBOaLpmSRbX/P30oT3/7+ATWYrmVbg+Co2/9DfIzMNohU99XRERRb9Xa
        Duw9xgVklhj62Q53ps2j5dHRmiOA1gUsTLVgIx8TAHF+RNmGWKzLNf3sqcoAo93wntl3arpboZmKR
        VdIZozCQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mtTJ3-002Bkc-BB; Sat, 04 Dec 2021 11:34:17 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1AB9598106D; Sat,  4 Dec 2021 12:34:15 +0100 (CET)
Date:   Sat, 4 Dec 2021 12:34:15 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Li Hua <hucool.lihua@huawei.com>
Cc:     Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2, RESEND] sched/rt: Try to restart rt period timer when
 rt runtime exceeded
Message-ID: <20211204113415.GV16608@worktop.programming.kicks-ass.net>
References: <20211203033618.11895-1-hucool.lihua@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211203033618.11895-1-hucool.lihua@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 03, 2021 at 03:36:18AM +0000, Li Hua wrote:
> When rt_runtime is modified from -1 to a valid control value, it may
> cause the task to be throttled all the time. Operations like the following
> will trigger the bug. E.g:
> 1. echo -1 > /proc/sys/kernel/sched_rt_runtime_us
> 2. Run a FIFO task named A that executes while(1)
> 3. echo 950000 > /proc/sys/kernel/sched_rt_runtime_us
> 
> When rt_runtime is -1, The rt period timer will not be activated when task
> A enqueued. And then the task will be throttled after setting rt_runtime to
> 950,000. The task will always be throttled because the rt period timer is
> not activated.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Li Hua <hucool.lihua@huawei.com>

Thanks, do you think you can reply here with a Fixes: tag so I can add
it?
