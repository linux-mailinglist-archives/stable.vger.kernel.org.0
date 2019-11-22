Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 639C1107068
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729329AbfKVKoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:44:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:50156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728309AbfKVKoR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:44:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FBA020656;
        Fri, 22 Nov 2019 10:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419456;
        bh=W1/lV2XXwhI/fw03aQUefAxM/mttitnn52A6z2VdHYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fSxkaUoBMVkGzRf7w4EG2uUxRW2zEP7X2VtfjSBGewzf47KBdccpXyu53PYXe8ihs
         MDWRlUIry0U3/slP4jiMQt3qh1UQdvCXViTfcvF6sSGmWnIpewPaqv7PqnzmIgQklE
         Cy1xoKa5F2ygWonTpj8t4Zr/AxnyT5foOggJtRME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
        =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 074/222] power: supply: max8998-charger: Fix platform data retrieval
Date:   Fri, 22 Nov 2019 11:26:54 +0100
Message-Id: <20191122100907.971386931@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomasz Figa <tomasz.figa@gmail.com>

[ Upstream commit cb90a2c6f77fe9b43d1e3f759bb2f13fe7fa1811 ]

Since the max8998 MFD driver supports instantiation by DT, platform data
retrieval is handled in MFD probe and cell drivers should get use
the pdata field of max8998_dev struct to obtain them.

Fixes: ee999fb3f17f ("mfd: max8998: Add support for Device Tree")
Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/max8998_charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/max8998_charger.c b/drivers/power/supply/max8998_charger.c
index b64cf0f141425..66438029bdd0c 100644
--- a/drivers/power/supply/max8998_charger.c
+++ b/drivers/power/supply/max8998_charger.c
@@ -85,7 +85,7 @@ static const struct power_supply_desc max8998_battery_desc = {
 static int max8998_battery_probe(struct platform_device *pdev)
 {
 	struct max8998_dev *iodev = dev_get_drvdata(pdev->dev.parent);
-	struct max8998_platform_data *pdata = dev_get_platdata(iodev->dev);
+	struct max8998_platform_data *pdata = iodev->pdata;
 	struct power_supply_config psy_cfg = {};
 	struct max8998_battery_data *max8998;
 	struct i2c_client *i2c;
-- 
2.20.1



