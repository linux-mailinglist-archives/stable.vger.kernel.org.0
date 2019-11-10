Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5EDF63FC
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729549AbfKJCtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:49:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:59966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729545AbfKJCtr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:49:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 382B122593;
        Sun, 10 Nov 2019 02:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354186;
        bh=W0mfyXlOQJc8EOdIZJoXJvWy43HYarysZdwefjnP4tY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S8hwVNMZC+GfZmJyHs1U27XPE9GDCMnRDanIgNX8MQkd4XrLw7SUzFIqPEAtedjY8
         nG2W/E6ckUW3PdBUdybz0MLX7xGacGMoq7UnvePliSOvooy4PK1N83+bO6Yeyyr3YB
         8pu4tg+ETP5cDSiaia+McTEiNzJfmRQ96TNajTVk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Kemnade <andreas@kemnade.info>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 35/66] phy: phy-twl4030-usb: fix denied runtime access
Date:   Sat,  9 Nov 2019 21:48:14 -0500
Message-Id: <20191110024846.32598-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024846.32598-1-sashal@kernel.org>
References: <20191110024846.32598-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit 6c7103aa026094a4ee2c2708ec6977a6dfc5331d ]

When runtime is not enabled, pm_runtime_get_sync() returns -EACCESS,
the counter will be incremented but the resume callback not called,
so enumeration and charging will not start properly.
To avoid that happen, disable irq on suspend and recheck on resume.

Practically this happens when the device is woken up from suspend by
plugging in usb.

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/phy-twl4030-usb.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
index 547ca7b3f0985..ddb530ee2255c 100644
--- a/drivers/phy/phy-twl4030-usb.c
+++ b/drivers/phy/phy-twl4030-usb.c
@@ -144,6 +144,7 @@
 #define PMBR1				0x0D
 #define GPIO_USB_4PIN_ULPI_2430C	(3 << 0)
 
+static irqreturn_t twl4030_usb_irq(int irq, void *_twl);
 /*
  * If VBUS is valid or ID is ground, then we know a
  * cable is present and we need to be runtime-enabled
@@ -392,6 +393,33 @@ static void __twl4030_phy_power(struct twl4030_usb *twl, int on)
 	WARN_ON(twl4030_usb_write_verify(twl, PHY_PWR_CTRL, pwr) < 0);
 }
 
+static int __maybe_unused twl4030_usb_suspend(struct device *dev)
+{
+	struct twl4030_usb *twl = dev_get_drvdata(dev);
+
+	/*
+	 * we need enabled runtime on resume,
+	 * so turn irq off here, so we do not get it early
+	 * note: wakeup on usb plug works independently of this
+	 */
+	dev_dbg(twl->dev, "%s\n", __func__);
+	disable_irq(twl->irq);
+
+	return 0;
+}
+
+static int __maybe_unused twl4030_usb_resume(struct device *dev)
+{
+	struct twl4030_usb *twl = dev_get_drvdata(dev);
+
+	dev_dbg(twl->dev, "%s\n", __func__);
+	enable_irq(twl->irq);
+	/* check whether cable status changed */
+	twl4030_usb_irq(0, twl);
+
+	return 0;
+}
+
 static int __maybe_unused twl4030_usb_runtime_suspend(struct device *dev)
 {
 	struct twl4030_usb *twl = dev_get_drvdata(dev);
@@ -652,6 +680,7 @@ static const struct phy_ops ops = {
 static const struct dev_pm_ops twl4030_usb_pm_ops = {
 	SET_RUNTIME_PM_OPS(twl4030_usb_runtime_suspend,
 			   twl4030_usb_runtime_resume, NULL)
+	SET_SYSTEM_SLEEP_PM_OPS(twl4030_usb_suspend, twl4030_usb_resume)
 };
 
 static int twl4030_usb_probe(struct platform_device *pdev)
-- 
2.20.1

