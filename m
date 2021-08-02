Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F253DD1C4
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 10:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbhHBIO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 04:14:27 -0400
Received: from mga07.intel.com ([134.134.136.100]:9124 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232654AbhHBIO1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 04:14:27 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10063"; a="277180161"
X-IronPort-AV: E=Sophos;i="5.84,288,1620716400"; 
   d="scan'208";a="277180161"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2021 01:14:17 -0700
X-IronPort-AV: E=Sophos;i="5.84,288,1620716400"; 
   d="scan'208";a="509972316"
Received: from crojewsk-mobl1.ger.corp.intel.com (HELO [10.213.13.140]) ([10.213.13.140])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2021 01:14:15 -0700
Subject: Re: [PATCH 2/5] ASoC: intel: atom: Fix reference to PCM buffer
 address
To:     Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Cc:     Mark Brown <broonie@kernel.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        stable@vger.kernel.org
References: <20210728112353.6675-1-tiwai@suse.de>
 <20210728112353.6675-3-tiwai@suse.de>
From:   Cezary Rojewski <cezary.rojewski@intel.com>
Message-ID: <558118ee-f581-f4ae-5066-5e67a416666f@intel.com>
Date:   Mon, 2 Aug 2021 10:14:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210728112353.6675-3-tiwai@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-07-28 1:23 PM, Takashi Iwai wrote:
> PCM buffers might be allocated dynamically when the buffer
> preallocation failed or a larger buffer is requested, and it's not
> guaranteed that substream->dma_buffer points to the actually used
> buffer.  The address should be retrieved from runtime->dma_addr,
> instead of substream->dma_buffer (and shouldn't use virt_to_phys).
> 
> Also, remove the line overriding runtime->dma_area superfluously,
> which was already set up at the PCM buffer allocation.
> 
> Cc: Cezary Rojewski <cezary.rojewski@intel.com>
> Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>   sound/soc/intel/atom/sst-mfld-platform-pcm.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/sound/soc/intel/atom/sst-mfld-platform-pcm.c b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
> index 4124aa2fc247..5db2f4865bbb 100644
> --- a/sound/soc/intel/atom/sst-mfld-platform-pcm.c
> +++ b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
> @@ -127,7 +127,7 @@ static void sst_fill_alloc_params(struct snd_pcm_substream *substream,
>   	snd_pcm_uframes_t period_size;
>   	ssize_t periodbytes;
>   	ssize_t buffer_bytes = snd_pcm_lib_buffer_bytes(substream);
> -	u32 buffer_addr = virt_to_phys(substream->dma_buffer.area);
> +	u32 buffer_addr = substream->runtime->dma_addr;
>   
>   	channels = substream->runtime->channels;
>   	period_size = substream->runtime->period_size;
> @@ -233,7 +233,6 @@ static int sst_platform_alloc_stream(struct snd_pcm_substream *substream,
>   	/* set codec params and inform SST driver the same */
>   	sst_fill_pcm_params(substream, &param);
>   	sst_fill_alloc_params(substream, &alloc_params);
> -	substream->runtime->dma_area = substream->dma_buffer.area;
>   	str_params.sparams = param;
>   	str_params.aparams = alloc_params;
>   	str_params.codec = SST_CODEC_TYPE_PCM;
> 

Hello,

Changes look good. Can't verify these due to lack of test vehicles, 
unfortunately.

Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
