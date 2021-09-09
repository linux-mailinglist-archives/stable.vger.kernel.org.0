Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D28404B09
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238114AbhIILue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:50:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240939AbhIILqa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:46:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB52A61215;
        Thu,  9 Sep 2021 11:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187778;
        bh=axmn8dH+PKOLbiom6RifHrPlM1s1t5joj3jEIbTgiWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YAVkVS/f7DiH4GD+3pfZZCnd0LiiGngQJf0tuX8U7+60STWh54iHxhrS1e086rd3Y
         W4s1Zc5iwKQL45vh62Y8+VGJgkgit+xz03wwi+HP7MHBXLquA9DhhLkxTAjKL369mX
         SPCFlV7fIkpE8WrtQCc5IHHB1K8jZq0XBGKFtKiWDo3WZV98ElyeV8MyjYhbKez9RI
         glu7KH3ICMpQ9gszL6B4wAtcyCYWV/Ss0HPs5/AhJX1fm5hFJ5mzozOt0tuwH4ELqL
         HDs41K6C1L1S4boXmtlTTsfkdOY2fXOit1zbu2pYLuquD9bx9JQ1vWFk0wL1i0om8g
         d9NC0DaHYE58Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.de>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 088/252] i2c: i801: Fix handling SMBHSTCNT_PEC_EN
Date:   Thu,  9 Sep 2021 07:38:22 -0400
Message-Id: <20210909114106.141462-88-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit a6b8bb6a813a6621c75ceacd1fa604c0229e9624 ]

Bit SMBHSTCNT_PEC_EN is used only if software calculates the CRC and
uses register SMBPEC. This is not supported by the driver, it supports
hw-calculation of CRC only (using bit SMBAUXSTS_CRCE). The chip spec
states the following, therefore never set bit SMBHSTCNT_PEC_EN.

Chapter SMBus CRC Generation and Checking
If the AAC bit is set in the Auxiliary Control register, the PCH
automatically calculates and drives CRC at the end of the transmitted
packet for write cycles, and will check the CRC for read cycles. It will
not transmit the contents of the PEC register for CRC. The PEC bit must
not be set in the Host Control register. If this bit is set, unspecified
behavior will result.

This patch is based solely on the specification and compile-tested only,
because I have no PEC-capable devices.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Tested-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-i801.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index aa3f60e69230..92ec291c0648 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -503,19 +503,16 @@ static int i801_transaction(struct i801_priv *priv, int xact)
 
 static int i801_block_transaction_by_block(struct i801_priv *priv,
 					   union i2c_smbus_data *data,
-					   char read_write, int command,
-					   int hwpec)
+					   char read_write, int command)
 {
-	int i, len;
-	int status;
-	int xact = hwpec ? SMBHSTCNT_PEC_EN : 0;
+	int i, len, status, xact;
 
 	switch (command) {
 	case I2C_SMBUS_BLOCK_PROC_CALL:
-		xact |= I801_BLOCK_PROC_CALL;
+		xact = I801_BLOCK_PROC_CALL;
 		break;
 	case I2C_SMBUS_BLOCK_DATA:
-		xact |= I801_BLOCK_DATA;
+		xact = I801_BLOCK_DATA;
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -665,8 +662,7 @@ static irqreturn_t i801_isr(int irq, void *dev_id)
  */
 static int i801_block_transaction_byte_by_byte(struct i801_priv *priv,
 					       union i2c_smbus_data *data,
-					       char read_write, int command,
-					       int hwpec)
+					       char read_write, int command)
 {
 	int i, len;
 	int smbcmd;
@@ -764,9 +760,8 @@ static int i801_set_block_buffer_mode(struct i801_priv *priv)
 }
 
 /* Block transaction function */
-static int i801_block_transaction(struct i801_priv *priv,
-				  union i2c_smbus_data *data, char read_write,
-				  int command, int hwpec)
+static int i801_block_transaction(struct i801_priv *priv, union i2c_smbus_data *data,
+				  char read_write, int command)
 {
 	int result = 0;
 	unsigned char hostc;
@@ -802,11 +797,11 @@ static int i801_block_transaction(struct i801_priv *priv,
 	 && i801_set_block_buffer_mode(priv) == 0)
 		result = i801_block_transaction_by_block(priv, data,
 							 read_write,
-							 command, hwpec);
+							 command);
 	else
 		result = i801_block_transaction_byte_by_byte(priv, data,
 							     read_write,
-							     command, hwpec);
+							     command);
 
 	if (command == I2C_SMBUS_I2C_BLOCK_DATA
 	 && read_write == I2C_SMBUS_WRITE) {
@@ -917,8 +912,7 @@ static s32 i801_access(struct i2c_adapter *adap, u16 addr,
 		       SMBAUXCTL(priv));
 
 	if (block)
-		ret = i801_block_transaction(priv, data, read_write, size,
-					     hwpec);
+		ret = i801_block_transaction(priv, data, read_write, size);
 	else
 		ret = i801_transaction(priv, xact);
 
@@ -1690,6 +1684,7 @@ static void i801_setup_hstcfg(struct i801_priv *priv)
 	unsigned char hstcfg = priv->original_hstcfg;
 
 	hstcfg &= ~SMBHSTCFG_I2C_EN;	/* SMBus timing */
+	hstcfg &= ~SMBHSTCNT_PEC_EN;	/* Disable software PEC */
 	hstcfg |= SMBHSTCFG_HST_EN;
 	pci_write_config_byte(priv->pci_dev, SMBHSTCFG, hstcfg);
 }
-- 
2.30.2

