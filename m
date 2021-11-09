Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5FE844B1CB
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 18:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhKIRSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 12:18:22 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:46186 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235222AbhKIRSV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 12:18:21 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id F3E571FD34;
        Tue,  9 Nov 2021 17:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1636478134; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w2u1c/OVbCzJIJ5761FcTJUE1XzuOMfSX3Bnp8Mme7s=;
        b=ZwQV9ABZLTcCLrPTJXvGjA+CksqOScnFQ8y0snD8Rj9xiiHPpSSUpj06oAM7Oxqgy0kvMt
        Jxkr/KioI9GmfnXam3MDeBKl9K/OCjxRfLkcFPCuRSbcGuZEhgA6MLKgWN+4ynU3ZVoEI7
        LIW5/W375caR/JxKMeZFxQZVyx26PGo=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id AFE77A3B83;
        Tue,  9 Nov 2021 17:15:33 +0000 (UTC)
Date:   Tue, 9 Nov 2021 18:15:33 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Alexey Makhalov <amakhalov@vmware.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] mm: fix panic in __alloc_pages
Message-ID: <YYqstfX8PSGDfWsn@dhcp22.suse.cz>
References: <908909e0-4815-b580-7ff5-d824d36a141c@redhat.com>
 <20211108202325.20304-1-amakhalov@vmware.com>
 <2e191db3-286f-90c6-bf96-3f89891e9926@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e191db3-286f-90c6-bf96-3f89891e9926@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 08-11-21 18:08:52, Eric Dumazet wrote:
> 
> 
> On 11/8/21 12:23 PM, Alexey Makhalov wrote:
> > There is a kernel panic caused by pcpu_alloc_pages() passing
> > offlined and uninitialized node to alloc_pages_node() leading
> > to panic by NULL dereferencing uninitialized NODE_DATA(nid).
> > 
> >  CPU2 has been hot-added
> >  BUG: unable to handle page fault for address: 0000000000001608
> >  #PF: supervisor read access in kernel mode
> >  #PF: error_code(0x0000) - not-present page
> >  PGD 0 P4D 0
> >  Oops: 0000 [#1] SMP PTI
> >  CPU: 0 PID: 1 Comm: systemd Tainted: G            E     5.15.0-rc7+ #11
> >  Hardware name: VMware, Inc. VMware7,1/440BX Desktop Reference Platform, BIOS VMW
> > 
> >  RIP: 0010:__alloc_pages+0x127/0x290
> >  Code: 4c 89 f0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 44 89 e0 48 8b 55 b8 c1 e8 0c 83 e0 01 88 45 d0 4c 89 c8 48 85 d2 0f 85 1a 01 00 00 <45> 3b 41 08 0f 82 10 01 00 00 48 89 45 c0 48 8b 00 44 89 e2 81 e2
> >  RSP: 0018:ffffc900006f3bc8 EFLAGS: 00010246
> >  RAX: 0000000000001600 RBX: 0000000000000000 RCX: 0000000000000000
> >  RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000cc2
> >  RBP: ffffc900006f3c18 R08: 0000000000000001 R09: 0000000000001600
> >  R10: ffffc900006f3a40 R11: ffff88813c9fffe8 R12: 0000000000000cc2
> >  R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000cc2
> >  FS:  00007f27ead70500(0000) GS:ffff88807ce00000(0000) knlGS:0000000000000000
> >  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >  CR2: 0000000000001608 CR3: 000000000582c003 CR4: 00000000001706b0
> >  Call Trace:
> >   pcpu_alloc_pages.constprop.0+0xe4/0x1c0
> >   pcpu_populate_chunk+0x33/0xb0
> >   pcpu_alloc+0x4d3/0x6f0
> >   __alloc_percpu_gfp+0xd/0x10
> >   alloc_mem_cgroup_per_node_info+0x54/0xb0
> >   mem_cgroup_alloc+0xed/0x2f0
> >   mem_cgroup_css_alloc+0x33/0x2f0
> >   css_create+0x3a/0x1f0
> >   cgroup_apply_control_enable+0x12b/0x150
> >   cgroup_mkdir+0xdd/0x110
> >   kernfs_iop_mkdir+0x4f/0x80
> >   vfs_mkdir+0x178/0x230
> >   do_mkdirat+0xfd/0x120
> >   __x64_sys_mkdir+0x47/0x70
> >   ? syscall_exit_to_user_mode+0x21/0x50
> >   do_syscall_64+0x43/0x90
> >   entry_SYSCALL_64_after_hwframe+0x44/0xae
> > 
> > Panic can be easily reproduced by disabling udev rule for
> > automatic onlining hot added CPU followed by CPU with
> > memoryless node (NUMA node with CPU only) hot add.
> > 
> > Hot adding CPU and memoryless node does not bring the node
> > to online state. Memoryless node will be onlined only during
> > the onlining its CPU.
> > 
> > Node can be in one of the following states:
> > 1. not present.(nid == NUMA_NO_NODE)
> > 2. present, but offline (nid > NUMA_NO_NODE, node_online(nid) == 0,
> > 				NODE_DATA(nid) == NULL)
> > 3. present and online (nid > NUMA_NO_NODE, node_online(nid) > 0,
> > 				NODE_DATA(nid) != NULL)
> > 
> > Percpu code is doing allocations for all possible CPUs. The
> > issue happens when it serves hot added but not yet onlined
> > CPU when its node is in 2nd state. This node is not ready
> > to use, fallback to numa_mem_id().
> > 
> > Signed-off-by: Alexey Makhalov <amakhalov@vmware.com>
> > Reviewed-by: David Hildenbrand <david@redhat.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Michal Hocko <mhocko@suse.com>
> > Cc: Oscar Salvador <osalvador@suse.de>
> > Cc: Dennis Zhou <dennis@kernel.org>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Christoph Lameter <cl@linux.com>
> > Cc: linux-mm@kvack.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: stable@vger.kernel.org
> > ---
> >  mm/percpu-vm.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
> > index 2054c9213..f58d73c92 100644
> > --- a/mm/percpu-vm.c
> > +++ b/mm/percpu-vm.c
> > @@ -84,15 +84,19 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
> >  			    gfp_t gfp)
> >  {
> >  	unsigned int cpu, tcpu;
> > -	int i;
> > +	int i, nid;
> >  
> >  	gfp |= __GFP_HIGHMEM;
> >  
> >  	for_each_possible_cpu(cpu) {
> > +		nid = cpu_to_node(cpu);
> > +		if (nid == NUMA_NO_NODE || !node_online(nid))
> > +			nid = numa_mem_id();
> 
> Maybe we should fail this fallback if (gfp & __GFP_THISNODE) ?
> 
> Or maybe there is no support for this constraint in per-cpu allocator anyway.

I would be really curious about the usecase. Not to mention that pcp
allocation would be effectively unusable on any setups with memory less
nodes.

> I am a bit worried that we do not really know if pages are
> allocated on the right node or not.

There hasn't been any guarantee like that. Page allocator would fallback
to other nodes (in the node distance order) unless __GFP_THISNODE is
specified. This patch just papers over the fact that currently we can
end up having an invalid numa node associated with a cpu. This is a bug
in the initialization code. Even if that is fixed the node fallback is
still a real thing that might happen.

-- 
Michal Hocko
SUSE Labs
