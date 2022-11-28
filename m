Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E87D63AE16
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 17:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbiK1QtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 11:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiK1QtY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 11:49:24 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51756167F4;
        Mon, 28 Nov 2022 08:49:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669654163; x=1701190163;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CgPF6MKTnegmRDmcI5KCYgm3Dojtw3BD/LAsoXreVzA=;
  b=HtF/KqwLsL6qxOspoQuu4/2ZGgGHtzJdzUMY3XrCXkMN3R+bCvU89Xa9
   6ttqO6pnFF5OE67aC2r1Z65KxhLxeOUUpTyAxxFDUwdCkWsz2oOog/CBg
   dy1TDQnJV9zbZ/cmO6M2vHaO0aoDdHRJLxAYYK+HmiLvywq3rGIM/TQtD
   VkUNwNjQQYDDi6vZ74q7nk/FbXlItTTY+GsXwegiaOtoB15q18TDkxVIJ
   qd4lldcZD24VI4h3kLLZEdAEQWh43YgyWL+ASxDhjFdORTQbigZl9E6wT
   fBEYMBoDluwC+A1fTnD/o1GaZdfGVWrCQBPAKiEjmpeSUeHC76QtwsOYg
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="379144205"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="379144205"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 08:49:22 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="768104564"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="768104564"
Received: from kschjaer-mobl.amr.corp.intel.com (HELO [10.212.114.246]) ([10.212.114.246])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 08:49:21 -0800
Message-ID: <5171929e-b750-d2f1-fec9-b34d76c18dcb@linux.intel.com>
Date:   Mon, 28 Nov 2022 10:49:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.2
Subject: Re: [PATCH v4] ALSA: core: Fix deadlock when shutdown a frozen
 userspace
Content-Language: en-US
To:     Ricardo Ribalda <ribalda@chromium.org>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Takashi Iwai <tiwai@suse.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc:     alsa-devel@alsa-project.org, sound-open-firmware@alsa-project.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20221127-snd-freeze-v4-0-51ca64b7f2ab@chromium.org>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <20221127-snd-freeze-v4-0-51ca64b7f2ab@chromium.org>
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



On 11/28/22 07:42, Ricardo Ribalda wrote:
> During kexec(), the userspace is frozen. Therefore we cannot wait for it
> to complete.
> 
> Avoid running snd_sof_machine_unregister during shutdown.
> 
> This fixes:
> 
> [   84.943749] Freezing user space processes ... (elapsed 0.111 seconds) done.
> [  246.784446] INFO: task kexec-lite:5123 blocked for more than 122 seconds.
> [  246.819035] Call Trace:
> [  246.821782]  <TASK>
> [  246.824186]  __schedule+0x5f9/0x1263
> [  246.828231]  schedule+0x87/0xc5
> [  246.831779]  snd_card_disconnect_sync+0xb5/0x127
> ...
> [  246.889249]  snd_sof_device_shutdown+0xb4/0x150
> [  246.899317]  pci_device_shutdown+0x37/0x61
> [  246.903990]  device_shutdown+0x14c/0x1d6
> [  246.908391]  kernel_kexec+0x45/0xb9
> 
> And:
> 
> [  246.893222] INFO: task kexec-lite:4891 blocked for more than 122 seconds.
> [  246.927709] Call Trace:
> [  246.930461]  <TASK>
> [  246.932819]  __schedule+0x5f9/0x1263
> [  246.936855]  ? fsnotify_grab_connector+0x5c/0x70
> [  246.942045]  schedule+0x87/0xc5
> [  246.945567]  schedule_timeout+0x49/0xf3
> [  246.949877]  wait_for_completion+0x86/0xe8
> [  246.954463]  snd_card_free+0x68/0x89
> ...
> [  247.001080]  platform_device_unregister+0x12/0x35
> 
> Cc: stable@vger.kernel.org
> Fixes: 83bfc7e793b5 ("ASoC: SOF: core: unregister clients and machine drivers in .shutdown")
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> ---
> To: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> To: Liam Girdwood <lgirdwood@gmail.com>
> To: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
> To: Bard Liao <yung-chuan.liao@linux.intel.com>
> To: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> To: Kai Vehmanen <kai.vehmanen@linux.intel.com>
> To: Daniel Baluta <daniel.baluta@nxp.com>
> To: Mark Brown <broonie@kernel.org>
> To: Jaroslav Kysela <perex@perex.cz>
> To: Takashi Iwai <tiwai@suse.com>
> Cc: sound-open-firmware@alsa-project.org
> Cc: alsa-devel@alsa-project.org
> Cc: linux-kernel@vger.kernel.org
> ---
> Changes in v4:
> - Do not call snd_sof_machine_unregister from shutdown.
> - Link to v3: https://lore.kernel.org/r/20221127-snd-freeze-v3-0-a2eda731ca14@chromium.org
> 
> Changes in v3:
> - Wrap pm_freezing in a function
> - Link to v2: https://lore.kernel.org/r/20221127-snd-freeze-v2-0-d8a425ea9663@chromium.org
> 
> Changes in v2:
> - Only use pm_freezing if CONFIG_FREEZER 
> - Link to v1: https://lore.kernel.org/r/20221127-snd-freeze-v1-0-57461a366ec2@chromium.org
> ---
>  sound/soc/sof/core.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/sound/soc/sof/core.c b/sound/soc/sof/core.c
> index 3e6141d03770..9616ba607ded 100644
> --- a/sound/soc/sof/core.c
> +++ b/sound/soc/sof/core.c
> @@ -475,19 +475,16 @@ EXPORT_SYMBOL(snd_sof_device_remove);
>  int snd_sof_device_shutdown(struct device *dev)
>  {
>  	struct snd_sof_dev *sdev = dev_get_drvdata(dev);
> -	struct snd_sof_pdata *pdata = sdev->pdata;
>  
>  	if (IS_ENABLED(CONFIG_SND_SOC_SOF_PROBE_WORK_QUEUE))
>  		cancel_work_sync(&sdev->probe_work);
>  
>  	/*
> -	 * make sure clients and machine driver(s) are unregistered to force
> -	 * all userspace devices to be closed prior to the DSP shutdown sequence
> +	 * make sure clients are unregistered prior to the DSP shutdown
> +	 * sequence.
>  	 */
>  	sof_unregister_clients(sdev);
>  
> -	snd_sof_machine_unregister(sdev, pdata);
> -

The comment clearly says that we do want all userspace devices to be
closed. This was added in 83bfc7e793b5 ("ASoC: SOF: core: unregister
clients and machine drivers in .shutdown") precisely to avoid a platform
hang if the devices are used after the shutdown completes.

So you are not fixing 83bfc7e793b5, just re-adding a problem to fix
another one...
