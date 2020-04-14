Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4D91A7601
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 10:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436787AbgDNI0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 04:26:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28052 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2436783AbgDNI0l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 04:26:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586852799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b37d0Kofi4/XRxv8UfpXOdTiWurzTmejZQ30rVyez0k=;
        b=QyAOD5ENY/DkKva+vfqi4fuxmhzX6B6dZ06vhPgUnKouxRf486+TJk/vjGdLEG5jKClXcX
        qs6k3Iy7TDwKYmml0FK/8FuEYPV2A9wfTb4pm+FI1e09qpI8d/zOhDqjP/3waOoWJc4p+i
        Hma2eWSOMNSTKy7jRn3wLT8vJnQEf4I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-Oc4FJfziPimugTUyHNkC2A-1; Tue, 14 Apr 2020 04:26:36 -0400
X-MC-Unique: Oc4FJfziPimugTUyHNkC2A-1
Received: by mail-wm1-f70.google.com with SMTP id u11so1217042wmc.7
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 01:26:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b37d0Kofi4/XRxv8UfpXOdTiWurzTmejZQ30rVyez0k=;
        b=BtcmaQO79CGLxatrYi/oyuEmW/xhqKnAwv4nErMVBmJSTA9xDAMAkU4za5FsB+0HGL
         UceZAicOt/BNV2q/rNpgpv7f9VXldey4iWdebQ0da3va5U7rYy3tqU6+9aCR0J7o73DW
         aweMEo5+6UIY0YeZDSmfWDBsOWdqXqfBgnwOVyoeBgtPOQ2jdVrAyXJeV5DxbZ5cUPG6
         yRjDOD3wGvaVBaTbsHgDRv4ESHFb7jgB6tyglvF2xDay/Ep0osN3oWebJJNsO+Fwn9vh
         7XTHbEFZ87blzAe4xm6ND6kEcufJyG4qj8L28muEjg9P9J1p4ORVGeffwNmMsnSwdUDl
         1ZZg==
X-Gm-Message-State: AGi0PuYKPAMZZutx/w5y2rMuG8W6KUUTUI9PDD2RdSiLN6ZczNEbsG5X
        W8VhxJ77UUU0gWrqrILM9gwN8yZ+qqHCrP7SM8RIb7zB1DSxaixGTxZExNX0mkhsf+zvmZTj4Jm
        hVKI/5OiW693pEFpp
X-Received: by 2002:a7b:c401:: with SMTP id k1mr21977050wmi.152.1586852795048;
        Tue, 14 Apr 2020 01:26:35 -0700 (PDT)
X-Google-Smtp-Source: APiQypJLloBOUIuHphP4FqubsTTF9OSa00IedmMyDWrhWDWdhrct7ws2/aUFRcsoLOb+NPUJGjePVw==
X-Received: by 2002:a7b:c401:: with SMTP id k1mr21976977wmi.152.1586852793854;
        Tue, 14 Apr 2020 01:26:33 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id y7sm18913048wmb.43.2020.04.14.01.26.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 01:26:33 -0700 (PDT)
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
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <d6684575-ce91-fe72-6035-11834a05cd54@redhat.com>
Date:   Tue, 14 Apr 2020 10:26:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200414071349.GA8403@linux.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 4/14/20 9:13 AM, Jarkko Sakkinen wrote:
> On Mon, Apr 13, 2020 at 08:11:15PM +0200, Hans de Goede wrote:
>> Hi,
>>
>> On 4/13/20 8:07 PM, Jarkko Sakkinen wrote:
>>> On Mon, Apr 13, 2020 at 12:04:25PM +0200, Hans de Goede wrote:
>>>> Hi Jarkko,
>>>>
>>>> On 4/12/20 7:04 PM, Jarkko Sakkinen wrote:
>>>>> Call devm_free_irq() if we have to revert to polling in order not to
>>>>> unnecessarily reserve the IRQ for the life-cycle of the driver.
>>>>>
>>>>> Cc: stable@vger.kernel.org # 4.5.x
>>>>> Reported-by: Hans de Goede <hdegoede@redhat.com>
>>>>> Fixes: e3837e74a06d ("tpm_tis: Refactor the interrupt setup")
>>>>> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>>>>> ---
>>>>>     drivers/char/tpm/tpm_tis_core.c | 5 ++++-
>>>>>     1 file changed, 4 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
>>>>> index 27c6ca031e23..ae6868e7b696 100644
>>>>> --- a/drivers/char/tpm/tpm_tis_core.c
>>>>> +++ b/drivers/char/tpm/tpm_tis_core.c
>>>>> @@ -1062,9 +1062,12 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
>>>>>     		if (irq) {
>>>>>     			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
>>>>>     						 irq);
>>>>> -			if (!(chip->flags & TPM_CHIP_FLAG_IRQ))
>>>>> +			if (!(chip->flags & TPM_CHIP_FLAG_IRQ)) {
>>>>>     				dev_err(&chip->dev, FW_BUG
>>>>>     					"TPM interrupt not working, polling instead\n");
>>>>> +				devm_free_irq(chip->dev.parent, priv->irq,
>>>>> +					      chip);
>>>>> +			}
>>>>
>>>> My initial plan was actually to do something similar, but if the probe code
>>>> is actually ever fixed to work as intended again then this will lead to a
>>>> double free as then the IRQ-test path of tpm_tis_send() will have called
>>>> disable_interrupts() which already calls devm_free_irq().
>>>>
>>>> You could check for chip->irq != 0 here to avoid that.

Erm in case you haven't figured it out yet this should be priv->irq != 0, sorry.

>>>>
>>>> But it all is rather messy, which is why I went with the "#if 0" approach
>>>> in my patch.
>>>
>>> I think it is right way to fix it. It is a bug independent of the issue
>>> we are experiencing.
>>>
>>> However, what you are suggesting should be done in addition. Do you have
>>> a patch in place or do you want me to refine mine?
>>
>> I do not have a patch ready for this, if you can refine yours that would
>> be great.
> 
> Thanks! Just wanted to confirm.

And thank you for working on a (temporary?) fix for this.

Regards,

Hans

