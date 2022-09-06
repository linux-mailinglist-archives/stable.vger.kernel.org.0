Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4BE5AE662
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 13:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238774AbiIFLVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 07:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbiIFLV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 07:21:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470BE32B8B
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 04:21:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07636B81694
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 11:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA83C433D6;
        Tue,  6 Sep 2022 11:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662463285;
        bh=QKeq8wyejEWxxXGcIv88eWbigrEX5zLT5c4wTeWXPUE=;
        h=Subject:To:Cc:From:Date:From;
        b=yV9dlw8zUo9ginvSTqGpzF+ICCDJCFfq+k3jOpmLCd//tyYOEpb86ngr+WwMH8GaX
         4przGp3h//zQdBpP4O3/5Aphr4OXFL8nfOfC+1rdnjGWUAqWMY/SPufrbOOkfH1O8f
         c8Jb6z/RnIEKhMCdiEDaveAb0LUcqOZGAVvPK1WA=
Subject: FAILED: patch "[PATCH] usb: dwc3: disable USB core PHY management" failed to apply to 5.10-stable tree
To:     johan+linaro@kernel.org, gregkh@linuxfoundation.org,
        mka@chromium.org, stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 06 Sep 2022 13:21:14 +0200
Message-ID: <166246327419781@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6000b8d900cd5f52fbcd0776d0cc396e88c8c2ea Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan+linaro@kernel.org>
Date: Thu, 25 Aug 2022 15:18:36 +0200
Subject: [PATCH] usb: dwc3: disable USB core PHY management

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

diff --git a/drivers/usb/dwc3/host.c b/drivers/usb/dwc3/host.c
index f6f13e7f1ba1..a7154fe8206d 100644
--- a/drivers/usb/dwc3/host.c
+++ b/drivers/usb/dwc3/host.c
@@ -11,8 +11,13 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 
+#include "../host/xhci-plat.h"
 #include "core.h"
 
+static const struct xhci_plat_priv dwc3_xhci_plat_priv = {
+	.quirks = XHCI_SKIP_PHY_INIT,
+};
+
 static void dwc3_host_fill_xhci_irq_res(struct dwc3 *dwc,
 					int irq, char *name)
 {
@@ -92,6 +97,11 @@ int dwc3_host_init(struct dwc3 *dwc)
 		goto err;
 	}
 
+	ret = platform_device_add_data(xhci, &dwc3_xhci_plat_priv,
+					sizeof(dwc3_xhci_plat_priv));
+	if (ret)
+		goto err;
+
 	memset(props, 0, sizeof(struct property_entry) * ARRAY_SIZE(props));
 
 	if (dwc->usb3_lpm_capable)

