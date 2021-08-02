Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A46383DD9F2
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234854AbhHBOFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:05:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236389AbhHBOEK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:04:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEF6C61029;
        Mon,  2 Aug 2021 13:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912664;
        bh=RpHi/N2fpE+anUQgI6rQ0fkw0FuwGVwHthESk42mFLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OrNZInCVNvFdi+heKdMNFxqsOm9BGOYjSNUK5EYsYGkdbMRygszlbIbP3OdBY95I1
         De50HRjw4Mi1AAtvPLDGenoltvTJ+OdlbJr71lnSe62j+GM493khgJzz1e71oKDwx7
         CFtgCJZgALS5KbNiRi5DFxPvCylU3NpvoEWXcGPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 088/104] tulip: windbond-840: Fix missing pci_disable_device() in probe and remove
Date:   Mon,  2 Aug 2021 15:45:25 +0200
Message-Id: <20210802134346.914025849@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
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
index 514df170ec5d..c967e0e859e5 100644
--- a/drivers/net/ethernet/dec/tulip/winbond-840.c
+++ b/drivers/net/ethernet/dec/tulip/winbond-840.c
@@ -357,7 +357,7 @@ static int w840_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int i, option = find_cnt < MAX_UNITS ? options[find_cnt] : 0;
 	void __iomem *ioaddr;
 
-	i = pci_enable_device(pdev);
+	i = pcim_enable_device(pdev);
 	if (i) return i;
 
 	pci_set_master(pdev);
@@ -379,7 +379,7 @@ static int w840_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ioaddr = pci_iomap(pdev, TULIP_BAR, netdev_res_size);
 	if (!ioaddr)
-		goto err_out_free_res;
+		goto err_out_netdev;
 
 	for (i = 0; i < 3; i++)
 		((__le16 *)dev->dev_addr)[i] = cpu_to_le16(eeprom_read(ioaddr, i));
@@ -458,8 +458,6 @@ static int w840_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 err_out_cleardev:
 	pci_iounmap(pdev, ioaddr);
-err_out_free_res:
-	pci_release_regions(pdev);
 err_out_netdev:
 	free_netdev (dev);
 	return -ENODEV;
@@ -1526,7 +1524,6 @@ static void w840_remove1(struct pci_dev *pdev)
 	if (dev) {
 		struct netdev_private *np = netdev_priv(dev);
 		unregister_netdev(dev);
-		pci_release_regions(pdev);
 		pci_iounmap(pdev, np->base_addr);
 		free_netdev(dev);
 	}
-- 
2.30.2



