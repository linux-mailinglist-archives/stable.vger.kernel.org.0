Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D242F1721
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730249AbhAKNFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:05:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:51666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730236AbhAKNFE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:05:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BE2E2255F;
        Mon, 11 Jan 2021 13:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370288;
        bh=lnIgKExTFNLQC4+UMBirQm1JKZUB0vvXVvSHP64FZfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AgLZ75gtlbym/j6PR//7lSwNferIire44YkeyRDCY0Iz4FIE/P/X7gNRd8nMuFl/2
         1GGz+BXIs8NU44uQl/j3aw00HxZ+j/0qX70tUq5jMKxS+amBi20Ipgd+ljvc9WsYLt
         bw3jVgTksDkyOJbDSM0r212IE9zWtJopGEUVAYuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 14/57] net: ethernet: Fix memleak in ethoc_probe
Date:   Mon, 11 Jan 2021 14:01:33 +0100
Message-Id: <20210111130034.415569565@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130033.715773309@linuxfoundation.org>
References: <20210111130033.715773309@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 5d41f9b7ee7a5a5138894f58846a4ffed601498a ]

When mdiobus_register() fails, priv->mdio allocated
by mdiobus_alloc() has not been freed, which leads
to memleak.

Fixes: e7f4dc3536a4 ("mdio: Move allocation of interrupts into core")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20201223110615.31389-1-dinghao.liu@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ethoc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/ethoc.c
+++ b/drivers/net/ethernet/ethoc.c
@@ -1212,7 +1212,7 @@ static int ethoc_probe(struct platform_d
 	ret = mdiobus_register(priv->mdio);
 	if (ret) {
 		dev_err(&netdev->dev, "failed to register MDIO bus\n");
-		goto free2;
+		goto free3;
 	}
 
 	ret = ethoc_mdio_probe(netdev);
@@ -1244,6 +1244,7 @@ error2:
 	netif_napi_del(&priv->napi);
 error:
 	mdiobus_unregister(priv->mdio);
+free3:
 	mdiobus_free(priv->mdio);
 free2:
 	if (priv->clk)


