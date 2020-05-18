Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560A01D7D68
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 17:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgERPwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 11:52:43 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:41412 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbgERPwn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 11:52:43 -0400
Received: from localhost.localdomain (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 936C0260258;
        Mon, 18 May 2020 16:52:41 +0100 (BST)
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-mtd@lists.infradead.org
Cc:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        stable@vger.kernel.org
Subject: [PATCH] mtd: rawnand: Fix nand_gpio_waitrdy()
Date:   Mon, 18 May 2020 17:52:37 +0200
Message-Id: <20200518155237.297549-1-boris.brezillon@collabora.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Mimic what's done in nand_soft_waitrdy() and add one to the jiffies
timeout so we don't end up waiting less than actually required.

Reported-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Fixes: b0e137ad24b6c ("mtd: rawnand: Provide helper for polling GPIO R/B pin")
Cc: <stable@vger.kernel.org>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/mtd/nand/raw/nand_base.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/raw/nand_base.c b/drivers/mtd/nand/raw/nand_base.c
index 2d2a216af120..169150a7c140 100644
--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -790,8 +790,14 @@ EXPORT_SYMBOL_GPL(nand_soft_waitrdy);
 int nand_gpio_waitrdy(struct nand_chip *chip, struct gpio_desc *gpiod,
 		      unsigned long timeout_ms)
 {
-	/* Wait until R/B pin indicates chip is ready or timeout occurs */
-	timeout_ms = jiffies + msecs_to_jiffies(timeout_ms);
+
+	/*
+	 * Wait until R/B pin indicates chip is ready or timeout occurs.
+	 * +1 below is necessary because if we are now in the last fraction
+	 * of jiffy and msecs_to_jiffies is 1 then we will wait only that
+	 * small jiffy fraction - possibly leading to false timeout.
+	 */
+	timeout_ms = jiffies + msecs_to_jiffies(timeout_ms) + 1;
 	do {
 		if (gpiod_get_value_cansleep(gpiod))
 			return 0;
-- 
2.25.4

