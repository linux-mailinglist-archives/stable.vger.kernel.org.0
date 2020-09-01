Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1D2259AF2
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730382AbgIAQzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728695AbgIAQzl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 12:55:41 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5D7C061244
        for <stable@vger.kernel.org>; Tue,  1 Sep 2020 09:55:38 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id y30so459949ooj.3
        for <stable@vger.kernel.org>; Tue, 01 Sep 2020 09:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v9975+hMWELTbAGvjMd+ItUOvowUKdGImeITiNZKzKE=;
        b=o9lKL0BVvMWm1tgl9Is1duPG5UGxdnIw9uldI8xPl0uGpZA7catKjJrRgBEAZJ0kbq
         m8OyAcQNAUHJJfw3kqhHlMddaLDwROFECYORDdwHm6W5cfivp+a9zNpn96v3HYUYlGkg
         jQjw/3QtxH5+nxI9pfta4wg+mkkVdPSzhFJjEhrs3DFHKpKw+3c7PqQ8xR1xnrLkhUzT
         Iuz5E6sFg7WjtaL9eBPRFLX7jtfdcOVNM83CJV4S2YSX38bqb6sxMse1As3kv26EQBWK
         KSm3PZHlpGKIRmh/8ovguVfzz4Jfy3bagDaSf/eDiUM+ptjv9PXx88/gXF/jEmk5/7u/
         W1Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v9975+hMWELTbAGvjMd+ItUOvowUKdGImeITiNZKzKE=;
        b=bU5SqwTwYUcI4MQQwOv67F4PmEO8rnH0rkRi1fj8Ny1ImobCQ7uNudN4PWkjejsSxr
         1Rkrzh4ucbQIrK0MXxigU6UUdabGScI2jmfhi0BIjZ/UNNSqvi8wrkO7O4s37CIGUHHc
         qghpM9w1Sz3nFtR9CNIS6c06n090EedHYO7nKhY4yA98AWOvlCKqNFkLT9lGkhFxxN3R
         9Itol4aMTP0A4nmqAfo86ZArrTNj+waK6KwglhfzigYopHlAaUxCEXBTysngd70MxQYJ
         dsoChJj8bVwbRFR9fsfQNmLsfpWvIXWZIDHl6Cujl7iH2XYdp0rmMvXjNKWDxcTy0VJp
         S37w==
X-Gm-Message-State: AOAM530Ir80VKeuul2wk0NqxhP4WQn3bOifqlh6WuGWgjjgqT45L9Ai5
        suPxGJCYYA3/9WDoFJEVNRxYIg==
X-Google-Smtp-Source: ABdhPJxXRLmSKBcnBlceznNDbZ4sBA5PnARmg8Fs8AUVLHlcApULxzxJqLOenz9NbmlqafxciiOaaw==
X-Received: by 2002:a05:6820:384:: with SMTP id r4mr2009979ooj.62.1598979338069;
        Tue, 01 Sep 2020 09:55:38 -0700 (PDT)
Received: from yoga ([2605:6000:e5cb:c100:8898:14ff:fe6d:34e])
        by smtp.gmail.com with ESMTPSA id 35sm273166oth.21.2020.09.01.09.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 09:55:37 -0700 (PDT)
Date:   Tue, 1 Sep 2020 11:55:34 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Stanimir Varbanov <svarbanov@mm-sol.com>, stable@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: qcom: Make sure PCIe is reset before init for rev
 2.1.0
Message-ID: <20200901165534.GA3715@yoga>
References: <20200901124955.137-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901124955.137-1-ansuelsmth@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 01 Sep 07:49 CDT 2020, Ansuel Smith wrote:

> Qsdk U-Boot can incorrectly leave the PCIe interface in an undefined
> state if bootm command is used instead of bootipq. This is caused by the
> not deinit of PCIe when bootm is called. Reset the PCIe before init
> anyway to fix this U-Boot bug.
> 

Looks sensible.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
> Cc: stable@vger.kernel.org # v4.19+
> ---
>  drivers/pci/controller/dwc/pcie-qcom.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
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
