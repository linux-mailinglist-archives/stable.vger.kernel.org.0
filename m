Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24FB1C0A7B
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 00:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgD3Wla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 18:41:30 -0400
Received: from mupuf.org ([167.71.42.210]:51438 "EHLO mupuf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726784AbgD3Wla (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 18:41:30 -0400
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Apr 2020 18:41:28 EDT
Received: from [10.249.163.62] (global-5-181.nat-2.net.cam.ac.uk [131.111.5.181])
        by Neelix.spliet.org (Postfix) with ESMTPSA id 339F960040;
        Thu, 30 Apr 2020 23:36:06 +0100 (BST)
DKIM-Filter: OpenDKIM Filter v2.11.0 Neelix.spliet.org 339F960040
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=spliet.org;
        s=default; t=1588286166;
        bh=mAYCq6SwMehYdTI3mtH0OjWKuuvEEz7e13q+p2AAlYc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=a3LJi6CM20lYKOOOEcb9ovSGV3HB7MjuYPkEgoYEPrDAEeTXvAT695bvcpzXdUHU6
         mVExCA7Xh8anvFOXwHun6Fk3Y7Oh0astY6eoFgNFp0KZ4rYtu1Z0KHaaCqylbAPRGE
         Km7qRT7U/2vODCJ3mNd6tgGT9pHcFsN5C89uoffM=
Subject: Re: [PATCH AUTOSEL 5.6 12/38] ALSA: hda: Skip controller resume if
 not needed
To:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
References: <20200424122237.9831-1-sashal@kernel.org>
 <20200424122237.9831-12-sashal@kernel.org> <s5himhprr32.wl-tiwai@suse.de>
From:   Roy Spliet <nouveau@spliet.org>
Message-ID: <f5f301c7-a74d-7c2e-d182-3f003bfc061b@spliet.org>
Date:   Thu, 30 Apr 2020 23:36:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <s5himhprr32.wl-tiwai@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on Neelix
X-Virus-Scanned: clamav-milter 0.102.2 at Neelix
X-Virus-Status: Clean
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

(Minus "Linux kernel", that list has enough volume)

Op 24-04-2020 om 13:44 schreef Takashi Iwai:
> On Fri, 24 Apr 2020 14:22:10 +0200,
> Sasha Levin wrote:
>>
>> From: Takashi Iwai <tiwai@suse.de>
>>
>> [ Upstream commit c4c8dd6ef807663e42a5f04ea77cd62029eb99fa ]
>>
>> The HD-audio controller does system-suspend and resume operations by
>> directly calling its helpers __azx_runtime_suspend() and
>> __azx_runtime_resume().  However, in general, we don't have to resume
>> always the device fully at the system resume; typically, if a device
>> has been runtime-suspended, we can leave it to runtime resume.
>>
>> Usually for achieving this, the driver would call
>> pm_runtime_force_suspend() and pm_runtime_force_resume() pairs in the
>> system suspend and resume ops.  Unfortunately, this doesn't work for
>> the resume path in our case.  For handling the jack detection at the
>> system resume, a child codec device may need the (literally) forcibly
>> resume even if it's been runtime-suspended, and for that, the
>> controller device must be also resumed even if it's been suspended.
>>
>> This patch is an attempt to improve the situation.  It replaces the
>> direct __azx_runtime_suspend()/_resume() calls with with
>> pm_runtime_force_suspend() and pm_runtime_force_resume() with a slight
>> trick as we've done for the codec side.  More exactly:
>>
>> - azx_has_pm_runtime() check is dropped from azx_runtime_suspend() and
>>    azx_runtime_resume(), so that it can be properly executed from the
>>    system-suspend/resume path
>>
>> - The WAKEEN handling depends on the card's power state now; it's set
>>    and cleared only for the runtime-suspend
>>
>> - azx_resume() checks whether any codec may need the forcible resume
>>    beforehand.  If the forcible resume is required, it does temporary
>>    PM refcount up/down for actually triggering the runtime resume.
>>
>> - A new helper function, hda_codec_need_resume(), is introduced for
>>    checking whether the codec needs a forcible runtime-resume, and the
>>    existing code is rewritten with that.
>>
>> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=207043
>> Link: https://lore.kernel.org/r/20200413082034.25166-6-tiwai@suse.de
>> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> This commit is known to cause a regression, and the fix patch is
> included in today's pull request.  If we apply this, better to wait
> for the next batch including its fix.

These six patches, plus Takashi's fix on top of them, do not seem to 
have made it to 5.6.7 or 5.6.8 in the end. Is there a plan to include 
them in 5.6.9?
Thanks,

Roy

> 
> 
> thanks,
> 
> Takashi
> 
> 
>> ---
>>   include/sound/hda_codec.h |  5 +++++
>>   sound/pci/hda/hda_codec.c |  2 +-
>>   sound/pci/hda/hda_intel.c | 38 +++++++++++++++++++++++++++-----------
>>   3 files changed, 33 insertions(+), 12 deletions(-)
>>
>> diff --git a/include/sound/hda_codec.h b/include/sound/hda_codec.h
>> index 3ee8036f5436d..225154a4f2ed0 100644
>> --- a/include/sound/hda_codec.h
>> +++ b/include/sound/hda_codec.h
>> @@ -494,6 +494,11 @@ void snd_hda_update_power_acct(struct hda_codec *codec);
>>   static inline void snd_hda_set_power_save(struct hda_bus *bus, int delay) {}
>>   #endif
>>   
>> +static inline bool hda_codec_need_resume(struct hda_codec *codec)
>> +{
>> +	return !codec->relaxed_resume && codec->jacktbl.used;
>> +}
>> +
>>   #ifdef CONFIG_SND_HDA_PATCH_LOADER
>>   /*
>>    * patch firmware
>> diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
>> index 53e7732ef7520..aed1f8188e662 100644
>> --- a/sound/pci/hda/hda_codec.c
>> +++ b/sound/pci/hda/hda_codec.c
>> @@ -2951,7 +2951,7 @@ static int hda_codec_runtime_resume(struct device *dev)
>>   static int hda_codec_force_resume(struct device *dev)
>>   {
>>   	struct hda_codec *codec = dev_to_hda_codec(dev);
>> -	bool forced_resume = !codec->relaxed_resume && codec->jacktbl.used;
>> +	bool forced_resume = hda_codec_need_resume(codec);
>>   	int ret;
>>   
>>   	/* The get/put pair below enforces the runtime resume even if the
>> diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
>> index aa0be85614b6c..02c6308502b1e 100644
>> --- a/sound/pci/hda/hda_intel.c
>> +++ b/sound/pci/hda/hda_intel.c
>> @@ -1027,7 +1027,7 @@ static int azx_suspend(struct device *dev)
>>   	chip = card->private_data;
>>   	bus = azx_bus(chip);
>>   	snd_power_change_state(card, SNDRV_CTL_POWER_D3hot);
>> -	__azx_runtime_suspend(chip);
>> +	pm_runtime_force_suspend(dev);
>>   	if (bus->irq >= 0) {
>>   		free_irq(bus->irq, chip);
>>   		bus->irq = -1;
>> @@ -1044,7 +1044,9 @@ static int azx_suspend(struct device *dev)
>>   static int azx_resume(struct device *dev)
>>   {
>>   	struct snd_card *card = dev_get_drvdata(dev);
>> +	struct hda_codec *codec;
>>   	struct azx *chip;
>> +	bool forced_resume = false;
>>   
>>   	if (!azx_is_pm_ready(card))
>>   		return 0;
>> @@ -1055,7 +1057,20 @@ static int azx_resume(struct device *dev)
>>   			chip->msi = 0;
>>   	if (azx_acquire_irq(chip, 1) < 0)
>>   		return -EIO;
>> -	__azx_runtime_resume(chip, false);
>> +
>> +	/* check for the forced resume */
>> +	list_for_each_codec(codec, &chip->bus) {
>> +		if (hda_codec_need_resume(codec)) {
>> +			forced_resume = true;
>> +			break;
>> +		}
>> +	}
>> +
>> +	if (forced_resume)
>> +		pm_runtime_get_noresume(dev);
>> +	pm_runtime_force_resume(dev);
>> +	if (forced_resume)
>> +		pm_runtime_put(dev);
>>   	snd_power_change_state(card, SNDRV_CTL_POWER_D0);
>>   
>>   	trace_azx_resume(chip);
>> @@ -1102,12 +1117,12 @@ static int azx_runtime_suspend(struct device *dev)
>>   	if (!azx_is_pm_ready(card))
>>   		return 0;
>>   	chip = card->private_data;
>> -	if (!azx_has_pm_runtime(chip))
>> -		return 0;
>>   
>>   	/* enable controller wake up event */
>> -	azx_writew(chip, WAKEEN, azx_readw(chip, WAKEEN) |
>> -		  STATESTS_INT_MASK);
>> +	if (snd_power_get_state(card) == SNDRV_CTL_POWER_D0) {
>> +		azx_writew(chip, WAKEEN, azx_readw(chip, WAKEEN) |
>> +			   STATESTS_INT_MASK);
>> +	}
>>   
>>   	__azx_runtime_suspend(chip);
>>   	trace_azx_runtime_suspend(chip);
>> @@ -1118,17 +1133,18 @@ static int azx_runtime_resume(struct device *dev)
>>   {
>>   	struct snd_card *card = dev_get_drvdata(dev);
>>   	struct azx *chip;
>> +	bool from_rt = snd_power_get_state(card) == SNDRV_CTL_POWER_D0;
>>   
>>   	if (!azx_is_pm_ready(card))
>>   		return 0;
>>   	chip = card->private_data;
>> -	if (!azx_has_pm_runtime(chip))
>> -		return 0;
>> -	__azx_runtime_resume(chip, true);
>> +	__azx_runtime_resume(chip, from_rt);
>>   
>>   	/* disable controller Wake Up event*/
>> -	azx_writew(chip, WAKEEN, azx_readw(chip, WAKEEN) &
>> -			~STATESTS_INT_MASK);
>> +	if (from_rt) {
>> +		azx_writew(chip, WAKEEN, azx_readw(chip, WAKEEN) &
>> +			   ~STATESTS_INT_MASK);
>> +	}
>>   
>>   	trace_azx_runtime_resume(chip);
>>   	return 0;
>> -- 
>> 2.20.1
>>
