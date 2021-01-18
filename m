Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 064772FA459
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 16:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405534AbhARPQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 10:16:45 -0500
Received: from foss.arm.com ([217.140.110.172]:37732 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405397AbhARPQH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 10:16:07 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2463A1FB;
        Mon, 18 Jan 2021 07:15:19 -0800 (PST)
Received: from e121166-lin.cambridge.arm.com (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 924753F68F;
        Mon, 18 Jan 2021 07:15:17 -0800 (PST)
Date:   Mon, 18 Jan 2021 15:15:11 +0000
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Cc:     Ilia Mirkin <imirkin@alum.mit.edu>, stable@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sham Muthayyan <smuthayy@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] PCI: qcom: use PHY_REFCLK_USE_PAD only for ipq8064
Message-ID: <20210118151511.GA15060@e121166-lin.cambridge.arm.com>
References: <20201019165555.8269-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019165555.8269-1-ansuelsmth@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 19, 2020 at 06:55:55PM +0200, Ansuel Smith wrote:
> The use of PHY_REFCLK_USE_PAD introduced a regression for apq8064
> devices. It was tested that while apq doesn't require the padding, ipq
> SoC must use it or the kernel hangs on boot.
> 
> Fixes: de3c4bf6489 ("PCI: qcom: Add support for tx term offset for rev 2.1.0")
> Reported-by: Ilia Mirkin <imirkin@alum.mit.edu>
> Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Cc: stable@vger.kernel.org # v4.19+
> ---
>  drivers/pci/controller/dwc/pcie-qcom.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Need qcom maintainer's ack, thanks.

Lorenzo

> diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
> index 3aac77a295ba..dad6e9ce66ba 100644
> --- a/drivers/pci/controller/dwc/pcie-qcom.c
> +++ b/drivers/pci/controller/dwc/pcie-qcom.c
> @@ -387,7 +387,9 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
>  
>  	/* enable external reference clock */
>  	val = readl(pcie->parf + PCIE20_PARF_PHY_REFCLK);
> -	val &= ~PHY_REFCLK_USE_PAD;
> +	/* USE_PAD is required only for ipq806x */
> +	if (!of_device_is_compatible(node, "qcom,pcie-apq8064"))
> +		val &= ~PHY_REFCLK_USE_PAD;
>  	val |= PHY_REFCLK_SSP_EN;
>  	writel(val, pcie->parf + PCIE20_PARF_PHY_REFCLK);
>  
> -- 
> 2.27.0
> 
