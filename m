Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A63A26237E
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733179AbfGHPe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:34:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390655AbfGHPeu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:34:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F19FF204EC;
        Mon,  8 Jul 2019 15:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562600089;
        bh=1y6TrxPpo4z/VeD6N4ELESCYUlwBI91glaQM5xDDCtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hc8PLI2jRy20ldAzu9exvzxgnLEh5iCGOvPFtT7FbSO6qWbnX5a+84RuJEgFatCLQ
         /jFfDJh3qrx6E4hdltMPNGIFdF+BL2c39BJ663aNHUbDvJIKun8FTMhlApzxyPTQun
         HFo/AimHSqvRf4Tf7wVzDkwtMF1itjPj35BLIEqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 48/96] i2c: pca-platform: Fix GPIO lookup code
Date:   Mon,  8 Jul 2019 17:13:20 +0200
Message-Id: <20190708150529.113774328@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



