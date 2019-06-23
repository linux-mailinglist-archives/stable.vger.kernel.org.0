Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5F64FE05
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 22:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbfFWUcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 16:32:24 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48345 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726296AbfFWUcY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 16:32:24 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5307F21AF1;
        Sun, 23 Jun 2019 16:32:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 23 Jun 2019 16:32:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=RCt3m0
        x+t7kjWxvCrDRCbWguY2IS9N5I7ekS+PNwNRU=; b=W6a5/lq+M4Te5wngio0ZXR
        SOit17aP8ffGMeERWFkYjQNS+ErAb2bxauFT2MB4ns1bT0E2QJ8ORujxCU+Lm9ie
        0537+mxCLatYZBOL3FEaqC/lHWRMhFJINICyoX6TwfMkxrYc/GxEtezcSPvyFBe8
        +RaNxtFtChgiFGlvtwdr6oR1Yvd89Lk4NpWObOYgIZ6M4xfWMZGMHpQL4pvFJogY
        hokZMc6FIAQ0xYd2wsTpIbDFUK9Eq43u1Bxnn9MHY4816Etn0SVtQPFT0XnpNCEG
        9xOvJyTRCjuNz0TCjpnKMFbh/aSJlp7zP0DqM4D9DfM9FXSO3vcLDrxRF7DqNxUg
        ==
X-ME-Sender: <xms:1-EPXU6HHFMwpYnv4HlccPvy7-Kb5WwU8PNeg_sJDDz1GqislLhFJQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtgdduheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppedujedvrddutdegrddvgeekrdeggeenucfrrghrrghmpehmrghilhhfrh
    homhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:1-EPXcQuCLfz6DYCswgSKTigaz5D14DHE-R53ONMtQj2pnhgJ86ZWg>
    <xmx:1-EPXfsiINrXAqwkxGGHbbE9b3tCwSMdtlsYMsZYIBP9jziluHEaKA>
    <xmx:1-EPXW8G7g2pptb_N4vj2G2lZya-UUtoVtB4Oncm4zGDclBL9c_wpA>
    <xmx:1-EPXYHgopkB6zq9ZHD16XlPRDjkSo7pONDVHeSEFyu0Q8OpNIw4ng>
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4255D380075;
        Sun, 23 Jun 2019 16:32:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/vmwgfx: Use the backdoor port if the HB port is not" failed to apply to 4.9-stable tree
To:     thellstrom@vmware.com, drawat@vmware.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jun 2019 22:31:43 +0200
Message-ID: <1561321903194146@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cc0ba0d8624f210995924bb57a8b181ce8976606 Mon Sep 17 00:00:00 2001
From: Thomas Hellstrom <thellstrom@vmware.com>
Date: Wed, 29 May 2019 08:15:19 +0200
Subject: [PATCH] drm/vmwgfx: Use the backdoor port if the HB port is not
 available

The HB port may not be available for various reasons. Either it has been
disabled by a config option or by the hypervisor for other reasons.
In that case, make sure we have a backup plan and use the backdoor port
instead with a performance penalty.

Cc: stable@vger.kernel.org
Fixes: 89da76fde68d ("drm/vmwgfx: Add VMWare host messaging capability")
Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Deepak Rawat <drawat@vmware.com>

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
 

