Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9A5E582EFC
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239754AbiG0RT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237215AbiG0RSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:18:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC5479EEA;
        Wed, 27 Jul 2022 09:43:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E42C1601C0;
        Wed, 27 Jul 2022 16:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED82DC433C1;
        Wed, 27 Jul 2022 16:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940231;
        bh=OWV/hf/XEBSjkRGgk5wImacYpr3pIY3T3KqtCGvljDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qpXXo788UaxafTWgDNCNuMxH6NacvSrN5zjmYZmQFI9sjeiRymXzIikkkKLfnptLN
         v4/kOPq70f2FxEn9RQUK1o/mfySWeN0qQEMBbPAbEZXfx+z13gd1Fdz9Trj45701NG
         j9ohS/bAkNhS0xp2NdU0FwLp17jnYps2qpRWYM+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 152/201] xhci: dbc: refactor xhci_dbc_init()
Date:   Wed, 27 Jul 2022 18:10:56 +0200
Message-Id: <20220727161034.130364605@linuxfoundation.org>
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

[ Upstream commit 534675942e901959b5d8dc11ea526c4e48817d8e ]

Refactor xhci_dbc_init(), splitting it into logical
parts closer to the Linux device model.

- Create the fake dbc device, depends on xhci strucure
- Allocate a dbc structure, xhci agnostic
- Call xhci_dbc_tty_probe(), similar to actual probe.

Adjustments to xhci_dbc_exit and xhci_dbc_remove are also needed
as a result to the xhci_dbc_init() changes

Mostly non-functional changes, except for creating the dbc sysfs
entry earlier, together with the dbc structure.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20220216095153.1303105-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-dbgcap.c | 124 ++++++++++++++++++---------------
 1 file changed, 66 insertions(+), 58 deletions(-)

diff --git a/drivers/usb/host/xhci-dbgcap.c b/drivers/usb/host/xhci-dbgcap.c
index ccb0156fcebe..6a437862b498 100644
--- a/drivers/usb/host/xhci-dbgcap.c
+++ b/drivers/usb/host/xhci-dbgcap.c
@@ -924,49 +924,6 @@ static void xhci_do_dbc_exit(struct xhci_hcd *xhci)
 	spin_unlock_irqrestore(&xhci->lock, flags);
 }
 
-static int xhci_do_dbc_init(struct xhci_hcd *xhci)
-{
-	u32			reg;
-	struct xhci_dbc		*dbc;
-	unsigned long		flags;
-	void __iomem		*base;
-	int			dbc_cap_offs;
-
-	base = &xhci->cap_regs->hc_capbase;
-	dbc_cap_offs = xhci_find_next_ext_cap(base, 0, XHCI_EXT_CAPS_DEBUG);
-	if (!dbc_cap_offs)
-		return -ENODEV;
-
-	dbc = kzalloc(sizeof(*dbc), GFP_KERNEL);
-	if (!dbc)
-		return -ENOMEM;
-
-	dbc->regs = base + dbc_cap_offs;
-
-	/* We will avoid using DbC in xhci driver if it's in use. */
-	reg = readl(&dbc->regs->control);
-	if (reg & DBC_CTRL_DBC_ENABLE) {
-		kfree(dbc);
-		return -EBUSY;
-	}
-
-	spin_lock_irqsave(&xhci->lock, flags);
-	if (xhci->dbc) {
-		spin_unlock_irqrestore(&xhci->lock, flags);
-		kfree(dbc);
-		return -EBUSY;
-	}
-	xhci->dbc = dbc;
-	spin_unlock_irqrestore(&xhci->lock, flags);
-
-	dbc->xhci = xhci;
-	dbc->dev = xhci_to_hcd(xhci)->self.sysdev;
-	INIT_DELAYED_WORK(&dbc->event_work, xhci_dbc_handle_events);
-	spin_lock_init(&dbc->lock);
-
-	return 0;
-}
-
 static ssize_t dbc_show(struct device *dev,
 			struct device_attribute *attr,
 			char *buf)
@@ -1026,44 +983,95 @@ static ssize_t dbc_store(struct device *dev,
 
 static DEVICE_ATTR_RW(dbc);
 
-int xhci_dbc_init(struct xhci_hcd *xhci)
+struct xhci_dbc *
+xhci_alloc_dbc(struct device *dev, void __iomem *base)
 {
+	struct xhci_dbc		*dbc;
 	int			ret;
-	struct device		*dev = xhci_to_hcd(xhci)->self.controller;
 
-	ret = xhci_do_dbc_init(xhci);
+	dbc = kzalloc(sizeof(*dbc), GFP_KERNEL);
+	if (!dbc)
+		return NULL;
+
+	dbc->regs = base;
+	dbc->dev = dev;
+
+	if (readl(&dbc->regs->control) & DBC_CTRL_DBC_ENABLE)
+		return NULL;
+
+	INIT_DELAYED_WORK(&dbc->event_work, xhci_dbc_handle_events);
+	spin_lock_init(&dbc->lock);
+
+	ret = device_create_file(dev, &dev_attr_dbc);
 	if (ret)
-		goto init_err3;
+		goto err;
+
+	return dbc;
+err:
+	kfree(dbc);
+	return NULL;
+}
+
+/* undo what xhci_alloc_dbc() did */
+void xhci_dbc_remove(struct xhci_dbc *dbc)
+{
+	if (!dbc)
+		return;
+	/* stop hw, stop wq and call dbc->ops->stop() */
+	xhci_dbc_stop(dbc);
+
+	/* remove sysfs files */
+	device_remove_file(dbc->dev, &dev_attr_dbc);
+
+	kfree(dbc);
+}
+
+int xhci_dbc_init(struct xhci_hcd *xhci)
+{
+	struct device		*dev;
+	void __iomem		*base;
+	int			ret;
+	int			dbc_cap_offs;
+
+	/* create all parameters needed resembling a dbc device */
+	dev = xhci_to_hcd(xhci)->self.controller;
+	base = &xhci->cap_regs->hc_capbase;
+
+	dbc_cap_offs = xhci_find_next_ext_cap(base, 0, XHCI_EXT_CAPS_DEBUG);
+	if (!dbc_cap_offs)
+		return -ENODEV;
+
+	/* already allocated and in use */
+	if (xhci->dbc)
+		return -EBUSY;
+
+	xhci->dbc = xhci_alloc_dbc(dev, base);
+	if (!xhci->dbc)
+		return -ENOMEM;
 
 	ret = xhci_dbc_tty_probe(xhci);
 	if (ret)
 		goto init_err2;
 
-	ret = device_create_file(dev, &dev_attr_dbc);
-	if (ret)
-		goto init_err1;
-
 	return 0;
 
-init_err1:
-	xhci_dbc_tty_remove(xhci->dbc);
 init_err2:
 	xhci_do_dbc_exit(xhci);
-init_err3:
 	return ret;
 }
 
 void xhci_dbc_exit(struct xhci_hcd *xhci)
 {
-	struct device		*dev = xhci_to_hcd(xhci)->self.controller;
+	unsigned long		flags;
 
 	if (!xhci->dbc)
 		return;
 
-	device_remove_file(dev, &dev_attr_dbc);
 	xhci_dbc_tty_remove(xhci->dbc);
-	xhci_dbc_stop(xhci->dbc);
-	xhci_do_dbc_exit(xhci);
+	xhci_dbc_remove(xhci->dbc);
+	spin_lock_irqsave(&xhci->lock, flags);
+	xhci->dbc = NULL;
+	spin_unlock_irqrestore(&xhci->lock, flags);
 }
 
 #ifdef CONFIG_PM
-- 
2.35.1



