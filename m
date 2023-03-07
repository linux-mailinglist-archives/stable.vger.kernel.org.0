Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4006AF381
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbjCGTFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233602AbjCGTF2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:05:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208F3D1637
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:50:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD5A8B819CD
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060D1C433EF;
        Tue,  7 Mar 2023 18:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215054;
        bh=0zr1IgT8A0Qnx8nHanHALvhoeyDkWIkS87HmeWMQWh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=03fLqsoef4bqP+tQsHhCMI4XcRsA3hfqvOL4ZptbQOYWPC6qYRAeOaY4KENWFmwZc
         narBQzlO51V/rQfgs3biGObVy6EoV35fw3vYgKwjIl5yAHPQ2GrruMkGqI5/Dipuls
         IShG+ReMEnjqjQ6l0W5UBeKKJ6IYnz7tqgSGAu/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Coffin <alex.coffin@matician.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 137/567] Bluetooth: L2CAP: Fix potential user-after-free
Date:   Tue,  7 Mar 2023 17:57:53 +0100
Message-Id: <20230307165911.829182335@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit df5703348813235874d851934e957c3723d71644 ]

This fixes all instances of which requires to allocate a buffer calling
alloc_skb which may release the chan lock and reacquire later which
makes it possible that the chan is disconnected in the meantime.

Fixes: a6a5568c03c4 ("Bluetooth: Lock the L2CAP channel when sending")
Reported-by: Alexander Coffin <alex.coffin@matician.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 24 ------------------------
 net/bluetooth/l2cap_sock.c |  8 ++++++++
 2 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index e15fcf72a3428..a21e086d69d0e 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -2683,14 +2683,6 @@ int l2cap_chan_send(struct l2cap_chan *chan, struct msghdr *msg, size_t len)
 		if (IS_ERR(skb))
 			return PTR_ERR(skb);
 
-		/* Channel lock is released before requesting new skb and then
-		 * reacquired thus we need to recheck channel state.
-		 */
-		if (chan->state != BT_CONNECTED) {
-			kfree_skb(skb);
-			return -ENOTCONN;
-		}
-
 		l2cap_do_send(chan, skb);
 		return len;
 	}
@@ -2735,14 +2727,6 @@ int l2cap_chan_send(struct l2cap_chan *chan, struct msghdr *msg, size_t len)
 		if (IS_ERR(skb))
 			return PTR_ERR(skb);
 
-		/* Channel lock is released before requesting new skb and then
-		 * reacquired thus we need to recheck channel state.
-		 */
-		if (chan->state != BT_CONNECTED) {
-			kfree_skb(skb);
-			return -ENOTCONN;
-		}
-
 		l2cap_do_send(chan, skb);
 		err = len;
 		break;
@@ -2763,14 +2747,6 @@ int l2cap_chan_send(struct l2cap_chan *chan, struct msghdr *msg, size_t len)
 		 */
 		err = l2cap_segment_sdu(chan, &seg_queue, msg, len);
 
-		/* The channel could have been closed while segmenting,
-		 * check that it is still connected.
-		 */
-		if (chan->state != BT_CONNECTED) {
-			__skb_queue_purge(&seg_queue);
-			err = -ENOTCONN;
-		}
-
 		if (err)
 			break;
 
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index d2c6785205992..a267c9b6bcef4 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1623,6 +1623,14 @@ static struct sk_buff *l2cap_sock_alloc_skb_cb(struct l2cap_chan *chan,
 	if (!skb)
 		return ERR_PTR(err);
 
+	/* Channel lock is released before requesting new skb and then
+	 * reacquired thus we need to recheck channel state.
+	 */
+	if (chan->state != BT_CONNECTED) {
+		kfree_skb(skb);
+		return ERR_PTR(-ENOTCONN);
+	}
+
 	skb->priority = sk->sk_priority;
 
 	bt_cb(skb)->l2cap.chan = chan;
-- 
2.39.2



