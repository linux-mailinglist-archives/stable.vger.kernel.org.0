Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69BF247FFC3
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbhL0PlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:41:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39164 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238814AbhL0PjS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:39:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 138B4610F4;
        Mon, 27 Dec 2021 15:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7F9C36AEA;
        Mon, 27 Dec 2021 15:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619557;
        bh=oPDPs7mMFsEWC1psm9pFPE0y5DV5PzK598c6Y0kPV3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n+O+FCQ8B/GAZAY3AE7c6XVMrn0clfxHcc9b6omMrVLuHsUWHMB8ZkOpGNtbZi52Z
         CGuNn5fd/KcXFH17i909ZiesoyOjM522kDl6+PHEPT42BIGORmVe6lORNWc9eGCNpo
         SuAsdLrqNFIqNL0tjvM2KU74Mm4b/3+eSHjhaPuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johnny Chuang <johnny.chuang.emc@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 65/76] Input: elants_i2c - do not check Remark ID on eKTH3900/eKTH5312
Date:   Mon, 27 Dec 2021 16:31:20 +0100
Message-Id: <20211227151326.941975336@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johnny Chuang <johnny.chuang.emc@gmail.com>

commit 4ebfee2bbc1a9c343dd50565ba5ae249fac32267 upstream.

The eKTH3900/eKTH5312 series do not support the firmware update rules of
Remark ID. Exclude these two series from checking it when updating the
firmware in touch controllers.

Signed-off-by: Johnny Chuang <johnny.chuang.emc@gmail.com>
Link: https://lore.kernel.org/r/1639619603-20616-1-git-send-email-johnny.chuang.emc@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/elants_i2c.c |   46 ++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

--- a/drivers/input/touchscreen/elants_i2c.c
+++ b/drivers/input/touchscreen/elants_i2c.c
@@ -109,6 +109,19 @@
 #define ELAN_POWERON_DELAY_USEC	500
 #define ELAN_RESET_DELAY_MSEC	20
 
+/* FW boot code version */
+#define BC_VER_H_BYTE_FOR_EKTH3900x1_I2C        0x72
+#define BC_VER_H_BYTE_FOR_EKTH3900x2_I2C        0x82
+#define BC_VER_H_BYTE_FOR_EKTH3900x3_I2C        0x92
+#define BC_VER_H_BYTE_FOR_EKTH5312x1_I2C        0x6D
+#define BC_VER_H_BYTE_FOR_EKTH5312x2_I2C        0x6E
+#define BC_VER_H_BYTE_FOR_EKTH5312cx1_I2C       0x77
+#define BC_VER_H_BYTE_FOR_EKTH5312cx2_I2C       0x78
+#define BC_VER_H_BYTE_FOR_EKTH5312x1_I2C_USB    0x67
+#define BC_VER_H_BYTE_FOR_EKTH5312x2_I2C_USB    0x68
+#define BC_VER_H_BYTE_FOR_EKTH5312cx1_I2C_USB   0x74
+#define BC_VER_H_BYTE_FOR_EKTH5312cx2_I2C_USB   0x75
+
 enum elants_state {
 	ELAN_STATE_NORMAL,
 	ELAN_WAIT_QUEUE_HEADER,
@@ -663,6 +676,37 @@ static int elants_i2c_validate_remark_id
 	return 0;
 }
 
+static bool elants_i2c_should_check_remark_id(struct elants_data *ts)
+{
+	struct i2c_client *client = ts->client;
+	const u8 bootcode_version = ts->iap_version;
+	bool check;
+
+	/* I2C eKTH3900 and eKTH5312 are NOT support Remark ID */
+	if ((bootcode_version == BC_VER_H_BYTE_FOR_EKTH3900x1_I2C) ||
+	    (bootcode_version == BC_VER_H_BYTE_FOR_EKTH3900x2_I2C) ||
+	    (bootcode_version == BC_VER_H_BYTE_FOR_EKTH3900x3_I2C) ||
+	    (bootcode_version == BC_VER_H_BYTE_FOR_EKTH5312x1_I2C) ||
+	    (bootcode_version == BC_VER_H_BYTE_FOR_EKTH5312x2_I2C) ||
+	    (bootcode_version == BC_VER_H_BYTE_FOR_EKTH5312cx1_I2C) ||
+	    (bootcode_version == BC_VER_H_BYTE_FOR_EKTH5312cx2_I2C) ||
+	    (bootcode_version == BC_VER_H_BYTE_FOR_EKTH5312x1_I2C_USB) ||
+	    (bootcode_version == BC_VER_H_BYTE_FOR_EKTH5312x2_I2C_USB) ||
+	    (bootcode_version == BC_VER_H_BYTE_FOR_EKTH5312cx1_I2C_USB) ||
+	    (bootcode_version == BC_VER_H_BYTE_FOR_EKTH5312cx2_I2C_USB)) {
+		dev_dbg(&client->dev,
+			"eKTH3900/eKTH5312(0x%02x) are not support remark id\n",
+			bootcode_version);
+		check = false;
+	} else if (bootcode_version >= 0x60) {
+		check = true;
+	} else {
+		check = false;
+	}
+
+	return check;
+}
+
 static int elants_i2c_do_update_firmware(struct i2c_client *client,
 					 const struct firmware *fw,
 					 bool force)
@@ -676,7 +720,7 @@ static int elants_i2c_do_update_firmware
 	u16 send_id;
 	int page, n_fw_pages;
 	int error;
-	bool check_remark_id = ts->iap_version >= 0x60;
+	bool check_remark_id = elants_i2c_should_check_remark_id(ts);
 
 	/* Recovery mode detection! */
 	if (force) {


