Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E575A1A873D
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 19:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407572AbgDNRPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 13:15:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49847 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2407565AbgDNRPP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 13:15:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586884514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QHwWbb/0Om5PBT0L8gP9PPmqVVSNwuqyRY8+lxTkQz4=;
        b=UZx1j0SVaEy8kmXzkpkXXH/ESx9iE5b6yUGsgHV8COMCV7dWG7vOBvLJC/bgcoO8ISpAiQ
        VaA22sRCkiVNJX3cRb/c/59P2q8mKne8kKU0VYgNYC3lTI+8KZiZVaamN/HwdEWAXvmfaL
        buZGvivVVYxF93LYU9bNRbvaKgP2hVI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-ZT9_tEydPUWAzemE-7DqaA-1; Tue, 14 Apr 2020 13:15:12 -0400
X-MC-Unique: ZT9_tEydPUWAzemE-7DqaA-1
Received: by mail-wm1-f71.google.com with SMTP id y1so4571768wmj.3
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 10:15:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QHwWbb/0Om5PBT0L8gP9PPmqVVSNwuqyRY8+lxTkQz4=;
        b=KybJqpSZgyMac4SCCHcC5tooLKUQOFBR+SsTdzzcp2ZvmGpG6j6Xh0lPnW4WKATXWm
         mUa5q6kRM/wqjWVTATC8g9q1yKuiDsGrOlBYpMlTM2Xw9+46W7bczZ07xkadUKp2cl2j
         tYu7SMpMybeqapKlrtuA4XbUil62NiLfocbCXyLxY1VBXoncTXVdqUCRdv6mZy/DKKE5
         wMKVZt82V/YP/TNrKMTAIfS4X/TIb8OppKTgaKtf7QO5cmHpA2VuRwHhnV8IQgAYCNfm
         ur9RWtt9a7SIvD7cz6uYmsYPVm5Coal8ggCLKLryNuRsJSMUj+7dANpRMcuqnWAg6YDr
         3mtw==
X-Gm-Message-State: AGi0PuaZgRCxyI26Q9dwzR/dv+HBJToraDmuuFz1bYxQiJDcccyMlV6m
        oWKJAa+O9ecFV3cSiqKJt7y//tTOFR3O5tSNhnuwMgs8Tnl5I0nqPowg/x3JP6kqQLBOOJIcdPI
        OwtKz8SNNuq48Vzsl
X-Received: by 2002:a1c:3884:: with SMTP id f126mr872616wma.91.1586884510941;
        Tue, 14 Apr 2020 10:15:10 -0700 (PDT)
X-Google-Smtp-Source: APiQypLZ5tlO8vUZ2+Gf9BUVJ2f3UtHoKBSt3gtDjrnyTHdxARpdiMBvdHLGMesO68HbfP9mIsMQ6Q==
X-Received: by 2002:a1c:3884:: with SMTP id f126mr872591wma.91.1586884510742;
        Tue, 14 Apr 2020 10:15:10 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id s18sm10732847wrv.2.2020.04.14.10.15.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 10:15:09 -0700 (PDT)
Subject: Re: [PATCH] tpm/tpm_tis: Free IRQ if probing fails
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20200412170412.324200-1-jarkko.sakkinen@linux.intel.com>
 <b909aaee-3fff-4dca-40f4-4c5348474426@redhat.com>
 <20200413180732.GA11147@linux.intel.com>
 <7df7f8bd-c65e-1435-7e82-b9f4ecd729de@redhat.com>
 <20200414071349.GA8403@linux.intel.com>
 <d6684575-ce91-fe72-6035-11834a05cd54@redhat.com>
 <20200414160404.GA32775@linux.intel.com>
 <20200414164542.GC32775@linux.intel.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <df580835-f887-1918-c933-6509e5a1ad47@redhat.com>
