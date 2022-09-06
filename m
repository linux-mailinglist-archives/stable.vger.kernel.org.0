Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA40E5AE735
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 14:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237958AbiIFMHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 08:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237950AbiIFMHO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 08:07:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77E072EEE;
        Tue,  6 Sep 2022 05:07:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 399EBB817C2;
        Tue,  6 Sep 2022 12:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CE5C433D7;
        Tue,  6 Sep 2022 12:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662466027;
        bh=xDToHq5NwCY7n27E7K90MiH8cQCQzp7YqE+8PvSjgOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=alkw36V4w9CuDxib9kT9NJ+3zt7Nh14WTfslB4ICMxmvBEGGBypZWIFgisQf37Dpl
         vH663SlyfcDGoG2Vtiz1yBVRVh5pAmGn0ZeRO9dEfJAEozGMdu4RnqiYbRtl0MxWpB
         T9NSf7pOGRc/e528CbK/1ZCNZa6sfqoyFf9NgkOOfxCgyda6OtQLKxHBQajYbVMJBT
         UvFabFcNQ0ZlFE22qgnbGTlqUbQuN7vuah8Wy6txP5OaZUL5TdrTKfZKcU9Zaf4g/5
         QI/92XmZnjSX8IjB00fLG+WjX1zyYX5ir74wBp5c4ShECqU6R9jnCVOh5CVmKbbvgL
         b9GlF4cZnWaBQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oVXMF-00050M-53; Tue, 06 Sep 2022 14:07:11 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        stable <stable@kernel.org>
Subject: [PATCH stable-5.15 3/3] usb: dwc3: disable USB core PHY management
Date:   Tue,  6 Sep 2022 14:07:02 +0200
Message-Id: <20220906120702.19219-4-johan@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220906120702.19219-1-johan@kernel.org>
References: <20220906120702.19219-1-johan@kernel.org>
MIME-Version: 1.0
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
---
 drivers/usb/dwc3/host.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/usb/dwc3/host.c b/drivers/usb/dwc3/host.c
index 2078e9d70292..85165a972076 100644
--- a/drivers/usb/dwc3/host.c
+++ b/drivers/usb/dwc3/host.c
@@ -10,8 +10,13 @@
 #include <linux/acpi.h>
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
@@ -87,6 +92,11 @@ int dwc3_host_init(struct dwc3 *dwc)
 		goto err;
 	}
 
+	ret = platform_device_add_data(xhci, &dwc3_xhci_plat_priv,
+					sizeof(dwc3_xhci_plat_priv));
+	if (ret)
+		goto err;
+
 	memset(props, 0, sizeof(struct property_entry) * ARRAY_SIZE(props));
 
 	if (dwc->usb3_lpm_capable)
-- 
2.35.1

