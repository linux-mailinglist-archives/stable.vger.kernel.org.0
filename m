Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2BC113216
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730055AbfLDSFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:05:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:52560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730420AbfLDSFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:05:38 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB90B20659;
        Wed,  4 Dec 2019 18:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482738;
        bh=c2DkTy4DJDy46PvyizCrjeXPqUguuY8YxnhHujB8QQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bZxEQQzaEioyDiMfCZNHto8xArieFnq9nK0rxVHnfp1JsuJdu/6nVrnbb++mjyJjn
         TTZDuPKTqyUXC8Vti1yzVrOSvE+OwTBBvZVPH1IyvDFEFUP20N2OYw8CpbUpTaxkRZ
         el0wNHQlQwBEaOcjocxWksNHHqijdNe4Vvq/9YwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 115/209] net: dsa: bcm_sf2: Propagate error value from mdio_write
Date:   Wed,  4 Dec 2019 18:55:27 +0100
Message-Id: <20191204175331.040110263@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kangjie Lu <kjlu@umn.edu>

[ Upstream commit e49505f7255be8ced695919c08a29bf2c3d79616 ]

Both bcm_sf2_sw_indir_rw and mdiobus_write_nested could fail, so let's
return their error codes upstream.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/bcm_sf2.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index af666951a9592..94ad2fdd6ef0d 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -432,11 +432,10 @@ static int bcm_sf2_sw_mdio_write(struct mii_bus *bus, int addr, int regnum,
 	 * send them to our master MDIO bus controller
 	 */
 	if (addr == BRCM_PSEUDO_PHY_ADDR && priv->indir_phy_mask & BIT(addr))
-		bcm_sf2_sw_indir_rw(priv, 0, addr, regnum, val);
+		return bcm_sf2_sw_indir_rw(priv, 0, addr, regnum, val);
 	else
-		mdiobus_write_nested(priv->master_mii_bus, addr, regnum, val);
-
-	return 0;
+		return mdiobus_write_nested(priv->master_mii_bus, addr,
+				regnum, val);
 }
 
 static irqreturn_t bcm_sf2_switch_0_isr(int irq, void *dev_id)
-- 
2.20.1



