Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A4B442A13
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 10:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbhKBJHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 05:07:00 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:58468 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbhKBJG6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 05:06:58 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 58FE92190B;
        Tue,  2 Nov 2021 09:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1635843863; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FQEk7euf1G3s43BnBfla4wo2KxK/XLAKoQBCeTgbFlg=;
        b=gwqfHlozMmRuDrNEqUdlPz/QNOyKLaEHUOPCTD/fwVhFXUbh95iEqVl1jM6gHypg8HqxA0
        WcYpkHBTHRNlmo9prJIrq672nWBeFKVmSyLyT5NOJPo4LH8mMuEwoIm8KaFBJXupjkebRG
        gth4aIr8JV0/YYHlfbvSFfluFwCcmcE=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 26AD0A3B83;
        Tue,  2 Nov 2021 09:04:23 +0000 (UTC)
Date:   Tue, 2 Nov 2021 10:04:22 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Alexey Makhalov <amakhalov@vmware.com>
Cc:     David Hildenbrand <david@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Oscar Salvador <OSalvador@suse.com>
Subject: Re: [PATCH] mm: fix panic in __alloc_pages
Message-ID: <YYD/FkpAk5IvmOux@dhcp22.suse.cz>
References: <20211101201312.11589-1-amakhalov@vmware.com>
 <YYDtDkGNylpAgPIS@dhcp22.suse.cz>
 <7136c959-63ff-b866-b8e4-f311e0454492@redhat.com>
 <C69EF2FE-DFF6-492E-AD40-97A53739C3EC@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C69EF2FE-DFF6-492E-AD40-97A53739C3EC@vmware.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It is hard to follow your reply as your email client is not quoting
properly. Let me try to reconstruct

On Tue 02-11-21 08:48:27, Alexey Makhalov wrote:
> On 02.11.21 08:47, Michal Hocko wrote:
[...]
>>>>  CPU2 has been hot-added
>>>>  BUG: unable to handle page fault for address: 0000000000001608
>>>>  #PF: supervisor read access in kernel mode
>>>>  #PF: error_code(0x0000) - not-present page
>>>>  PGD 0 P4D 0
>>>>  Oops: 0000 [#1] SMP PTI
>>>>  CPU: 0 PID: 1 Comm: systemd Tainted: G            E     5.15.0-rc7+ #11
>>>>  Hardware name: VMware, Inc. VMware7,1/440BX Desktop Reference Platform, BIOS VMW
>>>>
>>>>  RIP: 0010:__alloc_pages+0x127/0x290
>>> 
>>> Could you resolve this into a specific line of the source code please?

This got probably unnoticed. I would be really curious whether this is
a broken zonelist or something else.
 
>>>> Node can be in one of the following states:
>>>> 1. not present (nid == NUMA_NO_NODE)
>>>> 2. present, but offline (nid > NUMA_NO_NODE, node_online(nid) == 0,
>>>> 				NODE_DATA(nid) == NULL)
>>>> 3. present and online (nid > NUMA_NO_NODE, node_online(nid) > 0,
>>>> 				NODE_DATA(nid) != NULL)
>>>>
>>>> alloc_page_{bulk_array}node() functions verify for nid validity only
>>>> and do not check if nid is online. Enhanced verification check allows
>>>> to handle page allocation when node is in 2nd state.
>>> 
>>> I do not think this is a correct approach. We should make sure that the
>>> proper fallback node is used instead. This means that the zone list is
>>> initialized properly. IIRC this has been a problem in the past and it
>>> has been fixed. The initialization code is quite subtle though so it is
>>> possible that this got broken again.

> This approach behaves in the same way as CPU was not yet added. (state #1).
> So, we can think of state #2 as state #1 when CPU is not present.

>> I'm a little confused:
>> 
>> In add_memory_resource() we hotplug the new node if required and set it
>> online. Memory might get onlined later, via online_pages().
>
> You are correct. In case of memory hot add, it is true. But in case of adding
> CPU with memoryless node, try_node_online() will be called only during CPU
> onlining, see cpu_up().
> 
> Is there any reason why try_online_node() resides in cpu_up() and not in add_cpu()?
> I think it would be correct to online node during the CPU hot add to align with
> memory hot add.

I am not familiar with cpu hotplug, but this doesn't seem to be anything
new so how come this became problem only now?

>> So after add_memory_resource()->__try_online_node() succeeded, we have
>> an online pgdat -- essentially 3.
>> 
> This patch detects if we're past 3. but says that it reproduced by
> disabling *memory* onlining.
> This is the hot adding of both new CPU and new _memoryless_ node (with CPU only)
> And onlining CPU makes its node online. Disabling CPU onlining puts new node
> into state #2, which leads to repro.    
> 
>> Before we online memory for a hotplugged node, all zones are !populated.
>> So once we online memory for a !populated zone in online_pages(), we
>> trigger setup_zone_pageset().
>> 
>> 
>> The confusing part is that this patch checks for 3. but says it can be
>> reproduced by not onlining *memory*. There seems to be something missing.
> 
> Do we maybe need a proper populated_zone() check before accessing zone data?

No, we need them initialize properly.
-- 
Michal Hocko
SUSE Labs
