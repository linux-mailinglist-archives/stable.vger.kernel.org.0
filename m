Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 793E45EC8A7
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 17:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbiI0Pxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 11:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiI0Pxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 11:53:30 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CBC5E662;
        Tue, 27 Sep 2022 08:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664294006; x=1695830006;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yWf0AKBcbKVO8mFX9yX+cExaY/j0C7Lc8cRLyTHGlqI=;
  b=ivfrbgqdwJFPYe48lZqgrlIWHfDVhm03IfvgK+VBzXItRYOEocBvUaRe
   lLXZYwnPbzo8P+to2+fscrNlC3MCd157if1IlBVFq0Q/qK/mpBS1c4lD+
   A5JZAf45bc22N1f1zvakho6MD8/25EH65ZfYxWR6MW1KYH1UKLrg9dcGO
   ocD9l0lZCGkNKbQD70lSLlHRHlNUCln5woQ0gfi87MmvOXsWpkRsT6WD1
   BvHvYBKYN5Zf8f2X5MJBExvb02yJruma6Y5EUXUsxdhBoJVqKWWE09oUk
   ACjskrIBMLdXNRtx/wHGLpxDGWrwQrrgB0Rm4MyPKi7owm8QRrCd9+m6y
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="365395783"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="365395783"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 08:53:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="950335528"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="950335528"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 27 Sep 2022 08:53:22 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 78D8D101; Tue, 27 Sep 2022 18:53:41 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Felipe Balbi <balbi@kernel.org>, Ferry Toth <fntoth@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 2/2] Revert "usb: dwc3: Don't switch OTG -> peripheral if extcon is present"
Date:   Tue, 27 Sep 2022 18:53:32 +0300
Message-Id: <20220927155332.10762-3-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220927155332.10762-1-andriy.shevchenko@linux.intel.com>
References: <20220927155332.10762-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 0f01017191384e3962fa31520a9fd9846c3d352f.

As pointed out by Ferry this breaks Dual Role support on
Intel Merrifield platforms.

Fixes: 0f0101719138 ("usb: dwc3: Don't switch OTG -> peripheral if extcon is present")
Reported-by: Ferry Toth <fntoth@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Ferry Toth <fntoth@gmail.com> # for Merrifield
---
 drivers/usb/dwc3/core.c | 55 +----------------------------------------
 drivers/usb/dwc3/drd.c  | 50 +++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 54 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index c2b463469d51..219d797e2230 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -23,7 +23,6 @@
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include <linux/of.h>
-#include <linux/of_graph.h>
 #include <linux/acpi.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/reset.h>
@@ -86,7 +85,7 @@ static int dwc3_get_dr_mode(struct dwc3 *dwc)
 		 * mode. If the controller supports DRD but the dr_mode is not
 		 * specified or set to OTG, then set the mode to peripheral.
 		 */
-		if (mode == USB_DR_MODE_OTG && !dwc->edev &&
+		if (mode == USB_DR_MODE_OTG &&
 		    (!IS_ENABLED(CONFIG_USB_ROLE_SWITCH) ||
 		     !device_property_read_bool(dwc->dev, "usb-role-switch")) &&
 		    !DWC3_VER_IS_PRIOR(DWC3, 330A))
@@ -1668,51 +1667,6 @@ static void dwc3_check_params(struct dwc3 *dwc)
 	}
 }
 
