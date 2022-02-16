Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30B0D4B811F
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 08:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiBPHNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 02:13:24 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:40348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiBPHNW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 02:13:22 -0500
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E49DA41B1
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 23:13:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1644993151;
    s=strato-dkim-0002; d=hartkopp.net;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=Yw44AETHr1cA85Pdp4DVNrbEVYyJ2DcIQvFytrlyT8o=;
    b=gu2GFbObVBCVZ1IsEZ8uyhr9uDReMY58MPo4CKx6A8biw3qCJs8SVFpYk0fuDNKt/U
    cEhq+HEDCCBazZrU20kkDx8YFXSdP0jZfhrV6n31pZ/6rQiJYna0j/XPHSU3ty+pMcnS
    kRmEVv40jOjwfnbPQcyHFdhYIIWXDTh3wDrN1mxGWv/YkLsPq3sBautwg0ju9FFPIO8A
    od3vnjzICKGNCZ4VebgcDh+v4zTDf0IjK+zisj1YdI/htN4an9i3CSAZSfUdnFsnhc4A
    GBjGl5QZDrDfnpsrbPyFFmcN6Ehy3eci0eLMuLggFtlRMFCQIGNg7cOiTFZyCYhqYsH+
    eRFw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS/xvEBL7X5sbo3UIh9IyLecSWJafUvprl4"
X-RZG-CLASS-ID: mo00
Received: from silver.lan
    by smtp.strato.de (RZmta 47.39.0 AUTH)
    with ESMTPSA id L7379cy1G6WVfoj
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 16 Feb 2022 07:32:31 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Thomas Wagner <thwa1@web.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [BACKPORT stable Linux-5.10.y 2/2] can: isotp: add SF_BROADCAST support for functional addressing
Date:   Wed, 16 Feb 2022 07:31:37 +0100
Message-Id: <20220216063137.2023-2-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220216063137.2023-1-socketcan@hartkopp.net>
References: <20220216063137.2023-1-socketcan@hartkopp.net>
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

Upstream commit 921ca574cd382142add8b12d0a7117f495510de5

The patch was intended for 5.10 but missed the merge window by some days.
This missing patch continously breaks the backport of stable fixes and is
the only missing feature of upstream isotp in Linux 5.10 e.g. for RasPi.

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
---
 include/uapi/linux/can/isotp.h |  2 +-
 net/can/isotp.c                | 50 ++++++++++++++++++++++++----------
 2 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/include/uapi/linux/can/isotp.h b/include/uapi/linux/can/isotp.h
index 7793b26aa154..c55935b64ccc 100644
--- a/include/uapi/linux/can/isotp.h
+++ b/include/uapi/linux/can/isotp.h
@@ -133,11 +133,11 @@ struct can_isotp_ll_options {
 #define CAN_ISOTP_HALF_DUPLEX	0x040	/* half duplex error state handling */
 #define CAN_ISOTP_FORCE_TXSTMIN	0x080	/* ignore stmin from received FC */
 #define CAN_ISOTP_FORCE_RXSTMIN	0x100	/* ignore CFs depending on rx stmin */
 #define CAN_ISOTP_RX_EXT_ADDR	0x200	/* different rx extended addressing */
 #define CAN_ISOTP_WAIT_TX_DONE	0x400	/* wait for tx completion */
-
+#define CAN_ISOTP_SF_BROADCAST	0x800	/* 1-to-N functional addressing */
 
 /* default values */
 
 #define CAN_ISOTP_DEFAULT_FLAGS		0
 #define CAN_ISOTP_DEFAULT_EXT_ADDRESS	0x00
diff --git a/net/can/isotp.c b/net/can/isotp.c
index 3f11d2b314b6..d0581dc6a65f 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -886,10 +886,20 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	if (!size || size > MAX_MSG_LENGTH) {
 		err = -EINVAL;
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
 
 	dev = dev_get_by_index(sock_net(sk), so->ifindex);
@@ -913,13 +923,10 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	so->tx.idx = 0;
 
 	cf = (struct canfd_frame *)skb->data;
 	skb_put_zero(skb, so->ll.mtu);
 
-	/* take care of a potential SF_DL ESC offset for TX_DL > 8 */
-	off = (so->tx.ll_dl > CAN_MAX_DLEN) ? 1 : 0;
-
 	/* check for single frame transmission depending on TX_DL */
 	if (size <= so->tx.ll_dl - SF_PCI_SZ4 - ae - off) {
 		/* The message size generally fits into a SingleFrame - good.
 		 *
 		 * SF_DL ESC offset optimization:
@@ -1055,11 +1062,11 @@ static int isotp_release(struct socket *sock)
 	spin_unlock(&isotp_notifier_lock);
 
 	lock_sock(sk);
 
 	/* remove current filters & unregister */
-	if (so->bound) {
+	if (so->bound && (!(so->opt.flags & CAN_ISOTP_SF_BROADCAST))) {
 		if (so->ifindex) {
 			struct net_device *dev;
 
 			dev = dev_get_by_index(net, so->ifindex);
 			if (dev) {
@@ -1095,26 +1102,40 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	struct net *net = sock_net(sk);
 	int ifindex;
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
 		return -ENODEV;
 
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
 		goto out;
 
@@ -1136,17 +1157,18 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	if (!(dev->flags & IFF_UP))
 		notify_enetdown = 1;
 
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
 			if (dev) {
 				can_rx_unregister(net, dev, so->rxid,
@@ -1355,11 +1377,11 @@ static void isotp_notify(struct isotp_sock *so, unsigned long msg,
 
 	switch (msg) {
 	case NETDEV_UNREGISTER:
 		lock_sock(sk);
 		/* remove current filters & unregister */
-		if (so->bound)
+		if (so->bound && (!(so->opt.flags & CAN_ISOTP_SF_BROADCAST)))
 			can_rx_unregister(dev_net(dev), dev, so->rxid,
 					  SINGLE_MASK(so->rxid),
 					  isotp_rcv, sk);
 
 		so->ifindex = 0;
-- 
2.30.2

