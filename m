Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40F7D10B969
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbfK0Uwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:52:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:40850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728367AbfK0Uwy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:52:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36312218AF;
        Wed, 27 Nov 2019 20:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887972;
        bh=bhdA9kNRhnLawkQQEg6MRHgImVL95/eiUfk8//boD7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YfCvRvSzo3jSq3/95kSIP9bqZ7ZDFZ6OtvIK+25cBVlkrf1VL547UudkZw7V+dvor
         LSuYElIcrWRsM0rr14PDAeFOTu126Do3oFnmmwoPaT5H9so0gerwQ2Xi70tiHCmUFN
         +CqfakojK/omIYyecIs8NqtlJ56ccLYns92Kvf0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 139/211] net: dsa: bcm_sf2: Turn on PHY to allow successful registration
Date:   Wed, 27 Nov 2019 21:31:12 +0100
Message-Id: <20191127203107.145733435@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit c04a17d2a9ccf1eaba1c5a56f83e997540a70556 ]

We are binding to the PHY using the SF2 slave MDIO bus that we create,
binding involves reading the PHY's MII_PHYSID1/2 which won't be possible
if the PHY is turned off. Temporarily turn it on/off for the bus probing
to succeeed. This fixes unbind/bind problems where the port connecting
to that PHY would be in error since it could not connect to it.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/bcm_sf2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 604c5abc08eb8..af666951a9592 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -1196,12 +1196,16 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	bcm_sf2_gphy_enable_set(priv->dev->ds, true);
+
 	ret = bcm_sf2_mdio_register(ds);
 	if (ret) {
 		pr_err("failed to register MDIO bus\n");
 		return ret;
 	}
 
+	bcm_sf2_gphy_enable_set(priv->dev->ds, false);
+
 	ret = bcm_sf2_cfp_rst(priv);
 	if (ret) {
 		pr_err("failed to reset CFP\n");
-- 
2.20.1



