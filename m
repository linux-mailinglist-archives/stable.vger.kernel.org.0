Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 655C744B198
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 17:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhKIQ6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 11:58:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240633AbhKIQ6r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 11:58:47 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5291C061764;
        Tue,  9 Nov 2021 08:56:01 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id v20so22013053plo.7;
        Tue, 09 Nov 2021 08:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yKSJWjoS4FlMkEwfd1CEg+bbbf+O13lC3d6NjL84SQU=;
        b=ftNhU2MssZC00s1SE84SmHoY/W/7GRJTNg1cAbnHmPwm8uH/mdYfQDNeM0/q17x1F8
         ASDFcTr4crfGMTMp9S3QTpGUYn68xnPKjzAVGPE/H+fP6MGA0yNXzb/Xmb1KTzWhwhd5
         HPfxMOzeTx87I3zA/AlnmECJMoMuYr5c00LuFvZgE1HVTJM+DWxAs0RkW60wIhBloJu1
         soDrdabodY+dnzPAD7Orbvwk4uAOlgFzqkMj7r+42/YdyUvCRAjisT+RTuo6paSZfp33
         o2i6dIUrX0t7mARsn4vh/vKlsghjkPxY3TUg41eTInFlUR0NW52n+zIuI3hoKK3KRwRH
         vAiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yKSJWjoS4FlMkEwfd1CEg+bbbf+O13lC3d6NjL84SQU=;
        b=j1EmUQ6Y//+7LmmOn3m9xEZOtdgfzcVEBEbEUK+7hrdKSj325LXlTgMD5ZQ3LleESL
         JnjH4w/czeoT9sCo+LJ+ofG4uAg1D+7TA2W9l9IcutVL+WUe/OAlXNUyKPewQ43FffrX
         aQ1Wry5JAz9qYNy4QJ1ICPpsYFW8TZplTVPt5cjJDNb0GFrN0GeIDCtI794Aqa2FdcA9
         KPkYW0nAS8IBIfnifHH1DWSQYczCo1+k55lDC/bDdsJCFxo2Gx22F95whEmZYcWaLInK
         phlJtChtX1V0Dt9vYLUkBES8N+3bXQ1m3R9AYEfFt+fWRE7IwtXozJ9O2XcAVxJs+fDP
         h/eA==
X-Gm-Message-State: AOAM532UB6jwf2mXJNsx9PLYALA+idFAjJjnl4HBIgBFDMwxV5hq/JR9
        aDCgf2z/9NArd5jB2nprD0xlXKfumtI=
X-Google-Smtp-Source: ABdhPJwQOEhJkbDXIpZbMRrVVWPXjbBtWw0Cd7CqtFbEkIUAFHxinvd0TFYDLOmn6uoV7KiS/ipuoQ==
X-Received: by 2002:a17:90b:1b03:: with SMTP id nu3mr8810774pjb.240.1636476960940;
        Tue, 09 Nov 2021 08:56:00 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id l1sm3060889pjh.28.2021.11.09.08.55.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Nov 2021 08:56:00 -0800 (PST)
Subject: Re: [PATCH v3] mm: fix panic in __alloc_pages
To:     David Hildenbrand <david@redhat.com>,
        Alexey Makhalov <amakhalov@vmware.com>, linux-mm@kvack.org
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <908909e0-4815-b580-7ff5-d824d36a141c@redhat.com>
 <20211108202325.20304-1-amakhalov@vmware.com>
 <2e191db3-286f-90c6-bf96-3f89891e9926@gmail.com>
 <b6abd371-71d3-858b-9082-3d6a171cb8ef@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <dd205eeb-92f4-3eee-e8de-e1f8c4b1ea0e@gmail.com>
