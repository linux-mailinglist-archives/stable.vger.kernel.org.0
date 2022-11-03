Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83720617FEB
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 15:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiKCOrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 10:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbiKCOrU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 10:47:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813A35FBF;
        Thu,  3 Nov 2022 07:47:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C37161EE9;
        Thu,  3 Nov 2022 14:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771DDC433D6;
        Thu,  3 Nov 2022 14:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667486838;
        bh=gbhpvtSXD4DQTboOw5UHAA7/5MJ3F47V20HOCICIiuA=;
        h=From:To:Cc:Subject:Date:From;
        b=f1mm6nrTbYcNw48+CiauaGuSzi3B9+xhtrqQI8lQcVKE3OqmZtM/6hhyo1gWqeVFP
         HfuxAvnf4cv8zaUllKGJ8YNqKALnk0qVbtlxzZx+3ZcTtrYsjVMY7FdEd6c6C0eJOZ
         ZLATaxLjPLJvz/I56s6CVsYwPY97FKKLMWuefncj3yDKEESNpsoPji6iikyUh63Z9q
         3C5ZB6t/DbNZ9tnvMFoHIUFjz5RrWx2c02QlKZ1SlEj0QNaWs22Q4Vc8dBD1hN/sIg
         HgcXYWueX3Jv8qRqAw327RTnqgsQkA9ZcymjR/df0WvSPnGoo4WihRolV9OM1hucm+
         XBDs2UzbCDaaw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1oqbUj-0003hD-4H; Thu, 03 Nov 2022 15:47:01 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Stefan Agner <stefan@agner.ch>, stable@vger.kernel.org
Subject: [PATCH] Revert "usb: dwc3: disable USB core PHY management"
Date:   Thu,  3 Nov 2022 15:46:48 +0100
Message-Id: <20221103144648.14197-1-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/usb/dwc3/host.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/usb/dwc3/host.c b/drivers/usb/dwc3/host.c
index a7154fe8206d..f6f13e7f1ba1 100644
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
-- 
2.37.3

