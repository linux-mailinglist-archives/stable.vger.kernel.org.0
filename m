Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D52265442
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 23:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbgIJVm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 17:42:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36669 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730748AbgIJMiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Sep 2020 08:38:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599741488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=Zl9jhLWd0ntBbano9gVqm77GPWcuI33dAlYAek1cWcE=;
        b=jGkFWix/XgFFlnzBBgKpnx2Y3Y3HfsMEJ5PTYNHElaSdeJtDkDON2DaK2UrOHeHh3ZFdfh
        pjj+myGV5repiITx4kwTLHsCQWP29Y3GGVKEI4cQ/4hA9RoAtkphTYoGo3iG3eRJ1U83GW
        9HOtmjPIdpHwU1ZzKnPVioK5O4iMBOI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-yzHLsV-oOyaT9_QxHajLIw-1; Thu, 10 Sep 2020 08:38:05 -0400
X-MC-Unique: yzHLsV-oOyaT9_QxHajLIw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 507C23FFE;
        Thu, 10 Sep 2020 12:38:03 +0000 (UTC)
Received: from [10.36.113.88] (ovpn-113-88.ams2.redhat.com [10.36.113.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDC1187D99;
        Thu, 10 Sep 2020 12:38:00 +0000 (UTC)
Subject: Re: [PATCH] mm: don't rely on system state to detect hot-plug
 operations
To:     Laurent Dufour <ldufour@linux.ibm.com>,
        Michal Hocko <mhocko@suse.com>
Cc:     akpm@linux-foundation.org, Oscar Salvador <osalvador@suse.de>,
        rafael@kernel.org, nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
References: <5cbd92e1-c00a-4253-0119-c872bfa0f2bc@redhat.com>
 <20200908170835.85440-1-ldufour@linux.ibm.com>
 <20200909074011.GD7348@dhcp22.suse.cz>
 <9faac1ce-c02d-7dbc-f79a-4aaaa5a73d28@linux.ibm.com>
 <20200909090953.GE7348@dhcp22.suse.cz>
 <4cdb54be-1a92-4ba4-6fee-3b415f3468a9@linux.ibm.com>
 <20200909105914.GF7348@dhcp22.suse.cz>
 <74a62b00-235e-7deb-2814-f3b240fea25e@linux.ibm.com>
 <20200910072331.GB28354@dhcp22.suse.cz>
 <31cfdf35-618f-6f56-ef16-0d999682ad02@linux.ibm.com>
 <20200910111246.GE28354@dhcp22.suse.cz>
 <bd6f2d09-f4e2-0a63-3511-e0f9bf283fe3@linux.ibm.com>
 <65b2680d-b02e-16c9-66a4-e38b9d3fa52b@redhat.com>
 <ac9d3ea9-3735-8d38-e2d3-4eb69d5471b1@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 WNyWQQ==
Organization: Red Hat GmbH
Message-ID: <391488b4-1603-efe7-3a80-54f407bd67ed@redhat.com>
Date:   Thu, 10 Sep 2020 14:38:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <ac9d3ea9-3735-8d38-e2d3-4eb69d5471b1@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10.09.20 14:36, Laurent Dufour wrote:
> Le 10/09/2020 à 14:00, David Hildenbrand a écrit :
>> On 10.09.20 13:35, Laurent Dufour wrote:
>>> Le 10/09/2020 à 13:12, Michal Hocko a écrit :
>>>> On Thu 10-09-20 09:51:39, Laurent Dufour wrote:
>>>>> Le 10/09/2020 à 09:23, Michal Hocko a écrit :
>>>>>> On Wed 09-09-20 18:07:15, Laurent Dufour wrote:
>>>>>>> Le 09/09/2020 à 12:59, Michal Hocko a écrit :
>>>>>>>> On Wed 09-09-20 11:21:58, Laurent Dufour wrote:
>>>>>> [...]
>>>>>>>>> For the point a, using the enum allows to know in
>>>>>>>>> register_mem_sect_under_node() if the link operation is due to a hotplug
>>>>>>>>> operation or done at boot time.
>>>>>>>>
>>>>>>>> Yes, but let me repeat. We have a mess here and different paths check
>>>>>>>> for the very same condition by different ways. We need to unify those.
>>>>>>>
>>>>>>> What are you suggesting to unify these checks (using a MP_* enum as
>>>>>>> suggested by David, something else)?
>>>>>>
>>>>>> We do have system_state check spread at different places. I would use
>>>>>> this one and wrap it behind a helper. Or have I missed any reason why
>>>>>> that wouldn't work for this case?
>>>>>
>>>>> That would not work in that case because memory can be hot-added at the
>>>>> SYSTEM_SCHEDULING system state and the regular memory is also registered at
>>>>> that system state too. So system state is not enough to discriminate between
>>>>> the both.
>>>>
>>>> If that is really the case all other places need a fix as well.
>>>> Btw. could you be more specific about memory hotplug during early boot?
>>>> How that happens? I am only aware of https://lkml.kernel.org/r/20200818110046.6664-1-osalvador@suse.de
>>>> and that doesn't happen as early as SYSTEM_SCHEDULING.
>>>
>>> That points has been raised by David, quoting him here:
>>>
>>>> IIRC, ACPI can hotadd memory while SCHEDULING, this patch would break that.
>>>>
>>>> Ccing Oscar, I think he mentioned recently that this is the case with ACPI.
>>>
>>> Oscar told that he need to investigate further on that.
>>>
>>> On my side I can't get these ACPI "early" hot-plug operations to happen so I
>>> can't check that.
>>>
>>> If this is clear that ACPI memory hotplug doesn't happen at SYSTEM_SCHEDULING,
>>> the patch I proposed at first is enough to fix the issue.
>>>
>>
>> Booting a qemu guest with 4 coldplugged DIMMs gives me:
>>
>> :/root# dmesg | grep link_mem
>> [    0.302247] link_mem_sections() during 1
>> [    0.445086] link_mem_sections() during 1
>> [    0.445766] link_mem_sections() during 1
>> [    0.446749] link_mem_sections() during 1
>> [    0.447746] link_mem_sections() during 1
>>
>> So AFAICs everything happens during SYSTEM_SCHEDULING - boot memory and
>> ACPI (cold)plug.
>>
>> To make forward progress with this, relying on the system_state is
>> obviously not sufficient.
>>
>> 1. We have to fix this instance and the instance directly in
>> get_nid_for_pfn() by passing in the context (I once had a patch to clean
>> that up, to not have two state checks, but it got lost somewhere).
>>
>> 2. The "system_state < SYSTEM_RUNNING" check in
>> register_memory_resource() is correct. Actual memory hotplug after boot
>> is not impacted. (I remember we discussed this exact behavior back then)
>>
>> 3. build_all_zonelists() should work as expected, called from
>> start_kernel() before sched_init().
> 
> I'm bit confused now.
> Since hotplug operation is happening at SYSTEM_SCHEDULING like the regular 
> memory registration, would it be enough to add a parameter to 
> register_mem_sect_under_node() (reworking the memmap_context enum)?
> That way the check is not based on the system state but on the calling path.
> 

That would have been my suggestion to definitely fix it - maybe
Michal/Oscar have a better suggestion know that we know what's going on.

-- 
Thanks,

David / dhildenb

