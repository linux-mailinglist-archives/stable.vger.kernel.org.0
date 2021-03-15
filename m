Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0785B33C98A
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 23:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbhCOW5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 18:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229756AbhCOW4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 18:56:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2C2E64F51;
        Mon, 15 Mar 2021 22:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615848996;
        bh=mA6bo54i/sasosDNilaR36TpTtKYiYK3W7ZnOQugUzQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jf5J1PFj3rCq0FWyR+H3d3QIZGBaWMqdvpWSbcVpGTyzgxxNvpkhO5UFkbh7ymSrw
         o3XYlZcnLwb23SZ9AQADSy0L8Qrmj/jmERt0/W7kzZMcR/TVtvk0obSDSD/JmqTE7g
         BoSFVryjJZdJLcDDLJxTyY+saHXXHfxeqOTdwhl6knDfMBOO3NHvwnAewdeJRl0kVy
         /dr5HqhqMGbsW2qczcEPMnZRcLstnXkc7u2e1/vlUsZhJcFYR9cza6DFCXA6gnWax7
         n7xYHSkGseZ5xv51gw1RhswrIOfzElGSI8tERxxk8MPBE1UXRyrKnezXpol7cB7yvd
         +4IlHuHs/PcYA==
Date:   Mon, 15 Mar 2021 23:56:33 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Boqun Feng <boqun.feng@gmail.com>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH 10/13] rcu/nocb: Delete bypass_timer upon nocb_gp wakeup
Message-ID: <20210315225633.GA53908@lothringen>
References: <20210223001011.127063-1-frederic@kernel.org>
 <20210223001011.127063-11-frederic@kernel.org>
 <20210303012456.GC20917@paulmck-ThinkPad-P72>
 <20210310221702.GC2949@lothringen>
 <YE908FC8F8/0p07q@boqun-archlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YE908FC8F8/0p07q@boqun-archlinux>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 10:53:36PM +0800, Boqun Feng wrote:
> On Wed, Mar 10, 2021 at 11:17:02PM +0100, Frederic Weisbecker wrote:
> > On Tue, Mar 02, 2021 at 05:24:56PM -0800, Paul E. McKenney wrote:
> > > On Tue, Feb 23, 2021 at 01:10:08AM +0100, Frederic Weisbecker wrote:
> > > > A NOCB-gp wake up can safely delete the nocb_bypass_timer. nocb_gp_wait()
> > > > is going to check again the bypass state and rearm the bypass timer if
> > > > necessary.
> > > > 
> > > > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > > > Cc: Josh Triplett <josh@joshtriplett.org>
> > > > Cc: Lai Jiangshan <jiangshanlai@gmail.com>
> > > > Cc: Joel Fernandes <joel@joelfernandes.org>
> > > > Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
> > > > Cc: Boqun Feng <boqun.feng@gmail.com>
> > > 
> > > Give that you delete this code a couple of patches later in this series,
> > > why not just leave it out entirely?  ;-)
> > 
> > It's not exactly deleted later, it's rather merged within the
> > "del_timer(&rdp_gp->nocb_timer)".
> > 
> > The purpose of that patch is to make it clear that we explicitly cancel
> > the nocb_bypass_timer here before we do it implicitly later with the
> > merge of nocb_bypass_timer into nocb_timer.
> > 
> > We could drop that patch, the resulting code in the end of the patchset
> > will be the same of course but the behaviour detail described here might
> > slip out of the reviewers attention :-)
> > 
> 
> How about merging the timers first and adding those small improvements
> later? i.e. move patch #12 #13 right after #7 (IIUC, #7 is the last
> requirement you need for merging timers)

Hmm, nope, patches 9 and 10 are actually preparation work for timers merge.
In fact they could even be skipped and timers could be merged directly but I
wanted the unified behaviour to be fully explicit for reviewers through those
incremental changes before merging the timers together.

>, and then patch #8~#11 just follow

Patch 8 really need to stay where it is because it is an important limitation
on nocb de-offloading that can be removed right after patch 7 (which itself
removes the sole reason for rdp leader to remain nocb) and it doesn't depend
on the timers unification that comes after.

> 
> Just my 2 cents. The overall patchset looks good to me ;-)
> 
> Feel free to add
> 
> Reviewed-by: Boqun Feng <boqun.feng@gmail.com>

Thanks a lot for checking that!
