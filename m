Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85C74677981
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 11:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbjAWKsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 05:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbjAWKsK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 05:48:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D375FF9;
        Mon, 23 Jan 2023 02:48:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4B1C60E0B;
        Mon, 23 Jan 2023 10:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258D5C433D2;
        Mon, 23 Jan 2023 10:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674470885;
        bh=EbLSIJ6i7GwOGSxdBHyoeaEaC1aW5LUNC5uFiJBWGnU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cIgFONB7UJzp6T7unbq7UlEXNzP75qAszNGO4XIUgVjcV6cuLqfnfLJCZU8JLYghR
         BMGZtEW3XGI1T3ACINn33srDA8IIkp0MS0d6Oy0DUJNXHLgvDjYL3OCBeK/qJXcrh8
         7wvvHels/bUJ2ddBWVIGRpSBEBXcRLOkdFA0bEfrI8Vcsu0ZEcZMOKyE2sKvuFDteX
         Vl/FYVrF0XJ4udBC/2/vmY9mZNyCJepoRDyGBQa0vb09AHetZS+pZe4UOS9MILNENq
         cb/HnqnPz4/iLIv8V6rPwEYyfTgb4ktV6fHmXEtwxGKIBG8QHzXqrKQjH+GIEHM/7Y
         cQ4b9fTghZe7Q==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pJuMr-0000wR-Pj; Mon, 23 Jan 2023 11:48:02 +0100
Date:   Mon, 23 Jan 2023 11:48:01 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH 5.15.y v2 5/5] phy: qcom-qmp-combo: fix runtime suspend
Message-ID: <Y85l4aQmEW0iOHHa@hovoldconsulting.com>
References: <20230113204548.578798-1-swboyd@chromium.org>
 <20230113204548.578798-6-swboyd@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113204548.578798-6-swboyd@chromium.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 13, 2023 at 12:45:48PM -0800, Stephen Boyd wrote:
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
> index b8646eaf1767..64a42e28e99f 100644
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
>  
> -	/* Supported only for USB3 PHY and luckily USB3 is the first phy */
> -	if (cfg->type != PHY_TYPE_USB3)
> -		return 0;

This is still not correct as this code would now be executed also for
PCIe and UFS PHYs, which wasn't the case before.

> -
>  	if (!qmp->init_count) {
>  		dev_vdbg(dev, "PHY not initialized, bailing out\n");
>  		return 0;

Johan
