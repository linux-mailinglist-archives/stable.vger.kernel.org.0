Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14353404D3A
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245325AbhIIMBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:01:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344163AbhIIL6n (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:58:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DA6B6140D;
        Thu,  9 Sep 2021 11:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187947;
        bh=vSCHNd0fBThLqXKbCXghXdPcsOfYDxh1LqWH4fhyoko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=azPGZSOre9fMmUJkmXOTrsGfN59XRXLxDypJRj73EG7PFrG9ey6hjMXepnd5PWfrt
         L0RrKUOtFLzCXHomdS9Rmg4sGaxyNzLOUXA8DzOx51dgkqkWEhup9UctRp2OIN06gS
         eFaY5oz90+Wiq//NdxHA44ur+SH8JqiKLHzYuKzKM/sPZnwkVzEC7LUdYwg52gM7LQ
         XAt6CxV1gcK76I8+x/+qsKczD53zJuUtgzQn8Dzc/C+2iTir3CTzU9bKS+tCtpPokX
         Z83h+QgFPb8g2psgUWnT+YCNk4aZkJF4oKhrZlwq3RtfkLN6HPETk5+3lRHo5gPEh5
         DuoDsbeG1vZiA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nadezda Lutovinova <lutovinova@ispras.ru>,
        Fabio Estevam <festevam@gmail.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 216/252] usb: dwc3: imx8mp: request irq after initializing dwc3
Date:   Thu,  9 Sep 2021 07:40:30 -0400
Message-Id: <20210909114106.141462-216-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

