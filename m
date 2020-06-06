Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F2F1F07ED
	for <lists+stable@lfdr.de>; Sat,  6 Jun 2020 18:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbgFFQai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Jun 2020 12:30:38 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:44861 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726968AbgFFQah (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Jun 2020 12:30:37 -0400
Received: from [192.168.1.9] (hst-208-212.medicom.bg [84.238.208.212])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by extserv.mm-sol.com (Postfix) with ESMTPSA id 83EB6CFCE;
        Sat,  6 Jun 2020 19:30:33 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mm-sol.com; s=201706;
        t=1591461033; bh=9Jbiod1vB7zOrB+Jk7X53N7PxKajryvdgLEigxtjI4s=;
        h=Subject:To:Cc:From:Date:From;
        b=Vypu7//tMZa9tpCbHL1Ji6VLjIFz9l8PJtA/ehTMfAnRvO4uAcQfwY79lq3e5Fwch
         4rmpKpGcm+EJs6gL4yMeDuyy3oAD++xm7GMZlnvoQnvtIUHNAYq34yYyAkXP3lOKuT
         UATDVvO1+KWvaS/TPQlavw0RK5u4glJTkTWL3ynu4PTbjomzb1jisW9lViFz96HAGS
         ai87vqIUSdYp+cU8ptRD4geRFAQXGLMX2wh0Cy2w1LsU5xPvVq1S4Wr63ZDYzYnDHr
         zEpb2eanVKJAg/9pOIF4PsjOILDA6vAKrQyTz62cAHVrV4g1le3GJdynBuaoi+Qjgf
         6NMu8VIxXg/+g==
Subject: Re: [PATCH v5 07/11] PCI: qcom: Define some PARF params needed for
 ipq8064 SoC
To:     Ansuel Smith <ansuelsmth@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200602115353.20143-1-ansuelsmth@gmail.com>
 <20200602115353.20143-8-ansuelsmth@gmail.com>
From:   Stanimir Varbanov <svarbanov@mm-sol.com>
Message-ID: <f0f86fd3-c6ad-94f6-5256-8089e2b8af65@mm-sol.com>
Date:   Sat, 6 Jun 2020 19:30:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200602115353.20143-8-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 6/2/20 2:53 PM, Ansuel Smith wrote:
> Set some specific value for Tx De-Emphasis, Tx Swing and Rx equalization
> needed on some ipq8064 based device (Netgear R7800 for example). Without
> this the system locks on kernel load.
> 
> Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Cc: stable@vger.kernel.org # v4.5+
> Reviewed-by: Rob Herring <robh@kernel.org>
> ---
>  drivers/pci/controller/dwc/pcie-qcom.c | 27 ++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
> index f2ea1ab6f584..f5398b0d270c 100644
> --- a/drivers/pci/controller/dwc/pcie-qcom.c
> +++ b/drivers/pci/controller/dwc/pcie-qcom.c
> @@ -46,6 +46,9 @@
>  
>  #define PCIE20_PARF_PHY_CTRL			0x40
>  #define PCIE20_PARF_PHY_REFCLK			0x4C
> +#define PHY_REFCLK_SSP_EN			BIT(16)
> +#define PHY_REFCLK_USE_PAD			BIT(12)

These two are not used in the patch, please move it in 08/11.

> +
>  #define PCIE20_PARF_DBI_BASE_ADDR		0x168
>  #define PCIE20_PARF_SLV_ADDR_SPACE_SIZE		0x16C
>  #define PCIE20_PARF_MHI_CLOCK_RESET_CTRL	0x174
> @@ -77,6 +80,18 @@
>  #define DBI_RO_WR_EN				1
>  
>  #define PERST_DELAY_US				1000
> +/* PARF registers */
> +#define PCIE20_PARF_PCS_DEEMPH			0x34
> +#define PCS_DEEMPH_TX_DEEMPH_GEN1(x)		((x) << 16)
> +#define PCS_DEEMPH_TX_DEEMPH_GEN2_3_5DB(x)	((x) << 8)
> +#define PCS_DEEMPH_TX_DEEMPH_GEN2_6DB(x)	((x) << 0)
> +
> +#define PCIE20_PARF_PCS_SWING			0x38
> +#define PCS_SWING_TX_SWING_FULL(x)		((x) << 8)
> +#define PCS_SWING_TX_SWING_LOW(x)		((x) << 0)
> +
> +#define PCIE20_PARF_CONFIG_BITS		0x50
> +#define PHY_RX0_EQ(x)				((x) << 24)
>  
>  #define PCIE20_v3_PARF_SLV_ADDR_SPACE_SIZE	0x358
>  #define SLV_ADDR_SPACE_SZ			0x10000000
> @@ -293,6 +308,7 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
>  	struct qcom_pcie_resources_2_1_0 *res = &pcie->res.v2_1_0;
>  	struct dw_pcie *pci = pcie->pci;
>  	struct device *dev = pci->dev;
> +	struct device_node *node = dev->of_node;
>  	u32 val;
>  	int ret;
>  
> @@ -347,6 +363,17 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
>  	val &= ~BIT(0);
>  	writel(val, pcie->parf + PCIE20_PARF_PHY_CTRL);
>  
> +	if (of_device_is_compatible(node, "qcom,pcie-ipq8064")) {
> +		writel(PCS_DEEMPH_TX_DEEMPH_GEN1(24) |
> +			       PCS_DEEMPH_TX_DEEMPH_GEN2_3_5DB(24) |
> +			       PCS_DEEMPH_TX_DEEMPH_GEN2_6DB(34),
> +		       pcie->parf + PCIE20_PARF_PCS_DEEMPH);
> +		writel(PCS_SWING_TX_SWING_FULL(120) |
> +			       PCS_SWING_TX_SWING_LOW(120),
> +		       pcie->parf + PCIE20_PARF_PCS_SWING);

Please fix the indentations above.

> +		writel(PHY_RX0_EQ(4), pcie->parf + PCIE20_PARF_CONFIG_BITS);
> +	}
> +
>  	/* enable external reference clock */
>  	val = readl(pcie->parf + PCIE20_PARF_PHY_REFCLK);
>  	val |= BIT(16);
> 

-- 
regards,
Stan
