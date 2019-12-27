Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3972C12B7BC
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfL0RvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:51:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:40970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728238AbfL0Rn2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:43:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A63B821744;
        Fri, 27 Dec 2019 17:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468607;
        bh=ta6P7W4Qxx76cOxWAlSlu27XJGWgczrHYC2HaYJxa4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i1R8KvnO8Py5NUmbcgVF31xE7Rx4O/AvPkg8WjwzCCEsiM3knECYStBvI7myMf4Ul
         xlvmTGUfVfxuVC+9D3oo3TO+3p3BDPodA6bjr7iF4LnO2mgnDt6JJrpLarmVnWFW3C
         aEoXDN7CZojteSugWdAv3GXlRwhSoKg/ieZNvEwI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 127/187] clk: at91: fix possible deadlock
Date:   Fri, 27 Dec 2019 12:39:55 -0500
Message-Id: <20191227174055.4923-127-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit 6956eb33abb5deab2cd916b4c31226b57736bc3c ]

Lockdep warns about a possible circular locking dependency because using
syscon_node_to_regmap() will make the created regmap get and enable the
first clock it can parse from the device tree. This clock is not needed to
access the registers and should not be enabled at that time.

Use the recently introduced device_node_to_regmap to solve that as it looks
up the regmap in the same list but doesn't care about the clocks.

Reported-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lkml.kernel.org/r/20191128102531.817549-1-alexandre.belloni@bootlin.com
Tested-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/at91sam9260.c | 2 +-
 drivers/clk/at91/at91sam9rl.c  | 2 +-
 drivers/clk/at91/at91sam9x5.c  | 2 +-
 drivers/clk/at91/pmc.c         | 2 +-
 drivers/clk/at91/sama5d2.c     | 2 +-
 drivers/clk/at91/sama5d4.c     | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/at91/at91sam9260.c b/drivers/clk/at91/at91sam9260.c
index 0aabe49aed09..a9d4234758d7 100644
--- a/drivers/clk/at91/at91sam9260.c
+++ b/drivers/clk/at91/at91sam9260.c
@@ -348,7 +348,7 @@ static void __init at91sam926x_pmc_setup(struct device_node *np,
 		return;
 	mainxtal_name = of_clk_get_parent_name(np, i);
 
-	regmap = syscon_node_to_regmap(np);
+	regmap = device_node_to_regmap(np);
 	if (IS_ERR(regmap))
 		return;
 
diff --git a/drivers/clk/at91/at91sam9rl.c b/drivers/clk/at91/at91sam9rl.c
index 0ac34cdaa106..77fe83a73bf4 100644
--- a/drivers/clk/at91/at91sam9rl.c
+++ b/drivers/clk/at91/at91sam9rl.c
@@ -83,7 +83,7 @@ static void __init at91sam9rl_pmc_setup(struct device_node *np)
 		return;
 	mainxtal_name = of_clk_get_parent_name(np, i);
 
-	regmap = syscon_node_to_regmap(np);
+	regmap = device_node_to_regmap(np);
 	if (IS_ERR(regmap))
 		return;
 
diff --git a/drivers/clk/at91/at91sam9x5.c b/drivers/clk/at91/at91sam9x5.c
index 0855f3a80cc7..086cf0b4955c 100644
--- a/drivers/clk/at91/at91sam9x5.c
+++ b/drivers/clk/at91/at91sam9x5.c
@@ -146,7 +146,7 @@ static void __init at91sam9x5_pmc_setup(struct device_node *np,
 		return;
 	mainxtal_name = of_clk_get_parent_name(np, i);
 
-	regmap = syscon_node_to_regmap(np);
+	regmap = device_node_to_regmap(np);
 	if (IS_ERR(regmap))
 		return;
 
diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
index 0b03cfae3a9d..b71515acdec1 100644
--- a/drivers/clk/at91/pmc.c
+++ b/drivers/clk/at91/pmc.c
@@ -275,7 +275,7 @@ static int __init pmc_register_ops(void)
 
 	np = of_find_matching_node(NULL, sama5d2_pmc_dt_ids);
 
-	pmcreg = syscon_node_to_regmap(np);
+	pmcreg = device_node_to_regmap(np);
 	if (IS_ERR(pmcreg))
 		return PTR_ERR(pmcreg);
 
diff --git a/drivers/clk/at91/sama5d2.c b/drivers/clk/at91/sama5d2.c
index 0de1108737db..ff7e3f727082 100644
--- a/drivers/clk/at91/sama5d2.c
+++ b/drivers/clk/at91/sama5d2.c
@@ -162,7 +162,7 @@ static void __init sama5d2_pmc_setup(struct device_node *np)
 		return;
 	mainxtal_name = of_clk_get_parent_name(np, i);
 
-	regmap = syscon_node_to_regmap(np);
+	regmap = device_node_to_regmap(np);
 	if (IS_ERR(regmap))
 		return;
 
diff --git a/drivers/clk/at91/sama5d4.c b/drivers/clk/at91/sama5d4.c
index 25b156d4e645..a6dee4a3b6e4 100644
--- a/drivers/clk/at91/sama5d4.c
+++ b/drivers/clk/at91/sama5d4.c
@@ -136,7 +136,7 @@ static void __init sama5d4_pmc_setup(struct device_node *np)
 		return;
 	mainxtal_name = of_clk_get_parent_name(np, i);
 
-	regmap = syscon_node_to_regmap(np);
+	regmap = device_node_to_regmap(np);
 	if (IS_ERR(regmap))
 		return;
 
-- 
2.20.1

