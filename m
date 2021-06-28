Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526293B6325
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235846AbhF1Owx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:52:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235463AbhF1Ous (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:50:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C27F61D29;
        Mon, 28 Jun 2021 14:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891022;
        bh=qFoW+Lily5SAupUVjLvebr411IbgZAEne0xEraeU3G8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BspyajOrj3teJ73rJSSk1QtO9gfOwmmln5cx1UYAhY0hCIrfisUQYKVAo0Ql7ZITr
         2N/KzT8vxd0YGQnGRftJyCeN58WXo2vagHD1Wfm4ZQbdsksiNNYdVJcbdZ6CS+IM+p
         GhH5ify+HAwqbMzoHB/rCTP7jeuHCzMb4s+6i+Wcij9g+K2NdvOFkeJbhc4+OYbAta
         +5oNJtAL8YNHNA6dkpK1427+A7i2dal4LgohbpNMJ4mRSpHHUJf5PnkwcVI0SkIvCR
         93G4pm4AJea3l/VFXtvEUgCATlmRjmkQwBpi/K9fwGFHBtilJ4haU82k7xDx802/1Z
         UXfHleBX4ItXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 36/88] be2net: Fix an error handling path in 'be_probe()'
Date:   Mon, 28 Jun 2021 10:35:36 -0400
Message-Id: <20210628143628.33342-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit c19c8c0e666f9259e2fc4d2fa4b9ff8e3b40ee5d ]

If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
call, as already done in the remove function.

Fixes: d6b6d9877878 ("be2net: use PCIe AER capability")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/emulex/benet/be_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index cabeb1790db7..43ae124cabff 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -5926,6 +5926,7 @@ static int be_probe(struct pci_dev *pdev, const struct pci_device_id *pdev_id)
 unmap_bars:
 	be_unmap_pci_bars(adapter);
 free_netdev:
+	pci_disable_pcie_error_reporting(pdev);
 	free_netdev(netdev);
 rel_reg:
 	pci_release_regions(pdev);
-- 
2.30.2

