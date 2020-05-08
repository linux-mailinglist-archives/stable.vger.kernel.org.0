Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFBD1CAA1A
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 13:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgEHL5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 07:57:06 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:40764 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbgEHL5F (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 07:57:05 -0400
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 May 2020 07:57:04 EDT
Received: from [192.168.1.3] (212-5-158-166.ip.btc-net.bg [212.5.158.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by extserv.mm-sol.com (Postfix) with ESMTPSA id 01B60CFDF;
        Fri,  8 May 2020 14:51:41 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mm-sol.com; s=201706;
        t=1588938702; bh=HKXtAHb8XwUHfwx+lbiW6p1jjEHLBjHzXIcqdmJHqqo=;
        h=Subject:To:Cc:From:Date:From;
        b=NcEbwqswZH8u+RVQPQUWGHPsbLKm/6gGSfUMjoePLqgP5XBQXk/R3Pzr2joHoZqrj
         gT1XmmZQx+hqZpAr5etbQx4ZdzWwa1VL5orRtSAI74Hvb1UvTjNjR53rmM8Z7jpcpZ
         hSph9EnkKjuNmd94CpveOGlmHUW7+EEJzTqIgJn2cHUZfqs2LZ/+ZJvtTY5/wPQTJk
         LFvY5GpWPCkLJ9v2DCZ+YOF515eUW9F6RmQijf7dUm82opTPWIKqkYPmemhhMvJr6B
         UpPP0qYaDClC2ZcC9pRu15T1DFmq7JLMo2S31rMKbzoF2O0YgYmaPx7Vlf7NW5iig6
         DYEUGUywDP6Bg==
Subject: Re: [PATCH v3 01/11] PCI: qcom: add missing ipq806x clocks in PCIe
 driver
To:     Ansuel Smith <ansuelsmth@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Sham Muthayyan <smuthayy@codeaurora.org>, stable@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200430220619.3169-1-ansuelsmth@gmail.com>
 <20200430220619.3169-2-ansuelsmth@gmail.com>
From:   Stanimir Varbanov <svarbanov@mm-sol.com>
Message-ID: <3228e401-f9cd-a550-0bd4-80f01b35971a@mm-sol.com>
Date:   Fri, 8 May 2020 14:51:39 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200430220619.3169-2-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ansuel,

On 5/1/20 1:06 AM, Ansuel Smith wrote:
> Aux and Ref clk are missing in PCIe qcom driver.
> Add support in the driver to fix PCIe initialization in ipq806x.
> 
> Fixes: 82a823833f4e PCI: qcom: Add Qualcomm PCIe controller driver
> Signed-off-by: Sham Muthayyan <smuthayy@codeaurora.org>
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Cc: stable@vger.kernel.org # v4.5+
> ---
>  drivers/pci/controller/dwc/pcie-qcom.c | 44 ++++++++++++++++++++++----
>  1 file changed, 38 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
> index 5ea527a6bd9f..2a39dfdccfc8 100644
> --- a/drivers/pci/controller/dwc/pcie-qcom.c
> +++ b/drivers/pci/controller/dwc/pcie-qcom.c
> @@ -88,6 +88,8 @@ struct qcom_pcie_resources_2_1_0 {
>  	struct clk *iface_clk;
>  	struct clk *core_clk;
>  	struct clk *phy_clk;
> +	struct clk *aux_clk;
> +	struct clk *ref_clk;
>  	struct reset_control *pci_reset;
>  	struct reset_control *axi_reset;
>  	struct reset_control *ahb_reset;
> @@ -246,6 +248,14 @@ static int qcom_pcie_get_resources_2_1_0(struct qcom_pcie *pcie)
>  	if (IS_ERR(res->phy_clk))
>  		return PTR_ERR(res->phy_clk);
>  
> +	res->aux_clk = devm_clk_get_optional(dev, "aux");
> +	if (IS_ERR(res->aux_clk))
> +		return PTR_ERR(res->aux_clk);
> +
> +	res->ref_clk = devm_clk_get_optional(dev, "ref");
> +	if (IS_ERR(res->ref_clk))
> +		return PTR_ERR(res->ref_clk);
> +
>  	res->pci_reset = devm_reset_control_get_exclusive(dev, "pci");
>  	if (IS_ERR(res->pci_reset))
>  		return PTR_ERR(res->pci_reset);
> @@ -278,6 +288,8 @@ static void qcom_pcie_deinit_2_1_0(struct qcom_pcie *pcie)
>  	clk_disable_unprepare(res->iface_clk);
>  	clk_disable_unprepare(res->core_clk);
>  	clk_disable_unprepare(res->phy_clk);
> +	clk_disable_unprepare(res->aux_clk);
> +	clk_disable_unprepare(res->ref_clk);
>  	regulator_bulk_disable(ARRAY_SIZE(res->supplies), res->supplies);
>  }
>  
> @@ -307,16 +319,32 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
>  		goto err_assert_ahb;
>  	}
>  
> +	ret = clk_prepare_enable(res->core_clk);
> +	if (ret) {
> +		dev_err(dev, "cannot prepare/enable core clock\n");
> +		goto err_clk_core;
> +	}
> +
>  	ret = clk_prepare_enable(res->phy_clk);
>  	if (ret) {
>  		dev_err(dev, "cannot prepare/enable phy clock\n");
>  		goto err_clk_phy;
>  	}
>  
> -	ret = clk_prepare_enable(res->core_clk);
> -	if (ret) {
> -		dev_err(dev, "cannot prepare/enable core clock\n");
> -		goto err_clk_core;
> +	if (res->aux_clk) {

you don't need this check, clk_prepare_enable handles NULL

> +		ret = clk_prepare_enable(res->aux_clk);
> +		if (ret) {
> +			dev_err(dev, "cannot prepare/enable aux clock\n");
> +			goto err_clk_aux;
> +		}
> +	}
> +
> +	if (res->ref_clk) {

here too

> +		ret = clk_prepare_enable(res->ref_clk);
> +		if (ret) {
> +			dev_err(dev, "cannot prepare/enable ref clock\n");
> +			goto err_clk_ref;
> +		}
>  	}
>  
>  	ret = reset_control_deassert(res->ahb_reset);
> @@ -372,10 +400,14 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
>  	return 0;
>  
>  err_deassert_ahb:
> -	clk_disable_unprepare(res->core_clk);
> -err_clk_core:
> +	clk_disable_unprepare(res->ref_clk);
> +err_clk_ref:
> +	clk_disable_unprepare(res->aux_clk);
> +err_clk_aux:
>  	clk_disable_unprepare(res->phy_clk);
>  err_clk_phy:
> +	clk_disable_unprepare(res->core_clk);
> +err_clk_core:
>  	clk_disable_unprepare(res->iface_clk);
>  err_assert_ahb:
>  	regulator_bulk_disable(ARRAY_SIZE(res->supplies), res->supplies);
> 

-- 
regards,
Stan
