Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 467F12DD80
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 14:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbfE2Mwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 08:52:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbfE2Mwe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 08:52:34 -0400
Received: from localhost (173-25-83-245.client.mchsi.com [173.25.83.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E027320673;
        Wed, 29 May 2019 12:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559134354;
        bh=dGdCcGynEuU84CpifoTXESNk2YEk11Q/jGdnwOs+Z6w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u4ogjzOkqZR5Nbh3+cYMWEKxFsnKlIh67NoDnsZy7gFqj1L/7JUMH6XqIwXwDn6xz
         KMuQSOnWj9hHsqvf6Je8Jyx30JyREdjGCk42fa/ZDKy5vtlpolOQ3wsKvHXefAjzyB
         hNrXgkjUHo3CUGXe/TArH2W1n6B5xtyjl3oa4q64=
Date:   Wed, 29 May 2019 07:52:32 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Niklas Cassel <niklas.cassel@linaro.org>
Cc:     Stanimir Varbanov <svarbanov@mm-sol.com>,
        Andy Gross <agross@kernel.org>,
        David Brown <david.brown@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        stable@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] PCI: qcom: Ensure that PERST is asserted for at least
 100 ms
Message-ID: <20190529125232.GA28250@google.com>
References: <20190529094352.5961-1-niklas.cassel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529094352.5961-1-niklas.cassel@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
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

I think this patch is absolutely the right thing to do.  We don't know
what might be plugged in, so we should support arbitrary endpoints.

One could imagine some sort of DT property to identify closed
environments where there is no need to support arbitrary endpoints and
it might be desirable to reduce the delay.  But that should wait
until there's a need for it and if the need *does* arise, hopefully
the definition of such a property could be generic across all SoCs.

> The PCI Express Card Electromechanical Specification specifies:
> "On power up, the deassertion of PERST# is delayed 100 ms (TPVPERL) from
> the power rails achieving specified operating limits."

It'd be nice to include the complete citation, i.e., "PCI Express Card
Electromechanical Specification r2.0, sec 2.2"

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
> 
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
