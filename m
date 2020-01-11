Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD1A2138106
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 12:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbgAKLDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 06:03:42 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55132 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729087AbgAKLDm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jan 2020 06:03:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578740620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=IMWr4MVSUwrWNDI+XqQF+ZEtNzBIwKFTWI4dbt40bdo=;
        b=fH1eneQ5j/dPki6+iRxSYrb/2r5To8dGfheWLUDwMedEmQ/LxMhyexkz6Pfd8Sd8OsSssz
        iT6HG/zMK7rd8D8dw+K0AKCVOjuoSr6MXY3HTo6J/ktaiNfp1HejvOwS4T8FkT/n8MAi/t
        NMGA4ImHhlR9i0X9LVAWpg6VbEQ/Brk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-agwvWYLtPcuu1u28dVH0jQ-1; Sat, 11 Jan 2020 06:03:36 -0500
X-MC-Unique: agwvWYLtPcuu1u28dVH0jQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 681031800D48;
        Sat, 11 Jan 2020 11:03:34 +0000 (UTC)
Received: from [10.36.116.76] (ovpn-116-76.ams2.redhat.com [10.36.116.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F77C5D9CD;
        Sat, 11 Jan 2020 11:03:31 +0000 (UTC)
Subject: Re: [PATCH v4] mm/memory_hotplug: Fix remove_memory() lockdep splat
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Michal Hocko <mhocko@suse.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
References: <157869128062.2451572.4093315441083744888.stgit@dwillia2-desk3.amr.corp.intel.com>
 <d8458d18-5cf4-a823-4d22-86a9b6e66457@redhat.com>
 <CAPcyv4hcAR7pq0ZD=Y3MaePCqcQzkpUvc7+O7+xZkq4TtkgyKQ@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <a3d58f0b-145f-1e70-434f-e97e1f08ebcf@redhat.com>
Date:   Sat, 11 Jan 2020 12:03:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hcAR7pq0ZD=Y3MaePCqcQzkpUvc7+O7+xZkq4TtkgyKQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>>> Cc: <stable@vger.kernel.org>
>>
>> I am not convinced this can actually happen. I explained somewhere els=
e
>> already why a similar locksplat (reported by Pavel IIRC) on the ordina=
ry
>> memory removal path is a false positive (because the device hotplug lo=
ck
>> actually protects us from such conditions). Can you elaborate why this
>> is stable material (and explain my tired eyes how the issue will
>> actually happen in real life)?
>=20
> I don't mind waiting for it to soak a while upstream before heading
> back to -stable, and it's possible the kn->count entanglement is on a
> kobject in a different part of the sysfs hierarchy, but I haven't
> proven that. So, it's a toss up. I think the backport risk is low, but
> we can validate that with some upstream soak time.

So I just remember why I think this (and the previously reported done
for ACPI DIMMs) are false positives. The actual locking order is

onlining/offlining from user space:

kn->count -> device_hotplug_lock -> cpu_hotplug_lock -> mem_hotplug_lock

memory removal:

device_hotplug_lock -> cpu_hotplug_lock -> mem_hotplug_lock -> kn->count


This looks like a locking inversion - but it's not. Whenever we come via
user space we do a mutex_trylock(), which resolves this issue by backing
up. The device_hotplug_lock will prevent

I have no clue why the device_hotplug_lock does not pop up in the
lockdep report here. Sounds wrong to me.

I think this is a false positive and not stable material.

>=20
>>
>> [...]
>>>
>>>  When adding/removing memory that uses memory block devices (i.e. ord=
inary RAM),
>>> -the device_hotplug_lock should be held to:
>>> +the device_hotplug_lock is held to:
>>>
>>>  - synchronize against online/offline requests (e.g. via sysfs). This=
 way, memory
>>>    block devices can only be accessed (.online/.state attributes) by =
user
>>> -  space once memory has been fully added. And when removing memory, =
we
>>> -  know nobody is in critical sections.
>>> +  space once memory has been fully added. And when removing memory, =
the
>>> +  memory block device is invalidated (mem->section count set to 0) u=
nder the
>>> +  lock to abort any in-flight online requests.
>>
>> I don't think this is needed. See below.
>>
>>>  - synchronize against CPU hotplug and similar (e.g. relevant for ACP=
I and PPC)
>>>
>>>  Especially, there is a possible lock inversion that is avoided using
>>> @@ -112,7 +113,13 @@ can result in a lock inversion.
>>>
>>>  onlining/offlining of memory should be done via device_online()/
>>>  device_offline() - to make sure it is properly synchronized to actio=
ns
>>> -via sysfs. Holding device_hotplug_lock is advised (to e.g. protect o=
nline_type)
>>> +via sysfs. Holding device_hotplug_lock is required to prevent online=
 racing
>>> +removal. The device_hotplug_lock and memblock invalidation allows
>>> +remove_memory_block_devices() to run outside of mem_hotplug_lock to =
avoid lock
>>> +dependency conflicts with memblock-sysfs teardown. The add_memory() =
path
>>> +performs create_memory_block_devices() under mem_hotplug_lock so tha=
t if it
>>> +fails it can perform an arch_remove_memory() cleanup. There are no k=
nown lock
>>> +dependency problems with memblock-sysfs setup.
>>>
>>>  When adding/removing/onlining/offlining memory or adding/removing
>>>  heterogeneous/device memory, we should always hold the mem_hotplug_l=
ock in
>>> diff --git a/drivers/base/core.c b/drivers/base/core.c
>>> index 42a672456432..5d5036370c92 100644
>>> --- a/drivers/base/core.c
>>> +++ b/drivers/base/core.c
>>> @@ -1146,6 +1146,11 @@ void unlock_device_hotplug(void)
>>>       mutex_unlock(&device_hotplug_lock);
>>>  }
>>>
>>> +void assert_held_device_hotplug(void)
>>> +{
>>> +     lockdep_assert_held(&device_hotplug_lock);
>>> +}
>>> +
>>>  int lock_device_hotplug_sysfs(void)
>>>  {
>>>       if (mutex_trylock(&device_hotplug_lock))
>>> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
>>> index 799b43191dea..91c6fbd2383e 100644
>>> --- a/drivers/base/memory.c
>>> +++ b/drivers/base/memory.c
>>> @@ -280,6 +280,10 @@ static int memory_subsys_online(struct device *d=
ev)
>>>       if (mem->state =3D=3D MEM_ONLINE)
>>>               return 0;
>>>
>>> +     /* online lost the race with hot-unplug, abort */
>>> +     if (!mem->section_count)
>>> +             return -ENXIO;
>>> +
>>
>> Huh, why is that needed? There is pages_correctly_probed(), which chec=
ks
>> that all sections are present already (but I also have a patch to rewo=
rk
>> that in my queue, because it looks like it's not needed in the current
>> state).
>=20
> I chose "mem->section_count =3D 0" as the invalidation event because
> that attribute is tied to the memory block itself and for symmetry
> with the offline path. More below...
>=20
>>
>> (Especially, I don't see why this is necessary in the context of this
>> patch - nothing changed in that regard. Also, checks against "device
>> already removed" should logically belong into
>> device_online()/device_offline().
>=20
> The scenario is that userspace races two threads one calling offline
> and the other calling online. Likely no, possible yes. Offline thread
> wins the race, but not before online thread gets to the lock in
> state_store(). Offline thread completes the teardown and unlocks.
> Online thread starts operating on a zombie memory-block-device until
> it notices the memory associated with that device is not suitable to
> online.
>=20
> For symmetry with memory_subsys_offline() (that prevents the loser of
> a race of 2 threads running offline from continuing to operate on a
> zombie memory-block with a ->section_count check) I added a
> ->section_count check to memory_subsys_online().

1. The section_count check is in place to disallow offlining memory
blocks with missing sections. (see 26bbe7ef6d5c ("drivers/base/memory.c:
prohibit offlining of memory blocks with missing sections")). Not to
deal with any races/zombie blocks.

2. offlining/onlining racing is completely irrelevant. state_store() and
online_store() do a lock_device_hotplug_sysfs(), which is a trylock. The
looser will simply back off. device_online() and device_offline()
properly deal with the block already being in the desired state.

3. zombie blocks are interesting, but I am not convinced yet this is an
actual issue - we've never seen it happening. I *think* it could work
due to the trylock correctly (pending requests will back off while
another thread is removing them), but I am not convinced there is no
tiny little race. Anyhow, we have pages_correctly_probed() which will
bail out properly already if the sections have been removed in the
meantime. Also, I think we should deal with zombie blocks differently if
required (more below).

I think this hunk does logically not belong into this patch and is also
not needed (due to pages_correctly_probed() in memory_block_action()).
Please drop it from this patch (including the documentation update
regarding this).

>=20
>> Other subsystems should have similar issues, no?)
>=20
> Not many subsystems have a sysfs attribute that can trigger the
> unregistration of the self same attribute, but yes, I've seen it cause
> problems.
>=20
> For example, async device probing and registration causes similar
> issues and was only recently fixed:
>=20
> 3451a495ef24 driver core: Establish order of operations for device_add
> and device_del via bitflag

I feel like we should have a -> removed property on devices and check
against that in device_online() and device_offline(). But only if there
isn't another magical mechanism that deals with zombie devices and
pending online/offline requests.

>=20
>>
>>>       /*
>>>        * If we are called from state_store(), online_type will be
>>>        * set >=3D 0 Otherwise we were called from the device online
>>> @@ -736,8 +740,6 @@ int create_memory_block_devices(unsigned long sta=
rt, unsigned long size)
>>>   * Remove memory block devices for the given memory area. Start and =
size
>>>   * have to be aligned to memory block granularity. Memory block devi=
ces
>>>   * have to be offline.
>>> - *
>>> - * Called under device_hotplug_lock.
>>>   */
>>
>> Why is that change needed? Especially with the radix tree rework, this
>> lock is required on this call path. Removing this looks wrong to me.
>=20
> I'm not removing the dependency I'm trading the comment for a call to
> assert_held_device_hotplug(). I'm ok with keeping the comment, but the
> explicit lockdep assertion helps the future developer that refactors
> and inadvertently misses the comment.
>=20

Ah, I missed that you placed the assert into that function, sorry
(thought it would be in the caller). We document it for most other
functions in that file now, so I'd prefer to just keep it. Whatever you
prefer.


--=20
Thanks,

David / dhildenb

