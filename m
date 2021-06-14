Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B51D3A6428
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbhFNLVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:21:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235456AbhFNLSL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:18:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2549B6198C;
        Mon, 14 Jun 2021 10:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667838;
        bh=0OzG14zKROsbLr8pPESTvl8w51dkSHjRo2SIdkg5/FQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0AbanDDChusuaIchHx1v3j9JXjSb5BvaIJe7gUnVazU0OdXI+i7St6N4lqlYGPjzN
         T/YXLozXBTZqT9sl+uDTcyuwMDDfCPbfF0DU1Rz0EjPp+fR0v6J+y/5bT78intZ3Mm
         7P61sILPhv1SZVH4IoMpLf/d1OuhCcTo5ZauY8/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prike Liang <Prike.Liang@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 5.12 093/173] usb: pci-quirks: disable D3cold on xhci suspend for s2idle on AMD Renoir
Date:   Mon, 14 Jun 2021 12:27:05 +0200
Message-Id: <20210614102701.267640322@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

commit d1658268e43980c071dbffc3d894f6f6c4b6732a upstream.

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
---
 drivers/usb/host/xhci-pci.c |    7 ++++++-
 drivers/usb/host/xhci.h     |    1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -59,6 +59,7 @@
 #define PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI		0x1138
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_XHCI		0x461e
 
+#define PCI_DEVICE_ID_AMD_RENOIR_XHCI			0x1639
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_4			0x43b9
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_3			0x43ba
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_2			0x43bb
@@ -182,6 +183,10 @@ static void xhci_pci_quirks(struct devic
 		(pdev->device == PCI_DEVICE_ID_AMD_PROMONTORYA_1)))
 		xhci->quirks |= XHCI_U2_DISABLE_WAKE;
 
+	if (pdev->vendor == PCI_VENDOR_ID_AMD &&
+		pdev->device == PCI_DEVICE_ID_AMD_RENOIR_XHCI)
+		xhci->quirks |= XHCI_BROKEN_D3COLD;
+
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL) {
 		xhci->quirks |= XHCI_LPM_SUPPORT;
 		xhci->quirks |= XHCI_INTEL_HOST;
@@ -539,7 +544,7 @@ static int xhci_pci_suspend(struct usb_h
 	 * Systems with the TI redriver that loses port status change events
 	 * need to have the registers polled during D3, so avoid D3cold.
 	 */
-	if (xhci->quirks & XHCI_COMP_MODE_QUIRK)
+	if (xhci->quirks & (XHCI_COMP_MODE_QUIRK | XHCI_BROKEN_D3COLD))
 		pci_d3cold_disable(pdev);
 
 	if (xhci->quirks & XHCI_PME_STUCK_QUIRK)
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1892,6 +1892,7 @@ struct xhci_hcd {
 #define XHCI_DISABLE_SPARSE	BIT_ULL(38)
 #define XHCI_SG_TRB_CACHE_SIZE_QUIRK	BIT_ULL(39)
 #define XHCI_NO_SOFT_RETRY	BIT_ULL(40)
+#define XHCI_BROKEN_D3COLD	BIT_ULL(41)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;


