Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1EFC1B0AB
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 09:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbfEMHCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 03:02:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbfEMHCR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 May 2019 03:02:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E960E20B7C;
        Mon, 13 May 2019 07:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557730936;
        bh=bT3ak87mHPOn/6qzmCm3Jho7/L4DKAETYvoo3+eBUqY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jO7KprTNDJQMrxqqhWUNHHaFgScJGY1zYd9dCxmZPvnK+wiWF//WbPh18bDM/24nO
         G5LYSxV2L7+/5DpYnaMegQlQSmMQdZzDOlhIAFkFgGLlzPhelwohmSgOmZYBtlAJAI
         SRhqybZbIHjOEJecBGeqjLtEYL0NGJ7wxbbbdIRE=
Date:   Mon, 13 May 2019 09:02:14 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daniel Wagner <wagi@monom.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Subject: Re: [PATCH v4.4.y] mm, vmstat: make quiet_vmstat lighter
Message-ID: <20190513070214.GA26553@kroah.com>
References: <20190513061237.4915-1-wagi@monom.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190513061237.4915-1-wagi@monom.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 13, 2019 at 08:12:37AM +0200, Daniel Wagner wrote:
> From: Michal Hocko <mhocko@suse.com>
> 
> [ Upstream commit f01f17d3705bb6081c9e5728078f64067982be36 ]
> 
> Mike has reported a considerable overhead of refresh_cpu_vm_stats from
> the idle entry during pipe test:
> 
>     12.89%  [kernel]       [k] refresh_cpu_vm_stats.isra.12
>      4.75%  [kernel]       [k] __schedule
>      4.70%  [kernel]       [k] mutex_unlock
>      3.14%  [kernel]       [k] __switch_to
> 
> This is caused by commit 0eb77e988032 ("vmstat: make vmstat_updater
> deferrable again and shut down on idle") which has placed quiet_vmstat
> into cpu_idle_loop.  The main reason here seems to be that the idle
> entry has to get over all zones and perform atomic operations for each
> vmstat entry even though there might be no per cpu diffs.  This is a
> pointless overhead for _each_ idle entry.
> 
> Make sure that quiet_vmstat is as light as possible.
> 
> First of all it doesn't make any sense to do any local sync if the
> current cpu is already set in oncpu_stat_off because vmstat_update puts
> itself there only if there is nothing to do.
> 
> Then we can check need_update which should be a cheap way to check for
> potential per-cpu diffs and only then do refresh_cpu_vm_stats.
> 
> The original patch also did cancel_delayed_work which we are not doing
> here.  There are two reasons for that.  Firstly cancel_delayed_work from
> idle context will blow up on RT kernels (reported by Mike):
> 
>   CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.5.0-rt3 #7
>   Hardware name: MEDION MS-7848/MS-7848, BIOS M7848W08.20C 09/23/2013
>   Call Trace:
>     dump_stack+0x49/0x67
>     ___might_sleep+0xf5/0x180
>     rt_spin_lock+0x20/0x50
>     try_to_grab_pending+0x69/0x240
>     cancel_delayed_work+0x26/0xe0
>     quiet_vmstat+0x75/0xa0
>     cpu_idle_loop+0x38/0x3e0
>     cpu_startup_entry+0x13/0x20
>     start_secondary+0x114/0x140
> 
> And secondly, even on !RT kernels it might add some non trivial overhead
> which is not necessary.  Even if the vmstat worker wakes up and preempts
> idle then it will be most likely a single shot noop because the stats
> were already synced and so it would end up on the oncpu_stat_off anyway.
> We just need to teach both vmstat_shepherd and vmstat_update to stop
> scheduling the worker if there is nothing to do.
> 
> [mgalbraith@suse.de: cancel pending work of the cpu_stat_off CPU]
> Signed-off-by: Michal Hocko <mhocko@suse.com>
> Reported-by: Mike Galbraith <umgwanakikbuti@gmail.com>
> Acked-by: Christoph Lameter <cl@linux.com>
> Signed-off-by: Mike Galbraith <mgalbraith@suse.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Daniel Wagner <wagi@monom.org>
> ---
> Hi Greg,
> 
> Upstream commmit 0eb77e988032 ("vmstat: make vmstat_updater deferrable
> again and shut down on idle") was back ported in v4.4.178
> (bdf3c006b9a2). For -rt we definitely need the bugfix f01f17d3705b
> ("mm, vmstat: make quiet_vmstat lighter") as well.
> 
> Since the offending patch was back ported to v4.4 stable only, the
> other stable branches don't need an update (offending patch and bug
> fix are already in).
> 
> Could you please queue the above patch for v4.4.y?

Now queued up, thanks.

greg k-h
