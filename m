Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D42F12C992
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728961AbfL2SKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:10:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:51728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730575AbfL2Rnz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:43:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5DE0206DB;
        Sun, 29 Dec 2019 17:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641435;
        bh=4Vep9hp3oIK/uKvc6QvlfrC9Af+IUlNKIaCjStI4rJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bXHlAlModCN0aIbjVXWMnqWYSUpIOBlhgLEzaU4L8XkRYdbsKfZb9/2rbQdCDnngj
         BTZgYozbjLdM0qorMC4zSjk5x7ct7JqEoAyWDcRDnKjadloTruZa0pCfj7dd+BVcPf
         t7uFbIH6CLhBQd9H166PMgHYtVplVRWjqQdMSD4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jayati Sahu <jayati.sahu@samsung.com>,
        Sriram Dash <sriram.dash@samsung.com>,
        Padmanabhan Rajanbabu <p.rajanbabu@samsung.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 025/434] net: stmmac: platform: Fix MDIO init for platforms without PHY
Date:   Sun, 29 Dec 2019 18:21:18 +0100
Message-Id: <20191229172703.767449167@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Padmanabhan Rajanbabu <p.rajanbabu@samsung.com>

[ Upstream commit d3e014ec7d5ebe9644b5486bc530b91e62bbf624 ]

The current implementation of "stmmac_dt_phy" function initializes
the MDIO platform bus data, even in the absence of PHY. This fix
will skip MDIO initialization if there is no PHY present.

Fixes: 7437127 ("net: stmmac: Convert to phylink and remove phylib logic")
Acked-by: Jayati Sahu <jayati.sahu@samsung.com>
Signed-off-by: Sriram Dash <sriram.dash@samsung.com>
Signed-off-by: Padmanabhan Rajanbabu <p.rajanbabu@samsung.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -320,7 +320,7 @@ out:
 static int stmmac_dt_phy(struct plat_stmmacenet_data *plat,
 			 struct device_node *np, struct device *dev)
 {
-	bool mdio = true;
+	bool mdio = false;
 	static const struct of_device_id need_mdio_ids[] = {
 		{ .compatible = "snps,dwc-qos-ethernet-4.10" },
 		{},


