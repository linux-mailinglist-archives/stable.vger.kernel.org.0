Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C61B0137421
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 17:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728564AbgAJQym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 11:54:42 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60112 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727928AbgAJQym (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jan 2020 11:54:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578675280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=uI570JVpfSRhYK0rHTcPa3REfBSaxMKpkEKETnncEx4=;
        b=gzuqsB9DUVQX9JfvVnRRdrXXGhsPMjQIrVXTleNaGRQm5sppTtV9W9USUFj2en5M0Vy5nl
        p8FIqSnqFEx9Z/yaghTaiLft99J4Wp+t5vTNKOzKDCtiVVMsqrgtIr89WQYFqsin76vipz
        8XekIoDAN9n0393JvXtvyi6cg8ph4qI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-Dm70gjSlPkilaTY459D6jA-1; Fri, 10 Jan 2020 11:54:36 -0500
X-MC-Unique: Dm70gjSlPkilaTY459D6jA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E4A5107ACC4;
        Fri, 10 Jan 2020 16:54:35 +0000 (UTC)
Received: from [10.36.118.66] (unknown [10.36.118.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B289E19C4F;
        Fri, 10 Jan 2020 16:54:32 +0000 (UTC)
Subject: Re: [PATCH] mm/memory_hotplug: Fix remove_memory() lockdep splat
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Michal Hocko <mhocko@suse.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <157863061737.2230556.3959730620803366776.stgit@dwillia2-desk3.amr.corp.intel.com>
 <e60e64f9-894b-4121-d97b-fb61459cbbe5@redhat.com>
 <CAPcyv4jm=fmP=-5vbo2jxzMe2qXqZP=zDYF8G_rs3X6_Om0wPg@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <4d0334e2-c4e7-6d3f-99ba-2ca0495e1549@redhat.com>
Date:   Fri, 10 Jan 2020 17:54:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jm=fmP=-5vbo2jxzMe2qXqZP=zDYF8G_rs3X6_Om0wPg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10.01.20 17:42, Dan Williams wrote:
> On Fri, Jan 10, 2020 at 1:10 AM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 10.01.20 05:30, Dan Williams wrote:
>>> The daxctl unit test for the dax_kmem driver currently triggers the
>>> lockdep splat below. It results from the fact that
>>> remove_memory_block_devices() is invoked under the mem_hotplug_lock()
>>> causing lockdep entanglements with cpu_hotplug_lock().
>>>
>>> The mem_hotplug_lock() is not needed to synchronize the memory block
>>> device sysfs interface vs the page online state, that is already handled
>>> by lock_device_hotplug(). Specifically lock_device_hotplug()
>>> is sufficient to allow try_remove_memory() to check the offline
>>> state of the memblocks and be assured that subsequent online attempts
>>> will be blocked. The device_online() path checks mem->section_count
>>> before allowing any state manipulations and mem->section_count is
>>> cleared in remove_memory_block_devices().
>>>
>>> The add_memory() path does create memblock devices under the lock, but
>>> there is no lockdep report on that path, so it is left alone for now.
>>>
>>> This change is only possible thanks to the recent change that refactored
>>> memory block device removal out of arch_remove_memory() (commit
>>> 4c4b7f9ba948 mm/memory_hotplug: remove memory block devices before
>>> arch_remove_memory()).
>>>
>>>     ======================================================
>>>     WARNING: possible circular locking dependency detected
>>>     5.5.0-rc3+ #230 Tainted: G           OE
>>>     ------------------------------------------------------
>>>     lt-daxctl/6459 is trying to acquire lock:
>>>     ffff99c7f0003510 (kn->count#241){++++}, at: kernfs_remove_by_name_ns+0x41/0x80
>>>
>>>     but task is already holding lock:
>>>     ffffffffa76a5450 (mem_hotplug_lock.rw_sem){++++}, at: percpu_down_write+0x20/0xe0
>>>
>>>     which lock already depends on the new lock.
>>>
>>>
>>>     the existing dependency chain (in reverse order) is:
>>>
>>>     -> #2 (mem_hotplug_lock.rw_sem){++++}:
>>>            __lock_acquire+0x39c/0x790
>>>            lock_acquire+0xa2/0x1b0
>>>            get_online_mems+0x3e/0xb0
>>>            kmem_cache_create_usercopy+0x2e/0x260
>>>            kmem_cache_create+0x12/0x20
>>>            ptlock_cache_init+0x20/0x28
>>>            start_kernel+0x243/0x547
>>>            secondary_startup_64+0xb6/0xc0
>>>
>>>     -> #1 (cpu_hotplug_lock.rw_sem){++++}:
>>>            __lock_acquire+0x39c/0x790
>>>            lock_acquire+0xa2/0x1b0
>>>            cpus_read_lock+0x3e/0xb0
>>>            online_pages+0x37/0x300
>>>            memory_subsys_online+0x17d/0x1c0
>>>            device_online+0x60/0x80
>>>            state_store+0x65/0xd0
>>>            kernfs_fop_write+0xcf/0x1c0
>>>            vfs_write+0xdb/0x1d0
>>>            ksys_write+0x65/0xe0
>>>            do_syscall_64+0x5c/0xa0
>>>            entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>>
>>>     -> #0 (kn->count#241){++++}:
>>>            check_prev_add+0x98/0xa40
>>>            validate_chain+0x576/0x860
>>>            __lock_acquire+0x39c/0x790
>>>            lock_acquire+0xa2/0x1b0
>>>            __kernfs_remove+0x25f/0x2e0
>>>            kernfs_remove_by_name_ns+0x41/0x80
>>>            remove_files.isra.0+0x30/0x70
>>>            sysfs_remove_group+0x3d/0x80
>>>            sysfs_remove_groups+0x29/0x40
>>>            device_remove_attrs+0x39/0x70
>>>            device_del+0x16a/0x3f0
>>>            device_unregister+0x16/0x60
>>>            remove_memory_block_devices+0x82/0xb0
>>>            try_remove_memory+0xb5/0x130
>>>            remove_memory+0x26/0x40
>>>            dev_dax_kmem_remove+0x44/0x6a [kmem]
>>>            device_release_driver_internal+0xe4/0x1c0
>>>            unbind_store+0xef/0x120
>>>            kernfs_fop_write+0xcf/0x1c0
>>>            vfs_write+0xdb/0x1d0
>>>            ksys_write+0x65/0xe0
>>>            do_syscall_64+0x5c/0xa0
>>>            entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>>
>>>     other info that might help us debug this:
>>>
>>>     Chain exists of:
>>>       kn->count#241 --> cpu_hotplug_lock.rw_sem --> mem_hotplug_lock.rw_sem
>>>
>>>      Possible unsafe locking scenario:
>>>
>>>            CPU0                    CPU1
>>>            ----                    ----
>>>       lock(mem_hotplug_lock.rw_sem);
>>>                                    lock(cpu_hotplug_lock.rw_sem);
>>>                                    lock(mem_hotplug_lock.rw_sem);
>>>       lock(kn->count#241);
>>>
>>>      *** DEADLOCK ***
>>>
>>> No fixes tag as this seems to have been a long standing issue that
>>> likely predated the addition of kernfs lockdep annotations.
>>>
>>> Cc: <stable@vger.kernel.org>
>>> Cc: Vishal Verma <vishal.l.verma@intel.com>
>>> Cc: David Hildenbrand <david@redhat.com>
>>> Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
>>> Cc: Michal Hocko <mhocko@suse.com>
>>> Cc: Dave Hansen <dave.hansen@linux.intel.com>
>>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>>> ---
>>>  mm/memory_hotplug.c |   12 +++++++++---
>>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>>> index 55ac23ef11c1..a4e7dadded08 100644
>>> --- a/mm/memory_hotplug.c
>>> +++ b/mm/memory_hotplug.c
>>> @@ -1763,8 +1763,6 @@ static int __ref try_remove_memory(int nid, u64 start, u64 size)
>>>
>>>       BUG_ON(check_hotplug_memory_range(start, size));
>>>
>>> -     mem_hotplug_begin();
>>> -
>>>       /*
>>>        * All memory blocks must be offlined before removing memory.  Check
>>>        * whether all memory blocks in question are offline and return error
>>> @@ -1777,9 +1775,17 @@ static int __ref try_remove_memory(int nid, u64 start, u64 size)
>>>       /* remove memmap entry */
>>>       firmware_map_remove(start, start + size, "System RAM");
>>>
>>> -     /* remove memory block devices before removing memory */
>>> +     /*
>>> +      * Remove memory block devices before removing memory, and do
>>> +      * not hold the mem_hotplug_lock() over kobject removal
>>> +      * operations. lock_device_hotplug() keeps the
>>> +      * check_memblock_offlined_cb result valid until the entire
>>> +      * removal process is complete.
>>> +      */
>>
>> Maybe shorten that to
>>
>> /*
>>  * Remove memory block devices before removing memory. Protected
>>  * by the device_hotplug_lock only.
>>  */
> 
> Why make someone dig for the reasons this lock is sufficient?

I think 5 LOC of comment are too much for something that is documented
e.g., in Documentation/core-api/memory-hotplug.rst ("Locking
Internals"). But whatever you prefer.

> 
>>
>> AFAIK, the device hotplug lock is sufficient here. The memory hotplug
>> lock / cpu hotplug lock is only needed when calling into arch code
>> (especially for PPC). We hold both locks when onlining/offlining memory.
>>
>>>       remove_memory_block_devices(start, size);
>>>
>>> +     mem_hotplug_begin();
>>> +
>>>       arch_remove_memory(nid, start, size, NULL);
>>>       memblock_free(start, size);
>>>       memblock_remove(start, size);
>>>
>>
>> I'd suggest to do the same in the adding part right away (if easily
>> possible) to make it clearer.
> 
> Let's let this fix percolate upstream for a bit to make sure there was
> no protection the mem_hotplug_begin() was inadvertently providing.

Yeah, why not.

> 
>> I properly documented the semantics of
>> add_memory_block_devices()/remove_memory_block_devices() already (that
>> they need the device hotplug lock).
> 
> I see that, but I prefer lockdep_assert_held() in the code rather than
> comments. I'll send a patch to fix that up.

That won't work as early boot code from ACPI won't hold it while it adds
memory. And we decided (especially Michal :) ) to keep it like that.

-- 
Thanks,

David / dhildenb

