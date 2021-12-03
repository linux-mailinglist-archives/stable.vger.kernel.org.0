Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27DF0467277
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 08:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378825AbhLCHVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 02:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378800AbhLCHVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 02:21:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCAEC06174A;
        Thu,  2 Dec 2021 23:17:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B46B62942;
        Fri,  3 Dec 2021 07:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58404C53FC7;
        Fri,  3 Dec 2021 07:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638515864;
        bh=i0rhTufR5Dba/BowNYQm/wav9bcJqB5wt7mHJZWPIHM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N2B+u4sxzOHJm99qhNdGH9F0JtekTu5tqzDRdbW0ez1b0i8V0bH1N4ty5wUl8/5ZA
         rQX3fIq6EQgtDzKmqxy0+Q3pr3EZ1i8a1tOmfEisp7ltnO5oobyHwR8HDaxkEspvDM
         12XjIK5S53dpCAASYVBkJzwCZDQHwJHE0e/WEg/Y=
Date:   Fri, 3 Dec 2021 08:17:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Li Hua <hucool.lihua@huawei.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2, RESEND] sched/rt: Try to restart rt period timer when
 rt runtime exceeded
Message-ID: <YanElPGuGJ8J6UK9@kroah.com>
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
> ---
> v1->v2:
>   - call do_start_rt_bandwidth to reduce repetitive code.
>   - use raw_spin_lock_irqsave to avoid deadlock on a timer context.
> ---
>  kernel/sched/rt.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
