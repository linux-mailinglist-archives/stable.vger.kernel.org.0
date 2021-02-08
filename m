Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6CAE313812
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbhBHPg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:36:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:33886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233626AbhBHPRr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:17:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DF3064EDB;
        Mon,  8 Feb 2021 15:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797117;
        bh=USss8QpaSi1sWMdu67F1JOoKzz3+gnYUyjJplyxKF2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i98H9vzAgdPGI6UcPxmP6udI02sefvDDYTGXkoW/9iDJ9LcR7Ky3TVbxaGA4ZgnLA
         gcA0DRXSyr9/Mjg2TfRF2APIKLXef0aME+cCgBHQVkFEkMCFHbM0fW1NaHXT7IESDB
         judfoardMzV9wU0ITedi6rso92jU0XbSF0nRg5tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomasz Maciej Nowak <tmn505@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 5.4 65/65] usb: host: xhci: mvebu: make USB 3.0 PHY optional for Armada 3720
Date:   Mon,  8 Feb 2021 16:01:37 +0100
Message-Id: <20210208145812.734090745@linuxfoundation.org>
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

From: Pali Rohár <pali@kernel.org>

commit 3241929b67d28c83945d3191c6816a3271fd6b85 upstream.

Older ATF does not provide SMC call for USB 3.0 phy power on functionality
and therefore initialization of xhci-hcd is failing when older version of
ATF is used. In this case phy_power_on() function returns -EOPNOTSUPP.

[    3.108467] mvebu-a3700-comphy d0018300.phy: unsupported SMC call, try updating your firmware
[    3.117250] phy phy-d0018300.phy.0: phy poweron failed --> -95
[    3.123465] xhci-hcd: probe of d0058000.usb failed with error -95

This patch introduces a new plat_setup callback for xhci platform drivers
which is called prior calling usb_add_hcd() function. This function at its
beginning skips PHY init if hcd->skip_phy_initialization is set.

Current init_quirk callback for xhci platform drivers is called from
xhci_plat_setup() function which is called after chip reset completes.
It happens in the middle of the usb_add_hcd() function and therefore this
callback cannot be used for setting if PHY init should be skipped or not.

For Armada 3720 this patch introduce a new xhci_mvebu_a3700_plat_setup()
function configured as a xhci platform plat_setup callback. This new
function calls phy_power_on() and in case it returns -EOPNOTSUPP then
XHCI_SKIP_PHY_INIT quirk is set to instruct xhci-plat to skip PHY
initialization.

This patch fixes above failure by ignoring 'not supported' error in
xhci-hcd driver. In this case it is expected that phy is already power on.

It fixes initialization of xhci-hcd on Espressobin boards where is older
Marvell's Arm Trusted Firmware without SMC call for USB 3.0 phy power.

