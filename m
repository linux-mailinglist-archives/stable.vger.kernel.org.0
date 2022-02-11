Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A05D4B213A
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 10:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235793AbiBKJOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 04:14:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235169AbiBKJOB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 04:14:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE792F01
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 01:14:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92787B828BB
        for <stable@vger.kernel.org>; Fri, 11 Feb 2022 09:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87B3C340E9;
        Fri, 11 Feb 2022 09:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644570838;
        bh=if/7nze3wDf09DTJSKQqW1G5ZGZQDzTWIMkvOKNBqEU=;
        h=Subject:To:Cc:From:Date:From;
        b=mKn/p9yPgnTD08/HZo3TaD3w0LRhg0KiYmiWoXcZ90VUtgk+sTWnDHi24RLpZnlEZ
         idTu7QnBPSTF8zGzU9WgK5238+1HYJAu9FOtwCSCME/Zpw+Y6uWkAeRoM+/9x3tQ7T
         1J8NMfkOUIlkYjEtXVBQN3NJwQRnSWg5PbflGIlY=
Subject: FAILED: patch "[PATCH] can: isotp: fix error path in isotp_sendmsg() to unlock wait" failed to apply to 5.10-stable tree
To:     socketcan@hartkopp.net, mkl@pengutronix.de,
        william.xuanziyang@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 11 Feb 2022 10:13:55 +0100
Message-ID: <1644570835151211@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8375dfac4f683e1b2c5956d919d36aeedad46699 Mon Sep 17 00:00:00 2001
From: Oliver Hartkopp <socketcan@hartkopp.net>
Date: Wed, 9 Feb 2022 08:36:01 +0100
Subject: [PATCH] can: isotp: fix error path in isotp_sendmsg() to unlock wait
 queue

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

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 9149e8d8aefc..d2a430b6a13b 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -887,7 +887,7 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 
 	if (!size || size > MAX_MSG_LENGTH) {
 		err = -EINVAL;
-		goto err_out;
+		goto err_out_drop;
 	}
 
 	/* take care of a potential SF_DL ESC offset for TX_DL > 8 */
@@ -897,24 +897,24 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	if ((so->opt.flags & CAN_ISOTP_SF_BROADCAST) &&
 	    (size > so->tx.ll_dl - SF_PCI_SZ4 - ae - off)) {
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
@@ -976,7 +976,7 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	if (err) {
 		pr_notice_once("can-isotp: %s: can_send_ret %pe\n",
 			       __func__, ERR_PTR(err));
-		goto err_out;
+		goto err_out_drop;
 	}
 
 	if (wait_tx_done) {
@@ -989,6 +989,9 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 
 	return size;
 
+err_out_drop:
+	/* drop this PDU and unlock a potential wait queue */
+	old_state = ISOTP_IDLE;
 err_out:
 	so->tx.state = old_state;
 	if (so->tx.state == ISOTP_IDLE)

