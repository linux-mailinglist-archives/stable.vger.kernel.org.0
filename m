Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661D533CA3B
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 01:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbhCPACr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 20:02:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233898AbhCPACp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 20:02:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C467964F37;
        Tue, 16 Mar 2021 00:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615852964;
        bh=dli/d2ebn1pnWh7cKAeWzCoyMngSBh0W1PyKQJV5VfM=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=RCbQ7q0+TCJlHe/2YVmP9s2ENNbSqxQtJ1LpcbBeze030Z6ywrlhpf5mWoZ3vOZjP
         PN4AQ8T1j6zP1EVeHl29GNkEf3nCwYdOCnk0hqnd3+Mb2HJbBkdrk+37fbXCZoOiCj
         pD84HTmYOy3Q8BMuGqao+xggyjKHDUBarv6vrb+siFYtXsU1MOKxplVUyBaBHdj85I
         kTrl7DKbJZtMQJcMpCDZkdrAScr1SafLR1/113RcDmKb+pdaHOZXW1n/LLYqMu8bb5
         LcbY87fWelbx3h2p/UoBBZl4BkE8uaXMvWCAFkpvE9DWFKvMxTpswUbsDASwDBrMzd
         D6pJ7hc4sifsg==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id A200C35226FD; Mon, 15 Mar 2021 17:02:44 -0700 (PDT)
Date:   Mon, 15 Mar 2021 17:02:44 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     Boqun Feng <boqun.feng@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH 10/13] rcu/nocb: Delete bypass_timer upon nocb_gp wakeup
Message-ID: <20210316000244.GS2696@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20210223001011.127063-1-frederic@kernel.org>
 <20210223001011.127063-11-frederic@kernel.org>
 <20210303012456.GC20917@paulmck-ThinkPad-P72>
 <20210310221702.GC2949@lothringen>
 <YE908FC8F8/0p07q@boqun-archlinux>
 <20210315225633.GA53908@lothringen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315225633.GA53908@lothringen>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 11:56:33PM +0100, Frederic Weisbecker wrote:
> On Mon, Mar 15, 2021 at 10:53:36PM +0800, Boqun Feng wrote:
> > On Wed, Mar 10, 2021 at 11:17:02PM +0100, Frederic Weisbecker wrote:
> > > On Tue, Mar 02, 2021 at 05:24:56PM -0800, Paul E. McKenney wrote:
> > > > On Tue, Feb 23, 2021 at 01:10:08AM +0100, Frederic Weisbecker wrote:
> > > > > A NOCB-gp wake up can safely delete the nocb_bypass_timer. nocb_gp_wait()
> > > > > is going to check again the bypass state and rearm the bypass timer if
> > > > > necessary.
> > > > > 
> > > > > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > > > > Cc: Josh Triplett <josh@joshtriplett.org>
> > > > > Cc: Lai Jiangshan <jiangshanlai@gmail.com>
> > > > > Cc: Joel Fernandes <joel@joelfernandes.org>
> > > > > Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
> > > > > Cc: Boqun Feng <boqun.feng@gmail.com>
> > > > 
> > > > Give that you delete this code a couple of patches later in this series,
> > > > why not just leave it out entirely?  ;-)
> > > 
> > > It's not exactly deleted later, it's rather merged within the
> > > "del_timer(&rdp_gp->nocb_timer)".
> > > 
> > > The purpose of that patch is to make it clear that we explicitly cancel
> > > the nocb_bypass_timer here before we do it implicitly later with the
> > > merge of nocb_bypass_timer into nocb_timer.
> > > 
> > > We could drop that patch, the resulting code in the end of the patchset
> > > will be the same of course but the behaviour detail described here might
> > > slip out of the reviewers attention :-)
> > > 
> > 
> > How about merging the timers first and adding those small improvements
> > later? i.e. move patch #12 #13 right after #7 (IIUC, #7 is the last
> > requirement you need for merging timers)
> 
> Hmm, nope, patches 9 and 10 are actually preparation work for timers merge.
> In fact they could even be skipped and timers could be merged directly but I
> wanted the unified behaviour to be fully explicit for reviewers through those
> incremental changes before merging the timers together.
> 
> >, and then patch #8~#11 just follow
> 
> Patch 8 really need to stay where it is because it is an important limitation
> on nocb de-offloading that can be removed right after patch 7 (which itself
> removes the sole reason for rdp leader to remain nocb) and it doesn't depend
> on the timers unification that comes after.
> 
> > 
> > Just my 2 cents. The overall patchset looks good to me ;-)
> > 
> > Feel free to add
> > 
> > Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
> 
> Thanks a lot for checking that!

Applied to 10/13, thank you both!

							Thanx, Paul
