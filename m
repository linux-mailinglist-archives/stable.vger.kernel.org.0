Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4853A60E7
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbhFNKkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:40:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233748AbhFNKh1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:37:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B31861411;
        Mon, 14 Jun 2021 10:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666809;
        bh=ROmdGCMgyJmEdIh8sl4OpTLSLWePKaqKWNlIOPLkcMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cc/GXBzBWSFONAMzFwRt2tSw0n8wzPjNlIDkObjSvgMAviKLI95stODt/la49kNiQ
         Vt5cb3UBD70bf8svIAb+KdterJHuar6IY+pTQvAyl/Zzfo6hYYpF0K33m5EFW1Elr1
         pLePev+uLg4c2ZtyVDnw5Vh8qDkbwNVzxAGmB8I0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 20/49] i2c: mpc: implement erratum A-004447 workaround
Date:   Mon, 14 Jun 2021 12:27:13 +0200
Message-Id: <20210614102642.531347444@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102641.857724541@linuxfoundation.org>
References: <20210614102641.857724541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit 8f0cdec8b5fd94135d643662506ee94ae9e98785 ]

The P2040/P2041 has an erratum where the normal i2c recovery mechanism
does not work. Implement the alternative recovery mechanism documented
in the P2040 Chip Errata Rev Q.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mpc.c | 79 +++++++++++++++++++++++++++++++++++-
 1 file changed, 78 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
index d94df068c073..7db5554d2b4e 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -23,6 +23,7 @@
 
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/fsl_devices.h>
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
@@ -49,6 +50,7 @@
 #define CCR_MTX  0x10
 #define CCR_TXAK 0x08
 #define CCR_RSTA 0x04
+#define CCR_RSVD 0x02
 
 #define CSR_MCF  0x80
 #define CSR_MAAS 0x40
@@ -70,6 +72,7 @@ struct mpc_i2c {
 	u8 fdr, dfsrr;
 #endif
 	struct clk *clk_per;
+	bool has_errata_A004447;
 };
 
 struct mpc_i2c_divider {
@@ -178,6 +181,75 @@ static int i2c_wait(struct mpc_i2c *i2c, unsigned timeout, int writing)
 	return 0;
 }
 
+static int i2c_mpc_wait_sr(struct mpc_i2c *i2c, int mask)
+{
+	void __iomem *addr = i2c->base + MPC_I2C_SR;
+	u8 val;
+
+	return readb_poll_timeout(addr, val, val & mask, 0, 100);
+}
+
+/*
+ * Workaround for Erratum A004447. From the P2040CE Rev Q
+ *
+ * 1.  Set up the frequency divider and sampling rate.
+ * 2.  I2CCR - a0h
+ * 3.  Poll for I2CSR[MBB] to get set.
+ * 4.  If I2CSR[MAL] is set (an indication that SDA is stuck low), then go to
+ *     step 5. If MAL is not set, then go to step 13.
+ * 5.  I2CCR - 00h
+ * 6.  I2CCR - 22h
+ * 7.  I2CCR - a2h
+ * 8.  Poll for I2CSR[MBB] to get set.
+ * 9.  Issue read to I2CDR.
+ * 10. Poll for I2CSR[MIF] to be set.
+ * 11. I2CCR - 82h
+ * 12. Workaround complete. Skip the next steps.
+ * 13. Issue read to I2CDR.
+ * 14. Poll for I2CSR[MIF] to be set.
+ * 15. I2CCR - 80h
+ */
+static void mpc_i2c_fixup_A004447(struct mpc_i2c *i2c)
+{
+	int ret;
+	u32 val;
+
+	writeccr(i2c, CCR_MEN | CCR_MSTA);
+	ret = i2c_mpc_wait_sr(i2c, CSR_MBB);
+	if (ret) {
+		dev_err(i2c->dev, "timeout waiting for CSR_MBB\n");
+		return;
+	}
+
+	val = readb(i2c->base + MPC_I2C_SR);
+
+	if (val & CSR_MAL) {
+		writeccr(i2c, 0x00);
+		writeccr(i2c, CCR_MSTA | CCR_RSVD);
+		writeccr(i2c, CCR_MEN | CCR_MSTA | CCR_RSVD);
+		ret = i2c_mpc_wait_sr(i2c, CSR_MBB);
+		if (ret) {
+			dev_err(i2c->dev, "timeout waiting for CSR_MBB\n");
+			return;
+		}
+		val = readb(i2c->base + MPC_I2C_DR);
+		ret = i2c_mpc_wait_sr(i2c, CSR_MIF);
+		if (ret) {
+			dev_err(i2c->dev, "timeout waiting for CSR_MIF\n");
+			return;
+		}
+		writeccr(i2c, CCR_MEN | CCR_RSVD);
+	} else {
+		val = readb(i2c->base + MPC_I2C_DR);
+		ret = i2c_mpc_wait_sr(i2c, CSR_MIF);
+		if (ret) {
+			dev_err(i2c->dev, "timeout waiting for CSR_MIF\n");
+			return;
+		}
+		writeccr(i2c, CCR_MEN);
+	}
+}
+
 #if defined(CONFIG_PPC_MPC52xx) || defined(CONFIG_PPC_MPC512x)
 static const struct mpc_i2c_divider mpc_i2c_dividers_52xx[] = {
 	{20, 0x20}, {22, 0x21}, {24, 0x22}, {26, 0x23},
@@ -636,7 +708,10 @@ static int fsl_i2c_bus_recovery(struct i2c_adapter *adap)
 {
 	struct mpc_i2c *i2c = i2c_get_adapdata(adap);
 
-	mpc_i2c_fixup(i2c);
+	if (i2c->has_errata_A004447)
+		mpc_i2c_fixup_A004447(i2c);
+	else
+		mpc_i2c_fixup(i2c);
 
 	return 0;
 }
@@ -740,6 +815,8 @@ static int fsl_i2c_probe(struct platform_device *op)
 	dev_info(i2c->dev, "timeout %u us\n", mpc_ops.timeout * 1000000 / HZ);
 
 	platform_set_drvdata(op, i2c);
+	if (of_property_read_bool(op->dev.of_node, "fsl,i2c-erratum-a004447"))
+		i2c->has_errata_A004447 = true;
 
 	i2c->adap = mpc_ops;
 	of_address_to_resource(op->dev.of_node, 0, &res);
-- 
2.30.2



