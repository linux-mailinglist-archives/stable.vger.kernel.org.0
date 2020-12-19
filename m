Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69D92DEFBE
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgLSM5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:57:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:44158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727018AbgLSM5c (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:57:32 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejas Joglekar <joglekar@synopsys.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 10/16] usb: xhci: Set quirk for XHCI_SG_TRB_CACHE_SIZE_QUIRK
Date:   Sat, 19 Dec 2020 13:57:17 +0100
Message-Id: <20201219125339.580055081@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125339.066340030@linuxfoundation.org>
References: <20201219125339.066340030@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejas Joglekar <Tejas.Joglekar@synopsys.com>

commit bac1ec551434697ca3c5bb5d258811ba5446866a upstream.

This commit uses the private data passed by parent device
to set the quirk for Synopsys xHC. This patch fixes the
SNPS xHC hang issue when the data is scattered across
small buffers which does not make atleast MPS size for
given TRB cache size of SNPS xHC.

Signed-off-by: Tejas Joglekar <joglekar@synopsys.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20201208092912.1773650-2-mathias.nyman@linux.intel.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-plat.c |    3 +++
 drivers/usb/host/xhci.h      |    1 +
 2 files changed, 4 insertions(+)

--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -333,6 +333,9 @@ static int xhci_plat_probe(struct platfo
 	if (priv && (priv->quirks & XHCI_SKIP_PHY_INIT))
 		hcd->skip_phy_initialization = 1;
 
+	if (priv && (priv->quirks & XHCI_SG_TRB_CACHE_SIZE_QUIRK))
+		xhci->quirks |= XHCI_SG_TRB_CACHE_SIZE_QUIRK;
+
 	ret = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (ret)
 		goto disable_usb_phy;
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1878,6 +1878,7 @@ struct xhci_hcd {
 #define XHCI_RENESAS_FW_QUIRK	BIT_ULL(36)
 #define XHCI_SKIP_PHY_INIT	BIT_ULL(37)
 #define XHCI_DISABLE_SPARSE	BIT_ULL(38)
+#define XHCI_SG_TRB_CACHE_SIZE_QUIRK	BIT_ULL(39)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;


