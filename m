Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29C4490CCE
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 17:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241246AbiAQQ70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 11:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241249AbiAQQ7V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 11:59:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA52FC061747;
        Mon, 17 Jan 2022 08:59:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A075B81131;
        Mon, 17 Jan 2022 16:59:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2F1C36AE7;
        Mon, 17 Jan 2022 16:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438755;
        bh=P8uN7Qcdlnrf6K1w94rRAe6b7mk1wt3YZB943ppmnEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MVR0TsLmtwgIcWvYxg6Thh9Ey3035mu/xLi8RqNZfNrAdmqEd6o32/IUJtZBBIjA1
         Xd29MmRZwmhzwyKnR8AfF/RwZkJhJGT2b5fd/ETMqn221qKFATHftKhJWWUIiyiqF4
         46xFfCwo2vOgyFeJ40Ceorsymgajqs3RqIm+s0+FM11FatbsxrIOY/0LHrNo75/lF4
         rU5Qgrv+d5oefscoN9hp6ws2ilqbPp7Cp7Ft7P5fehJ55JnHGqUXydxfPCLhtuvURi
         MwzMNIYAsBPrpH7Z62X0m2wlkGTA3EJDuTLHZ22WiLWSDgqquoaBORJsNh8cD8kYT2
         G0t70GUJcXikA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.de>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>, jdelvare@suse.com,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 09/52] i2c: i801: Don't silently correct invalid transfer size
Date:   Mon, 17 Jan 2022 11:58:10 -0500
Message-Id: <20220117165853.1470420-9-sashal@kernel.org>
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

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit effa453168a7eeb8a562ff4edc1dbf9067360a61 ]

If an invalid block size is provided, reject it instead of silently
changing it to a supported value. Especially critical I see the case of
a write transfer with block length 0. In this case we have no guarantee
that the byte we would write is valid. When silently reducing a read to
32 bytes then we don't return an error and the caller may falsely
assume that we returned the full requested data.

If this change should break any (broken) caller, then I think we should
fix the caller.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-i801.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 41446f9cc52da..c87ea470eba98 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -775,6 +775,11 @@ static int i801_block_transaction(struct i801_priv *priv, union i2c_smbus_data *
 	int result = 0;
 	unsigned char hostc;
 
+	if (read_write == I2C_SMBUS_READ && command == I2C_SMBUS_BLOCK_DATA)
+		data->block[0] = I2C_SMBUS_BLOCK_MAX;
+	else if (data->block[0] < 1 || data->block[0] > I2C_SMBUS_BLOCK_MAX)
+		return -EPROTO;
+
 	if (command == I2C_SMBUS_I2C_BLOCK_DATA) {
 		if (read_write == I2C_SMBUS_WRITE) {
 			/* set I2C_EN bit in configuration register */
@@ -788,16 +793,6 @@ static int i801_block_transaction(struct i801_priv *priv, union i2c_smbus_data *
 		}
 	}
 
-	if (read_write == I2C_SMBUS_WRITE
-	 || command == I2C_SMBUS_I2C_BLOCK_DATA) {
-		if (data->block[0] < 1)
-			data->block[0] = 1;
-		if (data->block[0] > I2C_SMBUS_BLOCK_MAX)
-			data->block[0] = I2C_SMBUS_BLOCK_MAX;
-	} else {
-		data->block[0] = 32;	/* max for SMBus block reads */
-	}
-
 	/* Experience has shown that the block buffer can only be used for
 	   SMBus (not I2C) block transactions, even though the datasheet
 	   doesn't mention this limitation. */
-- 
2.34.1

