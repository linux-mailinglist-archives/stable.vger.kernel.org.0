Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74D8619919C
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731070AbgCaJUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:20:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730638AbgCaJNk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:13:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6470420772;
        Tue, 31 Mar 2020 09:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646019;
        bh=QJg5dbPMMfu3F11UcTFkO03F2cyBYQMHfMbgC//ejzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LUHE/NjhcLah79x2KTUYRmnVx3EFdjdvRKxG1cH2znbcsluvTxFzBZwxcth6cTdQa
         LIzmr/8/r4fpRkJAYaP5107dH3xj4Y2TDpw57BBTxC8TcyemrEgO4o0KOBj8CxF59u
         FH0DbVV9UHFaKFknlcfBl4ydvfyDs4WLOL3vH5aE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dajun Jin <adajunjin@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 057/155] drivers/of/of_mdio.c:fix of_mdiobus_register()
Date:   Tue, 31 Mar 2020 10:58:17 +0200
Message-Id: <20200331085424.967560333@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
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
index bd6129db64178..c34a6df712adb 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -268,6 +268,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 				rc = of_mdiobus_register_phy(mdio, child, addr);
 				if (rc && rc != -ENODEV)
 					goto unregister;
+				break;
 			}
 		}
 	}
-- 
2.20.1



