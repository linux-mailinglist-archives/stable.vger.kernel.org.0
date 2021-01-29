Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31DC3082B8
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 01:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbhA2Aws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 19:52:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:39714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231224AbhA2AwK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 19:52:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F9BD64DEB;
        Fri, 29 Jan 2021 00:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611881489;
        bh=lZ5LKd9/hBVdbeSFVOre7zKzMJV9tCrQqwYciLIfd1Y=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=CDcDMlaXzCLP69bdGv+YZWiNtN+7Nkc9y3JAL1tIE6XwxiZg9ZvyGFzYz7E36M9Ny
         2EU/8cW0hlD5u3sLocvTQEasvwvkBydIXFWAv9kmmg+xJslJMBvimPlI2pitvq9M5a
         fORAtZyjhjz3T9gY39Iitazb+uqCsXDMWZEjyJ+GB13PRwaPHUmIKcKaLEZziasfMK
         dQSYBPaAP1nzFeQJNzLfoVuPvsvJwDAI9jWhtnjA3USBETdn5FTjIwtrG43AH0A5oe
         ofFlTMO6WUmEKWcCLQx8vGKKd+YuHVd5JPwwjkXNvmbBs4URaNd3di3rlfzITWYtFl
         S1bFEHLUq7oYw==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id EF34335237A0; Thu, 28 Jan 2021 16:51:28 -0800 (PST)
Date:   Thu, 28 Jan 2021 16:51:28 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH 08/16] rcu/nocb: Move trace_rcu_nocb_wake() calls outside
 nocb_lock when possible
Message-ID: <20210129005128.GA2743@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20210128171222.131380-1-frederic@kernel.org>
 <20210128171222.131380-9-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128171222.131380-9-frederic@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 28, 2021 at 06:12:14PM +0100, Frederic Weisbecker wrote:
> Those tracing calls don't need to be under the nocb lock. Move them
> outside.

This one looks fine (give or take the usual wordsmithing), but does
not apply, presumably due to my not having yet taken one of the earlier
patches.  So deferred for now, and please include it in your next version.

							Thanx, Paul

> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Lai Jiangshan <jiangshanlai@gmail.com>
> Cc: Joel Fernandes <joel@joelfernandes.org>
> Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> ---
>  kernel/rcu/tree_plugin.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 86c3bcceede6..8c5fea58ee80 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -1700,9 +1700,9 @@ static bool wake_nocb_gp(struct rcu_data *rdp, bool force,
>  
>  	lockdep_assert_held(&rdp->nocb_lock);
>  	if (!READ_ONCE(rdp_gp->nocb_gp_kthread)) {
> +		rcu_nocb_unlock_irqrestore(rdp, flags);
>  		trace_rcu_nocb_wake(rcu_state.name, rdp->cpu,
>  				    TPS("AlreadyAwake"));
> -		rcu_nocb_unlock_irqrestore(rdp, flags);
>  		return false;
>  	}
>  
> @@ -1950,9 +1950,9 @@ static void __call_rcu_nocb_wake(struct rcu_data *rdp, bool was_alldone,
>  	// If we are being polled or there is no kthread, just leave.
>  	t = READ_ONCE(rdp->nocb_gp_kthread);
>  	if (rcu_nocb_poll || !t) {
> +		rcu_nocb_unlock_irqrestore(rdp, flags);
>  		trace_rcu_nocb_wake(rcu_state.name, rdp->cpu,
>  				    TPS("WakeNotPoll"));
> -		rcu_nocb_unlock_irqrestore(rdp, flags);
>  		return;
>  	}
>  	// Need to actually to a wakeup.
> @@ -1987,8 +1987,8 @@ static void __call_rcu_nocb_wake(struct rcu_data *rdp, bool was_alldone,
>  					   TPS("WakeOvfIsDeferred"));
>  		rcu_nocb_unlock_irqrestore(rdp, flags);
>  	} else {
> +		rcu_nocb_unlock_irqrestore(rdp, flags);
>  		trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("WakeNot"));
> -		rcu_nocb_unlock_irqrestore(rdp, flags);
>  	}
>  	return;
>  }
> -- 
> 2.25.1
> 
