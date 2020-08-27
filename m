Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90BB32549E5
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 17:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgH0Pvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 11:51:55 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:19759 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgH0Pvx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 11:51:53 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f47d68a0001>; Thu, 27 Aug 2020 08:51:38 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 27 Aug 2020 08:51:52 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 27 Aug 2020 08:51:52 -0700
Received: from [10.26.74.41] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 27 Aug
 2020 15:51:49 +0000
Subject: Re: [PATCH v6 7/7] sdhci: tegra: Add missing TMCLK for data timeout
To:     Sowjanya Komatineni <skomatineni@nvidia.com>,
        <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <thierry.reding@gmail.com>, <robh+dt@kernel.org>
CC:     <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <1598500201-5987-1-git-send-email-skomatineni@nvidia.com>
 <1598500201-5987-8-git-send-email-skomatineni@nvidia.com>
 <93d0188b-c833-33b4-211e-b9293c4f3a1c@nvidia.com>
 <3deac67c-bb1e-ef23-7dcc-8d4024203ab1@nvidia.com>
 <5ec4d869-f134-6e6d-6496-2410f271b196@nvidia.com>
 <2d5f8c57-47be-4874-b9dd-98e9ccebd4c0@nvidia.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <03387289-1442-a7d8-fc4e-6d3176d2234a@nvidia.com>
Date:   Thu, 27 Aug 2020 16:51:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2d5f8c57-47be-4874-b9dd-98e9ccebd4c0@nvidia.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598543498; bh=VLDBFnteH9Zw07t/tJUf5/VUBe6j0BRaRnUk+k9N3A8=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=iO3w0prRAprdRNIqbOlFvMu8ofZOEHlLUMjgS/ZCS8uSrGXuRCQPqhQD1HKHLsSPZ
         mjZmgSG8TQtsfcg/qgIJVSKluBW91ciGAdR3zFiCpUfsIbOaZiSW3gtyKc0yw8LkPv
         fel520AX58XO059uLHHScZcmYCozMm0DMtkHxZjTDb2GfqWwDLoCz9jG339gRB/WKB
         82DYQCdD+YoE6y90nHOnBk8S2CgeYCntDd7BGzDWc5L5TyvtXo7LPQTGQqjnxnFiwR
         lG1zxgj7EIjoh8NI8h504TILP++yVmMXNVjOxlToYyQzytZJqEhllOR5n5F1BZH0fg
         hWFyselN7RXYA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 27/08/2020 16:43, Sowjanya Komatineni wrote:
