Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 846C11018B0
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbfKSF2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:28:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:46418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727840AbfKSF2D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:28:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F195208C3;
        Tue, 19 Nov 2019 05:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141281;
        bh=2ohfrYlI9AQLpAqTbHVEr+dyZe0wqqGRf+hlTW7OljU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K1pBEN8q7hscB015nYNBWhtwL8Ke6wGVDYogIR7swd2wM8G8p+u/tJ+vD9uQF3G2d
         8OJK/nHvW4lYpFlEnQ5G6mPkS08eSXcYUEoRqPyxISvK5Gs01ILkmI0xW3n9lYhksW
         WpcYsf9S0B+LIpmcMbr9252s+sGL/pdjkBrttdDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 108/422] net: phy: mscc: read vsc8531,vddmac as an u32
Date:   Tue, 19 Nov 2019 06:15:05 +0100
Message-Id: <20191119051406.154190055@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Schulz <quentin.schulz@bootlin.com>

[ Upstream commit a993e0f583c7925adaa7721226ccd7a41e7e63d1 ]

In the DT binding, it is specified nowhere that 'vsc8531,vddmac' is an
u16, even though it's read as an u16 in the driver.

Let's update the driver to take into consideration that the
'vsc8531,vddmac' property is of the default type u32.

Signed-off-by: Quentin Schulz <quentin.schulz@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mscc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c
index 84ca9ff40ae0b..53d63a71a03e2 100644
--- a/drivers/net/phy/mscc.c
+++ b/drivers/net/phy/mscc.c
@@ -111,7 +111,7 @@ struct vsc8531_private {
 
 #ifdef CONFIG_OF_MDIO
 struct vsc8531_edge_rate_table {
-	u16 vddmac;
+	u32 vddmac;
 	u8 slowdown[8];
 };
 
@@ -376,7 +376,7 @@ out_unlock:
 static int vsc85xx_edge_rate_magic_get(struct phy_device *phydev)
 {
 	u8 sd;
-	u16 vdd;
+	u32 vdd;
 	int rc, i, j;
 	struct device *dev = &phydev->mdio.dev;
 	struct device_node *of_node = dev->of_node;
@@ -385,7 +385,7 @@ static int vsc85xx_edge_rate_magic_get(struct phy_device *phydev)
 	if (!of_node)
 		return -ENODEV;
 
-	rc = of_property_read_u16(of_node, "vsc8531,vddmac", &vdd);
+	rc = of_property_read_u32(of_node, "vsc8531,vddmac", &vdd);
 	if (rc != 0)
 		vdd = MSCC_VDDMAC_3300;
 
-- 
2.20.1



