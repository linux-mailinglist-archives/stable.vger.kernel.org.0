Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B3C261A01
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbgIHS3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:29:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731409AbgIHQKZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:10:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1277424806;
        Tue,  8 Sep 2020 15:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579799;
        bh=yVzu16jkR+ZSizyDraX6CgN0pG7oqdVsMdzwGZ9bSn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gqpp2pvCKDpLa1Hac3KUTeDfadwHIgNa3wFim4k1Z66aXhcorGMUvqM0UD9THtjPp
         4Klk6UbZGtRZ+gh+ra8JGWxIMFnpdKfsK9mEOac2X+9p2vVbVRJonYVRE5SpWNaEEs
         jP/W+XEHV30tqQkAyYQZP83+BPDGh9aLl63JMUY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 038/129] net: arc_emac: Fix memleak in arc_mdio_probe
Date:   Tue,  8 Sep 2020 17:24:39 +0200
Message-Id: <20200908152231.581109549@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
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
index 0187dbf3b87df..54cdafdd067db 100644
--- a/drivers/net/ethernet/arc/emac_mdio.c
+++ b/drivers/net/ethernet/arc/emac_mdio.c
@@ -153,6 +153,7 @@ int arc_mdio_probe(struct arc_emac_priv *priv)
 	if (IS_ERR(data->reset_gpio)) {
 		error = PTR_ERR(data->reset_gpio);
 		dev_err(priv->dev, "Failed to request gpio: %d\n", error);
+		mdiobus_free(bus);
 		return error;
 	}
 
-- 
2.25.1



