Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18FE83EB76C
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241019AbhHMPIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:08:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241123AbhHMPIc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:08:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5318E6109E;
        Fri, 13 Aug 2021 15:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867285;
        bh=ZvhGvJNzjXWCpSiOHxmHHy8hjNHLrQl0CUUjDzJJ3ZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JOS+uM3aVLFnUKN6yx+wC3jxbxtqyqT5jclnxt+XF3DT4TVLEEpULRNv2k6y6MMSY
         WROWXqPcXn9cpnd2f2mlGTZLpTYXoZyXbPF+YBuA9pOxcUfkpoIVljQKfmY5ZrgGJC
         PjFD8ffRQMo1MOLYwFi46C4f2Sk8wWqB3mYaRe8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 04/25] net: natsemi: Fix missing pci_disable_device() in probe and remove
Date:   Fri, 13 Aug 2021 17:06:28 +0200
Message-Id: <20210813150520.866473423@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150520.718161915@linuxfoundation.org>
References: <20210813150520.718161915@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 7fe74dfd41c428afb24e2e615470832fa997ff14 ]

Replace pci_enable_device() with pcim_enable_device(),
pci_disable_device() and pci_release_regions() will be
called in release automatically.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/natsemi/natsemi.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/natsemi.c b/drivers/net/ethernet/natsemi/natsemi.c
index 122c2ee3dfe2..58527a2ec455 100644
--- a/drivers/net/ethernet/natsemi/natsemi.c
+++ b/drivers/net/ethernet/natsemi/natsemi.c
@@ -817,7 +817,7 @@ static int natsemi_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
 		printk(version);
 #endif
 
-	i = pci_enable_device(pdev);
+	i = pcim_enable_device(pdev);
 	if (i) return i;
 
 	/* natsemi has a non-standard PM control register
@@ -850,7 +850,7 @@ static int natsemi_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ioaddr = ioremap(iostart, iosize);
 	if (!ioaddr) {
 		i = -ENOMEM;
-		goto err_ioremap;
+		goto err_pci_request_regions;
 	}
 
 	/* Work around the dropped serial bit. */
@@ -968,9 +968,6 @@ static int natsemi_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
  err_register_netdev:
 	iounmap(ioaddr);
 
- err_ioremap:
-	pci_release_regions(pdev);
-
  err_pci_request_regions:
 	free_netdev(dev);
 	return i;
@@ -3228,7 +3225,6 @@ static void natsemi_remove1(struct pci_dev *pdev)
 
 	NATSEMI_REMOVE_FILE(pdev, dspcfg_workaround);
 	unregister_netdev (dev);
-	pci_release_regions (pdev);
 	iounmap(ioaddr);
 	free_netdev (dev);
 }
-- 
2.30.2



