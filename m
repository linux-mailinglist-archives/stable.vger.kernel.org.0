Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB11106F31
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730287AbfKVKyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:54:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730285AbfKVKyF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:54:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8946320637;
        Fri, 22 Nov 2019 10:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420045;
        bh=oeUILCoYnzNn+H2vA7zbnS+k6R6CH4wMXcGBPruayWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QdSji4yro4uv62+fIyCID/EAmWe6dQwFQJvAh0FUFMPqmarbrMQ9a3DMZ9rIGCcR0
         6KQttGmJumH0YcuIMGXCVx0gpEDXzH9yGeP0FspDGArijwHhU3P0dhML0R9uw1Qmsw
         5EWZo4Vli3qWKTerNxLI5VR65Aw+nmwi25gJfZgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vignesh R <vigneshr@ti.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 097/122] mfd: ti_am335x_tscadc: Keep ADC interface on if child is wakeup capable
Date:   Fri, 22 Nov 2019 11:29:10 +0100
Message-Id: <20191122100830.798920395@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vignesh R <vigneshr@ti.com>

[ Upstream commit c974ac771479327b5424f60d58845e31daddadea ]

If a child device like touchscreen is wakeup capable, then keep ADC
interface on, so that a touching resistive screen will generate wakeup
event to the system.

Signed-off-by: Vignesh R <vigneshr@ti.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/ti_am335x_tscadc.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index 5894d6c16fab8..ca9f0c8d1ed0f 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -296,11 +296,24 @@ static int ti_tscadc_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static int __maybe_unused ti_tscadc_can_wakeup(struct device *dev, void *data)
+{
+	return device_may_wakeup(dev);
+}
+
 static int __maybe_unused tscadc_suspend(struct device *dev)
 {
 	struct ti_tscadc_dev	*tscadc = dev_get_drvdata(dev);
 
 	regmap_write(tscadc->regmap, REG_SE, 0x00);
+	if (device_for_each_child(dev, NULL, ti_tscadc_can_wakeup)) {
+		u32 ctrl;
+
+		regmap_read(tscadc->regmap, REG_CTRL, &ctrl);
+		ctrl &= ~(CNTRLREG_POWERDOWN);
+		ctrl |= CNTRLREG_TSCSSENB;
+		regmap_write(tscadc->regmap, REG_CTRL, ctrl);
+	}
 	pm_runtime_put_sync(dev);
 
 	return 0;
-- 
2.20.1



