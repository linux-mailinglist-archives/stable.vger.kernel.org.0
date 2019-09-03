Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAD8A6881
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 14:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbfICMWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 08:22:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:47128 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726631AbfICMWX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 08:22:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8C35AB049;
        Tue,  3 Sep 2019 12:22:21 +0000 (UTC)
Date:   Tue, 3 Sep 2019 14:22:21 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc:     Thomas Lindroth <thomas.lindroth@gmail.com>, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [BUG] Early OOM and kernel NULL pointer dereference in 4.19.69
Message-ID: <20190903122221.GV14028@dhcp22.suse.cz>
References: <31131c2d-a936-8bbf-e58d-a3baaa457340@gmail.com>
 <20190902071617.GC14028@dhcp22.suse.cz>
 <a07da432-1fc1-67de-ae35-93f157bf9a7d@gmail.com>
 <20190903074132.GM14028@dhcp22.suse.cz>
 <84c47d16-ff5a-9af0-efd4-5ef78d302170@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84c47d16-ff5a-9af0-efd4-5ef78d302170@virtuozzo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 03-09-19 15:05:22, Andrey Ryabinin wrote:
> 
> 
> On 9/3/19 10:41 AM, Michal Hocko wrote:
> > On Mon 02-09-19 21:34:29, Thomas Lindroth wrote:
> >> On 9/2/19 9:16 AM, Michal Hocko wrote:
> >>> On Sun 01-09-19 22:43:05, Thomas Lindroth wrote:
> >>>> After upgrading to the 4.19 series I've started getting problems with
> >>>> early OOM.
> >>>
> >>> What is the kenrel you have updated from? Would it be possible to try
> >>> the current Linus' tree?
> >>
> >> I did some more testing and it turns out this is not a regression after all.
> >>
> >> I followed up on my hunch and monitored memory.kmem.max_usage_in_bytes while
> >> running cgexec -g memory:12G bash -c 'find / -xdev -type f -print0 | \
> >>         xargs -0 -n 1 -P 8 stat > /dev/null'
> >>
> >> Just as memory.kmem.max_usage_in_bytes = memory.kmem.limit_in_bytes the OOM
> >> killer kicked in and killed my X server.
> >>
> >> Using the find|stat approach it was easy to test the problem in a testing VM.
> >> I was able to reproduce the problem in all these kernels:
> >>   4.9.0
> >>   4.14.0
> >>   4.14.115
> >>   4.19.0
> >>   5.2.11
> >>
> >> 5.3-rc6 didn't build in the VM. The build environment is too old probably.
> >>
> >> I was curious why I initially couldn't reproduce the problem in 4.14 by
> >> building chromium. I was again able to successfully build chromium using
> >> 4.14.115. Turns out memory.kmem.max_usage_in_bytes was 1015689216 after
> >> building and my limit is set to 1073741824. I guess some unrelated change in
> >> memory management raised that slightly for 4.19 triggering the problem.
> >>
> >> If you want to reproduce for yourself here are the steps:
> >> 1. build any kernel above 4.9 using something like my .config
> >> 2. setup a v1 memory cgroup with memory.kmem.limit_in_bytes lower than
> >>    memory.limit_in_bytes. I used 100M in my testing VM.
> >> 3. Run "find / -xdev -type f -print0 | xargs -0 -n 1 -P 8 stat > /dev/null"
> >>    in the cgroup.
> >> 4. Assuming there is enough inodes on the rootfs the global OOM killer
> >>    should kick in when memory.kmem.max_usage_in_bytes =
> >>    memory.kmem.limit_in_bytes and kill something outside the cgroup.
> > 
> > This is certainly a bug. Is this still an OOM triggered from
> > pagefault_out_of_memory? Since 4.19 (29ef680ae7c21) the memcg charge
> > path should invoke the memcg oom killer directly from the charge path.
> > If that doesn't happen then the failing charge is either GFP_NOFS or a
> > large allocation.
> > 
> > The former has been fixed just recently by http://lkml.kernel.org/r/cbe54ed1-b6ba-a056-8899-2dc42526371d@i-love.sakura.ne.jp
> > and I suspect this is a fix you are looking for. Although it is curious
> > that you can see a global oom even before because the charge path would
> > mark an oom situation even for NOFS context and it should trigger the
> > memcg oom killer on the way out from the page fault path. So essentially
> > the same call trace except the oom killer should be constrained to the
> > memcg context.
> > 
> > Could you try the above patch please?
> > 
> 
> It won't help. We hitting ->kmem limit here, not the ->memory or ->memsw, so try_charge() is successful and
> only __memcg_kmem_charge_memcg() fails to charge ->kmem and returns -ENOMEM.
> 
> Limiting kmem just never worked and it doesn't work now. AFAIK this feature hasn't been finished because 
> there was no clear purpose/use case found. I remember that there was some discussion on lsfmm about this https://lwn.net/Articles/636331/
> but I don't remember the discussion itself.

Ohh, right you are. I completely forgot that __memcg_kmem_charge_memcg
doesn't really trigger the normal charge path but rather charge the
counter directly.

So you are right. The v1 kmem accounting is broken and probably
unfixable. Do not use it.

Thanks!

-- 
Michal Hocko
SUSE Labs
