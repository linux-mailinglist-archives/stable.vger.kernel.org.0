Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93917266648
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgIKRY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:24:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbgIKNAK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 09:00:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A862D2226B;
        Fri, 11 Sep 2020 12:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828984;
        bh=p6uNEAiri0OzZ1/93DJ8TG7PHf9aP2bTZ9/fkANWS+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dtIucj3oT+uGOUyKrsmjO3eHGI0wnfDvIrph9x32EzR6KjODliT92FgTt10PR3tIL
         OguleYa+I1ndlGerWxDKLNOVBMZVECGn9AHFSMdta3DRfiq0uCyOH3db5U6bYVMhdd
         mkoztpB+fEytdUpFyBJBhFAkqmgWA35mdIlGZiwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 20/71] net: arc_emac: Fix memleak in arc_mdio_probe
Date:   Fri, 11 Sep 2020 14:46:04 +0200
Message-Id: <20200911122505.949211751@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122504.928931589@linuxfoundation.org>
References: <20200911122504.928931589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit e2d79cd8875fa8c3cc7defa98a8cc99a1ed0c62f ]

When devm_gpiod_get_optional() fails, bus should be
freed just like when of_mdiobus_register() fails.

Fixes: 1bddd96cba03d ("net: arc_emac: support the phy reset for emac driver")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/arc/emac_mdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/arc/emac_mdio.c b/drivers/net/ethernet/arc/emac_mdio.c
index a22403c688c95..337cfce78aef2 100644
--- a/drivers/net/ethernet/arc/emac_mdio.c
+++ b/drivers/net/ethernet/arc/emac_mdio.c
@@ -152,6 +152,7 @@ int arc_mdio_probe(struct arc_emac_priv *priv)
 	if (IS_ERR(data->reset_gpio)) {
 		error = PTR_ERR(data->reset_gpio);
 		dev_err(priv->dev, "Failed to request gpio: %d\n", error);
+		mdiobus_free(bus);
 		return error;
 	}
 
-- 
2.25.1



