Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09DD339B7D3
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 13:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhFDL0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 07:26:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230075AbhFDL0k (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Jun 2021 07:26:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E3F3613AC;
        Fri,  4 Jun 2021 11:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622805878;
        bh=bmLFLJFCrvDChHo70fEd9cXVhj84IgBCSocclHs7D0U=;
        h=Subject:To:From:Date:From;
        b=zqVaHrSXpJJSwXdfIv3j2oSbhyz7VuCYx58y2UbxKnvY+d2Wzb9VP//dGCWj6JnQT
         eg/EMZjUaVk4gL7bbpyHUDLqiegx8SLmJF5UQGSf2yr7MvQAEgetHbqt0bbDcQOquY
         mK1PTPMoFmd4cSIXSfIecN/b5zwx/YyCo5cK4cr4=
Subject: patch "usb: typec: tcpm: Properly handle Alert and Status Messages" added to usb-linus
To:     kyletso@google.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Jun 2021 13:24:36 +0200
Message-ID: <162280587682131@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpm: Properly handle Alert and Status Messages

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 063933f47a7af01650af9c4fbcc5831f1c4eb7d9 Mon Sep 17 00:00:00 2001
From: Kyle Tso <kyletso@google.com>
Date: Tue, 1 Jun 2021 00:49:28 +0800
Subject: usb: typec: tcpm: Properly handle Alert and Status Messages

When receiving Alert Message, if it is not unexpected but is
unsupported for some reason, the port should return Not_Supported
Message response.

Also, according to PD3.0 Spec 6.5.2.1.4 Event Flags Field, the
OTP/OVP/OCP flags in the Event Flags field in Status Message no longer
require Get_PPS_Status Message to clear them. Thus remove it when
receiving Status Message with those flags being set.

In addition, add the missing AMS operations for Status Message.

Fixes: 64f7c494a3c0 ("typec: tcpm: Add support for sink PPS related messages")
Fixes: 0908c5aca31e ("usb: typec: tcpm: AMS and Collision Avoidance")
Signed-off-by: Kyle Tso <kyletso@google.com>
Link: https://lore.kernel.org/r/20210531164928.2368606-1-kyletso@google.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c  | 52 ++++++++++++++++++----------------
 include/linux/usb/pd_ext_sdb.h |  4 ---
 2 files changed, 27 insertions(+), 29 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 6161a0c1dc0e..938a1afd43ec 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -2188,20 +2188,25 @@ static void tcpm_handle_alert(struct tcpm_port *port, const __le32 *payload,
 
 	if (!type) {
 		tcpm_log(port, "Alert message received with no type");
+		tcpm_queue_message(port, PD_MSG_CTRL_NOT_SUPP);
 		return;
 	}
 
 	/* Just handling non-battery alerts for now */
 	if (!(type & USB_PD_ADO_TYPE_BATT_STATUS_CHANGE)) {
-		switch (port->state) {
-		case SRC_READY:
-		case SNK_READY:
+		if (port->pwr_role == TYPEC_SOURCE) {
+			port->upcoming_state = GET_STATUS_SEND;
+			tcpm_ams_start(port, GETTING_SOURCE_SINK_STATUS);
+		} else {
+			/*
+			 * Do not check SinkTxOk here in case the Source doesn't set its Rp to
+			 * SinkTxOk in time.
+			 */
+			port->ams = GETTING_SOURCE_SINK_STATUS;
 			tcpm_set_state(port, GET_STATUS_SEND, 0);
-			break;
-		default:
-			tcpm_queue_message(port, PD_MSG_CTRL_WAIT);
-			break;
 		}
+	} else {
+		tcpm_queue_message(port, PD_MSG_CTRL_NOT_SUPP);
 	}
 }
 
@@ -2445,7 +2450,12 @@ static void tcpm_pd_data_request(struct tcpm_port *port,
 		tcpm_pd_handle_state(port, BIST_RX, BIST, 0);
 		break;
 	case PD_DATA_ALERT:
-		tcpm_handle_alert(port, msg->payload, cnt);
+		if (port->state != SRC_READY && port->state != SNK_READY)
+			tcpm_pd_handle_state(port, port->pwr_role == TYPEC_SOURCE ?
+					     SRC_SOFT_RESET_WAIT_SNK_TX : SNK_SOFT_RESET,
+					     NONE_AMS, 0);
+		else
+			tcpm_handle_alert(port, msg->payload, cnt);
 		break;
 	case PD_DATA_BATT_STATUS:
 	case PD_DATA_GET_COUNTRY_INFO:
@@ -2769,24 +2779,16 @@ static void tcpm_pd_ext_msg_request(struct tcpm_port *port,
 
 	switch (type) {
 	case PD_EXT_STATUS:
-		/*
-		 * If PPS related events raised then get PPS status to clear
-		 * (see USB PD 3.0 Spec, 6.5.2.4)
-		 */
-		if (msg->ext_msg.data[USB_PD_EXT_SDB_EVENT_FLAGS] &
-		    USB_PD_EXT_SDB_PPS_EVENTS)
-			tcpm_pd_handle_state(port, GET_PPS_STATUS_SEND,
-					     GETTING_SOURCE_SINK_STATUS, 0);
-
-		else
-			tcpm_pd_handle_state(port, ready_state(port), NONE_AMS, 0);
-		break;
 	case PD_EXT_PPS_STATUS:
-		/*
-		 * For now the PPS status message is used to clear events
-		 * and nothing more.
-		 */
-		tcpm_pd_handle_state(port, ready_state(port), NONE_AMS, 0);
+		if (port->ams == GETTING_SOURCE_SINK_STATUS) {
+			tcpm_ams_finish(port);
+			tcpm_set_state(port, ready_state(port), 0);
+		} else {
+			/* unexpected Status or PPS_Status Message */
+			tcpm_pd_handle_state(port, port->pwr_role == TYPEC_SOURCE ?
+					     SRC_SOFT_RESET_WAIT_SNK_TX : SNK_SOFT_RESET,
+					     NONE_AMS, 0);
+		}
 		break;
 	case PD_EXT_SOURCE_CAP_EXT:
 	case PD_EXT_GET_BATT_CAP:
diff --git a/include/linux/usb/pd_ext_sdb.h b/include/linux/usb/pd_ext_sdb.h
index 0eb83ce19597..b517ebc8f0ff 100644
--- a/include/linux/usb/pd_ext_sdb.h
+++ b/include/linux/usb/pd_ext_sdb.h
@@ -24,8 +24,4 @@ enum usb_pd_ext_sdb_fields {
 #define USB_PD_EXT_SDB_EVENT_OVP		BIT(3)
 #define USB_PD_EXT_SDB_EVENT_CF_CV_MODE		BIT(4)
 
-#define USB_PD_EXT_SDB_PPS_EVENTS	(USB_PD_EXT_SDB_EVENT_OCP |	\
-					 USB_PD_EXT_SDB_EVENT_OTP |	\
-					 USB_PD_EXT_SDB_EVENT_OVP)
-
 #endif /* __LINUX_USB_PD_EXT_SDB_H */
-- 
2.31.1


