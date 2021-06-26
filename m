Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334233B4BC9
	for <lists+stable@lfdr.de>; Sat, 26 Jun 2021 03:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhFZBV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 21:21:28 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:11098 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbhFZBV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Jun 2021 21:21:27 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GBbXx16sTzZhxp;
        Sat, 26 Jun 2021 09:16:01 +0800 (CST)
Received: from dggpemm500001.china.huawei.com (7.185.36.107) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 26 Jun 2021 09:19:04 +0800
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemm500001.china.huawei.com (7.185.36.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 26 Jun 2021 09:19:03 +0800
Subject: Re: [PATCH stable v5.10 0/7] arm64: Default to 32-bit wide ZONE_DMA
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Jing Xiangfeng <jingxiangfeng@huawei.com>,
        <catalin.marinas@arm.com>, <will@kernel.org>,
        <akpm@linux-foundation.org>, <guohanjun@huawei.com>,
        <sudeep.holla@arm.com>, <song.bao.hua@hisilicon.com>,
        <ardb@kernel.org>, <anshuman.khandual@arm.com>,
        <stable@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Li Huafei <lihuafei1@huawei.com>
References: <827b317d7f5da6e048806922098291faacdb19f9.camel@suse.de>
 <YETwL6QGWFyJTAzk@kroah.com> <604597E3.5000605@huawei.com>
 <YEX1OcbVNSqwwusF@kroah.com>
 <31cd8432-2466-555d-7617-ae48cbcd4244@huawei.com>
 <8b0a4f25-0803-9341-f3a4-277d16802295@huawei.com>
 <YNLe4CGtOgVvTOMN@kroah.com>
 <e47df0fd-0ddd-408b-2972-1b6d0a786f00@huawei.com>
 <YNLkDJ8zHGRZ5iG8@kroah.com>
 <f692a6e5-9e07-8b96-b7d3-213e6e3d071b@huawei.com>
 <YNWtyJaDY17829g9@kroah.com>
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
Message-ID: <29d5f027-c7d7-c7da-683b-cab12cc093f0@huawei.com>
Date:   Sat, 26 Jun 2021 09:19:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <YNWtyJaDY17829g9@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500001.china.huawei.com (7.185.36.107)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2021/6/25 18:19, Greg KH wrote:
> On Wed, Jun 23, 2021 at 04:01:10PM +0800, Kefeng Wang wrote:
>>
>> Let's inline the link:
>> https://lore.kernel.org/lkml/20210303073319.2215839-1-jingxiangfeng@huawei.com/
>>
>> The following 7 patches(we asked from link) has merged into lts5.10(tag:
>> v5.10.22)
>>
>>    4d7ed9a49b0c mm: Remove examples from enum zone_type comment
>>    8eaef922e938 arm64: mm: Set ZONE_DMA size based on early IORT scan
>>    35ec3d09ff6a arm64: mm: Set ZONE_DMA size based on devicetree's dma-ranges
>>    a9861e7fa4f8 of: unittest: Add test for of_dma_get_max_cpu_address()
>>    18bf6e998d08 of/address: Introduce of_dma_get_max_cpu_address()
>>    3fbe62ffbb54 arm64: mm: Move zone_dma_bits initialization into
>> zone_sizes_init()
>>    407b173adfac arm64: mm: Move reserve_crashkernel() into mem_init()
>>
>> but the patch "arm64: mm: Move reserve_crashkernel() into mem_init()"
>> has some issue, see the following discussion from Catalin,
>>
>> https://lore.kernel.org/linux-devicetree/e60d643e-4879-3fc3-737d-2c145332a6d7@arm.com/
>> https://lore.kernel.org/linux-arm-kernel/20201119175556.18681-1-catalin.marinas@arm.com/
>>
>> and yes, we met crash in lts5.10 when kexec boot due to "arm64: mm: Move
>> reserve_crashkernel() into mem_init()" too, which could be fixed by
>> commit 2687275a5843 "arm64: Force NO_BLOCK_MAPPINGS if crashkernel
>> reservation is required", and the commit 791ab8b2e3db "arm64: Ignore any DMA
>> offsets in the max_zone_phys() calculation" also about DMA set,
>> So I only asked the two patches(both in v5.11) related ARM64 ZONE_DMA
>> changes backported into lts5.10.
> Thanks, all now queued up.
Thank you again ;)
> greg k-h
> .
>
