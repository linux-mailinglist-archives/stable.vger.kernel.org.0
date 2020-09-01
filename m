Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E947259B60
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbgIARA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:41642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729402AbgIAPVJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:21:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0614206FA;
        Tue,  1 Sep 2020 15:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973669;
        bh=zhgQvzd9WGYemK0tA6PXpmnGY1fwRmaxSlZXCyx0CAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UrfpdObO6T95P/5qO1WHJPJJaVxQwrw+y7ocaYXn/1K0oKktf0D9I77Qzka6XMRzT
         ZYgHN5nMsnqNk5XCIWtlrI5l6jTiEQtgOY4WdJCWYs/0AQxqtc9X7zkkqEkkBLTJ4k
         gliEAShbCO+S4i1TFDufIrle1JGGoimDp2f5M5uU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Tamseel Shams <m.shams@samsung.com>
Subject: [PATCH 4.14 64/91] serial: samsung: Removes the IRQ not found warning
Date:   Tue,  1 Sep 2020 17:10:38 +0200
Message-Id: <20200901150931.331859762@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150928.096174795@linuxfoundation.org>
References: <20200901150928.096174795@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tamseel Shams <m.shams@samsung.com>

commit 8c6c378b0cbe0c9f1390986b5f8ffb5f6ff7593b upstream.

In few older Samsung SoCs like s3c2410, s3c2412
and s3c2440, UART IP is having 2 interrupt lines.
However, in other SoCs like s3c6400, s5pv210,
exynos5433, and exynos4210 UART is having only 1
interrupt line. Due to this, "platform_get_irq(platdev, 1)"
call in the driver gives the following false-positive error:
"IRQ index 1 not found" on newer SoC's.

This patch adds the condition to check for Tx interrupt
only for the those SoC's which have 2 interrupt lines.

Tested-by: Alim Akhtar <alim.akhtar@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Tamseel Shams <m.shams@samsung.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200810030021.45348-1-m.shams@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/samsung.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1733,9 +1733,11 @@ static int s3c24xx_serial_init_port(stru
 		ourport->tx_irq = ret + 1;
 	}
 
-	ret = platform_get_irq(platdev, 1);
-	if (ret > 0)
-		ourport->tx_irq = ret;
+	if (!s3c24xx_serial_has_interrupt_mask(port)) {
+		ret = platform_get_irq(platdev, 1);
+		if (ret > 0)
+			ourport->tx_irq = ret;
+	}
 	/*
 	 * DMA is currently supported only on DT platforms, if DMA properties
 	 * are specified.


