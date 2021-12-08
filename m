Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C030746CECB
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 09:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhLHI2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 03:28:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57778 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231496AbhLHI2P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 03:28:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638951882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mGNzfxil83BwgKb8q3ZzS1nHV7JGiQQ9FuAbcm/1Kc0=;
        b=H9zhH+Sm+BJlEykkN+hlpt1ViBisN4Vpa5yQYVAOb4bS5uXKTRNC/8laOinjFjy0d+wOv/
        1ndgpBYIbnmueK+tF0dXJiXfCfi4hnAb9YvHEVfp3FgWBh0pxKbfYboxt2tjHR8Ca9derd
        zIleLfSWuNT8xVOWoascOlZTP0NKf+I=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-566-tKRCJB53N1ahCfG3IWYL1w-1; Wed, 08 Dec 2021 03:24:41 -0500
X-MC-Unique: tKRCJB53N1ahCfG3IWYL1w-1
Received: by mail-wm1-f72.google.com with SMTP id i131-20020a1c3b89000000b00337f92384e0so2629224wma.5
        for <stable@vger.kernel.org>; Wed, 08 Dec 2021 00:24:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=mGNzfxil83BwgKb8q3ZzS1nHV7JGiQQ9FuAbcm/1Kc0=;
        b=ghCqjoHsmZkb2eDP0RjtVMa6frnYWhvXJfW4UgOCkaUl+GIf668uVBbycLPbNcKcJq
         qA7tRf6GVf6+vZp0WH0CeIohhdY9Z+7W2h8IBPlCasziH1hIg5N/0NPEMzmUbiH5V32m
         bGQ9AVKvnjNzJPp21khxcJP9vBpYeU28mF1CpBGHxYxeSaTWXYr8a3whYRF7/qOjD64N
         aOAsM044msAvsXot3ridjSKaeUGeEFJcFGdzLnyx+iWhMnPjj8vGJi95MVHz/u4OH2ii
         ZQNoyOM0brEe4UWK8VUlQjXCc7GrLSIREscWi/cIvZAvGrzUI6/oYF8cQV26KkEuIe1u
         aR0Q==
X-Gm-Message-State: AOAM532olp/TGfPLsze72ySoTxOHaEHU0QxZYm3V04lSR8W5EJ5CcPz7
        Pv3kEM4cDEGWUhEVu5AXr9ZvcKbc1MPRmxDuLl10gGMOYV5Yjmi4upp1K0DWpqfRID/Ay94l88F
        nTpz8iTk9TQveQ5Fc
X-Received: by 2002:adf:f64b:: with SMTP id x11mr58346294wrp.4.1638951880443;
        Wed, 08 Dec 2021 00:24:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyPcE1kffLfqAUuWfGBdEEWvTivlPYMkkV5BIbduu2zNPLXeuz7ReUNWJm/wEYKcnQJHssqHQ==
X-Received: by 2002:adf:f64b:: with SMTP id x11mr58346276wrp.4.1638951880244;
        Wed, 08 Dec 2021 00:24:40 -0800 (PST)
Received: from [192.168.3.132] (p5b0c62ba.dip0.t-ipconnect.de. [91.12.98.186])
        by smtp.gmail.com with ESMTPSA id c4sm2017397wrr.37.2021.12.08.00.24.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 00:24:39 -0800 (PST)
Message-ID: <5a44c44a-141c-363d-c23e-558edc23b9b4@redhat.com>
Date:   Wed, 8 Dec 2021 09:24:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3] mm: fix panic in __alloc_pages
Content-Language: en-US
To:     Michal Hocko <mhocko@suse.com>
Cc:     Alexey Makhalov <amakhalov@vmware.com>,
        Dennis Zhou <dennis@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <Ya992YvnZ3e3G6h0@dhcp22.suse.cz>
 <b7deaf90-8c3c-c22a-b8dc-e6d98bc93ae6@redhat.com>
 <Ya+EHUYgzo8GaCeq@dhcp22.suse.cz>
 <d01c20fe-86d2-1dc8-e56d-15c0da49afb3@redhat.com>
 <Ya+LbaD8mkvIdq+c@dhcp22.suse.cz> <Ya+Nq2fWrSgl79Bn@dhcp22.suse.cz>
 <2E174230-04F3-4798-86D5-1257859FFAD8@vmware.com>
 <21539fc8-15a8-1c8c-4a4f-8b85734d2a0e@redhat.com>
 <78E39A43-D094-4706-B4BD-18C0B18EB2C3@vmware.com>
 <f9786109-518f-38d4-0270-a3e87a13c4ef@redhat.com>
 <YbBo5uvV7wtgOYrj@dhcp22.suse.cz>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <YbBo5uvV7wtgOYrj@dhcp22.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08.12.21 09:12, Michal Hocko wrote:
