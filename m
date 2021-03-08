Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933E3330652
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 04:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbhCHDUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 22:20:25 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:13865 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbhCHDUR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 22:20:17 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Dv3T15rNxz7kKK;
        Mon,  8 Mar 2021 11:18:29 +0800 (CST)
Received: from [10.174.178.215] (10.174.178.215) by smtp.huawei.com
 (10.3.19.203) with Microsoft SMTP Server (TLS) id 14.3.498.0; Mon, 8 Mar 2021
 11:20:04 +0800
Subject: Re: [PATCH stable v5.10 0/7] arm64: Default to 32-bit wide ZONE_DMA
To:     Greg KH <gregkh@linuxfoundation.org>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
References: <20210303073319.2215839-1-jingxiangfeng@huawei.com>
 <YEDkmj6cchMPAq2h@kroah.com>
 <9bc396116372de5b538d71d8f9ae9c3259f1002e.camel@suse.de>
 <YEDr/lYZHew88/Ip@kroah.com>
 <827b317d7f5da6e048806922098291faacdb19f9.camel@suse.de>
 <YETwL6QGWFyJTAzk@kroah.com>
CC:     <catalin.marinas@arm.com>, <will@kernel.org>,
        <akpm@linux-foundation.org>, <paul.walmsley@sifive.com>,
        <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <rppt@kernel.org>,
        <lorenzo.pieralisi@arm.com>, <guohanjun@huawei.com>,
        <sudeep.holla@arm.com>, <rjw@rjwysocki.net>, <lenb@kernel.org>,
        <song.bao.hua@hisilicon.com>, <ardb@kernel.org>,
        <anshuman.khandual@arm.com>, <bhelgaas@google.com>, <guro@fb.com>,
        <robh+dt@kernel.org>, <stable@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <frowand.list@gmail.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-riscv@lists.infradead.org>,
        <wangkefeng.wang@huawei.com>
From:   Jing Xiangfeng <jingxiangfeng@huawei.com>
Message-ID: <604597E3.5000605@huawei.com>
Date:   Mon, 8 Mar 2021 11:20:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <YETwL6QGWFyJTAzk@kroah.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.215]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/3/7 23:24, Greg KH wrote:
> On Thu, Mar 04, 2021 at 04:09:28PM +0100, Nicolas Saenz Julienne wrote:
>> On Thu, 2021-03-04 at 15:17 +0100, Greg KH wrote:
>>> On Thu, Mar 04, 2021 at 03:05:32PM +0100, Nicolas Saenz Julienne wrote:
>>>> Hi Greg.
>>>>
>>>> On Thu, 2021-03-04 at 14:46 +0100, Greg KH wrote:
>>>>> On Wed, Mar 03, 2021 at 03:33:12PM +0800, Jing Xiangfeng wrote:
>>>>>> Using two distinct DMA zones turned out to be problematic. Here's an
>>>>>> attempt go back to a saner default.
>>>>> What problem does this solve?  How does this fit into the stable kernel
>>>>> rules?
>>>> We changed the way we setup memory zones in arm64 in order to cater for
>>>> Raspberry Pi 4's weird DMA constraints: ZONE_DMA spans the lower 1GB of memory
>>>> and ZONE_DMA32 the rest of the 32bit address space. Since you can't allocate
>>>> memory that crosses zone boundaries, this broke crashkernel allocations on big
>>>> machines. This series fixes all this by parsing the HW description and checking
>>>> for DMA constrained buses. When not found, the unnecessary zone creation is
>>>> skipped.
>>> What kernel/commit caused this "breakage"?
>> 1a8e1cef7603 arm64: use both ZONE_DMA and ZONE_DMA32
> Thanks for the info, all now queued up.
There is a fix in 5.11. Please consider applying the following commit to 
5.10.y:

aed5041ef9a3 of: unittest: Fix build on architectures without 
CONFIG_OF_ADDRES

Thanks

>
> greg k-h
> .
>

