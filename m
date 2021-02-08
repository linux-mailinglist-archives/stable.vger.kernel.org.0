Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874D331355B
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 15:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhBHOiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 09:38:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:46668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232714AbhBHOhu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 09:37:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B7CA64E2E;
        Mon,  8 Feb 2021 14:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612795028;
        bh=+HupK8FRrKV+qdzANXJSRPUmR43wpCm/m1CmcaIcrLs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jUUZnDB8WeFr5TT1NLwUBSLbfo50X9bMZZJg0ozxoVYFG+q98lRO4cAPDUywNwTO2
         pHfmVi8vpGDXaAjmEAmALtZUf1e/SXZSmWWf866wsl7j4nwy7jFQKNHRFf9L/X+94Q
         c79yjAQNx3ZTHlqRn+o4xWevoIZV1KnwPkGywY2T5IPBE4B8ModC9bwh6VqkAU82oy
         84J7X5qqn5G64MLsFYp6Z4MnxKZ8EGxS/6VKVQee2ZJ4Kicw7A2x/3xmQlqoFCInLe
         KNd8t0FXIEt6cT6o96C7fZl7yiwKDJ9SJ52ZLr23j8wA8rKgtn2XWAhWOtf4mcaI0Z
         rSYPbuhOyQenA==
Received: by pali.im (Postfix)
        id DDF0E9E0; Mon,  8 Feb 2021 15:37:05 +0100 (CET)
Date:   Mon, 8 Feb 2021 15:37:05 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     mathias.nyman@linux.intel.com, stable@vger.kernel.org,
        tmn505@gmail.com, yoshihiro.shimoda.uh@renesas.com
Subject: Re: FAILED: patch "[PATCH] usb: host: xhci: mvebu: make USB 3.0 PHY
 optional for Armada" failed to apply to 5.4-stable tree
Message-ID: <20210208143705.xi4jjy6unz5ueph4@pali>
References: <1612711854148237@kroah.com>
 <20210207155621.m4or6ktctyqnejhk@pali>
 <YCEN8PptcWpl5PvW@kroah.com>
 <YCEPdBfsxpWSdSar@kroah.com>
 <20210208110709.2ce5h3fdm3ftipcf@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210208110709.2ce5h3fdm3ftipcf@pali>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Monday 08 February 2021 12:07:09 Pali Rohár wrote:
> On Monday 08 February 2021 11:16:20 Greg KH wrote:
> > On Mon, Feb 08, 2021 at 11:09:52AM +0100, Greg KH wrote:
> > > On Sun, Feb 07, 2021 at 04:56:21PM +0100, Pali Rohár wrote:
> > > > On Sunday 07 February 2021 16:30:54 gregkh@linuxfoundation.org wrote:
> > > > > The patch below does not apply to the 5.4-stable tree.
> > > > > If someone wants it applied there, or to any other stable or longterm
> > > > > tree, then please email the backport, including the original git commit
> > > > > id to <stable@vger.kernel.org>.
> > > > > 
> > > > > thanks,
> > > > > 
> > > > > greg k-h
> > > > ...
> > > > > Fixes: bd3d25b07342 ("arm64: dts: marvell: armada-37xx: link USB hosts with their PHYs")
> > > > > Cc: <stable@vger.kernel.org> # 5.1+: ea17a0f153af: phy: marvell: comphy: Convert internal SMCC firmware return codes to errno
> > > > > Cc: <stable@vger.kernel.org> # 5.1+: f768e718911e: usb: host: xhci-plat: add priv quirk for skip PHY initialization
> > > > 
> > > > Hello Greg! Seems that you have forgot to apply some dependency patches.
> > > 
> > > You are right, I had one, not the other, now fixed up...
> > 
> > Nope, of_phy_put(phy) is not present in 5.4, so it needs a "real"
> > backport.
> > 
> > Can you do that?
> 
> Ok, I will look at it.

Now I have backported this patch to 5.4 version and tested it with old
arm trusted firmware (for which this patch is fixing support) and also
with the new arm trusted firmware. It is working fine in both cases.

Still this patch depends on two mentioned commits which are required.


From a04199cc1ca41f91622e03dfb8d7a2536cdd4f46 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Date: Mon, 1 Feb 2021 16:08:03 +0100
Subject: [PATCH] usb: host: xhci: mvebu: make USB 3.0 PHY optional for Armada
 3720
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[pali: Backported to 5.4 by replacing of_phy_put() with phy_put()]
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 drivers/usb/host/xhci-mvebu.c | 42 +++++++++++++++++++++++++++++++++++
 drivers/usb/host/xhci-mvebu.h |  6 +++++
 drivers/usb/host/xhci-plat.c  | 20 ++++++++++++++++-
 drivers/usb/host/xhci-plat.h  |  1 +
 4 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-mvebu.c b/drivers/usb/host/xhci-mvebu.c
index 60651a50770f..f27d5c2c42f3 100644
--- a/drivers/usb/host/xhci-mvebu.c
+++ b/drivers/usb/host/xhci-mvebu.c
@@ -8,6 +8,7 @@
 #include <linux/mbus.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/phy/phy.h>
 
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
@@ -74,6 +75,47 @@ int xhci_mvebu_mbus_init_quirk(struct usb_hcd *hcd)
 	return 0;
 }
 
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
+
 int xhci_mvebu_a3700_init_quirk(struct usb_hcd *hcd)
 {
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
diff --git a/drivers/usb/host/xhci-mvebu.h b/drivers/usb/host/xhci-mvebu.h
index ca0a3a5721dd..74b4d21a498a 100644
--- a/drivers/usb/host/xhci-mvebu.h
+++ b/drivers/usb/host/xhci-mvebu.h
@@ -12,6 +12,7 @@ struct usb_hcd;
 
 #if IS_ENABLED(CONFIG_USB_XHCI_MVEBU)
 int xhci_mvebu_mbus_init_quirk(struct usb_hcd *hcd);
+int xhci_mvebu_a3700_plat_setup(struct usb_hcd *hcd);
 int xhci_mvebu_a3700_init_quirk(struct usb_hcd *hcd);
 #else
 static inline int xhci_mvebu_mbus_init_quirk(struct usb_hcd *hcd)
@@ -19,6 +20,11 @@ static inline int xhci_mvebu_mbus_init_quirk(struct usb_hcd *hcd)
 	return 0;
 }
 
+static inline int xhci_mvebu_a3700_plat_setup(struct usb_hcd *hcd)
+{
+	return 0;
+}
+
 static inline int xhci_mvebu_a3700_init_quirk(struct usb_hcd *hcd)
 {
 	return 0;
diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 7f78818ebbb3..84cfa8544285 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -44,6 +44,16 @@ static void xhci_priv_plat_start(struct usb_hcd *hcd)
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
@@ -101,6 +111,7 @@ static const struct xhci_plat_priv xhci_plat_marvell_armada = {
 };
 
 static const struct xhci_plat_priv xhci_plat_marvell_armada3700 = {
+	.plat_setup = xhci_mvebu_a3700_plat_setup,
 	.init_quirk = xhci_mvebu_a3700_init_quirk,
 };
 
@@ -308,7 +319,14 @@ static int xhci_plat_probe(struct platform_device *pdev)
 
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
diff --git a/drivers/usb/host/xhci-plat.h b/drivers/usb/host/xhci-plat.h
index 5681723fc9cd..b7749151bdfb 100644
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
-- 
2.20.1
