Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0796CC33F
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233530AbjC1Owb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232888AbjC1OwP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:52:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C78DCDC0
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:52:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E742CB81D72
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:52:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3840CC433D2;
        Tue, 28 Mar 2023 14:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015121;
        bh=tG20YixPuNghNz3iwWiDToG04WFpYWr1dNhJyvgw0ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wFOBrvW55QlUG8pOL3OtQ0g4iQqOjF8nimw948qpVf9T/HEOhAeH4fDUCF3R7hmmV
         0szDdIBL5yJpErLHrOwcT1sy45ftlC0h6+heQrSrzIb9baRvMXD1N6wCwN2SJ6BfA7
         WKxI4cOxHIMJZ1xgML+JEqyulbFwNleFEMM4o3dY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Quentin Schulz <quentin.schulz@theobroma-systems.com>
Subject: [PATCH 6.2 174/240] usb: dwc2: fix a race, dont power off/on phy for dual-role mode
Date:   Tue, 28 Mar 2023 16:42:17 +0200
Message-Id: <20230328142626.881393183@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>

commit 5021383242ada277a38bd052a4c12ed4707faccb upstream.

When in dual role mode (dr_mode == USB_DR_MODE_OTG), platform probe
successively basically calls:
- dwc2_gadget_init()
- dwc2_hcd_init()
- dwc2_lowlevel_hw_disable() since recent change [1]
- usb_add_gadget_udc()

The PHYs (and so the clocks it may provide) shouldn't be disabled for all
SoCs, in OTG mode, as the HCD part has been initialized.

On STM32 this creates some weird race condition upon boot, when:
- initially attached as a device, to a HOST
- and there is a gadget script invoked to setup the device part.
Below issue becomes systematic, as long as the gadget script isn't
started by userland: the hardware PHYs (and so the clocks provided by the
PHYs) remains disabled.
It ends up in having an endless interrupt storm, before the watchdog
resets the platform.

[   16.924163] dwc2 49000000.usb-otg: EPs: 9, dedicated fifos, 952 entries in SPRAM
[   16.962704] dwc2 49000000.usb-otg: DWC OTG Controller
[   16.966488] dwc2 49000000.usb-otg: new USB bus registered, assigned bus number 2
[   16.974051] dwc2 49000000.usb-otg: irq 77, io mem 0x49000000
[   17.032170] hub 2-0:1.0: USB hub found
[   17.042299] hub 2-0:1.0: 1 port detected
[   17.175408] dwc2 49000000.usb-otg: Mode Mismatch Interrupt: currently in Host mode
[   17.181741] dwc2 49000000.usb-otg: Mode Mismatch Interrupt: currently in Host mode
[   17.189303] dwc2 49000000.usb-otg: Mode Mismatch Interrupt: currently in Host mode
...

The host part is also not functional, until the gadget part is configured.

The HW may only be disabled for peripheral mode (original init), e.g.
dr_mode == USB_DR_MODE_PERIPHERAL, until the gadget driver initializes.

But when in USB_DR_MODE_OTG, the HW should remain enabled, as the HCD part
is able to run, while the gadget part isn't necessarily configured.

I don't fully get the of purpose the original change, that claims disabling
the hardware is missing. It creates conditions on SOCs using the PHY
initialization to be completely non working in OTG mode. Original
change [1] should be reworked to be platform specific.

[1] https://lore.kernel.org/r/20221206-dwc2-gadget-dual-role-v1-2-36515e1092cd@theobroma-systems.com

Fixes: ade23d7b7ec5 ("usb: dwc2: power on/off phy for peripheral mode in dual-role mode")
Cc: stable <stable@kernel.org>
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Reviewed-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Tested-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Link: https://lore.kernel.org/r/20230315144433.3095859-1-fabrice.gasnier@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/gadget.c   |    6 ++----
 drivers/usb/dwc2/platform.c |    3 +--
 2 files changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -4549,8 +4549,7 @@ static int dwc2_hsotg_udc_start(struct u
 	hsotg->gadget.dev.of_node = hsotg->dev->of_node;
 	hsotg->gadget.speed = USB_SPEED_UNKNOWN;
 
-	if (hsotg->dr_mode == USB_DR_MODE_PERIPHERAL ||
-	    (hsotg->dr_mode == USB_DR_MODE_OTG && dwc2_is_device_mode(hsotg))) {
+	if (hsotg->dr_mode == USB_DR_MODE_PERIPHERAL) {
 		ret = dwc2_lowlevel_hw_enable(hsotg);
 		if (ret)
 			goto err;
@@ -4612,8 +4611,7 @@ static int dwc2_hsotg_udc_stop(struct us
 	if (!IS_ERR_OR_NULL(hsotg->uphy))
 		otg_set_peripheral(hsotg->uphy->otg, NULL);
 
-	if (hsotg->dr_mode == USB_DR_MODE_PERIPHERAL ||
-	    (hsotg->dr_mode == USB_DR_MODE_OTG && dwc2_is_device_mode(hsotg)))
+	if (hsotg->dr_mode == USB_DR_MODE_PERIPHERAL)
 		dwc2_lowlevel_hw_disable(hsotg);
 
 	return 0;
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -576,8 +576,7 @@ static int dwc2_driver_probe(struct plat
 	dwc2_debugfs_init(hsotg);
 
 	/* Gadget code manages lowlevel hw on its own */
-	if (hsotg->dr_mode == USB_DR_MODE_PERIPHERAL ||
-	    (hsotg->dr_mode == USB_DR_MODE_OTG && dwc2_is_device_mode(hsotg)))
+	if (hsotg->dr_mode == USB_DR_MODE_PERIPHERAL)
 		dwc2_lowlevel_hw_disable(hsotg);
 
 #if IS_ENABLED(CONFIG_USB_DWC2_PERIPHERAL) || \


