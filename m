Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45AE06041E2
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbiJSKuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234471AbiJSKtK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:49:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384F312B34A;
        Wed, 19 Oct 2022 03:21:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EB3AB8244E;
        Wed, 19 Oct 2022 08:59:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE96EC433B5;
        Wed, 19 Oct 2022 08:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666169985;
        bh=ihGyUt66Xn5KkFVt2Ai5BlSmYAVmRhdfjWNm29R+RKM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WgUIMkYXmrYHZYC5wNczTProIVvFgcTKLWvQoHvRYHczvvPDg3rPnIBK7LzVmcE0n
         j2sWIpfaVOEez9QWrG3LbCZPn93/Z04LqPG+u6K4AjSGXT0dZhLC7iBmyQ1DvpCj8J
         aIlv/opynJ1eOvPJ9K4LLOXUrHBG2lt9e1cQvnVehAPKBdcaKc1HL2Ir+IF5zgSzeH
         nNEtrZjNjMOtD+XJSBiJucdgoFWP2WRI3gejTzHIRzWTGW6p6cv5w+BrjPJoHuUL2/
         QCfTZNU2whkEHUSEriBe7WBqf7wYu/CxIa9umei+JScUpMvYNN0TOFwd/DNjr2246H
         dS74ZGvaFkXYw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1ol4vE-0004up-Tj; Wed, 19 Oct 2022 10:59:33 +0200
Date:   Wed, 19 Oct 2022 10:59:32 +0200
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
Message-ID: <Y0+8dKESygFunXOu@hovoldconsulting.com>
References: <20220906120702.19219-1-johan@kernel.org>
 <20220906120702.19219-4-johan@kernel.org>
 <808bdba846bb60456adf10a3016911ee@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <808bdba846bb60456adf10a3016911ee@agner.ch>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 18, 2022 at 05:27:24PM +0200, Stefan Agner wrote:
> Hi Johan,
> 
> On 2022-09-06 14:07, Johan Hovold wrote:
> > From: Johan Hovold <johan+linaro@kernel.org>
> > 
> > commit 6000b8d900cd5f52fbcd0776d0cc396e88c8c2ea upstream.
> > 
> > The dwc3 driver manages its PHYs itself so the USB core PHY management
> > needs to be disabled.
> > 
> > Use the struct xhci_plat_priv hack added by commits 46034a999c07 ("usb:
> > host: xhci-plat: add platform data support") and f768e718911e ("usb:
> > host: xhci-plat: add priv quirk for skip PHY initialization") to
> > propagate the setting for now.
> 
> [adding also Samsung/ODROID device tree authors Krzysztof and Marek]
> 
> For some reason, this commit seems to break detection of the USB to
> S-ATA controller on ODROID-HC1 devices (Exynos 5422).
> 
> We have a known to work OS release of v5.15.60, and known to not be
> working of v5.15.67. By reverting suspicious commits, I was able to
> pinpoint the problem to this particular commit.
> 
> From what I understand, on that particular hardware the S-ATA controller
> power is controlled via the V-BUS signal VBUSCTRL_U2 (Schematic [1]).
> Presumably this signal is no longer controlled with this change.
> 
> This came up in our HAOS issue #2153 [2].

Thanks for the report and sorry about the breakage. This wasn't supposed
to go to stable but Greg thought otherwise (and I helped with the
backporting to prevent autosel from pulling in even more changes).

But at least this way we found out sooner that this platform depends on
having both USB core and dwc3 managing the same PHY.

I think this may be related to the calibration calls added to dwc3 and
later removed again by commits:

	d8c80bb3b55b ("phy: exynos5-usbdrd: Calibrate LOS levels for exynos5420/5800")
	a0a465569b45 ("usb: dwc3: remove generic PHY calibrate() calls")

The removal explicitly mentions that the expectation is that USB core
will do the PHY calibration.

There could be other changes in the sequencing of events that this
platform has been implicitly relying on, but as a start, could try
adding the missing calibration calls (patch below) and see if that makes a
difference?

Johan


diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 46cf8edf7f93..f8a0e340eb63 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -198,6 +198,8 @@ static void __dwc3_set_mode(struct work_struct *work)
                                otg_set_vbus(dwc->usb2_phy->otg, true);
                        phy_set_mode(dwc->usb2_generic_phy, PHY_MODE_USB_HOST);
                        phy_set_mode(dwc->usb3_generic_phy, PHY_MODE_USB_HOST);
+                       phy_calibrate(dwc->usb2_generic_phy);
+                       phy_calibrate(dwc->usb3_generic_phy);
                        if (dwc->dis_split_quirk) {
                                reg = dwc3_readl(dwc->regs, DWC3_GUCTL3);
                                reg |= DWC3_GUCTL3_SPLITDISABLE;
@@ -1369,6 +1371,8 @@ static int dwc3_core_init_mode(struct dwc3 *dwc)
                        otg_set_vbus(dwc->usb2_phy->otg, true);
                phy_set_mode(dwc->usb2_generic_phy, PHY_MODE_USB_HOST);
                phy_set_mode(dwc->usb3_generic_phy, PHY_MODE_USB_HOST);
+               phy_calibrate(dwc->usb2_generic_phy);
+               phy_calibrate(dwc->usb3_generic_phy);
 
                ret = dwc3_host_init(dwc);
                if (ret)
