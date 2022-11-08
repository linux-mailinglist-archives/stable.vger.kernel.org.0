Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4230E620B56
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 09:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbiKHIku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 03:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233295AbiKHIks (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 03:40:48 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5822DFE;
        Tue,  8 Nov 2022 00:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667896847; x=1699432847;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XiCgmwfFwaPwY+8uHUHAzxPyz0OpKzFmJlOm58spYyM=;
  b=a5V2thwPV5mWV1jGKMu7vsf+f2+zsG+pFF6rIb0wnOKzHPfxm4OE9zdE
   gN7b6P6TxwDcFuv2zaKVi5xOUFDRFLRBHakYrgBnHHu+A3IfBGXnqlWXm
   rriqn7xT+tgVRm5hMpvqtLRk2hBr/+FMqosjEV9erz2Oi0uBzpid/lt7C
   uwkciJEeP1cWhQ+meeg0l7FPvJ6pVqKEkGRofYQcvQfnecM8/1e8C9yJn
   YJGHgJ5dAuLna9geVNTrB3MmShT0T/VXWpG7FnZwdgyv41Dh/s7LLByMH
   ZelDgHLREo9hIckmcWJAuSTjXUqeUEdt4NU5k8ihduuYcVb9yjhSaU52M
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="396937644"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="396937644"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 00:40:40 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="699840954"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="699840954"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.56.164])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 00:40:37 -0800
Message-ID: <8dc73d23-f063-4fae-1849-816c48f3a4da@intel.com>
Date:   Tue, 8 Nov 2022 10:40:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.2
Subject: Re: [PATCH] mmc: sdhci-esdhc-imx: use the correct host caps for
 MMC_CAP_8_BIT_DATA
Content-Language: en-US
To:     haibo.chen@nxp.com, ulf.hansson@linaro.org,
        linux-mmc@vger.kernel.org
Cc:     linux-imx@nxp.com, stable@vger.kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de, kernel@pengutronix.de, festevam@gmail.com
References: <1667893503-20583-1-git-send-email-haibo.chen@nxp.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <1667893503-20583-1-git-send-email-haibo.chen@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/11/22 09:45, haibo.chen@nxp.com wrote:
> From: Haibo Chen <haibo.chen@nxp.com>
> 
> MMC_CAP_8_BIT_DATA belongs to struct mmc_host, not struct sdhci_host.
> So correct it here.
> 
> Fixes: 1ed5c3b22fc7 ("mmc: sdhci-esdhc-imx: Propagate ESDHC_FLAG_HS400* only on 8bit bus")
> Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
> Cc: stable@vger.kernel.org

Acked-by: Adrian Hunter <adrian.hunter@intel.com>


> ---
>  drivers/mmc/host/sdhci-esdhc-imx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
> index a54f1806dd57..004c6352d954 100644
> --- a/drivers/mmc/host/sdhci-esdhc-imx.c
> +++ b/drivers/mmc/host/sdhci-esdhc-imx.c
> @@ -1679,14 +1679,14 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
>  	if (imx_data->socdata->flags & ESDHC_FLAG_ERR004536)
>  		host->quirks |= SDHCI_QUIRK_BROKEN_ADMA;
>  
> -	if (host->caps & MMC_CAP_8_BIT_DATA &&
> +	if (host->mmc->caps & MMC_CAP_8_BIT_DATA &&
>  	    imx_data->socdata->flags & ESDHC_FLAG_HS400)
>  		host->mmc->caps2 |= MMC_CAP2_HS400;
>  
>  	if (imx_data->socdata->flags & ESDHC_FLAG_BROKEN_AUTO_CMD23)
>  		host->quirks2 |= SDHCI_QUIRK2_ACMD23_BROKEN;
>  
> -	if (host->caps & MMC_CAP_8_BIT_DATA &&
> +	if (host->mmc->caps & MMC_CAP_8_BIT_DATA &&
>  	    imx_data->socdata->flags & ESDHC_FLAG_HS400_ES) {
>  		host->mmc->caps2 |= MMC_CAP2_HS400_ES;
>  		host->mmc_host_ops.hs400_enhanced_strobe =

