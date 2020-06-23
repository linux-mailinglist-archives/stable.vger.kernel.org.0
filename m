Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1E02060D0
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392876AbgFWUqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:46:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391022AbgFWUor (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:44:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2450521941;
        Tue, 23 Jun 2020 20:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945087;
        bh=P/xQFApdL9TuihnLUerhnPMfJWlHfPpcFKHFkh6WFKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=10khhRQDasRY7vbq5To2gXIXyraetx2ZQD8tGfc7qJSXh7YRMz4bRZgpoXcRX7Q/O
         AkjmCpZYeLgZMSqTPU29UKD2xezOFAnZ3hPdb5vue+kyRJXHGca5wWrCbEd/GEPjI9
         uUdvAnbee/AO8zdiBVhJ58eFSA4Tz4Op/R2tYrG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 006/136] iio: pressure: bmp280: Tolerate IRQ before registering
Date:   Tue, 23 Jun 2020 21:57:42 +0200
Message-Id: <20200623195303.933983517@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
References: <20200623195303.601828702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 97b31a6f5fb95b1ec6575b78a7240baddba34384 ]

With DEBUG_SHIRQ enabled we have a kernel crash

[  116.482696] BUG: kernel NULL pointer dereference, address: 0000000000000000

...

[  116.606571] Call Trace:
[  116.609023]  <IRQ>
[  116.611047]  complete+0x34/0x50
[  116.614206]  bmp085_eoc_irq+0x9/0x10 [bmp280]

because DEBUG_SHIRQ mechanism fires an IRQ before registration and drivers
ought to be able to handle an interrupt happening before request_irq() returns.

Fixes: aae953949651 ("iio: pressure: bmp280: add support for BMP085 EOC interrupt")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/bmp280-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/pressure/bmp280-core.c b/drivers/iio/pressure/bmp280-core.c
index 5f625ffa2a88d..3204dff34e0ad 100644
--- a/drivers/iio/pressure/bmp280-core.c
+++ b/drivers/iio/pressure/bmp280-core.c
@@ -651,7 +651,7 @@ static int bmp180_measure(struct bmp280_data *data, u8 ctrl_meas)
 	unsigned int ctrl;
 
 	if (data->use_eoc)
-		init_completion(&data->done);
+		reinit_completion(&data->done);
 
 	ret = regmap_write(data->regmap, BMP280_REG_CTRL_MEAS, ctrl_meas);
 	if (ret)
@@ -907,6 +907,9 @@ static int bmp085_fetch_eoc_irq(struct device *dev,
 			"trying to enforce it\n");
 		irq_trig = IRQF_TRIGGER_RISING;
 	}
+
+	init_completion(&data->done);
+
 	ret = devm_request_threaded_irq(dev,
 			irq,
 			bmp085_eoc_irq,
-- 
2.25.1



