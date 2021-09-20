Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B39411DE1
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347231AbhITRZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:25:34 -0400
Received: from mail1.perex.cz ([77.48.224.245]:59472 "EHLO mail1.perex.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229849AbhITRXi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:23:38 -0400
Received: from mail1.perex.cz (localhost [127.0.0.1])
        by smtp1.perex.cz (Perex's E-mail Delivery System) with ESMTP id AB079A003E;
        Mon, 20 Sep 2021 19:22:09 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp1.perex.cz AB079A003E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=perex.cz; s=default;
        t=1632158529; bh=kv1wbMFRgrQwqZvmZ0oJ5ioIGhCcRDJN/8c1FRurspo=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=qR33ooaatNG1KZGYW/PaTHDhk9NVO85VHu4vwR6+SBf0/YpiK+5I2rH76ktzHoinR
         csOO+R9WM8r79hvNlAFUCJU0sbPpxa5ZWCZtGDQZUku8YPAzr2NrcH/syZAxJubT6I
         fFMCHiO1kyjF8RtDsVMl/Vs4wRfBDsiAoods8I38=
Received: from p1gen2.localdomain (unknown [192.168.100.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: perex)
        by mail1.perex.cz (Perex's E-mail Delivery System) with ESMTPSA;
        Mon, 20 Sep 2021 19:22:05 +0200 (CEST)
Subject: Re: [PATCH] ALSA: rawmidi: introduce
 SNDRV_RAWMIDI_IOCTL_USER_PVERSION
To:     David Henningsson <coding@diwic.se>,
        ALSA development <alsa-devel@alsa-project.org>
Cc:     Takashi Iwai <tiwai@suse.de>, stable@vger.kernel.org
References: <20210920083538.128008-1-perex@perex.cz>
 <5f2b66ef-01f2-f371-e8af-afa236f10cc5@diwic.se>
From:   Jaroslav Kysela <perex@perex.cz>
Message-ID: <88bd2d00-20af-4fd5-8a76-a81247ed331a@perex.cz>
Date:   Mon, 20 Sep 2021 19:22:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <5f2b66ef-01f2-f371-e8af-afa236f10cc5@diwic.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20. 09. 21 18:42, David Henningsson wrote:
> 
> On 2021-09-20 10:35, Jaroslav Kysela wrote:
>> The new framing mode causes the user space regression, because
>> the alsa-lib code does not initialize the reserved space in
>> the params structure when the device is opened.
>>
>> This change adds SNDRV_RAWMIDI_IOCTL_USER_PVERSION like we
>> do for the PCM interface for the protocol acknowledgment.
>>
>> Cc: David Henningsson <coding@diwic.se>
>> Cc: <stable@vger.kernel.org>
>> Fixes: 08fdced60ca0 ("ALSA: rawmidi: Add framing mode")
>> BugLink: https://github.com/alsa-project/alsa-lib/issues/178
>> Signed-off-by: Jaroslav Kysela <perex@perex.cz>
>> ---
>>   include/sound/rawmidi.h     | 1 +
>>   include/uapi/sound/asound.h | 1 +
>>   sound/core/rawmidi.c        | 9 +++++++++
>>   3 files changed, 11 insertions(+)
>>
>> diff --git a/include/sound/rawmidi.h b/include/sound/rawmidi.h
>> index 989e1517332d..7a08ed2acd60 100644
>> --- a/include/sound/rawmidi.h
>> +++ b/include/sound/rawmidi.h
>> @@ -98,6 +98,7 @@ struct snd_rawmidi_file {
>>   	struct snd_rawmidi *rmidi;
>>   	struct snd_rawmidi_substream *input;
>>   	struct snd_rawmidi_substream *output;
>> +	unsigned int user_pversion;	/* supported protocol version */
>>   };
>>   
>>   struct snd_rawmidi_str {
>> diff --git a/include/uapi/sound/asound.h b/include/uapi/sound/asound.h
>> index 1d84ec9db93b..f906e50a7919 100644
>> --- a/include/uapi/sound/asound.h
>> +++ b/include/uapi/sound/asound.h
>> @@ -784,6 +784,7 @@ struct snd_rawmidi_status {
>>   
>>   #define SNDRV_RAWMIDI_IOCTL_PVERSION	_IOR('W', 0x00, int)
>>   #define SNDRV_RAWMIDI_IOCTL_INFO	_IOR('W', 0x01, struct snd_rawmidi_info)
>> +#define SNDRV_RAWMIDI_IOCTL_USER_PVERSION _IOW('A', 0x02, int)
> 
> How come it's not 'W' here but 'A' instead?

Good catch. I sent v2 of this patch with this correction. Thank you.

https://lore.kernel.org/alsa-devel/20210920171850.154186-1-perex@perex.cz/

					Jaroslav

> 
> Looks good otherwise, given a quick glance. It'll need a corresponding 
> alsa-lib patch to actually call SNDRV_RAWMIDI_IOCTL_USER_PVERSION.
> 
> Thanks for helping to sort this out.
> 
> // David
> 


-- 
Jaroslav Kysela <perex@perex.cz>
Linux Sound Maintainer; ALSA Project; Red Hat, Inc.
