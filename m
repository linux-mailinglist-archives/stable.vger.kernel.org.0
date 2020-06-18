Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A44E1FE90F
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730561AbgFRCw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:52:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbgFRBIR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:08:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C73AB21D79;
        Thu, 18 Jun 2020 01:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442496;
        bh=stORPdFsRhgx7toJ62y60iPkcRMSoNPQRIYfOj7ngAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KLsPm7hJnbWbkeWByc7TbddDGdfXiM7IJdPEwC0VRcWWWay0APjydJYo+HVo8RQ26
         sH3xveTsD/GQ+6jyKvcdWBX0Ge2eHLChKieWBOrEkO24ZKs4roW88YUsDVqqEsCKuY
         ofempq+g2dYtDMYfgOm8Ym2Zphuo8SDiqqZSqhPk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 008/388] iio: pressure: bmp280: Tolerate IRQ before registering
Date:   Wed, 17 Jun 2020 21:01:45 -0400
Message-Id: <20200618010805.600873-8-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 29c209cc1108..2540e7c2358c 100644
--- a/drivers/iio/pressure/bmp280-core.c
+++ b/drivers/iio/pressure/bmp280-core.c
@@ -713,7 +713,7 @@ static int bmp180_measure(struct bmp280_data *data, u8 ctrl_meas)
 	unsigned int ctrl;
 
 	if (data->use_eoc)
-		init_completion(&data->done);
+		reinit_completion(&data->done);
 
 	ret = regmap_write(data->regmap, BMP280_REG_CTRL_MEAS, ctrl_meas);
 	if (ret)
@@ -969,6 +969,9 @@ static int bmp085_fetch_eoc_irq(struct device *dev,
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

