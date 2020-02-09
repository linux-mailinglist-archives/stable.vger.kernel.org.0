Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51F35156A78
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbgBINGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:06:45 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:34379 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727473AbgBINGo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:06:44 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 47FCA21B24;
        Sun,  9 Feb 2020 08:06:44 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:06:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=hW72Ia
        h/IQ4UJ+SowUMa5TLGS3ARGzxTZ1E5qrd6BwU=; b=IO/liTKPliPNWCmBTmvDrI
        XXUlUkejYT8kxonbX2xDl+xf0qPeZWZGaItlqz0tjj+CHjGerXgaFFUcV7erJr0E
        0tGX0NV2k5xq2Bpw+kzXmSHHBy+H3GLdxeiAn6v9IrVCYDwieZT4acTQ3tKZVBR7
        VLrLnW3lix4r3rsudQqP1uo0KRIcY8YkKkt5RTqWype7wpFdfr/sklI/cI18nBWS
        UEjt8qCArr5vNPC/83hkNlpPHPoJzR7mJsuF5wyOCOS2dB9LboPl61y9ZXRGhEhy
        23+ixEboB9gwHqsL8EeEXSJDdrSOZeJyi9HLCAcrZmnV8EKqiBEjE6jv0RA6+KVA
        ==
X-ME-Sender: <xms:5ANAXoiQKoHlUEgPGdUMtKo2BuUbSal0dLcGClC8HetREMNy_FHQzg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepieenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:5ANAXj4c5VjIrjaXnrN63SnfaENHepdEPMsS5l9_qJZ-F9nLiyJiww>
    <xmx:5ANAXg5aiF9PlnuGvptNs6Xz6JEzgv4bFXVbbDtk_8AUKowRCDN1cA>
    <xmx:5ANAXrHBm4hytviV76WQrLRyGj1UZ7cpCXavhYsunfeQGl8tEL5YQA>
    <xmx:5ANAXty1TgPt2iWB7YnbOS196x5JfQdxz40w6JNeGJjPtv2s_fgNig>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5BB863060701;
        Sun,  9 Feb 2020 08:06:42 -0500 (EST)
Subject: FAILED: patch "[PATCH] media: cec: check 'transmit_in_progress', not 'transmitting'" failed to apply to 5.5-stable tree
To:     hverkuil-cisco@xs4all.nl, mchehab+huawei@kernel.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:48:05 +0100
Message-ID: <158124888510314@kroah.com>
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

From d51224b73d18d207912f15ad4eb7a4b456682729 Mon Sep 17 00:00:00 2001
From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Date: Wed, 11 Dec 2019 12:47:57 +0100
Subject: [PATCH] media: cec: check 'transmit_in_progress', not 'transmitting'

Currently wait_event_interruptible_timeout is called in cec_thread_func()
when adap->transmitting is set. But if the adapter is unconfigured
while transmitting, then adap->transmitting is set to NULL. But the
hardware is still actually transmitting the message, and that's
indicated by adap->transmit_in_progress and we should wait until that
is finished or times out before transmitting new messages.

As the original commit says: adap->transmitting is the userspace view,
adap->transmit_in_progress reflects the hardware state.

However, if adap->transmitting is NULL and adap->transmit_in_progress
is true, then wait_event_interruptible is called (no timeout), which
can get stuck indefinitely if the CEC driver is flaky and never marks
the transmit-in-progress as 'done'.

So test against transmit_in_progress when deciding whether to use
the timeout variant or not, instead of testing against adap->transmitting.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 32804fcb612b ("media: cec: keep track of outstanding transmits")
Cc: <stable@vger.kernel.org>      # for v4.19 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 1060e633b623..6c95dc471d4c 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -465,7 +465,7 @@ int cec_thread_func(void *_adap)
 		bool timeout = false;
 		u8 attempts;
 
-		if (adap->transmitting) {
+		if (adap->transmit_in_progress) {
 			int err;
 
 			/*
@@ -500,7 +500,7 @@ int cec_thread_func(void *_adap)
 			goto unlock;
 		}
 
-		if (adap->transmitting && timeout) {
+		if (adap->transmit_in_progress && timeout) {
 			/*
 			 * If we timeout, then log that. Normally this does
 			 * not happen and it is an indication of a faulty CEC
@@ -509,14 +509,18 @@ int cec_thread_func(void *_adap)
 			 * so much traffic on the bus that the adapter was
 			 * unable to transmit for CEC_XFER_TIMEOUT_MS (2.1s).
 			 */
-			pr_warn("cec-%s: message %*ph timed out\n", adap->name,
-				adap->transmitting->msg.len,
-				adap->transmitting->msg.msg);
+			if (adap->transmitting) {
+				pr_warn("cec-%s: message %*ph timed out\n", adap->name,
+					adap->transmitting->msg.len,
+					adap->transmitting->msg.msg);
+				/* Just give up on this. */
+				cec_data_cancel(adap->transmitting,
+						CEC_TX_STATUS_TIMEOUT);
+			} else {
+				pr_warn("cec-%s: transmit timed out\n", adap->name);
+			}
 			adap->transmit_in_progress = false;
 			adap->tx_timeouts++;
-			/* Just give up on this. */
-			cec_data_cancel(adap->transmitting,
-					CEC_TX_STATUS_TIMEOUT);
 			goto unlock;
 		}
 

