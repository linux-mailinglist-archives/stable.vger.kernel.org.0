Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9B840E49D
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244285AbhIPREw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:04:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347308AbhIPQ6p (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:58:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 736F161ABF;
        Thu, 16 Sep 2021 16:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809921;
        bh=vSCHNd0fBThLqXKbCXghXdPcsOfYDxh1LqWH4fhyoko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XipPWaH7lMvKhzv6LM3sf4Ydk+hft4Roxn7xY9zabvrSu/EA1aDocZfycuutW0INs
         61884eXGVyEDiuSnkqxhMiBDKk+xAcNwQKbcfT/S+ofaW8E7bqL9beR7u0gFY5tnpD
         tlzPHWWN4dNf6B87DFCFzJysABporcbYpWs5QAYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Felipe Balbi <balbi@kernel.org>,
        Nadezda Lutovinova <lutovinova@ispras.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 315/380] usb: dwc3: imx8mp: request irq after initializing dwc3
Date:   Thu, 16 Sep 2021 18:01:12 +0200
Message-Id: <20210916155814.768332033@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadezda Lutovinova <lutovinova@ispras.ru>

[ Upstream commit 6a48d0ae01a6ab05ae5e78328546a2f5f6d3054a ]

If IRQ occurs between calling  devm_request_threaded_irq() and
initializing dwc3_imx->dwc3, then null pointer dereference occurs
since dwc3_imx->dwc3 is used in dwc3_imx8mp_interrupt().

The patch puts registration of the interrupt handler after
initializing of neccesery data.

Found by Linux Driver Verification project (linuxtesting.org).

Reviewed-by: Fabio Estevam <festevam@gmail.com>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Nadezda Lutovinova <lutovinova@ispras.ru>
Link: https://lore.kernel.org/r/20210819154818.18334-1-lutovinova@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-imx8mp.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-imx8mp.c b/drivers/usb/dwc3/dwc3-imx8mp.c
index 756faa46d33a..d328d20abfbc 100644
--- a/drivers/usb/dwc3/dwc3-imx8mp.c
+++ b/drivers/usb/dwc3/dwc3-imx8mp.c
@@ -152,13 +152,6 @@ static int dwc3_imx8mp_probe(struct platform_device *pdev)
 	}
 	dwc3_imx->irq = irq;
 
-	err = devm_request_threaded_irq(dev, irq, NULL, dwc3_imx8mp_interrupt,
-					IRQF_ONESHOT, dev_name(dev), dwc3_imx);
-	if (err) {
-		dev_err(dev, "failed to request IRQ #%d --> %d\n", irq, err);
-		goto disable_clks;
-	}
-
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 	err = pm_runtime_get_sync(dev);
@@ -186,6 +179,13 @@ static int dwc3_imx8mp_probe(struct platform_device *pdev)
 	}
 	of_node_put(dwc3_np);
 
+	err = devm_request_threaded_irq(dev, irq, NULL, dwc3_imx8mp_interrupt,
+					IRQF_ONESHOT, dev_name(dev), dwc3_imx);
+	if (err) {
+		dev_err(dev, "failed to request IRQ #%d --> %d\n", irq, err);
+		goto depopulate;
+	}
+
 	device_set_wakeup_capable(dev, true);
 	pm_runtime_put(dev);
 
-- 
2.30.2