> On Tue 07-12-21 19:03:28, David Hildenbrand wrote:
>> On 07.12.21 18:17, Alexey Makhalov wrote:
>>>
>>>
>>>> On Dec 7, 2021, at 9:13 AM, David Hildenbrand <david@redhat.com> wrote:
>>>>
>>>> On 07.12.21 18:02, Alexey Makhalov wrote:
>>>>>
>>>>>
>>>>>> On Dec 7, 2021, at 8:36 AM, Michal Hocko <mhocko@suse.com> wrote:
>>>>>>
>>>>>> On Tue 07-12-21 17:27:29, Michal Hocko wrote:
>>>>>> [...]
>>>>>>> So your proposal is to drop set_node_online from the patch and add it as
>>>>>>> a separate one which handles
>>>>>>> 	- sysfs part (i.e. do not register a node which doesn't span a
>>>>>>> 	  physical address space)
>>>>>>> 	- hotplug side of (drop the pgd allocation, register node lazily
>>>>>>> 	  when a first memblocks are registered)
>>>>>>
>>>>>> In other words, the first stage
>>>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>>>> index c5952749ad40..f9024ba09c53 100644
>>>>>> --- a/mm/page_alloc.c
>>>>>> +++ b/mm/page_alloc.c
>>>>>> @@ -6382,7 +6382,11 @@ static void __build_all_zonelists(void *data)
>>>>>> 	if (self && !node_online(self->node_id)) {
>>>>>> 		build_zonelists(self);
>>>>>> 	} else {
>>>>>> -		for_each_online_node(nid) {
>>>>>> +		/*
>>>>>> +		 * All possible nodes have pgdat preallocated
>>>>>> +		 * free_area_init
>>>>>> +		 */
>>>>>> +		for_each_node(nid) {
>>>>>> 			pg_data_t *pgdat = NODE_DATA(nid);
>>>>>>
>>>>>> 			build_zonelists(pgdat);
>>>>>
>>>>> Will it blow up memory usage for the nodes which might never be onlined?
>>>>> I prefer the idea of init on demand.
>>>>>
>>>>> Even now there is an existing problem.
>>>>> In my experiments, I observed _huge_ memory consumption increase by increasing number
>>>>> of possible numa nodes. I’m going to report it in separate mail thread.
>>>>
>>>> I already raised that PPC might be problematic in that regard. Which
>>>> architecture / setup do you have in mind that can have a lot of possible
>>>> nodes?
>>>>
>>> It is x86_64 VMware VM, not the regular one, but specially configured (1 vCPU per node,
>>> with hot-plug support, 128 possible nodes)  
>>
>> I thought the pgdat would be smaller but I just gave it a test:
> 
> Yes, pgdat is quite large! Just embeded zones can eat a lot.
> 
>> On my system, pgdata_t is 173824 bytes. So 128 nodes would correspond to
>> 21 MiB, which is indeed a lot. I assume it's due to "struct zonelist",
>> which has MAX_ZONES_PER_ZONELIST == (MAX_NUMNODES * MAX_NR_ZONES) zone
>> references ...
> 
> This is what pahole tells me
> struct pglist_data {
>         struct zone                node_zones[4] __attribute__((__aligned__(64))); /*     0  5632 */
>         /* --- cacheline 88 boundary (5632 bytes) --- */
>         struct zonelist            node_zonelists[1];    /*  5632    80 */
> 	[...]
>         /* size: 6400, cachelines: 100, members: 27 */
>         /* sum members: 6369, holes: 5, sum holes: 31 */
> 
> with my particular config (which is !NUMA). I haven't really checked
> whether there are other places which might scale with MAX_NUM_NODES or
> something like that.
> 
> Anyway, is 21MB of wasted space for 128 Node machine something really
> note worthy?
> 

I think we'll soon might see setups (again, CXL is an example, but als
owhen providing a dynamic amount of performance differentiated memory
via virtio-mem) where this will most probably matter. With performance
differentiated memory we'll see a lot more nodes getting used in
general, and a lot more nodes eventually getting hotplugged.

If 128 nodes is realistic, I cannot tell.

We could optimize by allocating some members dynamically. For example
we'll never need MAX_NUMNODES entries, but only the number of possible
nodes.

-- 
Thanks,

David / dhildenb

