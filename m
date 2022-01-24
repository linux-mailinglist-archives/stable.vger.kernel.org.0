Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F103498E4B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355166AbiAXTkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:40:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58092 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354186AbiAXTgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:36:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8F29B8122F;
        Mon, 24 Jan 2022 19:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE20C340E5;
        Mon, 24 Jan 2022 19:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052968;
        bh=sTCekZEw9uEAHrjdVyISUfUMGWrR2PuYEye6KgK+SL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RSbWWf0elt2hxWRUfHajIgtQviTqewavZWRsjFhP9L5guZD8xudsDNBNK6mxSsIAA
         tE7cj9p4P/OvvQN3HQ6xZjXnpp1GwBODe1apYJgDPKDs6p6q8w7dT5HitAwfpmGe0Z
         mScAfNZmptIH145JJWQlb0zN1pdpYshEhY90CtHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Joakim Tjernlund <joakim.tjernlund@infinera.com>,
        Scott Wood <oss@buserror.net>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 231/320] i2c: mpc: Correct I2C reset procedure
Date:   Mon, 24 Jan 2022 19:43:35 +0100
Message-Id: <20220124184001.845220854@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index af349661fd769..8de8296d25831 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -105,23 +105,30 @@ static irqreturn_t mpc_i2c_isr(int irq, void *dev_id)
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
 
 static int i2c_wait(struct mpc_i2c *i2c, unsigned timeout, int writing)
-- 
2.34.1