This is regression introduced in commit bd3d25b07342 ("arm64: dts: marvell:
armada-37xx: link USB hosts with their PHYs") where USB 3.0 phy was defined
and therefore xhci-hcd on Espressobin with older ATF started failing.

Fixes: bd3d25b07342 ("arm64: dts: marvell: armada-37xx: link USB hosts with their PHYs")
Cc: <stable@vger.kernel.org> # 5.1+: ea17a0f153af: phy: marvell: comphy: Convert internal SMCC firmware return codes to errno
Cc: <stable@vger.kernel.org> # 5.1+: f768e718911e: usb: host: xhci-plat: add priv quirk for skip PHY initialization
Tested-by: Tomasz Maciej Nowak <tmn505@gmail.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com> # On R-Car
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com> # xhci-plat
Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/20210201150803.7305-1-pali@kernel.org
[pali: Backported to 5.4 by replacing of_phy_put() with phy_put()]
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-mvebu.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 drivers/usb/host/xhci-mvebu.h |    6 ++++++
 drivers/usb/host/xhci-plat.c  |   20 +++++++++++++++++++-
 drivers/usb/host/xhci-plat.h  |    1 +
 4 files changed, 68 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-mvebu.c
+++ b/drivers/usb/host/xhci-mvebu.c
@@ -8,6 +8,7 @@
 #include <linux/mbus.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/phy/phy.h>
 
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
@@ -73,6 +74,47 @@ int xhci_mvebu_mbus_init_quirk(struct us
 
 	return 0;
 }
+
+int xhci_mvebu_a3700_plat_setup(struct usb_hcd *hcd)
+{
+	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
+	struct device *dev = hcd->self.controller;
+	struct phy *phy;
+	int ret;
+
+	/* Old bindings miss the PHY handle */
+	phy = of_phy_get(dev->of_node, "usb3-phy");
+	if (IS_ERR(phy) && PTR_ERR(phy) == -EPROBE_DEFER)
+		return -EPROBE_DEFER;
+	else if (IS_ERR(phy))
+		goto phy_out;
+
+	ret = phy_init(phy);
+	if (ret)
+		goto phy_put;
+
+	ret = phy_set_mode(phy, PHY_MODE_USB_HOST_SS);
+	if (ret)
+		goto phy_exit;
+
+	ret = phy_power_on(phy);
+	if (ret == -EOPNOTSUPP) {
+		/* Skip initializatin of XHCI PHY when it is unsupported by firmware */
+		dev_warn(dev, "PHY unsupported by firmware\n");
+		xhci->quirks |= XHCI_SKIP_PHY_INIT;
+	}
+	if (ret)
+		goto phy_exit;
+
+	phy_power_off(phy);
+phy_exit:
+	phy_exit(phy);
+phy_put:
+	phy_put(phy);
+phy_out:
+
+	return 0;
+}
 
 int xhci_mvebu_a3700_init_quirk(struct usb_hcd *hcd)
 {
--- a/drivers/usb/host/xhci-mvebu.h
+++ b/drivers/usb/host/xhci-mvebu.h
@@ -12,12 +12,18 @@ struct usb_hcd;
 
 #if IS_ENABLED(CONFIG_USB_XHCI_MVEBU)
 int xhci_mvebu_mbus_init_quirk(struct usb_hcd *hcd);
+int xhci_mvebu_a3700_plat_setup(struct usb_hcd *hcd);
 int xhci_mvebu_a3700_init_quirk(struct usb_hcd *hcd);
 #else
 static inline int xhci_mvebu_mbus_init_quirk(struct usb_hcd *hcd)
 {
 	return 0;
 }
+
+static inline int xhci_mvebu_a3700_plat_setup(struct usb_hcd *hcd)
+{
+	return 0;
+}
 
 static inline int xhci_mvebu_a3700_init_quirk(struct usb_hcd *hcd)
 {
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -44,6 +44,16 @@ static void xhci_priv_plat_start(struct
 		priv->plat_start(hcd);
 }
 
+static int xhci_priv_plat_setup(struct usb_hcd *hcd)
+{
+	struct xhci_plat_priv *priv = hcd_to_xhci_priv(hcd);
+
+	if (!priv->plat_setup)
+		return 0;
+
+	return priv->plat_setup(hcd);
+}
+
 static int xhci_priv_init_quirk(struct usb_hcd *hcd)
 {
 	struct xhci_plat_priv *priv = hcd_to_xhci_priv(hcd);
@@ -101,6 +111,7 @@ static const struct xhci_plat_priv xhci_
 };
 
 static const struct xhci_plat_priv xhci_plat_marvell_armada3700 = {
+	.plat_setup = xhci_mvebu_a3700_plat_setup,
 	.init_quirk = xhci_mvebu_a3700_init_quirk,
 };
 
@@ -308,7 +319,14 @@ static int xhci_plat_probe(struct platfo
 
 	hcd->tpl_support = of_usb_host_tpl_support(sysdev->of_node);
 	xhci->shared_hcd->tpl_support = hcd->tpl_support;
-	if (priv && (priv->quirks & XHCI_SKIP_PHY_INIT))
+
+	if (priv) {
+		ret = xhci_priv_plat_setup(hcd);
+		if (ret)
+			goto disable_usb_phy;
+	}
+
+	if ((xhci->quirks & XHCI_SKIP_PHY_INIT) || (priv && (priv->quirks & XHCI_SKIP_PHY_INIT)))
 		hcd->skip_phy_initialization = 1;
 
 	ret = usb_add_hcd(hcd, irq, IRQF_SHARED);
--- a/drivers/usb/host/xhci-plat.h
+++ b/drivers/usb/host/xhci-plat.h
@@ -13,6 +13,7 @@
 struct xhci_plat_priv {
 	const char *firmware_name;
 	unsigned long long quirks;
+	int (*plat_setup)(struct usb_hcd *);
 	void (*plat_start)(struct usb_hcd *);
 	int (*init_quirk)(struct usb_hcd *);
 	int (*resume_quirk)(struct usb_hcd *);


