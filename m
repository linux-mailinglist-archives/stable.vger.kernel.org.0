Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BB6256C9A
	for <lists+stable@lfdr.de>; Sun, 30 Aug 2020 09:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgH3HbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Aug 2020 03:31:24 -0400
Received: from zg8tmtm5lju5ljm3lje2naaa.icoremail.net ([139.59.37.164]:57821
        "HELO zg8tmtm5lju5ljm3lje2naaa.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S1726013AbgH3HbX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Aug 2020 03:31:23 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Aug 2020 03:31:21 EDT
Received: from [166.111.139.123] (unknown [166.111.139.123])
        by app-3 (Coremail) with SMTP id EQQGZQCHOSYnVEtfzRnPAA--.24490S2;
        Sun, 30 Aug 2020 15:24:23 +0800 (CST)
Subject: Re: [PATCH AUTOSEL 4.19 08/38] media: pci: ttpci: av7110: fix
 possible buffer overflow caused by bad DMA value in debiirq()
To:     Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-media@vger.kernel.org
References: <20200821161807.348600-1-sashal@kernel.org>
 <20200821161807.348600-8-sashal@kernel.org>
 <20200829121020.GA20944@duo.ucw.cz>
From:   Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
Message-ID: <a9c96d50-a4d1-29bf-3bb0-68c4f7cd4c10@tsinghua.edu.cn>
Date:   Sun, 30 Aug 2020 15:24:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200829121020.GA20944@duo.ucw.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-CM-TRANSID: EQQGZQCHOSYnVEtfzRnPAA--.24490S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ur4UWryrCFWkJr48tw1rCrg_yoW8Jw13pF
        WIq3W0qFs5tF9IkrW2vrsFvaykAa4xJryDGwsrA34UArZ0gF1xCFWkJF4ru3ZYkF98ZayI
        qF4Yq342gryqqaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvFb7Iv0xC_KF4lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I
        8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCY
        02Avz4vE14v_GF4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
        Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r12
        6r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
        kF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVW3JVWrJr1lIxAIcVC2z280aVAF
        wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvj
        xU7LvtDUUUU
X-CM-SenderInfo: xedlyxhdmxq3pvlqwxlxdovvfxof0/
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2020/8/29 20:10, Pavel Machek wrote:
> Hi!
>
>> The value av7110->debi_virt is stored in DMA memory, and it is assigned
>> to data, and thus data[0] can be modified at any time by malicious
>> hardware. In this case, "if (data[0] < 2)" can be passed, but then
>> data[0] can be changed into a large number, which may cause buffer
>> overflow when the code "av7110->ci_slot[data[0]]" is used.
>>
>> To fix this possible bug, data[0] is assigned to a local variable, which
>> replaces the use of data[0].
> I'm pretty sure hardware capable of manipulating memory can work
> around any such checks, but...
>
>> +++ b/drivers/media/pci/ttpci/av7110.c
>> @@ -424,14 +424,15 @@ static void debiirq(unsigned long cookie)
>>   	case DATA_CI_GET:
>>   	{
>>   		u8 *data = av7110->debi_virt;
>> +		u8 data_0 = data[0];
>>   
>> -		if ((data[0] < 2) && data[2] == 0xff) {
>> +		if (data_0 < 2 && data[2] == 0xff) {
>>   			int flags = 0;
>>   			if (data[5] > 0)
>>   				flags |= CA_CI_MODULE_PRESENT;
>>   			if (data[5] > 5)
>>   				flags |= CA_CI_MODULE_READY;
>> -			av7110->ci_slot[data[0]].flags = flags;
>> +			av7110->ci_slot[data_0].flags = flags;
> This does not even do what it says. Compiler is still free to access
> data[0] multiple times. It needs READ_ONCE() to be effective.
>
>

Thanks for this advice, I will submit a v2 patch soon.


Best wishes,
Jia-Ju Bai

