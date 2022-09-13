Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 967755B738D
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235355AbiIMPGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234874AbiIMPEy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:04:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D4465802;
        Tue, 13 Sep 2022 07:30:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07DEEB80F99;
        Tue, 13 Sep 2022 14:27:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEBDC433C1;
        Tue, 13 Sep 2022 14:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079256;
        bh=Fl2Giew66XqwbEuil+L3lWo7xPrcCZo3t0Rz+/OmeNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JQg9iZAwtSqVpesbmp016ZnFda6g92gKWDrMyk3DfIm7FadT67CIL0jm5RIgGXH5u
         Eue/URfyMdNqyal9TSEK6aSX/4PxrVvr88YM234mrIGxNsfh+BFVjVPMxtIvn4PAY0
         8aEez6jXmVf6CortbDyQWbPl+hSW6aCnJP3jBcdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>,
        stable <stable@kernel.org>,
        Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 5.4 064/108] usb: dwc3: disable USB core PHY management
Date:   Tue, 13 Sep 2022 16:06:35 +0200
Message-Id: <20220913140356.370574658@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140353.549108748@linuxfoundation.org>
References: <20220913140353.549108748@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

commit 6000b8d900cd5f52fbcd0776d0cc396e88c8c2ea upstream.

The dwc3 driver manages its PHYs itself so the USB core PHY management
needs to be disabled.

Use the struct xhci_plat_priv hack added by commits 46034a999c07 ("usb:
host: xhci-plat: add platform data support") and f768e718911e ("usb:
host: xhci-plat: add priv quirk for skip PHY initialization") to
propagate the setting for now.

Fixes: 4e88d4c08301 ("usb: add a flag to skip PHY initialization to struct usb_hcd")
Fixes: 178a0bce05cb ("usb: core: hcd: integrate the PHY wrapper into the HCD core")
Tested-by: Matthias Kaehlcke <mka@chromium.org>
Cc: stable <stable@kernel.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20220825131836.19769-1-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ johan: adjust context to 5.15 ]
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/host.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/usb/dwc3/host.c
+++ b/drivers/usb/dwc3/host.c
@@ -9,8 +9,13 @@
 
 #include <linux/platform_device.h>
 
+#include "../host/xhci-plat.h"
 #include "core.h"
 
+static const struct xhci_plat_priv dwc3_xhci_plat_priv = {
+	.quirks = XHCI_SKIP_PHY_INIT,
+};
+
 static int dwc3_host_get_irq(struct dwc3 *dwc)
 {
 	struct platform_device	*dwc3_pdev = to_platform_device(dwc->dev);
@@ -85,6 +90,11 @@ int dwc3_host_init(struct dwc3 *dwc)
 		goto err;
 	}
 
+	ret = platform_device_add_data(xhci, &dwc3_xhci_plat_priv,
+					sizeof(dwc3_xhci_plat_priv));
+	if (ret)
+		goto err;
+
 	memset(props, 0, sizeof(struct property_entry) * ARRAY_SIZE(props));
 
 	if (dwc->usb3_lpm_capable)


