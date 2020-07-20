Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F792264A1
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729887AbgGTPqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:46:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730138AbgGTPqo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:46:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C6402065E;
        Mon, 20 Jul 2020 15:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260004;
        bh=wMn9wjQUD0rMUL4y+UmL4VufUkCmHW5CbQxVvrrPA8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K+CMufkJJZtzjJNELmJ+3CI8f7ZB7DukH5qCS/26NlnKkwJhPucU9q1i7koRV11hR
         kf4EUaZ50NNEIumoGRnPQvXyY4M/VoThOvnENiuZgVk3GdSitNuDzqKGT2WkLu1iXz
         p8wJZJvcY4xp1pLBR6pC8CiMS0GGH0iZbM7tqXUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 072/125] of: of_mdio: Correct loop scanning logic
Date:   Mon, 20 Jul 2020 17:36:51 +0200
Message-Id: <20200720152806.477897543@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
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
index 69da2f6896dae..8b7d3e64b8cab 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -256,10 +256,15 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 				 child->name, addr);
 
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



