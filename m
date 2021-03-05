Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2BE32E8B5
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbhCEM22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:28:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:36648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231903AbhCEM2C (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:28:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BF5365033;
        Fri,  5 Mar 2021 12:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947281;
        bh=2TFzhGIT6edKdwWyhZYFtdzQseAAnH/i1ygi4KFGDEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nBkbhURLkEPZ/QOnweWic483NAOUTan2v56xtJ8x6I8R5SeW1Pc2BRgc7JsItnVh+
         214U41VbCSacYAjdwJLr1VJG17N+SBWtLKAV4mhRZhdVUpn8CEUDx+ggFo+YvYnILN
         x1OMPLuc7X3NdXoM7qTpbnOObliFlDFJkL83poCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jingle Wu <jingle.wu@emc.com.tw>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Subject: [PATCH 5.10 002/102] Input: elantech - fix protocol errors for some trackpoints in SMBus mode
Date:   Fri,  5 Mar 2021 13:20:21 +0100
Message-Id: <20210305120903.406732015@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: jingle.wu <jingle.wu@emc.com.tw>

commit e4c9062717feda88900b566463228d1c4910af6d upstream.

There are some version of Elan trackpads that send incorrect data when
in SMbus mode, unless they are switched to use 0x5f reports instead of
standard 0x5e. This patch implements querying device to retrieve chips
identifying data, and switching it, when needed to the alternative
report.

Signed-off-by: Jingle Wu <jingle.wu@emc.com.tw>
Link: https://lore.kernel.org/r/20201211071531.32413-1-jingle.wu@emc.com.tw
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/elantech.c |   99 ++++++++++++++++++++++++++++++++++++++++-
 drivers/input/mouse/elantech.h |    4 +
 2 files changed, 101 insertions(+), 2 deletions(-)

--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -90,6 +90,47 @@ static int elantech_ps2_command(struct p
 }
 
 /*
+ * Send an Elantech style special command to read 3 bytes from a register
+ */
+static int elantech_read_reg_params(struct psmouse *psmouse, u8 reg, u8 *param)
+{
+	if (elantech_ps2_command(psmouse, NULL, ETP_PS2_CUSTOM_COMMAND) ||
+	    elantech_ps2_command(psmouse, NULL, ETP_REGISTER_READWRITE) ||
+	    elantech_ps2_command(psmouse, NULL, ETP_PS2_CUSTOM_COMMAND) ||
+	    elantech_ps2_command(psmouse, NULL, reg) ||
+	    elantech_ps2_command(psmouse, param, PSMOUSE_CMD_GETINFO)) {
+		psmouse_err(psmouse,
+			    "failed to read register %#02x\n", reg);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+/*
+ * Send an Elantech style special command to write a register with a parameter
+ */
+static int elantech_write_reg_params(struct psmouse *psmouse, u8 reg, u8 *param)
+{
+	if (elantech_ps2_command(psmouse, NULL, ETP_PS2_CUSTOM_COMMAND) ||
+	    elantech_ps2_command(psmouse, NULL, ETP_REGISTER_READWRITE) ||
+	    elantech_ps2_command(psmouse, NULL, ETP_PS2_CUSTOM_COMMAND) ||
+	    elantech_ps2_command(psmouse, NULL, reg) ||
+	    elantech_ps2_command(psmouse, NULL, ETP_PS2_CUSTOM_COMMAND) ||
+	    elantech_ps2_command(psmouse, NULL, param[0]) ||
+	    elantech_ps2_command(psmouse, NULL, ETP_PS2_CUSTOM_COMMAND) ||
+	    elantech_ps2_command(psmouse, NULL, param[1]) ||
+	    elantech_ps2_command(psmouse, NULL, PSMOUSE_CMD_SETSCALE11)) {
+		psmouse_err(psmouse,
+			    "failed to write register %#02x with value %#02x%#02x\n",
+			    reg, param[0], param[1]);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+/*
  * Send an Elantech style special command to read a value from a register
  */
 static int elantech_read_reg(struct psmouse *psmouse, unsigned char reg,
@@ -1530,18 +1571,34 @@ static const struct dmi_system_id no_hw_
 };
 
 /*
+ * Change Report id 0x5E to 0x5F.
+ */
+static int elantech_change_report_id(struct psmouse *psmouse)
+{
+	unsigned char param[2] = { 0x10, 0x03 };
+
+	if (elantech_write_reg_params(psmouse, 0x7, param) ||
+	    elantech_read_reg_params(psmouse, 0x7, param) ||
+	    param[0] != 0x10 || param[1] != 0x03) {
+		psmouse_err(psmouse, "Unable to change report ID to 0x5f.\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+/*
  * determine hardware version and set some properties according to it.
  */
 static int elantech_set_properties(struct elantech_device_info *info)
 {
 	/* This represents the version of IC body. */
-	int ver = (info->fw_version & 0x0f0000) >> 16;
+	info->ic_version = (info->fw_version & 0x0f0000) >> 16;
 
 	/* Early version of Elan touchpads doesn't obey the rule. */
 	if (info->fw_version < 0x020030 || info->fw_version == 0x020600)
 		info->hw_version = 1;
 	else {
-		switch (ver) {
+		switch (info->ic_version) {
 		case 2:
 		case 4:
 			info->hw_version = 2;
@@ -1557,6 +1614,11 @@ static int elantech_set_properties(struc
 		}
 	}
 
+	/* Get information pattern for hw_version 4 */
+	info->pattern = 0x00;
+	if (info->ic_version == 0x0f && (info->fw_version & 0xff) <= 0x02)
+		info->pattern = info->fw_version & 0xff;
+
 	/* decide which send_cmd we're gonna use early */
 	info->send_cmd = info->hw_version >= 3 ? elantech_send_cmd :
 						 synaptics_send_cmd;
@@ -1598,6 +1660,7 @@ static int elantech_query_info(struct ps
 {
 	unsigned char param[3];
 	unsigned char traces;
+	unsigned char ic_body[3];
 
 	memset(info, 0, sizeof(*info));
 
@@ -1640,6 +1703,21 @@ static int elantech_query_info(struct ps
 			     info->samples[2]);
 	}
 
+	if (info->pattern > 0x00 && info->ic_version == 0xf) {
+		if (info->send_cmd(psmouse, ETP_ICBODY_QUERY, ic_body)) {
+			psmouse_err(psmouse, "failed to query ic body\n");
+			return -EINVAL;
+		}
+		info->ic_version = be16_to_cpup((__be16 *)ic_body);
+		psmouse_info(psmouse,
+			     "Elan ic body: %#04x, current fw version: %#02x\n",
+			     info->ic_version, ic_body[2]);
+	}
+
+	info->product_id = be16_to_cpup((__be16 *)info->samples);
+	if (info->pattern == 0x00)
+		info->product_id &= 0xff;
+
 	if (info->samples[1] == 0x74 && info->hw_version == 0x03) {
 		/*
 		 * This module has a bug which makes absolute mode
@@ -1654,6 +1732,23 @@ static int elantech_query_info(struct ps
 	/* The MSB indicates the presence of the trackpoint */
 	info->has_trackpoint = (info->capabilities[0] & 0x80) == 0x80;
 
+	if (info->has_trackpoint && info->ic_version == 0x0011 &&
+	    (info->product_id == 0x08 || info->product_id == 0x09 ||
+	     info->product_id == 0x0d || info->product_id == 0x0e)) {
+		/*
+		 * This module has a bug which makes trackpoint in SMBus
+		 * mode return invalid data unless trackpoint is switched
+		 * from using 0x5e reports to 0x5f. If we are not able to
+		 * make the switch, let's abort initialization so we'll be
+		 * using standard PS/2 protocol.
+		 */
+		if (elantech_change_report_id(psmouse)) {
+			psmouse_info(psmouse,
+				     "Trackpoint report is broken, forcing standard PS/2 protocol\n");
+			return -ENODEV;
+		}
+	}
+
 	info->x_res = 31;
 	info->y_res = 31;
 	if (info->hw_version == 4) {
--- a/drivers/input/mouse/elantech.h
+++ b/drivers/input/mouse/elantech.h
@@ -18,6 +18,7 @@
 #define ETP_CAPABILITIES_QUERY		0x02
 #define ETP_SAMPLE_QUERY		0x03
 #define ETP_RESOLUTION_QUERY		0x04
+#define ETP_ICBODY_QUERY		0x05
 
 /*
  * Command values for register reading or writing
@@ -140,7 +141,10 @@ struct elantech_device_info {
 	unsigned char samples[3];
 	unsigned char debug;
 	unsigned char hw_version;
+	unsigned char pattern;
 	unsigned int fw_version;
+	unsigned int ic_version;
+	unsigned int product_id;
 	unsigned int x_min;
 	unsigned int y_min;
 	unsigned int x_max;


