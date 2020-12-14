Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390642D9F02
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407438AbgLNS2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:28:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:46104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502300AbgLNRiC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:38:02 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Maxime Ripard <mripard@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.9 077/105] media: pulse8-cec: add support for FW v10 and up
Date:   Mon, 14 Dec 2020 18:28:51 +0100
Message-Id: <20201214172558.977883031@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit 45ba1c0ba3e589ad3ef0d0603c822eb27ea16563 upstream.

Starting with firmware version 10 the GET/SET_HDMI_VERSION message
was removed and GET/SET_AUTO_POWER_ON was added.

The removal of GET/SET_HDMI_VERSION caused the probe of the
Pulse-Eight to fail. Add a version check to handle this gracefully.

Also show (but do not set) the Auto Power On value.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: Maxime Ripard <mripard@kernel.org>
Tested-by: Maxime Ripard <mripard@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/cec/usb/pulse8/pulse8-cec.c |   43 ++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 13 deletions(-)

--- a/drivers/media/cec/usb/pulse8/pulse8-cec.c
+++ b/drivers/media/cec/usb/pulse8/pulse8-cec.c
@@ -88,13 +88,15 @@ enum pulse8_msgcodes {
 	MSGCODE_SET_PHYSICAL_ADDRESS,	/* 0x20 */
 	MSGCODE_GET_DEVICE_TYPE,
 	MSGCODE_SET_DEVICE_TYPE,
-	MSGCODE_GET_HDMI_VERSION,
+	MSGCODE_GET_HDMI_VERSION,	/* Removed in FW >= 10 */
 	MSGCODE_SET_HDMI_VERSION,
 	MSGCODE_GET_OSD_NAME,
 	MSGCODE_SET_OSD_NAME,
 	MSGCODE_WRITE_EEPROM,
 	MSGCODE_GET_ADAPTER_TYPE,	/* 0x28 */
 	MSGCODE_SET_ACTIVE_SOURCE,
+	MSGCODE_GET_AUTO_POWER_ON,	/* New for FW >= 10 */
+	MSGCODE_SET_AUTO_POWER_ON,
 
 	MSGCODE_FRAME_EOM = 0x80,
 	MSGCODE_FRAME_ACK = 0x40,
@@ -143,6 +145,8 @@ static const char * const pulse8_msgname
 	"WRITE_EEPROM",
 	"GET_ADAPTER_TYPE",
 	"SET_ACTIVE_SOURCE",
+	"GET_AUTO_POWER_ON",
+	"SET_AUTO_POWER_ON",
 };
 
 static const char *pulse8_msgname(u8 cmd)
@@ -579,12 +583,14 @@ static int pulse8_cec_adap_log_addr(stru
 	if (err)
 		goto unlock;
 
-	cmd[0] = MSGCODE_SET_HDMI_VERSION;
-	cmd[1] = adap->log_addrs.cec_version;
-	err = pulse8_send_and_wait(pulse8, cmd, 2,
-				   MSGCODE_COMMAND_ACCEPTED, 0);
-	if (err)
-		goto unlock;
+	if (pulse8->vers < 10) {
+		cmd[0] = MSGCODE_SET_HDMI_VERSION;
+		cmd[1] = adap->log_addrs.cec_version;
+		err = pulse8_send_and_wait(pulse8, cmd, 2,
+					   MSGCODE_COMMAND_ACCEPTED, 0);
+		if (err)
+			goto unlock;
+	}
 
 	if (adap->log_addrs.osd_name[0]) {
 		size_t osd_len = strlen(adap->log_addrs.osd_name);
@@ -691,6 +697,14 @@ static int pulse8_setup(struct pulse8 *p
 	dev_dbg(pulse8->dev, "Autonomous mode: %s",
 		data[0] ? "on" : "off");
 
+	if (pulse8->vers >= 10) {
+		cmd[0] = MSGCODE_GET_AUTO_POWER_ON;
+		err = pulse8_send_and_wait(pulse8, cmd, 1, cmd[0], 1);
+		if (!err)
+			dev_dbg(pulse8->dev, "Auto Power On: %s",
+				data[0] ? "on" : "off");
+	}
+
 	cmd[0] = MSGCODE_GET_DEVICE_TYPE;
 	err = pulse8_send_and_wait(pulse8, cmd, 1, cmd[0], 1);
 	if (err)
@@ -752,12 +766,15 @@ static int pulse8_setup(struct pulse8 *p
 	dev_dbg(pulse8->dev, "Physical address: %x.%x.%x.%x\n",
 		cec_phys_addr_exp(*pa));
 
-	cmd[0] = MSGCODE_GET_HDMI_VERSION;
-	err = pulse8_send_and_wait(pulse8, cmd, 1, cmd[0], 1);
-	if (err)
-		return err;
-	log_addrs->cec_version = data[0];
-	dev_dbg(pulse8->dev, "CEC version: %d\n", log_addrs->cec_version);
+	log_addrs->cec_version = CEC_OP_CEC_VERSION_1_4;
+	if (pulse8->vers < 10) {
+		cmd[0] = MSGCODE_GET_HDMI_VERSION;
+		err = pulse8_send_and_wait(pulse8, cmd, 1, cmd[0], 1);
+		if (err)
+			return err;
+		log_addrs->cec_version = data[0];
+		dev_dbg(pulse8->dev, "CEC version: %d\n", log_addrs->cec_version);
+	}
 
 	cmd[0] = MSGCODE_GET_OSD_NAME;
 	err = pulse8_send_and_wait(pulse8, cmd, 1, cmd[0], 0);


