Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE02028BED4
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 19:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404035AbgJLRLL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 13:11:11 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15357 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404025AbgJLRLL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Oct 2020 13:11:11 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f848e220000>; Mon, 12 Oct 2020 10:10:58 -0700
Received: from rcampbell-dev.nvidia.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 12 Oct
 2020 17:11:07 +0000
Subject: Re: [PATCH] mm/memcg: fix device private memcg accounting
To:     Johannes Weiner <hannes@cmpxchg.org>
CC:     Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Ira Weiny <ira.weiny@intel.com>, <stable@vger.kernel.org>
References: <20201009215952.2726-1-rcampbell@nvidia.com>
 <20201009155055.f87de51ea04d4ea879e3981a@linux-foundation.org>
 <d1aab0b0-4327-38da-6587-98f1740228fd@nvidia.com>
 <20201012132859.GD163830@cmpxchg.org>
X-Nvconfidentiality: public
From:   Ralph Campbell <rcampbell@nvidia.com>
Message-ID: <1d029649-7f34-4f8a-3721-0154001a63ac@nvidia.com>
Date:   Mon, 12 Oct 2020 10:11:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20201012132859.GD163830@cmpxchg.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602522658; bh=LQh2H3qyxp3qJsZdje88nocGHD8ApGuulqjnVFd+f0M=;
        h=Subject:To:CC:References:X-Nvconfidentiality:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=pdinanZ3WSo3hvEXLhjY3+I1OdTsCFPXR/so9doT6WLjiCZ900YJfHXigHEIdA3BH
         eBzuzXwGbMAokDvcMdlvwMnhRroK2u5iwqpAUW+KOqw2R0qlVU2G+N55GKkRVND0G9
         SgeNKeXDWCW5+c9QeRvkROP5MkM34rlOQYEt+jX2t1DB/szIN7yHVFG70hdcoGYKx3
         NDnfqJkRWnUwjiwSsnOvbIWFZc27fqhxcchQu/rXTiQogEXz5FLzxafOCNXkLEhg1z
         N/yWpTI9PXZap0CwvA47nsaFJcjR5+MwnQDPF+cOLLJiUilH5cyTg7k62n/7Qup+Td
         uDC/A81hnSbxA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 10/12/20 6:28 AM, Johannes Weiner wrote:
> On Fri, Oct 09, 2020 at 05:00:37PM -0700, Ralph Campbell wrote:
>>
>> On 10/9/20 3:50 PM, Andrew Morton wrote:
>>> On Fri, 9 Oct 2020 14:59:52 -0700 Ralph Campbell <rcampbell@nvidia.com> wrote:
>>>
>>>> The code in mc_handle_swap_pte() checks for non_swap_entry() and returns
>>>> NULL before checking is_device_private_entry() so device private pages
>>>> are never handled.
>>>> Fix this by checking for non_swap_entry() after handling device private
>>>> swap PTEs.
> 
> The fix looks good to me.
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
>>> But this makes me suspect the answer is "there aren't any that we know
>>> of".  Are you sure a cc:stable is warranted?
>>>
>>
>> I assume the memory cgroup accounting would be off somehow when moving
>> a process to another memory cgroup.
>> Currently, the device private page is charged like a normal anonymous page
>> when allocated and is uncharged when the page is freed so I think that path is OK.
>> Maybe someone who knows more about memory cgroup accounting can comment?
> 
> As for whether to CC stable, I'm leaning toward no:
> 
> - When moving tasks, we'd leave their device pages behind in the old
>    cgroup. This isn't great, but it doesn't cause counter imbalances or
>    corruption or anything - we also skip locked pages, we used to skip
>    pages mapped by more than one pte, the user can select whether to
>    move pages along tasks at all, and if so, whether only anon or file.
> 
> - Charge moving itself is a bit of a questionable feature, and users
>    have been moving away from it. Leaving tasks in a cgroup and
>    changing the configuration is a heck of a lot cheaper than moving
>    potentially gigabytes of pages to another configuration domain.
> 
> - According to the Fixes tag, this isn't a regression, either. Since
>    their inception, we have never migrated device pages.

Thanks for the Acked-by and the comments.
I assume Andrew will update the tags when queuing this up unless he wants me to resend.
