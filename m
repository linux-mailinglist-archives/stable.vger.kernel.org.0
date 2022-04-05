Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C044F2B11
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbiDEIZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238354AbiDEISx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:18:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697A8DAA;
        Tue,  5 Apr 2022 01:08:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A069F60A1E;
        Tue,  5 Apr 2022 08:08:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2AA5C385A1;
        Tue,  5 Apr 2022 08:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146121;
        bh=iOy1mNW6EnbHS4QhamoV2p28aXccAJlzHWxZ/5jreW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oHc2StOFTy05foe8NJ0Wmiam+MDDBLNd5F2JY1JW1NEdVQxm9NexvG5JzDTkyCFA8
         eoi7cXF6/FbbtNGsv36p9i10LuaowViVJdSs80ldDREx8rpSOxJ9Pz9zqrPcSRmK3T
         pUfXKkO7+tpe6tlcQWZPQESbZEX+dHMiWepDNdZ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0650/1126] vxcan: enable local echo for sent CAN frames
Date:   Tue,  5 Apr 2022 09:23:17 +0200
Message-Id: <20220405070426.710048885@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

[ Upstream commit 259bdba27e32368b4404f69d613b1c1014c07cbf ]

The vxcan driver provides a pair of virtual CAN interfaces to exchange
CAN traffic between different namespaces - analogue to veth.

In opposite to the vcan driver the local sent CAN traffic on this interface
is not echo'ed back but only sent to the remote peer. This is unusual and
can be easily fixed by removing IFF_ECHO from the netdevice flags that
are set for vxcan interfaces by default at startup.

Without IFF_ECHO set on driver level, the local sent CAN frames are echo'ed
in af_can.c in can_send(). This patch makes vxcan interfaces adopt the
same local echo behavior and procedures as known from the vcan interfaces.

Fixes: a8f820a380a2 ("can: add Virtual CAN Tunnel driver (vxcan)")
Link: https://lore.kernel.org/all/20220309120416.83514-5-socketcan@hartkopp.net
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/vxcan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/vxcan.c b/drivers/net/can/vxcan.c
index 47ccc15a3486..191ffa7776e8 100644
--- a/drivers/net/can/vxcan.c
+++ b/drivers/net/can/vxcan.c
@@ -148,7 +148,7 @@ static void vxcan_setup(struct net_device *dev)
 	dev->hard_header_len	= 0;
 	dev->addr_len		= 0;
 	dev->tx_queue_len	= 0;
-	dev->flags		= (IFF_NOARP|IFF_ECHO);
+	dev->flags		= IFF_NOARP;
 	dev->netdev_ops		= &vxcan_netdev_ops;
 	dev->needs_free_netdev	= true;
 
-- 
2.34.1



