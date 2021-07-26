Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1F83D5ABB
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 15:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbhGZNKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 09:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233408AbhGZNKi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 09:10:38 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC00C061757;
        Mon, 26 Jul 2021 06:51:06 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id 129so8824203qkg.4;
        Mon, 26 Jul 2021 06:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fBlm2ZvFTx/fXkZZEbv4opd8Sf/xFXyW1r8V3ivE+J4=;
        b=aKWoFu0yQMpj8uvr5kwDEef8oijoQKzoA9XM8y7YGUdoU3YfOwtJC0MkgBEXGsDJVh
         FDwdKcbrk++oS8dXqH8Z22eI/SiV1+8tj7VfRvCE7uRefNr0c336fE2D2H5y20fSK0IK
         9K/qLfFMtZBQlvvcfZVKg6ZxHF5gS/ff4CcJCgrOK86OZFcmaSzsvuS+tEoBYcVGciEQ
         U5L2AmHu4nKwJ7sC7bY/jallp3XcM/WWbj3zPjLkR9sAa6m7q/HBDHUQ59R88TYKLU6w
         EotThLtNCOy1n306D14XxnYIZYjH6/XlERROfkzRs5T/0OL4vp0j1zjTVD1F7VQqb04z
         K5hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fBlm2ZvFTx/fXkZZEbv4opd8Sf/xFXyW1r8V3ivE+J4=;
        b=FjsRN2Iidg88f3z8o/0ALdqVCTb5iheOZ3DRtB3AS2B8aJ/xHGslCC04IoCSf5S3jf
         otCBcSOJCESWoWOSwyZy6HqH9M7Pg9BbLOJB0n5mdla647w31lA7v5uutILFufUdL+7v
         yxv1KKn13rjmuXkm4VJ/wf0zb4izF2FwrnX1gdOJRJgguQjaEYBFykXPkKPHrF58DQVr
         OXxKF9PZgoAkIjd+ShKJJdZbV1pHIEtJM6GUu1oHiLdia7HFurTK/m0oLTQ3THLtEnv3
         TxsEdBlx3mEN7xmN1nrVhcVClp6BsBPmNVsHAnZ1QIXB3mvQKXrV8JkaFQaaz1Yr1eYA
         fQfQ==
X-Gm-Message-State: AOAM533Pj61mgvAxo6r5D7y3sl4kDvYTIcEgyPzDOJtQJBouqgYSElUS
        p8NIaGK+TAut9qM7zVmkRCA5ESG349E=
X-Google-Smtp-Source: ABdhPJwTL/X9vT3vowjHHAj7gpDhx5cras8b0G3k3Tnhp33QuVKKdfLSQxl76dPX8sDEPJLhmgECjw==
X-Received: by 2002:a37:9a0e:: with SMTP id c14mr17129837qke.398.1627307465235;
        Mon, 26 Jul 2021 06:51:05 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o63sm23191qkf.4.2021.07.26.06.51.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 06:51:04 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH] watchdog: iTCO_wdt: Fix detection of SMI-off case
To:     Jan Kiszka <jan.kiszka@siemens.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>
Cc:     linux-watchdog@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christian Storm <christian.storm@siemens.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?Q?Mantas_Mikul=c4=97nas?= <grawity@gmail.com>,
        stable <stable@vger.kernel.org>
References: <d84f8e06-f646-8b43-d063-fb11f4827044@siemens.com>
 <b3b75b72-33d4-ce21-a8f4-77a37156aa9e@redhat.com>
 <0e37c448-26cc-7f4a-4f1a-598c595ce07e@siemens.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <49ce8c0c-b34d-d14c-9c9b-4eef4c991826@roeck-us.net>
Date:   Mon, 26 Jul 2021 06:51:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <0e37c448-26cc-7f4a-4f1a-598c595ce07e@siemens.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/26/21 5:05 AM, Jan Kiszka wrote:
> On 26.07.21 14:03, Paolo Bonzini wrote:
>> On 26/07/21 13:46, Jan Kiszka wrote:
>>> From: Jan Kiszka <jan.kiszka@siemens.com>
>>>
>>> Obviously, the test needs to run against the register content, not its
>>> address.
>>>
>>> Fixes: cb011044e34c ("watchdog: iTCO_wdt: Account for rebooting on
>>> second timeout")
>>> Reported-by: Mantas Mikulėnas <grawity@gmail.com>
>>> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
>>> ---
>>>    drivers/watchdog/iTCO_wdt.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
>>> index b3f604669e2c..643c6c2d0b72 100644
>>> --- a/drivers/watchdog/iTCO_wdt.c
>>> +++ b/drivers/watchdog/iTCO_wdt.c
>>> @@ -362,7 +362,7 @@ static int iTCO_wdt_set_timeout(struct
>>> watchdog_device *wd_dev, unsigned int t)
>>>         * Otherwise, the BIOS generally reboots when the SMI triggers.
>>>         */
>>>        if (p->smi_res &&
>>> -        (SMI_EN(p) & (TCO_EN | GBL_SMI_EN)) != (TCO_EN | GBL_SMI_EN))
>>> +        (inl(SMI_EN(p)) & (TCO_EN | GBL_SMI_EN)) != (TCO_EN |
>>> GBL_SMI_EN))
>>>            tmrval /= 2;
>>>          /* from the specs: */
>>>
>>
>> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: stable@vger.kernel.org
>>
>> (the latter because cb011044e34c has been picked up by stable kernels
>> already).
>>
> 
> Thanks. Originally wanted to add stable myself, but I'm still unsure
> whether this is the privilege of the subsystem maintainer or should also
> be done by contributors.
> 

Normally it is done by maintainers.

Guenter
