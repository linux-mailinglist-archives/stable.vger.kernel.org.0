Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F6D23B1A1
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 02:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729221AbgHDAVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 20:21:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54652 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729028AbgHDAVk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Aug 2020 20:21:40 -0400
Received: from [114.252.213.24] (helo=[192.168.0.104])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1k2ki1-000136-Dk; Tue, 04 Aug 2020 00:21:37 +0000
Subject: Re: [PATCH] Revert "ALSA: hda: call runtime_allow() for all hda
 controllers"
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
References: <20200803064638.6139-1-hui.wang@canonical.com>
 <0db4f5fe-7895-2d00-8ce3-96f1245000ab@linux.intel.com>
 <s5hwo2f3cux.wl-tiwai@suse.de>
 <6f583ccc-2251-384d-bc20-aa17c83a45b4@linux.intel.com>
From:   Hui Wang <hui.wang@canonical.com>
Message-ID: <e832bdc6-99d2-072d-87c4-2bbc868c099e@canonical.com>
Date:   Tue, 4 Aug 2020 08:21:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6f583ccc-2251-384d-bc20-aa17c83a45b4@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2020/8/4 上午1:00, Pierre-Louis Bossart wrote:
>
>
> On 8/3/20 11:36 AM, Takashi Iwai wrote:
>> On Mon, 03 Aug 2020 17:27:12 +0200,
>> Pierre-Louis Bossart wrote:
>>>
>>>
>>>
>>> On 8/3/20 1:46 AM, Hui Wang wrote:
>>>> This reverts commit 9a6418487b56 ("ALSA: hda: call runtime_allow()
>>>> for all hda controllers").
>>>>
>>>> The reverted patch already introduced some regressions on some
>>>> machines:
>>>>    - on gemini-lake machines, the error of "azx_get_response timeout"
>>>>      happens in the hda driver.
>>>>    - on the machines with alc662 codec, the audio jack detection 
>>>> doesn't
>>>>      work anymore.
>>>>
>>>> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=208511
>>>> Cc: <stable@vger.kernel.org>
>>>> Signed-off-by: Hui Wang <hui.wang@canonical.com>
>>>> ---
>>>>    sound/pci/hda/hda_intel.c | 1 -
>>>>    1 file changed, 1 deletion(-)
>>>>
>>>> diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
>>>> index e699873c8293..e34a4d5d047c 100644
>>>> --- a/sound/pci/hda/hda_intel.c
>>>> +++ b/sound/pci/hda/hda_intel.c
>>>> @@ -2352,7 +2352,6 @@ static int azx_probe_continue(struct azx *chip)
>>>>          if (azx_has_pm_runtime(chip)) {
>>>>            pm_runtime_use_autosuspend(&pci->dev);
>>>> -        pm_runtime_allow(&pci->dev);
>>>>            pm_runtime_put_autosuspend(&pci->dev);
>>>>        }
>>>
>>> Do I get this right that this permanently disables pm_runtime on all
>>> Intel HDaudio controllers?
>>
>> It just drops the unconditional enablement of runtime PM.
>> It can be enabled via sysfs, and that's the old default (let admin
>> enabling it via udev or whatever).
>
> Sorry I am confused now.
> Kai seemed to suggest in the Bugzilla comments that this would be 
> temporary, until these problems with i915 and ALC662 get fixed?

I planed to debug the issue of ALC662, but so far, I haven't got the 
machine,  It is difficult to debug power issues without a physical 
machine. Once I get the machine, I will debug it and try to find the 
root cause.

Thanks,

Hui.

