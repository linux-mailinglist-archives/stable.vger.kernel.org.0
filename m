Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7F13E25C1
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243412AbhHFIWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:22:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243869AbhHFIU7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:20:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B19BA611CE;
        Fri,  6 Aug 2021 08:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628238044;
        bh=uPP6pGfPKxxOWBPIuYO99gShrMMU9C+Cbh2sqJmsmPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=glP/Hgn1aajEczknuuWNVqQ0VfIEnQV6PqnRtF8q2cI7x8DTOus3ELi/HpVy1E5VI
         3v30u2Fq5n/1mUOi0+vgJL3Vj6elzNeKS99yvsJDuYiyKAmMgEqT2QUCLco+pjCrZp
         5MUbq+Y/g4T9WJFTlbXYv334Q1vUtzjCQjkmniT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 03/35] power: supply: ab8500: Call battery population once
Date:   Fri,  6 Aug 2021 10:16:46 +0200
Message-Id: <20210806081113.827211342@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.718626745@linuxfoundation.org>
References: <20210806081113.718626745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 7e2bb83c617f8fccc04db7d03f105a06b9d491a9 ]

The code was calling ab8500_bm_of_probe() in four different
spots effectively overwriting the same configuration three
times. This was done because probe order was uncertain.

Since we now used componentized probe, call it only once
while probing the main charging component.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_btemp.c    | 7 -------
 drivers/power/supply/ab8500_fg.c       | 6 ------
 drivers/power/supply/abx500_chargalg.c | 7 -------
 3 files changed, 20 deletions(-)

diff --git a/drivers/power/supply/ab8500_btemp.c b/drivers/power/supply/ab8500_btemp.c
index 4df305c767c5..dbdcff32f353 100644
--- a/drivers/power/supply/ab8500_btemp.c
+++ b/drivers/power/supply/ab8500_btemp.c
@@ -983,7 +983,6 @@ static const struct component_ops ab8500_btemp_component_ops = {
 
 static int ab8500_btemp_probe(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node;
 	struct power_supply_config psy_cfg = {};
 	struct device *dev = &pdev->dev;
 	struct ab8500_btemp *di;
@@ -996,12 +995,6 @@ static int ab8500_btemp_probe(struct platform_device *pdev)
 
 	di->bm = &ab8500_bm_data;
 
-	ret = ab8500_bm_of_probe(dev, np, di->bm);
-	if (ret) {
-		dev_err(dev, "failed to get battery information\n");
-		return ret;
-	}
-
 	/* get parent data */
 	di->dev = dev;
 	di->parent = dev_get_drvdata(pdev->dev.parent);
diff --git a/drivers/power/supply/ab8500_fg.c b/drivers/power/supply/ab8500_fg.c
index 46c718e9ebb7..146a5f03818f 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -3058,12 +3058,6 @@ static int ab8500_fg_probe(struct platform_device *pdev)
 
 	di->bm = &ab8500_bm_data;
 
-	ret = ab8500_bm_of_probe(dev, np, di->bm);
-	if (ret) {
-		dev_err(dev, "failed to get battery information\n");
-		return ret;
-	}
-
 	mutex_init(&di->cc_lock);
 
 	/* get parent data */
diff --git a/drivers/power/supply/abx500_chargalg.c b/drivers/power/supply/abx500_chargalg.c
index 599684ce0e4b..a17849bfacbf 100644
--- a/drivers/power/supply/abx500_chargalg.c
+++ b/drivers/power/supply/abx500_chargalg.c
@@ -2002,7 +2002,6 @@ static const struct component_ops abx500_chargalg_component_ops = {
 static int abx500_chargalg_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct device_node *np = dev->of_node;
 	struct power_supply_config psy_cfg = {};
 	struct abx500_chargalg *di;
 	int ret = 0;
@@ -2013,12 +2012,6 @@ static int abx500_chargalg_probe(struct platform_device *pdev)
 
 	di->bm = &ab8500_bm_data;
 
-	ret = ab8500_bm_of_probe(dev, np, di->bm);
-	if (ret) {
-		dev_err(dev, "failed to get battery information\n");
-		return ret;
-	}
-
 	/* get device struct and parent */
 	di->dev = dev;
 	di->parent = dev_get_drvdata(pdev->dev.parent);
-- 
2.30.2



