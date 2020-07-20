Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9096B226AA9
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731362AbgGTPw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:52:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731360AbgGTPw2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:52:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6B432064B;
        Mon, 20 Jul 2020 15:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260347;
        bh=WrJfgmj/gwUppoiQHyikB/X08pI4S01T2x1sGO1Xf1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gRbAtLWIU42Rv6ACs7RIvckXl9hVZ54dJ7KI6I4+QlzsjwqAmXj5qAnHRiFwPy0Kt
         WSBXwGSS7ceb/6UQJi6GUDBvQMa3w4SJWcnU+cTmJmsswAFlR0GedI2Lb/8M1G2AxS
         6jSVUFjP35LycbZ+hBdWty3HIb6FmbMlvSs0AAPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 040/133] of: of_mdio: Correct loop scanning logic
Date:   Mon, 20 Jul 2020 17:36:27 +0200
Message-Id: <20200720152805.657834536@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 5a8d7f126c97d04d893f5e5be2b286437a0d01b0 ]

Commit 209c65b61d94 ("drivers/of/of_mdio.c:fix of_mdiobus_register()")
introduced a break of the loop on the premise that a successful
registration should exit the loop. The premise is correct but not to
code, because rc && rc != -ENODEV is just a special error condition,
that means we would exit the loop even with rc == -ENODEV which is
absolutely not correct since this is the error code to indicate to the
MDIO bus layer that scanning should continue.

Fix this by explicitly checking for rc = 0 as the only valid condition
to break out of the loop.

Fixes: 209c65b61d94 ("drivers/of/of_mdio.c:fix of_mdiobus_register()")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/of_mdio.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index af7572fe090fd..100adacfdca94 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -267,10 +267,15 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 				 child, addr);
 
 			if (of_mdiobus_child_is_phy(child)) {
+				/* -ENODEV is the return code that PHYLIB has
+				 * standardized on to indicate that bus
+				 * scanning should continue.
+				 */
 				rc = of_mdiobus_register_phy(mdio, child, addr);
-				if (rc && rc != -ENODEV)
+				if (!rc)
+					break;
+				if (rc != -ENODEV)
 					goto unregister;
-				break;
 			}
 		}
 	}
-- 
2.25.1



