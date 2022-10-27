Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 589BC60F7CD
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 14:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbiJ0Mpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 08:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235387AbiJ0Mpd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 08:45:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17CED4BD2A;
        Thu, 27 Oct 2022 05:45:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC8766229C;
        Thu, 27 Oct 2022 12:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CF5C433C1;
        Thu, 27 Oct 2022 12:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666874731;
        bh=VwK3xnv7tqr64wpARnMxEPqabn4IYyL5RaDxsRoawBs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GiogSBYXfJ0r9+KZxe55/GEemyJGjjCmHjQtUDgImzxG7bKDiuIoQwnwncIu5fRmA
         Vdgw8qZtdKPbF7cVmPqsTiXrY1hNfQgyjzM7r1xCXqi9T5u2DURIO1fwD7KIXred9x
         N8hwc7uVYVimOc+gQ3HgHg0JEboeKXr/FOtGSVvAUGmFFaU1BvWhiNYlH+QTtcRiuu
         97ykirTvwKbSF9pN1tyHyQwAv0dJk14Swxl/jDkawtwEniTwdVK88tO2pNQ6MZ4E5t
         nkqBtV8ZqTMxaqzwEIMBQ4A+zd4G9ShWctrswDE0x4DFzpj1y7p/8Ff39RjAaDj2MP
         OGtFcy8N1TNEA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oo2G3-0007iP-Cb; Thu, 27 Oct 2022 14:45:16 +0200
Date:   Thu, 27 Oct 2022 14:45:15 +0200
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
Message-ID: <Y1p9Wy9w5umMBC4V@hovoldconsulting.com>
References: <20220906120702.19219-1-johan@kernel.org>
 <20220906120702.19219-4-johan@kernel.org>
 <808bdba846bb60456adf10a3016911ee@agner.ch>
 <Y0+8dKESygFunXOu@hovoldconsulting.com>
 <86c0f1ee8ffc94f9a53690dda6a83fbb@agner.ch>
 <Y1JCIKT80P9IysKD@hovoldconsulting.com>
 <b2a1e70bda64cb741efe81c5b7e56707@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2a1e70bda64cb741efe81c5b7e56707@agner.ch>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 26, 2022 at 03:11:00PM +0200, Stefan Agner wrote:
> On 2022-10-21 08:54, Johan Hovold wrote:
> > On Fri, Oct 21, 2022 at 12:06:12AM +0200, Stefan Agner wrote:
> >> On 2022-10-19 10:59, Johan Hovold wrote:
> >> > On Tue, Oct 18, 2022 at 05:27:24PM +0200, Stefan Agner wrote:
> >> >> On 2022-09-06 14:07, Johan Hovold wrote:
> >> >> > From: Johan Hovold <johan+linaro@kernel.org>
> >> >> >
> >> >> > commit 6000b8d900cd5f52fbcd0776d0cc396e88c8c2ea upstream.
> >> >> >
> >> >> > The dwc3 driver manages its PHYs itself so the USB core PHY management
> >> >> > needs to be disabled.
> >> >> >
> >> >> > Use the struct xhci_plat_priv hack added by commits 46034a999c07 ("usb:
> >> >> > host: xhci-plat: add platform data support") and f768e718911e ("usb:
> >> >> > host: xhci-plat: add priv quirk for skip PHY initialization") to
> >> >> > propagate the setting for now.
> > 
> >> >> For some reason, this commit seems to break detection of the USB to
> >> >> S-ATA controller on ODROID-HC1 devices (Exynos 5422).
> > 
> >> > I think this may be related to the calibration calls added to dwc3 and
> >> > later removed again by commits:
> >> >
> >> > 	d8c80bb3b55b ("phy: exynos5-usbdrd: Calibrate LOS levels for exynos5420/5800")
> >> > 	a0a465569b45 ("usb: dwc3: remove generic PHY calibrate() calls")
> >> >
> >> > The removal explicitly mentions that the expectation is that USB core
> >> > will do the PHY calibration.
> >> >
> >> > There could be other changes in the sequencing of events that this
> >> > platform has been implicitly relying on, but as a start, could try
> >> > adding the missing calibration calls (patch below) and see if that makes a
> >> > difference?
> >> 
> >> The patch below did not apply to 5.15.74 directly, but I think I was
> >> able to get the corrected patch applied (see below)

> The user reports the S-ATA disk is *not* recognized with that patch
> applied.

I just noticed a mistake in the instrumentation patch I sent you. Could
you try moving the calibrations calls after dwc3_host_init() (e.g. as in
the second chunk in the diff below)?

As mentioned in the commit message for a0a465569b45 ("usb: dwc3: remove
generic PHY calibrate() calls"), this may not work if the xhci-plat
driver is built as a module and there are some corner cases that it does
not cover.

It seems we should revert the offending commit and then try to find some
time to untangle this mess, but please check if the below addresses the
issue first so we know what the problem is.

I'll prepare a revert in the meantime.

Johan


diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 31156d4dec9f..37d49a394912 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -197,6 +197,8 @@ static void __dwc3_set_mode(struct work_struct *work)
                                otg_set_vbus(dwc->usb2_phy->otg, true);
                        phy_set_mode(dwc->usb2_generic_phy, PHY_MODE_USB_HOST);
                        phy_set_mode(dwc->usb3_generic_phy, PHY_MODE_USB_HOST);
+                       phy_calibrate(dwc->usb2_generic_phy);
+                       phy_calibrate(dwc->usb3_generic_phy);
                        if (dwc->dis_split_quirk) {
                                reg = dwc3_readl(dwc->regs, DWC3_GUCTL3);
                                reg |= DWC3_GUCTL3_SPLITDISABLE;
@@ -1391,6 +1393,9 @@ static int dwc3_core_init_mode(struct dwc3 *dwc)
                ret = dwc3_host_init(dwc);
                if (ret)
                        return dev_err_probe(dev, ret, "failed to initialize host\n");
+
+               phy_calibrate(dwc->usb2_generic_phy);
+               phy_calibrate(dwc->usb3_generic_phy);
                break;
        case USB_DR_MODE_OTG:
                INIT_WORK(&dwc->drd_work, __dwc3_set_mode);
