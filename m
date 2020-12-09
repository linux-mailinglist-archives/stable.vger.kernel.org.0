Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE012D4344
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 14:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732291AbgLINbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 08:31:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:42354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732040AbgLINbv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 08:31:51 -0500
Subject: patch "usb: xhci: Set quirk for XHCI_SG_TRB_CACHE_SIZE_QUIRK" added to usb-testing
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607520670;
        bh=cgJ+fXcYwxL23hwqbAo4DpOXBlzsvixMpRSP0Mj4pbQ=;
        h=To:From:Date:From;
        b=akKm+2SLSkhhYnztxfYw3xN/x24R21ilNkp5A3IF8uxhnjGFzUKhVgUG7YK03cnQV
         X9oYNUMz22NDkhjS2u15sT/AiAnY5KFH7wzopneMh0ITqLYGI2C377T/DbQT3hgtGo
         aK2HfAE4hvbMUzY6VpuD2Ik6cf2jJwHcZffw6+Wk=
To:     Tejas.Joglekar@synopsys.com, gregkh@linuxfoundation.org,
        joglekar@synopsys.com, mathias.nyman@linux.intel.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 14:32:09 +0100
Message-ID: <16075207292068@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: xhci: Set quirk for XHCI_SG_TRB_CACHE_SIZE_QUIRK

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From bac1ec551434697ca3c5bb5d258811ba5446866a Mon Sep 17 00:00:00 2001
From: Tejas Joglekar <Tejas.Joglekar@synopsys.com>
Date: Tue, 8 Dec 2020 11:29:08 +0200
Subject: usb: xhci: Set quirk for XHCI_SG_TRB_CACHE_SIZE_QUIRK

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
 drivers/usb/host/xhci-plat.c | 3 +++
 drivers/usb/host/xhci.h      | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index aa2d35f98200..4d34f6005381 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -333,6 +333,9 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	if (priv && (priv->quirks & XHCI_SKIP_PHY_INIT))
 		hcd->skip_phy_initialization = 1;
 
+	if (priv && (priv->quirks & XHCI_SG_TRB_CACHE_SIZE_QUIRK))
+		xhci->quirks |= XHCI_SG_TRB_CACHE_SIZE_QUIRK;
+
 	ret = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (ret)
 		goto disable_usb_phy;
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index ebb359ebb261..d90c0d5df3b3 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1878,6 +1878,7 @@ struct xhci_hcd {
 #define XHCI_RENESAS_FW_QUIRK	BIT_ULL(36)
 #define XHCI_SKIP_PHY_INIT	BIT_ULL(37)
 #define XHCI_DISABLE_SPARSE	BIT_ULL(38)
+#define XHCI_SG_TRB_CACHE_SIZE_QUIRK	BIT_ULL(39)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
-- 
2.29.2


