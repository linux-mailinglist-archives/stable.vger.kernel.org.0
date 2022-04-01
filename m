Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19E154EED17
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 14:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344011AbiDAM3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 08:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241594AbiDAM3N (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 08:29:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F1C184B5D;
        Fri,  1 Apr 2022 05:27:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07C92619C8;
        Fri,  1 Apr 2022 12:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12516C2BBE4;
        Fri,  1 Apr 2022 12:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648816043;
        bh=HTs0/FAhtfEndhvRZxAwXkarTQgKugIaJi8BLyTakpc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=OiygwegxAf+Nb8u/kYaR/sTqwX6e0Lsxxqct8K5A1abfkjfA8XRqqxguDLPJLfR/D
         kbJOjRjiOhQsNMZB7V9aGgBPwnXtF0KalEBDK9VwxXe+VSiwAB/08LOI9VOl4yQD1t
         3W2JCspaoJNyt+dJ2BicNJ3AVifeekj5Z35u1wzOsYdde8XZm5++CUvfdeT0ctyYO1
         DaFmg2ZZiu/jT0j22lIqPY5/FQPY44Zgx3G0InDUpu8AA4OE86t4xojKSbRLSJBVWv
         3MZzxD6mS8lbqQEDScQgisqXTlLqcndKgZL2etH6FhBjqgMfpieLMIzYeRHZLYhJ3s
         0C7o9idUoKeMw==
Date:   Fri, 1 Apr 2022 07:27:21 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        linux-pci@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] PCI: qcom: fix unbalanced phy init on probe errors
Message-ID: <20220401122721.GA87767@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401121054.6205-3-johan+linaro@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In subject, capitalize "Fix" and "PHY" to match previous commits and
your commit log.  Same for other patch.

On Fri, Apr 01, 2022 at 02:10:54PM +0200, Johan Hovold wrote:
> Make sure to undo the PHY initialisation (e.g. balance runtime PM) in
> case host initialisation fails during probe.
> 
> Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
> Cc: stable@vger.kernel.org      # 4.5
> Cc: Stanimir Varbanov <svarbanov@mm-sol.com>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
>  drivers/pci/controller/dwc/pcie-qcom.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
> index 0b0bd71f1bd2..df47986bda29 100644
> --- a/drivers/pci/controller/dwc/pcie-qcom.c
> +++ b/drivers/pci/controller/dwc/pcie-qcom.c
> @@ -1624,11 +1624,13 @@ static int qcom_pcie_probe(struct platform_device *pdev)
>  	ret = dw_pcie_host_init(pp);
>  	if (ret) {
>  		dev_err(dev, "cannot initialize host\n");
> -		goto err_pm_runtime_put;
> +		goto err_phy_exit;
>  	}
>  
>  	return 0;
>  
> +err_phy_exit:
> +	phy_exit(pcie->phy);
>  err_pm_runtime_put:
>  	pm_runtime_put(dev);
>  	pm_runtime_disable(dev);
> -- 
> 2.35.1
> 
