Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6392206311
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388901AbgFWUQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:16:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388390AbgFWUQH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:16:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C25B020EDD;
        Tue, 23 Jun 2020 20:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943367;
        bh=6RzejahLlQrgdvaRPrW8GQkygqnCDz26sEXC25Ezzs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/37c8F5XuQFjnAx3KJXEAQapH5rZCGZ/fDdkk2lPSb67z8maDPoMO/tmsdzLI69c
         sTtjf/5+O8PIQ8uNQPt8MdCssABxOX6qYR1+S+1a0dLxMnQcmvsGjk964J5CR0lNxf
         G4XRLMlz0r3udOPJ0zjr16SzlM3LqywCEw77Zh6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 337/477] net: marvell: Fix OF_MDIO config check
Date:   Tue, 23 Jun 2020 21:55:34 +0200
Message-Id: <20200623195423.470746470@linuxfoundation.org>
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
index 7fc8e10c5f337..a435f7352cfb0 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -337,7 +337,7 @@ static int m88e1101_config_aneg(struct phy_device *phydev)
 	return marvell_config_aneg(phydev);
 }
 
-#ifdef CONFIG_OF_MDIO
+#if IS_ENABLED(CONFIG_OF_MDIO)
 /* Set and/or override some configuration registers based on the
  * marvell,reg-init property stored in the of_node for the phydev.
  *
-- 
2.25.1



