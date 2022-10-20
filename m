Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF52606AF4
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 00:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiJTWGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 18:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiJTWGQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 18:06:16 -0400
Received: from mail.kmu-office.ch (mail.kmu-office.ch [IPv6:2a02:418:6a02::a2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74E16BD4B;
        Thu, 20 Oct 2022 15:06:14 -0700 (PDT)
Received: from webmail.kmu-office.ch (unknown [IPv6:2a02:418:6a02::a3])
        by mail.kmu-office.ch (Postfix) with ESMTPSA id 299DE5C30AD;
        Fri, 21 Oct 2022 00:06:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=agner.ch; s=dkim;
        t=1666303572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=25JEbdq0Y8j8gnFqBm3+CF/4d87gZR/hyOWMOMAnc/c=;
        b=gtso8EpJeEaMs7yAK01uPwlTtkywecX7F/6hVe6F3Rct7iGC2sbFTRewBXxyGQjpPr4zgu
        AQaYNoSib/2UMNQvBRiGd39euBHRkNU4lnEhxgU+8NkJihsU02saxLl6KuwozAN1+81ozQ
        bsmYySA33t+jCiZmA/4qdZBNV9n4d+Q=
MIME-Version: 1.0
Date:   Fri, 21 Oct 2022 00:06:12 +0200
From:   Stefan Agner <stefan@agner.ch>
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        stable <stable@kernel.org>, regressions@lists.linux.dev,
        m.szyprowski@samsung.com, krzk@kernel.org
Subject: Re: [PATCH stable-5.15 3/3] usb: dwc3: disable USB core PHY
 management
In-Reply-To: <Y0+8dKESygFunXOu@hovoldconsulting.com>
References: <20220906120702.19219-1-johan@kernel.org>
 <20220906120702.19219-4-johan@kernel.org>
 <808bdba846bb60456adf10a3016911ee@agner.ch>
 <Y0+8dKESygFunXOu@hovoldconsulting.com>
Message-ID: <86c0f1ee8ffc94f9a53690dda6a83fbb@agner.ch>
X-Sender: stefan@agner.ch
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Johan,

On 2022-10-19 10:59, Johan Hovold wrote:
> On Tue, Oct 18, 2022 at 05:27:24PM +0200, Stefan Agner wrote:
>> Hi Johan,
>>
>> On 2022-09-06 14:07, Johan Hovold wrote:
>> > From: Johan Hovold <johan+linaro@kernel.org>
>> >
>> > commit 6000b8d900cd5f52fbcd0776d0cc396e88c8c2ea upstream.
>> >
>> > The dwc3 driver manages its PHYs itself so the USB core PHY management
>> > needs to be disabled.
>> >
>> > Use the struct xhci_plat_priv hack added by commits 46034a999c07 ("usb:
>> > host: xhci-plat: add platform data support") and f768e718911e ("usb:
>> > host: xhci-plat: add priv quirk for skip PHY initialization") to
>> > propagate the setting for now.
>>
>> [adding also Samsung/ODROID device tree authors Krzysztof and Marek]
>>
>> For some reason, this commit seems to break detection of the USB to
>> S-ATA controller on ODROID-HC1 devices (Exynos 5422).
>>
>> We have a known to work OS release of v5.15.60, and known to not be
>> working of v5.15.67. By reverting suspicious commits, I was able to
>> pinpoint the problem to this particular commit.
>>
>> From what I understand, on that particular hardware the S-ATA controller
>> power is controlled via the V-BUS signal VBUSCTRL_U2 (Schematic [1]).
>> Presumably this signal is no longer controlled with this change.
>>
>> This came up in our HAOS issue #2153 [2].
> 
> Thanks for the report and sorry about the breakage. This wasn't supposed
> to go to stable but Greg thought otherwise (and I helped with the
> backporting to prevent autosel from pulling in even more changes).
> 
> But at least this way we found out sooner that this platform depends on
> having both USB core and dwc3 managing the same PHY.
> 
> I think this may be related to the calibration calls added to dwc3 and
> later removed again by commits:
> 
> 	d8c80bb3b55b ("phy: exynos5-usbdrd: Calibrate LOS levels for exynos5420/5800")
> 	a0a465569b45 ("usb: dwc3: remove generic PHY calibrate() calls")
> 
> The removal explicitly mentions that the expectation is that USB core
> will do the PHY calibration.
> 
> There could be other changes in the sequencing of events that this
> platform has been implicitly relying on, but as a start, could try
> adding the missing calibration calls (patch below) and see if that makes a
> difference?

The patch below did not apply to 5.15.74 directly, but I think I was
able to get the corrected patch applied (see below)

That said, I do not have direct access to that hardware, but I created a
build and asked the user test it.

Best regards,
Stefan

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index c32ca691bcc7..964f512603ec 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -196,6 +196,8 @@ static void __dwc3_set_mode(struct work_struct
*work)
                                otg_set_vbus(dwc->usb2_phy->otg, true);
                        phy_set_mode(dwc->usb2_generic_phy,
PHY_MODE_USB_HOST);
                        phy_set_mode(dwc->usb3_generic_phy,
PHY_MODE_USB_HOST);
+                       phy_calibrate(dwc->usb2_generic_phy);
+                       phy_calibrate(dwc->usb3_generic_phy);
                        if (dwc->dis_split_quirk) {
                                reg = dwc3_readl(dwc->regs,
DWC3_GUCTL3);
                                reg |= DWC3_GUCTL3_SPLITDISABLE;
@@ -1227,6 +1229,8 @@ static int dwc3_core_init_mode(struct dwc3 *dwc)
                        otg_set_vbus(dwc->usb2_phy->otg, true);
                phy_set_mode(dwc->usb2_generic_phy, PHY_MODE_USB_HOST);
                phy_set_mode(dwc->usb3_generic_phy, PHY_MODE_USB_HOST);
+               phy_calibrate(dwc->usb2_generic_phy);
+               phy_calibrate(dwc->usb3_generic_phy);
 
                ret = dwc3_host_init(dwc);
                if (ret)



--
Stefan

