Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250F53A6037
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232877AbhFNKcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:32:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232767AbhFNKcC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:32:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A64B761004;
        Mon, 14 Jun 2021 10:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666599;
        bh=87a2MqCndiLjymkkJx6RR9s/AWFCk35sTiTTK2jp5Hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aeor/dWWzuBXxHsL/C/BGuKcxiFqvKM5Zcmdm7eh8uuJ8ZDp3oXV2Hdn+ciSsV4Cz
         7UfRLXKyHGr8RllDmAyWVgzfzLmoRwwZwYZiK5AdNIp7ASjusTOaQBqfA/qQP+CcD8
         XRbblVIgKXec+DOvge975JPh4Sm6e1pDJIt/EWxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 17/34] i2c: mpc: Make use of i2c_recover_bus()
Date:   Mon, 14 Jun 2021 12:27:08 +0200
Message-Id: <20210614102642.146372200@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102641.582612289@linuxfoundation.org>
References: <20210614102641.582612289@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit 65171b2df15eb7545431d75c2729b5062da89b43 ]

Move the existing calls of mpc_i2c_fixup() to a recovery function
registered via bus_recovery_info. This makes it more obvious that
recovery is supported and allows for a future where recovery is
triggered by the i2c core.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mpc.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
index 48ecffecc0ed..f2e8b9a159a7 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -581,7 +581,7 @@ static int mpc_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 			if ((status & (CSR_MCF | CSR_MBB | CSR_RXAK)) != 0) {
 				writeb(status & ~CSR_MAL,
 				       i2c->base + MPC_I2C_SR);
-				mpc_i2c_fixup(i2c);
+				i2c_recover_bus(&i2c->adap);
 			}
 			return -EIO;
 		}
@@ -617,7 +617,7 @@ static int mpc_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 			if ((status & (CSR_MCF | CSR_MBB | CSR_RXAK)) != 0) {
 				writeb(status & ~CSR_MAL,
 				       i2c->base + MPC_I2C_SR);
-				mpc_i2c_fixup(i2c);
+				i2c_recover_bus(&i2c->adap);
 			}
 			return -EIO;
 		}
@@ -632,6 +632,15 @@ static u32 mpc_functionality(struct i2c_adapter *adap)
 	  | I2C_FUNC_SMBUS_READ_BLOCK_DATA | I2C_FUNC_SMBUS_BLOCK_PROC_CALL;
 }
 
+static int fsl_i2c_bus_recovery(struct i2c_adapter *adap)
+{
+	struct mpc_i2c *i2c = i2c_get_adapdata(adap);
+
+	mpc_i2c_fixup(i2c);
+
+	return 0;
+}
+
 static const struct i2c_algorithm mpc_algo = {
 	.master_xfer = mpc_xfer,
 	.functionality = mpc_functionality,
@@ -643,6 +652,10 @@ static struct i2c_adapter mpc_ops = {
 	.timeout = HZ,
 };
 
+static struct i2c_bus_recovery_info fsl_i2c_recovery_info = {
+	.recover_bus = fsl_i2c_bus_recovery,
+};
+
 static const struct of_device_id mpc_i2c_of_match[];
 static int fsl_i2c_probe(struct platform_device *op)
 {
@@ -735,6 +748,7 @@ static int fsl_i2c_probe(struct platform_device *op)
 	i2c_set_adapdata(&i2c->adap, i2c);
 	i2c->adap.dev.parent = &op->dev;
 	i2c->adap.dev.of_node = of_node_get(op->dev.of_node);
+	i2c->adap.bus_recovery_info = &fsl_i2c_recovery_info;
 
 	result = i2c_add_adapter(&i2c->adap);
 	if (result < 0) {
-- 
2.30.2



