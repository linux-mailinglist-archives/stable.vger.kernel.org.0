Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABC84F37FF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359825AbiDELU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349260AbiDEJtb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A63AB;
        Tue,  5 Apr 2022 02:43:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2657F6164D;
        Tue,  5 Apr 2022 09:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32838C385A1;
        Tue,  5 Apr 2022 09:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151806;
        bh=SFZhGojlTJsFtEcOoR6TsDZqCuHRKYKgaXsoBWxvPMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wsAaXplorpXAHaQGyH1G7Y0yl10x3YT6jInzObjwGDzf5w1hHxsrlGI6hC6UnzTFH
         imryDRU1uXYiAiIeB9+GNNfJ+myvZwqxv4DxMnwdbRkxJuAzUjmZuxXnJHu3MpqzMS
         aFdSz6jnsSDjhcZhGDtq5vf6LsYu4sQVGuCKMolA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 549/913] can: isotp: sanitize CAN ID checks in isotp_bind()
Date:   Tue,  5 Apr 2022 09:26:51 +0200
Message-Id: <20220405070356.303888570@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

commit 3ea566422cbde9610c2734980d1286ab681bb40e upstream.

Syzbot created an environment that lead to a state machine status that
can not be reached with a compliant CAN ID address configuration.
The provided address information consisted of CAN ID 0x6000001 and 0xC28001
which both boil down to 11 bit CAN IDs 0x001 in sending and receiving.

Sanitize the SFF/EFF CAN ID values before performing the address checks.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Link: https://lore.kernel.org/all/20220316164258.54155-1-socketcan@hartkopp.net
Reported-by: syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1104,6 +1104,7 @@ static int isotp_bind(struct socket *soc
 	struct net *net = sock_net(sk);
 	int ifindex;
 	struct net_device *dev;
+	canid_t tx_id, rx_id;
 	int err = 0;
 	int notify_enetdown = 0;
 	int do_rx_reg = 1;
@@ -1111,8 +1112,18 @@ static int isotp_bind(struct socket *soc
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
@@ -1124,21 +1135,13 @@ static int isotp_bind(struct socket *soc
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
@@ -1162,8 +1165,7 @@ static int isotp_bind(struct socket *soc
 	ifindex = dev->ifindex;
 
 	if (do_rx_reg)
-		can_rx_register(net, dev, addr->can_addr.tp.rx_id,
-				SINGLE_MASK(addr->can_addr.tp.rx_id),
+		can_rx_register(net, dev, rx_id, SINGLE_MASK(rx_id),
 				isotp_rcv, sk, "isotp", sk);
 
 	dev_put(dev);
@@ -1183,8 +1185,8 @@ static int isotp_bind(struct socket *soc
 
 	/* switch to new settings */
 	so->ifindex = ifindex;
-	so->rxid = addr->can_addr.tp.rx_id;
-	so->txid = addr->can_addr.tp.tx_id;
+	so->rxid = rx_id;
+	so->txid = tx_id;
 	so->bound = 1;
 
 out:


