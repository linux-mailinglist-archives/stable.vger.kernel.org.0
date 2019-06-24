Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC9B5073F
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbfFXKF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:05:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729819AbfFXKF6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:05:58 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57E90212F5;
        Mon, 24 Jun 2019 10:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370757;
        bh=0soxVsViu3xx6+L+4kDR+OCTU6k4+MLhJZC68ctLQYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xxwCx/yh0qSiS5EfeCAFMk2ShcqlAIIMHIcJbqS8KVZzRM0lBMLEynaT2q/+hz/tM
         pCeABD2MQaaIPC+GFfAzliR72rrrhf2NxrB/oXUke+NTJGswzb4UgahCxcYvx0hEZF
         SydwYXygCEEkZOa01+RqW2UfJOtc/iRHFEDOg8zI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
        Deepak Rawat <drawat@vmware.com>
Subject: [PATCH 4.19 79/90] drm/vmwgfx: Use the backdoor port if the HB port is not available
Date:   Mon, 24 Jun 2019 17:57:09 +0800
Message-Id: <20190624092319.123052565@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Hellstrom <thellstrom@vmware.com>

commit cc0ba0d8624f210995924bb57a8b181ce8976606 upstream.

The HB port may not be available for various reasons. Either it has been
disabled by a config option or by the hypervisor for other reasons.
In that case, make sure we have a backup plan and use the backdoor port
instead with a performance penalty.

Cc: stable@vger.kernel.org
Fixes: 89da76fde68d ("drm/vmwgfx: Add VMWare host messaging capability")
Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Deepak Rawat <drawat@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c |  146 ++++++++++++++++++++++++++++--------
 1 file changed, 117 insertions(+), 29 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
@@ -136,6 +136,114 @@ static int vmw_close_channel(struct rpc_
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
@@ -148,11 +256,10 @@ static int vmw_close_channel(struct rpc_
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
 
@@ -166,23 +273,14 @@ static int vmw_send_msg(struct rpc_chann
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
@@ -233,8 +331,7 @@ static int vmw_recv_msg(struct rpc_chann
 			VMW_HYPERVISOR_MAGIC,
 			eax, ebx, ecx, edx, si, di);
 
-		if ((HIGH_WORD(ecx) & MESSAGE_STATUS_SUCCESS) == 0 ||
-		    (HIGH_WORD(ecx) & MESSAGE_STATUS_HB) == 0) {
+		if ((HIGH_WORD(ecx) & MESSAGE_STATUS_SUCCESS) == 0) {
 			DRM_ERROR("Failed to get reply size for host message.\n");
 			return -EINVAL;
 		}
@@ -252,17 +349,8 @@ static int vmw_recv_msg(struct rpc_chann
 
 
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
 


