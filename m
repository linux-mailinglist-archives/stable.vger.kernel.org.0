Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78F74800F3
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236898AbhL0Pvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240877AbhL0Pt5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:49:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB876C0698D8;
        Mon, 27 Dec 2021 07:45:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C993610B1;
        Mon, 27 Dec 2021 15:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73742C36AEA;
        Mon, 27 Dec 2021 15:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619916;
        bh=UC9dyZeW0pIaPKgUTdOG7YJ6guH7hCZP2YNrDU+0v6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PIFQxve5cNKAwwtiWAyAX0nMsjQAhrE/3ECU2LJ9AuHOI9aX0Q9m0sqTiltVvnWYT
         98G2IAwQbzmSbmmbnzuFbWHuYmeWLum5zchwbpbi4D4loxorBGOJZGyjoT5D8VRDW4
         UUtkCxkOgFD4bVZb1aJLAMR3pmouRFwvS0kei0bg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johnny Chuang <johnny.chuang.emc@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 113/128] Input: elants_i2c - do not check Remark ID on eKTH3900/eKTH5312
Date:   Mon, 27 Dec 2021 16:31:28 +0100
Message-Id: <20211227151335.288748362@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
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
@@ -117,6 +117,19 @@
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
 enum elants_chip_id {
 	EKTH3500,
 	EKTF3624,
@@ -736,6 +749,37 @@ static int elants_i2c_validate_remark_id
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
@@ -749,7 +793,7 @@ static int elants_i2c_do_update_firmware
 	u16 send_id;
 	int page, n_fw_pages;
 	int error;
-	bool check_remark_id = ts->iap_version >= 0x60;
+	bool check_remark_id = elants_i2c_should_check_remark_id(ts);
 
 	/* Recovery mode detection! */
 	if (force) {


