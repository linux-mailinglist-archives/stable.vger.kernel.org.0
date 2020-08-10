Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F4F2409C5
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729033AbgHJPfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:35:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728297AbgHJP1x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:27:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2780F22B47;
        Mon, 10 Aug 2020 15:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073272;
        bh=fcijXXph/Ib20zYb8kxmJy/ligbrXC1nxTA4a9ahIx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JoFf7kwFrdieucOdGIqGGq6AO/W/MWD2JbBVhVwDeUp4kPe72fJh9ijG86rsv94vZ
         ExSmdEpuAvYJcy1PFW8M24/fTLrkJAQhtGoqFvZv6FMc9XLXboxyOsHLQ5yOgzyqkK
         6gJF12GamlCb1o9FZ5Kgch4xR++fVwkdfZVPW1DQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 46/67] Drivers: hv: vmbus: Ignore CHANNELMSG_TL_CONNECT_RESULT(23)
Date:   Mon, 10 Aug 2020 17:21:33 +0200
Message-Id: <20200810151811.708790463@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151809.438685785@linuxfoundation.org>
References: <20200810151809.438685785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

[ Upstream commit ddc9d357b991838c2d975e8d7e4e9db26f37a7ff ]

When a Linux hv_sock app tries to connect to a Service GUID on which no
host app is listening, a recent host (RS3+) sends a
CHANNELMSG_TL_CONNECT_RESULT (23) message to Linux and this triggers such
a warning:

unknown msgtype=23
WARNING: CPU: 2 PID: 0 at drivers/hv/vmbus_drv.c:1031 vmbus_on_msg_dpc

Actually Linux can safely ignore the message because the Linux app's
connect() will time out in 2 seconds: see VSOCK_DEFAULT_CONNECT_TIMEOUT
and vsock_stream_connect(). We don't bother to make use of the message
because: 1) it's only supported on recent hosts; 2) a non-trivial effort
is required to use the message in Linux, but the benefit is small.

So, let's not see the warning by silently ignoring the message.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/channel_mgmt.c | 21 +++++++--------------
 drivers/hv/vmbus_drv.c    |  4 ++++
 include/linux/hyperv.h    |  2 ++
 3 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index c8296d5e74c32..501c43c5851dc 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -1354,6 +1354,8 @@ channel_message_table[CHANNELMSG_COUNT] = {
 	{ CHANNELMSG_19,			0, NULL },
 	{ CHANNELMSG_20,			0, NULL },
 	{ CHANNELMSG_TL_CONNECT_REQUEST,	0, NULL },
+	{ CHANNELMSG_22,			0, NULL },
+	{ CHANNELMSG_TL_CONNECT_RESULT,		0, NULL },
 };
 
 /*
@@ -1365,25 +1367,16 @@ void vmbus_onmessage(void *context)
 {
 	struct hv_message *msg = context;
 	struct vmbus_channel_message_header *hdr;
-	int size;
 
 	hdr = (struct vmbus_channel_message_header *)msg->u.payload;
-	size = msg->header.payload_size;
 
 	trace_vmbus_on_message(hdr);
 
-	if (hdr->msgtype >= CHANNELMSG_COUNT) {
-		pr_err("Received invalid channel message type %d size %d\n",
-			   hdr->msgtype, size);
-		print_hex_dump_bytes("", DUMP_PREFIX_NONE,
-				     (unsigned char *)msg->u.payload, size);
-		return;
-	}
-
-	if (channel_message_table[hdr->msgtype].message_handler)
-		channel_message_table[hdr->msgtype].message_handler(hdr);
-	else
-		pr_err("Unhandled channel message type %d\n", hdr->msgtype);
+	/*
+	 * vmbus_on_msg_dpc() makes sure the hdr->msgtype here can not go
+	 * out of bound and the message_handler pointer can not be NULL.
+	 */
+	channel_message_table[hdr->msgtype].message_handler(hdr);
 }
 
 /*
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 160ff640485be..24c38e44ed3bc 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1073,6 +1073,10 @@ void vmbus_on_msg_dpc(unsigned long data)
 	}
 
 	entry = &channel_message_table[hdr->msgtype];
+
+	if (!entry->message_handler)
+		goto msg_handled;
+
 	if (entry->handler_type	== VMHT_BLOCKING) {
 		ctx = kmalloc(sizeof(*ctx), GFP_ATOMIC);
 		if (ctx == NULL)
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index b4a017093b697..67d9b5a374600 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -423,6 +423,8 @@ enum vmbus_channel_message_type {
 	CHANNELMSG_19				= 19,
 	CHANNELMSG_20				= 20,
 	CHANNELMSG_TL_CONNECT_REQUEST		= 21,
+	CHANNELMSG_22				= 22,
+	CHANNELMSG_TL_CONNECT_RESULT		= 23,
 	CHANNELMSG_COUNT
 };
 
-- 
2.25.1



