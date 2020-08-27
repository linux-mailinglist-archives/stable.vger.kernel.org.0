Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80EA725410B
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 10:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgH0IkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 04:40:18 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18913 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbgH0IkR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 04:40:17 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4771620002>; Thu, 27 Aug 2020 01:40:02 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 27 Aug 2020 01:40:16 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 27 Aug 2020 01:40:16 -0700
Received: from [10.26.74.41] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 27 Aug
 2020 08:40:09 +0000
Subject: Re: [PATCH v6 7/7] sdhci: tegra: Add missing TMCLK for data timeout
To:     Sowjanya Komatineni <skomatineni@nvidia.com>,
        <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <thierry.reding@gmail.com>, <robh+dt@kernel.org>
CC:     <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <1598500201-5987-1-git-send-email-skomatineni@nvidia.com>
 <1598500201-5987-8-git-send-email-skomatineni@nvidia.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <93d0188b-c833-33b4-211e-b9293c4f3a1c@nvidia.com>
Date:   Thu, 27 Aug 2020 09:40:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1598500201-5987-8-git-send-email-skomatineni@nvidia.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598517603; bh=Cfgu8bFdKBU1xwcQ7fpneIgTNYdgfKDPIYOIKIHdRqc=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=FqZN8ZX+cKvVAc31FD4WrRwXU1jo3WJ0d4pKcaYfPxaNfaFUH+kF+B3mHTpckcYXy
         aTdSjqUuIC/mVHcc/lZw0f8A4dziZV2z/W7t+Rzp7R8Ip4/YGx1A3dWU4WMZ358TrU
         IgVVIj5LF8WpA7WE5ALDUVPJw4Os8rpMtZKY7eitIlJU/Rk4Df3P8Yw9MXD9OgRvHV
         kzI5tSMObTfSCcuYoAXOSuFGfohfVm/4whVw7AHqUfOwxNRZgx/y1D6tBzuxCrjJq4
         LscMowGGg5X3W2p5j11QvCuxxg9SBTIwqv10bcmsq0Z/StP//yma3wBUsiPSb+aCf/
         KsOClBoB8vgcg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 27/08/2020 04:50, Sowjanya Komatineni wrote:
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
> So, this patch adds quirk NVQUIRK_HAS_TMCLK for SoC having separate
> timeout clock and keeps TMCLK enabled all the time.
> 
> Fixes: b5a84ecf025a ("mmc: tegra: Add Tegra210 support")
> Cc: stable <stable@vger.kernel.org> # 5.4
> Tested-by: Jon Hunter <jonathanh@nvidia.com>
> Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
> ---
>  drivers/mmc/host/sdhci-tegra.c | 90 ++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 82 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
> index 31ed321..f69ca8d 100644
> --- a/drivers/mmc/host/sdhci-tegra.c
> +++ b/drivers/mmc/host/sdhci-tegra.c
> @@ -13,6 +13,7 @@
>  #include <linux/clk.h>
>  #include <linux/io.h>
>  #include <linux/of.h>
> +#include <linux/of_clk.h>
>  #include <linux/of_device.h>
>  #include <linux/pinctrl/consumer.h>
>  #include <linux/regulator/consumer.h>
> @@ -110,6 +111,12 @@
>  #define NVQUIRK_DIS_CARD_CLK_CONFIG_TAP			BIT(8)
>  #define NVQUIRK_CQHCI_DCMD_R1B_CMD_TIMING		BIT(9)
>  
> +/*
> + * NVQUIRK_HAS_TMCLK is for SoC's having separate timeout clock for Tegra
> + * SDMMC hardware data timeout.
> + */
> +#define NVQUIRK_HAS_TMCLK				BIT(10)
> +
>  /* SDMMC CQE Base Address for Tegra Host Ver 4.1 and Higher */
>  #define SDHCI_TEGRA_CQE_BASE_ADDR			0xF000
>  
> @@ -140,6 +147,7 @@ struct sdhci_tegra_autocal_offsets {
>  struct sdhci_tegra {
>  	const struct sdhci_tegra_soc_data *soc_data;
>  	struct gpio_desc *power_gpio;
> +	struct clk *tmclk;
>  	bool ddr_signaling;
>  	bool pad_calib_required;
>  	bool pad_control_available;
> @@ -1433,7 +1441,8 @@ static const struct sdhci_tegra_soc_data soc_data_tegra210 = {
>  		    NVQUIRK_HAS_PADCALIB |
>  		    NVQUIRK_DIS_CARD_CLK_CONFIG_TAP |
>  		    NVQUIRK_ENABLE_SDR50 |
> -		    NVQUIRK_ENABLE_SDR104,
> +		    NVQUIRK_ENABLE_SDR104 |
> +		    NVQUIRK_HAS_TMCLK,
>  	.min_tap_delay = 106,
>  	.max_tap_delay = 185,
>  };
> @@ -1471,6 +1480,7 @@ static const struct sdhci_tegra_soc_data soc_data_tegra186 = {
>  		    NVQUIRK_DIS_CARD_CLK_CONFIG_TAP |
>  		    NVQUIRK_ENABLE_SDR50 |
>  		    NVQUIRK_ENABLE_SDR104 |
> +		    NVQUIRK_HAS_TMCLK |
>  		    NVQUIRK_CQHCI_DCMD_R1B_CMD_TIMING,
>  	.min_tap_delay = 84,
>  	.max_tap_delay = 136,
> @@ -1483,7 +1493,8 @@ static const struct sdhci_tegra_soc_data soc_data_tegra194 = {
>  		    NVQUIRK_HAS_PADCALIB |
>  		    NVQUIRK_DIS_CARD_CLK_CONFIG_TAP |
>  		    NVQUIRK_ENABLE_SDR50 |
> -		    NVQUIRK_ENABLE_SDR104,
> +		    NVQUIRK_ENABLE_SDR104 |
> +		    NVQUIRK_HAS_TMCLK,
>  	.min_tap_delay = 96,
>  	.max_tap_delay = 139,
>  };
> @@ -1611,15 +1622,76 @@ static int sdhci_tegra_probe(struct platform_device *pdev)
>  		goto err_power_req;
>  	}
>  
> -	clk = devm_clk_get(mmc_dev(host->mmc), NULL);
> -	if (IS_ERR(clk)) {
> -		rc = PTR_ERR(clk);
> +	/*
> +	 * Tegra210 and later has separate SDMMC_LEGACY_TM clock used for
> +	 * hardware data timeout clock and SW can choose TMCLK or SDCLK for
> +	 * hardware data timeout through the bit USE_TMCLK_FOR_DATA_TIMEOUT
> +	 * of the register SDHCI_TEGRA_VENDOR_SYS_SW_CTRL.
> +	 *
> +	 * USE_TMCLK_FOR_DATA_TIMEOUT bit default is set to 1 and SDMMC uses
> +	 * 12Mhz TMCLK which is advertised in host capability register.
> +	 * With TMCLK of 12Mhz provides maximum data timeout period that can
> +	 * be achieved is 11s better than using SDCLK for data timeout.
> +	 *
> +	 * So, TMCLK is set to 12Mhz and kept enabled all the time on SoC's
> +	 * supporting separate TMCLK.
> +	 *
> +	 * Old device tree has single sdhci clock. So with addition of TMCLK,
> +	 * retrieving sdhci clock by "sdhci" clock name based on number of
> +	 * clocks in sdhci device node.
> +	 */
> +
> +	if (of_clk_get_parent_count(pdev->dev.of_node) == 1) {
> +		if (soc_data->nvquirks & NVQUIRK_HAS_TMCLK)
> +			dev_warn(&pdev->dev,
> +				 "missing tmclk in the device tree\n");
> +
> +		clk = devm_clk_get(&pdev->dev, NULL);
> +		if (IS_ERR(clk)) {
> +			rc = PTR_ERR(clk);
>  
> -		if (rc != -EPROBE_DEFER)
> -			dev_err(&pdev->dev, "failed to get clock: %d\n", rc);
> +			if (rc != -EPROBE_DEFER)
> +				dev_err(&pdev->dev,
> +					"failed to get sdhci clock: %d\n", rc);
>  
> -		goto err_clk_get;
> +			goto err_power_req;
> +		}
> +	} else {
> +		if (soc_data->nvquirks & NVQUIRK_HAS_TMCLK) {


I think that I would do the inverse of this ...

   } else {
        if (!(soc_data->nvquirks & NVQUIRK_HAS_TMCLK)) {
                dev_err(&pdev->dev, "Device has unexpected clocks!\n");
                rc = -EINVAL;
                goto_power_req;
        }

        clk = devm_clk_get(&pdev->dev, "tmclk");
        ...

If the device does not have a single clock, then we expect it to support
the tmclk. If this is not the case, then this is a bug.

Cheers
Jon

-- 
nvpublic
