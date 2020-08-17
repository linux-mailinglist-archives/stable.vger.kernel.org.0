Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8D3246B41
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730927AbgHQPvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:51:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730834AbgHQPvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:51:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A27372072E;
        Mon, 17 Aug 2020 15:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679460;
        bh=LP/ESwE5uXSLHnZg76uKNJaf8JA4zFy3qEkEfQyv0Wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UUyBz0RdmxE/KOny3FtFvQTNNKFhFfsH05y8jH+3ktm99sC2eDFKlK8BOC8dG3Qv3
         m2k1ww0XOHkua0vNGXa0jq6NHQ5GkW3WiNuguLl7rNDQYP6GgrpI9hHG/4wg8I28a+
         2iX2soKo0mmMXOQThPhUBNuonRCEAN2slvgWZs6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 218/393] phy: renesas: rcar-gen3-usb2: move irq registration to init
Date:   Mon, 17 Aug 2020 17:14:28 +0200
Message-Id: <20200817143830.199525631@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit 08b0ad375ca66181faee725b1b358bcae8d592ee ]

If CONFIG_DEBUG_SHIRQ was enabled, r8a77951-salvator-xs could boot
correctly. If we appended "earlycon keep_bootcon" to the kernel
command like, we could get kernel log like below.

    SError Interrupt on CPU0, code 0xbf000002 -- SError
    CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.8.0-rc3-salvator-x-00505-g6c843129e6faaf01 #785
    Hardware name: Renesas Salvator-X 2nd version board based on r8a77951 (DT)
    pstate: 60400085 (nZCv daIf +PAN -UAO BTYPE=--)
    pc : rcar_gen3_phy_usb2_irq+0x14/0x54
    lr : free_irq+0xf4/0x27c

This means free_irq() calls the interrupt handler while PM runtime
is not getting if DEBUG_SHIRQ is enabled and rcar_gen3_phy_usb2_probe()
failed. To fix the issue, move the irq registration place to
rcar_gen3_phy_usb2_init() which is ready to handle the interrupts.

