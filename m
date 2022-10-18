Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFAB0603093
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 18:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbiJRQNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 12:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiJRQNo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 12:13:44 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70779E0F4;
        Tue, 18 Oct 2022 09:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666109623; x=1697645623;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ezRUfgf//9t3TKkvzi/6tZ+wan0th4HSbw4jvbk3WPM=;
  b=U3cbkxf6W1vJRh3JUS6JqezjIXoKPdAPhWMr6CKFYTgJCsflVWG9NEyl
   pGY/6YWf3H2k3nWw+a9d1sLrAzdGMgXLhs4vUZfpzxRfpKh+8kLixG8V/
   VWvveIUNc761YIAc0A7eRZP8/a92w95o9hWEn0iNkWfJi0NHFZhtM6UUF
   yMvabtJ6cOdUWmvJdYPrkwYOIvahMu6QyU0DiPCL1X6sJTd/be0dGhphJ
   U1RRSGgVFVw++i+javf3x3MJGLC0H1KCZno3NuKINWc5vvhkYd9HVxO/l
   p0kXCtG1bDkoGtjhTT1NXxM3FoP+OW6/uZZWzMf0yeOVTrK4QSrxMaHCa
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="304892739"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="304892739"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 09:13:40 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="803822798"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="803822798"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.51.208])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 09:13:33 -0700
Message-ID: <e7816e4a-8558-0de0-e25f-d10abd0ef1c3@intel.com>
Date:   Tue, 18 Oct 2022 19:13:28 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.0
Subject: Re: [PATCH 1/5] mmc: sdhci-of-arasan: Fix SDHCI_RESET_ALL for CQHCI
Content-Language: en-US
To:     Brian Norris <briannorris@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Shawn Lin <shawn.lin@rock-chips.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Haibo Chen <haibo.chen@nxp.com>,
        Al Cooper <alcooperx@gmail.com>, linux-mmc@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        linux-arm-kernel@lists.infradead.org,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>, stable@vger.kernel.org
References: <20221018035724.2061127-1-briannorris@chromium.org>
 <20221017205610.1.I29f6a2189e84e35ad89c1833793dca9e36c64297@changeid>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20221017205610.1.I29f6a2189e84e35ad89c1833793dca9e36c64297@changeid>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/10/22 06:57, Brian Norris wrote:
> SDHCI_RESET_ALL resets will reset the hardware CQE state, but we aren't
> tracking that properly in software. When out of sync, we may trigger
> various timeouts.
> 
> It's not typical to perform resets while CQE is enabled, but one
> particular case I hit commonly enough: mmc_suspend() -> mmc_power_off().
> Typically we will eventually deactivate CQE (cqhci_suspend() ->
> cqhci_deactivate()), but that's not guaranteed -- in particular, if
> we perform a partial (e.g., interrupted) system suspend.
> 
> The same bug was already found and fixed for two other drivers, in v5.7
> and v5.9:
> 
> 5cf583f1fb9c mmc: sdhci-msm: Deactivate CQE during SDHC reset
> df57d73276b8 mmc: sdhci-pci: Fix SDHCI_RESET_ALL for CQHCI for Intel GLK-based controllers
> 
> The latter is especially prescient, saying "other drivers using CQHCI
> might benefit from a similar change, if they also have CQHCI reset by
> SDHCI_RESET_ALL."
> 
> So like these other patches, deactivate CQHCI when resetting the
> controller. Also, move around the DT/caps handling, because
> sdhci_setup_host() performs resets before we've initialized CQHCI. This
> is the pattern followed in other SDHCI/CQHCI drivers.

Did you consider just checking host->mmc->cqe_private like
sdhci_cqhci_reset() ?

> 
> Fixes: 84362d79f436 ("mmc: sdhci-of-arasan: Add CQHCI support for arasan,sdhci-5.1")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
> 
>  drivers/mmc/host/sdhci-of-arasan.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-of-arasan.c b/drivers/mmc/host/sdhci-of-arasan.c
> index 3997cad1f793..1988a703781a 100644
> --- a/drivers/mmc/host/sdhci-of-arasan.c
> +++ b/drivers/mmc/host/sdhci-of-arasan.c
> @@ -366,6 +366,10 @@ static void sdhci_arasan_reset(struct sdhci_host *host, u8 mask)
>  	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
>  	struct sdhci_arasan_data *sdhci_arasan = sdhci_pltfm_priv(pltfm_host);
>  
> +	if ((host->mmc->caps2 & MMC_CAP2_CQE) && (mask & SDHCI_RESET_ALL) &&
> +	    sdhci_arasan->has_cqe)
> +		cqhci_deactivate(host->mmc);
> +
>  	sdhci_reset(host, mask);
>  
>  	if (sdhci_arasan->quirks & SDHCI_ARASAN_QUIRK_FORCE_CDTEST) {
> @@ -1521,7 +1525,8 @@ static int sdhci_arasan_register_sdclk(struct sdhci_arasan_data *sdhci_arasan,
>  	return 0;
>  }
>  
> -static int sdhci_arasan_add_host(struct sdhci_arasan_data *sdhci_arasan)
> +static int sdhci_arasan_add_host(struct sdhci_arasan_data *sdhci_arasan,
> +				 struct device_node *np)
>  {
>  	struct sdhci_host *host = sdhci_arasan->host;
>  	struct cqhci_host *cq_host;
> @@ -1549,6 +1554,10 @@ static int sdhci_arasan_add_host(struct sdhci_arasan_data *sdhci_arasan)
>  	if (dma64)
>  		cq_host->caps |= CQHCI_TASK_DESC_SZ_128;
>  
> +	host->mmc->caps2 |= MMC_CAP2_CQE;
> +	if (!of_property_read_bool(np, "disable-cqe-dcmd"))
> +		host->mmc->caps2 |= MMC_CAP2_CQE_DCMD;
> +
>  	ret = cqhci_init(cq_host, host->mmc, dma64);
>  	if (ret)
>  		goto cleanup;
> @@ -1705,13 +1714,9 @@ static int sdhci_arasan_probe(struct platform_device *pdev)
>  		host->mmc_host_ops.start_signal_voltage_switch =
>  					sdhci_arasan_voltage_switch;
>  		sdhci_arasan->has_cqe = true;
> -		host->mmc->caps2 |= MMC_CAP2_CQE;
> -
> -		if (!of_property_read_bool(np, "disable-cqe-dcmd"))
> -			host->mmc->caps2 |= MMC_CAP2_CQE_DCMD;
>  	}
>  
> -	ret = sdhci_arasan_add_host(sdhci_arasan);
> +	ret = sdhci_arasan_add_host(sdhci_arasan, np);
>  	if (ret)
>  		goto err_add_host;
>  

