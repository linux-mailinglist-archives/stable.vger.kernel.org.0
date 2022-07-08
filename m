Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB2256C397
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 01:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237234AbiGHXCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 19:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbiGHXCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 19:02:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA19371BF;
        Fri,  8 Jul 2022 16:02:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFB02B82A0E;
        Fri,  8 Jul 2022 23:01:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3BDC341C0;
        Fri,  8 Jul 2022 23:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657321317;
        bh=wNfnyz3LmMTDakpbo0s1J0PDENVco/YTdTzC4Br7C8c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=DkmuRAsiEV3Q3CN2Sac6ar1BgyMVW3WlbCLbQJtwvnSA9QqDLLsNFahsvRXMXrFXQ
         2R4/bSVavs80cYPoDBpg3Q/XVUuOJobJqMhGkiN3PKogV6vCG42UzEh2CRjwDAio5K
         eywro1EVoK4n/ntKFsaxAA6HIHlNnsuIlrB7XZk54betDv5NQ0o7pD7zI/f3HqSJrg
         EwWTpZK6xkDL1hhLdw1+i8DBPQdHp06K294czZS8ZANqm3XaAhsWEgifzXdK31WVJp
         bfv0jXPHI2BKeDLQ/i1PCedBVT0qmEO4ZcmV/4zD5QGOSCk/crIV8lB00mBBkJukkN
         nQkuxLZ5AZOqg==
Date:   Fri, 8 Jul 2022 18:01:55 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Stanimir Varbanov <svarbanov@mm-sol.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] PCI: qcom: Enable clocks only after PARF_PHY setup for
 rev 2.1.0
Message-ID: <20220708230155.GA388993@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708222743.27019-1-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 09, 2022 at 12:27:43AM +0200, Christian Marangi wrote:
> We currently enable clocks BEFORE we write to PARF_PHY_CTRL reg to
> enable clocks and resets. This case the driver to never set to a ready
> state with the error 'Phy link never came up'.
> 
> This in fact is caused by the phy clock getting enabled before setting
> the required bits in the PARF regs.
> 
> A workaround for this was set but with this new discovery we can drop
> the workaround and use a proper solution to the problem by just enabling
> the clock only AFTER the PARF_PHY_CTRL bit is set.
> 
> This correctly setup the pcie line and makes it usable even when a
> bootloader leave the pcie line to a underfined state.

Is "pcie" here a signal name?  Maybe this refers to the "PCIe link"?

> Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
> Cc: stable@vger.kernel.org # v5.4+
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>

Thanks, I put this on
https://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git,
pci/ctrl/qcom-pending branch (head 47b4ec9d2e60).

Can you take a look and make sure I didn't mess up the conflict
resolution with the rest of the series?

> ---
>  drivers/pci/controller/dwc/pcie-qcom.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
> index 2ea13750b492..da13a66ced14 100644
> --- a/drivers/pci/controller/dwc/pcie-qcom.c
> +++ b/drivers/pci/controller/dwc/pcie-qcom.c
> @@ -337,8 +337,6 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
>  	reset_control_assert(res->ext_reset);
>  	reset_control_assert(res->phy_reset);
>  
> -	writel(1, pcie->parf + PCIE20_PARF_PHY_CTRL);
> -
>  	ret = regulator_bulk_enable(ARRAY_SIZE(res->supplies), res->supplies);
>  	if (ret < 0) {
>  		dev_err(dev, "cannot enable regulators\n");
> @@ -381,15 +379,15 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
>  		goto err_deassert_axi;
>  	}
>  
> -	ret = clk_bulk_prepare_enable(ARRAY_SIZE(res->clks), res->clks);
> -	if (ret)
> -		goto err_clks;
> -
>  	/* enable PCIe clocks and resets */
>  	val = readl(pcie->parf + PCIE20_PARF_PHY_CTRL);
>  	val &= ~BIT(0);
>  	writel(val, pcie->parf + PCIE20_PARF_PHY_CTRL);
>  
> +	ret = clk_bulk_prepare_enable(ARRAY_SIZE(res->clks), res->clks);
> +	if (ret)
> +		goto err_clks;
> +
>  	if (of_device_is_compatible(node, "qcom,pcie-ipq8064") ||
>  	    of_device_is_compatible(node, "qcom,pcie-ipq8064-v2")) {
>  		writel(PCS_DEEMPH_TX_DEEMPH_GEN1(24) |
> -- 
> 2.36.1
> 
