Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F94D2F15DD
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731320AbhAKNLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:11:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:58192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731316AbhAKNLD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:11:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBEEC22795;
        Mon, 11 Jan 2021 13:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370622;
        bh=FUy1xwRMw7YqWPft1kH5bPHMQ2sY+SKXfSX4oqJwuJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fV5ceLXKdALJxp7cFlA9eOd9uylqQUIPdMBsMAO673UMfJV1SYm/NDXOZXEiQN165
         oDMCXIeeEFOM3TAqHJp79fkoJHb0BYK7goy86UyIqHR4Pz4Emsawr0GJ+jHtwUlEj+
         EU/4bmwKR6FwwnNLQ+MW1ZzNaDKC+tZklkdjP+mY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 25/92] net: ethernet: Fix memleak in ethoc_probe
Date:   Mon, 11 Jan 2021 14:01:29 +0100
Message-Id: <20210111130040.359268434@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
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
@@ -1207,7 +1207,7 @@ static int ethoc_probe(struct platform_d
 	ret = mdiobus_register(priv->mdio);
 	if (ret) {
 		dev_err(&netdev->dev, "failed to register MDIO bus\n");
-		goto free2;
+		goto free3;
 	}
 
 	ret = ethoc_mdio_probe(netdev);
@@ -1239,6 +1239,7 @@ error2:
 	netif_napi_del(&priv->napi);
 error:
 	mdiobus_unregister(priv->mdio);
+free3:
 	mdiobus_free(priv->mdio);
 free2:
 	clk_disable_unprepare(priv->clk);


