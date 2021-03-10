Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4A8333E18
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbhCJNZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:46388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233109AbhCJNYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C1E765002;
        Wed, 10 Mar 2021 13:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382694;
        bh=1VTpEPFFuren7SzjeEvCUz5t2OEKJ3NK/a9pyIjpnVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fzcm21YPLtjPrPB/5Zw+Q3r4aEYDhBkPBMtjifeYTOfrplJIv6rqffn8InIM6gx2M
         cXE5sUmfrwiQkY3415ibih37TVAgSNl8wo1L4ybaORzi/p9OkwSPn+m7bD5iZC7V7N
         od29eOHrXzq1zIg5sPZe1M9GsC35lvT0jrBVWQH0=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jun Li <jun.li@nxp.com>,
        Peter Chen <peter.chen@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 27/49] usb: cdns3: add quirk for enable runtime pm by default
Date:   Wed, 10 Mar 2021 14:23:38 +0100
Message-Id: <20210310132322.804313930@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132321.948258062@linuxfoundation.org>
References: <20210310132321.948258062@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Peter Chen <peter.chen@nxp.com>

[ Upstream commit 7cea9657756b2c83069a775c0671ff169bce456a ]

Some vendors (eg: NXP) may want to enable runtime pm by default for
power saving, add one quirk for it.

Reviewed-by: Jun Li <jun.li@nxp.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/core.c |  3 ++-
 drivers/usb/cdns3/core.h |  4 ++++
 drivers/usb/cdns3/host.c | 20 +++++++++++++++++---
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/cdns3/core.c b/drivers/usb/cdns3/core.c
index 039ab5d2435e..29affbf1e828 100644
--- a/drivers/usb/cdns3/core.c
+++ b/drivers/usb/cdns3/core.c
@@ -569,7 +569,8 @@ static int cdns3_probe(struct platform_device *pdev)
 	device_set_wakeup_capable(dev, true);
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
-	pm_runtime_forbid(dev);
+	if (!(cdns->pdata->quirks & CDNS3_DEFAULT_PM_RUNTIME_ALLOW))
+		pm_runtime_forbid(dev);
 
 	/*
 	 * The controller needs less time between bus and controller suspend,
diff --git a/drivers/usb/cdns3/core.h b/drivers/usb/cdns3/core.h
index 8a40d53d5ede..3176f924293a 100644
--- a/drivers/usb/cdns3/core.h
+++ b/drivers/usb/cdns3/core.h
@@ -42,6 +42,8 @@ struct cdns3_role_driver {
 struct cdns3_platform_data {
 	int (*platform_suspend)(struct device *dev,
 			bool suspend, bool wakeup);
+	unsigned long quirks;
+#define CDNS3_DEFAULT_PM_RUNTIME_ALLOW	BIT(0)
 };
 
 /**
@@ -73,6 +75,7 @@ struct cdns3_platform_data {
  * @wakeup_pending: wakeup interrupt pending
  * @pdata: platform data from glue layer
  * @lock: spinlock structure
+ * @xhci_plat_data: xhci private data structure pointer
  */
 struct cdns3 {
 	struct device			*dev;
@@ -106,6 +109,7 @@ struct cdns3 {
 	bool				wakeup_pending;
 	struct cdns3_platform_data	*pdata;
 	spinlock_t			lock;
+	struct xhci_plat_priv		*xhci_plat_data;
 };
 
 int cdns3_hw_role_switch(struct cdns3 *cdns);
diff --git a/drivers/usb/cdns3/host.c b/drivers/usb/cdns3/host.c
index f84739327a16..c3b29a9c77a5 100644
--- a/drivers/usb/cdns3/host.c
+++ b/drivers/usb/cdns3/host.c
@@ -52,15 +52,25 @@ static int __cdns3_host_init(struct cdns3 *cdns)
 		goto err1;
 	}
 
-	ret = platform_device_add_data(xhci, &xhci_plat_cdns3_xhci,
+	cdns->xhci_plat_data = kmemdup(&xhci_plat_cdns3_xhci,
+			sizeof(struct xhci_plat_priv), GFP_KERNEL);
+	if (!cdns->xhci_plat_data) {
+		ret = -ENOMEM;
+		goto err1;
+	}
+
+	if (cdns->pdata->quirks & CDNS3_DEFAULT_PM_RUNTIME_ALLOW)
+		cdns->xhci_plat_data->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
+
+	ret = platform_device_add_data(xhci, cdns->xhci_plat_data,
 			sizeof(struct xhci_plat_priv));
 	if (ret)
-		goto err1;
+		goto free_memory;
 
 	ret = platform_device_add(xhci);
 	if (ret) {
 		dev_err(cdns->dev, "failed to register xHCI device\n");
-		goto err1;
+		goto free_memory;
 	}
 
 	/* Glue needs to access xHCI region register for Power management */
@@ -69,6 +79,9 @@ static int __cdns3_host_init(struct cdns3 *cdns)
 		cdns->xhci_regs = hcd->regs;
 
 	return 0;
+
+free_memory:
+	kfree(cdns->xhci_plat_data);
 err1:
 	platform_device_put(xhci);
 	return ret;
@@ -102,6 +115,7 @@ int xhci_cdns3_suspend_quirk(struct usb_hcd *hcd)
 
 static void cdns3_host_exit(struct cdns3 *cdns)
 {
+	kfree(cdns->xhci_plat_data);
 	platform_device_unregister(cdns->host_dev);
 	cdns->host_dev = NULL;
 	cdns3_drd_host_off(cdns);
-- 
2.30.1



