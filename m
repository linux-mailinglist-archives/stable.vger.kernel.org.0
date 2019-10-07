Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDFDFCDCF7
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 10:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfJGIQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 04:16:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:56004 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726889AbfJGIQZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Oct 2019 04:16:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1DC79AD45;
        Mon,  7 Oct 2019 08:16:23 +0000 (UTC)
Date:   Mon, 7 Oct 2019 10:16:21 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Qian Cai <cai@lca.pw>
Cc:     akpm@linux-foundation.org, tj@kernel.org, vdavydov.dev@gmail.com,
        hannes@cmpxchg.org, guro@fb.com, cl@linux.com, penberg@kernel.org,
        rientjes@google.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/slub: fix a deadlock in show_slab_objects()
Message-ID: <20191007081621.GE2381@dhcp22.suse.cz>
References: <1570192309-10132-1-git-send-email-cai@lca.pw>
 <20191004125701.GJ9578@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004125701.GJ9578@dhcp22.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 04-10-19 14:57:01, Michal Hocko wrote:
> On Fri 04-10-19 08:31:49, Qian Cai wrote:
> > Long time ago, there fixed a similar deadlock in show_slab_objects()
> > [1]. However, it is apparently due to the commits like 01fb58bcba63
> > ("slab: remove synchronous synchronize_sched() from memcg cache
> > deactivation path") and 03afc0e25f7f ("slab: get_online_mems for
> > kmem_cache_{create,destroy,shrink}"), this kind of deadlock is back by
> > just reading files in /sys/kernel/slab which will generate a lockdep
> > splat below.
> > 
> > Since the "mem_hotplug_lock" here is only to obtain a stable online node
> > mask while racing with NUMA node hotplug, in the worst case, the results
> > may me miscalculated while doing NUMA node hotplug, but they shall be
> > corrected by later reads of the same files.
> 
> I think it is important to mention that this doesn't expose the
> show_slab_objects to use-after-free. There is only a single path that
> might really race here and that is the slab hotplug notifier callback
> __kmem_cache_shrink (via slab_mem_going_offline_callback) but that path
> doesn't really destroy kmem_cache_node data structures.

Andrew, please add this to the changelog so that we do not have to
scratch heads again when looking into that code.

Thanks!
-- 
Michal Hocko
SUSE Labs
