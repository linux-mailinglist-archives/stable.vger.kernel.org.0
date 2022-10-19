Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46BFF604123
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbiJSKim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbiJSKiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:38:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CDA15380D;
        Wed, 19 Oct 2022 03:17:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBB40B8232E;
        Wed, 19 Oct 2022 08:52:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392FEC433D6;
        Wed, 19 Oct 2022 08:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169552;
        bh=W+SzmJ4+Ai0GJAXfRt/BGB8Dxa/vhps1D+4o/1qiegw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XeQFZf2/OiT1C0LnGV58MKJwGMJ1pFVzLiluQ9TMU1LlLTyzfXcMGMYJVw5OL5Z2s
         IW9xjvWtCZpzY687K64pnvasy6NVE3vSu5Y75Wemyhg/fzmHDWbrHx1tdAJFos5W/a
         Cw0iADLW9/7KfmzLlCRWFeHtPiyHDJmm6QUrykGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Khalil Blaiech <kblaiech@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 320/862] i2c: mlxbf: support lock mechanism
Date:   Wed, 19 Oct 2022 10:26:47 +0200
Message-Id: <20221019083304.159499469@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Asmaa Mnebhi <asmaa@nvidia.com>

[ Upstream commit 86067ccfa1424a26491542d6f6d7546d40b61a10 ]

Linux is not the only entity using the BlueField I2C busses so
support a lock mechanism provided by hardware to avoid issues
when multiple entities are trying to access the same bus.

The lock is acquired whenever written explicitely or the lock
register is read. So make sure it is always released at the end
of a successful or failed transaction.

Fixes: b5b5b32081cd206b (i2c: mlxbf: I2C SMBus driver for Mellanox BlueField SoC)
Reviewed-by: Khalil Blaiech <kblaiech@nvidia.com>
Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mlxbf.c | 44 ++++++++++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mlxbf.c b/drivers/i2c/busses/i2c-mlxbf.c
index ad5efd7497d1..0e840eba4fd6 100644
--- a/drivers/i2c/busses/i2c-mlxbf.c
+++ b/drivers/i2c/busses/i2c-mlxbf.c
@@ -306,6 +306,7 @@ static u64 mlxbf_i2c_corepll_frequency;
  * exact.
  */
 #define MLXBF_I2C_SMBUS_TIMEOUT   (300 * 1000) /* 300ms */
+#define MLXBF_I2C_SMBUS_LOCK_POLL_TIMEOUT (300 * 1000) /* 300ms */
 
 /* Encapsulates timing parameters. */
 struct mlxbf_i2c_timings {
@@ -514,6 +515,25 @@ static bool mlxbf_smbus_master_wait_for_idle(struct mlxbf_i2c_priv *priv)
 	return false;
 }
 
+/*
+ * wait for the lock to be released before acquiring it.
+ */
+static bool mlxbf_i2c_smbus_master_lock(struct mlxbf_i2c_priv *priv)
+{
+	if (mlxbf_smbus_poll(priv->smbus->io, MLXBF_I2C_SMBUS_MASTER_GW,
+			   MLXBF_I2C_MASTER_LOCK_BIT, true,
+			   MLXBF_I2C_SMBUS_LOCK_POLL_TIMEOUT))
+		return true;
+
+	return false;
+}
+
+static void mlxbf_i2c_smbus_master_unlock(struct mlxbf_i2c_priv *priv)
+{
+	/* Clear the gw to clear the lock */
+	writel(0, priv->smbus->io + MLXBF_I2C_SMBUS_MASTER_GW);
+}
+
 static bool mlxbf_i2c_smbus_transaction_success(u32 master_status,
 						u32 cause_status)
 {
@@ -705,10 +725,19 @@ mlxbf_i2c_smbus_start_transaction(struct mlxbf_i2c_priv *priv,
 	slave = request->slave & GENMASK(6, 0);
 	addr = slave << 1;
 
-	/* First of all, check whether the HW is idle. */
-	if (WARN_ON(!mlxbf_smbus_master_wait_for_idle(priv)))
+	/*
+	 * Try to acquire the smbus gw lock before any reads of the GW register since
+	 * a read sets the lock.
+	 */
+	if (WARN_ON(!mlxbf_i2c_smbus_master_lock(priv)))
 		return -EBUSY;
 
+	/* Check whether the HW is idle */
+	if (WARN_ON(!mlxbf_smbus_master_wait_for_idle(priv))) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
 	/* Set first byte. */
 	data_desc[data_idx++] = addr;
 
@@ -732,8 +761,10 @@ mlxbf_i2c_smbus_start_transaction(struct mlxbf_i2c_priv *priv,
 			write_en = 1;
 			write_len += operation->length;
 			if (data_idx + operation->length >
-					MLXBF_I2C_MASTER_DATA_DESC_SIZE)
-				return -ENOBUFS;
+					MLXBF_I2C_MASTER_DATA_DESC_SIZE) {
+				ret = -ENOBUFS;
+				goto out_unlock;
+			}
 			memcpy(data_desc + data_idx,
 			       operation->buffer, operation->length);
 			data_idx += operation->length;
@@ -765,7 +796,7 @@ mlxbf_i2c_smbus_start_transaction(struct mlxbf_i2c_priv *priv,
 		ret = mlxbf_i2c_smbus_enable(priv, slave, write_len, block_en,
 					 pec_en, 0);
 		if (ret)
-			return ret;
+			goto out_unlock;
 	}
 
 	if (read_en) {
@@ -792,6 +823,9 @@ mlxbf_i2c_smbus_start_transaction(struct mlxbf_i2c_priv *priv,
 			priv->smbus->io + MLXBF_I2C_SMBUS_MASTER_FSM);
 	}
 
+out_unlock:
+	mlxbf_i2c_smbus_master_unlock(priv);
+
 	return ret;
 }
 
-- 
2.35.1



