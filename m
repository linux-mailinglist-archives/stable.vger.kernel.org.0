Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCCA266901C
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 09:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbjAMIJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 03:09:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241046AbjAMIIz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 03:08:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D191B65AF6;
        Fri, 13 Jan 2023 00:07:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59478B81FF6;
        Fri, 13 Jan 2023 08:07:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07CCC433D2;
        Fri, 13 Jan 2023 08:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673597244;
        bh=XwdbdOtMyNyQf2/SyhaupKFU6r9iYvLXNbua3vu2VpU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hkDLPxiPqcmD/vrzF672wBl2bqoJrDmdrzRQGEQ35dedumOJIl52g1JB3rc6hHFl6
         ePt70fh7UGMDcUQQ2B5nqlFBS5FYwd5eP7vtCRZLSUjHU/PKyZH6YUl35dD2Pz2n9h
         JArsZuQJ/rgnLnH01GE4q0t+J+X9AdEfDqB/eiRVBNdfIFda8u1vVE5ZEFYXnnfk4r
         OuWbvmVf9wJCBC6kNMBm52lN6qgLeRiIG3EEf97TJ5NqIaiCAYVPVxP3lyeNjXFvVx
         ZX8N7iz+KRMOLLDoSnq5LGcnCO+3DCzYCVHkDc1hdSQIb/ywQL0z1q5A9QI8Rmqm6r
         ks4CgauP1HFXw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pGF64-0006Kh-M1; Fri, 13 Jan 2023 09:07:33 +0100
Date:   Fri, 13 Jan 2023 09:07:32 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH 5.15.y 3/4] phy: qcom-qmp-combo: fix broken power on
Message-ID: <Y8ERRMXng+kL+Vtc@hovoldconsulting.com>
References: <20230113005405.3992011-1-swboyd@chromium.org>
 <20230113005405.3992011-4-swboyd@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113005405.3992011-4-swboyd@chromium.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 12, 2023 at 04:54:04PM -0800, Stephen Boyd wrote:
> From: Johan Hovold <johan+linaro@kernel.org>
> 
> commit 7a7d86d14d073dfa3429c550667a8e78b99edbd4 upstream.
> 
> The PHY is powered on during phy-init by setting the SW_PWRDN bit in the
> COM_POWER_DOWN_CTRL register and then setting the same bit in the in the
> PCS_POWER_DOWN_CONTROL register that belongs to the USB part of the
> PHY.
> 
> Currently, whether power on succeeds depends on probe order and having
> the USB part of the PHY be initialised first. In case the DP part of the
> PHY is instead initialised first, the intended power on of the USB block
> results in a corrupted DP_PHY register (e.g. DP_PHY_AUX_CFG8).
> 
> Add a pointer to the USB part of the PHY to the driver data and use that
> to power on the PHY also if the DP part of the PHY is initialised first.
> 
> Fixes: 52e013d0bffa ("phy: qcom-qmp: Add support for DP in USB3+DP combo phy")
> Cc: stable@vger.kernel.org	# 5.10
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> Link: https://lore.kernel.org/r/20221114081346.5116-5-johan+linaro@kernel.org
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> [swboyd@chromium.org: Backport to pre-split driver]
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  drivers/phy/qualcomm/phy-qcom-qmp.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
> index c6f860ce3d99..9fda6d283f20 100644
> --- a/drivers/phy/qualcomm/phy-qcom-qmp.c
> +++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
> @@ -2919,6 +2919,7 @@ struct qcom_qmp {
>  	struct regulator_bulk_data *vregs;
>  
>  	struct qmp_phy **phys;
> +	struct qmp_phy *usb_phy;
>  
>  	struct mutex phy_mutex;
>  	int init_count;
> @@ -4554,7 +4555,7 @@ static int qcom_qmp_phy_com_init(struct qmp_phy *qphy)
>  	struct qcom_qmp *qmp = qphy->qmp;
>  	const struct qmp_phy_cfg *cfg = qphy->cfg;
>  	void __iomem *serdes = qphy->serdes;
> -	void __iomem *pcs = qphy->pcs;
> +	struct qmp_phy *usb_phy = qmp->usb_phy;
>  	void __iomem *dp_com = qmp->dp_com;
>  	int ret, i;
>  
> @@ -4620,13 +4621,13 @@ static int qcom_qmp_phy_com_init(struct qmp_phy *qphy)
>  		qphy_setbits(serdes, cfg->regs[QPHY_COM_POWER_DOWN_CONTROL],
>  			     SW_PWRDN);
>  	} else {
> -		if (cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL])
> -			qphy_setbits(pcs,
> -					cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL],
> -					cfg->pwrdn_ctrl);
> +		if (usb_phy->cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL])
> +			qphy_setbits(usb_phy->pcs,
> +					usb_phy->cfg->regs[QPHY_PCS_POWER_DOWN_CONTROL],
> +					usb_phy->cfg->pwrdn_ctrl);
>  		else
> -			qphy_setbits(pcs, QPHY_POWER_DOWN_CONTROL,
> -					cfg->pwrdn_ctrl);
> +			qphy_setbits(usb_phy->pcs, QPHY_POWER_DOWN_CONTROL,
> +					usb_phy->cfg->pwrdn_ctrl);

This bit looks like it requires some more work in order not to break
PCIe and UFS PHYs, which lack the USB registers.

>  	}
>  
>  	mutex_unlock(&qmp->phy_mutex);
> @@ -5769,6 +5770,9 @@ static int qcom_qmp_phy_probe(struct platform_device *pdev)
>  			goto err_node_put;
>  		}
>  
> +		if (cfg->type == PHY_TYPE_USB3)
> +			qmp->usb_phy = qmp->phys[id];
> +
>  		/*
>  		 * Register the pipe clock provided by phy.
>  		 * See function description to see details of this pipe clock.
> @@ -5791,6 +5795,9 @@ static int qcom_qmp_phy_probe(struct platform_device *pdev)
>  		id++;
>  	}
>  
> +	if (!qmp->usb_phy)
> +		return -EINVAL;
> +

This will break probe of PCIe and UFS PHYs unless you only check this
for combo PHYs.

Perhaps you can rename the usb_phy pointer to something more generic and
set it also for PCIe and UFS so that it always points to the register
block that should be used for QPHY_PCS_POWER_DOWN_CONTROL.

>  	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
>  	if (!IS_ERR(phy_provider))
>  		dev_info(dev, "Registered Qcom-QMP phy\n");

Johan
