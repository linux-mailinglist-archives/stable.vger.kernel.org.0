Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8CE3F3297
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 19:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234428AbhHTR6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 13:58:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234160AbhHTR6Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 13:58:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C4DD61056;
        Fri, 20 Aug 2021 17:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629482258;
        bh=PMMuLswqXvvS4sA3R+OiUDxdV3fVCb2CblbI0j0/hws=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=mHErCOB9OHPl/euw92KIJaoIA2n/q0VOPX3EEoZIvJ29wxkyl40g1bCa1S7Zga0cQ
         jCczkL0N5l36yI9X9cKDIYBfHBVe68HhE9tI31xpbuaWvwcna+KJlaWlWl8VLxuNRs
         1GQbMatwRfFdKv6dCXaVX+0MTECd19mtQW8+6HCd5JMAOirnyHA/XiiBsKgf4oXUCQ
         pCdEyBwL8VHLJUn8pc2qslcqFdxWzfmeQzDJZAUApzPGDt+KKPU6DzzoReOF0Ce/nQ
         CNGiaCjIRva7AxihbqNI+frOOstddbPQ8Vx55MkhllgXo+9XvnBsKLYi1moYAc8FuN
         99itUPrja+bWg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 2D21B5C0399; Fri, 20 Aug 2021 10:57:38 -0700 (PDT)
Date:   Fri, 20 Aug 2021 10:57:38 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     gregkh@linuxfoundation.org, mathieu.desnoyers@efficios.com,
        akpm@linux-foundation.org, metze@samba.org, mingo@redhat.com,
        peterz@infradead.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracepoint: Use rcu get state and cond
 sync for static call" failed to apply to 5.10-stable tree
Message-ID: <20210820175738.GH4126399@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <1628500832155134@kroah.com>
 <20210819170933.5c4c6a38@oasis.local.home>
 <20210819204204.00f9ad28@rorschach.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210819204204.00f9ad28@rorschach.local.home>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 19, 2021 at 08:42:04PM -0400, Steven Rostedt wrote:
> On Thu, 19 Aug 2021 17:09:33 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Mathieu, seems that the "slow down 10x" patch was able to be backported
> > to 5.10, where as this patch was not. Reason being is that
> > start_poll_synchronize_rcu() was added in 5.13.
> 
> I can get this to work if I backport the following RCU patches:
> 
> 29d2bb94a8a126ce80ffbb433b648b32fdea524e
> srcu: Provide internal interface to start a Tree SRCU grace period
> 
> 5358c9fa54b09b5d3d7811b033aa0838c1bbaaf2
> srcu: Provide polling interfaces for Tree SRCU grace periods
> 
> 1a893c711a600ab57526619b56e6f6b7be00956e
> srcu: Provide internal interface to start a Tiny SRCU grace period
> 
> 8b5bd67cf6422b63ee100d76d8de8960ca2df7f0
> srcu: Provide polling interfaces for Tiny SRCU grace periods
> 
> The first three can be cherry-picked without issue. The last one has a
> small conflict, of:
> 
> include/linux/srcutiny.h.rej:
> --- include/linux/srcutiny.h
> +++ include/linux/srcutiny.h
> @@ -16,6 +16,7 @@
>  struct srcu_struct {
>         short srcu_lock_nesting[2];     /* srcu_read_lock() nesting depth. */
>         unsigned short srcu_idx;        /* Current reader array element in bit 0x2. */
> +       unsigned short srcu_idx_max;    /* Furthest future srcu_idx request. */
>         u8 srcu_gp_running;             /* GP workqueue running? */
>         u8 srcu_gp_waiting;             /* GP waiting for readers? */
>         struct swait_queue_head srcu_wq;
> 
> 
> Which I just added that line, and everything worked.
> 
> Paul, do you have any issues with these four patches getting backported?

I believe that you also need to backport 74612a07b83f ("srcu: Make Tiny
SRCU use multi-bit grace-period counter").  Otherwise, Tiny SRCU polling
grace periods will be at best working by accident.

This will also make your small conflict go away.

							Thanx, Paul

> Greg, Are you OK with them too?
> 
> Once those are backported, this patch can be backported as well, and
> everything should work. This patch really needs to stay with:
> 
> 231264d6927f6740af36855a622d0e240be9d94c
> tracepoint: Fix static call function vs data state mismatch
> 
> Otherwise I would say to revert it if this one can't be backported with
> it.
> 
> -- Steve
