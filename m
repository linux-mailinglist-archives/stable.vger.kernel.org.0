Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9A68A243C
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730067AbfH2SR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:17:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730063AbfH2SR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:17:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D0F92189D;
        Thu, 29 Aug 2019 18:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102647;
        bh=GMoAzwSR+XjclkVLdBs2F+bB87N7Ju4xv4DHWUbv9HM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oTyiH3hVH3jrjsW8PjtXc9gbURu52B8hQJX6vcrkn7rCquPOv39xhvQkUJLLD4kZC
         h/sobMROfGGj0DEBXXf+Ls6NnH5TD9lDKXo3L/gNY4D4is4cyzSXDUmg/68oeW9pel
         Gn+knJM0nUmQFV3F8ncHOJ6qQ8hoPN94kpPajKqk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dexuan Cui <decui@microsoft.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-hyperv@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 21/27] Input: hyperv-keyboard: Use in-place iterator API in the channel callback
Date:   Thu, 29 Aug 2019 14:16:47 -0400
Message-Id: <20190829181655.8741-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181655.8741-1-sashal@kernel.org>
References: <20190829181655.8741-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

[ Upstream commit d09bc83640d524b8467a660db7b1d15e6562a1de ]

Simplify the ring buffer handling with the in-place API.

Also avoid the dynamic allocation and the memory leak in the channel
callback function.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/hyperv-keyboard.c | 35 +++++----------------------
 1 file changed, 6 insertions(+), 29 deletions(-)

diff --git a/drivers/input/serio/hyperv-keyboard.c b/drivers/input/serio/hyperv-keyboard.c
index 55288a026e4e2..c137ffa6fdec8 100644
--- a/drivers/input/serio/hyperv-keyboard.c
+++ b/drivers/input/serio/hyperv-keyboard.c
@@ -245,40 +245,17 @@ static void hv_kbd_handle_received_packet(struct hv_device *hv_dev,
 
 static void hv_kbd_on_channel_callback(void *context)
 {
+	struct vmpacket_descriptor *desc;
 	struct hv_device *hv_dev = context;
-	void *buffer;
-	int bufferlen = 0x100; /* Start with sensible size */
 	u32 bytes_recvd;
 	u64 req_id;
-	int error;
 
-	buffer = kmalloc(bufferlen, GFP_ATOMIC);
-	if (!buffer)
-		return;
-
-	while (1) {
-		error = vmbus_recvpacket_raw(hv_dev->channel, buffer, bufferlen,
-					     &bytes_recvd, &req_id);
-		switch (error) {
-		case 0:
-			if (bytes_recvd == 0) {
-				kfree(buffer);
-				return;
-			}
-
-			hv_kbd_handle_received_packet(hv_dev, buffer,
-						      bytes_recvd, req_id);
-			break;
+	foreach_vmbus_pkt(desc, hv_dev->channel) {
+		bytes_recvd = desc->len8 * 8;
+		req_id = desc->trans_id;
 
-		case -ENOBUFS:
-			kfree(buffer);
-			/* Handle large packet */
-			bufferlen = bytes_recvd;
-			buffer = kmalloc(bytes_recvd, GFP_ATOMIC);
-			if (!buffer)
-				return;
-			break;
-		}
+		hv_kbd_handle_received_packet(hv_dev, desc, bytes_recvd,
+					      req_id);
 	}
 }
 
-- 
2.20.1

