Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44163A6427
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbhFNLVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:21:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235431AbhFNLTN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:19:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 909616198A;
        Mon, 14 Jun 2021 10:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667875;
        bh=e1azNAT/v4NUQ7A/2Pdi20zIzHS6WAprbWWy3490aXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZN2s8yQ+EUnGPJNRdqqe52Xq+OHHREUyZJU2lcSd8e3v9+T91erhGcpdYrsS+GFhL
         HO7/T1nYMU5VQMExr8dIkgaLE7FW+qUuGWGIlzqCLDcaSLLVwFczcfQZYZc9T3ix/m
         v+s6yoso34YmM56Jy68D7P0umtXSH35gsJmEyLXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kyle Tso <kyletso@google.com>
Subject: [PATCH 5.12 109/173] usb: typec: tcpm: Properly handle Alert and Status Messages
Date:   Mon, 14 Jun 2021 12:27:21 +0200
Message-Id: <20210614102701.790188609@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kyle Tso <kyletso@google.com>

commit 063933f47a7af01650af9c4fbcc5831f1c4eb7d9 upstream.

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
 drivers/usb/typec/tcpm/tcpm.c  |   52 +++++++++++++++++++++--------------------
 include/linux/usb/pd_ext_sdb.h |    4 ---
 2 files changed, 27 insertions(+), 29 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -2163,20 +2163,25 @@ static void tcpm_handle_alert(struct tcp
 
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
 
@@ -2420,7 +2425,12 @@ static void tcpm_pd_data_request(struct
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
@@ -2744,24 +2754,16 @@ static void tcpm_pd_ext_msg_request(stru
 
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


