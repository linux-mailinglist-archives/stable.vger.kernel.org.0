Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7CE3D59B2
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 14:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbhGZMEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 08:04:51 -0400
Received: from david.siemens.de ([192.35.17.14]:56883 "EHLO david.siemens.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233754AbhGZMEu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 08:04:50 -0400
X-Greylist: delayed 2361 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Jul 2021 08:04:50 EDT
Received: from mail2.sbs.de (mail2.sbs.de [192.129.41.66])
        by david.siemens.de (8.15.2/8.15.2) with ESMTPS id 16QC5dFX005210
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Jul 2021 14:05:40 +0200
Received: from [139.22.37.28] ([139.22.37.28])
        by mail2.sbs.de (8.15.2/8.15.2) with ESMTP id 16QC5d4G009611;
        Mon, 26 Jul 2021 14:05:39 +0200
Subject: Re: [PATCH] watchdog: iTCO_wdt: Fix detection of SMI-off case
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     linux-watchdog@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christian Storm <christian.storm@siemens.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?Q?Mantas_Mikul=c4=97nas?= <grawity@gmail.com>,
        stable <stable@vger.kernel.org>
References: <d84f8e06-f646-8b43-d063-fb11f4827044@siemens.com>
 <b3b75b72-33d4-ce21-a8f4-77a37156aa9e@redhat.com>
From:   Jan Kiszka <jan.kiszka@siemens.com>
Message-ID: <0e37c448-26cc-7f4a-4f1a-598c595ce07e@siemens.com>
Date:   Mon, 26 Jul 2021 14:05:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <b3b75b72-33d4-ce21-a8f4-77a37156aa9e@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26.07.21 14:03, Paolo Bonzini wrote:
> On 26/07/21 13:46, Jan Kiszka wrote:
>> From: Jan Kiszka <jan.kiszka@siemens.com>
>>
>> Obviously, the test needs to run against the register content, not its
>> address.
>>
>> Fixes: cb011044e34c ("watchdog: iTCO_wdt: Account for rebooting on
>> second timeout")
>> Reported-by: Mantas Mikulėnas <grawity@gmail.com>
>> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
>> ---
>>   drivers/watchdog/iTCO_wdt.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
>> index b3f604669e2c..643c6c2d0b72 100644
>> --- a/drivers/watchdog/iTCO_wdt.c
>> +++ b/drivers/watchdog/iTCO_wdt.c
>> @@ -362,7 +362,7 @@ static int iTCO_wdt_set_timeout(struct
>> watchdog_device *wd_dev, unsigned int t)
>>        * Otherwise, the BIOS generally reboots when the SMI triggers.
>>        */
>>       if (p->smi_res &&
>> -        (SMI_EN(p) & (TCO_EN | GBL_SMI_EN)) != (TCO_EN | GBL_SMI_EN))
>> +        (inl(SMI_EN(p)) & (TCO_EN | GBL_SMI_EN)) != (TCO_EN |
>> GBL_SMI_EN))
>>           tmrval /= 2;
>>         /* from the specs: */
>>
> 
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Cc: stable@vger.kernel.org
> 
> (the latter because cb011044e34c has been picked up by stable kernels
> already).
> 

Thanks. Originally wanted to add stable myself, but I'm still unsure
whether this is the privilege of the subsystem maintainer or should also
be done by contributors.

Jan

-- 
Siemens AG, T RDA IOT
Corporate Competence Center Embedded Linux
