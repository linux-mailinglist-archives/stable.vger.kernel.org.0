Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE61D2F14F4
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732327AbhAKNdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:33:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:33326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732187AbhAKNOw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:14:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81FF022BED;
        Mon, 11 Jan 2021 13:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370851;
        bh=zjC6Gipvh4Ns9zoYUlOGRldxgGB+zBpfwGUlLN5Y7UA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NXJcEVaGfit6U0txUEvOCnoeDdMH+Q5iBOp6NLPnZSq7VEkmrVzy3hMKT82jat1iB
         Xx+kexn9iOquKGhRKaEep+LokPZMqH/BVPt9S400bOzwLw0vXfDAMaKMht3OGSxKCb
         I9X27F1KOLIuHWNYwkL0TEDG6mQWV6c/m2dgbRiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 008/145] ethernet: ucc_geth: set dev->max_mtu to 1518
Date:   Mon, 11 Jan 2021 14:00:32 +0100
Message-Id: <20210111130048.914033533@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

[ Upstream commit 1385ae5c30f238f81bc6528d897c6d7a0816783f ]

All the buffers and registers are already set up appropriately for an
MTU slightly above 1500, so we just need to expose this to the
networking stack. AFAICT, there's no need to implement .ndo_change_mtu
when the receive buffers are always set up to support the max_mtu.

This fixes several warnings during boot on our mpc8309-board with an
embedded mv88e6250 switch:

mv88e6085 mdio@e0102120:10: nonfatal error -34 setting MTU 1500 on port 0
...
mv88e6085 mdio@e0102120:10: nonfatal error -34 setting MTU 1500 on port 4
ucc_geth e0102000.ethernet eth1: error -22 setting MTU to 1504 to include DSA overhead

The last line explains what the DSA stack tries to do: achieving an MTU
of 1500 on-the-wire requires that the master netdevice connected to
the CPU port supports an MTU of 1500+the tagging overhead.

Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/ucc_geth.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -3889,6 +3889,7 @@ static int ucc_geth_probe(struct platfor
 	INIT_WORK(&ugeth->timeout_work, ucc_geth_timeout_work);
 	netif_napi_add(dev, &ugeth->napi, ucc_geth_poll, 64);
 	dev->mtu = 1500;
+	dev->max_mtu = 1518;
 
 	ugeth->msg_enable = netif_msg_init(debug.msg_enable, UGETH_MSG_DEFAULT);
 	ugeth->phy_interface = phy_interface;


