Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E925145208D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345477AbhKPAzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:55:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245734AbhKOTVF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FE156328A;
        Mon, 15 Nov 2021 18:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001619;
        bh=2FNSaQtIK1xtf6h2ey8cw1D/v18nJ78M6xaDzSKJEHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gV8TEACDOmdxf3JDJ0XiwWx6IreY9+BzCE3z1LkfnuUrQqfSQ5p68h+6H/6Dxv0R2
         kA6T8ZFrY+yBthQynCz5FyBAZYIWF/vJnk06E+XEgfZX5LgVIR/YDqxkpS2mX8PQOf
         epPE4M33kb0dwir36xf1S+MWYnyyNVGjKNd6GYJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 258/917] net: phy: micrel: make *-skew-ps check more lenient
Date:   Mon, 15 Nov 2021 17:55:53 +0100
Message-Id: <20211115165437.540682168@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit 67ca5159dbe2edb5dae7544447b8677d2596933a ]

It seems reasonable to fine-tune only some of the skew values when using
one of the rgmii-*id PHY modes, and even when all skew values are
specified, using the correct ID PHY mode makes sense for documentation
purposes. Such a configuration also appears in the binding docs in
Documentation/devicetree/bindings/net/micrel-ksz90x1.txt, so the driver
should not warn about it.

Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Link: https://lore.kernel.org/r/20211012103402.21438-1-matthias.schiffer@ew.tq-group.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 5c928f827173c..643b1c1827a92 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -863,9 +863,9 @@ static int ksz9031_config_init(struct phy_device *phydev)
 				MII_KSZ9031RN_TX_DATA_PAD_SKEW, 4,
 				tx_data_skews, 4, &update);
 
-		if (update && phydev->interface != PHY_INTERFACE_MODE_RGMII)
+		if (update && !phy_interface_is_rgmii(phydev))
 			phydev_warn(phydev,
-				    "*-skew-ps values should be used only with phy-mode = \"rgmii\"\n");
+				    "*-skew-ps values should be used only with RGMII PHY modes\n");
 
 		/* Silicon Errata Sheet (DS80000691D or DS80000692D):
 		 * When the device links in the 1000BASE-T slave mode only,
-- 
2.33.0



