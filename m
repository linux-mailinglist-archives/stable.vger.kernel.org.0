Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5FC3289CA3
	for <lists+stable@lfdr.de>; Sat, 10 Oct 2020 02:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728542AbgJJAQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 20:16:36 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4417 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728611AbgJJABA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 20:01:00 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f80f9760000>; Fri, 09 Oct 2020 16:59:50 -0700
Received: from rcampbell-dev.nvidia.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 10 Oct
 2020 00:00:42 +0000
Subject: Re: [PATCH] mm/memcg: fix device private memcg accounting
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Michal Hocko" <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Ira Weiny <ira.weiny@intel.com>, <stable@vger.kernel.org>
References: <20201009215952.2726-1-rcampbell@nvidia.com>
 <20201009155055.f87de51ea04d4ea879e3981a@linux-foundation.org>
From:   Ralph Campbell <rcampbell@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <d1aab0b0-4327-38da-6587-98f1740228fd@nvidia.com>
Date:   Fri, 9 Oct 2020 17:00:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20201009155055.f87de51ea04d4ea879e3981a@linux-foundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602287990; bh=Us6utgoPebZq88AOhUuXmDuRmb+E4XSLkLaXZoYTNTE=;
        h=Subject:To:CC:References:From:X-Nvconfidentiality:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=iROueIQaQrO/x4pGQ5v6OqqoOKyMi9Es4tkR4HMVEI8xMT6oLWIWP6iq1upLtberH
         +6V4+BWrvHQyJK4yHkyI38Siwr1tQ9/smCkCqt5I2UKBXN4YDAF+qPxgMGkqOll4YM
         nhbaUlawwEgU59fLkN0y2u6KbDSicb5L5uOgIfvdZiIQBffNQzex1c5VkVSRaz4Rdy
         5eXSRS2/vAiMTd2L9aFXo3yM+4RCKevyPDwWuiNCrxl/pHo4+VAav6wyPgMQXMA1o6
         wTC2BxUgt6rkx4TpHUfXS15vpEkdJFr1JVNPAHHo8h/r6ZBaT6SjCJWgDGNv2wUq5R
         9LLlkYSx66hqQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 10/9/20 3:50 PM, Andrew Morton wrote:
> On Fri, 9 Oct 2020 14:59:52 -0700 Ralph Campbell <rcampbell@nvidia.com> wrote:
> 
>> The code in mc_handle_swap_pte() checks for non_swap_entry() and returns
>> NULL before checking is_device_private_entry() so device private pages
>> are never handled.
>> Fix this by checking for non_swap_entry() after handling device private
>> swap PTEs.
>>
>> Cc: stable@vger.kernel.org
> 
> I was going to ask "what are the end-user visible effects of the bug".
> This is important information with a cc:stable.
> 
>>
>> I'm not sure exactly how to test this. I ran the HMM self tests but
>> that is a minimal sanity check. I think moving the self test from one
>> memory cgroup to another while it is running would exercise this patch.
>> I'm looking at how the test could move itself to another group after
>> migrating some anonymous memory to the test driver.
>>
> 
> But this makes me suspect the answer is "there aren't any that we know
> of".  Are you sure a cc:stable is warranted?
> 

I assume the memory cgroup accounting would be off somehow when moving
a process to another memory cgroup.
Currently, the device private page is charged like a normal anonymous page
when allocated and is uncharged when the page is freed so I think that path is OK.
Maybe someone who knows more about memory cgroup accounting can comment?
