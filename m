Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2603B63CC
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235215AbhF1PAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235258AbhF1O63 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:58:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95D0F61C98;
        Mon, 28 Jun 2021 14:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891233;
        bh=7BcuhJM5XCOcma3ZPzVTwN+deEmpdKyNgHYmAG325p4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XV+b8fWPyGHmY+jf0WLBHdTEoph1dZObpdahvnKEPKuGP9fgw8U4iTpWiUYNLwzWF
         kmRJn9IO+Bff00vziFCSVXz/BmjCbKIAtLkYkkKKCHuuN7jXo1FYnJcasFPKlmREkx
         D6uu6b5uXcWfDy4WNplJAMfRILRHHLy0V9zm0B90dXNfX2FT1inGPWxJJXCpd6yPls
         W3drgVwcH0xsxft1hu9s/GCFD/4mO552/JH8jr9krIkxULE6+A69+UdXXZuuecpU0H
         dFhkT22FnvolATTJblsR25w5hioemIDt6RhghA7mXzlUxtFVUiuVXaNLM4AdedQwz+
         5kfid425YMgNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 32/71] be2net: Fix an error handling path in 'be_probe()'
Date:   Mon, 28 Jun 2021 10:39:24 -0400
Message-Id: <20210628144003.34260-33-sashal@kernel.org>
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
index 289560b0f643..b0b9f77c3740 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -5998,6 +5998,7 @@ static int be_probe(struct pci_dev *pdev, const struct pci_device_id *pdev_id)
 unmap_bars:
 	be_unmap_pci_bars(adapter);
 free_netdev:
+	pci_disable_pcie_error_reporting(pdev);
 	free_netdev(netdev);
 rel_reg:
 	pci_release_regions(pdev);
-- 
2.30.2

