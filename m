Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0CB10D930
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 18:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbfK2R4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 12:56:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:48032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726970AbfK2R4M (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Nov 2019 12:56:12 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B69242158A;
        Fri, 29 Nov 2019 17:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575050170;
        bh=NB5Gf1Q3vSZTblBj+r+anX1Gd6+985MhbvLhEw+wH68=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SRXGlV5RVcc+XmFeQm3pDrl7JXNeolayQezj9ZbtKE0XVQBPKE7YLSYtvNXvLEWqI
         zJuURxnHYvQT7mewsRGOYFJu2UHO2Lrzg4E9KZmEeEuYRNwfRgJLyGITiHQCLyt3h0
         jF4+weFrW/rmQdpVPFVBBqUMajzeyfaKARGv6Pio=
Date:   Fri, 29 Nov 2019 17:56:05 +0000
From:   Will Deacon <will@kernel.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel@vger.kernel.org, bsingharora@gmail.com,
        dvyukov@google.com, elver@google.com, parri.andrea@gmail.com,
        stable@vger.kernel.org,
        syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH v6] taskstats: fix data-race
Message-ID: <20191129175604.GA29789@willie-the-truck>
References: <20191009114809.8643-1-christian.brauner@ubuntu.com>
 <20191021113327.22365-1-christian.brauner@ubuntu.com>
 <efaecf5d-b528-24ba-1955-e1b190ece98c@rasmusvillemoes.dk>
 <20191021130417.5yi7pxpigsydz5po@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021130417.5yi7pxpigsydz5po@wittgenstein>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 21, 2019 at 03:04:18PM +0200, Christian Brauner wrote:
> On Mon, Oct 21, 2019 at 02:19:01PM +0200, Rasmus Villemoes wrote:
> > On 21/10/2019 13.33, Christian Brauner wrote:
> > > The first approach used smp_load_acquire() and smp_store_release().
> > > However, after having discussed this it seems that the data dependency
> > > for kmem_cache_alloc() would be fixed by WRITE_ONCE().
> > > Furthermore, the smp_load_acquire() would only manage to order the stats
> > > check before the thread_group_empty() check. So it seems just using
> > > READ_ONCE() and WRITE_ONCE() will do the job and I wanted to bring this
> > > up for discussion at least.
> > > 
> > > /* v6 */
> > > - Christian Brauner <christian.brauner@ubuntu.com>:
> > >   - bring up READ_ONCE()/WRITE_ONCE() approach for discussion
> > > ---
> > >  kernel/taskstats.c | 26 +++++++++++++++-----------
> > >  1 file changed, 15 insertions(+), 11 deletions(-)
> > > 
> > > diff --git a/kernel/taskstats.c b/kernel/taskstats.c
> > > index 13a0f2e6ebc2..111bb4139aa2 100644
> > > --- a/kernel/taskstats.c
> > > +++ b/kernel/taskstats.c
> > > @@ -554,25 +554,29 @@ static int taskstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
> > >  static struct taskstats *taskstats_tgid_alloc(struct task_struct *tsk)
> > >  {
> > >  	struct signal_struct *sig = tsk->signal;
> > > -	struct taskstats *stats;
> > > +	struct taskstats *stats_new, *stats;
> > >  
> > > -	if (sig->stats || thread_group_empty(tsk))
> > > -		goto ret;
> > > +	/* Pairs with WRITE_ONCE() below. */
> > > +	stats = READ_ONCE(sig->stats);
> > > +	if (stats || thread_group_empty(tsk))
> > > +		return stats;
> > >  
> > >  	/* No problem if kmem_cache_zalloc() fails */
> > > -	stats = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
> > > +	stats_new = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
> > >  
> > >  	spin_lock_irq(&tsk->sighand->siglock);
> > > -	if (!sig->stats) {
> > > -		sig->stats = stats;
> > > -		stats = NULL;
> > > +	if (!stats) {
> > > +		stats = stats_new;
> > > +		/* Pairs with READ_ONCE() above. */
> > > +		WRITE_ONCE(sig->stats, stats_new);
> > > +		stats_new = NULL;
> > 
> > No idea about the memory ordering issues, but don't you need to
> > load/check sig->stats again? Otherwise it seems that two threads might
> > both see !sig->stats, both allocate a stats_new, and both
> > unconditionally in turn assign their stats_new to sig->stats. Then the
> > first assignment ends up becoming a memory leak (and any writes through
> > that pointer done by the caller end up in /dev/null...)
> 
> Trigger hand too fast. I guess you're thinking sm like:
> 
> diff --git a/kernel/taskstats.c b/kernel/taskstats.c
> index 13a0f2e6ebc2..c4e1ed11e785 100644
> --- a/kernel/taskstats.c
> +++ b/kernel/taskstats.c
> @@ -554,25 +554,27 @@ static int taskstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
>  static struct taskstats *taskstats_tgid_alloc(struct task_struct *tsk)
>  {
>  	struct signal_struct *sig = tsk->signal;
> -	struct taskstats *stats;
> +	struct taskstats *stats_new, *stats;
>  
> -	if (sig->stats || thread_group_empty(tsk))
> -		goto ret;
> +	stats = READ_ONCE(sig->stats);

This probably wants to be an acquire, since both the memcpy() later on
in taskstats_exit() and the accesses in {b,x}acct_add_tsk() appear to
read from the taskstats structure without the sighand->siglock held and
therefore may miss zeroed allocation from the zalloc() below, I think.

> +	if (stats || thread_group_empty(tsk))
> +		return stats;
>  
> -	/* No problem if kmem_cache_zalloc() fails */
> -	stats = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
> +	stats_new = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
>  
>  	spin_lock_irq(&tsk->sighand->siglock);
> -	if (!sig->stats) {
> -		sig->stats = stats;
> -		stats = NULL;
> +	stats = READ_ONCE(sig->stats);

You hold the spinlock here, so I don't think you need the READ_ONCE().

> +	if (!stats) {
> +		stats = stats_new;
> +		WRITE_ONCE(sig->stats, stats_new);

You probably want a release here to publish the zeroes from the zalloc()
(back to my first comment). With those changes:

Reviewed-by: Will Deacon <will@kernel.org>

However, this caused me to look at do_group_exit() and we appear to have
racy accesses on sig->flags there thanks to signal_group_exit(). I worry
that might run quite deep, and can probably be looked at separately.

Will
