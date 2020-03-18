Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1A9C189E62
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 15:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgCRO5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 10:57:36 -0400
Received: from mga14.intel.com ([192.55.52.115]:44531 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbgCRO5f (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 10:57:35 -0400
IronPort-SDR: U1kvH1K6d7L2jJKBsKLBr7pmqYNpp42iDi8E4WSFtyejXchbpuLN88RVQSGrA6xKETqY2Ms4Pc
 WnO5Yq5/r8zQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 07:57:33 -0700
IronPort-SDR: Kj1JGDxudZsR0WZfdhQWYkDGnDHLMNhbr5SMNtUBvqyNEyEhXBNPkmJct1NGpDX6JhcjICcDKA
 1gd/NRZGeefQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,568,1574150400"; 
   d="scan'208";a="238212845"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga008.fm.intel.com with ESMTP; 18 Mar 2020 07:57:32 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 747B519D; Wed, 18 Mar 2020 16:57:31 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>, stable@vger.kernel.org
Subject: [PATCH v1] gpio: name PCA953x gpio chips after device name
Date:   Wed, 18 Mar 2020 16:57:22 +0200
Message-Id: <20200318145722.48478-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Instead of using the name directly from the I2C client
to name the gpio_chip, use dev_name() on the client->dev,
so we get the sometimes more unique device name, as I2C has
a mechanism for naming its devices explicitly in e.g.
board data.

This is a prerequisite for being able to reference
uniquely any I2C GPIO expander defined in a board file
when setting up GPIO descriptor tables.

Reviewed-by: Robert Jarzmik <robert.jarzmik@free.fr>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Cc: stable@vger.kernel.org
---
Reported in https://stackoverflow.com/questions/60722524/how-to-specify-the-name-of-a-gpiochip-in-the-device-tree
 drivers/gpio/gpio-pca953x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 023a32cfac42..540166443c34 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -449,7 +449,7 @@ static void pca953x_setup_gpio(struct pca953x_chip *chip, int gpios)
 
 	gc->base = chip->gpio_start;
 	gc->ngpio = gpios;
-	gc->label = chip->client->name;
+	gc->label = dev_name(&chip->client->dev);
 	gc->parent = &chip->client->dev;
 	gc->owner = THIS_MODULE;
 	gc->names = chip->names;
-- 
2.25.1

