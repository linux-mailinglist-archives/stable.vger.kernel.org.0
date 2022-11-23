Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C307C63555A
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237393AbiKWJR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:17:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237451AbiKWJQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:16:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43A7107E79
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:16:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BA2DB81EF5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81E1C433C1;
        Wed, 23 Nov 2022 09:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194991;
        bh=wbXfRZVTjH/i5QxGGaPKDOz1HOqWrlVg/c9gTEMXxDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/FnCM16fBpde/6UegAdpDz25Yk++bS9/d52WlcUE6tj2rFSEIiNX+E/9YJMQBI57
         FFUwwX4mazMWf8HQhS3joU9HdT6K6n56ew4ipv9ae03yjTaP/hjYsMGLyULx1qun0o
         xYhw0wV01mqeCwtjbQoxk7PSENUk2Q2lcUYWuav0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stefan Agner <stefan@agner.ch>,
        Johan Hovold <johan+linaro@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.4 116/156] Revert "usb: dwc3: disable USB core PHY management"
Date:   Wed, 23 Nov 2022 09:51:13 +0100
Message-Id: <20221123084602.148126300@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

commit 5c294de36e7fb3e0cba0c4e1ef9a5f57bc080d0f upstream.

This reverts commit 6000b8d900cd5f52fbcd0776d0cc396e88c8c2ea.

The offending commit disabled the USB core PHY management as the dwc3
already manages the PHYs in question.

Unfortunately some platforms have started relying on having USB core
also controlling the PHY and this is specifically currently needed on
some Exynos platforms for PHY calibration or connected device may fail
to enumerate.

The PHY calibration was previously handled in the dwc3 driver, but to
work around some issues related to how the dwc3 driver interacts with
xhci (e.g. using multiple drivers) this was moved to USB core by commits
34c7ed72f4f0 ("usb: core: phy: add support for PHY calibration") and
a0a465569b45 ("usb: dwc3: remove generic PHY calibrate() calls").

The same PHY obviously should not be controlled from two different
places, which for example do no agree on the PHY mode or power state
during suspend, but as the offending patch was backported to stable,
let's revert it for now.

Reported-by: Stefan Agner <stefan@agner.ch>
Link: https://lore.kernel.org/lkml/808bdba846bb60456adf10a3016911ee@agner.ch/
Fixes: 6000b8d900cd ("usb: dwc3: disable USB core PHY management")
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20221103144648.14197-1-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/host.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/drivers/usb/dwc3/host.c
+++ b/drivers/usb/dwc3/host.c
@@ -9,13 +9,8 @@
 
 #include <linux/platform_device.h>
 
-#include "../host/xhci-plat.h"
 #include "core.h"
 
-static const struct xhci_plat_priv dwc3_xhci_plat_priv = {
-	.quirks = XHCI_SKIP_PHY_INIT,
-};
-
 static int dwc3_host_get_irq(struct dwc3 *dwc)
 {
 	struct platform_device	*dwc3_pdev = to_platform_device(dwc->dev);
@@ -90,11 +85,6 @@ int dwc3_host_init(struct dwc3 *dwc)
 		goto err;
 	}
 
-	ret = platform_device_add_data(xhci, &dwc3_xhci_plat_priv,
-					sizeof(dwc3_xhci_plat_priv));
-	if (ret)
-		goto err;
-
 	memset(props, 0, sizeof(struct property_entry) * ARRAY_SIZE(props));
 
 	if (dwc->usb3_lpm_capable)


