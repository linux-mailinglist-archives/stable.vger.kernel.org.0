Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCFAA240202
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 08:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725774AbgHJGer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 02:34:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48025 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgHJGer (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 02:34:47 -0400
Received: from [114.253.245.60] (helo=[192.168.0.104])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1k51OP-0007Gs-Gk; Mon, 10 Aug 2020 06:34:45 +0000
Subject: Re: [PATCH] ALSA: hda - fix the micmute led status for Lenovo
 ThinkCentre AIO
To:     Takashi Iwai <tiwai@suse.de>
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
References: <20200810021659.7429-1-hui.wang@canonical.com>
 <s5hd03z6min.wl-tiwai@suse.de>
From:   Hui Wang <hui.wang@canonical.com>
Message-ID: <c8ca5bd3-d9a1-6269-e088-6bc6e3936876@canonical.com>
Date:   Mon, 10 Aug 2020 14:34:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <s5hd03z6min.wl-tiwai@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2020/8/10 下午2:30, Takashi Iwai wrote:
> On Mon, 10 Aug 2020 04:16:59 +0200,
> Hui Wang wrote:
>> After installing the Ubuntu Linux, the micmute led status is not
>> correct. Users expect that the led is on if the capture is disabled,
>> but with the current kernel, the led is off with the capture disabled.
>>
>> We tried the old linux kernel like linux-4.15, there is no this issue.
>> It looks like we introduced this issue when switching to the led_cdev.
> The behavior can be controlled via "Mic Mute-LED Mode" enum kcontrol.
> Which value does it have now?  If it's "Follow Capture", that's the
> correct behavior.  OTOH, if it's "Follow Mute", the LED polarity is
> indeed wrong.

It is "Follow Mute",  if I change it to "Follow Capture" manually, the 
led status becomes correct.

Thanks.

>
>
> thanks,
>
> Takashi
>
>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Hui Wang <hui.wang@canonical.com>
>> ---
>>   sound/pci/hda/patch_realtek.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
>> index daedcc0adc21..09d93dd88713 100644
>> --- a/sound/pci/hda/patch_realtek.c
>> +++ b/sound/pci/hda/patch_realtek.c
>> @@ -4414,6 +4414,7 @@ static void alc233_fixup_lenovo_line2_mic_hotkey(struct hda_codec *codec,
>>   {
>>   	struct alc_spec *spec = codec->spec;
>>   
>> +	spec->micmute_led_polarity = 1;
>>   	alc_fixup_hp_gpio_led(codec, action, 0, 0x04);
>>   	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
>>   		spec->init_amp = ALC_INIT_DEFAULT;
>> -- 
>> 2.17.1
>>
