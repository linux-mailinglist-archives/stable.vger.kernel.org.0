Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A252D6EAA83
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 14:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbjDUMjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 08:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbjDUMjE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 08:39:04 -0400
Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [203.110.167.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072F1B74F
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 05:38:58 -0700 (PDT)
X-ASG-Debug-ID: 1682080734-1eb14e6388386f0002-OJig3u
Received: from ZXSHMBX1.zhaoxin.com (ZXSHMBX1.zhaoxin.com [10.28.252.163]) by mx2.zhaoxin.com with ESMTP id 4mOIhBGDnUpGCazL (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Fri, 21 Apr 2023 20:38:55 +0800 (CST)
X-Barracuda-Envelope-From: WeitaoWang-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXSHMBX1.zhaoxin.com
 (10.28.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 21 Apr
 2023 20:38:54 +0800
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
        <stable@vger.kernel.org>
Subject: [PATCH v2 1/4] xhci: Add some quirks for zhaoxin xhci to fix issues
Date:   Sat, 22 Apr 2023 04:38:50 +0800
X-ASG-Orig-Subj: [PATCH v2 1/4] xhci: Add some quirks for zhaoxin xhci to fix issues
Message-ID: <20230421203853.387210-2-WeitaoWang-oc@zhaoxin.com>
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
X-Barracuda-Start-Time: 1682080734
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 2170
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add a quirk XHCI_ZHAOXIN_HOST for zhaoxin xhci to fix issues,
there are two cases will be used.
- add u1/u2 support.
- fix xHCI root hub speed show issue in zhaoxin platform.

Add a quirk XHCI_ZHAOXIN_TRB_FETCH to fix TRB prefetch issue.

On Zhaoxin ZX-100 project, xHCI can't work normally after resume
from system Sx state. To fix this issue, when resume from system
sx state, reinitialize xHCI instead of restore.
So, Add XHCI_RESET_ON_RESUME quirk for zx-100 to fix issue of
resuming from system sx state.

Cc: stable@vger.kernel.org
Signed-off-by: Weitao Wang <WeitaoWang-oc@zhaoxin.com>
---
v1->v2
 - Add more quirks of xhci for zhaoxin.

 drivers/usb/host/xhci-pci.c | 11 +++++++++++
 drivers/usb/host/xhci.h     |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 6db07ca419c3..53b7d8a1ed0a 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -334,6 +334,17 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	     pdev->device == PCI_DEVICE_ID_AMD_PROMONTORYA_4))
 		xhci->quirks |= XHCI_NO_SOFT_RETRY;
 
+	if (pdev->vendor == PCI_VENDOR_ID_ZHAOXIN) {
+		xhci->quirks |= XHCI_LPM_SUPPORT;
+		xhci->quirks |= XHCI_ZHAOXIN_HOST;
+		if (pdev->device == 0x9202) {
+			xhci->quirks |= XHCI_RESET_ON_RESUME;
+			xhci->quirks |= XHCI_ZHAOXIN_TRB_FETCH;
+		}
+		if (pdev->device == 0x9203)
+			xhci->quirks |= XHCI_ZHAOXIN_TRB_FETCH;
+	}
+
 	/* xHC spec requires PCI devices to support D3hot and D3cold */
 	if (xhci->hci_version >= 0x120)
 		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 786002bb35db..8f8f0e91b0dc 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1905,6 +1905,8 @@ struct xhci_hcd {
 #define XHCI_EP_CTX_BROKEN_DCS	BIT_ULL(42)
 #define XHCI_SUSPEND_RESUME_CLKS	BIT_ULL(43)
 #define XHCI_RESET_TO_DEFAULT	BIT_ULL(44)
+#define XHCI_ZHAOXIN_HOST	BIT_ULL(45)
+#define XHCI_ZHAOXIN_TRB_FETCH	BIT_ULL(46)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
-- 
2.32.0

