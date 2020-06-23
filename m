Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A5D206314
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389402AbgFWUQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:16:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388022AbgFWUQS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:16:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 787952073E;
        Tue, 23 Jun 2020 20:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943378;
        bh=vmvgYVO8n1EP5AjQrgIGT1TInpBkxtyNeuzktd11RXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qT1j0Dd3JijszeIVhXzT4HX5LizUnL3j9JMSZMHSGFWxmi1aFrQFBxDn/hgsdrSl4
         lt2aDOe7EHuaMPzNS/F7ANFuyVvbntv9xV+KzfjjyQ6j44zCjYrCbnNNUuM7sVSfvT
         4dX+0Lc4utWrCYg1pvfFuMk3zC9GCd0Xb4aTvE34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 338/477] net: mscc: Fix OF_MDIO config check
Date:   Tue, 23 Jun 2020 21:55:35 +0200
Message-Id: <20200623195423.518527381@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>

[ Upstream commit ae602786407fef34e1d66b3c8f278a10ed37197e ]

When CONFIG_OF_MDIO is set to be a module the code block is not
compiled. Use the IS_ENABLED macro that checks for both built in as
well as module.

Fixes: 4f58e6dceb0e4 ("net: phy: Cleanup the Edge-Rate feature in Microsemi PHYs.")
Signed-off-by: Dan Murphy <dmurphy@ti.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mscc/mscc.h      | 2 +-
 drivers/net/phy/mscc/mscc_main.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index 414e3b31bb1fa..132f9bf49198f 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -375,7 +375,7 @@ struct vsc8531_private {
 #endif
 };
 
-#ifdef CONFIG_OF_MDIO
+#if IS_ENABLED(CONFIG_OF_MDIO)
 struct vsc8531_edge_rate_table {
 	u32 vddmac;
 	u32 slowdown[8];
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index c8aa6d905d8e6..485a4f8a6a9a6 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -98,7 +98,7 @@ static const struct vsc85xx_hw_stat vsc8584_hw_stats[] = {
 	},
 };
 
-#ifdef CONFIG_OF_MDIO
+#if IS_ENABLED(CONFIG_OF_MDIO)
 static const struct vsc8531_edge_rate_table edge_table[] = {
 	{MSCC_VDDMAC_3300, { 0, 2,  4,  7, 10, 17, 29, 53} },
 	{MSCC_VDDMAC_2500, { 0, 3,  6, 10, 14, 23, 37, 63} },
@@ -382,7 +382,7 @@ out_unlock:
 	mutex_unlock(&phydev->lock);
 }
 
-#ifdef CONFIG_OF_MDIO
+#if IS_ENABLED(CONFIG_OF_MDIO)
 static int vsc85xx_edge_rate_magic_get(struct phy_device *phydev)
 {
 	u32 vdd, sd;
-- 
2.25.1



