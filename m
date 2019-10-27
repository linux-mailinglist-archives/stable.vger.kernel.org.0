Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E69AE65C6
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbfJ0VFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:05:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728750AbfJ0VFB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:05:01 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 497E5214AF;
        Sun, 27 Oct 2019 21:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210300;
        bh=IsBStTCkeWmqdWA0ZgIgVTI6Qu3UtzZL3iN49SUkrIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jUr9QWqOwcSoS7doCv7aixMMTIs4J6nwD+GtneZcNMJCP0iaicEf7Akkkrjd5SSG5
         1o7gVAeH+1WIAaFatjc6N1i7VE8Rvt64DN9m9BS2HF9T/hOJ+1cJRAlxGzjLaZfCdG
         rZDa2Or7qts1awQq6XIRFmZ+atqbKU2wq9cYMlB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 18/49] net: bcmgenet: Set phydev->dev_flags only for internal PHYs
Date:   Sun, 27 Oct 2019 22:00:56 +0100
Message-Id: <20191027203133.052186421@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203119.468466356@linuxfoundation.org>
References: <20191027203119.468466356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 92696286f3bb37ba50e4bd8d1beb24afb759a799 ]

phydev->dev_flags is entirely dependent on the PHY device driver which
is going to be used, setting the internal GENET PHY revision in those
bits only makes sense when drivers/net/phy/bcm7xxx.c is the PHY driver
being used.

Fixes: 487320c54143 ("net: bcmgenet: communicate integrated PHY revision to PHY driver")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -346,11 +346,12 @@ int bcmgenet_mii_probe(struct net_device
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct device_node *dn = priv->pdev->dev.of_node;
 	struct phy_device *phydev;
-	u32 phy_flags;
+	u32 phy_flags = 0;
 	int ret;
 
 	/* Communicate the integrated PHY revision */
-	phy_flags = priv->gphy_rev;
+	if (priv->internal_phy)
+		phy_flags = priv->gphy_rev;
 
 	/* Initialize link state variables that bcmgenet_mii_setup() uses */
 	priv->old_link = -1;


