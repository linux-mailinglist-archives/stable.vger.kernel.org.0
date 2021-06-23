Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561E63B144E
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 09:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhFWHC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 03:02:29 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:11084 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhFWHCZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 03:02:25 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G8vFp5tCTzZhys;
        Wed, 23 Jun 2021 14:57:02 +0800 (CST)
Received: from dggpemm500001.china.huawei.com (7.185.36.107) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 23 Jun 2021 15:00:00 +0800
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemm500001.china.huawei.com (7.185.36.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 23 Jun 2021 14:59:59 +0800
Subject: Re: [PATCH stable v5.10 0/7] arm64: Default to 32-bit wide ZONE_DMA
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>
CC:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        <catalin.marinas@arm.com>, <will@kernel.org>,
        <akpm@linux-foundation.org>, <guohanjun@huawei.com>,
        <sudeep.holla@arm.com>, <song.bao.hua@hisilicon.com>,
        <ardb@kernel.org>, <anshuman.khandual@arm.com>,
        <stable@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Li Huafei <lihuafei1@huawei.com>
References: <20210303073319.2215839-1-jingxiangfeng@huawei.com>
 <YEDkmj6cchMPAq2h@kroah.com>
 <9bc396116372de5b538d71d8f9ae9c3259f1002e.camel@suse.de>
 <YEDr/lYZHew88/Ip@kroah.com>
 <827b317d7f5da6e048806922098291faacdb19f9.camel@suse.de>
 <YETwL6QGWFyJTAzk@kroah.com> <604597E3.5000605@huawei.com>
 <YEX1OcbVNSqwwusF@kroah.com>
 <31cd8432-2466-555d-7617-ae48cbcd4244@huawei.com>
Message-ID: <8b0a4f25-0803-9341-f3a4-277d16802295@huawei.com>
Date:   Wed, 23 Jun 2021 14:59:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <31cd8432-2466-555d-7617-ae48cbcd4244@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500001.china.huawei.com (7.185.36.107)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

There are two more patches about the ZONE_DMA[32] changes, especially 
the second one, both them need be backported, thanks.

791ab8b2e3db - arm64: Ignore any DMA offsets in the max_zone_phys() 
calculation
2687275a5843 - arm64: Force NO_BLOCK_MAPPINGS if crashkernel reservation 
is required



On 2021/5/11 20:35, Kefeng Wang wrote:
> 
> 
> On 2021/3/8 17:58, Greg KH wrote:
>> On Mon, Mar 08, 2021 at 11:20:03AM +0800, Jing Xiangfeng wrote:
>>>
>>>
>>> On 2021/3/7 23:24, Greg KH wrote:
>>>> On Thu, Mar 04, 2021 at 04:09:28PM +0100, Nicolas Saenz Julienne wrote:
>>>>> On Thu, 2021-03-04 at 15:17 +0100, Greg KH wrote:
>>>>>> On Thu, Mar 04, 2021 at 03:05:32PM +0100, Nicolas Saenz Julienne 
>>>>>> wrote:
>>>>>>> Hi Greg.
>>>>>>>
>>>>>>> On Thu, 2021-03-04 at 14:46 +0100, Greg KH wrote:
>>>>>>>> On Wed, Mar 03, 2021 at 03:33:12PM +0800, Jing Xiangfeng wrote:
>>>>>>>>> Using two distinct DMA zones turned out to be problematic. 
>>>>>>>>> Here's an
>>>>>>>>> attempt go back to a saner default.
>>>>>>>> What problem does this solve?  How does this fit into the stable 
>>>>>>>> kernel
>>>>>>>> rules?
>>>>>>> We changed the way we setup memory zones in arm64 in order to 
>>>>>>> cater for
>>>>>>> Raspberry Pi 4's weird DMA constraints: ZONE_DMA spans the lower 
>>>>>>> 1GB of memory
>>>>>>> and ZONE_DMA32 the rest of the 32bit address space. Since you 
>>>>>>> can't allocate
>>>>>>> memory that crosses zone boundaries, this broke crashkernel 
>>>>>>> allocations on big
>>>>>>> machines. This series fixes all this by parsing the HW 
>>>>>>> description and checking
>>>>>>> for DMA constrained buses. When not found, the unnecessary zone 
>>>>>>> creation is
>>>>>>> skipped.
>>>>>> What kernel/commit caused this "breakage"?
>>>>> 1a8e1cef7603 arm64: use both ZONE_DMA and ZONE_DMA32
>>>> Thanks for the info, all now queued up.
>>> There is a fix in 5.11. Please consider applying the following commit to
>>> 5.10.y:
>>>
>>> aed5041ef9a3 of: unittest: Fix build on architectures without
>>> CONFIG_OF_ADDRES
>>
>> Thanks, now queued up.
> 
> Hi Grep, another commit d78050ee3544 "arm64: Remove 
> arm64_dma32_phys_limit and its uses" should be involved, thanks.
> 
> "Prior to this patch, disabling CONFIG_ZONE_DMA32 leads to CMA
> allocation from the whole RAM as arm64_dma32_phys_limit becomes
> PHYS_MASK+1." from Catalin, see more from the link
> https://www.spinics.net/lists/arm-kernel/msg867356.html
>>
>> greg k-h
>> .
>>
