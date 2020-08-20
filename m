Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C110524B888
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbgHTLXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:23:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730361AbgHTKHS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:07:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D61FF20855;
        Thu, 20 Aug 2020 10:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918038;
        bh=STaAiDozz5Ey94ASQtqCmUMNQiuV/yBML8B1zscPEZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZhUUYCYpNpcWNJnw69jOqvzwjz83BXVpm6PsxYp5oDSu4aay9Yr0nkUtpKxFmsha3
         8xTCQtHhIUM9baPePWXNSBSMw/LOn7XzFPlLT7YzC0rA/XWBec8Cjji5d/OAh6sfyk
         d0knbqajkkcSWhrFXDyC93ugayvYZta/L/5nNCrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Landen Chao <landen.chao@mediatek.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 032/228] net: ethernet: mtk_eth_soc: fix MTU warnings
Date:   Thu, 20 Aug 2020 11:20:07 +0200
Message-Id: <20200820091609.142068878@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Landen Chao <landen.chao@mediatek.com>

[ Upstream commit 555a893303872e044fb86f0a5834ce78d41ad2e2 ]

in recent kernel versions there are warnings about incorrect MTU size
like these:

eth0: mtu greater than device maximum
mtk_soc_eth 1b100000.ethernet eth0: error -22 setting MTU to include DSA overhead

Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
Fixes: 72579e14a1d3 ("net: dsa: don't fail to probe if we couldn't set the MTU")
Fixes: 7a4c53bee332 ("net: report invalid mtu value via netlink extack")
Signed-off-by: Landen Chao <landen.chao@mediatek.com>
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2452,6 +2452,8 @@ static int mtk_add_mac(struct mtk_eth *e
 	eth->netdev[id]->irq = eth->irq[0];
 	eth->netdev[id]->dev.of_node = np;
 
+	eth->netdev[id]->max_mtu = MTK_MAX_RX_LENGTH - MTK_RX_ETH_HLEN;
+
 	return 0;
 
 free_netdev:


