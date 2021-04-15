Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50887360BBF
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbhDOOZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:25:11 -0400
Received: from mga17.intel.com ([192.55.52.151]:62920 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230056AbhDOOZK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:25:10 -0400
IronPort-SDR: TdxjJHzQITVLo5uBwxZtafqy8hTojAzqkFJBj9d1oxpcWrYRI7wj24QHYB98UhP1dYDVHHqiET
 rC0Yw6IT/V7Q==
X-IronPort-AV: E=McAfee;i="6200,9189,9955"; a="174966822"
X-IronPort-AV: E=Sophos;i="5.82,225,1613462400"; 
   d="scan'208";a="174966822"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 07:24:47 -0700
IronPort-SDR: pKDKQflmVg1fjr500lbZygAhcwhvaDcQaREdvysUl4WeM6ChjHgiUhoUT4ljOeQBl2hJZ5fzGO
 VJ6yiDlb2oSg==
X-IronPort-AV: E=Sophos;i="5.82,225,1613462400"; 
   d="scan'208";a="452932231"
Received: from allanagx-mobl.amr.corp.intel.com (HELO [10.213.172.37]) ([10.213.172.37])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 07:24:47 -0700
Subject: Re: [PATCH v1] ASoC: Intel: kbl_da7219_max98927: Fix
 kabylake_ssp_fixup function
To:     Lukasz Majczak <lma@semihalf.com>, Mark Brown <broonie@kernel.org>,
        Harsha Priya <harshapriya.n@intel.com>,
        Vamshi Krishna Gopal <vamshi.krishna.gopal@intel.com>
Cc:     upstream@semihalf.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20210415124347.475432-1-lma@semihalf.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <a4c8f5d0-5bc1-1b7e-c7a5-731c9f6f7951@linux.intel.com>
Date:   Thu, 15 Apr 2021 09:24:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210415124347.475432-1-lma@semihalf.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/15/21 7:43 AM, Lukasz Majczak wrote:
> kabylake_ssp_fixup function uses snd_soc_dpcm to identify the
> codecs DAIs. The HW parameters are changed based on the codec DAI of the
> stream. The earlier approach to get snd_soc_dpcm was using container_of()
> macro on snd_pcm_hw_params.
> 
> The structures have been modified over time and snd_soc_dpcm does not have
> snd_pcm_hw_params as a reference but as a copy. This causes the current
> driver to crash when used.
> 
> This patch changes the way snd_soc_dpcm is extracted. snd_soc_pcm_runtime
> holds 2 dpcm instances (one for playback and one for capture). 2 codecs
> on the SSP are dmic (capture) and speakers (playback). Based on the
> stream direction, snd_soc_dpcm is extracted from snd_soc_pcm_runtime.
> 
> Tested for all use cases of the driver.
> Based on similar fix in kbl_rt5663_rt5514_max98927.c
> from Harsha Priya <harshapriya.n@intel.com> and
> Vamshi Krishna Gopal <vamshi.krishna.gopal@intel.com>
> 
> Cc: <stable@vger.kernel.org> # 5.4+
> Signed-off-by: Lukasz Majczak <lma@semihalf.com>
> ---
> Hi,
> This is basically a cherry-pick of this change:
> https://patchwork.kernel.org/project/alsa-devel/patch/1595432147-11166-1-git-send-email-harshapriya.n@intel.com/
> just applied to the kbl_da7219_max98927.
> Best regards,
> Lukasz

Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

> 
>   sound/soc/intel/boards/kbl_da7219_max98927.c | 38 +++++++++++++++-----
>   1 file changed, 30 insertions(+), 8 deletions(-)
> 
> diff --git a/sound/soc/intel/boards/kbl_da7219_max98927.c b/sound/soc/intel/boards/kbl_da7219_max98927.c
> index 9dfe5bd9180d..4b7b4a044f81 100644
> --- a/sound/soc/intel/boards/kbl_da7219_max98927.c
> +++ b/sound/soc/intel/boards/kbl_da7219_max98927.c
> @@ -284,11 +284,33 @@ static int kabylake_ssp_fixup(struct snd_soc_pcm_runtime *rtd,
>   	struct snd_interval *chan = hw_param_interval(params,
>   			SNDRV_PCM_HW_PARAM_CHANNELS);
>   	struct snd_mask *fmt = hw_param_mask(params, SNDRV_PCM_HW_PARAM_FORMAT);
> -	struct snd_soc_dpcm *dpcm = container_of(
> -			params, struct snd_soc_dpcm, hw_params);
> -	struct snd_soc_dai_link *fe_dai_link = dpcm->fe->dai_link;
> -	struct snd_soc_dai_link *be_dai_link = dpcm->be->dai_link;
> +	struct snd_soc_dpcm *dpcm, *rtd_dpcm = NULL;
>   
> +	/*
> +	 * The following loop will be called only for playback stream
> +	 * In this platform, there is only one playback device on every SSP
> +	 */
> +	for_each_dpcm_fe(rtd, SNDRV_PCM_STREAM_PLAYBACK, dpcm) {
> +		rtd_dpcm = dpcm;
> +		break;
> +	}
> +
> +	/*
> +	 * This following loop will be called only for capture stream
> +	 * In this platform, there is only one capture device on every SSP
> +	 */
> +	for_each_dpcm_fe(rtd, SNDRV_PCM_STREAM_CAPTURE, dpcm) {
> +		rtd_dpcm = dpcm;
> +		break;
> +	}
> +
> +	if (!rtd_dpcm)
> +		return -EINVAL;
> +
> +	/*
> +	 * The above 2 loops are mutually exclusive based on the stream direction,
> +	 * thus rtd_dpcm variable will never be overwritten
> +	 */
>   	/*
>   	 * Topology for kblda7219m98373 & kblmax98373 supports only S24_LE,
>   	 * where as kblda7219m98927 & kblmax98927 supports S16_LE by default.
> @@ -311,9 +333,9 @@ static int kabylake_ssp_fixup(struct snd_soc_pcm_runtime *rtd,
>   	/*
>   	 * The ADSP will convert the FE rate to 48k, stereo, 24 bit
>   	 */
> -	if (!strcmp(fe_dai_link->name, "Kbl Audio Port") ||
> -	    !strcmp(fe_dai_link->name, "Kbl Audio Headset Playback") ||
> -	    !strcmp(fe_dai_link->name, "Kbl Audio Capture Port")) {
> +	if (!strcmp(rtd_dpcm->fe->dai_link->name, "Kbl Audio Port") ||
> +	    !strcmp(rtd_dpcm->fe->dai_link->name, "Kbl Audio Headset Playback") ||
> +	    !strcmp(rtd_dpcm->fe->dai_link->name, "Kbl Audio Capture Port")) {
>   		rate->min = rate->max = 48000;
>   		chan->min = chan->max = 2;
>   		snd_mask_none(fmt);
> @@ -324,7 +346,7 @@ static int kabylake_ssp_fixup(struct snd_soc_pcm_runtime *rtd,
>   	 * The speaker on the SSP0 supports S16_LE and not S24_LE.
>   	 * thus changing the mask here
>   	 */
> -	if (!strcmp(be_dai_link->name, "SSP0-Codec"))
> +	if (!strcmp(rtd_dpcm->be->dai_link->name, "SSP0-Codec"))
>   		snd_mask_set_format(fmt, SNDRV_PCM_FORMAT_S16_LE);
>   
>   	return 0;
> 
