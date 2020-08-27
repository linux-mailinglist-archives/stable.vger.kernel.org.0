Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F4C254867
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 17:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgH0PG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 11:06:57 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18922 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727850AbgH0PEa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 11:04:30 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f47cb450001>; Thu, 27 Aug 2020 08:03:34 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 27 Aug 2020 08:04:17 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 27 Aug 2020 08:04:17 -0700
Received: from [10.2.174.186] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 27 Aug
 2020 15:04:16 +0000
Subject: Re: [PATCH v6 7/7] sdhci: tegra: Add missing TMCLK for data timeout
To:     Jon Hunter <jonathanh@nvidia.com>, <adrian.hunter@intel.com>,
        <ulf.hansson@linaro.org>, <thierry.reding@gmail.com>,
        <robh+dt@kernel.org>
CC:     <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <1598500201-5987-1-git-send-email-skomatineni@nvidia.com>
 <1598500201-5987-8-git-send-email-skomatineni@nvidia.com>
 <93d0188b-c833-33b4-211e-b9293c4f3a1c@nvidia.com>
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
Message-ID: <3deac67c-bb1e-ef23-7dcc-8d4024203ab1@nvidia.com>
Date:   Thu, 27 Aug 2020 08:03:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <93d0188b-c833-33b4-211e-b9293c4f3a1c@nvidia.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598540614; bh=DoTOabdYopsUxy9pThG/x9MurfIlwI7HTUiu8cCQwwY=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Transfer-Encoding:
         Content-Language;
        b=XlQaLVnA320/cdF58QoaOOm3uyXjuQO8XG4qcBlae1/h4o66sfrpaoFVAataUX953
         l91yA0tOtieTaZ6/6JFb6XYXuuNpgoyBAXXdVehSz4SF9BUVzyPkI2VZuqPwKNpErv
         Zds4wZ03jx103ddD78yf/Y2w7V593avKzNqZY2j7aJE6jalT49CE07sESPbSoSum34
         gQ5DxapOF4nrLKXwR1wPtVu1h0AzaKHGk1cc9F40VZObRqrmxM9sFLtSpHhO1g98OS
         Cpp+xYMD9DKBph8EEvT+VTLcjDiZ3p+NvRaw74YlyrMO+fE6WF4zbUnovGv4fiE8+H
         N4kDqpLheY/Gw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 8/27/20 1:40 AM, Jon Hunter wrote:
