Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74E4C199191
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731673AbgCaJNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:13:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731737AbgCaJNw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:13:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DEA820772;
        Tue, 31 Mar 2020 09:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646032;
        bh=DgDqi8cEBElxJzK0lL7sf2xDwK9UfCXAY8lCEVZWOWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p6PoSbW5Dtlt1WcSlVAJUSJTixYp/5DQjheQJ6lPbeeCtdnyz6u5IuOSAO+IHDT+o
         urOYoaenXeBL6QiP04c+5Bvqc+0RZpCCuBLi7WMk1FysvOA0WJ+vY+5N6/WXWUqIMG
         tuMaIlgBxFcNQozjUpgIjM010ElIrmoyMqgN3vdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 024/155] net: phy: mdio-bcm-unimac: Fix clock handling
Date:   Tue, 31 Mar 2020 10:57:44 +0200
Message-Id: <20200331085421.099034328@linuxfoundation.org>
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

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit c312c7818b86b663d32ec5d4b512abf06b23899a ]

The DT binding for this PHY describes an *optional* clock property.
Due to a bug in the error handling logic, we are actually ignoring this
clock *all* of the time so far.

Fix this by using devm_clk_get_optional() to handle this clock properly.

Fixes: b78ac6ecd1b6b ("net: phy: mdio-bcm-unimac: Allow configuring MDIO clock divider")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/mdio-bcm-unimac.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/phy/mdio-bcm-unimac.c
+++ b/drivers/net/phy/mdio-bcm-unimac.c
@@ -242,11 +242,9 @@ static int unimac_mdio_probe(struct plat
 		return -ENOMEM;
 	}
 
-	priv->clk = devm_clk_get(&pdev->dev, NULL);
-	if (PTR_ERR(priv->clk) == -EPROBE_DEFER)
+	priv->clk = devm_clk_get_optional(&pdev->dev, NULL);
+	if (IS_ERR(priv->clk))
 		return PTR_ERR(priv->clk);
-	else
-		priv->clk = NULL;
 
 	ret = clk_prepare_enable(priv->clk);
 	if (ret)


