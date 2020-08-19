Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10AE424A2BE
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 17:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgHSPVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 11:21:51 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13519 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727854AbgHSPVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 11:21:49 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3d437e0000>; Wed, 19 Aug 2020 08:21:34 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 19 Aug 2020 08:21:48 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 19 Aug 2020 08:21:48 -0700
Received: from [10.25.96.247] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 19 Aug
 2020 15:21:42 +0000
Subject: Re: [PATCH] ALSA: hda: avoid reset of sdo_limit
To:     Takashi Iwai <tiwai@suse.de>
CC:     <tiwai@suse.com>, <perex@perex.cz>, <kai.vehmanen@linux.intel.com>,
        <yang.jie@linux.intel.com>, <pierre-louis.bossart@linux.intel.com>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <1597848273-25813-1-git-send-email-spujar@nvidia.com>
 <s5hmu2qhele.wl-tiwai@suse.de>
From:   Sameer Pujar <spujar@nvidia.com>
Message-ID: <376cc1ba-d781-e319-e68d-99a8e8d8bbdf@nvidia.com>
Date:   Wed, 19 Aug 2020 20:51:39 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <s5hmu2qhele.wl-tiwai@suse.de>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597850495; bh=nIVmZYWAVKJjAz2WTV5Pq/8CeO7HreVwdVvgXeBqcqQ=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Transfer-Encoding:
         Content-Language;
        b=gB2Iq8OgTJba+HjCDFen9seVB6EsqqodAgImai9n1WYGZnkdNwRCo0Rf3AsaRpS61
         aaGKREz3fC9avdNZZ3HczjXxHdjBNDHKX1XbsE1DJl+FFspBGTLMJ9QIQ6BqGhHFiF
         Hi0Ir7lbXWo0ZBhOntTMy7B3afg89wg3nx601v4w005hPprSJwpLmP6G8zPPp/K7D+
         jwQ5iNmN1HPsmgVZCWiCtxAF65Uzk2OPfVQdLIze5ZEfBDSS1uxF5Y2lfNk6PNqdh+
         XMd0eLGin+1nCmksg0Mh8ZyiuYT1f4ZzvYAkqNpiqLDUW7F06ZSOFYV2jTfNwYwMIP
         3+SiXt5PWn4gg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 8/19/2020 8:23 PM, Takashi Iwai wrote:
> External email: Use caution opening links or attachments
>
>
> On Wed, 19 Aug 2020 16:44:33 +0200,
> Sameer Pujar wrote:
>> By default 'sdo_limit' is initialized with a default value of '8'
>> as per spec. This is overridden in cases where a different value is
>> required. However this is getting reset when snd_hdac_bus_init_chip()
>> is called again, which happens during runtime PM cycle. Avoid reset
>> by not initializing to default value everytime.
>>
>> Fixes: 67ae482a59e9 ("ALSA: hda: add member to store ratio for stripe control")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Sameer Pujar <spujar@nvidia.com>
> How about to move the default sdo_limit setup into snd_hdac_bus_init()
> instead?  That's the place to be called only once.

A better choice. Thanks for the suggestion. Will publish v2.

>
>
> thanks,
>
> Takashi
>
>
>> ---
>>   sound/hda/hdac_controller.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/sound/hda/hdac_controller.c b/sound/hda/hdac_controller.c
>> index 011b17c..0e26e96 100644
>> --- a/sound/hda/hdac_controller.c
>> +++ b/sound/hda/hdac_controller.c
>> @@ -538,7 +538,8 @@ bool snd_hdac_bus_init_chip(struct hdac_bus *bus, bool full_reset)
>>         *   { ((num_channels * bits_per_sample * rate/48000) /
>>         *      number of SDOs) >= 8 }
>>         */
>> -     bus->sdo_limit = 8;
>> +     if (!bus->sdo_limit)
>> +             bus->sdo_limit = 8;
>>
>>        return true;
>>   }
>> --
>> 2.7.4
>>
