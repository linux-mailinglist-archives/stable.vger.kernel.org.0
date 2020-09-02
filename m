Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89FAD25A8F5
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 11:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgIBJxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 05:53:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:44030 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbgIBJxF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Sep 2020 05:53:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 534BBAE92;
        Wed,  2 Sep 2020 09:53:03 +0000 (UTC)
Subject: Re: [PATCH v2 00/28] The new cgroup slab memory controller
To:     Pavel Tatashin <pasha.tatashin@soleen.com>,
        Roman Gushchin <guro@fb.com>
Cc:     Bharata B Rao <bharata@linux.ibm.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@kernel.org>
References: <20200127173453.2089565-1-guro@fb.com>
 <20200130020626.GA21973@in.ibm.com>
 <20200130024135.GA14994@xps.DHCP.thefacebook.com>
 <CA+CK2bCQcnTpzq2wGFa3D50PtKwBoWbDBm56S9y8c+j+pD+KSw@mail.gmail.com>
 <20200813000416.GA1592467@carbon.dhcp.thefacebook.com>
 <CA+CK2bDDToW=Q5RgeWkoN3_rUr3pyWGVb9MraTzM+DM3OZ+tdg@mail.gmail.com>
 <CA+CK2bBEHFuLLg79_h6bv4Vey+B0B2YXyBxTBa=Le12OKbNdwA@mail.gmail.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <6469324e-afa2-18b4-81fb-9e96466c1bf3@suse.cz>
Date:   Wed, 2 Sep 2020 11:53:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CA+CK2bBEHFuLLg79_h6bv4Vey+B0B2YXyBxTBa=Le12OKbNdwA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/28/20 6:47 PM, Pavel Tatashin wrote:
> There appears to be another problem that is related to the
> cgroup_mutex -> mem_hotplug_lock deadlock described above.
> 
> In the original deadlock that I described, the workaround is to
> replace crash dump from piping to Linux traditional save to files
> method. However, after trying this workaround, I still observed
> hardware watchdog resets during machine  shutdown.
> 
> The new problem occurs for the following reason: upon shutdown systemd
> calls a service that hot-removes memory, and if hot-removing fails for

Why is that hotremove even needed if we're shutting down? Are there any
(virtualization?) platforms where it makes some difference over plain
shutdown/restart?

