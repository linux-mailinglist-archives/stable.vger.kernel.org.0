Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D7525F931
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 13:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgIGLTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 07:19:24 -0400
Received: from foss.arm.com ([217.140.110.172]:33046 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728501AbgIGLRz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 07:17:55 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C99461045;
        Mon,  7 Sep 2020 04:02:13 -0700 (PDT)
Received: from e121166-lin.cambridge.arm.com (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5E3693F66E;
        Mon,  7 Sep 2020 04:02:12 -0700 (PDT)
Date:   Mon, 7 Sep 2020 12:02:07 +0100
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Stanimir Varbanov <svarbanov@mm-sol.com>, stable@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: qcom: Make sure PCIe is reset before init for rev
 2.1.0
Message-ID: <20200907110207.GA7573@e121166-lin.cambridge.arm.com>
References: <20200901124955.137-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901124955.137-1-ansuelsmth@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 01, 2020 at 02:49:54PM +0200, Ansuel Smith wrote:
> Qsdk U-Boot can incorrectly leave the PCIe interface in an undefined
> state if bootm command is used instead of bootipq. This is caused by the
> not deinit of PCIe when bootm is called. Reset the PCIe before init
> anyway to fix this U-Boot bug.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
> Cc: stable@vger.kernel.org # v4.19+
> ---
>  drivers/pci/controller/dwc/pcie-qcom.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)

Applied to pci/qcom, thanks.

Lorenzo

> diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
> index 3aac77a295ba..82336bbaf8dc 100644
> --- a/drivers/pci/controller/dwc/pcie-qcom.c
> +++ b/drivers/pci/controller/dwc/pcie-qcom.c
> @@ -302,6 +302,9 @@ static void qcom_pcie_deinit_2_1_0(struct qcom_pcie *pcie)
>  	reset_control_assert(res->por_reset);
>  	reset_control_assert(res->ext_reset);
>  	reset_control_assert(res->phy_reset);
> +
> +	writel(1, pcie->parf + PCIE20_PARF_PHY_CTRL);
> +
>  	regulator_bulk_disable(ARRAY_SIZE(res->supplies), res->supplies);
>  }
>  
> @@ -314,6 +317,16 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
>  	u32 val;
>  	int ret;
>  
> +	/* reset the PCIe interface as uboot can leave it undefined state */
> +	reset_control_assert(res->pci_reset);
> +	reset_control_assert(res->axi_reset);
> +	reset_control_assert(res->ahb_reset);
> +	reset_control_assert(res->por_reset);
> +	reset_control_assert(res->ext_reset);
> +	reset_control_assert(res->phy_reset);
> +
> +	writel(1, pcie->parf + PCIE20_PARF_PHY_CTRL);
> +
>  	ret = regulator_bulk_enable(ARRAY_SIZE(res->supplies), res->supplies);
>  	if (ret < 0) {
>  		dev_err(dev, "cannot enable regulators\n");
> -- 
> 2.27.0
> 
