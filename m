Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351733E810D
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234476AbhHJRzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:55:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236140AbhHJRws (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:52:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BAEB60295;
        Tue, 10 Aug 2021 17:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617412;
        bh=8T2v0KABr0EE4NnSDFDGDvowLI6RwHuQleLbm1JGzvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AiSgiqtA6IPNYcWUz39eCszXupiXMz8qkkBsp1r4VOV+L40OMoGS04ndSMWu4b5lI
         2ZB8dyeHq/Fig2Rkq0kpk+e5JymtiLNHmphTfLhR1bQ1ROhNytBUXiPgRk+Xdk9MHf
         F3o9d+jVpbrEDgVgFx05Zs5+I+pCNrPRzyaV5Lys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 047/175] net: natsemi: Fix missing pci_disable_device() in probe and remove
Date:   Tue, 10 Aug 2021 19:29:15 +0200
Message-Id: <20210810173002.496902370@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
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
index b81e1487945c..14a17ad730f0 100644
--- a/drivers/net/ethernet/natsemi/natsemi.c
+++ b/drivers/net/ethernet/natsemi/natsemi.c
@@ -819,7 +819,7 @@ static int natsemi_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
 		printk(version);
 #endif
 
-	i = pci_enable_device(pdev);
+	i = pcim_enable_device(pdev);
 	if (i) return i;
 
 	/* natsemi has a non-standard PM control register
@@ -852,7 +852,7 @@ static int natsemi_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ioaddr = ioremap(iostart, iosize);
 	if (!ioaddr) {
 		i = -ENOMEM;
-		goto err_ioremap;
+		goto err_pci_request_regions;
 	}
 
 	/* Work around the dropped serial bit. */
@@ -974,9 +974,6 @@ static int natsemi_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
  err_register_netdev:
 	iounmap(ioaddr);
 
- err_ioremap:
-	pci_release_regions(pdev);
-
  err_pci_request_regions:
 	free_netdev(dev);
 	return i;
@@ -3241,7 +3238,6 @@ static void natsemi_remove1(struct pci_dev *pdev)
 
 	NATSEMI_REMOVE_FILE(pdev, dspcfg_workaround);
 	unregister_netdev (dev);
-	pci_release_regions (pdev);
 	iounmap(ioaddr);
 	free_netdev (dev);
 }
-- 
2.30.2



