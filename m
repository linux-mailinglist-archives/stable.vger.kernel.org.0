Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46FE582EFA
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238643AbiG0RT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241793AbiG0RSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:18:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA68479EF2;
        Wed, 27 Jul 2022 09:43:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA3F9601CE;
        Wed, 27 Jul 2022 16:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31EFC433C1;
        Wed, 27 Jul 2022 16:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940234;
        bh=y884BdKINCrdyRmIMxHI65XF4GdItYKtWbvXi4nbEpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mCzzMVhEEEKqSoVG7Sn2wYWDFhq7bn9D1ZBgSadoIgyKdbyuGjdJZaOSrzhhQhaHl
         9oD8vPvaKArEX9X7tePdc7pBlVSZRaaTcOZpjAqcRNCDBZHd2kbwn9mBYvM3hNKf3S
         7gYog8pbW23yfm4/UarjFFwMobxB8LNEZWtpUoiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 153/201] xhci: dbc: create and remove dbc structure in dbgtty driver.
Date:   Wed, 27 Jul 2022 18:10:57 +0200
Message-Id: <20220727161034.170996847@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit 5ce036b98dd3301fc43bb06a6383ef07b6c776bc ]

Turn the dbgtty closer to a device driver by allocating the dbc
structure in its own xhci_dbc_tty_probe() function, and freeing it
in xhci_dbc_tty_remove()

Remove xhci_do_dbc_exit() as its no longer needed.

allocate and create the dbc strcuture in xhci_dbc_tty_probe()

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20220216095153.1303105-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-dbgcap.c | 26 +++-----------------------
 drivers/usb/host/xhci-dbgcap.h |  5 ++++-
 drivers/usb/host/xhci-dbgtty.c | 22 +++++++++++++++-------
 3 files changed, 22 insertions(+), 31 deletions(-)

diff --git a/drivers/usb/host/xhci-dbgcap.c b/drivers/usb/host/xhci-dbgcap.c
index 6a437862b498..f4da5708a40f 100644
--- a/drivers/usb/host/xhci-dbgcap.c
+++ b/drivers/usb/host/xhci-dbgcap.c
@@ -914,16 +914,6 @@ static void xhci_dbc_handle_events(struct work_struct *work)
 	mod_delayed_work(system_wq, &dbc->event_work, 1);
 }
 
-static void xhci_do_dbc_exit(struct xhci_hcd *xhci)
-{
-	unsigned long		flags;
-
-	spin_lock_irqsave(&xhci->lock, flags);
-	kfree(xhci->dbc);
-	xhci->dbc = NULL;
-	spin_unlock_irqrestore(&xhci->lock, flags);
-}
-
 static ssize_t dbc_show(struct device *dev,
 			struct device_attribute *attr,
 			char *buf)
