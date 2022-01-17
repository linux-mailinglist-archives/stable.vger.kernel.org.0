Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1970490CD1
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 17:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237822AbiAQQ71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 11:59:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48604 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241243AbiAQQ7U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 11:59:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 400CF611C3;
        Mon, 17 Jan 2022 16:59:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16DDC36AF5;
        Mon, 17 Jan 2022 16:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438759;
        bh=VpOIpWuYU5r7PoaTzGcmVyr0EObttdwQ5irv2gBTbpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a4ly/uY/d7OuVFxoxaPoodjEhYoQVuwBGXgomC8fiiI01hbvIfa8cX1d9Y4pjv5Ld
         b4vPwNS8EUxXAx3LkT7KDDE2EKFEbGSphq+sI2iRX247glyopnrVYDbWkwPdEdUbZF
         oZ7OzUW6XAxJRFMzP1HoMl1K+OMpesdd9/Lx53ucKRVC6T5+tbKxJJjSA+FSkDTm8/
         0vj8vaApo1ACJIW2GTiA5LKSjHEvo6Uh5VSP6iR84iBYNR/5KVYIhNNQW76nGemsOt
         OImhaB3bJLaJqt8ocTK2BcuSIyK6cIePnHJzt+Ia+zUKsoM1EJauFfIWujdsANBChF
         USTyfEcpkrSNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joakim Tjernlund <joakim.tjernlund@infinera.com>,
        Scott Wood <oss@buserror.net>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        chris.packham@alliedtelesis.co.nz, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 11/52] i2c: mpc: Correct I2C reset procedure
Date:   Mon, 17 Jan 2022 11:58:12 -0500
Message-Id: <20220117165853.1470420-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117165853.1470420-1-sashal@kernel.org>
References: <20220117165853.1470420-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joakim Tjernlund <joakim.tjernlund@infinera.com>

[ Upstream commit ebe82cf92cd4825c3029434cabfcd2f1780e64be ]

Current I2C reset procedure is broken in two ways:
1) It only generate 1 START instead of 9 STARTs and STOP.
2) It leaves the bus Busy so every I2C xfer after the first
   fixup calls the reset routine again, for every xfer there after.

This fixes both errors.

Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
Acked-by: Scott Wood <oss@buserror.net>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mpc.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
index db26cc36e13fe..6c698c10d3cdb 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -119,23 +119,30 @@ static inline void writeccr(struct mpc_i2c *i2c, u32 x)
 /* Sometimes 9th clock pulse isn't generated, and slave doesn't release
  * the bus, because it wants to send ACK.
  * Following sequence of enabling/disabling and sending start/stop generates
- * the 9 pulses, so it's all OK.
+ * the 9 pulses, each with a START then ending with STOP, so it's all OK.
  */
 static void mpc_i2c_fixup(struct mpc_i2c *i2c)
 {
 	int k;
-	u32 delay_val = 1000000 / i2c->real_clk + 1;
-
-	if (delay_val < 2)
-		delay_val = 2;
+	unsigned long flags;
 
 	for (k = 9; k; k--) {
 		writeccr(i2c, 0);
-		writeccr(i2c, CCR_MSTA | CCR_MTX | CCR_MEN);
+		writeb(0, i2c->base + MPC_I2C_SR); /* clear any status bits */
+		writeccr(i2c, CCR_MEN | CCR_MSTA); /* START */
+		readb(i2c->base + MPC_I2C_DR); /* init xfer */
+		udelay(15); /* let it hit the bus */
+		local_irq_save(flags); /* should not be delayed further */
+		writeccr(i2c, CCR_MEN | CCR_MSTA | CCR_RSTA); /* delay SDA */
 		readb(i2c->base + MPC_I2C_DR);
-		writeccr(i2c, CCR_MEN);
-		udelay(delay_val << 1);
+		if (k != 1)
+			udelay(5);
+		local_irq_restore(flags);
 	}
+	writeccr(i2c, CCR_MEN); /* Initiate STOP */
+	readb(i2c->base + MPC_I2C_DR);
+	udelay(15); /* Let STOP propagate */
+	writeccr(i2c, 0);
 }
 
 static int i2c_mpc_wait_sr(struct mpc_i2c *i2c, int mask)
-- 
2.34.1

