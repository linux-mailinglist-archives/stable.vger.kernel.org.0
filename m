Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5519207508
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 15:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403974AbgFXN4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 09:56:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:43621 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403988AbgFXN4x (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jun 2020 09:56:53 -0400
IronPort-SDR: 3MSPoUC55S6kawWRJIWwwEm991ipDYXzGcFxkXdHlCFLN63rd0NfB3VmEJEs2qH+RXbpEADz9Q
 Ykd+Fakalm+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="132909267"
X-IronPort-AV: E=Sophos;i="5.75,275,1589266800"; 
   d="scan'208";a="132909267"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2020 06:56:52 -0700
IronPort-SDR: QZC3rZlRDVXUALtvInsbMnADpN+lK5GiIzU3JSxxWKKAKyTS85r3WurtP7PXi4moQR3hQgMWYb
 iarqqjAhx59g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,275,1589266800"; 
   d="scan'208";a="263644049"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by fmsmga007.fm.intel.com with ESMTP; 24 Jun 2020 06:56:51 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Macpaul Lin <macpaul.lin@mediatek.com>, stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 3/5] usb: host: xhci-mtk: avoid runtime suspend when removing hcd
Date:   Wed, 24 Jun 2020 16:59:47 +0300
Message-Id: <20200624135949.22611-4-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200624135949.22611-1-mathias.nyman@linux.intel.com>
References: <20200624135949.22611-1-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Macpaul Lin <macpaul.lin@mediatek.com>

When runtime suspend was enabled, runtime suspend might happen
when xhci is removing hcd. This might cause kernel panic when hcd
has been freed but runtime pm suspend related handle need to
reference it.

Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Reviewed-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-mtk.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-mtk.c b/drivers/usb/host/xhci-mtk.c
index bfbdb3ceed29..4311d4c9b68d 100644
--- a/drivers/usb/host/xhci-mtk.c
+++ b/drivers/usb/host/xhci-mtk.c
@@ -587,6 +587,9 @@ static int xhci_mtk_remove(struct platform_device *dev)
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
 	struct usb_hcd  *shared_hcd = xhci->shared_hcd;
 
+	pm_runtime_put_noidle(&dev->dev);
+	pm_runtime_disable(&dev->dev);
+
 	usb_remove_hcd(shared_hcd);
 	xhci->shared_hcd = NULL;
 	device_init_wakeup(&dev->dev, false);
@@ -597,8 +600,6 @@ static int xhci_mtk_remove(struct platform_device *dev)
 	xhci_mtk_sch_exit(mtk);
 	xhci_mtk_clks_disable(mtk);
 	xhci_mtk_ldos_disable(mtk);
-	pm_runtime_put_sync(&dev->dev);
-	pm_runtime_disable(&dev->dev);
 
 	return 0;
 }
-- 
2.17.1

