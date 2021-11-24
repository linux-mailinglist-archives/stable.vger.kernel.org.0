Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E4445CF5F
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 22:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234293AbhKXVpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 16:45:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:50870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244768AbhKXVpX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 16:45:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5DAF60200;
        Wed, 24 Nov 2021 21:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637790132;
        bh=ah2I3uqyYLE8m7thrMmGKASOYSmvdjZyBclx+UXKn4E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YgMV8DHHxzgsjTn4w6O5PPLtDEEcRemobA/gyQZ86PXm5Fg2RJmgyaAPXbhSDcALJ
         RoLgFDxUhkFeNgqlQA1Zh8ERwycNMRMQm+B63ylwuFMtzjXNT3f0fMyTx2HCwkAooz
         38tBYA98ucFS/xMkKWg2aR0d9/8f3aD4z1uHBRAk=
Date:   Wed, 24 Nov 2021 13:42:10 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     SeongJae Park <sj@kernel.org>
Cc:     shakeelb@google.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon/core: Avoid fake load reports due to
 uninterruptible sleeps
Message-Id: <20211124134210.36ae288d02fea0a95e69e2ff@linux-foundation.org>
In-Reply-To: <20211124145219.32866-1-sj@kernel.org>
References: <20211124145219.32866-1-sj@kernel.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 24 Nov 2021 14:52:19 +0000 SeongJae Park <sj@kernel.org> wrote:

> Because DAMON sleeps in uninterruptible mode, /proc/loadavg reports fake
> load while DAMON is turned on, though it is doing nothing.  This can
> confuse users[1].  To avoid the case, this commit makes DAMON sleeps in
> idle mode.
> 
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -12,6 +12,8 @@
>  #include <linux/kthread.h>
>  #include <linux/mm.h>
>  #include <linux/random.h>
> +#include <linux/sched.h>
> +#include <linux/sched/debug.h>
>  #include <linux/slab.h>
>  #include <linux/string.h>
>  
> @@ -976,12 +978,25 @@ static unsigned long damos_wmark_wait_us(struct damos *scheme)
>  	return 0;
>  }
>  
> +/* sleep for @usecs in idle mode */
> +static void __sched damon_usleep_idle(unsigned long usecs)
> +{
> +	ktime_t exp = ktime_add_us(ktime_get(), usecs);
> +	u64 delta = usecs * NSEC_PER_USEC / 100;	/* allow 1% error */
> +
> +	for (;;) {
> +		__set_current_state(TASK_IDLE);
> +		if (!schedule_hrtimeout_range(&exp, delta, HRTIMER_MODE_ABS))
> +			break;
> +	}
> +}

Let's not copy-n-paste usleep_range() into damon code?

A new usleep_idle_range() in kernel/time/timer.c seems like a
worthwhile addition.  Perhaps usleep_idle_range() and usleep_range()
can be static inline wrappers against a new, more general function in
kernel/time/timer.c - usleep_range_state(min, max, state)?


