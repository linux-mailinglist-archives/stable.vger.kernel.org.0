Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A06D63AEE5
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbiK1R2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:28:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232649AbiK1R2D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:28:03 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA9A1126;
        Mon, 28 Nov 2022 09:28:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669656482; x=1701192482;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nrsDFP8BBP5mUInCmEHU9yFx53lFUUUO0H+uum4Vgp0=;
  b=QQSHbN1qoGTRwTt5biicOpNovCU8Yxj4opN5GJTxvJ3TaxpXpPdEg1m5
   79e6Z3N/s8nW4Kf5WB9t7PO9DAsssfSdTRIAGlAIvXiX2wrkrF33p0LmL
   g7NTVm5WYBEsCtDl0u4nBKRJuCZuKAihyQr+BVflu1tLgzy58sahKLDUI
   5SOaWagDbYnb9NkiOW/Rue6ze5G1H52jShqMQkdpCufDU4DJOFMEYk5oV
   o4Y39nqaKmLvBd5mYcQTRDpKuin5yau/A3VGr7OQ7I1tt5CdoWu2ZaY7R
   FL1iVWiZGYwK5vonlY62AAuNQnrojXIk3RnyTP/0thMW6YDPDtL3n+jTM
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="295281639"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="295281639"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 09:27:51 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="888509538"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="888509538"
Received: from kschjaer-mobl.amr.corp.intel.com (HELO [10.212.114.246]) ([10.212.114.246])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 09:27:49 -0800
Message-ID: <16ddcbb9-8afa-ff18-05f9-2e9e01baf3ea@linux.intel.com>
Date:   Mon, 28 Nov 2022 11:26:03 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.2
Subject: Re: [PATCH v4] ALSA: core: Fix deadlock when shutdown a frozen
 userspace
Content-Language: en-US
To:     Takashi Iwai <tiwai@suse.de>
Cc:     alsa-devel@alsa-project.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Takashi Iwai <tiwai@suse.com>, stable@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        linux-kernel@vger.kernel.org, sound-open-firmware@alsa-project.org
References: <20221127-snd-freeze-v4-0-51ca64b7f2ab@chromium.org>
 <5171929e-b750-d2f1-fec9-b34d76c18dcb@linux.intel.com>
 <87mt8bqaca.wl-tiwai@suse.de>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <87mt8bqaca.wl-tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/28/22 11:04, Takashi Iwai wrote:
