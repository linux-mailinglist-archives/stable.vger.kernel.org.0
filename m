Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7946DBA443
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390786AbfIVSrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:47:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390763AbfIVSrX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:47:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA4BE2186A;
        Sun, 22 Sep 2019 18:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178042;
        bh=JynpDT/gW2P7z3FNimWG7u5TDUQgbp30m34PxCe32QM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zwt5rOM4vien/A0MB+S9nUGrpNKmxCdZY2018CZoRQzryf+w4GQkqTwheTUj5gbHm
         4pwLYKyOGuDzIr3qz0nzpas2xriN1rYjW/jeIOrRS2wCXfUGsZkuPKmYDoUQjJ8DEW
         Ic0hXaZ3fxyALCNV9qI0m2PZbfzexS2Hmo9ntWAk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 122/203] PM / devfreq: exynos-bus: Correct clock enable sequence
Date:   Sun, 22 Sep 2019 14:42:28 -0400
Message-Id: <20190922184350.30563-122-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamil Konieczny <k.konieczny@partner.samsung.com>

[ Upstream commit 2c2b20e0da89c76759ee28c6824413ab2fa3bfc6 ]

Regulators should be enabled before clocks to avoid h/w hang. This
require change in exynos_bus_probe() to move exynos_bus_parse_of()
after exynos_bus_parent_parse_of() and change in error handling.
Similar change is needed in exynos_bus_exit() where clock should be
disabled before regulators.

Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/exynos-bus.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/devfreq/exynos-bus.c b/drivers/devfreq/exynos-bus.c
index d9f377912c104..7c06df8bd74fe 100644
--- a/drivers/devfreq/exynos-bus.c
+++ b/drivers/devfreq/exynos-bus.c
@@ -191,11 +191,10 @@ static void exynos_bus_exit(struct device *dev)
 	if (ret < 0)
 		dev_warn(dev, "failed to disable the devfreq-event devices\n");
 
-	if (bus->regulator)
-		regulator_disable(bus->regulator);
-
 	dev_pm_opp_of_remove_table(dev);
 	clk_disable_unprepare(bus->clk);
+	if (bus->regulator)
+		regulator_disable(bus->regulator);
 }
 
 /*
@@ -383,6 +382,7 @@ static int exynos_bus_probe(struct platform_device *pdev)
 	struct exynos_bus *bus;
 	int ret, max_state;
 	unsigned long min_freq, max_freq;
+	bool passive = false;
 
 	if (!np) {
 		dev_err(dev, "failed to find devicetree node\n");
@@ -396,27 +396,27 @@ static int exynos_bus_probe(struct platform_device *pdev)
 	bus->dev = &pdev->dev;
 	platform_set_drvdata(pdev, bus);
 
-	/* Parse the device-tree to get the resource information */
-	ret = exynos_bus_parse_of(np, bus);
-	if (ret < 0)
-		return ret;
-
 	profile = devm_kzalloc(dev, sizeof(*profile), GFP_KERNEL);
-	if (!profile) {
-		ret = -ENOMEM;
-		goto err;
-	}
+	if (!profile)
+		return -ENOMEM;
 
 	node = of_parse_phandle(dev->of_node, "devfreq", 0);
 	if (node) {
 		of_node_put(node);
-		goto passive;
+		passive = true;
 	} else {
 		ret = exynos_bus_parent_parse_of(np, bus);
+		if (ret < 0)
+			return ret;
 	}
 
+	/* Parse the device-tree to get the resource information */
+	ret = exynos_bus_parse_of(np, bus);
 	if (ret < 0)
-		goto err;
+		goto err_reg;
+
+	if (passive)
+		goto passive;
 
 	/* Initialize the struct profile and governor data for parent device */
 	profile->polling_ms = 50;
@@ -507,6 +507,9 @@ static int exynos_bus_probe(struct platform_device *pdev)
 err:
 	dev_pm_opp_of_remove_table(dev);
 	clk_disable_unprepare(bus->clk);
+err_reg:
+	if (!passive)
+		regulator_disable(bus->regulator);
 
 	return ret;
 }
-- 
2.20.1