-static struct extcon_dev *dwc3_get_extcon(struct dwc3 *dwc)
-{
-	struct device *dev = dwc->dev;
-	struct device_node *np_phy;
-	struct extcon_dev *edev = NULL;
-	const char *name;
-
-	if (device_property_read_bool(dev, "extcon"))
-		return extcon_get_edev_by_phandle(dev, 0);
-
-	/*
-	 * Device tree platforms should get extcon via phandle.
-	 * On ACPI platforms, we get the name from a device property.
-	 * This device property is for kernel internal use only and
-	 * is expected to be set by the glue code.
-	 */
-	if (device_property_read_string(dev, "linux,extcon-name", &name) == 0) {
-		edev = extcon_get_extcon_dev(name);
-		if (!edev)
-			return ERR_PTR(-EPROBE_DEFER);
-
-		return edev;
-	}
-
-	/*
-	 * Try to get an extcon device from the USB PHY controller's "port"
-	 * node. Check if it has the "port" node first, to avoid printing the
-	 * error message from underlying code, as it's a valid case: extcon
-	 * device (and "port" node) may be missing in case of "usb-role-switch"
-	 * or OTG mode.
-	 */
-	np_phy = of_parse_phandle(dev->of_node, "phys", 0);
-	if (of_graph_is_present(np_phy)) {
-		struct device_node *np_conn;
-
-		np_conn = of_graph_get_remote_node(np_phy, -1, -1);
-		if (np_conn)
-			edev = extcon_find_edev_by_node(np_conn);
-		of_node_put(np_conn);
-	}
-	of_node_put(np_phy);
-
-	return edev;
-}
-
 static int dwc3_probe(struct platform_device *pdev)
 {
 	struct device		*dev = &pdev->dev;
@@ -1849,13 +1803,6 @@ static int dwc3_probe(struct platform_device *pdev)
 		goto err2;
 	}
 
-	dwc->edev = dwc3_get_extcon(dwc);
-	if (IS_ERR(dwc->edev)) {
-		ret = PTR_ERR(dwc->edev);
-		dev_err_probe(dwc->dev, ret, "failed to get extcon\n");
-		goto err3;
-	}
-
 	ret = dwc3_get_dr_mode(dwc);
 	if (ret)
 		goto err3;
diff --git a/drivers/usb/dwc3/drd.c b/drivers/usb/dwc3/drd.c
index 039bf241769a..8cad9e7d3368 100644
--- a/drivers/usb/dwc3/drd.c
+++ b/drivers/usb/dwc3/drd.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/extcon.h>
+#include <linux/of_graph.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/property.h>
@@ -438,6 +439,51 @@ static int dwc3_drd_notifier(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
+static struct extcon_dev *dwc3_get_extcon(struct dwc3 *dwc)
+{
+	struct device *dev = dwc->dev;
+	struct device_node *np_phy;
+	struct extcon_dev *edev = NULL;
+	const char *name;
+
+	if (device_property_read_bool(dev, "extcon"))
+		return extcon_get_edev_by_phandle(dev, 0);
+
+	/*
+	 * Device tree platforms should get extcon via phandle.
+	 * On ACPI platforms, we get the name from a device property.
+	 * This device property is for kernel internal use only and
+	 * is expected to be set by the glue code.
+	 */
+	if (device_property_read_string(dev, "linux,extcon-name", &name) == 0) {
+		edev = extcon_get_extcon_dev(name);
+		if (!edev)
+			return ERR_PTR(-EPROBE_DEFER);
+
+		return edev;
+	}
+
+	/*
+	 * Try to get an extcon device from the USB PHY controller's "port"
+	 * node. Check if it has the "port" node first, to avoid printing the
+	 * error message from underlying code, as it's a valid case: extcon
+	 * device (and "port" node) may be missing in case of "usb-role-switch"
+	 * or OTG mode.
+	 */
+	np_phy = of_parse_phandle(dev->of_node, "phys", 0);
+	if (of_graph_is_present(np_phy)) {
+		struct device_node *np_conn;
+
+		np_conn = of_graph_get_remote_node(np_phy, -1, -1);
+		if (np_conn)
+			edev = extcon_find_edev_by_node(np_conn);
+		of_node_put(np_conn);
+	}
+	of_node_put(np_phy);
+
+	return edev;
+}
+
 #if IS_ENABLED(CONFIG_USB_ROLE_SWITCH)
 #define ROLE_SWITCH 1
 static int dwc3_usb_role_switch_set(struct usb_role_switch *sw,
@@ -542,6 +588,10 @@ int dwc3_drd_init(struct dwc3 *dwc)
 	    device_property_read_bool(dwc->dev, "usb-role-switch"))
 		return dwc3_setup_role_switch(dwc);
 
+	dwc->edev = dwc3_get_extcon(dwc);
+	if (IS_ERR(dwc->edev))
+		return PTR_ERR(dwc->edev);
+
 	if (dwc->edev) {
 		dwc->edev_nb.notifier_call = dwc3_drd_notifier;
 		ret = extcon_register_notifier(dwc->edev, EXTCON_USB_HOST,
-- 
2.35.1

