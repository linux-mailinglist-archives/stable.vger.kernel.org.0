Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C770C2FFAE
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 17:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbfE3Py6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 11:54:58 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:38992 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbfE3Py6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 May 2019 11:54:58 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C37DC341;
        Thu, 30 May 2019 08:54:57 -0700 (PDT)
Received: from redmoon (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 254DD3F59C;
        Thu, 30 May 2019 08:54:56 -0700 (PDT)
Date:   Thu, 30 May 2019 16:54:53 +0100
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Niklas Cassel <niklas.cassel@linaro.org>
Cc:     Stanimir Varbanov <svarbanov@mm-sol.com>,
        Andy Gross <agross@kernel.org>,
        David Brown <david.brown@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] PCI: qcom: Ensure that PERST is asserted for at least
 100 ms
Message-ID: <20190530155453.GF13993@redmoon>
References: <20190529094352.5961-1-niklas.cassel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529094352.5961-1-niklas.cassel@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 29, 2019 at 11:43:52AM +0200, Niklas Cassel wrote:
> Currently, there is only a 1 ms sleep after asserting PERST.
> 
> Reading the datasheets for different endpoints, some require PERST to be
> asserted for 10 ms in order for the endpoint to perform a reset, others
> require it to be asserted for 50 ms.
> 
> Several SoCs using this driver uses PCIe Mini Card, where we don't know
> what endpoint will be plugged in.
> 
> The PCI Express Card Electromechanical Specification specifies:
> "On power up, the deassertion of PERST# is delayed 100 ms (TPVPERL) from
> the power rails achieving specified operating limits."
> 
> Add a sleep of 100 ms before deasserting PERST, in order to ensure that
> we are compliant with the spec.
> 
> Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
> Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
> Acked-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> Cc: stable@vger.kernel.org # 4.5+
> ---
> Changes since v1:
> Move the sleep into qcom_ep_reset_deassert()
> 
>  drivers/pci/controller/dwc/pcie-qcom.c | 2 ++
>  1 file changed, 2 insertions(+)

Applied to pci/qcom for v5.3, thanks.

Lorenzo

> diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
> index 0ed235d560e3..5d1713069d14 100644
> --- a/drivers/pci/controller/dwc/pcie-qcom.c
> +++ b/drivers/pci/controller/dwc/pcie-qcom.c
> @@ -178,6 +178,8 @@ static void qcom_ep_reset_assert(struct qcom_pcie *pcie)
>  
>  static void qcom_ep_reset_deassert(struct qcom_pcie *pcie)
>  {
> +	/* Ensure that PERST has been asserted for at least 100 ms */
> +	msleep(100);
>  	gpiod_set_value_cansleep(pcie->reset, 0);
>  	usleep_range(PERST_DELAY_US, PERST_DELAY_US + 500);
>  }
> -- 
> 2.21.0
> 
