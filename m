Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9BBC617FF8
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 15:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbiKCOuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 10:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbiKCOuU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 10:50:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91971178B6;
        Thu,  3 Nov 2022 07:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4478AB825E5;
        Thu,  3 Nov 2022 14:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFC4C433C1;
        Thu,  3 Nov 2022 14:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667487017;
        bh=erGGAZzfipqS12h8LpJ0XkEJUQ4TTQ3kwJymttn8ZjI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TWI+k+9duvC5cKwggaCdsGL+PwsmKeA6eTORr4x+hRJ/+0oM8gLhLjzt4b7K3KCxU
         eZQnCQwipDuj3ksL2Jn5SeuIrPu2V9z4G7Kta+D7M8gGyzWw6TRBlorP7uuUBM1wjp
         skBTY2iPp14RYibnIg6a4KnabbhxGv74tdsW+vckwnhu8f68md36Lo/gAPxQAeWSjE
         dhmOFCecQNJr9m+zz6/eZaJms4t23EoeukTrmN4MY2niyamOMUDpHWtts0RpjKynTv
         Wf4zyWPdMtYwflWbHUrEeHcFqqt77I/OQYEmTDumJVtlJ1B47Gao51/kWs7yttj0VB
         tVcsvjAB/brDg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oqbXb-0003jR-Od; Thu, 03 Nov 2022 15:49:59 +0100
Date:   Thu, 3 Nov 2022 15:49:59 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Stefan Agner <stefan@agner.ch>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        stable <stable@kernel.org>, regressions@lists.linux.dev,
        m.szyprowski@samsung.com, krzk@kernel.org
Subject: Re: [PATCH stable-5.15 3/3] usb: dwc3: disable USB core PHY
 management
Message-ID: <Y2PVF/IJoKvSu3SM@hovoldconsulting.com>
References: <20220906120702.19219-1-johan@kernel.org>
 <20220906120702.19219-4-johan@kernel.org>
 <808bdba846bb60456adf10a3016911ee@agner.ch>
 <Y0+8dKESygFunXOu@hovoldconsulting.com>
 <86c0f1ee8ffc94f9a53690dda6a83fbb@agner.ch>
 <Y1JCIKT80P9IysKD@hovoldconsulting.com>
 <b2a1e70bda64cb741efe81c5b7e56707@agner.ch>
 <Y1p9Wy9w5umMBC4V@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1p9Wy9w5umMBC4V@hovoldconsulting.com>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 02:45:15PM +0200, Johan Hovold wrote:
> On Wed, Oct 26, 2022 at 03:11:00PM +0200, Stefan Agner wrote:

> > The user reports the S-ATA disk is *not* recognized with that patch
> > applied.
> 
> I just noticed a mistake in the instrumentation patch I sent you. Could
> you try moving the calibrations calls after dwc3_host_init() (e.g. as in
> the second chunk in the diff below)?
> 
> As mentioned in the commit message for a0a465569b45 ("usb: dwc3: remove
> generic PHY calibrate() calls"), this may not work if the xhci-plat
> driver is built as a module and there are some corner cases that it does
> not cover.
> 
> It seems we should revert the offending commit and then try to find some
> time to untangle this mess, but please check if the below addresses the
> issue first so we know what the problem is.
> 
> I'll prepare a revert in the meantime.

I've now posted the revert, but please do check if the below patch was
enough to resolve the immediate issue.

Johan

> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index 31156d4dec9f..37d49a394912 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -197,6 +197,8 @@ static void __dwc3_set_mode(struct work_struct *work)
>                                 otg_set_vbus(dwc->usb2_phy->otg, true);
>                         phy_set_mode(dwc->usb2_generic_phy, PHY_MODE_USB_HOST);
>                         phy_set_mode(dwc->usb3_generic_phy, PHY_MODE_USB_HOST);
> +                       phy_calibrate(dwc->usb2_generic_phy);
> +                       phy_calibrate(dwc->usb3_generic_phy);
>                         if (dwc->dis_split_quirk) {
>                                 reg = dwc3_readl(dwc->regs, DWC3_GUCTL3);
>                                 reg |= DWC3_GUCTL3_SPLITDISABLE;
> @@ -1391,6 +1393,9 @@ static int dwc3_core_init_mode(struct dwc3 *dwc)
>                 ret = dwc3_host_init(dwc);
>                 if (ret)
>                         return dev_err_probe(dev, ret, "failed to initialize host\n");
> +
> +               phy_calibrate(dwc->usb2_generic_phy);
> +               phy_calibrate(dwc->usb3_generic_phy);
>                 break;
>         case USB_DR_MODE_OTG:
>                 INIT_WORK(&dwc->drd_work, __dwc3_set_mode);
