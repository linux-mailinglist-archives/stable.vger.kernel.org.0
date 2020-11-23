Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC752C09A5
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387754AbgKWNJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:09:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:33046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732822AbgKWMrw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:47:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACDDE20732;
        Mon, 23 Nov 2020 12:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135659;
        bh=nyEAM/T93w3SVehLVpWVXIzl2+tDCjr73kJfPBWfMY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rflpnU5gppjDEAYeZwGPQD20w5MHVkPx8IBSY9ZD4cTVSpNePiG869F+JlU4SpifL
         9HtOyLZq2O9u44lDyIIdEbvTjiYCzwGMgxbHLq6iJHWAH7T9GJLk0H22B9VxD02WCN
         EpjqGPThclEb8G1K/wIPFcoxyNs/YQcmQSaZ4j3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jingle Wu <jingle.wu@emc.com.tw>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 118/252] Input: elan_i2c - fix firmware update on newer ICs
Date:   Mon, 23 Nov 2020 13:21:08 +0100
Message-Id: <20201123121841.286864053@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: jingle.wu <jingle.wu@emc.com.tw>

[ Upstream commit ae3d6083acf60116d4f409677452399547ed2009 ]

The argument to iap page type command depends on the firmware page size.

Fixes: bfd9b92bc8f9 ("Input: elan_i2c - handle firmware updated on newer ICs")
Signed-off-by: Jingle Wu <jingle.wu@emc.com.tw>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/elan_i2c.h       |  2 +-
 drivers/input/mouse/elan_i2c_core.c  |  3 ++-
 drivers/input/mouse/elan_i2c_i2c.c   | 10 +++++-----
 drivers/input/mouse/elan_i2c_smbus.c |  2 +-
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/input/mouse/elan_i2c.h b/drivers/input/mouse/elan_i2c.h
index c75b00c45d750..36e3cd9086716 100644
--- a/drivers/input/mouse/elan_i2c.h
+++ b/drivers/input/mouse/elan_i2c.h
@@ -78,7 +78,7 @@ struct elan_transport_ops {
 	int (*iap_reset)(struct i2c_client *client);
 
 	int (*prepare_fw_update)(struct i2c_client *client, u16 ic_type,
-				 u8 iap_version);
+				 u8 iap_version, u16 fw_page_size);
 	int (*write_fw_block)(struct i2c_client *client, u16 fw_page_size,
 			      const u8 *page, u16 checksum, int idx);
 	int (*finish_fw_update)(struct i2c_client *client,
diff --git a/drivers/input/mouse/elan_i2c_core.c b/drivers/input/mouse/elan_i2c_core.c
index c599e21a84784..61ed3f5ca2199 100644
--- a/drivers/input/mouse/elan_i2c_core.c
+++ b/drivers/input/mouse/elan_i2c_core.c
@@ -497,7 +497,8 @@ static int __elan_update_firmware(struct elan_tp_data *data,
 	u16 sw_checksum = 0, fw_checksum = 0;
 
 	error = data->ops->prepare_fw_update(client, data->ic_type,
-					     data->iap_version);
+					     data->iap_version,
+					     data->fw_page_size);
 	if (error)
 		return error;
 
diff --git a/drivers/input/mouse/elan_i2c_i2c.c b/drivers/input/mouse/elan_i2c_i2c.c
index 5a496d4ffa491..13dc097eb6c65 100644
--- a/drivers/input/mouse/elan_i2c_i2c.c
+++ b/drivers/input/mouse/elan_i2c_i2c.c
@@ -517,7 +517,7 @@ static int elan_i2c_set_flash_key(struct i2c_client *client)
 	return 0;
 }
 
-static int elan_read_write_iap_type(struct i2c_client *client)
+static int elan_read_write_iap_type(struct i2c_client *client, u16 fw_page_size)
 {
 	int error;
 	u16 constant;
@@ -526,7 +526,7 @@ static int elan_read_write_iap_type(struct i2c_client *client)
 
 	do {
 		error = elan_i2c_write_cmd(client, ETP_I2C_IAP_TYPE_CMD,
-					   ETP_I2C_IAP_TYPE_REG);
+					   fw_page_size / 2);
 		if (error) {
 			dev_err(&client->dev,
 				"cannot write iap type: %d\n", error);
@@ -543,7 +543,7 @@ static int elan_read_write_iap_type(struct i2c_client *client)
 		constant = le16_to_cpup((__le16 *)val);
 		dev_dbg(&client->dev, "iap type reg: 0x%04x\n", constant);
 
-		if (constant == ETP_I2C_IAP_TYPE_REG)
+		if (constant == fw_page_size / 2)
 			return 0;
 
 	} while (--retry > 0);
@@ -553,7 +553,7 @@ static int elan_read_write_iap_type(struct i2c_client *client)
 }
 
 static int elan_i2c_prepare_fw_update(struct i2c_client *client, u16 ic_type,
-				      u8 iap_version)
+				      u8 iap_version, u16 fw_page_size)
 {
 	struct device *dev = &client->dev;
 	int error;
@@ -594,7 +594,7 @@ static int elan_i2c_prepare_fw_update(struct i2c_client *client, u16 ic_type,
 	}
 
 	if (ic_type >= 0x0D && iap_version >= 1) {
-		error = elan_read_write_iap_type(client);
+		error = elan_read_write_iap_type(client, fw_page_size);
 		if (error)
 			return error;
 	}
diff --git a/drivers/input/mouse/elan_i2c_smbus.c b/drivers/input/mouse/elan_i2c_smbus.c
index 8ff823751f3ba..1820f1cfc1dc4 100644
--- a/drivers/input/mouse/elan_i2c_smbus.c
+++ b/drivers/input/mouse/elan_i2c_smbus.c
@@ -340,7 +340,7 @@ static int elan_smbus_set_flash_key(struct i2c_client *client)
 }
 
 static int elan_smbus_prepare_fw_update(struct i2c_client *client, u16 ic_type,
-					u8 iap_version)
+					u8 iap_version, u16 fw_page_size)
 {
 	struct device *dev = &client->dev;
 	int len;
-- 
2.27.0



