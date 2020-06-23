Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B62206236
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390256AbgFWU5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392429AbgFWUmp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:42:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14B78218AC;
        Tue, 23 Jun 2020 20:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944964;
        bh=xadqCNRl+pQYANsrXX3gSEkiRPvlxOBuzu8ThLrbcsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ngolo2drcV0T5pjH4I9jJtOWLrIm2nUy9ULOwOw6WnUKfrKZUigpQlCQckB+gcopr
         QFazmf1mmy61cjkwdzVHomMmwSNx0aucJIKZj7iR6cm2qaLlGXzmKSLmUvt6j4sxgs
         1PNUuv7Eo36/5EgozrGyZEnr1zbS0lys93JCT8fg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 163/206] usb: host: ehci-platform: add a quirk to avoid stuck
Date:   Tue, 23 Jun 2020 21:58:11 +0200
Message-Id: <20200623195325.017411182@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit cc7eac1e4afdd151085be4d0341a155760388653 ]

Since EHCI/OHCI controllers on R-Car Gen3 SoCs are possible to
be getting stuck very rarely after a full/low usb device was
disconnected. To detect/recover from such a situation, the controllers
require a special way which poll the EHCI PORTSC register and changes
the OHCI functional state.

So, this patch adds a polling timer into the ehci-platform driver,
and if the ehci driver detects the issue by the EHCI PORTSC register,
the ehci driver removes a companion device (= the OHCI controller)
to change the OHCI functional state to USB Reset once. And then,
the ehci driver adds the companion device again.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/1580114262-25029-1-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ehci-platform.c | 127 +++++++++++++++++++++++++++++++
 include/linux/usb/ehci_def.h     |   2 +-
 2 files changed, 128 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-platform.c b/drivers/usb/host/ehci-platform.c
index 4c306fb6b0699..8a45362155c5a 100644
--- a/drivers/usb/host/ehci-platform.c
+++ b/drivers/usb/host/ehci-platform.c
@@ -29,6 +29,8 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/reset.h>
+#include <linux/sys_soc.h>
+#include <linux/timer.h>
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
 #include <linux/usb/ehci_pdriver.h>
@@ -44,6 +46,9 @@ struct ehci_platform_priv {
 	struct clk *clks[EHCI_MAX_CLKS];
 	struct reset_control *rsts;
 	bool reset_on_resume;
+	bool quirk_poll;
+	struct timer_list poll_timer;
+	struct delayed_work poll_work;
 };
 
 static const char hcd_name[] = "ehci-platform";
@@ -118,6 +123,111 @@ static struct usb_ehci_pdata ehci_platform_defaults = {
 	.power_off =		ehci_platform_power_off,
 };
 
+/**
+ * quirk_poll_check_port_status - Poll port_status if the device sticks
+ * @ehci: the ehci hcd pointer
+ *
+ * Since EHCI/OHCI controllers on R-Car Gen3 SoCs are possible to be getting
+ * stuck very rarely after a full/low usb device was disconnected. To
+ * detect such a situation, the controllers require a special way which poll
+ * the EHCI PORTSC register.
+ *
+ * Return: true if the controller's port_status indicated getting stuck
+ */
+static bool quirk_poll_check_port_status(struct ehci_hcd *ehci)
+{
+	u32 port_status = ehci_readl(ehci, &ehci->regs->port_status[0]);
+
+	if (!(port_status & PORT_OWNER) &&
+	     (port_status & PORT_POWER) &&
+	    !(port_status & PORT_CONNECT) &&
+	     (port_status & PORT_LS_MASK))
+		return true;
+
+	return false;
+}
+
+/**
+ * quirk_poll_rebind_companion - rebind comanion device to recover
+ * @ehci: the ehci hcd pointer
+ *
+ * Since EHCI/OHCI controllers on R-Car Gen3 SoCs are possible to be getting
+ * stuck very rarely after a full/low usb device was disconnected. To
+ * recover from such a situation, the controllers require changing the OHCI
+ * functional state.
+ */
+static void quirk_poll_rebind_companion(struct ehci_hcd *ehci)
+{
+	struct device *companion_dev;
+	struct usb_hcd *hcd = ehci_to_hcd(ehci);
+
+	companion_dev = usb_of_get_companion_dev(hcd->self.controller);
+	if (!companion_dev)
+		return;
+
+	device_release_driver(companion_dev);
+	if (device_attach(companion_dev) < 0)
+		ehci_err(ehci, "%s: failed\n", __func__);
+
+	put_device(companion_dev);
+}
+
+static void quirk_poll_work(struct work_struct *work)
+{
+	struct ehci_platform_priv *priv =
+		container_of(to_delayed_work(work), struct ehci_platform_priv,
+			     poll_work);
+	struct ehci_hcd *ehci = container_of((void *)priv, struct ehci_hcd,
+					     priv);
+
+	/* check the status twice to reduce misdetection rate */
+	if (!quirk_poll_check_port_status(ehci))
+		return;
+	udelay(10);
+	if (!quirk_poll_check_port_status(ehci))
+		return;
+
+	ehci_dbg(ehci, "%s: detected getting stuck. rebind now!\n", __func__);
+	quirk_poll_rebind_companion(ehci);
+}
+
+static void quirk_poll_timer(struct timer_list *t)
+{
+	struct ehci_platform_priv *priv = from_timer(priv, t, poll_timer);
+	struct ehci_hcd *ehci = container_of((void *)priv, struct ehci_hcd,
+					     priv);
+
+	if (quirk_poll_check_port_status(ehci)) {
+		/*
+		 * Now scheduling the work for testing the port more. Note that
+		 * updating the status is possible to be delayed when
+		 * reconnection. So, this uses delayed work with 5 ms delay
+		 * to avoid misdetection.
+		 */
+		schedule_delayed_work(&priv->poll_work, msecs_to_jiffies(5));
+	}
+
+	mod_timer(&priv->poll_timer, jiffies + HZ);
+}
+
+static void quirk_poll_init(struct ehci_platform_priv *priv)
+{
+	INIT_DELAYED_WORK(&priv->poll_work, quirk_poll_work);
+	timer_setup(&priv->poll_timer, quirk_poll_timer, 0);
+	mod_timer(&priv->poll_timer, jiffies + HZ);
+}
+
+static void quirk_poll_end(struct ehci_platform_priv *priv)
+{
+	del_timer_sync(&priv->poll_timer);
+	cancel_delayed_work(&priv->poll_work);
+}
+
+static const struct soc_device_attribute quirk_poll_match[] = {
+	{ .family = "R-Car Gen3" },
+	{ /* sentinel*/ }
+};
+
 static int ehci_platform_probe(struct platform_device *dev)
 {
 	struct usb_hcd *hcd;
@@ -178,6 +288,9 @@ static int ehci_platform_probe(struct platform_device *dev)
 					  "has-transaction-translator"))
 			hcd->has_tt = 1;
 
