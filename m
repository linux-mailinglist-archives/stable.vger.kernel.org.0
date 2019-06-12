Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66D1341BFC
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 08:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730781AbfFLGJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 02:09:22 -0400
Received: from ste-pvt-msa1.bahnhof.se ([213.80.101.70]:26234 "EHLO
        ste-pvt-msa1.bahnhof.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbfFLGJW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 02:09:22 -0400
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jun 2019 02:09:21 EDT
Received: from localhost (localhost [127.0.0.1])
        by ste-pvt-msa1.bahnhof.se (Postfix) with ESMTP id D40373F42A;
        Wed, 12 Jun 2019 08:03:58 +0200 (CEST)
Authentication-Results: ste-pvt-msa1.bahnhof.se;
        dkim=pass (1024-bit key; unprotected) header.d=vmwopensource.org header.i=@vmwopensource.org header.b=EgK3CBR5;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at bahnhof.se
X-Spam-Flag: NO
X-Spam-Score: -3.1
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 tagged_above=-999 required=6.31
        tests=[ALL_TRUSTED=-1, BAYES_00=-1.9, DKIM_SIGNED=0.1,
        DKIM_VALID=-0.1, DKIM_VALID_AU=-0.1, DKIM_VALID_EF=-0.1]
        autolearn=ham autolearn_force=no
Received: from ste-pvt-msa1.bahnhof.se ([127.0.0.1])
        by localhost (ste-pvt-msa1.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id YctaeOzgSsAX; Wed, 12 Jun 2019 08:03:47 +0200 (CEST)
Received: from mail1.shipmail.org (h-205-35.A357.priv.bahnhof.se [155.4.205.35])
        (Authenticated sender: mb878879)
        by ste-pvt-msa1.bahnhof.se (Postfix) with ESMTPA id 438C43F38D;
        Wed, 12 Jun 2019 08:03:47 +0200 (CEST)
Received: from localhost.localdomain.localdomain (h-205-35.A357.priv.bahnhof.se [155.4.205.35])
        by mail1.shipmail.org (Postfix) with ESMTPSA id B7E783619AF;
        Wed, 12 Jun 2019 08:03:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=vmwopensource.org;
        s=mail; t=1560319426;
        bh=YbMIoe9/YFOZVZSi25taho2tJvhJOZwEFR/iguNGPXc=;
        h=From:To:Cc:Subject:Date:From;
        b=EgK3CBR5o3gqfVhe0y8Na5pDpzscQmnuEkMG8K5EbpnMEV7/87HAXHVeT560rCyBZ
         dFhlJgja3Xt+RHVpRUQjpPDVAKBromKI67JwUJyri7fXks0vprQboOdPE74/Y89kPj
         POgCDWwBJ+JzAM1ZOWlfzZ5Wal8K6jcHYNfPK7K4=
From:   =?UTF-8?q?Thomas=20Hellstr=C3=B6m=20=28VMware=29?= 
        <thellstrom@vmwopensource.org>
To:     dri-devel@lists.freedesktop.org
Cc:     Thomas Hellstrom <thellstrom@vmware.com>, stable@vger.kernel.org,
        Deepak Rawat <drawat@vmware.com>
Subject: [PATCH 1/2] drm/vmwgfx: Use the backdoor port if the HB port is not available
Date:   Wed, 12 Jun 2019 08:03:17 +0200
Message-Id: <20190612060318.42151-1-thellstrom@vmwopensource.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Hellstrom <thellstrom@vmware.com>

The HB port may not be available for various reasons. Either it has been
disabled by a config option or by the hypervisor for other reasons.
In that case, make sure we have a backup plan and use the backdoor port
instead with a performance penalty.

Cc: stable@vger.kernel.org
Fixes: 89da76fde68d ("drm/vmwgfx: Add VMWare host messaging capability")
Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Deepak Rawat <drawat@vmware.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c | 146 ++++++++++++++++++++++------
 1 file changed, 117 insertions(+), 29 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c b/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
index 8b9270f31409..e4e09d47c5c0 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
@@ -136,6 +136,114 @@ static int vmw_close_channel(struct rpc_channel *channel)
 	return 0;
 }
 
+/**
+ * vmw_port_hb_out - Send the message payload either through the
+ * high-bandwidth port if available, or through the backdoor otherwise.
+ * @channel: The rpc channel.
+ * @msg: NULL-terminated message.
+ * @hb: Whether the high-bandwidth port is available.
+ *
+ * Return: The port status.
+ */
+static unsigned long vmw_port_hb_out(struct rpc_channel *channel,
+				     const char *msg, bool hb)
+{
+	unsigned long si, di, eax, ebx, ecx, edx;
+	unsigned long msg_len = strlen(msg);
+
+	if (hb) {
+		unsigned long bp = channel->cookie_high;
+
+		si = (uintptr_t) msg;
+		di = channel->cookie_low;
+
+		VMW_PORT_HB_OUT(
+			(MESSAGE_STATUS_SUCCESS << 16) | VMW_PORT_CMD_HB_MSG,
+			msg_len, si, di,
+			VMW_HYPERVISOR_HB_PORT | (channel->channel_id << 16),
+			VMW_HYPERVISOR_MAGIC, bp,
+			eax, ebx, ecx, edx, si, di);
+
+		return ebx;
+	}
+
+	/* HB port not available. Send the message 4 bytes at a time. */
+	ecx = MESSAGE_STATUS_SUCCESS << 16;
+	while (msg_len && (HIGH_WORD(ecx) & MESSAGE_STATUS_SUCCESS)) {
+		unsigned int bytes = min_t(size_t, msg_len, 4);
+		unsigned long word = 0;
+
+		memcpy(&word, msg, bytes);
+		msg_len -= bytes;
+		msg += bytes;
+		si = channel->cookie_high;
+		di = channel->cookie_low;
+
+		VMW_PORT(VMW_PORT_CMD_MSG | (MSG_TYPE_SENDPAYLOAD << 16),
+			 word, si, di,
+			 VMW_HYPERVISOR_PORT | (channel->channel_id << 16),
+			 VMW_HYPERVISOR_MAGIC,
+			 eax, ebx, ecx, edx, si, di);
+	}
+
+	return ecx;
+}
+
+/**
+ * vmw_port_hb_in - Receive the message payload either through the
+ * high-bandwidth port if available, or through the backdoor otherwise.
+ * @channel: The rpc channel.
+ * @reply: Pointer to buffer holding reply.
+ * @reply_len: Length of the reply.
+ * @hb: Whether the high-bandwidth port is available.
+ *
+ * Return: The port status.
+ */
+static unsigned long vmw_port_hb_in(struct rpc_channel *channel, char *reply,
+				    unsigned long reply_len, bool hb)
+{
+	unsigned long si, di, eax, ebx, ecx, edx;
+
+	if (hb) {
+		unsigned long bp = channel->cookie_low;
+
+		si = channel->cookie_high;
+		di = (uintptr_t) reply;
+
+		VMW_PORT_HB_IN(
+			(MESSAGE_STATUS_SUCCESS << 16) | VMW_PORT_CMD_HB_MSG,
+			reply_len, si, di,
+			VMW_HYPERVISOR_HB_PORT | (channel->channel_id << 16),
+			VMW_HYPERVISOR_MAGIC, bp,
+			eax, ebx, ecx, edx, si, di);
+
+		return ebx;
+	}
+
+	/* HB port not available. Retrieve the message 4 bytes at a time. */
+	ecx = MESSAGE_STATUS_SUCCESS << 16;
+	while (reply_len) {
+		unsigned int bytes = min_t(unsigned long, reply_len, 4);
+
+		si = channel->cookie_high;
+		di = channel->cookie_low;
+
+		VMW_PORT(VMW_PORT_CMD_MSG | (MSG_TYPE_RECVPAYLOAD << 16),
+			 MESSAGE_STATUS_SUCCESS, si, di,
+			 VMW_HYPERVISOR_PORT | (channel->channel_id << 16),
+			 VMW_HYPERVISOR_MAGIC,
+			 eax, ebx, ecx, edx, si, di);
+
+		if ((HIGH_WORD(ecx) & MESSAGE_STATUS_SUCCESS) == 0)
+			break;
+
+		memcpy(reply, &ebx, bytes);
+		reply_len -= bytes;
+		reply += bytes;
+	}
+
+	return ecx;
+}
 
 
 /**
@@ -148,11 +256,10 @@ static int vmw_close_channel(struct rpc_channel *channel)
  */
 static int vmw_send_msg(struct rpc_channel *channel, const char *msg)
 {
-	unsigned long eax, ebx, ecx, edx, si, di, bp;
+	unsigned long eax, ebx, ecx, edx, si, di;
 	size_t msg_len = strlen(msg);
 	int retries = 0;
 
-
 	while (retries < RETRIES) {
 		retries++;
 
@@ -166,23 +273,14 @@ static int vmw_send_msg(struct rpc_channel *channel, const char *msg)
 			VMW_HYPERVISOR_MAGIC,
 			eax, ebx, ecx, edx, si, di);
 
-		if ((HIGH_WORD(ecx) & MESSAGE_STATUS_SUCCESS) == 0 ||
-		    (HIGH_WORD(ecx) & MESSAGE_STATUS_HB) == 0) {
-			/* Expected success + high-bandwidth. Give up. */
+		if ((HIGH_WORD(ecx) & MESSAGE_STATUS_SUCCESS) == 0) {
+			/* Expected success. Give up. */
 			return -EINVAL;
 		}
 
 		/* Send msg */
-		si  = (uintptr_t) msg;
-		di  = channel->cookie_low;
-		bp  = channel->cookie_high;
-
-		VMW_PORT_HB_OUT(
-			(MESSAGE_STATUS_SUCCESS << 16) | VMW_PORT_CMD_HB_MSG,
-			msg_len, si, di,
-			VMW_HYPERVISOR_HB_PORT | (channel->channel_id << 16),
-			VMW_HYPERVISOR_MAGIC, bp,
-			eax, ebx, ecx, edx, si, di);
+		ebx = vmw_port_hb_out(channel, msg,
+				      !!(HIGH_WORD(ecx) & MESSAGE_STATUS_HB));
 
 		if ((HIGH_WORD(ebx) & MESSAGE_STATUS_SUCCESS) != 0) {
 			return 0;
@@ -211,7 +309,7 @@ STACK_FRAME_NON_STANDARD(vmw_send_msg);
 static int vmw_recv_msg(struct rpc_channel *channel, void **msg,
 			size_t *msg_len)
 {
-	unsigned long eax, ebx, ecx, edx, si, di, bp;
+	unsigned long eax, ebx, ecx, edx, si, di;
 	char *reply;
 	size_t reply_len;
 	int retries = 0;
@@ -233,8 +331,7 @@ static int vmw_recv_msg(struct rpc_channel *channel, void **msg,
 			VMW_HYPERVISOR_MAGIC,
 			eax, ebx, ecx, edx, si, di);
 
-		if ((HIGH_WORD(ecx) & MESSAGE_STATUS_SUCCESS) == 0 ||
-		    (HIGH_WORD(ecx) & MESSAGE_STATUS_HB) == 0) {
+		if ((HIGH_WORD(ecx) & MESSAGE_STATUS_SUCCESS) == 0) {
 			DRM_ERROR("Failed to get reply size for host message.\n");
 			return -EINVAL;
 		}
@@ -252,17 +349,8 @@ static int vmw_recv_msg(struct rpc_channel *channel, void **msg,
 
 
 		/* Receive buffer */
-		si  = channel->cookie_high;
-		di  = (uintptr_t) reply;
-		bp  = channel->cookie_low;
-
-		VMW_PORT_HB_IN(
-			(MESSAGE_STATUS_SUCCESS << 16) | VMW_PORT_CMD_HB_MSG,
-			reply_len, si, di,
-			VMW_HYPERVISOR_HB_PORT | (channel->channel_id << 16),
-			VMW_HYPERVISOR_MAGIC, bp,
-			eax, ebx, ecx, edx, si, di);
-
+		ebx = vmw_port_hb_in(channel, reply, reply_len,
+				     !!(HIGH_WORD(ecx) & MESSAGE_STATUS_HB));
 		if ((HIGH_WORD(ebx) & MESSAGE_STATUS_SUCCESS) == 0) {
 			kfree(reply);
 
-- 
2.20.1

