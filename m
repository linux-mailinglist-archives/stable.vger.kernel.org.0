Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85397257AA9
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 15:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgHaNpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 09:45:39 -0400
Received: from zg8tmtm5lju5ljm3lje2naaa.icoremail.net ([139.59.37.164]:41455
        "HELO zg8tmtm5lju5ljm3lje2naaa.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S1726249AbgHaNpe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 09:45:34 -0400
Received: from [166.111.139.123] (unknown [166.111.139.123])
        by app-3 (Coremail) with SMTP id EQQGZQBnGCXq_kxf_QHqAA--.5154S2;
        Mon, 31 Aug 2020 21:45:14 +0800 (CST)
Subject: Re: [PATCH AUTOSEL 4.19 08/38] media: pci: ttpci: av7110: fix
 possible buffer overflow caused by bad DMA value in debiirq()
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-media@vger.kernel.org
References: <20200821161807.348600-1-sashal@kernel.org>
 <20200821161807.348600-8-sashal@kernel.org>
 <20200829121020.GA20944@duo.ucw.cz>
 <20200829171600.GA7465@pendragon.ideasonboard.com>
 <9e797c3a-033b-3473-ac03-1566d40e90d2@tsinghua.edu.cn>
 <20200830222549.GD6043@pendragon.ideasonboard.com>
From:   Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
Message-ID: <665f2e2d-b133-05be-17d5-49b860474ce5@tsinghua.edu.cn>
Date:   Mon, 31 Aug 2020 21:45:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200830222549.GD6043@pendragon.ideasonboard.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-CM-TRANSID: EQQGZQBnGCXq_kxf_QHqAA--.5154S2
X-Coremail-Antispam: 1UD129KBjvJXoWxur18urW3WF1xCw48WrykXwb_yoW5ZrWUpF
        WSkF45tF4DJFy3KryjvwnFvF9YyFWxtFyUWw4DJryjvrZ0vF9Yyr4jyF4rCa4Durn8Z3W0
        9F4Yv347WFWDAaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvIb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwV
        C2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l
        c2xSY4AK67AK6ry8MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I
        0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWU
        tVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcV
        CY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv
        67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf
        9x07br739UUUUU=
X-CM-SenderInfo: xedlyxhdmxq3pvlqwxlxdovvfxof0/
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2020/8/31 6:25, Laurent Pinchart wrote:
> Hi Jia-Ju,
>
> On Sun, Aug 30, 2020 at 03:33:11PM +0800, Jia-Ju Bai wrote:
>> On 2020/8/30 1:16, Laurent Pinchart wrote:
>>> On Sat, Aug 29, 2020 at 02:10:20PM +0200, Pavel Machek wrote:
>>>> Hi!
>>>>
>>>>> The value av7110->debi_virt is stored in DMA memory, and it is assigned
>>>>> to data, and thus data[0] can be modified at any time by malicious
>>>>> hardware. In this case, "if (data[0] < 2)" can be passed, but then
>>>>> data[0] can be changed into a large number, which may cause buffer
>>>>> overflow when the code "av7110->ci_slot[data[0]]" is used.
>>>>>
>>>>> To fix this possible bug, data[0] is assigned to a local variable, which
>>>>> replaces the use of data[0].
>>>> I'm pretty sure hardware capable of manipulating memory can work
>>>> around any such checks, but...
>>>>
>>>>> +++ b/drivers/media/pci/ttpci/av7110.c
>>>>> @@ -424,14 +424,15 @@ static void debiirq(unsigned long cookie)
>>>>>    	case DATA_CI_GET:
>>>>>    	{
>>>>>    		u8 *data = av7110->debi_virt;
>>>>> +		u8 data_0 = data[0];
>>>>>    
>>>>> -		if ((data[0] < 2) && data[2] == 0xff) {
>>>>> +		if (data_0 < 2 && data[2] == 0xff) {
>>>>>    			int flags = 0;
>>>>>    			if (data[5] > 0)
>>>>>    				flags |= CA_CI_MODULE_PRESENT;
>>>>>    			if (data[5] > 5)
>>>>>    				flags |= CA_CI_MODULE_READY;
>>>>> -			av7110->ci_slot[data[0]].flags = flags;
>>>>> +			av7110->ci_slot[data_0].flags = flags;
>>>> This does not even do what it says. Compiler is still free to access
>>>> data[0] multiple times. It needs READ_ONCE() to be effective.
>>> Yes, it seems quite dubious to me. If we *really* want to guard against
>>> rogue hardware here, the whole DMA buffer should be copied. I don't
>>> think it's worth it, a rogue PCI device can do much more harm.
>>  From the original driver code, data[0] is considered to be bad and thus
>> it should be checked, because the content of the DMA buffer may be
>> problematic.
>>
>> Based on this consideration, data[0] can be also modified to bypass the
>> check, and thus its value should be copied to a local variable for the
>> check and use.
> What makes you think the hardware would do that ?
>

Several recent papers show that the bad values from malicious or 
problematic hardware can cause security problems:
[NDSS'19] PeriScope: An Effective Probing and Fuzzing Framework for the 
Hardware-OS Boundary
[NDSS'19] Thunderclap: Exploring Vulnerabilities in Operating System 
IOMMU Protection via DMA from Untrustworthy Peripherals
[USENIX Security'20] USBFuzz: A Framework for Fuzzing USB Drivers by 
Device Emulation

In this case, the values from DMA can be bad, and the driver should 
carefully check these values to avoid security problems.
IOMMU is an effective method to prevent the hardware from accessing 
arbitrary memory address via DMA, but it does not check whether the 
values from DMA are safe.

I find that some drivers (including the av7110 driver) check (or try to 
check) the values from DMA, and thus I think these drivers have 
considered such security problems.
However, some of these checks are not rigorous, so that they can be 
bypassed in some cases. The problem that I reported is such an example.


Best wishes,
Jia-Ju Bai

