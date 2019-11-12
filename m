Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B801AF8F95
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 13:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbfKLMVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 07:21:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48759 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbfKLMVq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 07:21:46 -0500
Received: from [111.196.69.240] (helo=[192.168.1.103])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1iUVB1-0004Fc-O9; Tue, 12 Nov 2019 12:21:44 +0000
Subject: Re: [PATCH] ALSA: hda/hdmi - add a parameter to let users decide if
 checking the eld_valid
To:     Takashi Iwai <tiwai@suse.de>
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
References: <20191111144502.22910-1-hui.wang@canonical.com>
 <s5h7e46whpi.wl-tiwai@suse.de> <s5hzhh2v1pw.wl-tiwai@suse.de>
From:   Hui Wang <hui.wang@canonical.com>
Message-ID: <cf190a1c-ec4c-0031-f1af-c3bfdd1acc85@canonical.com>
Date:   Tue, 12 Nov 2019 20:21:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <s5hzhh2v1pw.wl-tiwai@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2019/11/12 上午12:04, Takashi Iwai wrote:
> On Mon, 11 Nov 2019 16:33:45 +0100,
> Takashi Iwai wrote:
>> On Mon, 11 Nov 2019 15:45:02 +0100,
>> Hui Wang wrote:
>>> With the commit 7f641e26a6df ("ALSA: hda/hdmi - Consider eld_valid
>>> when reporting jack event"), the driver checks eld_valid before
>>> reporting Jack state, this fixes the 4 HDMI/DP audio devices issue.
>>>
>>> But recently some users complained that the hdmi audio on their
>>> machines couldn't work anymore with this commit. On their machines,
>>> the monitor_present is 1 while the eld_valid is 0 when plugging a
>>> monitor, and the hdmi audio could work even the eld_valid is 0.
>>>
>>> To make the hdmi audio work again on those machines, adding a module
>>> parameter, if usrs want to skip the checking eld_valid, they
>>> could set checking_eld_valid=0 when loading the module. And this
>>> parameter only applies to sense_via_verbs, for those getting eld via
>>> component, no need to apply this parameter since it is impossible
>>> that present is 1 while eld_valid is 0.
>>>
>>> BugLink: https://bugs.launchpad.net/bugs/1834771
>>> Fixes: 7f641e26a6df ("ALSA: hda/hdmi - Consider eld_valid when reporting jack event")
>>> Cc: <stable@vger.kernel.org>
>>> Signed-off-by: Hui Wang <hui.wang@canonical.com>
>> Well, this sort of module option is rather a last resort, so I
>> hesitate to apply this.
>>
>> The bug reports in the above are a bit hard to digest quickly.
>> Could you tell exactly which hardware (and drivers) show the problem?
>>
>> FWIW, amdgpu driver already got the audio-component binding recently,
>> so this problem shouldn't be triggered, at least in this code path.
>> And, for nouveau and radeon, I already submitted the patches to
>> support the audio-component binding, but by some reason they haven't
>> been merged to the upstream.  In that case, we'd need to ping DRM
>> guys.

I know the amdgpu driver already supported audio-component, I guess it 
will fix this problem. But it is not easy to backport the related 
patches to ubuntu 4.15 and 5.0 kernels. It will be better if we could 
figure out a fix for sense_via_verbs() too. :-)


> On the second thought, I wonder whether eld_valid would be corrected
> later by the graphics side at all.  If yes, it's a timing issue, and
> it can be corrected with the repolling.
>
> A totally untested patch is below.

I will build a testing kernel with this patch and let the bug reporter 
test it.

Thanks,

Hui.


>
> thanks,
>
> Takashi
>
> --- a/sound/pci/hda/patch_hdmi.c
> +++ b/sound/pci/hda/patch_hdmi.c
> @@ -1549,19 +1549,25 @@ static bool hdmi_present_sense_via_verbs(struct hdmi_spec_per_pin *per_pin,
>   			do_repoll = true;
>   	}
>   
> -	if (do_repoll)
> +	do_repoll |= repoll && eld->eld_valid != eld->monitor_present;
> +	if (do_repoll) {
>   		schedule_delayed_work(&per_pin->work, msecs_to_jiffies(300));
> -	else
> +		ret = false;
> +	} else {
>   		update_eld(codec, per_pin, eld);
> -
> -	ret = !repoll || !eld->monitor_present || eld->eld_valid;
> +		per_pin->repoll_count = 0;
> +		ret = true;
> +	}
>   
>   	jack = snd_hda_jack_tbl_get(codec, pin_nid);
>   	if (jack) {
>   		jack->block_report = !ret;
> -		jack->pin_sense = (eld->monitor_present && eld->eld_valid) ?
> -			AC_PINSENSE_PRESENCE : 0;
> +		if (ret) {
> +			jack->pin_sense = (eld->monitor_present && eld->eld_valid) ?
> +				AC_PINSENSE_PRESENCE : 0;
> +		}
>   	}
> +
>   	mutex_unlock(&per_pin->lock);
>   	return ret;
>   }
>
