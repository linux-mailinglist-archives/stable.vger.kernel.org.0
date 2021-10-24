Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA384388FE
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 15:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbhJXNQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 09:16:31 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.161]:36121 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbhJXNQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Oct 2021 09:16:30 -0400
X-Greylist: delayed 349 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Oct 2021 09:16:30 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1635080885;
    s=strato-dkim-0002; d=hartkopp.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=HluJTrgAQZ1xLvImtMRoFuitI9oVA7hWg7hh5gKk0mU=;
    b=CXs2AwNzqmN90Jo65NssxLDXAQhNhFXEe4KMbBUxZ5LWEhxZEeyILrWNZE7cCKpAno
    LgDnzkmmTsfzf51rvjjdCaXOooqr+jxrnlMcLDIgD7dDjD0fCxeUUk9tqgFCowvmW5oM
    VwczuugMjUjOKR56mk2wB5H1lPXAGNf+Nl8Lk2EpYVhSo3dWJZudBRWN7WczRQUXs9Sm
    mF0py0wW+NUow/Eve8u/vytJCLokDKtZCHTli4dBxmXibEV6aTfnxiDfcrf4MsgMmDYc
    qoM9ONYUWXTvS+PoCwifnnC6Lj16bBuJPfvsQJl4KLhxQ1kRLiKUjQN89g6VXecJkd34
    ZOHQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS/xvEBL7X5sbo3UIh9IyLecSWJafUvprl4"
X-RZG-CLASS-ID: mo00
Received: from silver.lan
    by smtp.strato.de (RZmta 47.33.8 AUTH)
    with ESMTPSA id 900f80x9OD85WF7
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 24 Oct 2021 15:08:05 +0200 (CEST)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     gregkh@linuxfoundation.org
Cc:     linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        stable@vger.kernel.org,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10-stable] can: isotp: isotp_sendmsg(): fix TX buffer concurrent access in isotp_sendmsg()
Date:   Sun, 24 Oct 2021 15:07:18 +0200
Message-Id: <20211024130718.64492-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 43a08c3bdac4cb42eff8fe5e2278bffe0c5c3daa upstream.

When isotp_sendmsg() concurrent, tx.state of all TX processes can be
ISOTP_IDLE. The conditions so->tx.state != ISOTP_IDLE and
wq_has_sleeper(&so->wait) can not protect TX buffer from being
accessed by multiple TX processes.

We can use cmpxchg() to try to modify tx.state to ISOTP_SENDING firstly.
If the modification of the previous process succeed, the later process
must wait tx.state to ISOTP_IDLE firstly. Thus, we can ensure TX buffer
is accessed by only one process at the same time. And we should also
restore the original tx.state at the subsequent error processes.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Link: https://lore.kernel.org/all/c2517874fbdf4188585cf9ddf67a8fa74d5dbde5.1633764159.git.william.xuanziyang@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 347cc732736e..1d1710503b8d 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -119,11 +119,11 @@ enum {
 };
 
 struct tpcon {
 	int idx;
 	int len;
-	u8 state;
+	u32 state;
 	u8 bs;
 	u8 sn;
 	u8 ll_dl;
 	u8 buf[MAX_MSG_LENGTH + 1];
 };
@@ -844,10 +844,11 @@ static enum hrtimer_restart isotp_tx_timer_handler(struct hrtimer *hrtimer)
 
 static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 {
 	struct sock *sk = sock->sk;
 	struct isotp_sock *so = isotp_sk(sk);
+	u32 old_state = so->tx.state;
 	struct sk_buff *skb;
 	struct net_device *dev;
 	struct canfd_frame *cf;
 	int ae = (so->opt.flags & CAN_ISOTP_EXTEND_ADDR) ? 1 : 0;
 	int wait_tx_done = (so->opt.flags & CAN_ISOTP_WAIT_TX_DONE) ? 1 : 0;
@@ -856,43 +857,49 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 
 	if (!so->bound)
 		return -EADDRNOTAVAIL;
 
 	/* we do not support multiple buffers - for now */
-	if (so->tx.state != ISOTP_IDLE || wq_has_sleeper(&so->wait)) {
-		if (msg->msg_flags & MSG_DONTWAIT)
-			return -EAGAIN;
+	if (cmpxchg(&so->tx.state, ISOTP_IDLE, ISOTP_SENDING) != ISOTP_IDLE ||
+	    wq_has_sleeper(&so->wait)) {
+		if (msg->msg_flags & MSG_DONTWAIT) {
+			err = -EAGAIN;
+			goto err_out;
+		}
 
 		/* wait for complete transmission of current pdu */
 		err = wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
 		if (err)
-			return err;
+			goto err_out;
 	}
 
-	if (!size || size > MAX_MSG_LENGTH)
-		return -EINVAL;
+	if (!size || size > MAX_MSG_LENGTH) {
+		err = -EINVAL;
+		goto err_out;
+	}
 
 	err = memcpy_from_msg(so->tx.buf, msg, size);
 	if (err < 0)
-		return err;
+		goto err_out;
 
 	dev = dev_get_by_index(sock_net(sk), so->ifindex);
-	if (!dev)
-		return -ENXIO;
+	if (!dev) {
+		err = -ENXIO;
+		goto err_out;
+	}
 
 	skb = sock_alloc_send_skb(sk, so->ll.mtu + sizeof(struct can_skb_priv),
 				  msg->msg_flags & MSG_DONTWAIT, &err);
 	if (!skb) {
 		dev_put(dev);
-		return err;
+		goto err_out;
 	}
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
 	can_skb_prv(skb)->skbcnt = 0;
 
-	so->tx.state = ISOTP_SENDING;
 	so->tx.len = size;
 	so->tx.idx = 0;
 
 	cf = (struct canfd_frame *)skb->data;
 	skb_put_zero(skb, so->ll.mtu);
@@ -947,19 +954,26 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	err = can_send(skb, 1);
 	dev_put(dev);
 	if (err) {
 		pr_notice_once("can-isotp: %s: can_send_ret %d\n",
 			       __func__, err);
-		return err;
+		goto err_out;
 	}
 
 	if (wait_tx_done) {
 		/* wait for complete transmission of current pdu */
 		wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
 	}
 
 	return size;
+
+err_out:
+	so->tx.state = old_state;
+	if (so->tx.state == ISOTP_IDLE)
+		wake_up_interruptible(&so->wait);
+
+	return err;
 }
 
 static int isotp_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 			 int flags)
 {
-- 
2.30.2

