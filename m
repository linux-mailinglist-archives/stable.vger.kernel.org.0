Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34C532B001
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbhCCA3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:29:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:55094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350763AbhCBMub (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:50:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E33964F72;
        Tue,  2 Mar 2021 11:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686272;
        bh=WBPXsz4WZudRCvS5C99vhxKE7pTuA0i3oabXbJnn+NQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Ygm3W3TmB0qOI9ANIb0jofssna/80MdNxrXnLQqXKPEeHiERaamSGLHHxcAEF4ZUF
         STGasbjPf40zXRTdvSDFxq8x5jNGdr23RSQ+28sdkKRqaO/L9VXWTUkp4EZn3M3IE2
         E+S3OkT7CPqHAZOiWVSq1s6jdMeNyk0sJNqkCm6KF4Yqwv5lBig6Atj6YGqOt8xtW4
         pHW/D8IUgrnalvhNti+jm7nt1dgUU4odgjKvsZsAxahAjytEQ00vthYFuIFl6Ik0OR
         neFxgUvhqCPl2CgpnjoAUwZGtrnSDTlmLCs0k4Ed+/rUN6sYC7y85rRKD3oklIE/Cr
         xUignxAcCgHmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/33] i2c: rcar: faster irq code to minimize HW race condition
Date:   Tue,  2 Mar 2021 06:57:17 -0500
Message-Id: <20210302115749.62653-1-sashal@kernel.org>
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
index 9c162a01a584..9d54ae935524 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -89,7 +89,6 @@
 
 #define RCAR_BUS_PHASE_START	(MDBS | MIE | ESG)
 #define RCAR_BUS_PHASE_DATA	(MDBS | MIE)
-#define RCAR_BUS_MASK_DATA	(~(ESG | FSB) & 0xFF)
 #define RCAR_BUS_PHASE_STOP	(MDBS | MIE | FSB)
 
 #define RCAR_IRQ_SEND	(MNR | MAL | MST | MAT | MDE)
@@ -616,7 +615,7 @@ static bool rcar_i2c_slave_irq(struct rcar_i2c_priv *priv)
 /*
  * This driver has a lock-free design because there are IP cores (at least
  * R-Car Gen2) which have an inherent race condition in their hardware design.
- * There, we need to clear RCAR_BUS_MASK_DATA bits as soon as possible after
+ * There, we need to switch to RCAR_BUS_PHASE_DATA as soon as possible after
  * the interrupt was generated, otherwise an unwanted repeated message gets
  * generated. It turned out that taking a spinlock at the beginning of the ISR
  * was already causing repeated messages. Thus, this driver was converted to
@@ -625,13 +624,11 @@ static bool rcar_i2c_slave_irq(struct rcar_i2c_priv *priv)
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

