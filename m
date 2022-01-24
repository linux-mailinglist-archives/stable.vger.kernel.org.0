Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16290498964
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344048AbiAXSzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:55:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53188 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344233AbiAXSyB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:54:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4986E61507;
        Mon, 24 Jan 2022 18:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B35BC340E5;
        Mon, 24 Jan 2022 18:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050440;
        bh=P8JodIRX2uzjywT3FD6+DpyuTrOHA3GSKST3Iwdgot4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gk3BE7J3Qp7aXxCQgrXnMZg1iEG78agJP06QMFsRB1RrCMa9sk+2kSADFy07yHF1T
         FyoBfbMYWbbjnTRLKxfK31hZEIlT/bbwNnwgOiwSwREv2qZB0bM9yzhfXIv2VYEtDu
         H4AQU2qY5pP58fljuWTRdG6wtwt4MDlEPVRLh+gk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Joakim Tjernlund <joakim.tjernlund@infinera.com>,
        Scott Wood <oss@buserror.net>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 090/114] i2c: mpc: Correct I2C reset procedure
Date:   Mon, 24 Jan 2022 19:43:05 +0100
Message-Id: <20220124183929.891467756@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
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
index 2e083a71c2215..988ea9df6654c 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -107,23 +107,30 @@ static irqreturn_t mpc_i2c_isr(int irq, void *dev_id)
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



