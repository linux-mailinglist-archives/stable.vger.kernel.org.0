Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3235BAAED
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbiIPKMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbiIPKLy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:11:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5880126C1;
        Fri, 16 Sep 2022 03:09:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2F2EB82503;
        Fri, 16 Sep 2022 10:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE63C433C1;
        Fri, 16 Sep 2022 10:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663322967;
        bh=bc2OW2J+0cXow/XWPZkMpI2LiaUOa6IBtOe2gC9WYqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SIeDwg0qQ92vOQ88zl2XrrlgKpGmuKT62WIo0R6Naq1taMl2afWcdhVweF7dKrD6L
         NuoerkIJOVChLzEm1HnM30FIENcUxDTrLCzzYg1uaNGPaPeKEYQTPnKcZrr7wTgo5u
         WRBRgffefZetA9g4COQgLcCrxKsMnWL+wE/bBbd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Even Xu <even.xu@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@intel.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/14] hid: intel-ish-hid: ishtp: Fix ishtp client sending disordered message
Date:   Fri, 16 Sep 2022 12:08:10 +0200
Message-Id: <20220916100443.298475397@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100443.123226979@linuxfoundation.org>
References: <20220916100443.123226979@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Even Xu <even.xu@intel.com>

[ Upstream commit e1fa076706209cc447d7a2abd0843a18277e5ef7 ]

There is a timing issue captured during ishtp client sending stress tests.
It was observed during stress tests that ISH firmware is getting out of
ordered messages. This is a rare scenario as the current set of ISH client
drivers don't send much data to firmware. But this may not be the case
going forward.

When message size is bigger than IPC MTU, ishtp splits the message into
fragments and uses serialized async method to send message fragments.
The call stack:
ishtp_cl_send_msg_ipc->ipc_tx_callback(first fregment)->
ishtp_send_msg(with callback)->write_ipc_to_queue->
write_ipc_from_queue->callback->ipc_tx_callback(next fregment)......

When an ipc write complete interrupt is received, driver also calls
write_ipc_from_queue->ipc_tx_callback in ISR to start sending of next fragment.

Through ipc_tx_callback uses spin_lock to protect message splitting, as the
serialized sending method will call back to ipc_tx_callback again, so it doesn't
put sending under spin_lock, it causes driver cannot guarantee all fragments
be sent in order.

Considering this scenario:
ipc_tx_callback just finished a fragment splitting, and not call ishtp_send_msg
yet, there is a write complete interrupt happens, then ISR->write_ipc_from_queue
->ipc_tx_callback->ishtp_send_msg->write_ipc_to_queue......

Because ISR has higher exec priority than normal thread, this causes the new
fragment be sent out before previous fragment. This disordered message causes
invalid message to firmware.

The solution is, to send fragments synchronously:
Use ishtp_write_message writing fragments into tx queue directly one by one,
instead of ishtp_send_msg only writing one fragment with completion callback.
As no completion callback be used, so change ipc_tx_callback to ipc_tx_send.

Signed-off-by: Even Xu <even.xu@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ishtp/client.c | 68 ++++++++++++++----------
 1 file changed, 39 insertions(+), 29 deletions(-)

diff --git a/drivers/hid/intel-ish-hid/ishtp/client.c b/drivers/hid/intel-ish-hid/ishtp/client.c
index 1cc157126fce7..c0d69303e3b09 100644
--- a/drivers/hid/intel-ish-hid/ishtp/client.c
+++ b/drivers/hid/intel-ish-hid/ishtp/client.c
@@ -626,13 +626,14 @@ static void ishtp_cl_read_complete(struct ishtp_cl_rb *rb)
 }
 
 /**
- * ipc_tx_callback() - IPC tx callback function
+ * ipc_tx_send() - IPC tx send function
  * @prm: Pointer to client device instance
  *
- * Send message over IPC either first time or on callback on previous message
- * completion
+ * Send message over IPC. Message will be split into fragments
+ * if message size is bigger than IPC FIFO size, and all
+ * fragments will be sent one by one.
  */
