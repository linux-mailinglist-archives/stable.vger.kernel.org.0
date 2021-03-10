Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3047334B54
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 23:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbhCJWRL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 17:17:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:53862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232181AbhCJWRF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 17:17:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F52664FB9;
        Wed, 10 Mar 2021 22:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615414625;
        bh=uvxATqmALoLwZ5xgJ3XvB9q+ryBa5IKMCmWm/PrqUS8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ahAt+j+pAV7DmD0Z1B3oguj1fYJjKbXXGMMJmOlnqSK2gsaTPeH71RUDM7a+DpC6F
         s6DZmBWqsvjcT7v85GFi4DiNnLYWR5LbRn6SwxzykW8hnyzU5jXYacUPxVIPdtFaVT
         ZOh8FMZY4bhcIYyBLxCgHRts7Bv9J6+9A1cqwzlbe9FcvWmtMlKbe5gnSJo/mOeVxL
         6FLmXK2Q6e/7DmHfvS0GMTpJseA3yuxjc/qeaCnLMwif11ImkpPvDEDH5log0Dwb40
         zOES27c+I/2rDwh3p4bx0VoVlof6X/OqLpFNBP6kbB87AxwxyRnE6wxdUBkuDRAyB3
         HbAn0992iqtBw==
Date:   Wed, 10 Mar 2021 23:17:02 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH 10/13] rcu/nocb: Delete bypass_timer upon nocb_gp wakeup
Message-ID: <20210310221702.GC2949@lothringen>
References: <20210223001011.127063-1-frederic@kernel.org>
 <20210223001011.127063-11-frederic@kernel.org>
 <20210303012456.GC20917@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303012456.GC20917@paulmck-ThinkPad-P72>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 05:24:56PM -0800, Paul E. McKenney wrote:
> On Tue, Feb 23, 2021 at 01:10:08AM +0100, Frederic Weisbecker wrote:
> > A NOCB-gp wake up can safely delete the nocb_bypass_timer. nocb_gp_wait()
> > is going to check again the bypass state and rearm the bypass timer if
> > necessary.
> > 
> > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > Cc: Josh Triplett <josh@joshtriplett.org>
> > Cc: Lai Jiangshan <jiangshanlai@gmail.com>
> > Cc: Joel Fernandes <joel@joelfernandes.org>
> > Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
> > Cc: Boqun Feng <boqun.feng@gmail.com>
> 
> Give that you delete this code a couple of patches later in this series,
> why not just leave it out entirely?  ;-)

It's not exactly deleted later, it's rather merged within the
"del_timer(&rdp_gp->nocb_timer)".

The purpose of that patch is to make it clear that we explicitly cancel
the nocb_bypass_timer here before we do it implicitly later with the
merge of nocb_bypass_timer into nocb_timer.

We could drop that patch, the resulting code in the end of the patchset
will be the same of course but the behaviour detail described here might
slip out of the reviewers attention :-)

> 
> 							Thanx, Paul
> 
> > ---
> >  kernel/rcu/tree_plugin.h | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> > index b62ad79bbda5..9da67b0d3997 100644
> > --- a/kernel/rcu/tree_plugin.h
> > +++ b/kernel/rcu/tree_plugin.h
> > @@ -1711,6 +1711,8 @@ static bool __wake_nocb_gp(struct rcu_data *rdp_gp,
> >  		del_timer(&rdp_gp->nocb_timer);
> >  	}
> >  
> > +	del_timer(&rdp_gp->nocb_bypass_timer);
> > +
> >  	if (force || READ_ONCE(rdp_gp->nocb_gp_sleep)) {
> >  		WRITE_ONCE(rdp_gp->nocb_gp_sleep, false);
> >  		needwake = true;

Thanks.
