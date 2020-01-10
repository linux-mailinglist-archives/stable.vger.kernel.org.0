Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 393C81379B9
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 23:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbgAJWdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 17:33:45 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39423 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727324AbgAJWdp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jan 2020 17:33:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578695622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=wkjmjwV/ir+5sFM7NfhYvFfBTvBFKSIKVyrG2QmMlbw=;
        b=STvzc1YImyfirDH1eRuCVWvpBoUkJz/hU8LnOl7eK8LCRmxd4SKPKJXeJZ6sR+kXwPfR9s
        Pi29weug0Bk2vgr2K00lcWh4orp0uNSRFVmXg3dNASbinsAwlHLy0pPigsorRKMoKMeJA0
        bWbmPcJXo+wZLy73gzAYr9S/MU9E1Tw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-PTOWxYEYMESbPN6cvtRZuA-1; Fri, 10 Jan 2020 17:33:39 -0500
X-MC-Unique: PTOWxYEYMESbPN6cvtRZuA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA231800D41;
        Fri, 10 Jan 2020 22:33:37 +0000 (UTC)
Received: from [10.36.116.37] (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BABAE5C1B5;
        Fri, 10 Jan 2020 22:33:35 +0000 (UTC)
Subject: Re: [PATCH v4] mm/memory_hotplug: Fix remove_memory() lockdep splat
To:     Dan Williams <dan.j.williams@intel.com>, akpm@linux-foundation.org
Cc:     stable@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Michal Hocko <mhocko@suse.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <157869128062.2451572.4093315441083744888.stgit@dwillia2-desk3.amr.corp.intel.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <d8458d18-5cf4-a823-4d22-86a9b6e66457@redhat.com>
Date:   Fri, 10 Jan 2020 23:33:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <157869128062.2451572.4093315441083744888.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10.01.20 22:22, Dan Williams wrote:
> The daxctl unit test for the dax_kmem driver currently triggers the
> lockdep splat below. It results from the fact that
> remove_memory_block_devices() is invoked under the mem_hotplug_lock()
> causing lockdep entanglements with cpu_hotplug_lock().
>=20
> The mem_hotplug_lock() is not needed to synchronize the memory block
> device sysfs interface vs the page online state, that is already handle=
d
> by lock_device_hotplug(). Specifically lock_device_hotplug()
> is sufficient to allow try_remove_memory() to check the offline
> state of the memblocks and be assured that subsequent online attempts
> will be blocked. The device_online() path checks mem->section_count
> before allowing any state manipulations and mem->section_count is
> cleared in remove_memory_block_devices().
>=20
> The add_memory() path does create memblock devices under the lock, but
> there is no lockdep report on that path, and it wants to unwind the
> hot-add (via arch_remove_memory()) if the memblock device creation
> fails, so it is left alone for now.
>=20
> This change is only possible thanks to the recent change that refactore=
d
> memory block device removal out of arch_remove_memory() (commit
> 4c4b7f9ba948 mm/memory_hotplug: remove memory block devices before
> arch_remove_memory()).
>=20
>     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>     WARNING: possible circular locking dependency detected
>     5.5.0-rc3+ #230 Tainted: G           OE
>     ------------------------------------------------------
>     lt-daxctl/6459 is trying to acquire lock:
>     ffff99c7f0003510 (kn->count#241){++++}, at: kernfs_remove_by_name_n=
s+0x41/0x80
>=20
>     but task is already holding lock:
>     ffffffffa76a5450 (mem_hotplug_lock.rw_sem){++++}, at: percpu_down_w=
rite+0x20/0xe0
>=20
>     which lock already depends on the new lock.
>=20
>=20
>     the existing dependency chain (in reverse order) is:
>=20
>     -> #2 (mem_hotplug_lock.rw_sem){++++}:
>            __lock_acquire+0x39c/0x790
>            lock_acquire+0xa2/0x1b0
>            get_online_mems+0x3e/0xb0
>            kmem_cache_create_usercopy+0x2e/0x260
>            kmem_cache_create+0x12/0x20
>            ptlock_cache_init+0x20/0x28
>            start_kernel+0x243/0x547
>            secondary_startup_64+0xb6/0xc0
>=20
>     -> #1 (cpu_hotplug_lock.rw_sem){++++}:
>            __lock_acquire+0x39c/0x790
>            lock_acquire+0xa2/0x1b0
>            cpus_read_lock+0x3e/0xb0
>            online_pages+0x37/0x300
>            memory_subsys_online+0x17d/0x1c0
>            device_online+0x60/0x80
>            state_store+0x65/0xd0
>            kernfs_fop_write+0xcf/0x1c0
>            vfs_write+0xdb/0x1d0
>            ksys_write+0x65/0xe0
>            do_syscall_64+0x5c/0xa0
>            entry_SYSCALL_64_after_hwframe+0x49/0xbe
>=20
>     -> #0 (kn->count#241){++++}:
>            check_prev_add+0x98/0xa40
>            validate_chain+0x576/0x860
>            __lock_acquire+0x39c/0x790
>            lock_acquire+0xa2/0x1b0
>            __kernfs_remove+0x25f/0x2e0
>            kernfs_remove_by_name_ns+0x41/0x80
>            remove_files.isra.0+0x30/0x70
>            sysfs_remove_group+0x3d/0x80
>            sysfs_remove_groups+0x29/0x40
>            device_remove_attrs+0x39/0x70
>            device_del+0x16a/0x3f0
>            device_unregister+0x16/0x60
>            remove_memory_block_devices+0x82/0xb0
>            try_remove_memory+0xb5/0x130
>            remove_memory+0x26/0x40
>            dev_dax_kmem_remove+0x44/0x6a [kmem]
>            device_release_driver_internal+0xe4/0x1c0
>            unbind_store+0xef/0x120
>            kernfs_fop_write+0xcf/0x1c0
>            vfs_write+0xdb/0x1d0
>            ksys_write+0x65/0xe0
>            do_syscall_64+0x5c/0xa0
>            entry_SYSCALL_64_after_hwframe+0x49/0xbe
>=20
>     other info that might help us debug this:
>=20
>     Chain exists of:
>       kn->count#241 --> cpu_hotplug_lock.rw_sem --> mem_hotplug_lock.rw=
_sem
>=20
>      Possible unsafe locking scenario:
>=20
>            CPU0                    CPU1
>            ----                    ----
>       lock(mem_hotplug_lock.rw_sem);
>                                    lock(cpu_hotplug_lock.rw_sem);
>                                    lock(mem_hotplug_lock.rw_sem);
>       lock(kn->count#241);
>=20
>      *** DEADLOCK ***
>=20
> No fixes tag as this seems to have been a long standing issue that
> likely predated the addition of kernfs lockdep annotations.
>=20
> Cc: <stable@vger.kernel.org>

I am not convinced this can actually happen. I explained somewhere else
already why a similar locksplat (reported by Pavel IIRC) on the ordinary
memory removal path is a false positive (because the device hotplug lock
actually protects us from such conditions). Can you elaborate why this
is stable material (and explain my tired eyes how the issue will
actually happen in real life)?

[...]
> =20
>  When adding/removing memory that uses memory block devices (i.e. ordin=
ary RAM),
> -the device_hotplug_lock should be held to:
> +the device_hotplug_lock is held to:
> =20
>  - synchronize against online/offline requests (e.g. via sysfs). This w=
ay, memory
>    block devices can only be accessed (.online/.state attributes) by us=
er
> -  space once memory has been fully added. And when removing memory, we
> -  know nobody is in critical sections.
> +  space once memory has been fully added. And when removing memory, th=
e
> +  memory block device is invalidated (mem->section count set to 0) und=
er the
> +  lock to abort any in-flight online requests.

I don't think this is needed. See below.

>  - synchronize against CPU hotplug and similar (e.g. relevant for ACPI =
and PPC)
> =20
>  Especially, there is a possible lock inversion that is avoided using
> @@ -112,7 +113,13 @@ can result in a lock inversion.
> =20
>  onlining/offlining of memory should be done via device_online()/
>  device_offline() - to make sure it is properly synchronized to actions
> -via sysfs. Holding device_hotplug_lock is advised (to e.g. protect onl=
ine_type)
> +via sysfs. Holding device_hotplug_lock is required to prevent online r=
acing
> +removal. The device_hotplug_lock and memblock invalidation allows
> +remove_memory_block_devices() to run outside of mem_hotplug_lock to av=
oid lock
> +dependency conflicts with memblock-sysfs teardown. The add_memory() pa=
th
> +performs create_memory_block_devices() under mem_hotplug_lock so that =
if it
> +fails it can perform an arch_remove_memory() cleanup. There are no kno=
wn lock
> +dependency problems with memblock-sysfs setup.
> =20
>  When adding/removing/onlining/offlining memory or adding/removing
>  heterogeneous/device memory, we should always hold the mem_hotplug_loc=
k in
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 42a672456432..5d5036370c92 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1146,6 +1146,11 @@ void unlock_device_hotplug(void)
>  	mutex_unlock(&device_hotplug_lock);
>  }
> =20
> +void assert_held_device_hotplug(void)
> +{
> +	lockdep_assert_held(&device_hotplug_lock);
> +}
> +
>  int lock_device_hotplug_sysfs(void)
>  {
>  	if (mutex_trylock(&device_hotplug_lock))
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 799b43191dea..91c6fbd2383e 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -280,6 +280,10 @@ static int memory_subsys_online(struct device *dev=
)
>  	if (mem->state =3D=3D MEM_ONLINE)
>  		return 0;
> =20
> +	/* online lost the race with hot-unplug, abort */
> +	if (!mem->section_count)
> +		return -ENXIO;
> +

Huh, why is that needed? There is pages_correctly_probed(), which checks
that all sections are present already (but I also have a patch to rework
that in my queue, because it looks like it's not needed in the current
state).

(Especially, I don't see why this is necessary in the context of this
patch - nothing changed in that regard. Also, checks against "device
already removed" should logically belong into
device_online()/device_offline(). Other subsystems should have similar
issues, no?)

>  	/*
>  	 * If we are called from state_store(), online_type will be
>  	 * set >=3D 0 Otherwise we were called from the device online
> @@ -736,8 +740,6 @@ int create_memory_block_devices(unsigned long start=
, unsigned long size)
>   * Remove memory block devices for the given memory area. Start and si=
ze
>   * have to be aligned to memory block granularity. Memory block device=
s
>   * have to be offline.
> - *
> - * Called under device_hotplug_lock.
>   */

Why is that change needed? Especially with the radix tree rework, this
lock is required on this call path. Removing this looks wrong to me.


>  void remove_memory_block_devices(unsigned long start, unsigned long si=
ze)
>  {
> @@ -746,6 +748,8 @@ void remove_memory_block_devices(unsigned long star=
t, unsigned long size)
>  	struct memory_block *mem;
>  	unsigned long block_id;
> =20
> +	assert_held_device_hotplug();
> +
>  	if (WARN_ON_ONCE(!IS_ALIGNED(start, memory_block_size_bytes()) ||
>  			 !IS_ALIGNED(size, memory_block_size_bytes())))
>  		return;
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 96ff76731e93..a84654489c51 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -1553,6 +1553,7 @@ static inline bool device_supports_offline(struct=
 device *dev)
>  extern void lock_device_hotplug(void);
>  extern void unlock_device_hotplug(void);
>  extern int lock_device_hotplug_sysfs(void);
> +extern void assert_held_device_hotplug(void);
>  extern int device_offline(struct device *dev);
>  extern int device_online(struct device *dev);
>  extern void set_primary_fwnode(struct device *dev, struct fwnode_handl=
e *fwnode);
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 55ac23ef11c1..0158cd4cca48 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1763,8 +1763,6 @@ static int __ref try_remove_memory(int nid, u64 s=
tart, u64 size)
> =20
>  	BUG_ON(check_hotplug_memory_range(start, size));
> =20
> -	mem_hotplug_begin();
> -
>  	/*
>  	 * All memory blocks must be offlined before removing memory.  Check
>  	 * whether all memory blocks in question are offline and return error
> @@ -1777,9 +1775,15 @@ static int __ref try_remove_memory(int nid, u64 =
start, u64 size)
>  	/* remove memmap entry */
>  	firmware_map_remove(start, start + size, "System RAM");
> =20
> -	/* remove memory block devices before removing memory */
> +	/*
> +	 * Remove memory block devices before removing memory and before
> +	 * mem_hotplug_begin() (see Documentation/core-api/memory-hotplug.rst
> +	 * "Locking Internals").
> +	 */
>  	remove_memory_block_devices(start, size);
> =20
> +	mem_hotplug_begin();
> +
>  	arch_remove_memory(nid, start, size, NULL);
>  	memblock_free(start, size);
>  	memblock_remove(start, size);
>=20

That hunk looks good to me.

--=20
Thanks,

David / dhildenb

