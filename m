Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAE32434E4
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 09:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgHMHXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 03:23:32 -0400
Received: from www381.your-server.de ([78.46.137.84]:59098 "EHLO
        www381.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbgHMHXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Aug 2020 03:23:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=metafoo.de;
         s=default2002; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID;
        bh=/rw/ABEPjiEaBAOAgD9xWsMZr2Q2LaEmkUB2HMr+Svs=; b=Gm8ESdJLYpDNxyf/U+jMLWs/pK
        /2mh67+0zN0hkS66KjpRCgaPdtZ5UIJsPuUcqZpd8y3Q6aw2haFUZUPLyA6TKZgmMkK2u02Bpoo5o
        3D1ArL1nj9QJemWrceaEGFQvRpKERKbzdgNU9HPAQB3BIZNrJ4fqCmvxsrZOLxOG/18oMA0gYGn3r
        Jt4aAfIeC0nhw8PJdpbPTFAtmaF3Uq6gHcu58Dqf9jsYELisKLTiKrxIl/i5Ke+35bEYFiEeoeWUf
        qGdSujWzFXhmyI3ThwvIhOXWgKeqYc6jVMszTr1cnW7V7pLbQIb25uQLIgJXOQVi5VCJj7uJJghf5
        APhc4y3A==;
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www381.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <lars@metafoo.de>)
        id 1k67a8-0003PW-H7; Thu, 13 Aug 2020 09:23:24 +0200
Received: from [2001:a61:2517:6d01:9e5c:8eff:fe01:8578]
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <lars@metafoo.de>)
        id 1k67a8-0003wM-Az; Thu, 13 Aug 2020 09:23:24 +0200
Subject: Re: [PATCH] iio: trigger: sysfs: Disable irqs before calling
 iio_trigger_poll()
To:     Christian Eggers <ceggers@arri.de>
Cc:     Jonathan Cameron <jic23@kernel.org>, stable@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200727145714.4377-1-ceggers@arri.de>
 <4871626.01MspNxQH7@n95hx1g2>
 <a59d204e-aeb0-2649-5e6f-f07815713d1a@metafoo.de>
 <3847827.rc3nFVyU9p@n95hx1g2>
From:   Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <f6fc5fbe-5c51-fe9a-670e-4b5201353356@metafoo.de>
Date:   Thu, 13 Aug 2020 09:23:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3847827.rc3nFVyU9p@n95hx1g2>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Authenticated-Sender: lars@metafoo.de
X-Virus-Scanned: Clear (ClamAV 0.102.4/25900/Mon Aug 10 14:44:29 2020)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/12/20 1:01 PM, Christian Eggers wrote:
> Hi Lars
>
> On Monday, 3 August 2020, 08:52:54 CEST, Lars-Peter Clausen wrote:
>> On 8/3/20 8:44 AM, Christian Eggers wrote:
>>> ...
>>> is my patch sufficient, or would you prefer a different solution?
>> The code in normal upstream is correct, there is no need to patch it
>> since iio_sysfs_trigger_work() always runs with IRQs disabled.
>>
>>>> Are you using a non-upstream kernel? Maybe a RT kernel?
>>> I use v5.4.<almost-latest>-rt
>> That explains it. Have a look at
>> 0200-irqwork-push-most-work-into-softirq-context.patch.
>>
>> The right fix for this issue is to add the following snippet to the RT
>> patchset.
>>
>> diff --git a/drivers/iio/trigger/iio-trig-sysfs.c
>> b/drivers/iio/trigger/iio-trig-sysfs.c
>> --- a/drivers/iio/trigger/iio-trig-sysfs.c
>> +++ b/drivers/iio/trigger/iio-trig-sysfs.c
>> @@ -161,6 +161,7 @@ static int iio_sysfs_trigger_probe(int id)
>>        iio_trigger_set_drvdata(t->trig, t);
>>
>>        init_irq_work(&t->work, iio_sysfs_trigger_work);
>> +    t->work.flags = IRQ_WORK_HARD_IRQ;
>>
>>        ret = iio_trigger_register(t->trig);
>>        if (ret)
> I can confirm that this works for iio-trig-sysfs on 5.4.54-rt32. Currently I
> do not use iio-trig-hrtimer, but if I remember correctly, the problem was also
> present there.

Similar story, I think. On mainline hrtimers run in hardirq mode by 
default, whereas in RT they run in softirq mode by default. So we 
haven't see the issue in mainline.

To fix this we need to explicitly specify that the IIO hrtimer always 
needs to run in hardirq mode by using the HRTIMER_MODE_REL_HARD flag. 
I'll send a patch.

> Do you want to apply your patch for mainline? In contrast to v5.4,
> IRQ_WORK_HARD_IRQ is already available there (moved to smp_types.h).
> Unfortunately I cannot test it on mainline for now, as my BSP stuff is not
> ported yet.

Sounds like a plan :)

