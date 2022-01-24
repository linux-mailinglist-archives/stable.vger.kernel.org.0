Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A47498277
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 15:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiAXOc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 09:32:28 -0500
Received: from mga12.intel.com ([192.55.52.136]:2805 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235136AbiAXOc2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jan 2022 09:32:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643034748; x=1674570748;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nUSyDUBIcKvRjB/JZIHte1GLcdZVZjEvDXSwcf94QOk=;
  b=VfvSpMf56yKBn/hH6cbVRsbOi6J0ius6+6KZ83JHHnxKDRNc9ep325h6
   LuUQOHzrIpnqidFMorkBK+ZTN6A/AC2DWSd3dHaKogjiF5RvCWUiZYBuE
   E8AcTG9H8MDb4uHPtLtCozWoFrXFqdZbRT7SGIO1MdtQaE2JlQVvFXz/i
   ftXMQxvjk8Qtkk45myQzIZE6TyWCEJH68KfK4CUAyfAlO/NI8cel+3hZw
   oaFuauhfXbkTBtbafvVxRQLIRhjwRtRjY+wYEaXGwv6Rz0x+3rnYsGLe2
   u8kwGZzza8vJGuejduvBg5qEQ42z2CDmmeEgfb4TniMfeWUvQiAm4AEu0
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="226037224"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="226037224"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 06:32:27 -0800
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="494636055"
Received: from jindalan-mobl.amr.corp.intel.com (HELO [10.212.11.218]) ([10.212.11.218])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 06:32:26 -0800
Message-ID: <306d7c1b-32e9-7078-cdb9-191165d394b4@linux.intel.com>
Date:   Mon, 24 Jan 2022 08:32:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: FAILED: patch "[PATCH] ASoC: SOF: sof-audio: setup sched widgets
 during pipeline" failed to apply to 5.16-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, broonie@kernel.org,
        kai.vehmanen@linux.intel.com, ranjani.sridharan@linux.intel.com
Cc:     stable@vger.kernel.org
References: <16430327951439@kroah.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <16430327951439@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/24/22 07:59, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.16-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Yes, it looks like we've missing two dependencies. the following
sequence applies on top of v5.16.2

git cherry-pick 7cc7b9ba21d4978d19f0e3edc2b00d44c9d66ff6
git cherry-pick b2ebcf42a48f4560862bb811f3268767d17ebdcd

and then this commit
git cherry-pick 01429183f479c54c1b5d15453a8ce574ea43e525

I would recommend adding these three patches to avoid issues with
dynamic pipelines.


> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 01429183f479c54c1b5d15453a8ce574ea43e525 Mon Sep 17 00:00:00 2001
> From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Date: Tue, 23 Nov 2021 19:16:04 +0200
> Subject: [PATCH] ASoC: SOF: sof-audio: setup sched widgets during pipeline
>  complete step
> 
> Older firmware prior to ABI 3.19 has a dependency where the scheduler
> widgets need to be setup last. Moving the call to sof_widget_setup()
> before the pipeline_complete() call also helps remove the need for the
> 'reverse' direction when walking through the widget list - this was
> only working because of the topology macros but the topology does not
> require any order.
> 
> Fixes: 5fcdbb2d45df ("ASoC: SOF: Add support for dynamic pipelines")
> Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
> Link: https://lore.kernel.org/r/20211123171606.129350-1-kai.vehmanen@linux.intel.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> 
> diff --git a/sound/soc/sof/sof-audio.c b/sound/soc/sof/sof-audio.c
> index 0f2566f7c094..f4e142ec0fbd 100644
> --- a/sound/soc/sof/sof-audio.c
> +++ b/sound/soc/sof/sof-audio.c
> @@ -637,16 +637,25 @@ const struct sof_ipc_pipe_new *snd_sof_pipeline_find(struct snd_sof_dev *sdev,
>  
>  int sof_set_up_pipelines(struct snd_sof_dev *sdev, bool verify)
>  {
> +	struct sof_ipc_fw_version *v = &sdev->fw_ready.version;
>  	struct snd_sof_widget *swidget;
>  	struct snd_sof_route *sroute;
>  	int ret;
>  
>  	/* restore pipeline components */
> -	list_for_each_entry_reverse(swidget, &sdev->widget_list, list) {
> +	list_for_each_entry(swidget, &sdev->widget_list, list) {
>  		/* only set up the widgets belonging to static pipelines */
>  		if (!verify && swidget->dynamic_pipeline_widget)
>  			continue;
>  
> +		/*
> +		 * For older firmware, skip scheduler widgets in this loop,
> +		 * sof_widget_setup() will be called in the 'complete pipeline' loop
> +		 */
> +		if (v->abi_version < SOF_ABI_VER(3, 19, 0) &&
> +		    swidget->id == snd_soc_dapm_scheduler)
> +			continue;
> +
>  		/* update DAI config. The IPC will be sent in sof_widget_setup() */
>  		if (WIDGET_IS_DAI(swidget->id)) {
>  			struct snd_sof_dai *dai = swidget->private;
> @@ -694,6 +703,12 @@ int sof_set_up_pipelines(struct snd_sof_dev *sdev, bool verify)
>  			if (!verify && swidget->dynamic_pipeline_widget)
>  				continue;
>  
> +			if (v->abi_version < SOF_ABI_VER(3, 19, 0)) {
> +				ret = sof_widget_setup(sdev, swidget);
> +				if (ret < 0)
> +					return ret;
> +			}
> +
>  			swidget->complete =
>  				snd_sof_complete_pipeline(sdev, swidget);
>  			break;
> @@ -722,7 +737,7 @@ int sof_tear_down_pipelines(struct snd_sof_dev *sdev, bool verify)
>  	 * sroute->setup because during suspend all streams are suspended and during topology
>  	 * loading the sound card unavailable to open PCMs.
>  	 */
> -	list_for_each_entry_reverse(swidget, &sdev->widget_list, list) {
> +	list_for_each_entry(swidget, &sdev->widget_list, list) {
>  		if (swidget->dynamic_pipeline_widget)
>  			continue;
>  
> 
