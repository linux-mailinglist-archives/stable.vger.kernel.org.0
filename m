Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA4BEA63
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 20:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbfD2Spu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 14:45:50 -0400
Received: from mga06.intel.com ([134.134.136.31]:27294 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728962AbfD2Spu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 14:45:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Apr 2019 11:45:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,410,1549958400"; 
   d="scan'208";a="153344993"
Received: from linux.intel.com ([10.54.29.200])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Apr 2019 11:45:49 -0700
Received: from brettjgr-mobl1.ger.corp.intel.com (unknown [10.254.180.216])
        by linux.intel.com (Postfix) with ESMTP id A1D445803C2;
        Mon, 29 Apr 2019 11:45:47 -0700 (PDT)
Subject: Re: [PATCH v2] ASoC: Intel: avoid Oops if DMA setup fails
To:     Ross Zwisler <zwisler@chromium.org>, linux-kernel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Jie Yang <yang.jie@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.com>,
        alsa-devel@alsa-project.org, stable@vger.kernel.org
References: <20190429182517.210909-1-zwisler@google.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <951de893-e6ff-5bd0-3483-4c1d93b30cfc@linux.intel.com>
Date:   Mon, 29 Apr 2019 13:45:46 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190429182517.210909-1-zwisler@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/29/19 1:25 PM, Ross Zwisler wrote:
> Currently in sst_dsp_new() if we get an error return from sst_dma_new()
> we just print an error message and then still complete the function
> successfully.  This means that we are trying to run without sst->dma
> properly set up, which will result in NULL pointer dereference when
> sst->dma is later used.  This was happening for me in
> sst_dsp_dma_get_channel():
> 
>          struct sst_dma *dma = dsp->dma;
> 	...
>          dma->ch = dma_request_channel(mask, dma_chan_filter, dsp);
> 
> This resulted in:
> 
>     BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
>     IP: sst_dsp_dma_get_channel+0x4f/0x125 [snd_soc_sst_firmware]
> 
> Fix this by adding proper error handling for the case where we fail to
> set up DMA.
> 
> This change only affects Haswell and Broadwell systems.  Baytrail
> systems explicilty opt-out of DMA via sst->pdata->resindex_dma_base
> being set to -1.
> 
> Signed-off-by: Ross Zwisler <zwisler@google.com>
> Cc: stable@vger.kernel.org

Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

Thanks Ross!

FWIW we should start deprecating this driver now and transition to SOF. 
I'll double-check how the upcoming 1.3 release works on my Pixel 
2015/Samus device later this week.


> ---
> 
> Changes in v2:
>   - Upgraded the sst_dma_new() failure message from dev_warn() to dev_err()
>     (Pierre-Louis).
>   - Noted in the changelog that this change only affects Haswell and
>     Broadwell (Pierre-Louis).
> 
> ---
>   sound/soc/intel/common/sst-firmware.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/sound/soc/intel/common/sst-firmware.c b/sound/soc/intel/common/sst-firmware.c
> index 1e067504b6043..f830e59f93eaa 100644
> --- a/sound/soc/intel/common/sst-firmware.c
> +++ b/sound/soc/intel/common/sst-firmware.c
> @@ -1251,11 +1251,15 @@ struct sst_dsp *sst_dsp_new(struct device *dev,
>   		goto irq_err;
>   
>   	err = sst_dma_new(sst);
> -	if (err)
> -		dev_warn(dev, "sst_dma_new failed %d\n", err);
> +	if (err)  {
> +		dev_err(dev, "sst_dma_new failed %d\n", err);
> +		goto dma_err;
> +	}
>   
>   	return sst;
>   
> +dma_err:
> +	free_irq(sst->irq, sst);
>   irq_err:
>   	if (sst->ops->free)
>   		sst->ops->free(sst);
> 

