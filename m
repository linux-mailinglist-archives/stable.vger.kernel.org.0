Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA257490D74
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242250AbiAQRDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:03:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51548 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241976AbiAQRBr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:01:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B6D66120D;
        Mon, 17 Jan 2022 17:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E39C36AEC;
        Mon, 17 Jan 2022 17:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438905;
        bh=3cmUl0Kng61V5pxa0ERWvC6ByxCde87qlfadGwheNM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AiTvVW+PXcODuBwlvDvZ50dIwlBZ3tGwnPy+RMWJCDNLBqxAUko10+Zc23cwDvoo4
         UGTzJoXWPDL5HMT+IGwfhTfDIh39h4oK4R3HuM9mZvA7mvFh0VA+PyJjff3cp2Q1qt
         +yEv6AW9ununE3EsYL7P0z/UzVDwF2/fVc7jJ4kok0h//PzPaGSnp2cVIuhMjfaWLF
         DQJDf8qBj/V12CbMSR0FQL1z1uJc08U1YzXJbnhNlT7fb+37u16mtvLkc5EuFm1+d6
         UHWAwOXlJQu+yEfEUwDRiZWU9KfmYbEE6SFc0Dsj8QwWYYVE2chFeDvSYU2bPanK1r
         LQIWCvGnf3PYw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.de>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>, jdelvare@suse.com,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 08/44] i2c: i801: Don't silently correct invalid transfer size
Date:   Mon, 17 Jan 2022 12:00:51 -0500
Message-Id: <20220117170127.1471115-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170127.1471115-1-sashal@kernel.org>
References: <20220117170127.1471115-1-sashal@kernel.org>
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
index 1f929e6c30bea..98e39a17fb830 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -763,6 +763,11 @@ static int i801_block_transaction(struct i801_priv *priv, union i2c_smbus_data *
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
@@ -776,16 +781,6 @@ static int i801_block_transaction(struct i801_priv *priv, union i2c_smbus_data *
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

