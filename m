Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1123B63D2
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235681AbhF1PAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:00:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235299AbhF1O6b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:58:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F82E61D56;
        Mon, 28 Jun 2021 14:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891235;
        bh=Ok7+7P5uVmCeXlsCb3ow4rcZgX1YVa/zI41DWx7KL58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zm6v+8DOO0qgZLbnF1/k66yd+Iea4VYfDlkqublF8RsHK8vGNcLk8f1qKURyBPE9s
         NpaE6L5SUMkCWhjTN0hwxFsRiIxL22MXHunpOc/KUmGwj2+KDQW8vcsEvNYGTLNcHa
         5n8ZSeZgQWGYuBK5TmGAk1kxfs6C5P+DZ371H4ajW0Q5RX90dg9r2yL3T7TgwiLa1U
         OLYcZpJoJTu7HFukmAYGtLwJvv0L6c2MVDCxWOM9vI0p7DgUgJnZ0lQyglWxqEHCHm
         LgUBbGt7UxrL9oYSuBguJ4sHTpmBFXtCgx2hYoJ3kDC5E6EQpLomcPLB5txzCQMd9O
         i+SmbAsXMrBxA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 35/71] net: ethernet: fix potential use-after-free in ec_bhf_remove
Date:   Mon, 28 Jun 2021 10:39:27 -0400
Message-Id: <20210628144003.34260-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144003.34260-1-sashal@kernel.org>
References: <20210628144003.34260-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
index f7b42483921c..0ade0c6d81ee 100644
--- a/drivers/net/ethernet/ec_bhf.c
+++ b/drivers/net/ethernet/ec_bhf.c
@@ -589,10 +589,12 @@ static void ec_bhf_remove(struct pci_dev *dev)
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

