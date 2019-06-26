Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC86560A1
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfFZDnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:43:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727289AbfFZDnS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:43:18 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-74.mobile.att.net [107.77.172.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C988F20659;
        Wed, 26 Jun 2019 03:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520598;
        bh=nmVqm5LCFkN57JcvZZ3jWRa4TbV2CnF7sjsDTG8/21g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oj3KhlkTDOL0SVQQZacBz9WkB7BPKTbaqBnuvXFQ7uAJLPHgG/PlrUnUowFxeXCAP
         d9Sk0HUBa0nlUWJjt+DTkxorCPO5mRTe2M8LE4E2CGp/A57H8OfJ6kVNijYqd7+Szj
         T0ihNz78K1g3kdPBR7qH3RbEPFSEcQUwK268yK8k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 44/51] i2c: pca-platform: Fix GPIO lookup code
Date:   Tue, 25 Jun 2019 23:41:00 -0400
Message-Id: <20190626034117.23247-44-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034117.23247-1-sashal@kernel.org>
References: <20190626034117.23247-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit a0cac264a86fbf4d6cb201fbbb73c1d335e3248a ]

The devm_gpiod_request_gpiod() call will add "-gpios" to
any passed connection ID before looking it up.

I do not think the reset GPIO on this platform is named
"reset-gpios-gpios" but rather "reset-gpios" in the device
tree, so fix this up so that we get a proper reset GPIO
handle.

Also drop the inclusion of the legacy GPIO header.

Fixes: 0e8ce93bdceb ("i2c: pca-platform: add devicetree awareness")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-pca-platform.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pca-platform.c b/drivers/i2c/busses/i2c-pca-platform.c
index de3fe6e828cb..f50afa8e3cba 100644
--- a/drivers/i2c/busses/i2c-pca-platform.c
+++ b/drivers/i2c/busses/i2c-pca-platform.c
@@ -21,7 +21,6 @@
 #include <linux/platform_device.h>
 #include <linux/i2c-algo-pca.h>
 #include <linux/platform_data/i2c-pca-platform.h>
-#include <linux/gpio.h>
 #include <linux/gpio/consumer.h>
 #include <linux/io.h>
 #include <linux/of.h>
@@ -173,7 +172,7 @@ static int i2c_pca_pf_probe(struct platform_device *pdev)
 	i2c->adap.dev.parent = &pdev->dev;
 	i2c->adap.dev.of_node = np;
 
-	i2c->gpio = devm_gpiod_get_optional(&pdev->dev, "reset-gpios", GPIOD_OUT_LOW);
+	i2c->gpio = devm_gpiod_get_optional(&pdev->dev, "reset", GPIOD_OUT_LOW);
 	if (IS_ERR(i2c->gpio))
 		return PTR_ERR(i2c->gpio);
 
-- 
2.20.1

