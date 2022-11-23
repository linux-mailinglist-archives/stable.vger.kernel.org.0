Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 951A76358B3
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236744AbiKWKCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:02:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236832AbiKWKBC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:01:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB184509C
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:53:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F138D61B6C
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC105C433D7;
        Wed, 23 Nov 2022 09:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197194;
        bh=DzdurgrY6s4J5MLc/utmj4OMQtaOkNdIs2TXiFiM0Pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LKt1jqzcBSojDkzDVNEREH9XEhdHOW5otyfj1zxQeJwn4Mp5QlX5kf+CequH78HEc
         bGJAqatuV8kdT6BvltsO2wSxzpTHjm+0KSzYEQzHT9zVDobAVIYkRSHxsi7iDmwZsV
         qqrYIsYtxzh8CT+rl1P/68TYfkqLNLzg6bWO1M/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stefan Agner <stefan@agner.ch>,
        Johan Hovold <johan+linaro@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.0 224/314] Revert "usb: dwc3: disable USB core PHY management"
Date:   Wed, 23 Nov 2022 09:51:09 +0100
Message-Id: <20221123084635.675105859@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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
@@ -11,13 +11,8 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 
-#include "../host/xhci-plat.h"
 #include "core.h"
 
-static const struct xhci_plat_priv dwc3_xhci_plat_priv = {
-	.quirks = XHCI_SKIP_PHY_INIT,
-};
-
 static void dwc3_host_fill_xhci_irq_res(struct dwc3 *dwc,
 					int irq, char *name)
 {
@@ -97,11 +92,6 @@ int dwc3_host_init(struct dwc3 *dwc)
 		goto err;
 	}
 
-	ret = platform_device_add_data(xhci, &dwc3_xhci_plat_priv,
-					sizeof(dwc3_xhci_plat_priv));
-	if (ret)
-		goto err;
-
 	memset(props, 0, sizeof(struct property_entry) * ARRAY_SIZE(props));
 
 	if (dwc->usb3_lpm_capable)