> On Mon, 28 Nov 2022 17:49:20 +0100,
> Pierre-Louis Bossart wrote:
>>
>>
>>
>> On 11/28/22 07:42, Ricardo Ribalda wrote:
>>> During kexec(), the userspace is frozen. Therefore we cannot wait for it
>>> to complete.
>>>
>>> Avoid running snd_sof_machine_unregister during shutdown.
>>>
>>> This fixes:
>>>
>>> [   84.943749] Freezing user space processes ... (elapsed 0.111 seconds) done.
>>> [  246.784446] INFO: task kexec-lite:5123 blocked for more than 122 seconds.
>>> [  246.819035] Call Trace:
>>> [  246.821782]  <TASK>
>>> [  246.824186]  __schedule+0x5f9/0x1263
>>> [  246.828231]  schedule+0x87/0xc5
>>> [  246.831779]  snd_card_disconnect_sync+0xb5/0x127
>>> ...
>>> [  246.889249]  snd_sof_device_shutdown+0xb4/0x150
>>> [  246.899317]  pci_device_shutdown+0x37/0x61
>>> [  246.903990]  device_shutdown+0x14c/0x1d6
>>> [  246.908391]  kernel_kexec+0x45/0xb9
>>>
>>> And:
>>>
>>> [  246.893222] INFO: task kexec-lite:4891 blocked for more than 122 seconds.
>>> [  246.927709] Call Trace:
>>> [  246.930461]  <TASK>
>>> [  246.932819]  __schedule+0x5f9/0x1263
>>> [  246.936855]  ? fsnotify_grab_connector+0x5c/0x70
>>> [  246.942045]  schedule+0x87/0xc5
>>> [  246.945567]  schedule_timeout+0x49/0xf3
>>> [  246.949877]  wait_for_completion+0x86/0xe8
>>> [  246.954463]  snd_card_free+0x68/0x89
>>> ...
>>> [  247.001080]  platform_device_unregister+0x12/0x35
>>>
>>> Cc: stable@vger.kernel.org
>>> Fixes: 83bfc7e793b5 ("ASoC: SOF: core: unregister clients and machine drivers in .shutdown")
>>> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
>>> ---
>>> To: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>>> To: Liam Girdwood <lgirdwood@gmail.com>
>>> To: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>>> To: Bard Liao <yung-chuan.liao@linux.intel.com>
>>> To: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
>>> To: Kai Vehmanen <kai.vehmanen@linux.intel.com>
>>> To: Daniel Baluta <daniel.baluta@nxp.com>
>>> To: Mark Brown <broonie@kernel.org>
>>> To: Jaroslav Kysela <perex@perex.cz>
>>> To: Takashi Iwai <tiwai@suse.com>
>>> Cc: sound-open-firmware@alsa-project.org
>>> Cc: alsa-devel@alsa-project.org
>>> Cc: linux-kernel@vger.kernel.org
>>> ---
>>> Changes in v4:
>>> - Do not call snd_sof_machine_unregister from shutdown.
>>> - Link to v3: https://lore.kernel.org/r/20221127-snd-freeze-v3-0-a2eda731ca14@chromium.org
>>>
>>> Changes in v3:
>>> - Wrap pm_freezing in a function
>>> - Link to v2: https://lore.kernel.org/r/20221127-snd-freeze-v2-0-d8a425ea9663@chromium.org
>>>
>>> Changes in v2:
>>> - Only use pm_freezing if CONFIG_FREEZER 
>>> - Link to v1: https://lore.kernel.org/r/20221127-snd-freeze-v1-0-57461a366ec2@chromium.org
>>> ---
>>>  sound/soc/sof/core.c | 7 ++-----
>>>  1 file changed, 2 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/sound/soc/sof/core.c b/sound/soc/sof/core.c
>>> index 3e6141d03770..9616ba607ded 100644
>>> --- a/sound/soc/sof/core.c
>>> +++ b/sound/soc/sof/core.c
>>> @@ -475,19 +475,16 @@ EXPORT_SYMBOL(snd_sof_device_remove);
>>>  int snd_sof_device_shutdown(struct device *dev)
>>>  {
>>>  	struct snd_sof_dev *sdev = dev_get_drvdata(dev);
>>> -	struct snd_sof_pdata *pdata = sdev->pdata;
>>>  
>>>  	if (IS_ENABLED(CONFIG_SND_SOC_SOF_PROBE_WORK_QUEUE))
>>>  		cancel_work_sync(&sdev->probe_work);
>>>  
>>>  	/*
>>> -	 * make sure clients and machine driver(s) are unregistered to force
>>> -	 * all userspace devices to be closed prior to the DSP shutdown sequence
>>> +	 * make sure clients are unregistered prior to the DSP shutdown
>>> +	 * sequence.
>>>  	 */
>>>  	sof_unregister_clients(sdev);
>>>  
>>> -	snd_sof_machine_unregister(sdev, pdata);
>>> -
>>
>> The comment clearly says that we do want all userspace devices to be
>> closed. This was added in 83bfc7e793b5 ("ASoC: SOF: core: unregister
>> clients and machine drivers in .shutdown") precisely to avoid a platform
>> hang if the devices are used after the shutdown completes.
> 
> The problem is that it wants the *close* of the user-space programs
> unnecessarily.  Basically the shutdown can be seen as a sort of device
> hot unplug; i.e. the disconnection of the device files and the cleanup
> of device state are the main task.  The difference is that the hot
> unplug (unbind) usually follows the sync for the all processes being
> closed (so that you can release all resources gracefully), while this
> step is skipped for the shutdown (no need for resource-free).

Sorry Takashi, I don't have enough background to follow your explanations.

As Kai mentioned it, this step helped with a S5 issue earlier in 2022.
Removing this will mechanically bring the issue back and break other
Chromebooks.
