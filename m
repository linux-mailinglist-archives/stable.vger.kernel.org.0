Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB3DB1332B0
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729919AbgAGVKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:10:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:36284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729438AbgAGVKF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:10:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0669E2077B;
        Tue,  7 Jan 2020 21:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431405;
        bh=FvAHbcoWqATo0vcYGrp4Vf8OlzqnBzekWMoDdjm14cU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LDcJCp7NFPKvl6o5xvNJzqY4aAhFP0B16ZTN5dE1XaES4EDE6P1QxHNpu3wstrHP+
         pyoK3uNDZCqvBHaPjF++g8Bl+wNgAwpUoPdwFH7FA/kjbkmnbl7RV2NR+xQKi3yzHH
         fKybdM5xD03NBkcnzXaNzHiLscOPJf4omAYUPMUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.14 26/74] media: pulse8-cec: fix lost cec_transmit_attempt_done() call
Date:   Tue,  7 Jan 2020 21:54:51 +0100
Message-Id: <20200107205155.720076902@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205135.369001641@linuxfoundation.org>
References: <20200107205135.369001641@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit e5a52a1d15c79bb48a430fb263852263ec1d3f11 upstream.

The periodic PING command could interfere with the result of
a CEC transmit, causing a lost cec_transmit_attempt_done()
call.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: <stable@vger.kernel.org>      # for v4.10 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/pulse8-cec/pulse8-cec.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/media/usb/pulse8-cec/pulse8-cec.c
+++ b/drivers/media/usb/pulse8-cec/pulse8-cec.c
@@ -121,6 +121,7 @@ struct pulse8 {
 	unsigned int vers;
 	struct completion cmd_done;
 	struct work_struct work;
+	u8 work_result;
 	struct delayed_work ping_eeprom_work;
 	struct cec_msg rx_msg;
 	u8 data[DATA_SIZE];
@@ -142,8 +143,10 @@ static void pulse8_irq_work_handler(stru
 {
 	struct pulse8 *pulse8 =
 		container_of(work, struct pulse8, work);
+	u8 result = pulse8->work_result;
 
-	switch (pulse8->data[0] & 0x3f) {
+	pulse8->work_result = 0;
+	switch (result & 0x3f) {
 	case MSGCODE_FRAME_DATA:
 		cec_received_msg(pulse8->adap, &pulse8->rx_msg);
 		break;
@@ -177,12 +180,12 @@ static irqreturn_t pulse8_interrupt(stru
 		pulse8->escape = false;
 	} else if (data == MSGEND) {
 		struct cec_msg *msg = &pulse8->rx_msg;
+		u8 msgcode = pulse8->buf[0];
 
 		if (debug)
 			dev_info(pulse8->dev, "received: %*ph\n",
 				 pulse8->idx, pulse8->buf);
-		pulse8->data[0] = pulse8->buf[0];
-		switch (pulse8->buf[0] & 0x3f) {
+		switch (msgcode & 0x3f) {
 		case MSGCODE_FRAME_START:
 			msg->len = 1;
 			msg->msg[0] = pulse8->buf[1];
@@ -191,14 +194,20 @@ static irqreturn_t pulse8_interrupt(stru
 			if (msg->len == CEC_MAX_MSG_SIZE)
 				break;
 			msg->msg[msg->len++] = pulse8->buf[1];
-			if (pulse8->buf[0] & MSGCODE_FRAME_EOM)
+			if (msgcode & MSGCODE_FRAME_EOM) {
+				WARN_ON(pulse8->work_result);
+				pulse8->work_result = msgcode;
 				schedule_work(&pulse8->work);
+				break;
+			}
 			break;
 		case MSGCODE_TRANSMIT_SUCCEEDED:
 		case MSGCODE_TRANSMIT_FAILED_LINE:
 		case MSGCODE_TRANSMIT_FAILED_ACK:
 		case MSGCODE_TRANSMIT_FAILED_TIMEOUT_DATA:
 		case MSGCODE_TRANSMIT_FAILED_TIMEOUT_LINE:
+			WARN_ON(pulse8->work_result);
+			pulse8->work_result = msgcode;
 			schedule_work(&pulse8->work);
 			break;
 		case MSGCODE_HIGH_ERROR:


