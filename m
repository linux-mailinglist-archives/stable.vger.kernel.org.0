Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA51D10BE55
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfK0Vfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:35:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:35016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729013AbfK0UtY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:49:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9842021843;
        Wed, 27 Nov 2019 20:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887764;
        bh=dG+zSrw7iEHZfFQEuCJ+9sfjj9LTzYBKGyDmPJzLAbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MVTC/UOL/3Eya1pokbYrC0NL+ByApCKY0ov3q/BUL6Gk5AvIdNRqZGrxESNF7A3J+
         h1F+NG74mOLhW9NZjrwGbMRpgVOPRO4hH5a34pJSfYYCbBrhAEoVZK827QMgUPXF3K
         7eGWAvUtZZJTc3f6HgJ1muN8vT+FSklWSWtx7DWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 084/211] mfd: max8997: Enale irq-wakeup unconditionally
Date:   Wed, 27 Nov 2019 21:30:17 +0100
Message-Id: <20191127203101.717047848@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit efddff27c886e729a7f84a7205bd84d7d4af7336 ]

IRQ wake up support for MAX8997 driver was initially configured by
respective property in pdata. However, after the driver conversion to
device-tree, setting it was left as 'todo'. Nowadays most of other PMIC MFD
drivers initialized from device-tree assume that they can be an irq wakeup
source, so enable it also for MAX8997. This fixes support for wakeup from
MAX8997 RTC alarm.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/max8997.c       | 8 +-------
 include/linux/mfd/max8997.h | 1 -
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index 2d6e2c3927862..4a2fc59d59016 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -155,12 +155,6 @@ static struct max8997_platform_data *max8997_i2c_parse_dt_pdata(
 
 	pd->ono = irq_of_parse_and_map(dev->of_node, 1);
 
-	/*
-	 * ToDo: the 'wakeup' member in the platform data is more of a linux
-	 * specfic information. Hence, there is no binding for that yet and
-	 * not parsed here.
-	 */
-
 	return pd;
 }
 
@@ -248,7 +242,7 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 	 */
 
 	/* MAX8997 has a power button input. */
-	device_init_wakeup(max8997->dev, pdata->wakeup);
+	device_init_wakeup(max8997->dev, true);
 
 	return ret;
 
diff --git a/include/linux/mfd/max8997.h b/include/linux/mfd/max8997.h
index cf815577bd686..3ae1fe743bc34 100644
--- a/include/linux/mfd/max8997.h
+++ b/include/linux/mfd/max8997.h
@@ -178,7 +178,6 @@ struct max8997_led_platform_data {
 struct max8997_platform_data {
 	/* IRQ */
 	int ono;
-	int wakeup;
 
 	/* ---- PMIC ---- */
 	struct max8997_regulator_data *regulators;
-- 
2.20.1



