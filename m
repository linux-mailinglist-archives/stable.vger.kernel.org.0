Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 191D9FFD8F
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 05:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbfKRElA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Nov 2019 23:41:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41231 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbfKRElA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Nov 2019 23:41:00 -0500
Received: from 61-220-137-34.hinet-ip.hinet.net ([61.220.137.34] helo=[10.101.195.16])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1iWYqP-0003kk-4e; Mon, 18 Nov 2019 04:40:57 +0000
Subject: Re: [PATCH] ALSA: hda/hdmi - add a parameter to let users decide if
 checking the eld_valid
From:   Hui Wang <hui.wang@canonical.com>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
References: <20191111144502.22910-1-hui.wang@canonical.com>
 <s5h7e46whpi.wl-tiwai@suse.de> <s5hzhh2v1pw.wl-tiwai@suse.de>
 <cf190a1c-ec4c-0031-f1af-c3bfdd1acc85@canonical.com>
Message-ID: <5af71ae2-2a1e-cb75-cfce-7228c433a957@canonical.com>
Date:   Mon, 18 Nov 2019 12:40:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <cf190a1c-ec4c-0031-f1af-c3bfdd1acc85@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2019/11/12 下午8:21, Hui Wang wrote:
>
> On 2019/11/12 上午12:04, Takashi Iwai wrote:
>> On Mon, 11 Nov 2019 16:33:45 +0100,
>> Takashi Iwai wrote:
>>> On Mon, 11 Nov 2019 15:45:02 +0100,
>>> Hui Wang wrote:
>
[snip]
>> On the second thought, I wonder whether eld_valid would be corrected
>> later by the graphics side at all.  If yes, it's a timing issue, and
>> it can be corrected with the repolling.
>>
>> A totally untested patch is below.
>
> I will build a testing kernel with this patch and let the bug reporter 
> test it.
>
> Thanks,
>
> Hui.

Hello Takashi,

Tested the patch,  it didn't work. The driver always failed to read the 
speaker allocation from snd_hdmi_get_eld_ati().

This is the dmesg after adding the patch:

https://launchpadlibrarian.net/451420819/dmesg (both presence and 
eld_valid bits are set, but can't get the speaker_alloc)

Regards,

Hui.


>
>
>>
>> thanks,
>>
>> Takashi
>>
>> --- a/sound/pci/hda/patch_hdmi.c
>> +++ b/sound/pci/hda/patch_hdmi.c
>> @@ -1549,19 +1549,25 @@ static bool 
>> hdmi_present_sense_via_verbs(struct hdmi_spec_per_pin *per_pin,
>>               do_repoll = true;
>>       }
>>   -    if (do_repoll)
>> +    do_repoll |= repoll && eld->eld_valid != eld->monitor_present;
>> +    if (do_repoll) {
>>           schedule_delayed_work(&per_pin->work, msecs_to_jiffies(300));
>> -    else
>> +        ret = false;
>> +    } else {
>>           update_eld(codec, per_pin, eld);
>> -
>> -    ret = !repoll || !eld->monitor_present || eld->eld_valid;
>> +        per_pin->repoll_count = 0;
>> +        ret = true;
>> +    }
>>         jack = snd_hda_jack_tbl_get(codec, pin_nid);
>>       if (jack) {
>>           jack->block_report = !ret;
>> -        jack->pin_sense = (eld->monitor_present && eld->eld_valid) ?
>> -            AC_PINSENSE_PRESENCE : 0;
>> +        if (ret) {
>> +            jack->pin_sense = (eld->monitor_present && 
>> eld->eld_valid) ?
>> +                AC_PINSENSE_PRESENCE : 0;
>> +        }
>>       }
>> +
>>       mutex_unlock(&per_pin->lock);
>>       return ret;
>>   }
>>
