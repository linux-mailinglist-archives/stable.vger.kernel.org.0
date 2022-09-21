Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 341B15C00AF
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiIUPFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiIUPFU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:05:20 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE84448E93;
        Wed, 21 Sep 2022 08:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663772718; x=1695308718;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ivbh6ZGqsRC20s9vn6y6NPd6czEHxqm4rOtV1lbpFnc=;
  b=MK9OczHjmaMeyUXAYKW6qlCGRVgEilY44R9w67NtTGDN84bUo8drgwLW
   PraKVff6/mn0CZoTmuRYBt0vwB20GHQ+JpzxYm7qNX93WW6aIMflxveCQ
   uWHeqrgMtREwu1wdW6NefYS+xwFg0GMRcQ2NhltPrCbbSs/XmtNDCmWBE
   nKGMpWMNnXN17SX/XoF0oM+Tl8BI3H6HDOYxCwFwWhUk+7sQGctqLsYuL
   2AhBXTxT69YECDZVzbt96OvuInBxPfVfXVHPyAFe4EX+Us34Oh4ag13sF
   y0PS1TJLDRLn4JSrgFg+YyiqoR/fzEHcB+XnS4jSJAHck1A7uO1zi63kw
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="280398523"
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="280398523"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 08:05:18 -0700
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="948187784"
Received: from johannes-mobl1.ger.corp.intel.com (HELO [10.249.46.195]) ([10.249.46.195])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 08:05:11 -0700
Message-ID: <20916c9d-3598-7c40-ee77-1148c3d2e4b1@linux.intel.com>
Date:   Wed, 21 Sep 2022 17:05:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH 1/2] ASoC: wcd9335: fix order of Slimbus unprepare/disable
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Banajit Goswami <bgoswami@quicinc.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Vinod Koul <vkoul@kernel.org>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20220921145354.1683791-1-krzysztof.kozlowski@linaro.org>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <20220921145354.1683791-1-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/21/22 16:53, Krzysztof Kozlowski wrote:
> Slimbus streams are first prepared and then enabled, so the cleanup path
> should reverse it.  The unprepare sets stream->num_ports to 0 and frees
> the stream->ports.  Calling disable after unprepare was not really
> effective (channels was not deactivated) and could lead to further
> issues due to making transfers on unprepared stream.
> 
> Fixes: 20aedafdf492 ("ASoC: wcd9335: add support to wcd9335 codec")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  sound/soc/codecs/wcd9335.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
> index 06c6adbe5920..d2548fdf9ae5 100644
> --- a/sound/soc/codecs/wcd9335.c
> +++ b/sound/soc/codecs/wcd9335.c
> @@ -1972,8 +1972,8 @@ static int wcd9335_trigger(struct snd_pcm_substream *substream, int cmd,
>  	case SNDRV_PCM_TRIGGER_STOP:
>  	case SNDRV_PCM_TRIGGER_SUSPEND:
>  	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
> -		slim_stream_unprepare(dai_data->sruntime);
>  		slim_stream_disable(dai_data->sruntime);
> +		slim_stream_unprepare(dai_data->sruntime);

This looks logical but different from what the kernel doc says:

/**
 * slim_stream_disable() - Disable a SLIMbus Stream
 *
 * @stream: instance of slim stream runtime to disable
 *
 * This API will disable all the ports and channels associated with
 * SLIMbus stream
 *
 * Return: zero on success and error code on failure. From ASoC DPCM
framework,
 * this state is linked to trigger() pause operation.
 */

/**
 * slim_stream_unprepare() - Un-prepare a SLIMbus Stream
 *
 * @stream: instance of slim stream runtime to unprepare
 *
 * This API will un allocate all the ports and channels associated with
 * SLIMbus stream
 *
 * Return: zero on success and error code on failure. From ASoC DPCM
framework,
 * this state is linked to trigger() stop operation.
 */

I would bet the documentation is incorrect?

>  		break;
>  	default:
>  		break;
