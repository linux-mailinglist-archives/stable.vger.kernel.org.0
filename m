Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 663D150155A
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236246AbiDNNds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244902AbiDNN2P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:28:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22903A776E;
        Thu, 14 Apr 2022 06:21:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B42BA612E6;
        Thu, 14 Apr 2022 13:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C673FC385A5;
        Thu, 14 Apr 2022 13:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942477;
        bh=Hjz2oU53MLAT469dRVbdyT7uIR4htjXRrXfpzBlOT8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cWqCcbnbCrxY1AsoqIWUJNR5utn3SE6jG6+j52e2318kiFp9r0vdDmEqjx0yZ2BsI
         kDeKyssmmb1J7EfQ/CXwcLYtLmwjdbGh63aUJLCaJwyqsezB1yBM4votRB1tVj7atL
         GUIoUe0rWW/ii2t0d3Psu7/ReG8TF8ISrEebFUwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 148/338] vxcan: enable local echo for sent CAN frames
Date:   Thu, 14 Apr 2022 15:10:51 +0200
Message-Id: <20220414110843.116162702@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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
index ccd758ba3fb0..8197f04aa8b6 100644
--- a/drivers/net/can/vxcan.c
+++ b/drivers/net/can/vxcan.c
@@ -156,7 +156,7 @@ static void vxcan_setup(struct net_device *dev)
 	dev->hard_header_len	= 0;
 	dev->addr_len		= 0;
 	dev->tx_queue_len	= 0;
-	dev->flags		= (IFF_NOARP|IFF_ECHO);
+	dev->flags		= IFF_NOARP;
 	dev->netdev_ops		= &vxcan_netdev_ops;
 	dev->needs_free_netdev	= true;
 }
-- 
2.34.1



