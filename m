Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAFA93CB63E
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 12:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239169AbhGPKsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 06:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239145AbhGPKsM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Jul 2021 06:48:12 -0400
Received: from srv6.fidu.org (srv6.fidu.org [IPv6:2a01:4f8:231:de0::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E02C06175F
        for <stable@vger.kernel.org>; Fri, 16 Jul 2021 03:45:17 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by srv6.fidu.org (Postfix) with ESMTP id A30D6C80089;
        Fri, 16 Jul 2021 12:37:20 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at srv6.fidu.org
Received: from srv6.fidu.org ([127.0.0.1])
        by localhost (srv6.fidu.org [127.0.0.1]) (amavisd-new, port 10026)
        with LMTP id 6ItIr60bHv6m; Fri, 16 Jul 2021 12:37:20 +0200 (CEST)
Received: from wsembach-tuxedo.fritz.box (p200300E37F209B006c872a2351999967.dip0.t-ipconnect.de [IPv6:2003:e3:7f20:9b00:6c87:2a23:5199:9967])
        (Authenticated sender: wse@tuxedocomputers.com)
        by srv6.fidu.org (Postfix) with ESMTPA id 44817C8008A;
        Fri, 16 Jul 2021 12:37:20 +0200 (CEST)
From:   Werner Sembach <wse@tuxedocomputers.com>
To:     kernel-team@lists.ubuntu.com
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        Prike Liang <Prike.Liang@amd.com>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Werner Sembach <wse@tuxedocomputers.com>
Subject: [SRU][H][PATCH 1/1] usb: pci-quirks: disable D3cold on xhci suspend for s2idle on AMD Renoir
Date:   Fri, 16 Jul 2021 12:37:16 +0200
Message-Id: <20210716103716.4473-2-wse@tuxedocomputers.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210716103716.4473-1-wse@tuxedocomputers.com>
References: <20210716103716.4473-1-wse@tuxedocomputers.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

The XHCI controller is required to enter D3hot rather than D3cold for AMD
s2idle on this hardware generation.

Otherwise, the 'Controller Not Ready' (CNR) bit is not being cleared by
host in resume and eventually this results in xhci resume failures during
the s2idle wakeup.

Link: https://lore.kernel.org/linux-usb/1612527609-7053-1-git-send-email-Prike.Liang@amd.com/
Suggested-by: Prike Liang <Prike.Liang@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Cc: stable <stable@vger.kernel.org> # 5.11+
Link: https://lore.kernel.org/r/20210527154534.8900-1-mario.limonciello@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
(cherry picked from commit d1658268e43980c071dbffc3d894f6f6c4b6732a)
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
---
 drivers/usb/host/xhci-pci.c | 7 ++++++-
 drivers/usb/host/xhci.h     | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 9568b907fd05..ceccd27cf4d0 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -59,6 +59,7 @@
 #define PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI		0x1138
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_XHCI		0x461e
 
+#define PCI_DEVICE_ID_AMD_RENOIR_XHCI			0x1639
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_4			0x43b9
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_3			0x43ba
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_2			0x43bb
@@ -182,6 +183,10 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		(pdev->device == PCI_DEVICE_ID_AMD_PROMONTORYA_1)))
 		xhci->quirks |= XHCI_U2_DISABLE_WAKE;
 
+	if (pdev->vendor == PCI_VENDOR_ID_AMD &&
+		pdev->device == PCI_DEVICE_ID_AMD_RENOIR_XHCI)
+		xhci->quirks |= XHCI_BROKEN_D3COLD;
+
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL) {
 		xhci->quirks |= XHCI_LPM_SUPPORT;
 		xhci->quirks |= XHCI_INTEL_HOST;
@@ -548,7 +553,7 @@ static int xhci_pci_suspend(struct usb_hcd *hcd, bool do_wakeup)
 	 * Systems with the TI redriver that loses port status change events
 	 * need to have the registers polled during D3, so avoid D3cold.
 	 */
-	if (xhci->quirks & XHCI_COMP_MODE_QUIRK)
+	if (xhci->quirks & (XHCI_COMP_MODE_QUIRK | XHCI_BROKEN_D3COLD))
 		pci_d3cold_disable(pdev);
 
 	if (xhci->quirks & XHCI_PME_STUCK_QUIRK)
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 3190fd570c57..80a43b843af7 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1884,6 +1884,7 @@ struct xhci_hcd {
 #define XHCI_DISABLE_SPARSE	BIT_ULL(38)
 #define XHCI_SG_TRB_CACHE_SIZE_QUIRK	BIT_ULL(39)
 #define XHCI_NO_SOFT_RETRY	BIT_ULL(40)
+#define XHCI_BROKEN_D3COLD	BIT_ULL(41)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
-- 
2.25.1

