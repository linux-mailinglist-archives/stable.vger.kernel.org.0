Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4941373E1
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 17:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbgAJQnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 11:43:10 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:38384 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728209AbgAJQnK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jan 2020 11:43:10 -0500
Received: by mail-oi1-f193.google.com with SMTP id l9so2385440oii.5
        for <stable@vger.kernel.org>; Fri, 10 Jan 2020 08:43:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pR2iX18tjXNnoBPSNqNK9ys64+Jcpo7fZQg0i/s/+nw=;
        b=ZfnlIqumLx11xnTlrzHHA/io9dAA9rY70kuYDBhctQ7IN74tUElswBp7CxnhQVSYx6
         c7AliLu0EobfDfzf6WWjjjToJ/R+jDi4SkJGbj8HyR0wBR7pnweuEqQcLz7DEr3Jl+9h
         3+O7+at2eVX3wuSxLv44jSrpksEKmtyO18ZuvCWs8CeZq2Jq+f/Z06CX1GskGiwhlrLT
         qRxkFHFl9dvBJ98dRItwbnJ3XL2jDUasJ7Tp38uE7XOptpHR8CMay4k/RnSnvKgf81Wi
         aQLYeBZh90Gp3X+tCJgVu5qbQgslw4VFrYDfHLzNgseHrm6sLsHCq3oKthnEN1Czpu/0
         v7Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pR2iX18tjXNnoBPSNqNK9ys64+Jcpo7fZQg0i/s/+nw=;
        b=Rz5IQy5x+gLUUEqiwmSLrUDLd11WKUeDEPd/D8ddqV/aJVV9MCfByDmNzag480NhTf
         zjSUpujKRLxa9ss/rkw+zXThDWkx6H40ZTUm8mhdX5ZRJlj30IQuL1Ub3QtvoKOe08x+
         b+70gC1LeYOUKxfRPVBMinsoKDEigu3gHQ0CcvV5uqX/4FgM4uuo2fzvUnHDFD57Ek7j
         Zlr+KrehnvsMrWdk/Xhscfq8VEMCSfLcVS6RhGjpKPW9Rdn6YrK6gc4NUhembTlEwecj
         X/7DNS+THqdOvlTCJwb/EE2EGfLUfd0YWg6PTyYgjxyj1DtuNcwMEoq16lAA2nmxa8Bp
         CdpQ==
X-Gm-Message-State: APjAAAWdPG4CuslvbEXHyLfly/1yeTKXul9DHc2BkwtRTaMSX4pTSqIJ
        yQvA82U1R0tGzOnLyiB6cc3GoSUCPGDp4x1M1EqTYT/2
X-Google-Smtp-Source: APXvYqxK4i/HNBAk3rtkotV9R/sF7UURwsT3pfV5Edd4gerSvJPZ67eM19soRbqvumd2706szUR3iDfBazdnV/orM4s=
X-Received: by 2002:aca:3f54:: with SMTP id m81mr2723806oia.73.1578674589422;
 Fri, 10 Jan 2020 08:43:09 -0800 (PST)
MIME-Version: 1.0
References: <157863061737.2230556.3959730620803366776.stgit@dwillia2-desk3.amr.corp.intel.com>
 <e60e64f9-894b-4121-d97b-fb61459cbbe5@redhat.com>
