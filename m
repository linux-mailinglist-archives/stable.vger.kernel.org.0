Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3BB4B4A98
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346643AbiBNKVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:21:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347081AbiBNKUr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:20:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2864E6E344;
        Mon, 14 Feb 2022 01:55:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6209B80DC8;
        Mon, 14 Feb 2022 09:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB25C340E9;
        Mon, 14 Feb 2022 09:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832526;
        bh=pgZjIPO/xPpvA04zri388RaooRNpi1eK/Oi2BDZbWD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=umV0aFXN1CO0x0+nPVtGr5fwjfWf2zaGmMf4smBmQYl52kQi6jKdw1qM3IwfIlgKU
         FrbxhTJIfUo1e8HuXRBw6K1E4PzDENeC3uJ0+OFYMJpGbDz4ynZRYAkhbZztgb/jTO
         QNsxV3SxNrZiPqFtUGidTpMCrN9SFrOIkwk//G0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.16 011/203] can: isotp: fix error path in isotp_sendmsg() to unlock wait queue
Date:   Mon, 14 Feb 2022 10:24:15 +0100
Message-Id: <20220214092510.602078699@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 8375dfac4f683e1b2c5956d919d36aeedad46699 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -887,7 +887,7 @@ static int isotp_sendmsg(struct socket *
 
 	if (!size || size > MAX_MSG_LENGTH) {
 		err = -EINVAL;
-		goto err_out;
+		goto err_out_drop;
 	}
 
 	/* take care of a potential SF_DL ESC offset for TX_DL > 8 */
@@ -897,24 +897,24 @@ static int isotp_sendmsg(struct socket *
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
@@ -976,7 +976,7 @@ static int isotp_sendmsg(struct socket *
 	if (err) {
 		pr_notice_once("can-isotp: %s: can_send_ret %pe\n",
 			       __func__, ERR_PTR(err));
-		goto err_out;
+		goto err_out_drop;
 	}
 
 	if (wait_tx_done) {
@@ -989,6 +989,9 @@ static int isotp_sendmsg(struct socket *
 
 	return size;
 
+err_out_drop:
+	/* drop this PDU and unlock a potential wait queue */
+	old_state = ISOTP_IDLE;
 err_out:
 	so->tx.state = old_state;
 	if (so->tx.state == ISOTP_IDLE)


