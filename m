Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46899407815
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237958AbhIKNW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:22:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236891AbhIKNUq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:20:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 856E86137E;
        Sat, 11 Sep 2021 13:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631366066;
        bh=sLEhvPGHt/OVIy/lMim2xitRpoLNc3mWtdRlyNS81oM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ajML2CtJncL8gHa7dsLbijVON6AOvEZvo7dso41Xolu3Xazxq6eda7DMluaKGbsDB
         Fs7qe3n6Cod2xA9F2siA6jWANsfzkoe2PwbrwrLWjlSeLVNPH6zyYs75zZSlF603Sq
         RFh+dL1BWqHeGIctqzXhajCd1uS6iUFBXT1r2Ntp+VDgNu+k5MMh6wBBdbQtoKDcrM
         gTrTAlWaFOB/4Rq5g1bwYzyIhyVy5j1nJjsBRc7F7DMurY41WvXOBSxXJOUG2SNBhv
         /KMV/nC5x0y2Dgh0kqRsef+Drp2pzXLiZ2VYpZN/SQrPs5Ib5A64n5UMXTHWqT2ip8
         wD4bVLCjqYi1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 4.9 2/4] mfd: Don't use irq_create_mapping() to resolve a mapping
Date:   Sat, 11 Sep 2021 09:14:20 -0400
Message-Id: <20210911131423.286235-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131423.286235-1-sashal@kernel.org>
References: <20210911131423.286235-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 9ff80e2de36d0554e3a6da18a171719fe8663c17 ]

Although irq_create_mapping() is able to deal with duplicate
mappings, it really isn't supposed to be a substitute for
irq_find_mapping(), and can result in allocations that take place
in atomic context if the mapping didn't exist.

Fix the handful of MFD drivers that use irq_create_mapping() in
interrupt context by using irq_find_mapping() instead.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/ab8500-core.c | 2 +-
 drivers/mfd/stmpe.c       | 4 ++--
 drivers/mfd/tc3589x.c     | 2 +-
 drivers/mfd/wm8994-irq.c  | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 2f212bdc187a..83484c43b1dc 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -489,7 +489,7 @@ static int ab8500_handle_hierarchical_line(struct ab8500 *ab8500,
 		if (line == AB8540_INT_GPIO43F || line == AB8540_INT_GPIO44F)
 			line += 1;
 
-		handle_nested_irq(irq_create_mapping(ab8500->domain, line));
+		handle_nested_irq(irq_find_mapping(ab8500->domain, line));
 	}
 
 	return 0;
diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index b0c7bcdaf5df..61fb4873c061 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -1033,7 +1033,7 @@ static irqreturn_t stmpe_irq(int irq, void *data)
 
 	if (variant->id_val == STMPE801_ID ||
 	    variant->id_val == STMPE1600_ID) {
-		int base = irq_create_mapping(stmpe->domain, 0);
+		int base = irq_find_mapping(stmpe->domain, 0);
 
 		handle_nested_irq(base);
 		return IRQ_HANDLED;
@@ -1061,7 +1061,7 @@ static irqreturn_t stmpe_irq(int irq, void *data)
 		while (status) {
 			int bit = __ffs(status);
 			int line = bank * 8 + bit;
-			int nestedirq = irq_create_mapping(stmpe->domain, line);
+			int nestedirq = irq_find_mapping(stmpe->domain, line);
 
 			handle_nested_irq(nestedirq);
 			status &= ~(1 << bit);
diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
index 274bf39968aa..96187c1e5f8f 100644
--- a/drivers/mfd/tc3589x.c
+++ b/drivers/mfd/tc3589x.c
@@ -187,7 +187,7 @@ static irqreturn_t tc3589x_irq(int irq, void *data)
 
 	while (status) {
 		int bit = __ffs(status);
-		int virq = irq_create_mapping(tc3589x->domain, bit);
+		int virq = irq_find_mapping(tc3589x->domain, bit);
 
 		handle_nested_irq(virq);
 		status &= ~(1 << bit);
diff --git a/drivers/mfd/wm8994-irq.c b/drivers/mfd/wm8994-irq.c
index 18710f3b5c53..2c58d9b99a39 100644
--- a/drivers/mfd/wm8994-irq.c
+++ b/drivers/mfd/wm8994-irq.c
@@ -159,7 +159,7 @@ static irqreturn_t wm8994_edge_irq(int irq, void *data)
 	struct wm8994 *wm8994 = data;
 
 	while (gpio_get_value_cansleep(wm8994->pdata.irq_gpio))
-		handle_nested_irq(irq_create_mapping(wm8994->edge_irq, 0));
+		handle_nested_irq(irq_find_mapping(wm8994->edge_irq, 0));
 
 	return IRQ_HANDLED;
 }
-- 
2.30.2

