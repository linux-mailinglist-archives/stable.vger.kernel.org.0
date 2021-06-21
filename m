Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183653AEFFD
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbhFUQoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:44:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233065AbhFUQl7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:41:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10BDE613FA;
        Mon, 21 Jun 2021 16:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293073;
        bh=GPZlmCmG5Ozv64hMj2PJFVS6AWHaoBhOPRTJYmhJWpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t4hT1p1ITPhjQW8B58ecr+0T3ppxqXjgeQ32mBgwawhevsdXZFWNkrr0SoJ2ws0OM
         yDigHdtGswYl5KiiYWRqpD9tbP1LQ5yyif9CcJQjKbqsKolS9olJDEgJ/orlgWoO/Q
         Ab+1uXu53Iz+W9TBZHtau5eaHdLWAZc8gLrXMxmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 087/178] net: ethernet: fix potential use-after-free in ec_bhf_remove
Date:   Mon, 21 Jun 2021 18:15:01 +0200
Message-Id: <20210621154925.632311036@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 9cca0c2d70149160407bda9a9446ce0c29b6e6c6 ]

static void ec_bhf_remove(struct pci_dev *dev)
{
...
	struct ec_bhf_priv *priv = netdev_priv(net_dev);

	unregister_netdev(net_dev);
	free_netdev(net_dev);

	pci_iounmap(dev, priv->dma_io);
	pci_iounmap(dev, priv->io);
...
}

priv is netdev private data, but it is used
after free_netdev(). It can cause use-after-free when accessing priv
pointer. So, fix it by moving free_netdev() after pci_iounmap()
calls.

Fixes: 6af55ff52b02 ("Driver for Beckhoff CX5020 EtherCAT master module.")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ec_bhf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ec_bhf.c b/drivers/net/ethernet/ec_bhf.c
index 46b0dbab8aad..7c992172933b 100644
--- a/drivers/net/ethernet/ec_bhf.c
+++ b/drivers/net/ethernet/ec_bhf.c
@@ -576,10 +576,12 @@ static void ec_bhf_remove(struct pci_dev *dev)
 	struct ec_bhf_priv *priv = netdev_priv(net_dev);
 
 	unregister_netdev(net_dev);
-	free_netdev(net_dev);
 
 	pci_iounmap(dev, priv->dma_io);
 	pci_iounmap(dev, priv->io);
+
+	free_netdev(net_dev);
+
 	pci_release_regions(dev);
 	pci_clear_master(dev);
 	pci_disable_device(dev);
-- 
2.30.2