>=20
> On 8/27/20 8:14 AM, Jon Hunter wrote:
>> On 27/08/2020 16:03, Sowjanya Komatineni wrote:
>>> On 8/27/20 1:40 AM, Jon Hunter wrote:
>>>> On 27/08/2020 04:50, Sowjanya Komatineni wrote:
>>>>> commit b5a84ecf025a ("mmc: tegra: Add Tegra210 support")
>>>>>
>>>>> Tegra210 and later has a separate sdmmc_legacy_tm (TMCLK) used by
>>>>> Tegra
>>>>> SDMMC hawdware for data timeout to achive better timeout than using
>>>>> SDCLK and using TMCLK is recommended.
>>>>>
>>>>> USE_TMCLK_FOR_DATA_TIMEOUT bit in Tegra SDMMC register
>>>>> SDHCI_TEGRA_VENDOR_SYS_SW_CTRL can be used to choose either TMCLK or
>>>>> SDCLK for data timeout.
>>>>>
>>>>> Default USE_TMCLK_FOR_DATA_TIMEOUT bit is set to 1 and TMCLK is used
>>>>> for data timeout by Tegra SDMMC hardware and having TMCLK not enabled
>>>>> is not recommended.
>>>>>
>>>>> So, this patch adds quirk NVQUIRK_HAS_TMCLK for SoC having separate
>>>>> timeout clock and keeps TMCLK enabled all the time.
>>>>>
>>>>> Fixes: b5a84ecf025a ("mmc: tegra: Add Tegra210 support")
>>>>> Cc: stable <stable@vger.kernel.org> # 5.4
>>>>> Tested-by: Jon Hunter <jonathanh@nvidia.com>
>>>>> Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
>>>>> Acked-by: Adrian Hunter <adrian.hunter@intel.com>
>>>>> Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
>>>>> ---
>>>>> =C2=A0=C2=A0 drivers/mmc/host/sdhci-tegra.c | 90
>>>>> ++++++++++++++++++++++++++++++++++++++----
>>>>> =C2=A0=C2=A0 1 file changed, 82 insertions(+), 8 deletions(-)
>>>>>
>>>>> diff --git a/drivers/mmc/host/sdhci-tegra.c
>>>>> b/drivers/mmc/host/sdhci-tegra.c
>>>>> index 31ed321..f69ca8d 100644
>>>>> --- a/drivers/mmc/host/sdhci-tegra.c
>>>>> +++ b/drivers/mmc/host/sdhci-tegra.c
>>>>> @@ -13,6 +13,7 @@
>>>>> =C2=A0=C2=A0 #include <linux/clk.h>
>>>>> =C2=A0=C2=A0 #include <linux/io.h>
>>>>> =C2=A0=C2=A0 #include <linux/of.h>
>>>>> +#include <linux/of_clk.h>
>>>>> =C2=A0=C2=A0 #include <linux/of_device.h>
>>>>> =C2=A0=C2=A0 #include <linux/pinctrl/consumer.h>
>>>>> =C2=A0=C2=A0 #include <linux/regulator/consumer.h>
>>>>> @@ -110,6 +111,12 @@
>>>>> =C2=A0=C2=A0 #define NVQUIRK_DIS_CARD_CLK_CONFIG_TAP=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BIT(8)
>>>>> =C2=A0=C2=A0 #define NVQUIRK_CQHCI_DCMD_R1B_CMD_TIMING=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 BIT(9)
>>>>> =C2=A0=C2=A0 +/*
>>>>> + * NVQUIRK_HAS_TMCLK is for SoC's having separate timeout clock for
>>>>> Tegra
>>>>> + * SDMMC hardware data timeout.
>>>>> + */
>>>>> +#define NVQUIRK_HAS_TMCLK=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BIT(10)
>>>>> +
>>>>> =C2=A0=C2=A0 /* SDMMC CQE Base Address for Tegra Host Ver 4.1 and Hig=
her */
>>>>> =C2=A0=C2=A0 #define SDHCI_TEGRA_CQE_BASE_ADDR=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0xF000
>>>>> =C2=A0=C2=A0 @@ -140,6 +147,7 @@ struct sdhci_tegra_autocal_offsets {
>>>>> =C2=A0=C2=A0 struct sdhci_tegra {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const struct sdhci_tegra_soc_dat=
a *soc_data;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct gpio_desc *power_gpio;
>>>>> +=C2=A0=C2=A0=C2=A0 struct clk *tmclk;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool ddr_signaling;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool pad_calib_required;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool pad_control_available;
>>>>> @@ -1433,7 +1441,8 @@ static const struct sdhci_tegra_soc_data
>>>>> soc_data_tegra210 =3D {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 NVQUIRK_HAS_PADCALIB |
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 NVQUIRK_DIS_CARD_CLK_CONFIG_TAP |
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 NVQUIRK_ENABLE_SDR50 |
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 N=
VQUIRK_ENABLE_SDR104,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 N=
VQUIRK_ENABLE_SDR104 |
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 N=
VQUIRK_HAS_TMCLK,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .min_tap_delay =3D 106,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .max_tap_delay =3D 185,
>>>>> =C2=A0=C2=A0 };
>>>>> @@ -1471,6 +1480,7 @@ static const struct sdhci_tegra_soc_data
>>>>> soc_data_tegra186 =3D {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 NVQUIRK_DIS_CARD_CLK_CONFIG_TAP |
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 NVQUIRK_ENABLE_SDR50 |
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 NVQUIRK_ENABLE_SDR104 |
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 N=
VQUIRK_HAS_TMCLK |
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 NVQUIRK_CQHCI_DCMD_R1B_CMD_TIMING,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .min_tap_delay =3D 84,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .max_tap_delay =3D 136,
>>>>> @@ -1483,7 +1493,8 @@ static const struct sdhci_tegra_soc_data
>>>>> soc_data_tegra194 =3D {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 NVQUIRK_HAS_PADCALIB |
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 NVQUIRK_DIS_CARD_CLK_CONFIG_TAP |
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 NVQUIRK_ENABLE_SDR50 |
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 N=
VQUIRK_ENABLE_SDR104,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 N=
VQUIRK_ENABLE_SDR104 |
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 N=
VQUIRK_HAS_TMCLK,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .min_tap_delay =3D 96,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .max_tap_delay =3D 139,
>>>>> =C2=A0=C2=A0 };
>>>>> @@ -1611,15 +1622,76 @@ static int sdhci_tegra_probe(struct
>>>>> platform_device *pdev)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err=
_power_req;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0 -=C2=A0=C2=A0=C2=A0 clk =3D devm_clk_get(mmc_dev(host->m=
mc), NULL);
>>>>> -=C2=A0=C2=A0=C2=A0 if (IS_ERR(clk)) {
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc =3D PTR_ERR(clk);
>>>>> +=C2=A0=C2=A0=C2=A0 /*
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Tegra210 and later has separate SDMMC_LEG=
ACY_TM clock used for
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * hardware data timeout clock and SW can ch=
oose TMCLK or
>>>>> SDCLK for
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * hardware data timeout through the bit
>>>>> USE_TMCLK_FOR_DATA_TIMEOUT
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * of the register SDHCI_TEGRA_VENDOR_SYS_SW=
_CTRL.
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 *
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * USE_TMCLK_FOR_DATA_TIMEOUT bit default is=
 set to 1 and SDMMC
>>>>> uses
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * 12Mhz TMCLK which is advertised in host c=
apability register.
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * With TMCLK of 12Mhz provides maximum data=
 timeout period that
>>>>> can
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * be achieved is 11s better than using SDCL=
K for data timeout.
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 *
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * So, TMCLK is set to 12Mhz and kept enable=
d all the time on
>>>>> SoC's
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * supporting separate TMCLK.
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 *
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Old device tree has single sdhci clock. S=
o with addition of
>>>>> TMCLK,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * retrieving sdhci clock by "sdhci" clock n=
ame based on
>>>>> number of
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * clocks in sdhci device node.
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0 if (of_clk_get_parent_count(pdev->dev.of_node) =
=3D=3D 1) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (soc_data->nvquirks & =
NVQUIRK_HAS_TMCLK)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 d=
ev_warn(&pdev->dev,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "missing tmclk in the device tree\n");
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 clk =3D devm_clk_get(&pde=
v->dev, NULL);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (IS_ERR(clk)) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r=
c =3D PTR_ERR(clk);
>>>>> =C2=A0=C2=A0 -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (rc !=3D =
-EPROBE_DEFER)
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 d=
ev_err(&pdev->dev, "failed to get clock: %d\n", rc);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 i=
f (rc !=3D -EPROBE_DEFER)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 dev_err(&pdev->dev,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "failed to get sdhci clock=
: %d\n", rc);
>>>>> =C2=A0=C2=A0 -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_clk=
_get;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 g=
oto err_power_req;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> +=C2=A0=C2=A0=C2=A0 } else {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (soc_data->nvquirks & =
NVQUIRK_HAS_TMCLK) {
>>>> I think that I would do the inverse of this ...
>>>>
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 } else {
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!(soc_data-=
>nvquirks & NVQUIRK_HAS_TMCLK)) {
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev_err(&pdev->dev, "Device has unexpecte=
d
>>>> clocks!\n");
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc =3D -EINVAL;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto_power_req;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 clk =3D devm_cl=
k_get(&pdev->dev, "tmclk");
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ...
>>>>
>>>> If the device does not have a single clock, then we expect it to
>>>> support
>>>> the tmclk. If this is not the case, then this is a bug.
>>>>
>>>> Cheers
>>>> Jon
>>> I don't see other drivers validating for unexpected device tree entries=
.
>>>
>>> Also only for SoC with quirk HAS_TMCLK, we are retrieving TMCLK with
>>> clock name and enabling it.
>>>
>>> So for other SoC even if device tree has additional clock entry other
>>> than sdhci driver don't use it and also dt-binding do not have any tmcl=
k
>>> entry for other SoC. So why would this be a bug?
>> In the device tree binding doc, we say has two clocks for Tegra210,
>> Tegra186 and Tegra194 and one clock for all other devices. So if we no
>> there is more than 1 but the device does not have this quirk, then the
>> device-tree does not reflect what is stated in the binding doc or the
>> quirk is no populated as it should be. I feel that either case is a bug.
>>
>> Now of course it could be possible for someone to add a 3rd clock for
>> Tegra210 and we would not detect this but like you said we don't check
>> all conditions. So yes we don't catch all cases, but the ones that
>> matter.
>>
>> Jon
>>
> Based on internal discussion with Thierry we don't need to handle clocks
>=20
> order in driver. So will revert clock retrieval to same as in v4 and
> will send v7 series.

Yes OK fine. Maybe I am being too overly cautious as usual!

Jon

--=20
nvpublic