> some reason systemd kills that service after timeout. However, systemd
> is never able to kill the service, and we get hardware reset caused by
> watchdog or a hang during shutdown:
> 
> Thread #1: memory hot-remove systemd service
> Loops indefinitely, because if there is something still to be migrated
> this loop never terminates. However, this loop can be terminated via
> signal from systemd after timeout.
> __offline_pages()
>       do {
>           pfn = scan_movable_pages(pfn, end_pfn);
>                   # Returns 0, meaning there is nothing available to
>                   # migrate, no page is PageLRU(page)
>           ...
>           ret = walk_system_ram_range(start_pfn, end_pfn - start_pfn,
>                                             NULL, check_pages_isolated_cb);
>                   # Returns -EBUSY, meaning there is at least one PFN that
>                   # still has to be migrated.
>       } while (ret);
> 
> Thread #2: ccs killer kthread
>    css_killed_work_fn
>      cgroup_mutex  <- Grab this Mutex
>      mem_cgroup_css_offline
>        memcg_offline_kmem.part
>           memcg_deactivate_kmem_caches
>             get_online_mems
>               mem_hotplug_lock <- waits for Thread#1 to get read access
> 
> Thread #3: systemd
> ksys_read
>  vfs_read
>    __vfs_read
>      seq_read
>        proc_single_show
>          proc_cgroup_show
>            mutex_lock -> wait for cgroup_mutex that is owned by Thread #2
> 
> Thus, thread #3 systemd stuck, and unable to deliver timeout interrupt
> to thread #1.
> 
> The proper fix for both of the problems is to avoid cgroup_mutex ->
> mem_hotplug_lock ordering that was recently fixed in the mainline but
> still present in all stable branches. Unfortunately, I do not see a
> simple fix in how to remove mem_hotplug_lock from
> memcg_deactivate_kmem_caches without using Roman's series that is too
> big for stable.
> 
> Thanks,
> Pasha
> 
> On Wed, Aug 12, 2020 at 8:31 PM Pavel Tatashin
> <pasha.tatashin@soleen.com> wrote:
>>
>> On Wed, Aug 12, 2020 at 8:04 PM Roman Gushchin <guro@fb.com> wrote:
>> >
>> > On Wed, Aug 12, 2020 at 07:16:08PM -0400, Pavel Tatashin wrote:
>> > > Guys,
>> > >
>> > > There is a convoluted deadlock that I just root caused, and that is
>> > > fixed by this work (at least based on my code inspection it appears to
>> > > be fixed); but the deadlock exists in older and stable kernels, and I
>> > > am not sure whether to create a separate patch for it, or backport
>> > > this whole thing.
>> >
>>
>> Hi Roman,
>>
>> > Hi Pavel,
>> >
>> > wow, it's a quite complicated deadlock. Thank you for providing
>> > a perfect analysis!
>>
>> Thank you, it indeed took me a while to fully grasp the deadlock.
>>
>> >
>> > Unfortunately, backporting the whole new slab controller isn't an option:
>> > it's way too big and invasive.
>>
>> This is what I thought as well, this is why I want to figure out what
>> is the best way forward.
>>
>> > Do you already have a standalone fix?
>>
>> Not yet, I do not have a standalone fix. I suspect the best fix would
>> be to address fix css_killed_work_fn() stack so we never have:
>> cgroup_mutex -> mem_hotplug_lock. Either decoupling them or reverse
>> the order would work. If you have suggestions since you worked on this
>> code recently, please let me know.
>>
>> Thank you,
>> Pasha
>>
>> >
>> > Thanks!
>> >
>> >
>> > >
>> > > Thread #1: Hot-removes memory
>> > > device_offline
>> > >   memory_subsys_offline
>> > >     offline_pages
>> > >       __offline_pages
>> > >         mem_hotplug_lock <- write access
>> > >       waits for Thread #3 refcnt for pfn 9e5113 to get to 1 so it can
>> > > migrate it.
>> > >
>> > > Thread #2: ccs killer kthread
>> > >    css_killed_work_fn
>> > >      cgroup_mutex  <- Grab this Mutex
>> > >      mem_cgroup_css_offline
>> > >        memcg_offline_kmem.part
>> > >           memcg_deactivate_kmem_caches
>> > >             get_online_mems
>> > >               mem_hotplug_lock <- waits for Thread#1 to get read access
>> > >
>> > > Thread #3: crashing userland program
>> > > do_coredump
>> > >   elf_core_dump
>> > >       get_dump_page() -> get page with pfn#9e5113, and increment refcnt
>> > >       dump_emit
>> > >         __kernel_write
>> > >           __vfs_write
>> > >             new_sync_write
>> > >               pipe_write
>> > >                 pipe_wait   -> waits for Thread #4 systemd-coredump to
>> > > read the pipe
>> > >
>> > > Thread #4: systemd-coredump
>> > > ksys_read
>> > >   vfs_read
>> > >     __vfs_read
>> > >       seq_read
>> > >         proc_single_show
>> > >           proc_cgroup_show
>> > >             cgroup_mutex -> waits from Thread #2 for this lock.
>> >
>> > >
>> > > In Summary:
>> > > Thread#1 waits for Thread#3 for refcnt, Thread#3 waits for Thread#4 to
>> > > read pipe. Thread#4 waits for Thread#2 for cgroup_mutex lock; Thread#2
>> > > waits for Thread#1 for mem_hotplug_lock rwlock.
>> > >
>> > > This work appears to fix this deadlock because cgroup_mutex is not
>> > > called anymore before mem_hotplug_lock (unless I am missing it), as it
>> > > removes memcg_deactivate_kmem_caches.
>> > >
>> > > Thank you,
>> > > Pasha
>> > >
>> > > On Wed, Jan 29, 2020 at 9:42 PM Roman Gushchin <guro@fb.com> wrote:
>> > > >
>> > > > On Thu, Jan 30, 2020 at 07:36:26AM +0530, Bharata B Rao wrote:
>> > > > > On Mon, Jan 27, 2020 at 09:34:25AM -0800, Roman Gushchin wrote:
>> > > > > > The existing cgroup slab memory controller is based on the idea of
>> > > > > > replicating slab allocator internals for each memory cgroup.
>> > > > > > This approach promises a low memory overhead (one pointer per page),
>> > > > > > and isn't adding too much code on hot allocation and release paths.
>> > > > > > But is has a very serious flaw: it leads to a low slab utilization.
>> > > > > >
>> > > > > > Using a drgn* script I've got an estimation of slab utilization on
>> > > > > > a number of machines running different production workloads. In most
>> > > > > > cases it was between 45% and 65%, and the best number I've seen was
>> > > > > > around 85%. Turning kmem accounting off brings it to high 90s. Also
>> > > > > > it brings back 30-50% of slab memory. It means that the real price
>> > > > > > of the existing slab memory controller is way bigger than a pointer
>> > > > > > per page.
>> > > > > >
>> > > > > > The real reason why the existing design leads to a low slab utilization
>> > > > > > is simple: slab pages are used exclusively by one memory cgroup.
>> > > > > > If there are only few allocations of certain size made by a cgroup,
>> > > > > > or if some active objects (e.g. dentries) are left after the cgroup is
>> > > > > > deleted, or the cgroup contains a single-threaded application which is
>> > > > > > barely allocating any kernel objects, but does it every time on a new CPU:
>> > > > > > in all these cases the resulting slab utilization is very low.
>> > > > > > If kmem accounting is off, the kernel is able to use free space
>> > > > > > on slab pages for other allocations.
>> > > > > >
>> > > > > > Arguably it wasn't an issue back to days when the kmem controller was
>> > > > > > introduced and was an opt-in feature, which had to be turned on
>> > > > > > individually for each memory cgroup. But now it's turned on by default
>> > > > > > on both cgroup v1 and v2. And modern systemd-based systems tend to
>> > > > > > create a large number of cgroups.
>> > > > > >
>> > > > > > This patchset provides a new implementation of the slab memory controller,
>> > > > > > which aims to reach a much better slab utilization by sharing slab pages
>> > > > > > between multiple memory cgroups. Below is the short description of the new
>> > > > > > design (more details in commit messages).
>> > > > > >
>> > > > > > Accounting is performed per-object instead of per-page. Slab-related
>> > > > > > vmstat counters are converted to bytes. Charging is performed on page-basis,
>> > > > > > with rounding up and remembering leftovers.
>> > > > > >
>> > > > > > Memcg ownership data is stored in a per-slab-page vector: for each slab page
>> > > > > > a vector of corresponding size is allocated. To keep slab memory reparenting
>> > > > > > working, instead of saving a pointer to the memory cgroup directly an
>> > > > > > intermediate object is used. It's simply a pointer to a memcg (which can be
>> > > > > > easily changed to the parent) with a built-in reference counter. This scheme
>> > > > > > allows to reparent all allocated objects without walking them over and
>> > > > > > changing memcg pointer to the parent.
>> > > > > >
>> > > > > > Instead of creating an individual set of kmem_caches for each memory cgroup,
>> > > > > > two global sets are used: the root set for non-accounted and root-cgroup
>> > > > > > allocations and the second set for all other allocations. This allows to
>> > > > > > simplify the lifetime management of individual kmem_caches: they are
>> > > > > > destroyed with root counterparts. It allows to remove a good amount of code
>> > > > > > and make things generally simpler.
>> > > > > >
>> > > > > > The patchset* has been tested on a number of different workloads in our
>> > > > > > production. In all cases it saved significant amount of memory, measured
>> > > > > > from high hundreds of MBs to single GBs per host. On average, the size
>> > > > > > of slab memory has been reduced by 35-45%.
>> > > > >
>> > > > > Here are some numbers from multiple runs of sysbench and kernel compilation
>> > > > > with this patchset on a 10 core POWER8 host:
>> > > > >
>> > > > > ==========================================================================
>> > > > > Peak usage of memory.kmem.usage_in_bytes, memory.usage_in_bytes and
>> > > > > meminfo:Slab for Sysbench oltp_read_write with mysqld running as part
>> > > > > of a mem cgroup (Sampling every 5s)
>> > > > > --------------------------------------------------------------------------
>> > > > >                               5.5.0-rc7-mm1   +slab patch     %reduction
>> > > > > --------------------------------------------------------------------------
>> > > > > memory.kmem.usage_in_bytes    15859712        4456448         72
>> > > > > memory.usage_in_bytes         337510400       335806464       .5
>> > > > > Slab: (kB)                    814336          607296          25
>> > > > >
>> > > > > memory.kmem.usage_in_bytes    16187392        4653056         71
>> > > > > memory.usage_in_bytes         318832640       300154880       5
>> > > > > Slab: (kB)                    789888          559744          29
>> > > > > --------------------------------------------------------------------------
>> > > > >
>> > > > >
>> > > > > Peak usage of memory.kmem.usage_in_bytes, memory.usage_in_bytes and
>> > > > > meminfo:Slab for kernel compilation (make -s -j64) Compilation was
>> > > > > done from bash that is in a memory cgroup. (Sampling every 5s)
>> > > > > --------------------------------------------------------------------------
>> > > > >                               5.5.0-rc7-mm1   +slab patch     %reduction
>> > > > > --------------------------------------------------------------------------
>> > > > > memory.kmem.usage_in_bytes    338493440       231931904       31
>> > > > > memory.usage_in_bytes         7368015872      6275923968      15
>> > > > > Slab: (kB)                    1139072         785408          31
>> > > > >
>> > > > > memory.kmem.usage_in_bytes    341835776       236453888       30
>> > > > > memory.usage_in_bytes         6540427264      6072893440      7
>> > > > > Slab: (kB)                    1074304         761280          29
>> > > > >
>> > > > > memory.kmem.usage_in_bytes    340525056       233570304       31
>> > > > > memory.usage_in_bytes         6406209536      6177357824      3
>> > > > > Slab: (kB)                    1244288         739712          40
>> > > > > --------------------------------------------------------------------------
>> > > > >
>> > > > > Slab consumption right after boot
>> > > > > --------------------------------------------------------------------------
>> > > > >                               5.5.0-rc7-mm1   +slab patch     %reduction
>> > > > > --------------------------------------------------------------------------
>> > > > > Slab: (kB)                    821888          583424          29
>> > > > > ==========================================================================
>> > > > >
>> > > > > Summary:
>> > > > >
>> > > > > With sysbench and kernel compilation,  memory.kmem.usage_in_bytes shows
>> > > > > around 70% and 30% reduction consistently.
>> > > > >
>> > > > > Didn't see consistent reduction of memory.usage_in_bytes with sysbench and
>> > > > > kernel compilation.
>> > > > >
>> > > > > Slab usage (from /proc/meminfo) shows consistent 30% reduction and the
>> > > > > same is seen right after boot too.
>> > > >
>> > > > That's just perfect!
>> > > >
>> > > > memory.usage_in_bytes was most likely the same because the freed space
>> > > > was taken by pagecache.
>> > > >
>> > > > Thank you very much for testing!
>> > > >
>> > > > Roman
> 

