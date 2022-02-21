Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0D44BE05D
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348036AbiBUJKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:10:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347916AbiBUJJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:09:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C601D0E5;
        Mon, 21 Feb 2022 01:02:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61AD5B80EAC;
        Mon, 21 Feb 2022 09:02:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F26C340EB;
        Mon, 21 Feb 2022 09:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434135;
        bh=yXREIb9dWOXgFIR9B6zbwCvuIuHJttTldcPVXCQZ20k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VKhylwwheiNufO7oZk4us5NKJYdqNH863Nv6L22Mf5VDCoLvi0Y+4ZF6Pet/3QvLn
         al66/k2xhk9nus4GDxFzjvXLFqP18OlzCSez+bBl7SQ0dbKsADRXIw6Pg2o+uATLSP
         TMFzmWpISgiBgYYMbwoOPGWqzEAja9nn1lBpGYP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        Thomas Wagner <thwa1@web.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 007/121] can: isotp: add SF_BROADCAST support for functional addressing
Date:   Mon, 21 Feb 2022 09:48:19 +0100
Message-Id: <20220221084921.398704170@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 921ca574cd382142add8b12d0a7117f495510de5 upstream.

When CAN_ISOTP_SF_BROADCAST is set in the CAN_ISOTP_OPTS flags the CAN_ISOTP
socket is switched into functional addressing mode, where only single frame
(SF) protocol data units can be send on the specified CAN interface and the
given tp.tx_id after bind().

In opposite to normal and extended addressing this socket does not register a
CAN-ID for reception which would be needed for a 1-to-1 ISOTP connection with a
segmented bi-directional data transfer.

Sending SFs on this socket is therefore a TX-only 'broadcast' operation.

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Thomas Wagner <thwa1@web.de>
Link: https://lore.kernel.org/r/20201206144731.4609-1-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/can/isotp.h |    2 -
 net/can/isotp.c                |   50 +++++++++++++++++++++++++++++------------
 2 files changed, 37 insertions(+), 15 deletions(-)

--- a/include/uapi/linux/can/isotp.h
+++ b/include/uapi/linux/can/isotp.h
@@ -135,7 +135,7 @@ struct can_isotp_ll_options {
 #define CAN_ISOTP_FORCE_RXSTMIN	0x100	/* ignore CFs depending on rx stmin */
 #define CAN_ISOTP_RX_EXT_ADDR	0x200	/* different rx extended addressing */
 #define CAN_ISOTP_WAIT_TX_DONE	0x400	/* wait for tx completion */
-
+#define CAN_ISOTP_SF_BROADCAST	0x800	/* 1-to-N functional addressing */
 
 /* default values */
 
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -888,6 +888,16 @@ static int isotp_sendmsg(struct socket *
 		goto err_out_drop;
 	}
 
+	/* take care of a potential SF_DL ESC offset for TX_DL > 8 */
+	off = (so->tx.ll_dl > CAN_MAX_DLEN) ? 1 : 0;
+
+	/* does the given data fit into a single frame for SF_BROADCAST? */
+	if ((so->opt.flags & CAN_ISOTP_SF_BROADCAST) &&
+	    (size > so->tx.ll_dl - SF_PCI_SZ4 - ae - off)) {
+		err = -EINVAL;
+		goto err_out_drop;
+	}
+
 	err = memcpy_from_msg(so->tx.buf, msg, size);
 	if (err < 0)
 		goto err_out_drop;
@@ -915,9 +925,6 @@ static int isotp_sendmsg(struct socket *
 	cf = (struct canfd_frame *)skb->data;
 	skb_put_zero(skb, so->ll.mtu);
 
-	/* take care of a potential SF_DL ESC offset for TX_DL > 8 */
-	off = (so->tx.ll_dl > CAN_MAX_DLEN) ? 1 : 0;
-
 	/* check for single frame transmission depending on TX_DL */
 	if (size <= so->tx.ll_dl - SF_PCI_SZ4 - ae - off) {
 		/* The message size generally fits into a SingleFrame - good.
@@ -1057,7 +1064,7 @@ static int isotp_release(struct socket *
 	lock_sock(sk);
 
 	/* remove current filters & unregister */
-	if (so->bound) {
+	if (so->bound && (!(so->opt.flags & CAN_ISOTP_SF_BROADCAST))) {
 		if (so->ifindex) {
 			struct net_device *dev;
 
@@ -1097,15 +1104,12 @@ static int isotp_bind(struct socket *soc
 	struct net_device *dev;
 	int err = 0;
 	int notify_enetdown = 0;
+	int do_rx_reg = 1;
 
 	if (len < ISOTP_MIN_NAMELEN)
 		return -EINVAL;
 
-	if (addr->can_addr.tp.rx_id == addr->can_addr.tp.tx_id)
-		return -EADDRNOTAVAIL;
-
-	if ((addr->can_addr.tp.rx_id | addr->can_addr.tp.tx_id) &
-	    (CAN_ERR_FLAG | CAN_RTR_FLAG))
+	if (addr->can_addr.tp.tx_id & (CAN_ERR_FLAG | CAN_RTR_FLAG))
 		return -EADDRNOTAVAIL;
 
 	if (!addr->can_ifindex)
@@ -1113,6 +1117,23 @@ static int isotp_bind(struct socket *soc
 
 	lock_sock(sk);
 
+	/* do not register frame reception for functional addressing */
+	if (so->opt.flags & CAN_ISOTP_SF_BROADCAST)
+		do_rx_reg = 0;
+
+	/* do not validate rx address for functional addressing */
+	if (do_rx_reg) {
+		if (addr->can_addr.tp.rx_id == addr->can_addr.tp.tx_id) {
+			err = -EADDRNOTAVAIL;
+			goto out;
+		}
+
+		if (addr->can_addr.tp.rx_id & (CAN_ERR_FLAG | CAN_RTR_FLAG)) {
+			err = -EADDRNOTAVAIL;
+			goto out;
+		}
+	}
+
 	if (so->bound && addr->can_ifindex == so->ifindex &&
 	    addr->can_addr.tp.rx_id == so->rxid &&
 	    addr->can_addr.tp.tx_id == so->txid)
@@ -1138,13 +1159,14 @@ static int isotp_bind(struct socket *soc
 
 	ifindex = dev->ifindex;
 
-	can_rx_register(net, dev, addr->can_addr.tp.rx_id,
-			SINGLE_MASK(addr->can_addr.tp.rx_id), isotp_rcv, sk,
-			"isotp", sk);
+	if (do_rx_reg)
+		can_rx_register(net, dev, addr->can_addr.tp.rx_id,
+				SINGLE_MASK(addr->can_addr.tp.rx_id),
+				isotp_rcv, sk, "isotp", sk);
 
 	dev_put(dev);
 
-	if (so->bound) {
+	if (so->bound && do_rx_reg) {
 		/* unregister old filter */
 		if (so->ifindex) {
 			dev = dev_get_by_index(net, so->ifindex);
@@ -1357,7 +1379,7 @@ static void isotp_notify(struct isotp_so
 	case NETDEV_UNREGISTER:
 		lock_sock(sk);
 		/* remove current filters & unregister */
-		if (so->bound)
+		if (so->bound && (!(so->opt.flags & CAN_ISOTP_SF_BROADCAST)))
 			can_rx_unregister(dev_net(dev), dev, so->rxid,
 					  SINGLE_MASK(so->rxid),
 					  isotp_rcv, sk);


