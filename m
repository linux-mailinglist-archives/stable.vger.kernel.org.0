Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993E820D1DA
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 20:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgF2So0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:44:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:40929 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729207AbgF2SoH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:44:07 -0400
IronPort-SDR: AAFcEpXyqGPuY/r2wzkoyq7dQ/PoRmSYz3Xz+zRvEdMl6K9vAJJaw43epnsu15axYVGXcEzKSN
 iXClhUxtOIog==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="134327836"
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="134327836"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 10:33:59 -0700
IronPort-SDR: ifTNC6vK3Hv++aTC6d4EftzwDzy8SJ/ov5Xgz5cG76np/LhlBPWbAluyFWi7WsP7ZRudUfRAWw
 evmVrd018qBA==
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="318665194"
Received: from mmmille1-t460s.amr.corp.intel.com (HELO [10.255.230.126]) ([10.255.230.126])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 10:33:58 -0700
Subject: Re: [PATCH 1/6] ASoC: Intel: cht_bsw_rt5672: Change bus format to I2S
 2 channel
To:     Hans de Goede <hdegoede@redhat.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Jie Yang <yang.jie@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Oder Chiou <oder_chiou@realtek.com>
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
References: <20200628155231.71089-1-hdegoede@redhat.com>
 <20200628155231.71089-2-hdegoede@redhat.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <4a9413ef-89d9-427b-27e9-a3b2df6f310a@linux.intel.com>
Date:   Mon, 29 Jun 2020 10:06:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200628155231.71089-2-hdegoede@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/28/20 10:52 AM, Hans de Goede wrote:
> The default mode for SSP configuration is TDM 4 slot and so far we were
> using this for the bus format on cht-bsw-rt56732 boards.
> 
> One board, the Lenovo Miix 2 10 uses not 1 but 2 codecs connected to SSP2.
> The second piggy-backed, output-only codec is inside the keyboard-dock
> (which has extra speakers). Unlike the main rt5672 codec, we cannot
> configure this codec, it is hard coded to use 2 channel 24 bit I2S.
> 
> Using 4 channel TDM leads to the dock speakers codec (which listens in on
> the data send from the SSP to the rt5672 codec) emiting horribly distorted
> sound.
> 
> Since we only support 2 channels anyways, there is no need for TDM on any
> cht-bsw-rt5672 designs. So we can simply use I2S 2ch everywhere.
> 
> This commit fixes the Lenovo Miix 2 10 dock speakers issue by changing
> the bus format set in cht_codec_fixup() to I2S 2 channel.
> 
> This change has been tested on the following devices with a rt5672 codec:
> 
> Lenovo Miix 2 10
> Lenovo Thinkpad 8
> Lenovo Thinkpad 10 (gen 1)
> 
> Cc: stable@vger.kernel.org
> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1786723
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>   sound/soc/intel/boards/cht_bsw_rt5672.c | 23 +++++++++++------------
>   1 file changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/sound/soc/intel/boards/cht_bsw_rt5672.c b/sound/soc/intel/boards/cht_bsw_rt5672.c
> index 7a43c70a1378..22e432768edb 100644
> --- a/sound/soc/intel/boards/cht_bsw_rt5672.c
> +++ b/sound/soc/intel/boards/cht_bsw_rt5672.c
> @@ -253,21 +253,20 @@ static int cht_codec_fixup(struct snd_soc_pcm_runtime *rtd,
>   	params_set_format(params, SNDRV_PCM_FORMAT_S24_LE);
>   
>   	/*
> -	 * Default mode for SSP configuration is TDM 4 slot
> +	 * Default mode for SSP configuration is TDM 4 slot. One board/design,
> +	 * the Lenovo Miix 2 10 uses not 1 but 2 codecs connected to SSP2. The
> +	 * second piggy-backed, output-only codec is inside the keyboard-dock
> +	 * (which has extra speakers). Unlike the main rt5672 codec, we cannot
> +	 * configure this codec, it is hard coded to use 2 channel 24 bit I2S.
> +	 * Since we only support 2 channels anyways, there is no need for TDM
> +	 * on any cht-bsw-rt5672 designs. So we simply use I2S 2ch everywhere.
>   	 */

The change looks fine, but you may want to add additional comments to 
explain what happens here.

The default mode for the SSP configuration is TDM 4 slot for the cpu-dai 
(hard-coded in DSP firmware)
the default mode for the SSP configuration is I2S for the codec-dai 
(hard-coded in the 'SSP2-Codec" .dai_fmt masks, so far unused).

So with this change, you trade one dynamic configuration for another 
(was codec, not cpu). It works because of the pre-existing hard-coded 
values for the parts that are not set in this function.

> -	ret = snd_soc_dai_set_fmt(asoc_rtd_to_codec(rtd, 0),
> -				  SND_SOC_DAIFMT_DSP_B |
> -				  SND_SOC_DAIFMT_IB_NF |
> +	ret = snd_soc_dai_set_fmt(asoc_rtd_to_cpu(rtd, 0),
> +				  SND_SOC_DAIFMT_I2S     |
> +				  SND_SOC_DAIFMT_NB_NF   |
>   				  SND_SOC_DAIFMT_CBS_CFS);
>   	if (ret < 0) {
> -		dev_err(rtd->dev, "can't set format to TDM %d\n", ret);
> -		return ret;
> -	}
> -
> -	/* TDM 4 slots 24 bit, set Rx & Tx bitmask to 4 active slots */
> -	ret = snd_soc_dai_set_tdm_slot(asoc_rtd_to_codec(rtd, 0), 0xF, 0xF, 4, 24);
> -	if (ret < 0) {
> -		dev_err(rtd->dev, "can't set codec TDM slot %d\n", ret);
> +		dev_err(rtd->dev, "can't set format to I2S, err %d\n", ret); >   		return ret;
>   	}
>   
> 
