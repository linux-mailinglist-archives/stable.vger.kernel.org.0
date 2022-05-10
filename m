Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 789F752193A
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243536AbiEJNoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244559AbiEJNl7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:41:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832FD2C96EB;
        Tue, 10 May 2022 06:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C66AFB81DAF;
        Tue, 10 May 2022 13:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B672C385C2;
        Tue, 10 May 2022 13:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189387;
        bh=ZS4YX0gYWuUArXMDi1K/gNPON1wBSM2zlX0d9VfYLWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E51FigRLhPDCUxKgVAZ2UWifyoiDptxOMCt5CG/5ngIZfoUSDK6ftZPCQp1JsDqiM
         pIHzEK4PCvAdMgrRPUrkyzoXL/+ZIQ4T2vpYReBQ8hxfbZp4awzjJxShgtbJKMx25O
         c/zxZ0SoFNNUboaUon/9Qitf5fcwseKIa/Nc2JAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 033/135] can: isotp: remove re-binding of bound socket
Date:   Tue, 10 May 2022 15:06:55 +0200
Message-Id: <20220510130741.351866672@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 72ed3ee9fa0b461ad086403a8b5336154bd82234 upstream.

As a carry over from the CAN_RAW socket (which allows to change the CAN
interface while mantaining the filter setup) the re-binding of the
CAN_ISOTP socket needs to take care about CAN ID address information and
subscriptions. It turned out that this feature is so limited (e.g. the
sockopts remain fix) that it finally has never been needed/used.

In opposite to the stateless CAN_RAW socket the switching of the CAN ID
subscriptions might additionally lead to an interrupted ongoing PDU
reception. So better remove this unneeded complexity.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Link: https://lore.kernel.org/all/20220422082337.1676-1-socketcan@hartkopp.net
Cc: stable@vger.kernel.org
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |   22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1146,6 +1146,11 @@ static int isotp_bind(struct socket *soc
 
 	lock_sock(sk);
 
+	if (so->bound) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	/* do not register frame reception for functional addressing */
 	if (so->opt.flags & CAN_ISOTP_SF_BROADCAST)
 		do_rx_reg = 0;
@@ -1156,10 +1161,6 @@ static int isotp_bind(struct socket *soc
 		goto out;
 	}
 
-	if (so->bound && addr->can_ifindex == so->ifindex &&
-	    rx_id == so->rxid && tx_id == so->txid)
-		goto out;
-
 	dev = dev_get_by_index(net, addr->can_ifindex);
 	if (!dev) {
 		err = -ENODEV;
@@ -1186,19 +1187,6 @@ static int isotp_bind(struct socket *soc
 
 	dev_put(dev);
 
-	if (so->bound && do_rx_reg) {
-		/* unregister old filter */
-		if (so->ifindex) {
-			dev = dev_get_by_index(net, so->ifindex);
-			if (dev) {
-				can_rx_unregister(net, dev, so->rxid,
-						  SINGLE_MASK(so->rxid),
-						  isotp_rcv, sk);
-				dev_put(dev);
-			}
-		}
-	}
-
 	/* switch to new settings */
 	so->ifindex = ifindex;
 	so->rxid = rx_id;


