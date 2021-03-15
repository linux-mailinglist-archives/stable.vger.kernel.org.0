Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C55133B968
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbhCOOCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:02:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232055AbhCOOAP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89C8A64F07;
        Mon, 15 Mar 2021 13:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816786;
        bh=3dHF4xPZBkdJCHhLjFFJ+oVg5bdDf4otkPiATNSJy9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OGQfnsbN7jXWzzPQolcSArXTTC4gh2hGE/+mtrO124dGWAYRHAullA7yj9fkVayjc
         WtAxSi2t2ESdwXl+K9dXyra8DB9FfhlYbKxBvakY2ioG21QYOIb5Tz37bKHdLeNCDV
         SocqM3ysmUnw1W1bqurjwefD9OD/YJVpOVC5BumE=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 124/306] i2c: rcar: faster irq code to minimize HW race condition
Date:   Mon, 15 Mar 2021 14:53:07 +0100
Message-Id: <20210315135511.861679238@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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



