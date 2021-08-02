Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54683DD7B6
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234292AbhHBNrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:47:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234239AbhHBNq4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:46:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B38B60FC1;
        Mon,  2 Aug 2021 13:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912006;
        bh=JkSY3ycioVZNLgNmrHqts3OiCAFSHW9Sy0kYi5K4aUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GvNZomNBRgXwCwntjRWEwssXe4H3fcXIGdb0yBFcx22lVr8cBN9p7dUGSNqv4KOMS
         g0Fjw93UzHoL72HySJveULXyQE2JDZa33M9cGKMcVtGzVofoIEMzucKaZrD31m7YDg
         4jtyS3nfNSrq4Oy5EMEDYg8SyoR8rxYVyxioMKY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 25/26] tulip: windbond-840: Fix missing pci_disable_device() in probe and remove
Date:   Mon,  2 Aug 2021 15:44:35 +0200
Message-Id: <20210802134332.845536760@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134332.033552261@linuxfoundation.org>
References: <20210802134332.033552261@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 76a16be07b209a3f507c72abe823bd3af1c8661a ]

Replace pci_enable_device() with pcim_enable_device(),
pci_disable_device() and pci_release_regions() will be
called in release automatically.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/dec/tulip/winbond-840.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/winbond-840.c b/drivers/net/ethernet/dec/tulip/winbond-840.c
index 3c0e4d5c5fef..abc66eb13c35 100644
--- a/drivers/net/ethernet/dec/tulip/winbond-840.c
+++ b/drivers/net/ethernet/dec/tulip/winbond-840.c
@@ -368,7 +368,7 @@ static int w840_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int i, option = find_cnt < MAX_UNITS ? options[find_cnt] : 0;
 	void __iomem *ioaddr;
 
-	i = pci_enable_device(pdev);
+	i = pcim_enable_device(pdev);
 	if (i) return i;
 
 	pci_set_master(pdev);
@@ -390,7 +390,7 @@ static int w840_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ioaddr = pci_iomap(pdev, TULIP_BAR, netdev_res_size);
 	if (!ioaddr)
-		goto err_out_free_res;
+		goto err_out_netdev;
 
 	for (i = 0; i < 3; i++)
 		((__le16 *)dev->dev_addr)[i] = cpu_to_le16(eeprom_read(ioaddr, i));
@@ -469,8 +469,6 @@ static int w840_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 err_out_cleardev:
 	pci_iounmap(pdev, ioaddr);
-err_out_free_res:
-	pci_release_regions(pdev);
 err_out_netdev:
 	free_netdev (dev);
 	return -ENODEV;
@@ -1537,7 +1535,6 @@ static void w840_remove1(struct pci_dev *pdev)
 	if (dev) {
 		struct netdev_private *np = netdev_priv(dev);
 		unregister_netdev(dev);
-		pci_release_regions(pdev);
 		pci_iounmap(pdev, np->base_addr);
 		free_netdev(dev);
 	}
-- 
2.30.2



