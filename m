Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D677132AF00
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbhCCAOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:14:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:38706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383596AbhCBL4R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 06:56:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C703661477;
        Tue,  2 Mar 2021 11:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686136;
        bh=+7LclTKHzIOR90r+KzUvTzXCGvGArJVXRmP2usOJ2Ok=;
        h=From:To:Cc:Subject:Date:From;
        b=iUb5IrY/SkX6o8A+LOAE/pGNluVtKakeZYd/P1XmBO4UEPbaWVTHzz+F8eaH1qhUQ
         Mi0rMV5xY19yzb/Mtqi4nXstBcPDl9i9izuG2p44fZ/e5LsN/Kpvv6MSrCXBtc2D7t
         UZLMcHxHl3Rg/ahE8xHa0YO3ARs2oBi1AJCbIk5nxYOcCAAkw6CplIj05GfrmowCYm
         ICC2oNCpz7a2ROr1junRFu52ZofaGgs0TOwkeKQrsaEVF0NgJtL/1Rwogc1nbHU2jS
         yFDYoUY3ms59B9k8x9NoM57KwsT/J/7fcBEONKOMcjg9sXB1gThWnIxFVlFCIPwjN9
         8Fv6xgmHdhf3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 01/52] i2c: rcar: faster irq code to minimize HW race condition
Date:   Tue,  2 Mar 2021 06:54:42 -0500
Message-Id: <20210302115534.61800-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit c7b514ec979e23a08c411f3d8ed39c7922751422 ]

To avoid the HW race condition on R-Car Gen2 and earlier, we need to
write to ICMCR as soon as possible in the interrupt handler. We can
improve this by writing a static value instead of masking out bits.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-rcar.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index 217def2d7cb4..824586d7ee56 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -91,7 +91,6 @@
 
 #define RCAR_BUS_PHASE_START	(MDBS | MIE | ESG)
 #define RCAR_BUS_PHASE_DATA	(MDBS | MIE)
-#define RCAR_BUS_MASK_DATA	(~(ESG | FSB) & 0xFF)
 #define RCAR_BUS_PHASE_STOP	(MDBS | MIE | FSB)
 
 #define RCAR_IRQ_SEND	(MNR | MAL | MST | MAT | MDE)
@@ -621,7 +620,7 @@ static bool rcar_i2c_slave_irq(struct rcar_i2c_priv *priv)
 /*
  * This driver has a lock-free design because there are IP cores (at least
  * R-Car Gen2) which have an inherent race condition in their hardware design.
- * There, we need to clear RCAR_BUS_MASK_DATA bits as soon as possible after
+ * There, we need to switch to RCAR_BUS_PHASE_DATA as soon as possible after
  * the interrupt was generated, otherwise an unwanted repeated message gets
  * generated. It turned out that taking a spinlock at the beginning of the ISR
  * was already causing repeated messages. Thus, this driver was converted to
@@ -630,13 +629,11 @@ static bool rcar_i2c_slave_irq(struct rcar_i2c_priv *priv)
 static irqreturn_t rcar_i2c_irq(int irq, void *ptr)
 {
 	struct rcar_i2c_priv *priv = ptr;
-	u32 msr, val;
+	u32 msr;
 
 	/* Clear START or STOP immediately, except for REPSTART after read */
-	if (likely(!(priv->flags & ID_P_REP_AFTER_RD))) {
-		val = rcar_i2c_read(priv, ICMCR);
-		rcar_i2c_write(priv, ICMCR, val & RCAR_BUS_MASK_DATA);
-	}
+	if (likely(!(priv->flags & ID_P_REP_AFTER_RD)))
+		rcar_i2c_write(priv, ICMCR, RCAR_BUS_PHASE_DATA);
 
 	msr = rcar_i2c_read(priv, ICMSR);
 
-- 
2.30.1

