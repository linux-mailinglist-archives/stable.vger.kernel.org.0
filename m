Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2870324809
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 01:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236422AbhBYAs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 19:48:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:44222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236421AbhBYAs4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 19:48:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 684EA6146B;
        Thu, 25 Feb 2021 00:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614214096;
        bh=P6YhKinu23PkPP/k4EIifcZhpqaz7+hAFMZPWD9ydqw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YnciVnY0U5Lq9txw9Utq5s5oIj/cjMLXbwnMAK2V9DohXcNKzS8uCHJUQhznFjpca
         SOt4TnUjtzN0nUxG/3R5/RvH1c4lFEBzxDOSQlGddaihTng6zuMFANX0l2VswfN/2n
         lMKDxUZqdfTDvPBMvQYlxBMIdFEVV9Ozi9AyuErQVfs/8V/ex8knfPBDHSWuF6CxiC
         hEOsWkVWLMeb7vPosjtLQDcONJ+D5oQCVBrVzZzWZj2JRwHDLJCvYne4YLP7a5jCkh
         pQi0YTcX7K8JFWbABg3BfX2guAOLVmqb26SvHsQRYUa5c8fUrWleJiCuyLauiNbved
         onePSotlk5WBg==
Date:   Thu, 25 Feb 2021 01:48:13 +0100
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
Subject: Re: [PATCH 01/13] rcu/nocb: Fix potential missed nocb_timer rearm
Message-ID: <20210225004813.GB12431@lothringen>
References: <20210223001011.127063-1-frederic@kernel.org>
 <20210223001011.127063-2-frederic@kernel.org>
 <20210224183709.GI2743@paulmck-ThinkPad-P72>
 <20210224220606.GA3179@lothringen>
 <20210225001425.GL2743@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225001425.GL2743@paulmck-ThinkPad-P72>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 24, 2021 at 04:14:25PM -0800, Paul E. McKenney wrote:
> On Wed, Feb 24, 2021 at 11:06:06PM +0100, Frederic Weisbecker wrote:
> > I managed to recollect some pieces of my brain. So keep the above but
> > let's change the point 10:
> > 
> > 10.     CPU 0 enqueues its second callback, this time with interrupts
> >  	enabled so it can wake directly	->nocb_gp_kthread.
> > 	It does so with calling __wake_nocb_gp() which also cancels the
> > 	pending timer that got queued in step 2. But that doesn't reset
> > 	CPU 0's ->nocb_defer_wakeup which is still set to RCU_NOCB_WAKE.
> > 	So CPU 0's ->nocb_defer_wakeup and CPU 0's ->nocb_timer are now
> > 	desynchronized.
> > 
> > 11.	->nocb_gp_kthread associates the callback queued in 10 with a new
> > 	grace period, arrange for it to start and sleeps on it.
> > 
> > 12.     The grace period ends, ->nocb_gp_kthread awakens and wakes up
> > 	CPU 0's ->nocb_cb_kthread which invokes the callback queued in 10.
> > 
> > 13.	CPU 0 enqueues its third callback, this time with interrupts
> > 	disabled so it tries to queue a deferred wakeup. However
> > 	->nocb_defer_wakeup has a stalled RCU_NOCB_WAKE value which prevents
> > 	the CPU 0's ->nocb_timer, that got cancelled in 10, from being armed.
> > 
> > 14.     CPU 0 has its pending callback and it may go unnoticed until
> >         some other CPU ever wakes up ->nocb_gp_kthread or CPU 0 ever calls
> > 	an explicit deferred wake up caller like idle entry.
> > 
> > I hope I'm not missing something this time...
> 
> Thank you, that does sound plausible.  I guess I can see how rcutorture
> might have missed this one!

I must admit it requires a lot of stars to be aligned :-)

Thanks.