In-Reply-To: <e60e64f9-894b-4121-d97b-fb61459cbbe5@redhat.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 10 Jan 2020 08:42:58 -0800
Message-ID: <CAPcyv4jm=fmP=-5vbo2jxzMe2qXqZP=zDYF8G_rs3X6_Om0wPg@mail.gmail.com>
Subject: Re: [PATCH] mm/memory_hotplug: Fix remove_memory() lockdep splat
To:     David Hildenbrand <david@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Michal Hocko <mhocko@suse.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 10, 2020 at 1:10 AM David Hildenbrand <david@redhat.com> wrote:
>
> On 10.01.20 05:30, Dan Williams wrote:
> > The daxctl unit test for the dax_kmem driver currently triggers the
> > lockdep splat below. It results from the fact that
> > remove_memory_block_devices() is invoked under the mem_hotplug_lock()
> > causing lockdep entanglements with cpu_hotplug_lock().
> >
> > The mem_hotplug_lock() is not needed to synchronize the memory block
> > device sysfs interface vs the page online state, that is already handled
> > by lock_device_hotplug(). Specifically lock_device_hotplug()
> > is sufficient to allow try_remove_memory() to check the offline
> > state of the memblocks and be assured that subsequent online attempts
> > will be blocked. The device_online() path checks mem->section_count
> > before allowing any state manipulations and mem->section_count is
> > cleared in remove_memory_block_devices().
> >
> > The add_memory() path does create memblock devices under the lock, but
> > there is no lockdep report on that path, so it is left alone for now.
> >
> > This change is only possible thanks to the recent change that refactored
> > memory block device removal out of arch_remove_memory() (commit
> > 4c4b7f9ba948 mm/memory_hotplug: remove memory block devices before
> > arch_remove_memory()).
> >
> >     ======================================================
> >     WARNING: possible circular locking dependency detected
> >     5.5.0-rc3+ #230 Tainted: G           OE
> >     ------------------------------------------------------
> >     lt-daxctl/6459 is trying to acquire lock:
> >     ffff99c7f0003510 (kn->count#241){++++}, at: kernfs_remove_by_name_ns+0x41/0x80
> >
> >     but task is already holding lock:
> >     ffffffffa76a5450 (mem_hotplug_lock.rw_sem){++++}, at: percpu_down_write+0x20/0xe0
> >
> >     which lock already depends on the new lock.
> >
> >
> >     the existing dependency chain (in reverse order) is:
> >
> >     -> #2 (mem_hotplug_lock.rw_sem){++++}:
> >            __lock_acquire+0x39c/0x790
> >            lock_acquire+0xa2/0x1b0
> >            get_online_mems+0x3e/0xb0
> >            kmem_cache_create_usercopy+0x2e/0x260
> >            kmem_cache_create+0x12/0x20
> >            ptlock_cache_init+0x20/0x28
> >            start_kernel+0x243/0x547
> >            secondary_startup_64+0xb6/0xc0
> >
> >     -> #1 (cpu_hotplug_lock.rw_sem){++++}:
> >            __lock_acquire+0x39c/0x790
> >            lock_acquire+0xa2/0x1b0
> >            cpus_read_lock+0x3e/0xb0
> >            online_pages+0x37/0x300
> >            memory_subsys_online+0x17d/0x1c0
> >            device_online+0x60/0x80
> >            state_store+0x65/0xd0
> >            kernfs_fop_write+0xcf/0x1c0
> >            vfs_write+0xdb/0x1d0
> >            ksys_write+0x65/0xe0
> >            do_syscall_64+0x5c/0xa0
> >            entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >
> >     -> #0 (kn->count#241){++++}:
> >            check_prev_add+0x98/0xa40
> >            validate_chain+0x576/0x860
> >            __lock_acquire+0x39c/0x790
> >            lock_acquire+0xa2/0x1b0
> >            __kernfs_remove+0x25f/0x2e0
> >            kernfs_remove_by_name_ns+0x41/0x80
> >            remove_files.isra.0+0x30/0x70
> >            sysfs_remove_group+0x3d/0x80
> >            sysfs_remove_groups+0x29/0x40
> >            device_remove_attrs+0x39/0x70
> >            device_del+0x16a/0x3f0
> >            device_unregister+0x16/0x60
> >            remove_memory_block_devices+0x82/0xb0
> >            try_remove_memory+0xb5/0x130
> >            remove_memory+0x26/0x40
> >            dev_dax_kmem_remove+0x44/0x6a [kmem]
> >            device_release_driver_internal+0xe4/0x1c0
> >            unbind_store+0xef/0x120
> >            kernfs_fop_write+0xcf/0x1c0
> >            vfs_write+0xdb/0x1d0
> >            ksys_write+0x65/0xe0
> >            do_syscall_64+0x5c/0xa0
> >            entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >
> >     other info that might help us debug this:
> >
> >     Chain exists of:
> >       kn->count#241 --> cpu_hotplug_lock.rw_sem --> mem_hotplug_lock.rw_sem
> >
> >      Possible unsafe locking scenario:
> >
> >            CPU0                    CPU1
> >            ----                    ----
> >       lock(mem_hotplug_lock.rw_sem);
> >                                    lock(cpu_hotplug_lock.rw_sem);
> >                                    lock(mem_hotplug_lock.rw_sem);
> >       lock(kn->count#241);
> >
> >      *** DEADLOCK ***
> >
> > No fixes tag as this seems to have been a long standing issue that
> > likely predated the addition of kernfs lockdep annotations.
> >
> > Cc: <stable@vger.kernel.org>
> > Cc: Vishal Verma <vishal.l.verma@intel.com>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
> > Cc: Michal Hocko <mhocko@suse.com>
> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  mm/memory_hotplug.c |   12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> > index 55ac23ef11c1..a4e7dadded08 100644
> > --- a/mm/memory_hotplug.c
> > +++ b/mm/memory_hotplug.c
> > @@ -1763,8 +1763,6 @@ static int __ref try_remove_memory(int nid, u64 start, u64 size)
> >
> >       BUG_ON(check_hotplug_memory_range(start, size));
> >
> > -     mem_hotplug_begin();
> > -
> >       /*
> >        * All memory blocks must be offlined before removing memory.  Check
> >        * whether all memory blocks in question are offline and return error
> > @@ -1777,9 +1775,17 @@ static int __ref try_remove_memory(int nid, u64 start, u64 size)
> >       /* remove memmap entry */
> >       firmware_map_remove(start, start + size, "System RAM");
> >
> > -     /* remove memory block devices before removing memory */
> > +     /*
> > +      * Remove memory block devices before removing memory, and do
> > +      * not hold the mem_hotplug_lock() over kobject removal
> > +      * operations. lock_device_hotplug() keeps the
> > +      * check_memblock_offlined_cb result valid until the entire
> > +      * removal process is complete.
> > +      */
>
> Maybe shorten that to
>
> /*
>  * Remove memory block devices before removing memory. Protected
>  * by the device_hotplug_lock only.
>  */

Why make someone dig for the reasons this lock is sufficient?

>
> AFAIK, the device hotplug lock is sufficient here. The memory hotplug
> lock / cpu hotplug lock is only needed when calling into arch code
> (especially for PPC). We hold both locks when onlining/offlining memory.
>
> >       remove_memory_block_devices(start, size);
> >
> > +     mem_hotplug_begin();
> > +
> >       arch_remove_memory(nid, start, size, NULL);
> >       memblock_free(start, size);
> >       memblock_remove(start, size);
> >
>
> I'd suggest to do the same in the adding part right away (if easily
> possible) to make it clearer.

Let's let this fix percolate upstream for a bit to make sure there was
no protection the mem_hotplug_begin() was inadvertently providing.

> I properly documented the semantics of
> add_memory_block_devices()/remove_memory_block_devices() already (that
> they need the device hotplug lock).

I see that, but I prefer lockdep_assert_held() in the code rather than
comments. I'll send a patch to fix that up.