Date:   Tue, 14 Apr 2020 19:15:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200414164542.GC32775@linux.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 4/14/20 6:45 PM, Jarkko Sakkinen wrote:
> On Tue, Apr 14, 2020 at 07:04:07PM +0300, Jarkko Sakkinen wrote:
>> On Tue, Apr 14, 2020 at 10:26:32AM +0200, Hans de Goede wrote:
>>> Hi,
>>>
>>> On 4/14/20 9:13 AM, Jarkko Sakkinen wrote:
>>>> On Mon, Apr 13, 2020 at 08:11:15PM +0200, Hans de Goede wrote:
>>>>> Hi,
>>>>>
>>>>> On 4/13/20 8:07 PM, Jarkko Sakkinen wrote:
>>>>>> On Mon, Apr 13, 2020 at 12:04:25PM +0200, Hans de Goede wrote:
>>>>>>> Hi Jarkko,
>>>>>>>
>>>>>>> On 4/12/20 7:04 PM, Jarkko Sakkinen wrote:
>>>>>>>> Call devm_free_irq() if we have to revert to polling in order not to
>>>>>>>> unnecessarily reserve the IRQ for the life-cycle of the driver.
>>>>>>>>
>>>>>>>> Cc: stable@vger.kernel.org # 4.5.x
>>>>>>>> Reported-by: Hans de Goede <hdegoede@redhat.com>
>>>>>>>> Fixes: e3837e74a06d ("tpm_tis: Refactor the interrupt setup")
>>>>>>>> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>>>>>>>> ---
>>>>>>>>      drivers/char/tpm/tpm_tis_core.c | 5 ++++-
>>>>>>>>      1 file changed, 4 insertions(+), 1 deletion(-)
>>>>>>>>
>>>>>>>> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
>>>>>>>> index 27c6ca031e23..ae6868e7b696 100644
>>>>>>>> --- a/drivers/char/tpm/tpm_tis_core.c
>>>>>>>> +++ b/drivers/char/tpm/tpm_tis_core.c
>>>>>>>> @@ -1062,9 +1062,12 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
>>>>>>>>      		if (irq) {
>>>>>>>>      			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
>>>>>>>>      						 irq);
>>>>>>>> -			if (!(chip->flags & TPM_CHIP_FLAG_IRQ))
>>>>>>>> +			if (!(chip->flags & TPM_CHIP_FLAG_IRQ)) {
>>>>>>>>      				dev_err(&chip->dev, FW_BUG
>>>>>>>>      					"TPM interrupt not working, polling instead\n");
>>>>>>>> +				devm_free_irq(chip->dev.parent, priv->irq,
>>>>>>>> +					      chip);
>>>>>>>> +			}
>>>>>>>
>>>>>>> My initial plan was actually to do something similar, but if the probe code
>>>>>>> is actually ever fixed to work as intended again then this will lead to a
>>>>>>> double free as then the IRQ-test path of tpm_tis_send() will have called
>>>>>>> disable_interrupts() which already calls devm_free_irq().
>>>>>>>
>>>>>>> You could check for chip->irq != 0 here to avoid that.
>>>
>>> Erm in case you haven't figured it out yet this should be priv->irq != 0, sorry.
>>
>> Yup.
>>
>>>>>>>
>>>>>>> But it all is rather messy, which is why I went with the "#if 0" approach
>>>>>>> in my patch.
>>>>>>
>>>>>> I think it is right way to fix it. It is a bug independent of the issue
>>>>>> we are experiencing.
>>>>>>
>>>>>> However, what you are suggesting should be done in addition. Do you have
>>>>>> a patch in place or do you want me to refine mine?
>>>>>
>>>>> I do not have a patch ready for this, if you can refine yours that would
>>>>> be great.
>>>>
>>>> Thanks! Just wanted to confirm.
>>>
>>> And thank you for working on a (temporary?) fix for this.
>>
>> As far as I see it, it is orthogonal fix that needs to be backported
>> to stable kernels. This bug predates the issue we're seeing now.
> 
> Hey, I came to other thoughts on "how". Would probably make sense
> to always call disable_interrupts() aka no sense to add two separate
> code paths. What do you think?

Sounds good, I guess it would be best to combine that with a:

	if (priv->irq == 0)
		return;

At the top of disable_interrupts() and then unconditionally
call disable_interrupts() where your v1 of this patch
calls devm_free_irq(). That would be a reasonable clean
solution I think.

Regards,

Hans