-static void ipc_tx_callback(void *prm)
+static void ipc_tx_send(void *prm)
 {
 	struct ishtp_cl	*cl = prm;
 	struct ishtp_cl_tx_ring	*cl_msg;
@@ -677,32 +678,41 @@ static void ipc_tx_callback(void *prm)
 			    list);
 	rem = cl_msg->send_buf.size - cl->tx_offs;
 
-	ishtp_hdr.host_addr = cl->host_client_id;
-	ishtp_hdr.fw_addr = cl->fw_client_id;
-	ishtp_hdr.reserved = 0;
-	pmsg = cl_msg->send_buf.data + cl->tx_offs;
+	while (rem > 0) {
+		ishtp_hdr.host_addr = cl->host_client_id;
+		ishtp_hdr.fw_addr = cl->fw_client_id;
+		ishtp_hdr.reserved = 0;
+		pmsg = cl_msg->send_buf.data + cl->tx_offs;
+
+		if (rem <= dev->mtu) {
+			/* Last fragment or only one packet */
+			ishtp_hdr.length = rem;
+			ishtp_hdr.msg_complete = 1;
+			/* Submit to IPC queue with no callback */
+			ishtp_write_message(dev, &ishtp_hdr, pmsg);
+			cl->tx_offs = 0;
+			cl->sending = 0;
 
-	if (rem <= dev->mtu) {
-		ishtp_hdr.length = rem;
-		ishtp_hdr.msg_complete = 1;
-		cl->sending = 0;
-		list_del_init(&cl_msg->list);	/* Must be before write */
-		spin_unlock_irqrestore(&cl->tx_list_spinlock, tx_flags);
-		/* Submit to IPC queue with no callback */
-		ishtp_write_message(dev, &ishtp_hdr, pmsg);
-		spin_lock_irqsave(&cl->tx_free_list_spinlock, tx_free_flags);
-		list_add_tail(&cl_msg->list, &cl->tx_free_list.list);
-		++cl->tx_ring_free_size;
-		spin_unlock_irqrestore(&cl->tx_free_list_spinlock,
-			tx_free_flags);
-	} else {
-		/* Send IPC fragment */
-		spin_unlock_irqrestore(&cl->tx_list_spinlock, tx_flags);
-		cl->tx_offs += dev->mtu;
-		ishtp_hdr.length = dev->mtu;
-		ishtp_hdr.msg_complete = 0;
-		ishtp_send_msg(dev, &ishtp_hdr, pmsg, ipc_tx_callback, cl);
+			break;
+		} else {
+			/* Send ipc fragment */
+			ishtp_hdr.length = dev->mtu;
+			ishtp_hdr.msg_complete = 0;
+			/* All fregments submitted to IPC queue with no callback */
+			ishtp_write_message(dev, &ishtp_hdr, pmsg);
+			cl->tx_offs += dev->mtu;
+			rem = cl_msg->send_buf.size - cl->tx_offs;
+		}
 	}
+
+	list_del_init(&cl_msg->list);
+	spin_unlock_irqrestore(&cl->tx_list_spinlock, tx_flags);
+
+	spin_lock_irqsave(&cl->tx_free_list_spinlock, tx_free_flags);
+	list_add_tail(&cl_msg->list, &cl->tx_free_list.list);
+	++cl->tx_ring_free_size;
+	spin_unlock_irqrestore(&cl->tx_free_list_spinlock,
+		tx_free_flags);
 }
 
 /**
@@ -720,7 +730,7 @@ static void ishtp_cl_send_msg_ipc(struct ishtp_device *dev,
 		return;
 
 	cl->tx_offs = 0;
-	ipc_tx_callback(cl);
+	ipc_tx_send(cl);
 	++cl->send_msg_cnt_ipc;
 }
 
-- 
2.35.1



