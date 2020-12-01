Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B392DA257
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 22:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503601AbgLNVIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 16:08:16 -0500
Received: from www.linuxtv.org ([130.149.80.248]:52230 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503603AbgLNVIP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 16:08:15 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1kov46-0039ff-14; Mon, 14 Dec 2020 21:07:30 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Tue, 01 Dec 2020 15:20:02 +0000
Subject: [git:media_tree/master] media: pulse8-cec: add support for FW v10 and up
To:     linuxtv-commits@linuxtv.org
Cc:     Maxime Ripard <mripard@kernel.org>, stable@vger.kernel.org,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1kov46-0039ff-14@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: pulse8-cec: add support for FW v10 and up
Author:  Hans Verkuil <hverkuil-cisco@xs4all.nl>
Date:    Fri Nov 27 12:52:30 2020 +0100

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

 drivers/media/cec/usb/pulse8/pulse8-cec.c | 43 +++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 13 deletions(-)

---

diff --git a/drivers/media/cec/usb/pulse8/pulse8-cec.c b/drivers/media/cec/usb/pulse8/pulse8-cec.c
index 5d3a3f775bc8..04b13cdc38d2 100644
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
@@ -143,6 +145,8 @@ static const char * const pulse8_msgnames[] = {
 	"WRITE_EEPROM",
 	"GET_ADAPTER_TYPE",
 	"SET_ACTIVE_SOURCE",
+	"GET_AUTO_POWER_ON",
+	"SET_AUTO_POWER_ON",
 };
 
 static const char *pulse8_msgname(u8 cmd)
@@ -579,12 +583,14 @@ static int pulse8_cec_adap_log_addr(struct cec_adapter *adap, u8 log_addr)
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
@@ -691,6 +697,14 @@ static int pulse8_setup(struct pulse8 *pulse8, struct serio *serio,
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
@@ -752,12 +766,15 @@ static int pulse8_setup(struct pulse8 *pulse8, struct serio *serio,
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
