Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5B91381AA
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 15:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbgAKOwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 09:52:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43209 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729773AbgAKOwY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jan 2020 09:52:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578754342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=SaVor4Plg8CgMiFPIkvPtAAGv9jGCRIyU3aW9Cz3/BU=;
        b=iG9RMEFJpXy/JqzNCsmgsuD1Z6jyAXPjcxIR3HUFwfm3b+33ZSa2ZDmxEmTOmE4MHjgcv0
        eVhdJOWOlLyMdnfAZPPPtMDyAdFync/tFJzngr5HLLMB8KOV2/lbDQk7SWNeUtHoys5by9
        HFdZ6J4TubVI1wCxsPPIt3K8Nv+KIXg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-aZJzB9vUO5ap5au-Cl-ESg-1; Sat, 11 Jan 2020 09:52:18 -0500
X-MC-Unique: aZJzB9vUO5ap5au-Cl-ESg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0FA81800D48;
        Sat, 11 Jan 2020 14:52:16 +0000 (UTC)
Received: from [10.36.116.78] (ovpn-116-78.ams2.redhat.com [10.36.116.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1478B60BF3;
        Sat, 11 Jan 2020 14:52:13 +0000 (UTC)
Subject: Re: [PATCH v4] mm/memory_hotplug: Fix remove_memory() lockdep splat
To:     Qian Cai <cai@lca.pw>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Michal Hocko <mhocko@suse.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
References: <0BE8F7EF-01DC-47BD-899B-11FB8B40EB0A@lca.pw>
 <A5A31713-0D55-487C-814A-1415BB26DC1F@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <4fa0a559-dd5a-8405-0533-37cfe6973eeb@redhat.com>
Date:   Sat, 11 Jan 2020 15:52:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <A5A31713-0D55-487C-814A-1415BB26DC1F@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11.01.20 15:25, David Hildenbrand wrote:
>=20
>=20
>> Am 11.01.2020 um 14:56 schrieb Qian Cai <cai@lca.pw>:
>>
>> =EF=BB=BF
>>
>>> On Jan 11, 2020, at 6:03 AM, David Hildenbrand <david@redhat.com> wro=
te:
>>>
>>> So I just remember why I think this (and the previously reported done
>>> for ACPI DIMMs) are false positives. The actual locking order is
>>>
>>> onlining/offlining from user space:
>>>
>>> kn->count -> device_hotplug_lock -> cpu_hotplug_lock -> mem_hotplug_l=
ock
>>>
>>> memory removal:
>>>
>>> device_hotplug_lock -> cpu_hotplug_lock -> mem_hotplug_lock -> kn->co=
unt
>>>
>>>
>>> This looks like a locking inversion - but it's not. Whenever we come =
via
>>> user space we do a mutex_trylock(), which resolves this issue by back=
ing
>>> up. The device_hotplug_lock will prevent
>>>
>>> I have no clue why the device_hotplug_lock does not pop up in the
>>> lockdep report here. Sounds wrong to me.
>>>
>>> I think this is a false positive and not stable material.
>>
>> The point is that there are other paths does kn->count =E2=80=94> cpu_=
hotplug_lock without needing device_hotplug_lock to race with memory remo=
val.
>>
>> kmem_cache_shrink_all+0x50/0x100 (cpu_hotplug_lock.rw_sem/mem_hotplug_=
lock.rw_sem)
>> shrink_store+0x34/0x60
>> slab_attr_store+0x6c/0x170
>> sysfs_kf_write+0x70/0xb0
>> kernfs_fop_write+0x11c/0x270 ((kn->count)
>> __vfs_write+0x3c/0x70
>> vfs_write+0xcc/0x200
>> ksys_write+0x7c/0x140
>> system_call+0x5c/0x6
>>
>=20
> But not the lock of the memory devices, or am I missing something?
>=20

To clarify:

memory unplug will remove e.g., /sys/devices/system/memory/memoryX/,
which has a dedicated kn->count AFAIK

If you do a "echo 1 > /sys/kernel/slab/X/shrink", you would not lock the
kn->count of /sys/devices/system/memory/memoryX/, but the one of some
slab thingy.

The only scenario I could see is if remove_memory_block_devices() will
not only remove /sys/devices/system/memory/memoryX/, but also implicitly
e.g., /sys/kernel/slab/X/. If that is the case, then this is indeed not
a false positive, but something rather hard to trigger (which would
still classify as stable material).

--=20
Thanks,

David / dhildenb

