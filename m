Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F34506EAA81
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 14:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbjDUMjI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 08:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbjDUMjE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 08:39:04 -0400
Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [203.110.167.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40B3CC3B
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 05:39:00 -0700 (PDT)
X-ASG-Debug-ID: 1682080734-1eb14e6388386f0005-OJig3u
Received: from ZXSHMBX1.zhaoxin.com (ZXSHMBX1.zhaoxin.com [10.28.252.163]) by mx2.zhaoxin.com with ESMTP id NYfORPVgddCDGJOK (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Fri, 21 Apr 2023 20:38:56 +0800 (CST)
X-Barracuda-Envelope-From: WeitaoWang-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXSHMBX1.zhaoxin.com
 (10.28.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 21 Apr
 2023 20:38:55 +0800
Received: from L440.zhaoxin.com (10.29.8.21) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 21 Apr
 2023 20:38:54 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
From:   Weitao Wang <WeitaoWang-oc@zhaoxin.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.29.252.163
To:     <gregkh@linuxfoundation.org>, <mathias.nyman@intel.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <tonywwang@zhaoxin.com>, <weitaowang@zhaoxin.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 4/4] xhci: Add zhaoxin xHCI U1/U2 feature support
Date:   Sat, 22 Apr 2023 04:38:53 +0800
X-ASG-Orig-Subj: [PATCH v2 4/4] xhci: Add zhaoxin xHCI U1/U2 feature support
Message-ID: <20230421203853.387210-5-WeitaoWang-oc@zhaoxin.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20230421203853.387210-1-WeitaoWang-oc@zhaoxin.com>
References: <20230421203853.387210-1-WeitaoWang-oc@zhaoxin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.29.8.21]
X-ClientProxiedBy: zxbjmbx1.zhaoxin.com (10.29.252.163) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
X-Barracuda-Connect: ZXSHMBX1.zhaoxin.com[10.28.252.163]
X-Barracuda-Start-Time: 1682080736
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 3160
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: 1.09
X-Barracuda-Spam-Status: No, SCORE=1.09 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=DATE_IN_FUTURE_06_12, DATE_IN_FUTURE_06_12_2
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.107724
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
        0.01 DATE_IN_FUTURE_06_12   Date: is 6 to 12 hours after Received: date
        3.10 DATE_IN_FUTURE_06_12_2 DATE_IN_FUTURE_06_12_2
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add U1/U2 feature support of xHCI for zhaoxin.
Since both Intel and Zhaoxin need to check the tier where the device is
located to determine whether to enabled U1/U2, remove the previous Intel
U1/U2 tier policy and add common policy in xhci_check_tier_policy.
If vendor has specific U1/U2 enable policy,quirks can be add to declare.

Suggested-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Weitao Wang <WeitaoWang-oc@zhaoxin.com>
---
 v1->v2
 - Modify the description.
 - Adjust U1/U2 tier enable policy.

 drivers/usb/host/xhci.c | 43 +++++++++++++++++------------------------
 1 file changed, 18 insertions(+), 25 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 31d6ace9cace..b81a69126188 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4802,7 +4802,7 @@ static u16 xhci_calculate_u1_timeout(struct xhci_hcd *xhci,
 		}
 	}
 
-	if (xhci->quirks & XHCI_INTEL_HOST)
+	if (xhci->quirks & (XHCI_INTEL_HOST | XHCI_ZHAOXIN_HOST))
 		timeout_ns = xhci_calculate_intel_u1_timeout(udev, desc);
 	else
 		timeout_ns = udev->u1_params.sel;
@@ -4866,7 +4866,7 @@ static u16 xhci_calculate_u2_timeout(struct xhci_hcd *xhci,
 		}
 	}
 
-	if (xhci->quirks & XHCI_INTEL_HOST)
+	if (xhci->quirks & (XHCI_INTEL_HOST | XHCI_ZHAOXIN_HOST))
 		timeout_ns = xhci_calculate_intel_u2_timeout(udev, desc);
 	else
 		timeout_ns = udev->u2_params.sel;
@@ -4938,37 +4938,30 @@ static int xhci_update_timeout_for_interface(struct xhci_hcd *xhci,
 	return 0;
 }
 
-static int xhci_check_intel_tier_policy(struct usb_device *udev,
+static int xhci_check_tier_policy(struct xhci_hcd *xhci,
+		struct usb_device *udev,
 		enum usb3_link_state state)
 {
-	struct usb_device *parent;
-	unsigned int num_hubs;
+	struct usb_device *parent = udev->parent;
+	int tier = 1; /* roothub is tier1 */
 
-	/* Don't enable U1 if the device is on a 2nd tier hub or lower. */
-	for (parent = udev->parent, num_hubs = 0; parent->parent;
-			parent = parent->parent)
-		num_hubs++;
+	while (parent) {
+		parent = parent->parent;
+		tier++;
+	}
 
-	if (num_hubs < 2)
-		return 0;
+	if (xhci->quirks & XHCI_INTEL_HOST && tier > 3)
+		goto fail;
+	if (xhci->quirks & XHCI_ZHAOXIN_HOST && tier > 2)
+		goto fail;
 
-	dev_dbg(&udev->dev, "Disabling U1/U2 link state for device"
-			" below second-tier hub.\n");
-	dev_dbg(&udev->dev, "Plug device into first-tier hub "
-			"to decrease power consumption.\n");
+	return 0;
+fail:
+	dev_dbg(&udev->dev, "Tier policy prevents U1/U2 LPM states for devices at tier %d\n",
+			tier);
 	return -E2BIG;
 }
 
-static int xhci_check_tier_policy(struct xhci_hcd *xhci,
-		struct usb_device *udev,
-		enum usb3_link_state state)
-{
-	if (xhci->quirks & XHCI_INTEL_HOST)
-		return xhci_check_intel_tier_policy(udev, state);
-	else
-		return 0;
-}
-
 /* Returns the U1 or U2 timeout that should be enabled.
  * If the tier check or timeout setting functions return with a non-zero exit
  * code, that means the timeout value has been finalized and we shouldn't look
-- 
2.32.0

