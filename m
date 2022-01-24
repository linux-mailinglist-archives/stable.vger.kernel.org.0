Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5574999D3
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1456160AbiAXVh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:37:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44990 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1453413AbiAXVaI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:30:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5006BB8105C;
        Mon, 24 Jan 2022 21:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E96C340E4;
        Mon, 24 Jan 2022 21:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059804;
        bh=P8uN7Qcdlnrf6K1w94rRAe6b7mk1wt3YZB943ppmnEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ee+6EdznbQGMeWMA3cysw69uuVJf6laigvy0HCqQKth3m2LJcuMrAYH1/mFG93oTc
         jRehgTDjv3C0SZ5FYyW1/3ayiuoExzgsIPl8WOKCMsGWKXUJYF+zyNhBmwx25N5YBP
         Te784DT9sNrpIWUx1FLBI9+exJ7Pv5d66p0m7mls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.de>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0740/1039] i2c: i801: Dont silently correct invalid transfer size
Date:   Mon, 24 Jan 2022 19:42:09 +0100
Message-Id: <20220124184150.202022295@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



