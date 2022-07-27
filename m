Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAAC9582BAB
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238289AbiG0QgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238207AbiG0QfR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:35:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3842556B99;
        Wed, 27 Jul 2022 09:27:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1179B821BE;
        Wed, 27 Jul 2022 16:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F1EC433C1;
        Wed, 27 Jul 2022 16:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939263;
        bh=jNEKLf54zl2KwmjY+c4vxV4Lcye4TS306qtU0o1laFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b51HcySbvWj4PA5WKXhPblyTNTajcLVbuanfkP5bnIHtm1NcEDayQnLBhrhDb0Nxd
         /G+Iq7rsqsC3IhYVrG2c1wM7KwJNV08Ogz7zpz6YmY3FvD7z2rJK79SBY79YWe2Qm1
         1/ZIg63cZsVKktACpTFai1wwdSyB8/SXIOMZGbJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 4.19 48/62] Bluetooth: RFCOMM: Replace use of memcpy_from_msg with bt_skb_sendmmsg
Date:   Wed, 27 Jul 2022 18:10:57 +0200
Message-Id: <20220727161006.013557150@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161004.175638564@linuxfoundation.org>
References: <20220727161004.175638564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 81be03e026dc0c16dc1c64e088b2a53b73caa895 upstream.

This makes use of bt_skb_sendmmsg instead using memcpy_from_msg which
is not considered safe to be used when lock_sock is held.

Also make rfcomm_dlc_send handle skb with fragments and queue them all
atomically.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/rfcomm/core.c |   50 +++++++++++++++++++++++++++++++++++++-------
 net/bluetooth/rfcomm/sock.c |   50 ++++++++++----------------------------------
 2 files changed, 55 insertions(+), 45 deletions(-)

--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -552,22 +552,58 @@ struct rfcomm_dlc *rfcomm_dlc_exists(bda
 	return dlc;
 }
 
+static int rfcomm_dlc_send_frag(struct rfcomm_dlc *d, struct sk_buff *frag)
+{
+	int len = frag->len;
+
+	BT_DBG("dlc %p mtu %d len %d", d, d->mtu, len);
+
+	if (len > d->mtu)
+		return -EINVAL;
+
+	rfcomm_make_uih(frag, d->addr);
+	__skb_queue_tail(&d->tx_queue, frag);
+
+	return len;
+}
+
 int rfcomm_dlc_send(struct rfcomm_dlc *d, struct sk_buff *skb)
 {
-	int len = skb->len;
+	unsigned long flags;
+	struct sk_buff *frag, *next;
+	int len;
 
 	if (d->state != BT_CONNECTED)
 		return -ENOTCONN;
 
-	BT_DBG("dlc %p mtu %d len %d", d, d->mtu, len);
+	frag = skb_shinfo(skb)->frag_list;
+	skb_shinfo(skb)->frag_list = NULL;
 
-	if (len > d->mtu)
-		return -EINVAL;
+	/* Queue all fragments atomically. */
+	spin_lock_irqsave(&d->tx_queue.lock, flags);
+
+	len = rfcomm_dlc_send_frag(d, skb);
+	if (len < 0 || !frag)
+		goto unlock;
+
+	for (; frag; frag = next) {
+		int ret;
+
+		next = frag->next;
+
+		ret = rfcomm_dlc_send_frag(d, frag);
+		if (ret < 0) {
+			kfree_skb(frag);
+			goto unlock;
+		}
+
+		len += ret;
+	}
 
-	rfcomm_make_uih(skb, d->addr);
-	skb_queue_tail(&d->tx_queue, skb);
+unlock:
+	spin_unlock_irqrestore(&d->tx_queue.lock, flags);
 
-	if (!test_bit(RFCOMM_TX_THROTTLED, &d->flags))
+	if (len > 0 && !test_bit(RFCOMM_TX_THROTTLED, &d->flags))
 		rfcomm_schedule();
 	return len;
 }
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -578,47 +578,21 @@ static int rfcomm_sock_sendmsg(struct so
 	lock_sock(sk);
 
 	sent = bt_sock_wait_ready(sk, msg->msg_flags);
-	if (sent)
-		goto done;
-
-	while (len) {
-		size_t size = min_t(size_t, len, d->mtu);
-		int err;
-
-		skb = sock_alloc_send_skb(sk, size + RFCOMM_SKB_RESERVE,
-				msg->msg_flags & MSG_DONTWAIT, &err);
-		if (!skb) {
-			if (sent == 0)
-				sent = err;
-			break;
-		}
-		skb_reserve(skb, RFCOMM_SKB_HEAD_RESERVE);
-
-		err = memcpy_from_msg(skb_put(skb, size), msg, size);
-		if (err) {
-			kfree_skb(skb);
-			if (sent == 0)
-				sent = err;
-			break;
-		}
-
-		skb->priority = sk->sk_priority;
-
-		err = rfcomm_dlc_send(d, skb);
-		if (err < 0) {
-			kfree_skb(skb);
-			if (sent == 0)
-				sent = err;
-			break;
-		}
-
-		sent += size;
-		len  -= size;
-	}
 
-done:
 	release_sock(sk);
 
+	if (sent)
+		return sent;
+
+	skb = bt_skb_sendmmsg(sk, msg, len, d->mtu, RFCOMM_SKB_HEAD_RESERVE,
+			      RFCOMM_SKB_TAIL_RESERVE);
+	if (IS_ERR_OR_NULL(skb))
+		return PTR_ERR(skb);
+
+	sent = rfcomm_dlc_send(d, skb);
+	if (sent < 0)
+		kfree_skb(skb);
+
 	return sent;
 }
 


