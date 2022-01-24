Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F83498939
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245756AbiAXSxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:53:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51124 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245499AbiAXSv7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:51:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51BF8B81223;
        Mon, 24 Jan 2022 18:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C14C340E5;
        Mon, 24 Jan 2022 18:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050317;
        bh=ohSD3H6PwcHAXjnc8cPnR0pRDWhhFXJoW7p+x+J3LEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D75OLag6it4UaXI9wqqdiVSivpaCgWxPkFbAzHfXgh4BnfS0ySFmtcsG2YMhCz9zp
         KEEYoUU8F2HUVg13MKE6BgakENf9iQfBNmHn8d/uMZues5j8nmaxqF3xOfuisC9vrR
         rQ5FuGV5RGqvfVD86YHPHKncTnO/9eCw8QV5rc5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 078/114] net: mdio: Demote probed message to debug print
Date:   Mon, 24 Jan 2022 19:42:53 +0100
Message-Id: <20220124183929.500442597@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
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
index 4066fb5a935a7..2fb95cca33183 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -295,7 +295,7 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	}
 
 	bus->state = MDIOBUS_REGISTERED;
-	pr_info("%s: probed\n", bus->name);
+	dev_dbg(&bus->dev, "probed\n");
 	return 0;
 
 error:
-- 
2.34.1



