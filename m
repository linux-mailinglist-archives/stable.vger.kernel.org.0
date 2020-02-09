Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98794156A72
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbgBINFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:05:41 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:57975 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727654AbgBINFl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:05:41 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2E61221D73;
        Sun,  9 Feb 2020 08:05:40 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:05:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=sOZNtY
        ZgQS4QyZcO2JOgSM2nOU4UycfRlih09WdiRdg=; b=HC1RcRD66WIYNANcrOj6Nf
        Rj+IMt17HZzehvnzs4cPmgYT+vQENvFQ5aVX56FaQDFqDCbQOqym/a6tc4RsWPxx
        XQ10lTDnADCzK2ayilvjPvz4Fej3suy4Ps+CAjb25GJZ+3FCg6DK/NibZXBFs25z
        HZzamNFzunsPRCQPBEboyHvlfR6MLhOT4fdg40GP5E0QkMEQfmc2oBuxW3J7lAgI
        cnuTRc/xitoBiECOj8PT9a8u4UTw9whgQu3p9HssJbhbTBQyqQWjqyMYZCtqrVRZ
        M9TNYIMqvlTJ/8dgUzduwGD04R+BmBaT6Q1VrjG2lsHaBFYvGj33ac0iT3EBSPwQ
        ==
X-ME-Sender: <xms:pANAXsEk7gVeRPvL1SET_es8R8XL4qt2ABSns3vcmWD5Wai8BOLvUw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:pANAXmq9KFl4m2sjfr58V6SS0FomHcwp0BBEE77VDSOhmPqyGrdPUA>
    <xmx:pANAXqzmbLVp1tcR79ePCjLOhbyVF1o69poJGoShWXvzyBSRg3UEFA>
    <xmx:pANAXgxn6I_PGIo-EPZYWOVAE9ret7-adsrHsbQLdJM-aaN92QeHYQ>
    <xmx:pANAXkNhs1o0SG7xscw-aBJ3zOtmALE5lLNE8KiQRZL5JKAmqGZ-Wg>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id D1E883280065;
        Sun,  9 Feb 2020 08:05:38 -0500 (EST)
Subject: FAILED: patch "[PATCH] media: pulse8-cec: fix lost cec_transmit_attempt_done() call" failed to apply to 5.5-stable tree
To:     hverkuil-cisco@xs4all.nl, mchehab+huawei@kernel.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:47:40 +0100
Message-ID: <158124886014060@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c4e8f760581b8607a1989acb8925be25d6628760 Mon Sep 17 00:00:00 2001
From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Date: Sat, 7 Dec 2019 23:43:23 +0100
Subject: [PATCH] media: pulse8-cec: fix lost cec_transmit_attempt_done() call

The periodic PING command could interfere with the result of
a CEC transmit, causing a lost cec_transmit_attempt_done()
call.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: <stable@vger.kernel.org>      # for v4.10 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

diff --git a/drivers/media/usb/pulse8-cec/pulse8-cec.c b/drivers/media/usb/pulse8-cec/pulse8-cec.c
index ac88ade94cda..59609556d969 100644
--- a/drivers/media/usb/pulse8-cec/pulse8-cec.c
+++ b/drivers/media/usb/pulse8-cec/pulse8-cec.c
@@ -116,6 +116,7 @@ struct pulse8 {
 	unsigned int vers;
 	struct completion cmd_done;
 	struct work_struct work;
+	u8 work_result;
 	struct delayed_work ping_eeprom_work;
 	struct cec_msg rx_msg;
 	u8 data[DATA_SIZE];
@@ -137,8 +138,10 @@ static void pulse8_irq_work_handler(struct work_struct *work)
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
@@ -172,12 +175,12 @@ static irqreturn_t pulse8_interrupt(struct serio *serio, unsigned char data,
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
@@ -186,14 +189,20 @@ static irqreturn_t pulse8_interrupt(struct serio *serio, unsigned char data,
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

