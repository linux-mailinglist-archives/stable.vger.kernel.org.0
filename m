Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3AC11B7B2
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731017AbfLKPL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:11:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:60832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731012AbfLKPL6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:11:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A86AB2173E;
        Wed, 11 Dec 2019 15:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077117;
        bh=XebHkKGdyvyJe9x4eWTtKYtITQBxEm2abSNYs2wk4TQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JcAB0e/CbI8YBwYoehpJzcMMFVSJPlxthIpWlIb3ITPx+a2Tq5j2G4L/Vb03IY/BK
         uOeT37i8wuZBPoLb2EPNMu5evyRJ1QuYPSv/ts5OuXA5fVOivSCB/funX9BkxPu/Vq
         XCWSglvn6f+fJtDDx57aIGAQp1a4N4eM+StGtKt0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anson Huang <Anson.Huang@nxp.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 006/134] gpio: mxc: Only get the second IRQ when there is more than one IRQ
Date:   Wed, 11 Dec 2019 10:09:42 -0500
Message-Id: <20191211151150.19073-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

[ Upstream commit c8f3d144004dd3f471ffd414690d15a005e4acd6 ]

On some of i.MX SoCs like i.MX8QXP, there is ONLY one IRQ for each
GPIO bank, so it is better to check the IRQ count before getting
second IRQ to avoid below error message during probe:

[    1.070908] gpio-mxc 5d080000.gpio: IRQ index 1 not found
[    1.077420] gpio-mxc 5d090000.gpio: IRQ index 1 not found
[    1.083766] gpio-mxc 5d0a0000.gpio: IRQ index 1 not found
[    1.090122] gpio-mxc 5d0b0000.gpio: IRQ index 1 not found
[    1.096470] gpio-mxc 5d0c0000.gpio: IRQ index 1 not found
[    1.102804] gpio-mxc 5d0d0000.gpio: IRQ index 1 not found
[    1.109144] gpio-mxc 5d0e0000.gpio: IRQ index 1 not found
[    1.115475] gpio-mxc 5d0f0000.gpio: IRQ index 1 not found

Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mxc.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index 7907a87558662..c77d474185f31 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -411,6 +411,7 @@ static int mxc_gpio_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct mxc_gpio_port *port;
+	int irq_count;
 	int irq_base;
 	int err;
 
@@ -426,9 +427,15 @@ static int mxc_gpio_probe(struct platform_device *pdev)
 	if (IS_ERR(port->base))
 		return PTR_ERR(port->base);
 
-	port->irq_high = platform_get_irq(pdev, 1);
-	if (port->irq_high < 0)
-		port->irq_high = 0;
+	irq_count = platform_irq_count(pdev);
+	if (irq_count < 0)
+		return irq_count;
+
+	if (irq_count > 1) {
+		port->irq_high = platform_get_irq(pdev, 1);
+		if (port->irq_high < 0)
+			port->irq_high = 0;
+	}
 
 	port->irq = platform_get_irq(pdev, 0);
 	if (port->irq < 0)
-- 
2.20.1

