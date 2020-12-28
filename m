Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047BF2E3680
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgL1LeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:34:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:57918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727266AbgL1LeL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 06:34:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2169E229C6;
        Mon, 28 Dec 2020 11:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609155210;
        bh=mYhMQSWtJDDv0Iib83f7Tl4ZL9v/d0xJ9BXaMzJonB4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wdqij7gzDR+Ukvmesk4qBlF3VzoCfv1ijXUc76tjPzwdjOs2o8v2QBoJEXX02cyxw
         t+mMSIGcBWF6RgZUaBEQiZgVJ4uEu//aCoZVkV7sS3VuhXB99KmpnYreHG5SFUDxRS
         JcS91okyLBpURcuxMJy0gvXjBQoI9lPVuWDEXF+8=
Date:   Mon, 28 Dec 2020 12:31:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Shaoying Xu <shaoyi@amazon.com>
Cc:     stable@vger.kernel.org, fllinden@amazon.com, samjonas@amazon.com,
        surajjs@amazon.com
Subject: Re: [PATCH 4.14] mm: memcontrol: fix excessive complexity in
 memory.stat reporting
Message-ID: <X+nCCxUcxYhpZgom@kroah.com>
References: <20201221193531.GA10070@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201221193531.GA10070@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 21, 2020 at 07:35:31PM +0000, Shaoying Xu wrote:
> From: Johannes Weiner <hannes@cmpxchg.org>
> 
> [ Upstream commit a983b5ebee57209c99f68c8327072f25e0e6e3da ]
> 
> We've seen memory.stat reads in top-level cgroups take up to fourteen
> seconds during a userspace bug that created tens of thousands of ghost
> cgroups pinned by lingering page cache.
> 
> Even with a more reasonable number of cgroups, aggregating memory.stat
> is unnecessarily heavy.  The complexity is this:
> 
> 	nr_cgroups * nr_stat_items * nr_possible_cpus
> 
> where the stat items are ~70 at this point.  With 128 cgroups and 128
> CPUs - decent, not enormous setups - reading the top-level memory.stat
> has to aggregate over a million per-cpu counters.  This doesn't scale.
> 
> Instead of spreading the source of truth across all CPUs, use the
> per-cpu counters merely to batch updates to shared atomic counters.
> 
> This is the same as the per-cpu stocks we use for charging memory to the
> shared atomic page_counters, and also the way the global vmstat counters
> are implemented.
> 
> Vmstat has elaborate spilling thresholds that depend on the number of
> CPUs, amount of memory, and memory pressure - carefully balancing the
> cost of counter updates with the amount of per-cpu error.  That's
> because the vmstat counters are system-wide, but also used for decisions
> inside the kernel (e.g.  NR_FREE_PAGES in the allocator).  Neither is
> true for the memory controller.
> 
> Use the same static batch size we already use for page_counter updates
> during charging.  The per-cpu error in the stats will be 128k, which is
> an acceptable ratio of cores to memory accounting granularity.
> 
> [hannes@cmpxchg.org: fix warning in __this_cpu_xchg() calls]
>   Link: http://lkml.kernel.org/r/20171201135750.GB8097@cmpxchg.org
> Link: http://lkml.kernel.org/r/20171103153336.24044-3-hannes@cmpxchg.org
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: stable@vger.kernel.org c9019e9: mm: memcontrol: eliminate raw access to stat and event counters
> Cc: stable@vger.kernel.org 2845426: mm: memcontrol: implement lruvec stat functions on top of each other
> Cc: stable@vger.kernel.org
> [shaoyi@amazon.com: resolved the conflict brought by commit 17ffa29c355658c8e9b19f56cbf0388500ca7905 in mm/memcontrol.c by contextual fix]
> Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
> ---
> The excessive complexity in memory.stat reporting was fixed in v4.16 but didn't appear to make it to 4.14 stable. When backporting this patch, there is a small conflict brought by commit 17ffa29c355658c8e9b19f56cbf0388500ca7905 within free_mem_cgroup_per_node_info() of mm/memcontrol.c and can be resolved by contextual fix.
> 
>  include/linux/memcontrol.h |  96 +++++++++++++++++++++++++++---------------
>  mm/memcontrol.c            | 101 +++++++++++++++++++++++----------------------
>  2 files changed, 113 insertions(+), 84 deletions(-)

This patch does not apply to the 4.14.y tree, please fix it up and
resend it if you wish to see it applied there.

thanks,

greg k-h