Date:   Tue, 9 Nov 2021 08:55:58 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <b6abd371-71d3-858b-9082-3d6a171cb8ef@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/8/21 11:03 PM, David Hildenbrand wrote:
> On 09.11.21 03:08, Eric Dumazet wrote:
>>
>>
>> On 11/8/21 12:23 PM, Alexey Makhalov wrote:
>>> There is a kernel panic caused by pcpu_alloc_pages() passing
>>> offlined and uninitialized node to alloc_pages_node() leading
>>> to panic by NULL dereferencing uninitialized NODE_DATA(nid).
>>>
>>>  CPU2 has been hot-added
>>>  BUG: unable to handle page fault for address: 0000000000001608
>>>  #PF: supervisor read access in kernel mode
>>>  #PF: error_code(0x0000) - not-present page
>>>  PGD 0 P4D 0
>>>  Oops: 0000 [#1] SMP PTI
>>>  CPU: 0 PID: 1 Comm: systemd Tainted: G            E     5.15.0-rc7+ #11
>>>  Hardware name: VMware, Inc. VMware7,1/440BX Desktop Reference Platform, BIOS VMW
>>>
>>>  RIP: 0010:__alloc_pages+0x127/0x290
>>>  Code: 4c 89 f0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 44 89 e0 48 8b 55 b8 c1 e8 0c 83 e0 01 88 45 d0 4c 89 c8 48 85 d2 0f 85 1a 01 00 00 <45> 3b 41 08 0f 82 10 01 00 00 48 89 45 c0 48 8b 00 44 89 e2 81 e2
>>>  RSP: 0018:ffffc900006f3bc8 EFLAGS: 00010246
>>>  RAX: 0000000000001600 RBX: 0000000000000000 RCX: 0000000000000000
>>>  RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000cc2
>>>  RBP: ffffc900006f3c18 R08: 0000000000000001 R09: 0000000000001600
>>>  R10: ffffc900006f3a40 R11: ffff88813c9fffe8 R12: 0000000000000cc2
>>>  R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000cc2
>>>  FS:  00007f27ead70500(0000) GS:ffff88807ce00000(0000) knlGS:0000000000000000
>>>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>  CR2: 0000000000001608 CR3: 000000000582c003 CR4: 00000000001706b0
>>>  Call Trace:
>>>   pcpu_alloc_pages.constprop.0+0xe4/0x1c0
>>>   pcpu_populate_chunk+0x33/0xb0
>>>   pcpu_alloc+0x4d3/0x6f0
>>>   __alloc_percpu_gfp+0xd/0x10
>>>   alloc_mem_cgroup_per_node_info+0x54/0xb0
>>>   mem_cgroup_alloc+0xed/0x2f0
>>>   mem_cgroup_css_alloc+0x33/0x2f0
>>>   css_create+0x3a/0x1f0
>>>   cgroup_apply_control_enable+0x12b/0x150
>>>   cgroup_mkdir+0xdd/0x110
>>>   kernfs_iop_mkdir+0x4f/0x80
>>>   vfs_mkdir+0x178/0x230
>>>   do_mkdirat+0xfd/0x120
>>>   __x64_sys_mkdir+0x47/0x70
>>>   ? syscall_exit_to_user_mode+0x21/0x50
>>>   do_syscall_64+0x43/0x90
>>>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>
>>> Panic can be easily reproduced by disabling udev rule for
>>> automatic onlining hot added CPU followed by CPU with
>>> memoryless node (NUMA node with CPU only) hot add.
>>>
>>> Hot adding CPU and memoryless node does not bring the node
>>> to online state. Memoryless node will be onlined only during
>>> the onlining its CPU.
>>>
>>> Node can be in one of the following states:
>>> 1. not present.(nid == NUMA_NO_NODE)
>>> 2. present, but offline (nid > NUMA_NO_NODE, node_online(nid) == 0,
>>> 				NODE_DATA(nid) == NULL)
>>> 3. present and online (nid > NUMA_NO_NODE, node_online(nid) > 0,
>>> 				NODE_DATA(nid) != NULL)
>>>
>>> Percpu code is doing allocations for all possible CPUs. The
>>> issue happens when it serves hot added but not yet onlined
>>> CPU when its node is in 2nd state. This node is not ready
>>> to use, fallback to numa_mem_id().
>>>
>>> Signed-off-by: Alexey Makhalov <amakhalov@vmware.com>
>>> Reviewed-by: David Hildenbrand <david@redhat.com>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: David Hildenbrand <david@redhat.com>
>>> Cc: Michal Hocko <mhocko@suse.com>
>>> Cc: Oscar Salvador <osalvador@suse.de>
>>> Cc: Dennis Zhou <dennis@kernel.org>
>>> Cc: Tejun Heo <tj@kernel.org>
>>> Cc: Christoph Lameter <cl@linux.com>
>>> Cc: linux-mm@kvack.org
>>> Cc: linux-kernel@vger.kernel.org
>>> Cc: stable@vger.kernel.org
>>> ---
>>>  mm/percpu-vm.c | 8 ++++++--
>>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
>>> index 2054c9213..f58d73c92 100644
>>> --- a/mm/percpu-vm.c
>>> +++ b/mm/percpu-vm.c
>>> @@ -84,15 +84,19 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
>>>  			    gfp_t gfp)
>>>  {
>>>  	unsigned int cpu, tcpu;
>>> -	int i;
>>> +	int i, nid;
>>>  
>>>  	gfp |= __GFP_HIGHMEM;
>>>  
>>>  	for_each_possible_cpu(cpu) {
>>> +		nid = cpu_to_node(cpu);
>>> +		if (nid == NUMA_NO_NODE || !node_online(nid))
>>> +			nid = numa_mem_id();
>>
>> Maybe we should fail this fallback if (gfp & __GFP_THISNODE) ?
> 
> ... and what to do then? Fail the allocation? We could do that, but ...
> 
>>
>> Or maybe there is no support for this constraint in per-cpu allocator anyway.
>>
> 
> ... looking at mm/percpu.c, I don't think there are any users (IOW not
> supported?).
> 
>> I am a bit worried that we do not really know if pages are
>> allocated on the right node or not.
> 
> Even without __GFP_THISNODE it's sub-optimal. But if there is no memory
> on that node, there is barely anything we can do than falling back.

Some users need having fine control.
They would prefer -ENOMEM instead of a fallback.

Usually, /prov/vmallocinfo tells us numbers of allocated pages per node,
but it does not work (yet) with pcpu_get_vm_areas zones.

# grep alloc_large_system_hash /proc/vmallocinfo
0x00000000fb57af48-0x0000000084e058f0 134221824 alloc_large_system_hash+0x10f/0x2a0 pages=32768 vmalloc vpages N0=16384 N1=16384

# grep pcpu_get_vm_areas /proc/vmallocinfo 
0x000000009d7bd01f-0x000000002aa861cb 12582912 pcpu_get_vm_areas+0x0/0xa90 vmalloc
0x000000002aa861cb-0x0000000019fb1839 12582912 pcpu_get_vm_areas+0x0/0xa90 vmalloc
0x0000000019fb1839-0x00000000ba64fb09 12582912 pcpu_get_vm_areas+0x0/0xa90 vmalloc
0x00000000ba64fb09-0x00000000d688f04b 12582912 pcpu_get_vm_areas+0x0/0xa90 vmalloc
0x00000000d688f04b-0x0000000074e3854e 12582912 pcpu_get_vm_areas+0x0/0xa90 vmalloc