Note that after the commit 549b6b55b005 ("phy: renesas: rcar-gen3-usb2:
enable/disable independent irqs") which is merged into v5.2, since this
driver creates multiple phy instances, needs to check whether one of
phy instances is initialized. However, if we backport this patch to v5.1
or less, we don't need to check it because such kernel have single
phy instance.

Reported-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Fixes: 9f391c574efc ("phy: rcar-gen3-usb2: add runtime ID/VBUS pin detection")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/1594986297-12434-2-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/renesas/phy-rcar-gen3-usb2.c | 61 +++++++++++++-----------
 1 file changed, 33 insertions(+), 28 deletions(-)

diff --git a/drivers/phy/renesas/phy-rcar-gen3-usb2.c b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
index bfb22f868857f..5087b7c44d55b 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -111,6 +111,7 @@ struct rcar_gen3_chan {
 	struct work_struct work;
 	struct mutex lock;	/* protects rphys[...].powered */
 	enum usb_dr_mode dr_mode;
+	int irq;
 	bool extcon_host;
 	bool is_otg_channel;
 	bool uses_otg_pins;
@@ -389,12 +390,38 @@ static void rcar_gen3_init_otg(struct rcar_gen3_chan *ch)
 	rcar_gen3_device_recognition(ch);
 }
 
+static irqreturn_t rcar_gen3_phy_usb2_irq(int irq, void *_ch)
+{
+	struct rcar_gen3_chan *ch = _ch;
+	void __iomem *usb2_base = ch->base;
+	u32 status = readl(usb2_base + USB2_OBINTSTA);
+	irqreturn_t ret = IRQ_NONE;
+
+	if (status & USB2_OBINT_BITS) {
+		dev_vdbg(ch->dev, "%s: %08x\n", __func__, status);
+		writel(USB2_OBINT_BITS, usb2_base + USB2_OBINTSTA);
+		rcar_gen3_device_recognition(ch);
+		ret = IRQ_HANDLED;
+	}
+
+	return ret;
+}
+
 static int rcar_gen3_phy_usb2_init(struct phy *p)
 {
 	struct rcar_gen3_phy *rphy = phy_get_drvdata(p);
 	struct rcar_gen3_chan *channel = rphy->ch;
 	void __iomem *usb2_base = channel->base;
 	u32 val;
+	int ret;
+
+	if (!rcar_gen3_is_any_rphy_initialized(channel) && channel->irq >= 0) {
+		INIT_WORK(&channel->work, rcar_gen3_phy_usb2_work);
+		ret = request_irq(channel->irq, rcar_gen3_phy_usb2_irq,
+				  IRQF_SHARED, dev_name(channel->dev), channel);
+		if (ret < 0)
+			dev_err(channel->dev, "No irq handler (%d)\n", channel->irq);
+	}
 
 	/* Initialize USB2 part */
 	val = readl(usb2_base + USB2_INT_ENABLE);
@@ -433,6 +460,9 @@ static int rcar_gen3_phy_usb2_exit(struct phy *p)
 		val &= ~USB2_INT_ENABLE_UCOM_INTEN;
 	writel(val, usb2_base + USB2_INT_ENABLE);
 
+	if (channel->irq >= 0 && !rcar_gen3_is_any_rphy_initialized(channel))
+		free_irq(channel->irq, channel);
+
 	return 0;
 }
 
@@ -503,23 +533,6 @@ static const struct phy_ops rz_g1c_phy_usb2_ops = {
 	.owner		= THIS_MODULE,
 };
 
-static irqreturn_t rcar_gen3_phy_usb2_irq(int irq, void *_ch)
-{
-	struct rcar_gen3_chan *ch = _ch;
-	void __iomem *usb2_base = ch->base;
-	u32 status = readl(usb2_base + USB2_OBINTSTA);
-	irqreturn_t ret = IRQ_NONE;
-
-	if (status & USB2_OBINT_BITS) {
-		dev_vdbg(ch->dev, "%s: %08x\n", __func__, status);
-		writel(USB2_OBINT_BITS, usb2_base + USB2_OBINTSTA);
-		rcar_gen3_device_recognition(ch);
-		ret = IRQ_HANDLED;
-	}
-
-	return ret;
-}
-
 static const struct of_device_id rcar_gen3_phy_usb2_match_table[] = {
 	{
 		.compatible = "renesas,usb2-phy-r8a77470",
@@ -598,7 +611,7 @@ static int rcar_gen3_phy_usb2_probe(struct platform_device *pdev)
 	struct phy_provider *provider;
 	struct resource *res;
 	const struct phy_ops *phy_usb2_ops;
-	int irq, ret = 0, i;
+	int ret = 0, i;
 
 	if (!dev->of_node) {
 		dev_err(dev, "This driver needs device tree\n");
@@ -614,16 +627,8 @@ static int rcar_gen3_phy_usb2_probe(struct platform_device *pdev)
 	if (IS_ERR(channel->base))
 		return PTR_ERR(channel->base);
 
-	/* call request_irq for OTG */
-	irq = platform_get_irq_optional(pdev, 0);
-	if (irq >= 0) {
-		INIT_WORK(&channel->work, rcar_gen3_phy_usb2_work);
-		irq = devm_request_irq(dev, irq, rcar_gen3_phy_usb2_irq,
-				       IRQF_SHARED, dev_name(dev), channel);
-		if (irq < 0)
-			dev_err(dev, "No irq handler (%d)\n", irq);
-	}
-
+	/* get irq number here and request_irq for OTG in phy_init */
+	channel->irq = platform_get_irq_optional(pdev, 0);
 	channel->dr_mode = rcar_gen3_get_dr_mode(dev->of_node);
 	if (channel->dr_mode != USB_DR_MODE_UNKNOWN) {
 		int ret;
-- 
2.25.1



