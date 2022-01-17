Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6395B490ED3
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243297AbiAQRMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243778AbiAQRKX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:10:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329BBC0797BF;
        Mon, 17 Jan 2022 09:06:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2BA8B81162;
        Mon, 17 Jan 2022 17:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7AEC36AE7;
        Mon, 17 Jan 2022 17:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439167;
        bh=q5V/oWsy8/Any2yGd1E9n2BPhXEB4Nbics/VFJRxRGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mLCj2NZz1la+DEqyDvQyWy2hsyjK5KZqON/CIJ7ZBy0FKkoklpC7i3S6ahQYQQjP2
         MthBaIdSFXGC/SJbrN0DRP4CMecaWTkuRuoft1Y0GGay8mTKXNFBJ9RtXf8IP8NSdf
         ZWfTqmjqC2F6n8id/Xda/7VG42sAjA9NllR+hZty9leS9Tr4W2SbHll9JP5/GIgleM
         H+iXESkO4aCPzyNk30sPWn2H4eq6/4gOeCKetElPwa4aMMnFIrq4TiZ3LZeY7ev5bq
         kuWc+uZmSQWaxbPTDh2L6d644eQ6LFP9MlRpBUFj5J6Oa5JSpGaLeI9D/4FqdLebg1
         YUt2HM22JAXVQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.de>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>, jdelvare@suse.com,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/17] i2c: i801: Don't silently correct invalid transfer size
Date:   Mon, 17 Jan 2022 12:05:41 -0500
Message-Id: <20220117170551.1472640-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170551.1472640-1-sashal@kernel.org>
References: <20220117170551.1472640-1-sashal@kernel.org>
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
index efafd028c5d16..fb0ddaad87d2e 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -774,6 +774,11 @@ static int i801_block_transaction(struct i801_priv *priv,
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
@@ -787,16 +792,6 @@ static int i801_block_transaction(struct i801_priv *priv,
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

