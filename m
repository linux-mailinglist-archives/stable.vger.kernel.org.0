Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEA8F156A74
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgBINF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:05:58 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42607 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727654AbgBINF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:05:58 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9CB2A21C24;
        Sun,  9 Feb 2020 08:05:57 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:05:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=5xIbxc
        PqaWGIZdm3gLLuvboodiocNMVKtudEliSkQwo=; b=XNrclSG05IsbDrAqrgxVAR
        VDfdeW1NhU+lIx1owmGOWeHwUcK2OgQwiCLD/vVFXie8t8jgqgppAQtTh/kVcXu3
        kXxN1zZ4lP/gKneSYyIIURufZNDRifD/9Mu4Bpx/3ia9N3262Dx2wwFyuxwZ70HJ
        6tI+PnoKTH2OkiinSzGyZfH31xIZ5z+Nkvb8IrLePBJjKBQexS0W6KfrlKyHZvAn
        cf3XkadpPPFtgRfEA7SmVJNW1juWUZH3ebkKZIgPasIb4w7tVWjld6/TCJYICKXy
        FGtGYXEyXT6ftkS5sm9JSfN/ehl59x+W7JJb006vym8PWoI5AtOEOJdyGV4GLkQA
        ==
X-ME-Sender: <xms:tQNAXjq-A5zxvYUe4PCd_1hPTogKnI_FK9f3pLPd8Ipfzwp3FDfkQg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepvdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:tQNAXndiY-eYDb1VazyuIEuNgK-62b9gBEIcgRoV-jlCcG1Ovb0EdA>
    <xmx:tQNAXvDBJM2qOTJLODfuLKIQ4npgmKD6Z4OaGEInB-nc1m4HVcQpDQ>
    <xmx:tQNAXiRdieYgnOz3Pt2Lv-WkRZLyXG__HPtyVuEDEUamHKjRoVzwbQ>
    <xmx:tQNAXsfPeGTg_59F0ptBBpyAkKmnnYsab-mEiB4xDyCHtr5hD2ye4w>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5AF3530606E9;
        Sun,  9 Feb 2020 08:05:56 -0500 (EST)
Subject: FAILED: patch "[PATCH] media: pulse8-cec: fix lost cec_transmit_attempt_done() call" failed to apply to 5.4-stable tree
To:     hverkuil-cisco@xs4all.nl, mchehab+huawei@kernel.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:47:41 +0100
Message-ID: <15812488611455@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

