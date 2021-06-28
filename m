Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADC03B6289
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236390AbhF1OsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:48:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235058AbhF1OoK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:44:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A61861CFE;
        Mon, 28 Jun 2021 14:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890834;
        bh=b9MMu8XBLWrujxp3HO9gdNcY7HbRGRKoWMDkOUhTSWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R/c3ud6mA1G18tcdJiDRBLUNMK42demcnxGpblOaKcwVDYZhLKHg6Sky/PSEsDkzZ
         I3Cj2wWboeVeuGhWSs9GMiVDcU+CST4ef0hUb4jowDkZWfAPTOt8Hv8GqOBfYEa2xW
         DDYuYTOGi4TgFEV9G3i5DaGRsJpbfQMQmhZKp8ce0itBMmBWGPzJnYC1PSO4uRc+5i
         T0fgg//lyXV+4jdI2YQxmz+zSB0D51O4oFQiD7MlxDNwxzuRNM1BCbikNRvqIK+A4i
         B4UfObdRl3GQ1kLyi6eQpK1EYaSAsNOwGDQvE/1oKuxEh6vTnCYTRYzKlIw6tsB73E
         GgDZAO5BYZ+Bw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 053/109] net: ethernet: fix potential use-after-free in ec_bhf_remove
Date:   Mon, 28 Jun 2021 10:32:09 -0400
Message-Id: <20210628143305.32978-54-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
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
index d71cba0842c5..59dc20020c73 100644
--- a/drivers/net/ethernet/ec_bhf.c
+++ b/drivers/net/ethernet/ec_bhf.c
@@ -585,10 +585,12 @@ static void ec_bhf_remove(struct pci_dev *dev)
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

