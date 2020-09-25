Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7CE27856A
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 12:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgIYKzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 06:55:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbgIYKzl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 06:55:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9414020809;
        Fri, 25 Sep 2020 10:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601031340;
        bh=1CGfR6nV/0roujv2jCFmWNNypuMeXMaY0JOYlD8nOqw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o/Mjf8rloCokxg1rcOAx6WCaezFdt+QJGHbz5lBgfhDEad7fgc7D0QeuusD/T5pFr
         lGQ84YY0Ah6PqppljUBdP3liHqW041nRnQKV/e9+GPoJ4Y7kNSo0NDSjrJnIfMvcAB
         +LKm26Ts+R5E7Zzn7UWLcQzgpovT60J7hmevbzpI=
Date:   Fri, 25 Sep 2020 12:55:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Julius Hemanth Pitti <jpitti@cisco.com>
Cc:     akpm@linux-foundation.org, xlpang@linux.alibaba.com,
        mhocko@suse.com, vdavydov.dev@gmail.com, ktkhai@virtuozzo.com,
        hannes@cmpxchg.org, stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, xe-linux-external@cisco.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH stable v5.4] mm: memcg: fix memcg reclaim soft lockup
Message-ID: <20200925105555.GA2525199@kroah.com>
References: <20200921180508.61905-1-jpitti@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921180508.61905-1-jpitti@cisco.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 21, 2020 at 11:05:08AM -0700, Julius Hemanth Pitti wrote:
> From: Xunlei Pang <xlpang@linux.alibaba.com>
> 
> commit e3336cab2579012b1e72b5265adf98e2d6e244ad upstream
> 
> We've met softlockup with "CONFIG_PREEMPT_NONE=y", when the target memcg
> doesn't have any reclaimable memory.
> 
> It can be easily reproduced as below:
> 
>   watchdog: BUG: soft lockup - CPU#0 stuck for 111s![memcg_test:2204]
>   CPU: 0 PID: 2204 Comm: memcg_test Not tainted 5.9.0-rc2+ #12
>   Call Trace:
>     shrink_lruvec+0x49f/0x640
>     shrink_node+0x2a6/0x6f0
>     do_try_to_free_pages+0xe9/0x3e0
>     try_to_free_mem_cgroup_pages+0xef/0x1f0
>     try_charge+0x2c1/0x750
>     mem_cgroup_charge+0xd7/0x240
>     __add_to_page_cache_locked+0x2fd/0x370
>     add_to_page_cache_lru+0x4a/0xc0
>     pagecache_get_page+0x10b/0x2f0
>     filemap_fault+0x661/0xad0
>     ext4_filemap_fault+0x2c/0x40
>     __do_fault+0x4d/0xf9
>     handle_mm_fault+0x1080/0x1790
> 
> It only happens on our 1-vcpu instances, because there's no chance for
> oom reaper to run to reclaim the to-be-killed process.
> 
> Add a cond_resched() at the upper shrink_node_memcgs() to solve this
> issue, this will mean that we will get a scheduling point for each memcg
> in the reclaimed hierarchy without any dependency on the reclaimable
> memory in that memcg thus making it more predictable.
> 
> [jpitti@cisco.com:
>    - backported to v5.4.y
>    - Upstream patch applies fix in shrink_node_memcgs(), which
>      is not present to v5.4.y. Appled to shrink_node()]

Thanks for this, now queued up here and for 4.19

greg k-h
