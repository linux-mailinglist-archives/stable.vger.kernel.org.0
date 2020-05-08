Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280C01CADBE
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgEHNEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:04:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728905AbgEHMtJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:49:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1AF721473;
        Fri,  8 May 2020 12:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942148;
        bh=pizm5190yqEzNfwvsx7bXg5xW4jY2Iiy10XBwxmLmXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DcWbVQN36j0VS0GUZLdG9MI52xW4Iss2boT6ddkOxua5ZiXBq7HLrU2ASf/4VlAJz
         3vTWRxY9p4F4bZX9WslWT8RbuCpVTntZoEOXEQSNvBr4WZzLiBijDmxNa6W4bH0oAB
         ebigjr+aZbbfjl17mE7s0lwPpYHWxz7X9CLHReE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 277/312] net: ethernet: mvneta: Remove IFF_UNICAST_FLT which is not implemented
Date:   Fri,  8 May 2020 14:34:28 +0200
Message-Id: <20200508123143.908731565@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

commit 97db8afa2ab919fc400fe982f5054060868bdf07 upstream.

The mvneta driver advertises it supports IFF_UNICAST_FLT. However, it
actually does not. The hardware probably does support it, but there is
no code to configure the filter. As a quick and simple fix, remove the
flag. This will cause the core to fall back to promiscuous mode.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Fixes: b50b72de2f2f ("net: mvneta: enable features before registering the driver")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/marvell/mvneta.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3406,7 +3406,7 @@ static int mvneta_probe(struct platform_
 	dev->features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO;
 	dev->hw_features |= dev->features;
 	dev->vlan_features |= dev->features;
-	dev->priv_flags |= IFF_UNICAST_FLT | IFF_LIVE_ADDR_CHANGE;
+	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 	dev->gso_max_segs = MVNETA_MAX_TSO_SEGS;
 
 	err = register_netdev(dev);


