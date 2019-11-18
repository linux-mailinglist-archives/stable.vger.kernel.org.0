Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E487FFFD1
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 08:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbfKRHwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 02:52:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48480 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfKRHwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 02:52:17 -0500
Received: from 61-220-137-34.hinet-ip.hinet.net ([61.220.137.34] helo=[10.101.195.16])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1iWbpW-0005e4-7i; Mon, 18 Nov 2019 07:52:14 +0000
Subject: Re: [alsa-devel] [PATCH] ALSA: hda/hdmi - add a parameter to let
 users decide if checking the eld_valid
To:     Takashi Iwai <tiwai@suse.de>
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
References: <20191111144502.22910-1-hui.wang@canonical.com>
 <s5h7e46whpi.wl-tiwai@suse.de> <s5hzhh2v1pw.wl-tiwai@suse.de>
 <cf190a1c-ec4c-0031-f1af-c3bfdd1acc85@canonical.com>
 <5af71ae2-2a1e-cb75-cfce-7228c433a957@canonical.com>
 <s5himnh3bfe.wl-tiwai@suse.de>
From:   Hui Wang <hui.wang@canonical.com>
Message-ID: <d5dd18ca-401a-e2da-8118-f1200a39e1e9@canonical.com>
Date:   Mon, 18 Nov 2019 15:52:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <s5himnh3bfe.wl-tiwai@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2019/11/18 下午3:12, Takashi Iwai wrote:
> On Mon, 18 Nov 2019 05:40:52 +0100,
> Hui Wang wrote:
>>
>> On 2019/11/12 下午8:21, Hui Wang wrote:
>>> On 2019/11/12 上午12:04, Takashi Iwai wrote:
>>>> On Mon, 11 Nov 2019 16:33:45 +0100,
>>>> Takashi Iwai wrote:
>>>>> On Mon, 11 Nov 2019 15:45:02 +0100,
>>>>> Hui Wang wrote:
>> [snip]
>>>> On the second thought, I wonder whether eld_valid would be corrected
>>>> later by the graphics side at all.  If yes, it's a timing issue, and
>>>> it can be corrected with the repolling.
>>>>
>>>> A totally untested patch is below.
>>> I will build a testing kernel with this patch and let the bug
>>> reporter test it.
>>>
>>> Thanks,
>>>
>>> Hui.
>> Hello Takashi,
>>
>> Tested the patch,  it didn't work. The driver always failed to read
>> the speaker allocation from snd_hdmi_get_eld_ati().
>>
>> This is the dmesg after adding the patch:
>>
>> https://launchpadlibrarian.net/451420819/dmesg (both presence and
>> eld_valid bits are set, but can't get the speaker_alloc)
> So it's likely a bug in the graphics driver :)
>
> In anyway, it indicates that it's not about eld_valid check itself.
> The eld_valid was returned correctly together with the monitor_present
> flag.
>
> I guess the system worked casually with your patch to ignore eld_valid
> because we don't care much about the channel mapping if channels <= 2.
> IOW, another workaround would be to ignore the error if channels <=
> 2.
>
> But I wonder whether this state persists after this resume moment.
> Could you check what happens if you unload / reload the HD-audio
> driver?  Does the read of spk_alloc still fail?

OK, will test it.

Thanks,

Hui.

>
>
> thanks,
>
> Takashi
>
>> Regards,
>>
>> Hui.
>>
>>
>>>
>>>> thanks,
>>>>
>>>> Takashi
>>>>
>>>> --- a/sound/pci/hda/patch_hdmi.c
>>>> +++ b/sound/pci/hda/patch_hdmi.c
>>>> @@ -1549,19 +1549,25 @@ static bool
>>>> hdmi_present_sense_via_verbs(struct hdmi_spec_per_pin *per_pin,
>>>>                do_repoll = true;
>>>>        }
>>>>    -    if (do_repoll)
>>>> +    do_repoll |= repoll && eld->eld_valid != eld->monitor_present;
>>>> +    if (do_repoll) {
>>>>            schedule_delayed_work(&per_pin->work, msecs_to_jiffies(300));
>>>> -    else
>>>> +        ret = false;
>>>> +    } else {
>>>>            update_eld(codec, per_pin, eld);
>>>> -
>>>> -    ret = !repoll || !eld->monitor_present || eld->eld_valid;
>>>> +        per_pin->repoll_count = 0;
>>>> +        ret = true;
>>>> +    }
>>>>          jack = snd_hda_jack_tbl_get(codec, pin_nid);
>>>>        if (jack) {
>>>>            jack->block_report = !ret;
>>>> -        jack->pin_sense = (eld->monitor_present && eld->eld_valid) ?
>>>> -            AC_PINSENSE_PRESENCE : 0;
>>>> +        if (ret) {
>>>> +            jack->pin_sense = (eld->monitor_present &&
>>>> eld->eld_valid) ?
>>>> +                AC_PINSENSE_PRESENCE : 0;
>>>> +        }
>>>>        }
>>>> +
>>>>        mutex_unlock(&per_pin->lock);
>>>>        return ret;
>>>>    }
>>>>
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> https://mailman.alsa-project.org/mailman/listinfo/alsa-devel
