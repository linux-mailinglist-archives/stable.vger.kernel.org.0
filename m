Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFFB32BC08
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359149AbhCCNiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:38:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:39184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239545AbhCCBZj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 20:25:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B455C64FB8;
        Wed,  3 Mar 2021 01:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614734696;
        bh=1pX3GhK3Mhm63DTy3NRp0mhzbbcYTuCdbDqq8wxqGqI=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=SjeGS0cDc5nWtN9Ff+khL2j8OvJHjwWABFxT8JEcCwv9/thSegS3+4MwzUtHHoFD3
         r5XQ+v15iuuEIPG9lXUkNMCmMqPXE4onbISKt163RCpdFCCpt4NMztRDIIlhShLtsw
         ImQJn4I87nGh0cHR9mymZud0NwEQKq0W9jPgto0+T3FW0gA6T8aBqzAXx09fgXXGZh
         fFxL3ERO0l41SZVT3qiDdYKkJ6MnTJeEmU1gBVlz+nmCk7EboRK6EvMOfEuPDHX6JZ
         XsmidHqMdSdgxWnBwcPd+gbx798uLKx1rZCvrXbAnjrJnRYTEvg6Tjz2DIfdITD5AB
         DWwJzCpXgdV9w==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 563123522A62; Tue,  2 Mar 2021 17:24:56 -0800 (PST)
Date:   Tue, 2 Mar 2021 17:24:56 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH 10/13] rcu/nocb: Delete bypass_timer upon nocb_gp wakeup
Message-ID: <20210303012456.GC20917@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20210223001011.127063-1-frederic@kernel.org>
 <20210223001011.127063-11-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223001011.127063-11-frederic@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 23, 2021 at 01:10:08AM +0100, Frederic Weisbecker wrote:
> A NOCB-gp wake up can safely delete the nocb_bypass_timer. nocb_gp_wait()
> is going to check again the bypass state and rearm the bypass timer if
> necessary.
> 
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Lai Jiangshan <jiangshanlai@gmail.com>
> Cc: Joel Fernandes <joel@joelfernandes.org>
> Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
> Cc: Boqun Feng <boqun.feng@gmail.com>

Give that you delete this code a couple of patches later in this series,
why not just leave it out entirely?  ;-)

							Thanx, Paul

> ---
>  kernel/rcu/tree_plugin.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index b62ad79bbda5..9da67b0d3997 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -1711,6 +1711,8 @@ static bool __wake_nocb_gp(struct rcu_data *rdp_gp,
>  		del_timer(&rdp_gp->nocb_timer);
>  	}
>  
> +	del_timer(&rdp_gp->nocb_bypass_timer);
> +
>  	if (force || READ_ONCE(rdp_gp->nocb_gp_sleep)) {
>  		WRITE_ONCE(rdp_gp->nocb_gp_sleep, false);
>  		needwake = true;
> -- 
> 2.25.1
> 