@@ -984,7 +974,7 @@ static ssize_t dbc_store(struct device *dev,
 static DEVICE_ATTR_RW(dbc);
 
 struct xhci_dbc *
-xhci_alloc_dbc(struct device *dev, void __iomem *base)
+xhci_alloc_dbc(struct device *dev, void __iomem *base, const struct dbc_driver *driver)
 {
 	struct xhci_dbc		*dbc;
 	int			ret;
@@ -995,6 +985,7 @@ xhci_alloc_dbc(struct device *dev, void __iomem *base)
 
 	dbc->regs = base;
 	dbc->dev = dev;
+	dbc->driver = driver;
 
 	if (readl(&dbc->regs->control) & DBC_CTRL_DBC_ENABLE)
 		return NULL;
@@ -1045,18 +1036,8 @@ int xhci_dbc_init(struct xhci_hcd *xhci)
 	if (xhci->dbc)
 		return -EBUSY;
 
-	xhci->dbc = xhci_alloc_dbc(dev, base);
-	if (!xhci->dbc)
-		return -ENOMEM;
-
-	ret = xhci_dbc_tty_probe(xhci);
-	if (ret)
-		goto init_err2;
-
-	return 0;
+	ret = xhci_dbc_tty_probe(dev, base + dbc_cap_offs, xhci);
 
-init_err2:
-	xhci_do_dbc_exit(xhci);
 	return ret;
 }
 
@@ -1068,7 +1049,6 @@ void xhci_dbc_exit(struct xhci_hcd *xhci)
 		return;
 
 	xhci_dbc_tty_remove(xhci->dbc);
-	xhci_dbc_remove(xhci->dbc);
 	spin_lock_irqsave(&xhci->lock, flags);
 	xhci->dbc = NULL;
 	spin_unlock_irqrestore(&xhci->lock, flags);
diff --git a/drivers/usb/host/xhci-dbgcap.h b/drivers/usb/host/xhci-dbgcap.h
index c70b78d504eb..5d8c7815491c 100644
--- a/drivers/usb/host/xhci-dbgcap.h
+++ b/drivers/usb/host/xhci-dbgcap.h
@@ -196,8 +196,11 @@ static inline struct dbc_ep *get_out_ep(struct xhci_dbc *dbc)
 #ifdef CONFIG_USB_XHCI_DBGCAP
 int xhci_dbc_init(struct xhci_hcd *xhci);
 void xhci_dbc_exit(struct xhci_hcd *xhci);
-int xhci_dbc_tty_probe(struct xhci_hcd *xhci);
+int xhci_dbc_tty_probe(struct device *dev, void __iomem *res, struct xhci_hcd *xhci);
 void xhci_dbc_tty_remove(struct xhci_dbc *dbc);
+struct xhci_dbc *xhci_alloc_dbc(struct device *dev, void __iomem *res,
+				 const struct dbc_driver *driver);
+void xhci_dbc_remove(struct xhci_dbc *dbc);
 struct dbc_request *dbc_alloc_request(struct xhci_dbc *dbc,
 				      unsigned int direction,
 				      gfp_t flags);
diff --git a/drivers/usb/host/xhci-dbgtty.c b/drivers/usb/host/xhci-dbgtty.c
index eb46e642e87a..18bcc96853ae 100644
--- a/drivers/usb/host/xhci-dbgtty.c
+++ b/drivers/usb/host/xhci-dbgtty.c
@@ -468,9 +468,9 @@ static const struct dbc_driver dbc_driver = {
 	.disconnect		= xhci_dbc_tty_unregister_device,
 };
 
-int xhci_dbc_tty_probe(struct xhci_hcd *xhci)
+int xhci_dbc_tty_probe(struct device *dev, void __iomem *base, struct xhci_hcd *xhci)
 {
-	struct xhci_dbc		*dbc = xhci->dbc;
+	struct xhci_dbc		*dbc;
 	struct dbc_port		*port;
 	int			status;
 
@@ -485,13 +485,22 @@ int xhci_dbc_tty_probe(struct xhci_hcd *xhci)
 		goto out;
 	}
 
-	dbc->driver = &dbc_driver;
-	dbc->priv = port;
+	dbc_tty_driver->driver_state = port;
+
+	dbc = xhci_alloc_dbc(dev, base, &dbc_driver);
+	if (!dbc) {
+		status = -ENOMEM;
+		goto out2;
+	}
 
+	dbc->priv = port;
 
-	dbc_tty_driver->driver_state = port;
+	/* get rid of xhci once this is a real driver binding to a device */
+	xhci->dbc = dbc;
 
 	return 0;
+out2:
+	kfree(port);
 out:
 	/* dbc_tty_exit will be called by module_exit() in the future */
 	dbc_tty_exit();
@@ -506,8 +515,7 @@ void xhci_dbc_tty_remove(struct xhci_dbc *dbc)
 {
 	struct dbc_port         *port = dbc_to_port(dbc);
 
-	dbc->driver = NULL;
-	dbc->priv = NULL;
+	xhci_dbc_remove(dbc);
 	kfree(port);
 
 	/* dbc_tty_exit will be called by  module_exit() in the future */
-- 
2.35.1



