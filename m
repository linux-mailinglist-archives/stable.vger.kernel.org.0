Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B2440E7E5
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349901AbhIPRnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:43:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345608AbhIPRiS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:38:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CFFE63242;
        Thu, 16 Sep 2021 16:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811018;
        bh=vSCHNd0fBThLqXKbCXghXdPcsOfYDxh1LqWH4fhyoko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qr615oJJ2x1pJT1OXfUlQf9ZGHpe/0ga7C9G6ZRcqmc2h0bMqR1vaCw9TI60RzY/e
         BpdinplIe5IZ43OfCQ6H5yfuWOG4V8nN/EiRnTPd4bWsDbJCMZik88z6RSnf3jBMPl
         T1j5C37UAMpRHDejwfdEFtv+Npt0D8YToXuTady8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Felipe Balbi <balbi@kernel.org>,
        Nadezda Lutovinova <lutovinova@ispras.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 354/432] usb: dwc3: imx8mp: request irq after initializing dwc3
Date:   Thu, 16 Sep 2021 18:01:43 +0200
Message-Id: <20210916155822.813708515@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
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



