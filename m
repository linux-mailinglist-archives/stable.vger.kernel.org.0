Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69372418AF
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 11:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgHKJEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 05:04:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35985 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728224AbgHKJEF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 05:04:05 -0400
Received: from 1.general.hwang4.us.vpn ([10.172.67.16])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1k5QCR-0002qD-5f; Tue, 11 Aug 2020 09:04:03 +0000
Subject: Re: [PATCH] ALSA: hda - fix the micmute led status for Lenovo
 ThinkCentre AIO
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Cc:     "moderated list:SOUND" <alsa-devel@alsa-project.org>,
        stable@vger.kernel.org
References: <20200810021659.7429-1-hui.wang@canonical.com>
 <s5hd03z6min.wl-tiwai@suse.de>
 <c8ca5bd3-d9a1-6269-e088-6bc6e3936876@canonical.com>
 <s5ha6z36lk8.wl-tiwai@suse.de>
 <01D08974-C4EB-4820-9870-42B633DC19B3@canonical.com>
From:   Hui Wang <hui.wang@canonical.com>
Message-ID: <36899086-0e36-5b9f-42cd-745e0c717871@canonical.com>
Date:   Tue, 11 Aug 2020 17:03:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <01D08974-C4EB-4820-9870-42B633DC19B3@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2020/8/11 下午4:56, Kai-Heng Feng wrote:
> Hi,
>
>> On Aug 10, 2020, at 14:51, Takashi Iwai <tiwai@suse.de> wrote:
>>
>> On Mon, 10 Aug 2020 08:34:36 +0200,
>> Hui Wang wrote:
>>>
>>> On 2020/8/10 下午2:30, Takashi Iwai wrote:
>>>> On Mon, 10 Aug 2020 04:16:59 +0200,
>>>> Hui Wang wrote:
>>>>> After installing the Ubuntu Linux, the micmute led status is not
>>>>> correct. Users expect that the led is on if the capture is disabled,
>>>>> but with the current kernel, the led is off with the capture disabled.
>>>>>
>>>>> We tried the old linux kernel like linux-4.15, there is no this issue.
>>>>> It looks like we introduced this issue when switching to the led_cdev.
>>>> The behavior can be controlled via "Mic Mute-LED Mode" enum kcontrol.
>>>> Which value does it have now?  If it's "Follow Capture", that's the
>>>> correct behavior.  OTOH, if it's "Follow Mute", the LED polarity is
>>>> indeed wrong.
>>> It is "Follow Mute",  if I change it to "Follow Capture" manually, the
>>> led status becomes correct.
>> OK, thanks for confirmation.  Applied now.
> I wonder if it's because how brightness value passed to gpio_mute_led_set() and micmute_led_set():
>
> static int gpio_mute_led_set(struct led_classdev *led_cdev,
>                               enum led_brightness brightness)
> {
>          struct hda_codec *codec = dev_to_hda_codec(led_cdev->dev->parent);
>          struct alc_spec *spec = codec->spec;
>
>          alc_update_gpio_led(codec, spec->gpio_mute_led_mask,
>                              spec->mute_led_polarity, !brightness);
>          return 0;
> }
>
> static int micmute_led_set(struct led_classdev *led_cdev,
>                             enum led_brightness brightness)
> {
>          struct hda_codec *codec = dev_to_hda_codec(led_cdev->dev->parent);
>          struct alc_spec *spec = codec->spec;
>
>          alc_update_gpio_led(codec, spec->gpio_mic_led_mask,
>                              spec->micmute_led_polarity, !!brightness);
>          return 0;
> }
>
> Maybe we should let micmute_led_set() match gpio_mute_led_set() so the micmute polarity can be removed?

This will impact many many machines, I don't know if the current code 
could work correctly or not on other machines.

Thanks,

Hui.

>
> Kai-Heng
>
>>
>> Takashi
