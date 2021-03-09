Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA1E3341D4
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 16:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbhCJPph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 10:45:37 -0500
Received: from mga18.intel.com ([134.134.136.126]:58359 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232347AbhCJPpK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 10:45:10 -0500
IronPort-SDR: ij+7184eLzi9iWIHLQpvvKcPX6WHI+Rh/faBJO1JjRxf+l94GO7/erEv0oMfJsIhaqzRpHvequ
 ZoOEXBIwOqZw==
X-IronPort-AV: E=McAfee;i="6000,8403,9919"; a="176089347"
X-IronPort-AV: E=Sophos;i="5.81,237,1610438400"; 
   d="scan'208";a="176089347"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 07:45:08 -0800
IronPort-SDR: EBn1OfYcIEnRmTsi2bRxfu/vCk1dJ/f+VsVMYYxw3enRy2DOO4/6dYG2GDIwk7WbTLZvBvQoT4
 VqA32q2iwYYQ==
X-IronPort-AV: E=Sophos;i="5.81,237,1610438400"; 
   d="scan'208";a="403722167"
Received: from huiyingw-mobl.amr.corp.intel.com (HELO [10.212.214.84]) ([10.212.214.84])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 07:45:07 -0800
Subject: Re: [PATCH 1/2] ASoC: intel: atom: Stop advertising non working S24LE
 support
To:     Hans de Goede <hdegoede@redhat.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jie Yang <yang.jie@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
References: <20210309105520.9185-1-hdegoede@redhat.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <e1af1b57-d384-0dce-6362-c39197cf2063@linux.intel.com>
Date:   Tue, 9 Mar 2021 09:42:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210309105520.9185-1-hdegoede@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/9/21 4:55 AM, Hans de Goede wrote:
> The SST firmware's media and deep-buffer inputs are hardcoded to
> S16LE, the corresponding DAIs don't have a hw_params callback and
> their prepare callback also does not take the format into account.
> 
> So far the advertising of non working S24LE support has not caused
> issues because pulseaudio defaults to S16LE, but changing pulse-audio's
> config to use S24LE will result in broken sound.
> 
> Pipewire is replacing pulse now and pipewire prefers S24LE over S16LE
> when available, causing the problem of the broken S24LE support to
> come to the surface now.
> 
> Cc: stable@vger.kernel.org
> BugLink: https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/866
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Humm, that is strange.
I can't recall such limitations in the firmware, and the SSP support 
does make use of 24 bits.
Please give me a couple of days to double-check what's missing.

> ---
>   sound/soc/intel/atom/sst-mfld-platform-pcm.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/sound/soc/intel/atom/sst-mfld-platform-pcm.c b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
> index 9e9b05883557..aa5dd590ddd5 100644
> --- a/sound/soc/intel/atom/sst-mfld-platform-pcm.c
> +++ b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
> @@ -488,14 +488,14 @@ static struct snd_soc_dai_driver sst_platform_dai[] = {
>   		.channels_min = SST_STEREO,
>   		.channels_max = SST_STEREO,
>   		.rates = SNDRV_PCM_RATE_44100|SNDRV_PCM_RATE_48000,
> -		.formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE,
> +		.formats = SNDRV_PCM_FMTBIT_S16_LE,
>   	},
>   	.capture = {
>   		.stream_name = "Headset Capture",
>   		.channels_min = 1,
>   		.channels_max = 2,
>   		.rates = SNDRV_PCM_RATE_44100|SNDRV_PCM_RATE_48000,
> -		.formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE,
> +		.formats = SNDRV_PCM_FMTBIT_S16_LE,
>   	},
>   },
>   {
> @@ -506,7 +506,7 @@ static struct snd_soc_dai_driver sst_platform_dai[] = {
>   		.channels_min = SST_STEREO,
>   		.channels_max = SST_STEREO,
>   		.rates = SNDRV_PCM_RATE_44100|SNDRV_PCM_RATE_48000,
> -		.formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE,
> +		.formats = SNDRV_PCM_FMTBIT_S16_LE,
>   	},
>   },
>   {
> 
