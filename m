Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 455AE10DDF9
	for <lists+stable@lfdr.de>; Sat, 30 Nov 2019 16:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfK3PI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Nov 2019 10:08:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43866 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbfK3PI5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Nov 2019 10:08:57 -0500
Received: from [213.220.153.21] (helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1ib4Mf-00027w-PZ; Sat, 30 Nov 2019 15:08:53 +0000
Date:   Sat, 30 Nov 2019 16:08:53 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Will Deacon <will@kernel.org>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel@vger.kernel.org, bsingharora@gmail.com,
        dvyukov@google.com, elver@google.com, parri.andrea@gmail.com,
        stable@vger.kernel.org,
        syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH v6] taskstats: fix data-race
Message-ID: <20191130150851.r6lgwwatu42ad6i4@wittgenstein>
References: <20191009114809.8643-1-christian.brauner@ubuntu.com>
 <20191021113327.22365-1-christian.brauner@ubuntu.com>
 <efaecf5d-b528-24ba-1955-e1b190ece98c@rasmusvillemoes.dk>
 <20191021130417.5yi7pxpigsydz5po@wittgenstein>
 <20191129175604.GA29789@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191129175604.GA29789@willie-the-truck>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 29, 2019 at 05:56:05PM +0000, Will Deacon wrote:
> On Mon, Oct 21, 2019 at 03:04:18PM +0200, Christian Brauner wrote:
> > On Mon, Oct 21, 2019 at 02:19:01PM +0200, Rasmus Villemoes wrote:
> > > On 21/10/2019 13.33, Christian Brauner wrote:
> > > > The first approach used smp_load_acquire() and smp_store_release().
> > > > However, after having discussed this it seems that the data dependency
> > > > for kmem_cache_alloc() would be fixed by WRITE_ONCE().
> > > > Furthermore, the smp_load_acquire() would only manage to order the stats
> > > > check before the thread_group_empty() check. So it seems just using
> > > > READ_ONCE() and WRITE_ONCE() will do the job and I wanted to bring this
> > > > up for discussion at least.
> > > > 
> > > > /* v6 */
> > > > - Christian Brauner <christian.brauner@ubuntu.com>:
> > > >   - bring up READ_ONCE()/WRITE_ONCE() approach for discussion
> > > > ---
> > > >  kernel/taskstats.c | 26 +++++++++++++++-----------
> > > >  1 file changed, 15 insertions(+), 11 deletions(-)
> > > > 
> > > > diff --git a/kernel/taskstats.c b/kernel/taskstats.c
> > > > index 13a0f2e6ebc2..111bb4139aa2 100644
> > > > --- a/kernel/taskstats.c
> > > > +++ b/kernel/taskstats.c
> > > > @@ -554,25 +554,29 @@ static int taskstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
> > > >  static struct taskstats *taskstats_tgid_alloc(struct task_struct *tsk)
> > > >  {
> > > >  	struct signal_struct *sig = tsk->signal;
> > > > -	struct taskstats *stats;
> > > > +	struct taskstats *stats_new, *stats;
> > > >  
> > > > -	if (sig->stats || thread_group_empty(tsk))
> > > > -		goto ret;
> > > > +	/* Pairs with WRITE_ONCE() below. */
> > > > +	stats = READ_ONCE(sig->stats);
> > > > +	if (stats || thread_group_empty(tsk))
> > > > +		return stats;
> > > >  
> > > >  	/* No problem if kmem_cache_zalloc() fails */
> > > > -	stats = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
> > > > +	stats_new = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
> > > >  
> > > >  	spin_lock_irq(&tsk->sighand->siglock);
> > > > -	if (!sig->stats) {
> > > > -		sig->stats = stats;
> > > > -		stats = NULL;
> > > > +	if (!stats) {
> > > > +		stats = stats_new;
> > > > +		/* Pairs with READ_ONCE() above. */
> > > > +		WRITE_ONCE(sig->stats, stats_new);
> > > > +		stats_new = NULL;
> > > 
> > > No idea about the memory ordering issues, but don't you need to
> > > load/check sig->stats again? Otherwise it seems that two threads might
> > > both see !sig->stats, both allocate a stats_new, and both
> > > unconditionally in turn assign their stats_new to sig->stats. Then the
> > > first assignment ends up becoming a memory leak (and any writes through
> > > that pointer done by the caller end up in /dev/null...)
> > 
> > Trigger hand too fast. I guess you're thinking sm like:
> > 
> > diff --git a/kernel/taskstats.c b/kernel/taskstats.c
> > index 13a0f2e6ebc2..c4e1ed11e785 100644
> > --- a/kernel/taskstats.c
> > +++ b/kernel/taskstats.c
> > @@ -554,25 +554,27 @@ static int taskstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
> >  static struct taskstats *taskstats_tgid_alloc(struct task_struct *tsk)
> >  {
> >  	struct signal_struct *sig = tsk->signal;
> > -	struct taskstats *stats;
> > +	struct taskstats *stats_new, *stats;
> >  
> > -	if (sig->stats || thread_group_empty(tsk))
> > -		goto ret;
> > +	stats = READ_ONCE(sig->stats);
> 
> This probably wants to be an acquire, since both the memcpy() later on
> in taskstats_exit() and the accesses in {b,x}acct_add_tsk() appear to
> read from the taskstats structure without the sighand->siglock held and
> therefore may miss zeroed allocation from the zalloc() below, I think.
> 
> > +	if (stats || thread_group_empty(tsk))
> > +		return stats;
> >  
> > -	/* No problem if kmem_cache_zalloc() fails */
> > -	stats = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
> > +	stats_new = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
> >  
> >  	spin_lock_irq(&tsk->sighand->siglock);
> > -	if (!sig->stats) {
> > -		sig->stats = stats;
> > -		stats = NULL;
> > +	stats = READ_ONCE(sig->stats);
> 
> You hold the spinlock here, so I don't think you need the READ_ONCE().
> 
> > +	if (!stats) {
> > +		stats = stats_new;
> > +		WRITE_ONCE(sig->stats, stats_new);
> 
> You probably want a release here to publish the zeroes from the zalloc()
> (back to my first comment). With those changes:
> 
> Reviewed-by: Will Deacon <will@kernel.org>

Thanks, this is basically what we had in v5. I'll rework and send this
after the merge window closes.

> 
> However, this caused me to look at do_group_exit() and we appear to have
> racy accesses on sig->flags there thanks to signal_group_exit(). I worry
> that might run quite deep, and can probably be looked at separately.

Yeah, we should look into this but separate from this patch.

Thanks for taking a look at this! Much appreciated!
Christian
