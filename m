Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A470632E8B7
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhCEM23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:28:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231921AbhCEM2F (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:28:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 227F165031;
        Fri,  5 Mar 2021 12:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947284;
        bh=ejXKRYZG76XwBu6KMXOnU+pRL099t+/SP1QHHv8cDH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pEe7NHVq6ZOXihvprIAhivUlRi0t001lRa/h9zWdxC3zGGY/u/H6U2gFiASS49BMm
         z9oXr6II2SuXs1XZvXiAyUwXnm3iI2U7zXOOUR68X8rqvmzFl2Q1SPbD8BD974fev+
         7pJiibxEk/3oi7vSp2WsWcz7mifG/ex0KDMUmvRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jingle Wu <jingle.wu@emc.com.tw>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Nikolai Kostrigin <nickel@basealt.ru>
Subject: [PATCH 5.10 003/102] Input: elan_i2c - add new trackpoint report type 0x5F
Date:   Fri,  5 Mar 2021 13:20:22 +0100
Message-Id: <20210305120903.456291523@linuxfoundation.org>
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

From: Jingle Wu <jingle.wu@emc.com.tw>

commit 056115daede8d01f71732bc7d778fb85acee8eb6 upstream.

The 0x5F is a new trackpoint report type used by some modules.

Signed-off-by: Jingle Wu <jingle.wu@emc.com.tw>
Link: https://lore.kernel.org/r/20201211071511.32349-1-jingle.wu@emc.com.tw
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Nikolai Kostrigin <nickel@basealt.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/elan_i2c.h       |   16 ++++++++++++++++
 drivers/input/mouse/elan_i2c_core.c  |   13 +------------
 drivers/input/mouse/elan_i2c_smbus.c |    8 ++++++--
 3 files changed, 23 insertions(+), 14 deletions(-)

--- a/drivers/input/mouse/elan_i2c.h
+++ b/drivers/input/mouse/elan_i2c.h
@@ -28,6 +28,22 @@
 
 #define ETP_FEATURE_REPORT_MK	BIT(0)
 
+#define ETP_REPORT_ID		0x5D
+#define ETP_TP_REPORT_ID	0x5E
+#define ETP_TP_REPORT_ID2	0x5F
+#define ETP_REPORT_ID2		0x60	/* High precision report */
+
+#define ETP_REPORT_ID_OFFSET	2
+#define ETP_TOUCH_INFO_OFFSET	3
+#define ETP_FINGER_DATA_OFFSET	4
+#define ETP_HOVER_INFO_OFFSET	30
+#define ETP_MK_DATA_OFFSET	33	/* For high precision reports */
+
+#define ETP_MAX_REPORT_LEN	39
+
+#define ETP_MAX_FINGERS		5
+#define ETP_FINGER_DATA_LEN	5
+
 /* IAP Firmware handling */
 #define ETP_PRODUCT_ID_FORMAT_STRING	"%d.0"
 #define ETP_FW_NAME		"elan_i2c_" ETP_PRODUCT_ID_FORMAT_STRING ".bin"
--- a/drivers/input/mouse/elan_i2c_core.c
+++ b/drivers/input/mouse/elan_i2c_core.c
@@ -47,18 +47,6 @@
 #define ETP_FINGER_WIDTH	15
 #define ETP_RETRY_COUNT		3
 
-#define ETP_MAX_FINGERS		5
-#define ETP_FINGER_DATA_LEN	5
-#define ETP_REPORT_ID		0x5D
-#define ETP_REPORT_ID2		0x60	/* High precision report */
-#define ETP_TP_REPORT_ID	0x5E
-#define ETP_REPORT_ID_OFFSET	2
-#define ETP_TOUCH_INFO_OFFSET	3
-#define ETP_FINGER_DATA_OFFSET	4
-#define ETP_HOVER_INFO_OFFSET	30
-#define ETP_MK_DATA_OFFSET	33	/* For high precision reports */
-#define ETP_MAX_REPORT_LEN	39
-
 /* The main device structure */
 struct elan_tp_data {
 	struct i2c_client	*client;
@@ -1076,6 +1064,7 @@ static irqreturn_t elan_isr(int irq, voi
 		elan_report_absolute(data, report, true);
 		break;
 	case ETP_TP_REPORT_ID:
+	case ETP_TP_REPORT_ID2:
 		elan_report_trackpoint(data, report);
 		break;
 	default:
--- a/drivers/input/mouse/elan_i2c_smbus.c
+++ b/drivers/input/mouse/elan_i2c_smbus.c
@@ -45,6 +45,7 @@
 #define ETP_SMBUS_CALIBRATE_QUERY	0xC5
 
 #define ETP_SMBUS_REPORT_LEN		32
+#define ETP_SMBUS_REPORT_LEN2		7
 #define ETP_SMBUS_REPORT_OFFSET		2
 #define ETP_SMBUS_HELLOPACKET_LEN	5
 #define ETP_SMBUS_IAP_PASSWORD		0x1234
@@ -497,10 +498,13 @@ static int elan_smbus_get_report(struct
 		return len;
 	}
 
-	if (len != ETP_SMBUS_REPORT_LEN) {
+	if (report[ETP_REPORT_ID_OFFSET] == ETP_TP_REPORT_ID2)
+		report_len = ETP_SMBUS_REPORT_LEN2;
+
+	if (len != report_len) {
 		dev_err(&client->dev,
 			"wrong report length (%d vs %d expected)\n",
-			len, ETP_SMBUS_REPORT_LEN);
+			len, report_len);
 		return -EIO;
 	}
 


