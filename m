Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE7A254140
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 10:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgH0IyK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 04:54:10 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:3553 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728001AbgH0IyH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 04:54:07 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4774350000>; Thu, 27 Aug 2020 01:52:05 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 27 Aug 2020 01:54:07 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 27 Aug 2020 01:54:07 -0700
Received: from [10.26.74.41] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 27 Aug
 2020 08:54:01 +0000
Subject: Re: [PATCH v6 3/7] dt-bindings: mmc: tegra: Add tmclk for Tegra210
 and later
To:     Sowjanya Komatineni <skomatineni@nvidia.com>,
        <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <thierry.reding@gmail.com>, <robh+dt@kernel.org>
CC:     <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <1598500201-5987-1-git-send-email-skomatineni@nvidia.com>
 <1598500201-5987-4-git-send-email-skomatineni@nvidia.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <46af4970-6a5a-d51e-a93f-31690dfe6ec8@nvidia.com>
Date:   Thu, 27 Aug 2020 09:53:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1598500201-5987-4-git-send-email-skomatineni@nvidia.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598518325; bh=C6Crf15LnfbR0rYCsspSBLWvgIDpcD7/H+1fQJjziBk=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=f7MNXB70JXKKV7eh+wWqv5g6k0XPXmJk+IZpcs/j/jUPI/9rRzfsMCO/fkoR72bNL
         CoCAtkSQiJACST7dmGpn3SfK/k2ng5vxqxJEVfSamkxwNt5QXWRYQbWD04XGoLHkLn
         w6vJziiP0rq88p121df6/iNrPRH3SPKS2s2s5l5VmRq7ogPnTqyTCNg3brFMIu1DLW
         6CplkBy7/Z9VuNq55aRoPxJ0uPiL9dL3NzYFp288plQgyB3uOgp36i+D4axRISXA+m
         yJyalyfWVXylgRGUfs3GO4Ktw1HwqpcnYVIyBSnoH5h9UzuHaz5IP2ELmKEmvDk5e4
         Hjd3EnyaiJHMQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 27/08/2020 04:49, Sowjanya Komatineni wrote:
> Tegra210 and later uses separate SDMMC_LEGACY_TM clock for data
> timeout.
> 
> So, this patch adds "tmclk" to Tegra sdhci clock property in the
> device tree binding.
> 
> Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
> ---
>  .../bindings/mmc/nvidia,tegra20-sdhci.txt          | 32 ++++++++++++++++++++--
>  1 file changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.txt b/Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.txt
> index 2cf3aff..96c0b14 100644
> --- a/Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.txt
> +++ b/Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.txt
> @@ -15,8 +15,15 @@ Required properties:
>    - "nvidia,tegra210-sdhci": for Tegra210
>    - "nvidia,tegra186-sdhci": for Tegra186
>    - "nvidia,tegra194-sdhci": for Tegra194
> -- clocks : Must contain one entry, for the module clock.
> -  See ../clocks/clock-bindings.txt for details.
> +- clocks: For Tegra210, Tegra186 and Tegra194 must contain two entries.
> +	  One for the module clock and one for the timeout clock.
> +	  For all other Tegra devices, must contain a single entry for
> +	  the module clock. See ../clocks/clock-bindings.txt for details.
> +- clock-names: For Tegra210, Tegra186 and Tegra194 must contain the
> +	       strings 'sdhci' and 'tmclk' to represent the module and
> +	       the timeout clocks, respectively.
> +	       For all other Tegra devices must contain the string 'sdhci'
> +	       to represent the module clock.
>  - resets : Must contain an entry for each entry in reset-names.
>    See ../reset/reset.txt for details.
>  - reset-names : Must include the following entries:
> @@ -99,7 +106,7 @@ Optional properties for Tegra210, Tegra186 and Tegra194:
>  
>  Example:
>  sdhci@700b0000 {
> -	compatible = "nvidia,tegra210-sdhci", "nvidia,tegra124-sdhci";
> +	compatible = "nvidia,tegra124-sdhci";
>  	reg = <0x0 0x700b0000 0x0 0x200>;
>  	interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
>  	clocks = <&tegra_car TEGRA210_CLK_SDMMC1>;
> @@ -115,3 +122,22 @@ sdhci@700b0000 {
>  	nvidia,pad-autocal-pull-down-offset-1v8 = <0x7b>;
>  	status = "disabled";
>  };
> +
> +sdhci@700b0000 {
> +	compatible = "nvidia,tegra210-sdhci";
> +	reg = <0x0 0x700b0000 0x0 0x200>;
> +	interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
> +	clocks = <&tegra_car TEGRA210_CLK_SDMMC1>,
> +		 <&tegra_car TEGRA210_CLK_SDMMC_LEGACY>;
> +	clock-names = "sdhci", "tmclk";
> +	resets = <&tegra_car 14>;
> +	reset-names = "sdhci";
> +	pinctrl-names = "sdmmc-3v3", "sdmmc-1v8";
> +	pinctrl-0 = <&sdmmc1_3v3>;
> +	pinctrl-1 = <&sdmmc1_1v8>;
> +	nvidia,pad-autocal-pull-up-offset-3v3 = <0x00>;
> +	nvidia,pad-autocal-pull-down-offset-3v3 = <0x7d>;
> +	nvidia,pad-autocal-pull-up-offset-1v8 = <0x7b>;
> +	nvidia,pad-autocal-pull-down-offset-1v8 = <0x7b>;
> +	status = "disabled";
> +};
> 


Thanks!

Reviewed-by: Jon Hunter <jonathanh@nvidia.com>

Cheers
Jon

-- 
nvpublic
