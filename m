Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E23474F0011
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 11:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiDBJXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 05:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354174AbiDBJXO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 05:23:14 -0400
X-Greylist: delayed 363 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 02 Apr 2022 02:21:22 PDT
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.216])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC1D1BB7A6
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 02:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1648890782;
    s=strato-dkim-0002; d=hartkopp.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=LKfAu0VSjmAUskfrWtHsKCMHOSxEBzyjsPM4e8r4/zQ=;
    b=hA6boHnMCsnUr4v+k2rCyzi8Swfo/atNfOiTZuU9ZmM5DElaTRSLe2KA8aZ/UB5iPs
    kB4Rp7FHbbakImz/dM1610jIpGP70EeB9TxopJct+mgLX/XiGdHQ9okldiq4xhG569uq
    aAbiQPhjQtb9LsO8+8fQKE98eKunczcGK+tz3mwzQpNqltjikJ4y0R4owVZZSSYbu5Sx
    Rxq1RafAmbty9/wgsqLEVDQunt/1SI2w1QT4DgTwvlth0I1rRNVI2sbwj/9DsHouGhhl
    2/wNueBuOnyvkO8KKNV6fxkwYrhcspOwn4c/pe5VnBrrrJw+ckDVkGzwzBX4q34WjjSD
    sTZg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS/xvEBL7X5sbo3UIh9IyLecSWJafUvprl4"
X-RZG-CLASS-ID: mo00
Received: from silver.lan
    by smtp.strato.de (RZmta 47.42.2 AUTH)
    with ESMTPSA id 4544c9y329D2EHw
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sat, 2 Apr 2022 11:13:02 +0200 (CEST)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     stable@vger.kernel.org, sashal@kernel.org,
        gregkh@linuxfoundation.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH stable v5.10-v5.17] can: isotp: sanitize CAN ID checks in isotp_bind()
Date:   Sat,  2 Apr 2022 11:12:39 +0200
Message-Id: <20220402091239.3039-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 3ea566422cbde9610c2734980d1286ab681bb40e upstream.

Syzbot created an environment that lead to a state machine status that
can not be reached with a compliant CAN ID address configuration.
The provided address information consisted of CAN ID 0x6000001 and 0xC28001
which both boil down to 11 bit CAN IDs 0x001 in sending and receiving.

Sanitize the SFF/EFF CAN ID values before performing the address checks.

Cc: stable@vger.kernel.org # v5.10 - v5.17
Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Link: https://lore.kernel.org/all/20220316164258.54155-1-socketcan@hartkopp.net
Reported-by: syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index d2a430b6a13b..f8e3aeb79e3f 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1102,19 +1102,30 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	struct sock *sk = sock->sk;
 	struct isotp_sock *so = isotp_sk(sk);
 	struct net *net = sock_net(sk);
 	int ifindex;
 	struct net_device *dev;
+	canid_t tx_id, rx_id;
 	int err = 0;
 	int notify_enetdown = 0;
 	int do_rx_reg = 1;
 
 	if (len < ISOTP_MIN_NAMELEN)
 		return -EINVAL;
 
-	if (addr->can_addr.tp.tx_id & (CAN_ERR_FLAG | CAN_RTR_FLAG))
-		return -EADDRNOTAVAIL;
+	/* sanitize tx/rx CAN identifiers */
+	tx_id = addr->can_addr.tp.tx_id;
+	if (tx_id & CAN_EFF_FLAG)
+		tx_id &= (CAN_EFF_FLAG | CAN_EFF_MASK);
+	else
+		tx_id &= CAN_SFF_MASK;
+
+	rx_id = addr->can_addr.tp.rx_id;
+	if (rx_id & CAN_EFF_FLAG)
+		rx_id &= (CAN_EFF_FLAG | CAN_EFF_MASK);
+	else
+		rx_id &= CAN_SFF_MASK;
 
 	if (!addr->can_ifindex)
 		return -ENODEV;
 
 	lock_sock(sk);
@@ -1122,25 +1133,17 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	/* do not register frame reception for functional addressing */
 	if (so->opt.flags & CAN_ISOTP_SF_BROADCAST)
 		do_rx_reg = 0;
 
 	/* do not validate rx address for functional addressing */
-	if (do_rx_reg) {
-		if (addr->can_addr.tp.rx_id == addr->can_addr.tp.tx_id) {
-			err = -EADDRNOTAVAIL;
-			goto out;
-		}
-
-		if (addr->can_addr.tp.rx_id & (CAN_ERR_FLAG | CAN_RTR_FLAG)) {
-			err = -EADDRNOTAVAIL;
-			goto out;
-		}
+	if (do_rx_reg && rx_id == tx_id) {
+		err = -EADDRNOTAVAIL;
+		goto out;
 	}
 
 	if (so->bound && addr->can_ifindex == so->ifindex &&
-	    addr->can_addr.tp.rx_id == so->rxid &&
-	    addr->can_addr.tp.tx_id == so->txid)
+	    rx_id == so->rxid && tx_id == so->txid)
 		goto out;
 
 	dev = dev_get_by_index(net, addr->can_ifindex);
 	if (!dev) {
 		err = -ENODEV;
@@ -1160,12 +1163,11 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 		notify_enetdown = 1;
 
 	ifindex = dev->ifindex;
 
 	if (do_rx_reg)
-		can_rx_register(net, dev, addr->can_addr.tp.rx_id,
-				SINGLE_MASK(addr->can_addr.tp.rx_id),
+		can_rx_register(net, dev, rx_id, SINGLE_MASK(rx_id),
 				isotp_rcv, sk, "isotp", sk);
 
 	dev_put(dev);
 
 	if (so->bound && do_rx_reg) {
@@ -1181,12 +1183,12 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 		}
 	}
 
 	/* switch to new settings */
 	so->ifindex = ifindex;
-	so->rxid = addr->can_addr.tp.rx_id;
-	so->txid = addr->can_addr.tp.tx_id;
+	so->rxid = rx_id;
+	so->txid = tx_id;
 	so->bound = 1;
 
 out:
 	release_sock(sk);
 
-- 
2.30.2