+		if (soc_device_match(quirk_poll_match))
+			priv->quirk_poll = true;
+
 		for (clk = 0; clk < EHCI_MAX_CLKS; clk++) {
 			priv->clks[clk] = of_clk_get(dev->dev.of_node, clk);
 			if (IS_ERR(priv->clks[clk])) {
@@ -249,6 +362,9 @@ static int ehci_platform_probe(struct platform_device *dev)
 	device_enable_async_suspend(hcd->self.controller);
 	platform_set_drvdata(dev, hcd);
 
+	if (priv->quirk_poll)
+		quirk_poll_init(priv);
+
 	return err;
 
 err_power:
@@ -275,6 +391,9 @@ static int ehci_platform_remove(struct platform_device *dev)
 	struct ehci_platform_priv *priv = hcd_to_ehci_priv(hcd);
 	int clk;
 
+	if (priv->quirk_poll)
+		quirk_poll_end(priv);
+
 	usb_remove_hcd(hcd);
 
 	if (pdata->power_off)
@@ -299,9 +418,13 @@ static int ehci_platform_suspend(struct device *dev)
 	struct usb_hcd *hcd = dev_get_drvdata(dev);
 	struct usb_ehci_pdata *pdata = dev_get_platdata(dev);
 	struct platform_device *pdev = to_platform_device(dev);
+	struct ehci_platform_priv *priv = hcd_to_ehci_priv(hcd);
 	bool do_wakeup = device_may_wakeup(dev);
 	int ret;
 
+	if (priv->quirk_poll)
+		quirk_poll_end(priv);
+
 	ret = ehci_suspend(hcd, do_wakeup);
 	if (ret)
 		return ret;
@@ -333,6 +456,10 @@ static int ehci_platform_resume(struct device *dev)
 	}
 
 	ehci_resume(hcd, priv->reset_on_resume);
+
+	if (priv->quirk_poll)
+		quirk_poll_init(priv);
+
 	return 0;
 }
 #endif /* CONFIG_PM_SLEEP */
diff --git a/include/linux/usb/ehci_def.h b/include/linux/usb/ehci_def.h
index a15ce99dfc2d6..78e0063555575 100644
--- a/include/linux/usb/ehci_def.h
+++ b/include/linux/usb/ehci_def.h
@@ -151,7 +151,7 @@ struct ehci_regs {
 #define PORT_OWNER	(1<<13)		/* true: companion hc owns this port */
 #define PORT_POWER	(1<<12)		/* true: has power (see PPC) */
 #define PORT_USB11(x) (((x)&(3<<10)) == (1<<10))	/* USB 1.1 device */
-/* 11:10 for detecting lowspeed devices (reset vs release ownership) */
+#define PORT_LS_MASK	(3<<10)		/* Link status (SE0, K or J */
 /* 9 reserved */
 #define PORT_LPM	(1<<9)		/* LPM transaction */
 #define PORT_RESET	(1<<8)		/* reset port */
-- 
2.25.1