> On 27/08/2020 04:50, Sowjanya Komatineni wrote:
>> commit b5a84ecf025a ("mmc: tegra: Add Tegra210 support")
>>
>> Tegra210 and later has a separate sdmmc_legacy_tm (TMCLK) used by Tegra
>> SDMMC hawdware for data timeout to achive better timeout than using
>> SDCLK and using TMCLK is recommended.
>>
>> USE_TMCLK_FOR_DATA_TIMEOUT bit in Tegra SDMMC register
>> SDHCI_TEGRA_VENDOR_SYS_SW_CTRL can be used to choose either TMCLK or
>> SDCLK for data timeout.
>>
>> Default USE_TMCLK_FOR_DATA_TIMEOUT bit is set to 1 and TMCLK is used
>> for data timeout by Tegra SDMMC hardware and having TMCLK not enabled
>> is not recommended.
>>
>> So, this patch adds quirk NVQUIRK_HAS_TMCLK for SoC having separate
>> timeout clock and keeps TMCLK enabled all the time.
>>
>> Fixes: b5a84ecf025a ("mmc: tegra: Add Tegra210 support")
>> Cc: stable <stable@vger.kernel.org> # 5.4
>> Tested-by: Jon Hunter <jonathanh@nvidia.com>
>> Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
>> Acked-by: Adrian Hunter <adrian.hunter@intel.com>
>> Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
>> ---
>>   drivers/mmc/host/sdhci-tegra.c | 90 ++++++++++++++++++++++++++++++++++++++----
>>   1 file changed, 82 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
>> index 31ed321..f69ca8d 100644
>> --- a/drivers/mmc/host/sdhci-tegra.c
>> +++ b/drivers/mmc/host/sdhci-tegra.c
>> @@ -13,6 +13,7 @@
>>   #include <linux/clk.h>
>>   #include <linux/io.h>
>>   #include <linux/of.h>
>> +#include <linux/of_clk.h>
>>   #include <linux/of_device.h>
>>   #include <linux/pinctrl/consumer.h>
>>   #include <linux/regulator/consumer.h>
>> @@ -110,6 +111,12 @@
>>   #define NVQUIRK_DIS_CARD_CLK_CONFIG_TAP			BIT(8)
>>   #define NVQUIRK_CQHCI_DCMD_R1B_CMD_TIMING		BIT(9)
>>   
>> +/*
>> + * NVQUIRK_HAS_TMCLK is for SoC's having separate timeout clock for Tegra
>> + * SDMMC hardware data timeout.
>> + */
>> +#define NVQUIRK_HAS_TMCLK				BIT(10)
>> +
>>   /* SDMMC CQE Base Address for Tegra Host Ver 4.1 and Higher */
>>   #define SDHCI_TEGRA_CQE_BASE_ADDR			0xF000
>>   
>> @@ -140,6 +147,7 @@ struct sdhci_tegra_autocal_offsets {
>>   struct sdhci_tegra {
>>   	const struct sdhci_tegra_soc_data *soc_data;
>>   	struct gpio_desc *power_gpio;
>> +	struct clk *tmclk;
>>   	bool ddr_signaling;
>>   	bool pad_calib_required;
>>   	bool pad_control_available;
>> @@ -1433,7 +1441,8 @@ static const struct sdhci_tegra_soc_data soc_data_tegra210 = {
>>   		    NVQUIRK_HAS_PADCALIB |
>>   		    NVQUIRK_DIS_CARD_CLK_CONFIG_TAP |
>>   		    NVQUIRK_ENABLE_SDR50 |
>> -		    NVQUIRK_ENABLE_SDR104,
>> +		    NVQUIRK_ENABLE_SDR104 |
>> +		    NVQUIRK_HAS_TMCLK,
>>   	.min_tap_delay = 106,
>>   	.max_tap_delay = 185,
>>   };
>> @@ -1471,6 +1480,7 @@ static const struct sdhci_tegra_soc_data soc_data_tegra186 = {
>>   		    NVQUIRK_DIS_CARD_CLK_CONFIG_TAP |
>>   		    NVQUIRK_ENABLE_SDR50 |
>>   		    NVQUIRK_ENABLE_SDR104 |
>> +		    NVQUIRK_HAS_TMCLK |
>>   		    NVQUIRK_CQHCI_DCMD_R1B_CMD_TIMING,
>>   	.min_tap_delay = 84,
>>   	.max_tap_delay = 136,
>> @@ -1483,7 +1493,8 @@ static const struct sdhci_tegra_soc_data soc_data_tegra194 = {
>>   		    NVQUIRK_HAS_PADCALIB |
>>   		    NVQUIRK_DIS_CARD_CLK_CONFIG_TAP |
>>   		    NVQUIRK_ENABLE_SDR50 |
>> -		    NVQUIRK_ENABLE_SDR104,
>> +		    NVQUIRK_ENABLE_SDR104 |
>> +		    NVQUIRK_HAS_TMCLK,
>>   	.min_tap_delay = 96,
>>   	.max_tap_delay = 139,
>>   };
>> @@ -1611,15 +1622,76 @@ static int sdhci_tegra_probe(struct platform_device *pdev)
>>   		goto err_power_req;
>>   	}
>>   
>> -	clk = devm_clk_get(mmc_dev(host->mmc), NULL);
>> -	if (IS_ERR(clk)) {
>> -		rc = PTR_ERR(clk);
>> +	/*
>> +	 * Tegra210 and later has separate SDMMC_LEGACY_TM clock used for
>> +	 * hardware data timeout clock and SW can choose TMCLK or SDCLK for
>> +	 * hardware data timeout through the bit USE_TMCLK_FOR_DATA_TIMEOUT
>> +	 * of the register SDHCI_TEGRA_VENDOR_SYS_SW_CTRL.
>> +	 *
>> +	 * USE_TMCLK_FOR_DATA_TIMEOUT bit default is set to 1 and SDMMC uses
>> +	 * 12Mhz TMCLK which is advertised in host capability register.
>> +	 * With TMCLK of 12Mhz provides maximum data timeout period that can
>> +	 * be achieved is 11s better than using SDCLK for data timeout.
>> +	 *
>> +	 * So, TMCLK is set to 12Mhz and kept enabled all the time on SoC's
>> +	 * supporting separate TMCLK.
>> +	 *
>> +	 * Old device tree has single sdhci clock. So with addition of TMCLK,
>> +	 * retrieving sdhci clock by "sdhci" clock name based on number of
>> +	 * clocks in sdhci device node.
>> +	 */
>> +
>> +	if (of_clk_get_parent_count(pdev->dev.of_node) == 1) {
>> +		if (soc_data->nvquirks & NVQUIRK_HAS_TMCLK)
>> +			dev_warn(&pdev->dev,
>> +				 "missing tmclk in the device tree\n");
>> +
>> +		clk = devm_clk_get(&pdev->dev, NULL);
>> +		if (IS_ERR(clk)) {
>> +			rc = PTR_ERR(clk);
>>   
>> -		if (rc != -EPROBE_DEFER)
>> -			dev_err(&pdev->dev, "failed to get clock: %d\n", rc);
>> +			if (rc != -EPROBE_DEFER)
>> +				dev_err(&pdev->dev,
>> +					"failed to get sdhci clock: %d\n", rc);
>>   
>> -		goto err_clk_get;
>> +			goto err_power_req;
>> +		}
>> +	} else {
>> +		if (soc_data->nvquirks & NVQUIRK_HAS_TMCLK) {
>
> I think that I would do the inverse of this ...
>
>     } else {
>          if (!(soc_data->nvquirks & NVQUIRK_HAS_TMCLK)) {
>                  dev_err(&pdev->dev, "Device has unexpected clocks!\n");
>                  rc = -EINVAL;
>                  goto_power_req;
>          }
>
>          clk = devm_clk_get(&pdev->dev, "tmclk");
>          ...
>
> If the device does not have a single clock, then we expect it to support
> the tmclk. If this is not the case, then this is a bug.
>
> Cheers
> Jon

I don't see other drivers validating for unexpected device tree entries.

Also only for SoC with quirk HAS_TMCLK, we are retrieving TMCLK with 
clock name and enabling it.

So for other SoC even if device tree has additional clock entry other 
than sdhci driver don't use it and also dt-binding do not have any tmclk 
entry for other SoC. So why would this be a bug?

Can you please correct if I misunderstood you comment?

Thanks

Sowjanya



