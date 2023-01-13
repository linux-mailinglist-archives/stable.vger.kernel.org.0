Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A155669029
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 09:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbjAMIK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 03:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235311AbjAMIKW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 03:10:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F6A6369;
        Fri, 13 Jan 2023 00:09:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DD18B81FF6;
        Fri, 13 Jan 2023 08:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171ACC433D2;
        Fri, 13 Jan 2023 08:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673597366;
        bh=zSasbgdHynKwfOjksylVPOoExRkYiM4TC878mGmgv54=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZLE/kooOpcCY4IviTNZiNIs7j0uraeKNofPA7RBDKDdYNmyEhL1+HFJD4suPSinNB
         Gf6z+TUM9sv4RYwZaVdVkN9wQjY3ijOPi1EkL0qhnaxC/KD5JU7Vl1rBhOKOtyc1ar
         2nxSLE+B1V5sW36DZRU8EZx0OfuUHnI3WAkeUBiHLx1PQvQKYU5L/LnrxQJnUm27Ul
         KDUhocgTlb7MXFjLZe3xt53e9MNZ7MnB1iejurVLHaWpwrSoR2EtGCjP1sgS/8Dbr2
         gdQzOwNYss14SHo1E418WwurqfzPdWeddGFzUfhIKzPB9puCdTfwmlq7sxh/3c4UJW
         JcTuDj4Ot78kQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pGF83-0006Nr-KU; Fri, 13 Jan 2023 09:09:35 +0100
Date:   Fri, 13 Jan 2023 09:09:35 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH 5.15.y 4/4] phy: qcom-qmp-combo: fix runtime suspend
Message-ID: <Y8ERv0712EfPJWtF@hovoldconsulting.com>
References: <20230113005405.3992011-1-swboyd@chromium.org>
 <20230113005405.3992011-5-swboyd@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113005405.3992011-5-swboyd@chromium.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 12, 2023 at 04:54:05PM -0800, Stephen Boyd wrote:
> From: Johan Hovold <johan+linaro@kernel.org>
> 
> commit c7b98de745cffdceefc077ad5cf9cda032ef8959 upstream.
> 
> Drop the confused runtime-suspend type check which effectively broke
> runtime PM if the DP child node happens to be parsed before the USB
> child node during probe (e.g. due to order of child nodes in the
> devicetree).
> 
> Instead use the new driver data USB PHY pointer to access the USB
> configuration and resources.
> 
> Fixes: 52e013d0bffa ("phy: qcom-qmp: Add support for DP in USB3+DP combo phy")
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> Link: https://lore.kernel.org/r/20221114081346.5116-6-johan+linaro@kernel.org
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> [swboyd@chromium.org: Backport to pre-split driver]
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  drivers/phy/qualcomm/phy-qcom-qmp.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
> index 9fda6d283f20..d928afe2ebba 100644
> --- a/drivers/phy/qualcomm/phy-qcom-qmp.c
> +++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
> @@ -4985,15 +4985,11 @@ static void qcom_qmp_phy_disable_autonomous_mode(struct qmp_phy *qphy)
>  static int __maybe_unused qcom_qmp_phy_runtime_suspend(struct device *dev)
>  {
>  	struct qcom_qmp *qmp = dev_get_drvdata(dev);
> -	struct qmp_phy *qphy = qmp->phys[0];
> +	struct qmp_phy *qphy = qmp->usb_phy;
>  	const struct qmp_phy_cfg *cfg = qphy->cfg;
>  
>  	dev_vdbg(dev, "Suspending QMP phy, mode:%d\n", qphy->mode);

So this doesn't work currently either as the usb_phy pointer is not set
for PCIe and UFS PHYs.

>  
> -	/* Supported only for USB3 PHY and luckily USB3 is the first phy */
> -	if (cfg->type != PHY_TYPE_USB3)
> -		return 0;
> -
>  	if (!qmp->init_count) {
>  		dev_vdbg(dev, "PHY not initialized, bailing out\n");
>  		return 0;

Johan
