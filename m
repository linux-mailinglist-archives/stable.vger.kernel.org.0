Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 798A96047C1
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbiJSNpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233557AbiJSNoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:44:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C141D345D;
        Wed, 19 Oct 2022 06:31:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0A70ACE2202;
        Wed, 19 Oct 2022 09:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3109FC433C1;
        Wed, 19 Oct 2022 09:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666171055;
        bh=IALyVF24HY9xflgysUmvPocIS1MzwmyKLjdMduM7X1Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AKpJsdE5cg5g0wiap61DLwNeC6lurl02KJcIKeTMVZY+rXLQHnLrCeayi9MNCZTHj
         Yy0XawoJkTzxEy6DaxKiRSabln3KGmetEqjcsJZ5d7g2C/FxasWExV51pODFWgTyKx
         2wDIlQzy+RCAnTSJ/Cu9O21WwcHWmnaatjtGZ+5qowaq1X9tlP3zX0mAwRd5zF9ZLK
         0lObLGyLtvnOBUuhyiT2vxfbsYPzbczPmr4PdB5pg9hagUYbsghKq12FOX7jU4AHjC
         /CHqv6lAprwNvDop/L0VNkoYQ01OqCPHr1O8QRKB15ba3narTc76gX+18cGcfcXnmY
         pRYYozY4VK3wg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1ol5CV-00056k-AZ; Wed, 19 Oct 2022 11:17:23 +0200
Date:   Wed, 19 Oct 2022 11:17:23 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.0 524/862] phy: qcom-qmp-pcie: fix memleak on probe
 deferral
Message-ID: <Y0/Ao3M8Ob5dvEFr@hovoldconsulting.com>
References: <20221019083249.951566199@linuxfoundation.org>
 <20221019083313.126741569@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019083313.126741569@linuxfoundation.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 10:30:11AM +0200, Greg Kroah-Hartman wrote:
> From: Johan Hovold <johan+linaro@kernel.org>
> 
> [ Upstream commit 4be26f695ffa458b065b7942dbff9393bf0836ea ]
> 
> Switch to using the device-managed of_iomap helper to avoid leaking
> memory on probe deferral and driver unbind.
> 
> Note that this helper checks for already reserved regions and may fail
> if there are multiple devices claiming the same memory.

In case of a malformed dts, the above new check can prevent the driver
from binding. Fixing tiny memory leaks on driver unbind does not
outweigh that risk and, again, the stable tag was left out on purpose.

Please drop.

> Fixes: e78f3d15e115 ("phy: qcom-qmp: new qmp phy driver for qcom-chipsets")
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> Link: https://lore.kernel.org/r/20220916102340.11520-3-johan+linaro@kernel.org
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/phy/qualcomm/phy-qcom-qmp-pcie.c | 34 ++++++++++++------------
>  1 file changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
> index 0e0f2482827a..819bcd975ba4 100644
> --- a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
> +++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
> @@ -2329,17 +2329,17 @@ int qcom_qmp_phy_pcie_create(struct device *dev, struct device_node *np, int id,
>  	 * For dual lane PHYs: tx2 -> 3, rx2 -> 4, pcs_misc (optional) -> 5
>  	 * For single lane PHYs: pcs_misc (optional) -> 3.
>  	 */
> -	qphy->tx = of_iomap(np, 0);
> -	if (!qphy->tx)
> -		return -ENOMEM;
> +	qphy->tx = devm_of_iomap(dev, np, 0, NULL);
> +	if (IS_ERR(qphy->tx))
> +		return PTR_ERR(qphy->tx);
>  
> -	qphy->rx = of_iomap(np, 1);
> -	if (!qphy->rx)
> -		return -ENOMEM;
> +	qphy->rx = devm_of_iomap(dev, np, 1, NULL);
> +	if (IS_ERR(qphy->rx))
> +		return PTR_ERR(qphy->rx);
>  
> -	qphy->pcs = of_iomap(np, 2);
> -	if (!qphy->pcs)
> -		return -ENOMEM;
> +	qphy->pcs = devm_of_iomap(dev, np, 2, NULL);
> +	if (IS_ERR(qphy->pcs))
> +		return PTR_ERR(qphy->pcs);
>  
>  	/*
>  	 * If this is a dual-lane PHY, then there should be registers for the
> @@ -2348,9 +2348,9 @@ int qcom_qmp_phy_pcie_create(struct device *dev, struct device_node *np, int id,
>  	 * offset from the first lane.
>  	 */
>  	if (cfg->is_dual_lane_phy) {
> -		qphy->tx2 = of_iomap(np, 3);
> -		qphy->rx2 = of_iomap(np, 4);
> -		if (!qphy->tx2 || !qphy->rx2) {
> +		qphy->tx2 = devm_of_iomap(dev, np, 3, NULL);
> +		qphy->rx2 = devm_of_iomap(dev, np, 4, NULL);
> +		if (IS_ERR(qphy->tx2) || IS_ERR(qphy->rx2)) {
>  			dev_warn(dev,
>  				 "Underspecified device tree, falling back to legacy register regions\n");
>  
> @@ -2360,20 +2360,20 @@ int qcom_qmp_phy_pcie_create(struct device *dev, struct device_node *np, int id,
>  			qphy->rx2 = qphy->rx + QMP_PHY_LEGACY_LANE_STRIDE;
>  
>  		} else {
> -			qphy->pcs_misc = of_iomap(np, 5);
> +			qphy->pcs_misc = devm_of_iomap(dev, np, 5, NULL);
>  		}
>  
>  	} else {
> -		qphy->pcs_misc = of_iomap(np, 3);
> +		qphy->pcs_misc = devm_of_iomap(dev, np, 3, NULL);
>  	}
>  
> -	if (!qphy->pcs_misc &&
> +	if (IS_ERR(qphy->pcs_misc) &&
>  	    of_device_is_compatible(dev->of_node, "qcom,ipq6018-qmp-pcie-phy"))
>  		qphy->pcs_misc = qphy->pcs + 0x400;
>  
> -	if (!qphy->pcs_misc) {
> +	if (IS_ERR(qphy->pcs_misc)) {
>  		if (cfg->pcs_misc_tbl || cfg->pcs_misc_tbl_sec)
> -			return -EINVAL;
> +			return PTR_ERR(qphy->pcs_misc);
>  	}
>  
>  	snprintf(prop_name, sizeof(prop_name), "pipe%d", id);

Johan
