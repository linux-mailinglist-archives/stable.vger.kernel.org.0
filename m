Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49734356DC6
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 15:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234286AbhDGNt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 09:49:56 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:16064 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352708AbhDGNtz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 09:49:55 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FFm1224hfz19Kkt;
        Wed,  7 Apr 2021 21:47:34 +0800 (CST)
Received: from [10.174.176.73] (10.174.176.73) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Wed, 7 Apr 2021 21:49:35 +0800
Subject: Re: [QUESTION] WARNNING after 3d8e2128f26a ("sysfs: Add sysfs_emit
 and sysfs_emit_at to format sysfs output")
To:     Joe Perches <joe@perches.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Greg KH" <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <vbabka@suse.cz>, <linux-mm@kvack.org>,
        <open-iscsi@googlegroups.com>, <cleech@redhat.com>,
        "zhangyi (F)" <yi.zhang@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        <liuyongqiang13@huawei.com>,
        "Zhengyejian (Zetta)" <zhengyejian1@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        <chenzhou10@huawei.com>
References: <5837f5d9-2235-3ac2-f3f2-712e6cf4da5c@huawei.com>
 <YGbLiIL8ewIX1Hrt@kroah.com> <20210402144120.GO351017@casper.infradead.org>
 <08b739b5-4401-e550-2028-1ce43db38141@huawei.com>
 <cf36c95f3f92bd76f2d6c81c5795acefbe358f09.camel@perches.com>
From:   yangerkun <yangerkun@huawei.com>
Message-ID: <91f1d0e6-1ed3-7f32-029a-370169b9c00a@huawei.com>
Date:   Wed, 7 Apr 2021 21:49:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <cf36c95f3f92bd76f2d6c81c5795acefbe358f09.camel@perches.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.73]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



在 2021/4/7 21:21, Joe Perches 写道:
> On Wed, 2021-04-07 at 20:14 +0800, yangerkun wrote:
>>
>> 在 2021/4/2 22:41, Matthew Wilcox 写道:
>>> On Fri, Apr 02, 2021 at 09:45:12AM +0200, Greg KH wrote:
>>>> Why is the buffer alignment considered a "waste" here?  If that change
>>>> is in Linus's tree and newer kernels (it showed up in 5.4 which was
>>>> released quite a while ago), where are the people complaining about it
>>>> there?
>>>>
>>>> I think backporting 59bb47985c1d ("mm, sl[aou]b: guarantee natural
>>>> alignment for kmalloc(power-of-two)") seems like the correct thing to do
>>>> here to bring things into alignment (pun intended) with newer kernels.
>>>
>>> It's only a waste for slabs which need things like redzones (eg we could
>>> get 7 512-byte allocations out of a 4kB page with a 64 byte redzone
>>> and no alignment ; with alignment we can only get four).  Since slub
>>> can enable/disable redzones on a per-slab basis, and redzones aren't
>>> terribly interesting now that we have kasan/kfence, nobody really cares.
>>>
>>> .
>>>
>>
>> Thanks for your explain! The imfluence seems minimal since the "waste"
>> will happen only when we enable slub_debug.
>>
>> One more question for Joe Perches. Patch v2[1] does not add the
>> alignment check for buf and we add it in v3[2]. I don't see the
>> necessity for this check... Can you help to explain that why we need this?
> 
> It's to make sure it's a PAGE_SIZE aligned buffer.
> It's just so it would not be misused/abused in non-sysfs derived cases.
> 
> .
> 

Thanks! It help me to understand the problem better!
