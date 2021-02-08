Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451B8313705
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbhBHPSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:18:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:56648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230288AbhBHPNZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:13:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7A8A64EFB;
        Mon,  8 Feb 2021 15:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797018;
        bh=Cs2SbyAksaEPfEkkaAtG/GLaMjGLLIWrpGZyTPGfjcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JHKqDclU5Jw/dvnyQdV047tUkSb38z2hZUHpLAaHGW8oVISbL3vP8cpFUEiNXiLiJ
         Ha3Z4cxv2sf31On8+d+8NrqWTGSJZT0MSog0/AbZYQbZr91tVwiCtUM4YcenIXsBvj
         2sa70rGH9b3ZTsPw11AkK2Cmqs3Gm2ieXIAcc2KU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jun Li <jun.li@nxp.com>,
        Peter Chen <peter.chen@nxp.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.4 31/65] usb: host: xhci-plat: add priv quirk for skip PHY initialization
Date:   Mon,  8 Feb 2021 16:01:03 +0100
Message-Id: <20210208145811.429167857@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145810.230485165@linuxfoundation.org>
References: <20210208145810.230485165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

commit f768e718911e03a4a20b65f984eaa9b09045e4cd upstream.

Some DRD controllers (eg, dwc3 & cdns3) have PHY management at
their own driver to cover both device and host mode, so add one
priv quirk for such users to skip PHY management from HCD core.

Reviewed-by: Jun Li <jun.li@nxp.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200918131752.16488-5-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-plat.c |    8 ++++++--
 drivers/usb/host/xhci.h      |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -163,6 +163,8 @@ static int xhci_plat_probe(struct platfo
 	struct usb_hcd		*hcd;
 	int			ret;
 	int			irq;
+	struct xhci_plat_priv	*priv = NULL;
+
 
 	if (usb_disabled())
 		return -ENODEV;
@@ -257,8 +259,7 @@ static int xhci_plat_probe(struct platfo
 
 	priv_match = of_device_get_match_data(&pdev->dev);
 	if (priv_match) {
-		struct xhci_plat_priv *priv = hcd_to_xhci_priv(hcd);
-
+		priv = hcd_to_xhci_priv(hcd);
 		/* Just copy data for now */
 		if (priv_match)
 			*priv = *priv_match;
@@ -307,6 +308,9 @@ static int xhci_plat_probe(struct platfo
 
 	hcd->tpl_support = of_usb_host_tpl_support(sysdev->of_node);
 	xhci->shared_hcd->tpl_support = hcd->tpl_support;
+	if (priv && (priv->quirks & XHCI_SKIP_PHY_INIT))
+		hcd->skip_phy_initialization = 1;
+
 	ret = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (ret)
 		goto disable_usb_phy;
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1873,6 +1873,7 @@ struct xhci_hcd {
 #define XHCI_DEFAULT_PM_RUNTIME_ALLOW	BIT_ULL(33)
 #define XHCI_RESET_PLL_ON_DISCONNECT	BIT_ULL(34)
 #define XHCI_SNPS_BROKEN_SUSPEND    BIT_ULL(35)
+#define XHCI_SKIP_PHY_INIT	BIT_ULL(37)
 #define XHCI_DISABLE_SPARSE	BIT_ULL(38)
 
 	unsigned int		num_active_eps;


