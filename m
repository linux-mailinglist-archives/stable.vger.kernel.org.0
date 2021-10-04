Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F3D420FB9
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237958AbhJDNhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:37:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237955AbhJDNfb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:35:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55BF36323E;
        Mon,  4 Oct 2021 13:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353368;
        bh=I1EtwMEg3f+5Gi1tSt7SdQPFl6sxHfc5dDzpPSebGcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FcjhUPDAjNsQ67BhDzCesJEmT2iaOECzQjeuI/Vet2j+RK8Iagob4YNgDaQDv0i62
         9ZEsDrwl6f88nLO0DYGGayQVNxAEA1EPjn96JTVP7MFmbVzm8nUec0VN9f+dhtgewZ
         1I1OkMvdOUHJhDNpD6WH0f6kQWaNOwA5eBWSaQQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Saravana Kannan <saravanak@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 094/172] net: mdiobus: Set FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD for mdiobus parents
Date:   Mon,  4 Oct 2021 14:52:24 +0200
Message-Id: <20211004125048.026692254@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saravana Kannan <saravanak@google.com>

[ Upstream commit 04f41c68f18886aea5afc68be945e7195ea1d598 ]

There are many instances of PHYs that depend on a switch to supply a
resource (Eg: interrupts). Switches also expects the PHYs to be probed
by their specific drivers as soon as they are added. If that doesn't
happen, then the switch would force the use of generic PHY drivers for
the PHY even if the PHY might have specific driver available.

fw_devlink=on by design can cause delayed probes of PHY. To avoid, this
we need to set the FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD for the switch's
fwnode before the PHYs are added. The most generic way to do this is to
set this flag for the parent of MDIO busses which is typically the
switch.

For more context:
https://lore.kernel.org/lkml/YTll0i6Rz3WAAYzs@lunn.ch/#t

Fixes: ea718c699055 ("Revert "Revert "driver core: Set fw_devlink=on by default""")
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Saravana Kannan <saravanak@google.com>
Link: https://lore.kernel.org/r/20210915170940.617415-4-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio_bus.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 53f034fc2ef7..ee8313a4ac71 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -525,6 +525,10 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	    NULL == bus->read || NULL == bus->write)
 		return -EINVAL;
 
+	if (bus->parent && bus->parent->of_node)
+		bus->parent->of_node->fwnode.flags |=
+					FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD;
+
 	BUG_ON(bus->state != MDIOBUS_ALLOCATED &&
 	       bus->state != MDIOBUS_UNREGISTERED);
 
-- 
2.33.0



