Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2EC7498282
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 15:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238038AbiAXOhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 09:37:37 -0500
Received: from mga12.intel.com ([192.55.52.136]:3338 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234226AbiAXOhh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jan 2022 09:37:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643035056; x=1674571056;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OX53ujXtLEx0S9+9N/yH2epiXhl14vtkEg74KnD/UvE=;
  b=GTBFlUXBoBHnDsejQCY/QxBH2CAso6fL3J6gDn0FZUeA+9IzQ8Wnx5D/
   FJCeCOjy0nmDp0//RmQbusaopgH/jjTDmT2Ph7OzdpA/nf/e9WbvIHB0W
   c1ZMkvVaHrK5E69PNJpE3PEZkA4wuHwS1PfFxgThj4PYXxN/1Y+k2S9kR
   dZkIFdxX0RwsxLcwngJG7PJVTc+hrmeao3J+RPX/a1A4bhY+SHNFXI4+I
   yMCxeedc+falLJm5cZbwW8tpotWr1HkieHhfVnULkqmwFqeE9e7RUAsyD
   NLnNM0Oqg+uCcjSxUoIYIc/x2w9vEyHI5PzgKRNpZ5QgxLT+F5y4r4Wd9
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="226038182"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="226038182"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 06:37:36 -0800
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="494638184"
Received: from jindalan-mobl.amr.corp.intel.com (HELO [10.212.11.218]) ([10.212.11.218])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 06:37:36 -0800
Message-ID: <45de02b3-031a-35f2-eedd-b87f3a8f19af@linux.intel.com>
Date:   Mon, 24 Jan 2022 08:37:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: FAILED: patch "[PATCH] ASoC: SOF: handle paused streams during
 system suspend" failed to apply to 5.16-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, ranjani.sridharan@linux.intel.com,
        bard.liao@intel.com, broonie@kernel.org,
        kai.vehmanen@linux.intel.com, paul.olaru@oss.nxp.com
Cc:     stable@vger.kernel.org
References: <1643032809235135@kroah.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <1643032809235135@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/24/22 08:00, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.16-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

This is a bit of a corner case, most users don't use pause and
suspending while paused is not well handled in general.

This problem was detected by our CI test suite and fixed for
consistency, but it's not clear to me that this should land in -stable.

If there was any consensus that this is needed, the following sequence
works for me:

git cherry-pick 7cc7b9ba21d4978d19f0e3edc2b00d44c9d66ff6
git cherry-pick b2ebcf42a48f4560862bb811f3268767d17ebdcd
git cherry-pick 01429183f479c54c1b5d15453a8ce574ea43e525

and then this commit

git cherry-pick 96da174024b9c63bd5d3358668d0bc12677be877


> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 96da174024b9c63bd5d3358668d0bc12677be877 Mon Sep 17 00:00:00 2001
> From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> Date: Tue, 23 Nov 2021 19:16:06 +0200
> Subject: [PATCH] ASoC: SOF: handle paused streams during system suspend
> 
> During system suspend, paused streams do not get suspended.
> Therefore, we need to explicitly free these PCMs in the DSP
> and free the associated DAPM widgets so that they can be set
> up again during resume.
> 
> Fixes: 5fcdbb2d45df ("ASoC: SOF: Add support for dynamic pipelines")
> Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> Reviewed-by: Paul Olaru <paul.olaru@oss.nxp.com>
> Reviewed-by: Bard Liao <bard.liao@intel.com>
> Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
> Link: https://lore.kernel.org/r/20211123171606.129350-3-kai.vehmanen@linux.intel.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> 
> diff --git a/sound/soc/sof/pcm.c b/sound/soc/sof/pcm.c
> index 31dd79b794f1..0ceb1a9cbf73 100644
> --- a/sound/soc/sof/pcm.c
> +++ b/sound/soc/sof/pcm.c
> @@ -100,9 +100,8 @@ void snd_sof_pcm_period_elapsed(struct snd_pcm_substream *substream)
>  }
>  EXPORT_SYMBOL(snd_sof_pcm_period_elapsed);
>  
> -static int sof_pcm_dsp_pcm_free(struct snd_pcm_substream *substream,
> -				struct snd_sof_dev *sdev,
> -				struct snd_sof_pcm *spcm)
> +int sof_pcm_dsp_pcm_free(struct snd_pcm_substream *substream, struct snd_sof_dev *sdev,
> +			 struct snd_sof_pcm *spcm)
>  {
>  	struct sof_ipc_stream stream;
>  	struct sof_ipc_reply reply;
> diff --git a/sound/soc/sof/sof-audio.c b/sound/soc/sof/sof-audio.c
> index f4e142ec0fbd..e00ce275052f 100644
> --- a/sound/soc/sof/sof-audio.c
> +++ b/sound/soc/sof/sof-audio.c
> @@ -129,6 +129,14 @@ int sof_widget_free(struct snd_sof_dev *sdev, struct snd_sof_widget *swidget)
>  	case snd_soc_dapm_buffer:
>  		ipc_free.hdr.cmd |= SOF_IPC_TPLG_BUFFER_FREE;
>  		break;
> +	case snd_soc_dapm_dai_in:
> +	case snd_soc_dapm_dai_out:
> +	{
> +		struct snd_sof_dai *dai = swidget->private;
> +
> +		dai->configured = false;
> +		fallthrough;
> +	}
>  	default:
>  		ipc_free.hdr.cmd |= SOF_IPC_TPLG_COMP_FREE;
>  		break;
> @@ -720,6 +728,55 @@ int sof_set_up_pipelines(struct snd_sof_dev *sdev, bool verify)
>  	return 0;
>  }
>  
> +/*
> + * Free the PCM, its associated widgets and set the prepared flag to false for all PCMs that
> + * did not get suspended(ex: paused streams) so the widgets can be set up again during resume.
> + */
> +static int sof_tear_down_left_over_pipelines(struct snd_sof_dev *sdev)
> +{
> +	struct snd_sof_widget *swidget;
> +	struct snd_sof_pcm *spcm;
> +	int dir, ret;
> +
> +	/*
> +	 * free all PCMs and their associated DAPM widgets if their connected DAPM widget
> +	 * list is not NULL. This should only be true for paused streams at this point.
> +	 * This is equivalent to the handling of FE DAI suspend trigger for running streams.
> +	 */
> +	list_for_each_entry(spcm, &sdev->pcm_list, list)
> +		for_each_pcm_streams(dir) {
> +			struct snd_pcm_substream *substream = spcm->stream[dir].substream;
> +
> +			if (!substream || !substream->runtime)
> +				continue;
> +
> +			if (spcm->stream[dir].list) {
> +				ret = sof_pcm_dsp_pcm_free(substream, sdev, spcm);
> +				if (ret < 0)
> +					return ret;
> +
> +				ret = sof_widget_list_free(sdev, spcm, dir);
> +				if (ret < 0) {
> +					dev_err(sdev->dev, "failed to free widgets during suspend\n");
> +					return ret;
> +				}
> +			}
> +		}
> +
> +	/*
> +	 * free any left over DAI widgets. This is equivalent to the handling of suspend trigger
> +	 * for the BE DAI for running streams.
> +	 */
> +	list_for_each_entry(swidget, &sdev->widget_list, list)
> +		if (WIDGET_IS_DAI(swidget->id) && swidget->use_count == 1) {
> +			ret = sof_widget_free(sdev, swidget);
> +			if (ret < 0)
> +				return ret;
> +		}
> +
> +	return 0;
> +}
> +
>  /*
>   * For older firmware, this function doesn't free widgets for static pipelines during suspend.
>   * It only resets use_count for all widgets.
> @@ -734,8 +791,8 @@ int sof_tear_down_pipelines(struct snd_sof_dev *sdev, bool verify)
>  	/*
>  	 * This function is called during suspend and for one-time topology verification during
>  	 * first boot. In both cases, there is no need to protect swidget->use_count and
> -	 * sroute->setup because during suspend all streams are suspended and during topology
> -	 * loading the sound card unavailable to open PCMs.
> +	 * sroute->setup because during suspend all running streams are suspended and during
> +	 * topology loading the sound card unavailable to open PCMs.
>  	 */
>  	list_for_each_entry(swidget, &sdev->widget_list, list) {
>  		if (swidget->dynamic_pipeline_widget)
> @@ -754,6 +811,19 @@ int sof_tear_down_pipelines(struct snd_sof_dev *sdev, bool verify)
>  			return ret;
>  	}
>  
> +	/*
> +	 * Tear down all pipelines associated with PCMs that did not get suspended
> +	 * and unset the prepare flag so that they can be set up again during resume.
> +	 * Skip this step for older firmware.
> +	 */
> +	if (!verify && v->abi_version >= SOF_ABI_VER(3, 19, 0)) {
> +		ret = sof_tear_down_left_over_pipelines(sdev);
> +		if (ret < 0) {
> +			dev_err(sdev->dev, "failed to tear down paused pipelines\n");
> +			return ret;
> +		}
> +	}
> +
>  	list_for_each_entry(sroute, &sdev->route_list, list)
>  		sroute->setup = false;
>  
> diff --git a/sound/soc/sof/sof-audio.h b/sound/soc/sof/sof-audio.h
> index 389d56ac3aba..1c4f59d34717 100644
> --- a/sound/soc/sof/sof-audio.h
> +++ b/sound/soc/sof/sof-audio.h
> @@ -265,4 +265,6 @@ int sof_widget_free(struct snd_sof_dev *sdev, struct snd_sof_widget *swidget);
>  /* PCM */
>  int sof_widget_list_setup(struct snd_sof_dev *sdev, struct snd_sof_pcm *spcm, int dir);
>  int sof_widget_list_free(struct snd_sof_dev *sdev, struct snd_sof_pcm *spcm, int dir);
> +int sof_pcm_dsp_pcm_free(struct snd_pcm_substream *substream, struct snd_sof_dev *sdev,
> +			 struct snd_sof_pcm *spcm);
>  #endif
> 
