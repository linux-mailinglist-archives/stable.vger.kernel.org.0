Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88DFA37A6D2
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 14:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbhEKMhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 08:37:05 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:2444 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbhEKMhE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 08:37:04 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Ffclc1cMrzCr9G;
        Tue, 11 May 2021 20:33:16 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Tue, 11 May 2021 20:35:48 +0800
Subject: Re: [PATCH stable v5.10 0/7] arm64: Default to 32-bit wide ZONE_DMA
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>
CC:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        <catalin.marinas@arm.com>, <will@kernel.org>,
        <akpm@linux-foundation.org>, <paul.walmsley@sifive.com>,
        <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <rppt@kernel.org>,
        <lorenzo.pieralisi@arm.com>, <guohanjun@huawei.com>,
        <sudeep.holla@arm.com>, <rjw@rjwysocki.net>, <lenb@kernel.org>,
        <song.bao.hua@hisilicon.com>, <ardb@kernel.org>,
        <anshuman.khandual@arm.com>, <bhelgaas@google.com>, <guro@fb.com>,
        <robh+dt@kernel.org>, <stable@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <frowand.list@gmail.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-riscv@lists.infradead.org>
References: <20210303073319.2215839-1-jingxiangfeng@huawei.com>
 <YEDkmj6cchMPAq2h@kroah.com>
 <9bc396116372de5b538d71d8f9ae9c3259f1002e.camel@suse.de>
 <YEDr/lYZHew88/Ip@kroah.com>
 <827b317d7f5da6e048806922098291faacdb19f9.camel@suse.de>
 <YETwL6QGWFyJTAzk@kroah.com> <604597E3.5000605@huawei.com>
 <YEX1OcbVNSqwwusF@kroah.com>
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
Message-ID: <31cd8432-2466-555d-7617-ae48cbcd4244@huawei.com>
Date:   Tue, 11 May 2021 20:35:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <YEX1OcbVNSqwwusF@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/3/8 17:58, Greg KH wrote:
> On Mon, Mar 08, 2021 at 11:20:03AM +0800, Jing Xiangfeng wrote:
>>
>>
>> On 2021/3/7 23:24, Greg KH wrote:
>>> On Thu, Mar 04, 2021 at 04:09:28PM +0100, Nicolas Saenz Julienne wrote:
>>>> On Thu, 2021-03-04 at 15:17 +0100, Greg KH wrote:
>>>>> On Thu, Mar 04, 2021 at 03:05:32PM +0100, Nicolas Saenz Julienne wrote:
>>>>>> Hi Greg.
>>>>>>
>>>>>> On Thu, 2021-03-04 at 14:46 +0100, Greg KH wrote:
>>>>>>> On Wed, Mar 03, 2021 at 03:33:12PM +0800, Jing Xiangfeng wrote:
>>>>>>>> Using two distinct DMA zones turned out to be problematic. Here's an
>>>>>>>> attempt go back to a saner default.
>>>>>>> What problem does this solve?  How does this fit into the stable kernel
>>>>>>> rules?
>>>>>> We changed the way we setup memory zones in arm64 in order to cater for
>>>>>> Raspberry Pi 4's weird DMA constraints: ZONE_DMA spans the lower 1GB of memory
>>>>>> and ZONE_DMA32 the rest of the 32bit address space. Since you can't allocate
>>>>>> memory that crosses zone boundaries, this broke crashkernel allocations on big
>>>>>> machines. This series fixes all this by parsing the HW description and checking
>>>>>> for DMA constrained buses. When not found, the unnecessary zone creation is
>>>>>> skipped.
>>>>> What kernel/commit caused this "breakage"?
>>>> 1a8e1cef7603 arm64: use both ZONE_DMA and ZONE_DMA32
>>> Thanks for the info, all now queued up.
>> There is a fix in 5.11. Please consider applying the following commit to
>> 5.10.y:
>>
>> aed5041ef9a3 of: unittest: Fix build on architectures without
>> CONFIG_OF_ADDRES
> 
> Thanks, now queued up.

Hi Grep, another commit d78050ee3544 "arm64: Remove 
arm64_dma32_phys_limit and its uses" should be involved, thanks.

"Prior to this patch, disabling CONFIG_ZONE_DMA32 leads to CMA
allocation from the whole RAM as arm64_dma32_phys_limit becomes
PHYS_MASK+1." from Catalin, see more from the link
https://www.spinics.net/lists/arm-kernel/msg867356.html
> 
> greg k-h
> .
> 
