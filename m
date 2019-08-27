Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED7589E020
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731556AbfH0IAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731555AbfH0IAk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:00:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0AB42189D;
        Tue, 27 Aug 2019 08:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892840;
        bh=ouL9pQLML6Xp5EjrWd4QUncIOI/X0ujE/ME3vJWrTUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BoRBu9sUBXNy5dl0i1rn0zwosQff1IHwaTpq4R1C4ZpqxuhV538JtyrnBq6yuW7N2
         yCBFFPMdetPYrhIxPoU74oIdgaR6ji1XVgil6D38Co/7K8kcYEzfSoqtNzwnuybs6G
         fCDdjmoi+mECBC4IDLw2na9CebpiL0Z2pEM7mapM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Willem de Bruijn <willemb@google.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 032/162] can: dev: call netif_carrier_off() in register_candev()
Date:   Tue, 27 Aug 2019 09:49:20 +0200
Message-Id: <20190827072739.411523958@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c63845609c4700488e5eacd6ab4d06d5d420e5ef ]

CONFIG_CAN_LEDS is deprecated. When trying to use the generic netdev
trigger as suggested, there's a small inconsistency with the link
property: The LED is on initially, stays on when the device is brought
up, and then turns off (as expected) when the device is brought down.

Make sure the LED always reflects the state of the CAN device.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index b6b93a2d93a59..483d270664cc8 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -1249,6 +1249,8 @@ int register_candev(struct net_device *dev)
 		return -EINVAL;
 
 	dev->rtnl_link_ops = &can_link_ops;
+	netif_carrier_off(dev);
+
 	return register_netdev(dev);
 }
 EXPORT_SYMBOL_GPL(register_candev);
-- 
2.20.1



