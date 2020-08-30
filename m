Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C83256C9D
	for <lists+stable@lfdr.de>; Sun, 30 Aug 2020 09:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgH3HdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Aug 2020 03:33:23 -0400
Received: from zg8tmja5ljk3lje4mi4ymjia.icoremail.net ([209.97.182.222]:56917
        "HELO zg8tmja5ljk3lje4mi4ymjia.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S1726013AbgH3HdX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Aug 2020 03:33:23 -0400
X-Greylist: delayed 527 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Aug 2020 03:33:21 EDT
Received: from [166.111.139.123] (unknown [166.111.139.123])
        by app-5 (Coremail) with SMTP id EwQGZQB3fzc2VktfRObPAA--.13424S2;
        Sun, 30 Aug 2020 15:33:10 +0800 (CST)
Subject: Re: [PATCH AUTOSEL 4.19 08/38] media: pci: ttpci: av7110: fix
 possible buffer overflow caused by bad DMA value in debiirq()
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pavel Machek <pavel@ucw.cz>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-media@vger.kernel.org
References: <20200821161807.348600-1-sashal@kernel.org>
 <20200821161807.348600-8-sashal@kernel.org>
 <20200829121020.GA20944@duo.ucw.cz>
 <20200829171600.GA7465@pendragon.ideasonboard.com>
From:   Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
Message-ID: <9e797c3a-033b-3473-ac03-1566d40e90d2@tsinghua.edu.cn>
Date:   Sun, 30 Aug 2020 15:33:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200829171600.GA7465@pendragon.ideasonboard.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-CM-TRANSID: EwQGZQB3fzc2VktfRObPAA--.13424S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF15uF48Jr1rWw4xZry5Arb_yoW8ZFW3pF
        WIqF10qF4kJFnIkry2vrnFva9YyayxJry8Ww4DA34UZr90gF1Syr48AF4ruFyFkr98Z3W0
        9F4jv342gF98ta7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvab7Iv0xC_tr1lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I
        8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCY
        02Avz4vE14v_GF4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
        Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q
        6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
        kF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv
        67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyT
        uYvjxU2SoGDUUUU
X-CM-SenderInfo: xedlyxhdmxq3pvlqwxlxdovvfxof0/
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2020/8/30 1:16, Laurent Pinchart wrote:
> On Sat, Aug 29, 2020 at 02:10:20PM +0200, Pavel Machek wrote:
>> Hi!
>>
>>> The value av7110->debi_virt is stored in DMA memory, and it is assigned
>>> to data, and thus data[0] can be modified at any time by malicious
>>> hardware. In this case, "if (data[0] < 2)" can be passed, but then
>>> data[0] can be changed into a large number, which may cause buffer
>>> overflow when the code "av7110->ci_slot[data[0]]" is used.
>>>
>>> To fix this possible bug, data[0] is assigned to a local variable, which
>>> replaces the use of data[0].
>> I'm pretty sure hardware capable of manipulating memory can work
>> around any such checks, but...
>>
>>> +++ b/drivers/media/pci/ttpci/av7110.c
>>> @@ -424,14 +424,15 @@ static void debiirq(unsigned long cookie)
>>>   	case DATA_CI_GET:
>>>   	{
>>>   		u8 *data = av7110->debi_virt;
>>> +		u8 data_0 = data[0];
>>>   
>>> -		if ((data[0] < 2) && data[2] == 0xff) {
>>> +		if (data_0 < 2 && data[2] == 0xff) {
>>>   			int flags = 0;
>>>   			if (data[5] > 0)
>>>   				flags |= CA_CI_MODULE_PRESENT;
>>>   			if (data[5] > 5)
>>>   				flags |= CA_CI_MODULE_READY;
>>> -			av7110->ci_slot[data[0]].flags = flags;
>>> +			av7110->ci_slot[data_0].flags = flags;
>> This does not even do what it says. Compiler is still free to access
>> data[0] multiple times. It needs READ_ONCE() to be effective.
> Yes, it seems quite dubious to me. If we *really* want to guard against
> rogue hardware here, the whole DMA buffer should be copied. I don't
> think it's worth it, a rogue PCI device can do much more harm.
>

 From the original driver code, data[0] is considered to be bad and thus 
it should be checked, because the content of the DMA buffer may be 
problematic.
Based on this consideration, data[0] can be also modified to bypass the 
check, and thus its value should be copied to a local variable for the 
check and use.

I agree with Pavel that the compiler optimization may drop the copying 
operation, and thus READ_ONCE() should be used here.
I will submit a v2 patch soon.


Best wishes,
Jia-Ju Bai

