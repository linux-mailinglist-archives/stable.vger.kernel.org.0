Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429072063AD
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391057AbgFWUbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:31:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391181AbgFWUbD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:31:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89CF5206C3;
        Tue, 23 Jun 2020 20:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944264;
        bh=fleriWgx6Njua+UUeLzYxuGYivie5eQmAT4OYkQTLRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xiMwsc0DrlGuGiS+oojot/4a62E65vesdr0DsWXo0UoqivlBJYqekZ7I1SvMa5Yx8
         5Rb4mR3hsz/AfWGFfEzdtSFpRdfsu4QquGzf+g0el/xRdlXzYEfEA9EDJ6jIyGv8gd
         FR9HaThi2Ru/GBx3d+plOTCYPlKrvueji2vVW07k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 229/314] net: marvell: Fix OF_MDIO config check
Date:   Tue, 23 Jun 2020 21:57:04 +0200
Message-Id: <20200623195349.873864706@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>

[ Upstream commit 5cd119d9a05f1c1a08778a7305b4ca0f16bc1e20 ]

When CONFIG_OF_MDIO is set to be a module the code block is not
compiled. Use the IS_ENABLED macro that checks for both built in as
well as module.

Fixes: cf41a51db8985 ("of/phylib: Use device tree properties to initialize Marvell PHYs.")
Signed-off-by: Dan Murphy <dmurphy@ti.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/marvell.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index a7796134e3be0..91cf1d1672637 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -358,7 +358,7 @@ static int m88e1101_config_aneg(struct phy_device *phydev)
 	return marvell_config_aneg(phydev);
 }
 
-#ifdef CONFIG_OF_MDIO
+#if IS_ENABLED(CONFIG_OF_MDIO)
 /* Set and/or override some configuration registers based on the
  * marvell,reg-init property stored in the of_node for the phydev.
  *
-- 
2.25.1



