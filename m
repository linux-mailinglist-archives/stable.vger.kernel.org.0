Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9D145D5C3
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 08:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346273AbhKYHyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 02:54:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:44088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229894AbhKYHwW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 02:52:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF29460FDA;
        Thu, 25 Nov 2021 07:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637826551;
        bh=B7QA2luaH0UV4huYU5YUs8013qNIQPksoEF//pKOFTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:From;
        b=hF7eAFwfE+2RYL++qxXmK4oKzfVS/DMehoyOg+HqeL4UcxSHQTvHqrmNIIUaiMLbB
         P9Qgsmn1evzYJ5Ekk90+MLwqLQHY0/L8p7P8cMgkl81nNAJ0lInZHyebM+0d7x8u9M
         pQ1/+xRtCo2+cNpeC2kL651FnMXR6Jhca4kXssp1zd5E+gTlsR3WhvjtPn19YLM8La
         j8OPsHgEvXJgvraUGxtoBDNREW+OfVrurOHBzn7vHzpsuzP0kya2GMrV/ggxJYRxsD
         4SowyXv5+8BWGvEqz3Utte4Zu+XUu0/s7HMlUICOLAZ1wENb7f4RD55FtFkZjQRvaE
         AhrGSXCxB9UBw==
From:   SeongJae Park <sj@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     SeongJae Park <sj@kernel.org>, shakeelb@google.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon/core: Avoid fake load reports due to uninterruptible sleeps
Date:   Thu, 25 Nov 2021 07:49:08 +0000
Message-Id: <20211125074908.14412-1-sj@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211124134210.36ae288d02fea0a95e69e2ff@linux-foundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 24 Nov 2021 13:42:10 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 24 Nov 2021 14:52:19 +0000 SeongJae Park <sj@kernel.org> wrote:
> 
> > Because DAMON sleeps in uninterruptible mode, /proc/loadavg reports fake
> > load while DAMON is turned on, though it is doing nothing.  This can
> > confuse users[1].  To avoid the case, this commit makes DAMON sleeps in
> > idle mode.
> > 
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -12,6 +12,8 @@
> >  #include <linux/kthread.h>
> >  #include <linux/mm.h>
> >  #include <linux/random.h>
> > +#include <linux/sched.h>
> > +#include <linux/sched/debug.h>
> >  #include <linux/slab.h>
> >  #include <linux/string.h>
> >  
> > @@ -976,12 +978,25 @@ static unsigned long damos_wmark_wait_us(struct damos *scheme)
> >  	return 0;
> >  }
> >  
> > +/* sleep for @usecs in idle mode */
> > +static void __sched damon_usleep_idle(unsigned long usecs)
> > +{
> > +	ktime_t exp = ktime_add_us(ktime_get(), usecs);
> > +	u64 delta = usecs * NSEC_PER_USEC / 100;	/* allow 1% error */
> > +
> > +	for (;;) {
> > +		__set_current_state(TASK_IDLE);
> > +		if (!schedule_hrtimeout_range(&exp, delta, HRTIMER_MODE_ABS))
> > +			break;
> > +	}
> > +}
> 
> Let's not copy-n-paste usleep_range() into damon code?
> 
> A new usleep_idle_range() in kernel/time/timer.c seems like a
> worthwhile addition.  Perhaps usleep_idle_range() and usleep_range()
> can be static inline wrappers against a new, more general function in
> kernel/time/timer.c - usleep_range_state(min, max, state)?

Makes sense, agreed.  I will post next version soon.


Thanks,
SJ
