Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95FC425132E
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 09:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729471AbgHYH3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 03:29:05 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:16435 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729194AbgHYH3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 03:29:04 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f44bd480002>; Tue, 25 Aug 2020 00:27:04 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 25 Aug 2020 00:29:03 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 25 Aug 2020 00:29:03 -0700
Received: from [10.26.74.41] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 25 Aug
 2020 07:28:56 +0000
Subject: Re: [PATCH v4 7/7] sdhci: tegra: Add missing TMCLK for data timeout
To:     Sowjanya Komatineni <skomatineni@nvidia.com>,
        <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <thierry.reding@gmail.com>, <robh+dt@kernel.org>
CC:     <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <1598296557-32020-1-git-send-email-skomatineni@nvidia.com>
 <1598296557-32020-8-git-send-email-skomatineni@nvidia.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <a8ea7d0e-ed1d-165a-bba7-2a39c31cc107@nvidia.com>
Date:   Tue, 25 Aug 2020 08:28:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1598296557-32020-8-git-send-email-skomatineni@nvidia.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598340424; bh=R3hLvCd5YUZLhhnoklm4RrizfdS9HAJpYHSPgk5QwRc=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=YVimBWLTRrbrR+FkD2wyHFGJzWM82x9PGLcjxAyHWw/Z5zCgc2BKGnQYsvhaBsX34
         GlEmTtT0sVhAM+a70ut0CbPpN9swBjfOLru9INzrN9Z2wTbqOQqWYyHze8SLVOONEL
         XjI+Juwc1EiGSxo+5VuQQyuhCBHqIG6ATKQkca54RIHuMUdx5jfNgytCpVXt5KmFHD
         GoTfedudxaB8zEQ1yiOrBMg6x5E1pu/J31sZthQNAuys7McMDRzS9yigsvbB3czgdJ
         gIo54HQ6AM32cMzqw8wH6q0CyBWEMsLBNAJ6uzbpBOrrwwXlDONclUzCQ4ffpDgxYX
         AdbggAbwKFkHg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 24/08/2020 20:15, Sowjanya Komatineni wrote:
> commit b5a84ecf025a ("mmc: tegra: Add Tegra210 support")
> 
> Tegra210 and later has a separate sdmmc_legacy_tm (TMCLK) used by Tegra
> SDMMC hawdware for data timeout to achive better timeout than using
> SDCLK and using TMCLK is recommended.
> 
> USE_TMCLK_FOR_DATA_TIMEOUT bit in Tegra SDMMC register
> SDHCI_TEGRA_VENDOR_SYS_SW_CTRL can be used to choose either TMCLK or
> SDCLK for data timeout.
> 
> Default USE_TMCLK_FOR_DATA_TIMEOUT bit is set to 1 and TMCLK is used
> for data timeout by Tegra SDMMC hardware and having TMCLK not enabled
> is not recommended.
> 
> So, this patch fixes it.
> 
> Fixes: b5a84ecf025a ("mmc: tegra: Add Tegra210 support")
> Cc: stable <stable@vger.kernel.org> # 5.4
> Tested-by: Jon Hunter <jonathanh@nvidia.com>
> Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
> ---
>  drivers/mmc/host/sdhci-tegra.c | 41 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
> 
> diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
> index 31ed321..c0b9405 100644
> --- a/drivers/mmc/host/sdhci-tegra.c
> +++ b/drivers/mmc/host/sdhci-tegra.c
> @@ -140,6 +140,7 @@ struct sdhci_tegra_autocal_offsets {
>  struct sdhci_tegra {
>  	const struct sdhci_tegra_soc_data *soc_data;
>  	struct gpio_desc *power_gpio;
> +	struct clk *tmclk;
>  	bool ddr_signaling;
>  	bool pad_calib_required;
>  	bool pad_control_available;
> @@ -1611,6 +1612,44 @@ static int sdhci_tegra_probe(struct platform_device *pdev)
>  		goto err_power_req;
>  	}
>  
> +	/*
> +	 * Tegra210 has a separate SDMMC_LEGACY_TM clock used for host
> +	 * timeout clock and SW can choose TMCLK or SDCLK for hardware
> +	 * data timeout through the bit USE_TMCLK_FOR_DATA_TIMEOUT of
> +	 * the register SDHCI_TEGRA_VENDOR_SYS_SW_CTRL.
> +	 *
> +	 * USE_TMCLK_FOR_DATA_TIMEOUT bit default is set to 1 and SDMMC uses
> +	 * 12Mhz TMCLK which is advertised in host capability register.
> +	 * With TMCLK of 12Mhz provides maximum data timeout period that can
> +	 * be achieved is 11s better than using SDCLK for data timeout.
> +	 *
> +	 * So, TMCLK is set to 12Mhz and kept enabled all the time on SoC's
> +	 * supporting SDR104 mode and when not using SDCLK for data timeout.
> +	 */
> +
> +	if ((soc_data->nvquirks & NVQUIRK_ENABLE_SDR104) &&
> +	    !(soc_data->pdata->quirks & SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK)) {
> +		clk = devm_clk_get(&pdev->dev, "tmclk");
> +		if (IS_ERR(clk)) {
> +			rc = PTR_ERR(clk);
> +			if (rc == -EPROBE_DEFER)
> +				goto err_power_req;
> +
> +			dev_warn(&pdev->dev, "failed to get tmclk: %d\n", rc);
> +			clk = NULL;
> +		}
> +
> +		clk_set_rate(clk, 12000000);
> +		rc = clk_prepare_enable(clk);
> +		if (rc) {
> +			dev_err(&pdev->dev,
> +				"failed to enable tmclk: %d\n", rc);
> +			goto err_power_req;
> +		}
> +
> +		tegra_host->tmclk = clk;
> +	}
> +
>  	clk = devm_clk_get(mmc_dev(host->mmc), NULL);


One thing that I just thought of is that now we may have two clocks,
shouldn't we use the name, 'sdhci', for requesting the above clock as well?

Unfortunately, the name 'sdhci' has not been populated for all Tegra
devices until recently and so we may need to check if there are one of
two clocks populated. If there is only one, then maybe we fall back to
the above.

Cheers
Jon

-- 
nvpublic
