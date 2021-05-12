Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC4F37C45A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbhELPan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:30:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235073AbhELP0j (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:26:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FB62619E6;
        Wed, 12 May 2021 15:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832288;
        bh=lGBwzYM6UPRK04oz/BIx4ywRA0Ft18OoVzFBSvPbXa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LG3ooePnZc9clYsh/fXc6oVj7nzk4DFb7CgELwjAGgBcrrQtKsB54LGzRyqPu9nai
         Vwihv/WENKrv38HiozAuwD14EKN9rbLEiq5EU/OEQMzQMw9gZyALpcEOlygG7Ra4bf
         upipv1gosMBEN4juwj3HpXUmH5LqINFDWnacS5/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 183/530] usb: gadget: s3c: Fix the error handling path in s3c2410_udc_probe()
Date:   Wed, 12 May 2021 16:44:53 +0200
Message-Id: <20210512144825.855562227@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit e5242861ec6a0bce25b4cd10af0fc8a508fd067d ]

Some 'clk_prepare_enable()' and 'clk_get()' must be undone in the error
handling path of the probe function, as already done in the remove
function.

Fixes: 3fc154b6b813 ("USB Gadget driver for Samsung s3c2410 ARM SoC")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/2bee52e4ce968f48b4c32545cf8f3b2ab825ba82.1616830026.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/s3c2410_udc.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/udc/s3c2410_udc.c b/drivers/usb/gadget/udc/s3c2410_udc.c
index b81979b3bdb6..b154b62abefa 100644
--- a/drivers/usb/gadget/udc/s3c2410_udc.c
+++ b/drivers/usb/gadget/udc/s3c2410_udc.c
@@ -1750,7 +1750,8 @@ static int s3c2410_udc_probe(struct platform_device *pdev)
 	udc_clock = clk_get(NULL, "usb-device");
 	if (IS_ERR(udc_clock)) {
 		dev_err(dev, "failed to get udc clock source\n");
-		return PTR_ERR(udc_clock);
+		retval = PTR_ERR(udc_clock);
+		goto err_usb_bus_clk;
 	}
 
 	clk_prepare_enable(udc_clock);
@@ -1773,7 +1774,7 @@ static int s3c2410_udc_probe(struct platform_device *pdev)
 	base_addr = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(base_addr)) {
 		retval = PTR_ERR(base_addr);
-		goto err;
+		goto err_udc_clk;
 	}
 
 	the_controller = udc;
@@ -1791,7 +1792,7 @@ static int s3c2410_udc_probe(struct platform_device *pdev)
 	if (retval != 0) {
 		dev_err(dev, "cannot get irq %i, err %d\n", irq_usbd, retval);
 		retval = -EBUSY;
-		goto err;
+		goto err_udc_clk;
 	}
 
 	dev_dbg(dev, "got irq %i\n", irq_usbd);
@@ -1862,7 +1863,14 @@ err_gpio_claim:
 		gpio_free(udc_info->vbus_pin);
 err_int:
 	free_irq(irq_usbd, udc);
-err:
+err_udc_clk:
+	clk_disable_unprepare(udc_clock);
+	clk_put(udc_clock);
+	udc_clock = NULL;
+err_usb_bus_clk:
+	clk_disable_unprepare(usb_bus_clock);
+	clk_put(usb_bus_clock);
+	usb_bus_clock = NULL;
 
 	return retval;
 }
-- 
2.30.2



