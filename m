Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFC6B198FA9
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730981AbgCaJEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:04:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730648AbgCaJEt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:04:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BE6520787;
        Tue, 31 Mar 2020 09:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645488;
        bh=PndM6PtHusE/G30Hx9O5MCKkXCtbBUHeBRG+pkQeq0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vr34luBDrXgFBoxxBigBQQyWcKDumzUXn6wpNFD117+aP1p0PqbG/wFhooeTZbmFv
         hpslo8XIxCp0a7d7M+WD5jc5UzDWTURwbF/b7iur59rbKB91zYeNPToGwiBwyB3vlC
         Lx7wXZqXCTKMz35Ct+HCico4KeJfjgvkqma8I58g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dajun Jin <adajunjin@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 067/170] drivers/of/of_mdio.c:fix of_mdiobus_register()
Date:   Tue, 31 Mar 2020 10:58:01 +0200
Message-Id: <20200331085431.560157794@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dajun Jin <adajunjin@gmail.com>

[ Upstream commit 209c65b61d94344522c41a83cd6ce51aac5fd0a4 ]

When registers a phy_device successful, should terminate the loop
or the phy_device would be registered in other addr. If there are
multiple PHYs without reg properties, it will go wrong.

Signed-off-by: Dajun Jin <adajunjin@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/of_mdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index fc757ef6eadc5..a27234c58ec56 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -269,6 +269,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 				rc = of_mdiobus_register_phy(mdio, child, addr);
 				if (rc && rc != -ENODEV)
 					goto unregister;
+				break;
 			}
 		}
 	}
-- 
2.20.1



