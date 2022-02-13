Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978304B3D43
	for <lists+stable@lfdr.de>; Sun, 13 Feb 2022 21:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238135AbiBMUGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Feb 2022 15:06:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238134AbiBMUGE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Feb 2022 15:06:04 -0500
X-Greylist: delayed 177 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 13 Feb 2022 12:05:58 PST
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586D24A912
        for <stable@vger.kernel.org>; Sun, 13 Feb 2022 12:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1644782394;
    s=strato-dkim-0002; d=hartkopp.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=YRI6epwnrXU0zkSe3Ll8GBs9Oizqn1UdDwW521a/NSc=;
    b=IwRBofFvuIpKm7yA4Fkjqfqt11Q8WQaKLnYKvNwb+oL/BdDvk465bmKh6/xyCGOQVy
    Q/yRF0cuo7HhDuhjLoR4s+taraTYdB08vkAokiu9QDwOZJaXN3yCKjGm50dxkCsn4HB4
    WbblSTQpu2ujMk2lfODfOQJt33YauCy4V7Vz/V4L/3/YnyudkzSh3ZUZLnvk6oi8f/Yj
    9ome7+cCciOEtTVDJ44871eRSTSK+v/v7N7iTT/f1Q3hWUQcrZK3F/c0oVgeMGjvL/sd
    UiC+THfDOEdhjIs7zFaR248wQC4tWrbMeze480WaBaPSus3aXxDxQoKlAwAy6tUs/L3U
    lgXg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS/xvEBL7X5sbo3UIh9IyLecSWNadSQUT9H"
X-RZG-CLASS-ID: mo00
Received: from silver.lan
    by smtp.strato.de (RZmta 47.39.0 AUTH)
    with ESMTPSA id L7379cy1DJxrYIh
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 13 Feb 2022 20:59:53 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     gregkh@linuxfoundation.org, mkl@pengutronix.de,
        william.xuanziyang@huawei.com, stable@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH Backport 5.10-stable] can: isotp: fix error path in isotp_sendmsg() to unlock wait queue
Date:   Sun, 13 Feb 2022 20:59:40 +0100
Message-Id: <20220213195940.5146-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit 8375dfac4f68

Commit 43a08c3bdac4 ("can: isotp: isotp_sendmsg(): fix TX buffer concurrent
access in isotp_sendmsg()") introduced a new locking scheme that may render
the userspace application in a locking state when an error is detected.
This issue shows up under high load on simultaneously running isotp channels
with identical configuration which is against the ISO specification and
therefore breaks any reasonable PDU communication anyway.

Fixes: 43a08c3bdac4 ("can: isotp: isotp_sendmsg(): fix TX buffer concurrent access in isotp_sendmsg()")
Link: https://lore.kernel.org/all/20220209073601.25728-1-socketcan@hartkopp.net
Cc: stable@vger.kernel.org
Cc: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 53ce5b6448a5..c75de74001f9 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -872,28 +872,28 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 			goto err_out;
 	}
 
 	if (!size || size > MAX_MSG_LENGTH) {
 		err = -EINVAL;
-		goto err_out;
+		goto err_out_drop;
 	}
 
 	err = memcpy_from_msg(so->tx.buf, msg, size);
 	if (err < 0)
-		goto err_out;
+		goto err_out_drop;
 
 	dev = dev_get_by_index(sock_net(sk), so->ifindex);
 	if (!dev) {
 		err = -ENXIO;
-		goto err_out;
+		goto err_out_drop;
 	}
 
 	skb = sock_alloc_send_skb(sk, so->ll.mtu + sizeof(struct can_skb_priv),
 				  msg->msg_flags & MSG_DONTWAIT, &err);
 	if (!skb) {
 		dev_put(dev);
-		goto err_out;
+		goto err_out_drop;
 	}
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
 	can_skb_prv(skb)->skbcnt = 0;
@@ -954,11 +954,11 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	err = can_send(skb, 1);
 	dev_put(dev);
 	if (err) {
 		pr_notice_once("can-isotp: %s: can_send_ret %d\n",
 			       __func__, err);
-		goto err_out;
+		goto err_out_drop;
 	}
 
 	if (wait_tx_done) {
 		/* wait for complete transmission of current pdu */
 		wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
@@ -967,10 +967,13 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 			return -sk->sk_err;
 	}
 
 	return size;
 
+err_out_drop:
+	/* drop this PDU and unlock a potential wait queue */
+	old_state = ISOTP_IDLE;
 err_out:
 	so->tx.state = old_state;
 	if (so->tx.state == ISOTP_IDLE)
 		wake_up_interruptible(&so->wait);
 
-- 
2.30.2

