Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56FCC498B3C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346124AbiAXTMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:12:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38446 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343751AbiAXTIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:08:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFC46603DE;
        Mon, 24 Jan 2022 19:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6ABC340E5;
        Mon, 24 Jan 2022 19:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051318;
        bh=RAdhLRVeEYDOm1M80ADJcb/gs1YaEtQq24VU3WhFrZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sSmKnTjmGClsriMTz2IsdQALdCcdXHEtYVIiAhuXLrGBdts92n/duVNyliBf/6iFR
         6LI204gPMWTZB5yhyzkUk+9Ys9R8jf1w3PyNvs+EEpocTYL/CzF4ZEWHJJcWpBkdV5
         lyOk+dywhFXoOpOMbLdg1jirSLSnSdn1TF8JkaDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 124/186] net: mdio: Demote probed message to debug print
Date:   Mon, 24 Jan 2022 19:43:19 +0100
Message-Id: <20220124183941.101062250@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 7590fc6f80ac2cbf23e6b42b668bbeded070850b ]

On systems with large numbers of MDIO bus/muxes the message indicating
that a given MDIO bus has been successfully probed is repeated for as
many buses we have, which can eat up substantial boot time for no
reason, demote to a debug print.

Reported-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220103194024.2620-1-f.fainelli@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio_bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 5ef9bbbab3dbb..7b9480ce21a21 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -392,7 +392,7 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	mdiobus_setup_mdiodev_from_board_info(bus, mdiobus_create_device);
 
 	bus->state = MDIOBUS_REGISTERED;
-	pr_info("%s: probed\n", bus->name);
+	dev_dbg(&bus->dev, "probed\n");
 	return 0;
 
 error:
-- 
2.34.1



