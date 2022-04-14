Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6C775014DA
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344734AbiDNNwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344632AbiDNNo2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:44:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4DF33880;
        Thu, 14 Apr 2022 06:39:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82D4EB82983;
        Thu, 14 Apr 2022 13:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E7EC385A1;
        Thu, 14 Apr 2022 13:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943593;
        bh=BUp89Y48prw3uC7Zsp9NBI6Xgc8DoR1PbAzvthqIWTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XAskTyVCX3YwmOii8GFyXDxAgJfREihaxWOwyIBBTytRQgKNIh5MaELHoptGb4/5z
         ADcPpsHKrrJ920iiEDfrl2MNqHxUbx5TZT7EU4fB5peel3f+NMtEcoVkBmu4Jt5L+A
         g9tvNTJWjV2xTShG2r/xjguDiQ5h8VIFlYJ+lJSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 210/475] vxcan: enable local echo for sent CAN frames
Date:   Thu, 14 Apr 2022 15:09:55 +0200
Message-Id: <20220414110901.004512805@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
index 7000c6cd1e48..282c53ef76d2 100644
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



