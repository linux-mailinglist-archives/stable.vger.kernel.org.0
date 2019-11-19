Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 916EE101476
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbfKSFeJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:34:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:54816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729109AbfKSFeI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:34:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57D2920672;
        Tue, 19 Nov 2019 05:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141647;
        bh=TW1UJ3v+CH/LPjjD9VAJXk8Gc7Yo8euonvZXeuV1Gl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0RjMymQSgK1g26nSTTa0BsoCxnEztUMHMxQS1YUZvwwcdo8MTqns4INOXLtiJpf3K
         xqlHm/eUw6SF355CE+sg1idRQRW6zfU31tkTX5tmuCDJmrb3DJjnfxDuSe0wpynepS
         23JmJIbvY0goNQ2NFd+6HnUyrgWejCjm6Ae+DCzo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
        =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 225/422] power: supply: max8998-charger: Fix platform data retrieval
Date:   Tue, 19 Nov 2019 06:17:02 +0100
Message-Id: <20191119051413.215842302@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
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
index cad7d1a8feec7..aa65e6c36c55e 100644
--- a/drivers/power/supply/max8998_charger.c
+++ b/drivers/power/supply/max8998_charger.c
@@ -86,7 +86,7 @@ static const struct power_supply_desc max8998_battery_desc = {
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



