Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61B4316244F
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 11:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgBRKLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 05:11:23 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54404 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbgBRKLV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 05:11:21 -0500
Received: by mail-wm1-f65.google.com with SMTP id g1so2133889wmh.4
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 02:11:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g4DnGuTcijC6gHOEMHObTvcQULT66vNxdcSmpUIP4Co=;
        b=V3DKg1223zJ18V+uHkhUQfrLghNYMd4YV0tvZZi9y20BSTHAUZa6fbwmKnjpNNdUhn
         Rae2143y2amkdqPTHCuYwqH7wSBsh74/U8eQ5M3ILgooPcHv33qpj1k+W0+eBAbNTJZC
         DeNp9XbIKEXvdoEMeukGTXhhk++9Pm/TKdRi/gZosTjRsJtyOckjAIREzBSN7eWI7DOU
         XByxqjGYWNbOLEBNzL7WO2o0HFbISJIPRZXEILrQm2rKY3wX0i2gshYUK2CXIhkl5fuQ
         2wdE3sU5NlLGvc2blch9SdStVwYx/5ugJkSdLa+y6b2/lCKzssLx/FAGGCrplGgEPe8C
         K6AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g4DnGuTcijC6gHOEMHObTvcQULT66vNxdcSmpUIP4Co=;
        b=RNME+9dkjmNmj4GSSwKCfHbMUB8xD+eIo6IOJJI7F3aLXItfozpR+uMCwr6O6v8SGA
         0cONfy2AmvUzpIf0KHn6oqn8HVq0HkLPaqZuzO8u3rfMbtDZTIrk1PVBM0APDp9ohiPT
         tlEbZRgntUe0pIrqIYB2GssZKlpqTpQtnpXdsK9tzhivZ0yhbeFityaHkAghiQhAfJPW
         TdTBrAZh8tKZPF/77S5xyT4fT1Y/lv8EGy4Ft366e0HU67wvw1jpi0yThVMXJRnY/2nJ
         leOVFHQHDtKuEXwYjT0a4euRzV+fxrmKD2NTS1YUQ3AjMQ2D7Kuv4DO1RsDJ/tl2EhHi
         84Uw==
X-Gm-Message-State: APjAAAXIP/bXEXmajCGj6g8vODwRTssgiZtTwH62bA3jI/yjB5cXTpgA
        19/gGkXlWPEYuQqE8+eV7WUN+M7lGdw=
X-Google-Smtp-Source: APXvYqyiJ7NL87Ct/ZFG5d4PHWtIf/fnhXj67cuYYwwnRxCGe0aCkxrTvK9TEd3M0QxVD0Ou1kgOBw==
X-Received: by 2002:a05:600c:2406:: with SMTP id 6mr2338306wmp.30.1582020678661;
        Tue, 18 Feb 2020 02:11:18 -0800 (PST)
Received: from [192.168.86.34] (cpc89974-aztw32-2-0-cust43.18-1.cable.virginm.net. [86.30.250.44])
        by smtp.googlemail.com with ESMTPSA id r6sm5133746wrq.92.2020.02.18.02.11.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Feb 2020 02:11:18 -0800 (PST)
Subject: Re: [PATCH v2 2/7] nvmem: fix another memory leak in error path
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Khouloud Touil <ktouil@baylibre.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        stable <stable@vger.kernel.org>
References: <20200218094234.23896-1-brgl@bgdev.pl>
 <20200218094234.23896-3-brgl@bgdev.pl>
 <6e7a5df7-6ded-7777-5552-879934c185ad@linaro.org>
 <CAMRc=McQ4ESq4g82QGjZiM0+NWUBrjUv71Be7UXzZpSsa9xAig@mail.gmail.com>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Message-ID: <5f4cf6ca-c5e2-9fd2-b4b8-f99a120e0d4b@linaro.org>
Date:   Tue, 18 Feb 2020 10:11:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAMRc=McQ4ESq4g82QGjZiM0+NWUBrjUv71Be7UXzZpSsa9xAig@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 18/02/2020 10:05, Bartosz Golaszewski wrote:
> wt., 18 lut 2020 o 10:56 Srinivas Kandagatla
> <srinivas.kandagatla@linaro.org> napisał(a):
>>
>>
>>
>> On 18/02/2020 09:42, Bartosz Golaszewski wrote:
>>> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>>>
>>> The nvmem struct is only freed on the first error check after its
>>> allocation and leaked after that. Fix it with a new label.
>>>
>>> Cc: <stable@vger.kernel.org>
>>> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>>> ---
>>>    drivers/nvmem/core.c | 8 ++++----
>>>    1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
>>> index b0be03d5f240..c9b3f4047154 100644
>>> --- a/drivers/nvmem/core.c
>>> +++ b/drivers/nvmem/core.c
>>> @@ -343,10 +343,8 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
>>>                return ERR_PTR(-ENOMEM);
>>>
>>>        rval  = ida_simple_get(&nvmem_ida, 0, 0, GFP_KERNEL);
>>> -     if (rval < 0) {
>>> -             kfree(nvmem);
>>> -             return ERR_PTR(rval);
>>> -     }
>>> +     if (rval < 0)
>>> +             goto err_free_nvmem;
>>>        if (config->wp_gpio)
>>>                nvmem->wp_gpio = config->wp_gpio;
>>>        else
>>> @@ -432,6 +430,8 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
>>>        put_device(&nvmem->dev);
>>>    err_ida_remove:
>>>        ida_simple_remove(&nvmem_ida, nvmem->id);
>>> +err_free_nvmem:
>>> +     kfree(nvmem);
>>
>> This is not correct fix to start with, if the device has already been
>> intialized before jumping here then nvmem would be freed as part of
>> nvmem_release().
>>
>> So the bug was actually introduced by adding err_ida_remove label.
>>
>> You can free nvmem at that point but not at any point after that as
>> device core would be holding a reference to it.
>>
> 
> OK I see - I missed the release() callback assignment. Frankly: I find
> this split of resource management responsibility confusing. Since the
> users are expected to call nvmem_unregister() anyway - wouldn't it be
> more clear to just free all resources there? What is the advantage of
> defining the release() callback for device type here?

Because we are using dev pointer from nvmem structure, and this dev 
pointer should be valid until release callback is invoked.

Freeing nvmem at any early stage would make dev pointer invalid and 
device core would dereference it!

--srini
> 
> Bartosz
> 
