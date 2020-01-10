Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6481D137A3D
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 00:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbgAJX3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 18:29:32 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39896 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727498AbgAJX3b (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jan 2020 18:29:31 -0500
Received: by mail-ot1-f67.google.com with SMTP id 77so3613989oty.6
        for <stable@vger.kernel.org>; Fri, 10 Jan 2020 15:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HUhUwi9BiEkzqQ1lxWWGhRkB25aVVxGo3N7oWJf7O4k=;
        b=pQeaQPN5TzLCwSZttoh0PkL4rJys5eJOHE9GIZxJEL1Xb9G2RWKs84rjhDgcxZ6H22
         hE6ZhnrfmRyJdi6cCHRJVYdhGPnL1GKHHVOTOcKDr3Xwt6Iw4nixTId2hpjnNhjOy8KS
         dJXlpvAd0METs0BWRTCyvk/nvU4vKRrYpwTcvKH0jhOGUK29BEk27QO9rTjOhbZElKNZ
         /0orgjZWkQHZbTr1aB7fuyxg7ZW3nO5UL4jvX8DYxSvm6bWbxgTIErkFqho+Vh/AwX5v
         G+CT/su1x2k/+fWg6NLAsDiCJmudu1nN4NwnsQTFJhQWJ0EWkEHLrUcbu4puALX0z89f
         4ERg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HUhUwi9BiEkzqQ1lxWWGhRkB25aVVxGo3N7oWJf7O4k=;
        b=j21G4BJUH4Mi1fnTihhpfg+K9apnY+AOxen/dp4TT6gHPJbsJeIxiZaMJHECUKhmT1
         67c8wONuHblIXF1G894PLqX/QLrXTgerqvCLI73ibXab1tdR4UvI2ejQHMoZAKjPOQKc
         W4+6UTpAitQZGwUdbDRURBsUEtBEn5AUAWPbx+TKKlCrKERn87cA/63WxMpnENQIUBig
         WjfsbF8f75gd/31XB13WVxfIHPwLW9udjFR+Whn9quhuLD9E5Wixs++rBkYoqpiV+615
         La1WljChO/9GhHaBhiSiiQzjYWcpg3ZCbQ/Hyy48l8PsRh2XELksmyvgH9wNaGbadqKH
         lFXg==
X-Gm-Message-State: APjAAAVfAbLZcTAzBEzyKHQBgYVhDTce5A81xfA6NTKLjFl4LKWmfehN
        t33qMhBne3IC06mr2z1qgNvU0P7zafJ2HZASrtVkyA==
X-Google-Smtp-Source: APXvYqy7u7s6Qa4h2eMb9QB+EgkmpOuuRrQAK4ZqevZIRFc4NA8Ez/AwLKT0h2xXkmjLy15IAPN8fGGnPL7NaAaRvfY=
X-Received: by 2002:a9d:68d3:: with SMTP id i19mr4356465oto.71.1578698970105;
 Fri, 10 Jan 2020 15:29:30 -0800 (PST)
MIME-Version: 1.0
References: <157869128062.2451572.4093315441083744888.stgit@dwillia2-desk3.amr.corp.intel.com>
 <d8458d18-5cf4-a823-4d22-86a9b6e66457@redhat.com>
In-Reply-To: <d8458d18-5cf4-a823-4d22-86a9b6e66457@redhat.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 10 Jan 2020 15:29:19 -0800
Message-ID: <CAPcyv4hcAR7pq0ZD=Y3MaePCqcQzkpUvc7+O7+xZkq4TtkgyKQ@mail.gmail.com>
Subject: Re: [PATCH v4] mm/memory_hotplug: Fix remove_memory() lockdep splat
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

On Fri, Jan 10, 2020 at 2:33 PM David Hildenbrand <david@redhat.com> wrote:
>
> On 10.01.20 22:22, Dan Williams wrote:
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
> > there is no lockdep report on that path, and it wants to unwind the
> > hot-add (via arch_remove_memory()) if the memblock device creation
> > fails, so it is left alone for now.
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
>
> I am not convinced this can actually happen. I explained somewhere else
> already why a similar locksplat (reported by Pavel IIRC) on the ordinary
> memory removal path is a false positive (because the device hotplug lock
> actually protects us from such conditions). Can you elaborate why this
> is stable material (and explain my tired eyes how the issue will
> actually happen in real life)?

I don't mind waiting for it to soak a while upstream before heading
back to -stable, and it's possible the kn->count entanglement is on a
kobject in a different part of the sysfs hierarchy, but I haven't
proven that. So, it's a toss up. I think the backport risk is low, but
we can validate that with some upstream soak time.

>
> [...]
> >
> >  When adding/removing memory that uses memory block devices (i.e. ordinary RAM),
> > -the device_hotplug_lock should be held to:
> > +the device_hotplug_lock is held to:
> >
> >  - synchronize against online/offline requests (e.g. via sysfs). This way, memory
> >    block devices can only be accessed (.online/.state attributes) by user
> > -  space once memory has been fully added. And when removing memory, we
> > -  know nobody is in critical sections.
> > +  space once memory has been fully added. And when removing memory, the
> > +  memory block device is invalidated (mem->section count set to 0) under the
> > +  lock to abort any in-flight online requests.
>
> I don't think this is needed. See below.
>
> >  - synchronize against CPU hotplug and similar (e.g. relevant for ACPI and PPC)
> >
> >  Especially, there is a possible lock inversion that is avoided using
> > @@ -112,7 +113,13 @@ can result in a lock inversion.
> >
> >  onlining/offlining of memory should be done via device_online()/
> >  device_offline() - to make sure it is properly synchronized to actions
> > -via sysfs. Holding device_hotplug_lock is advised (to e.g. protect online_type)
> > +via sysfs. Holding device_hotplug_lock is required to prevent online racing
> > +removal. The device_hotplug_lock and memblock invalidation allows
> > +remove_memory_block_devices() to run outside of mem_hotplug_lock to avoid lock
> > +dependency conflicts with memblock-sysfs teardown. The add_memory() path
> > +performs create_memory_block_devices() under mem_hotplug_lock so that if it
> > +fails it can perform an arch_remove_memory() cleanup. There are no known lock
> > +dependency problems with memblock-sysfs setup.
> >
> >  When adding/removing/onlining/offlining memory or adding/removing
> >  heterogeneous/device memory, we should always hold the mem_hotplug_lock in
> > diff --git a/drivers/base/core.c b/drivers/base/core.c
> > index 42a672456432..5d5036370c92 100644
> > --- a/drivers/base/core.c
> > +++ b/drivers/base/core.c
> > @@ -1146,6 +1146,11 @@ void unlock_device_hotplug(void)
> >       mutex_unlock(&device_hotplug_lock);
> >  }
> >
> > +void assert_held_device_hotplug(void)
> > +{
> > +     lockdep_assert_held(&device_hotplug_lock);
> > +}
> > +
> >  int lock_device_hotplug_sysfs(void)
> >  {
> >       if (mutex_trylock(&device_hotplug_lock))
> > diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> > index 799b43191dea..91c6fbd2383e 100644
> > --- a/drivers/base/memory.c
> > +++ b/drivers/base/memory.c
> > @@ -280,6 +280,10 @@ static int memory_subsys_online(struct device *dev)
> >       if (mem->state == MEM_ONLINE)
> >               return 0;
> >
> > +     /* online lost the race with hot-unplug, abort */
> > +     if (!mem->section_count)
> > +             return -ENXIO;
> > +
>
> Huh, why is that needed? There is pages_correctly_probed(), which checks
> that all sections are present already (but I also have a patch to rework
> that in my queue, because it looks like it's not needed in the current
> state).

I chose "mem->section_count = 0" as the invalidation event because
that attribute is tied to the memory block itself and for symmetry
with the offline path. More below...

>
> (Especially, I don't see why this is necessary in the context of this
> patch - nothing changed in that regard. Also, checks against "device
> already removed" should logically belong into
> device_online()/device_offline().

The scenario is that userspace races two threads one calling offline
and the other calling online. Likely no, possible yes. Offline thread
wins the race, but not before online thread gets to the lock in
state_store(). Offline thread completes the teardown and unlocks.
Online thread starts operating on a zombie memory-block-device until
it notices the memory associated with that device is not suitable to
online.

For symmetry with memory_subsys_offline() (that prevents the loser of
a race of 2 threads running offline from continuing to operate on a
zombie memory-block with a ->section_count check) I added a
->section_count check to memory_subsys_online().

>Other subsystems should have similar issues, no?)

Not many subsystems have a sysfs attribute that can trigger the
unregistration of the self same attribute, but yes, I've seen it cause
problems.

For example, async device probing and registration causes similar
issues and was only recently fixed:

3451a495ef24 driver core: Establish order of operations for device_add
and device_del via bitflag

>
> >       /*
> >        * If we are called from state_store(), online_type will be
> >        * set >= 0 Otherwise we were called from the device online
> > @@ -736,8 +740,6 @@ int create_memory_block_devices(unsigned long start, unsigned long size)
> >   * Remove memory block devices for the given memory area. Start and size
> >   * have to be aligned to memory block granularity. Memory block devices
> >   * have to be offline.
> > - *
> > - * Called under device_hotplug_lock.
> >   */
>
> Why is that change needed? Especially with the radix tree rework, this
> lock is required on this call path. Removing this looks wrong to me.

I'm not removing the dependency I'm trading the comment for a call to
assert_held_device_hotplug(). I'm ok with keeping the comment, but the
explicit lockdep assertion helps the future developer that refactors
and inadvertently misses the comment.
