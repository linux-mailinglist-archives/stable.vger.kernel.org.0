Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9A53B63C4
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbhF1PAZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:00:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235008AbhF1O6P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:58:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A67D61CD0;
        Mon, 28 Jun 2021 14:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891226;
        bh=iVPNNFL1NmmQcqh1lXvw62DPBuN1pr/HXtCYEjfrhL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bXHOuDwKLLdMe0lHaeyQO4pmMmUNXaq8GwtT0KUR7DM+M5gC8bDxTUZXNccHi64SG
         /1q6MjDgYmCw1L9nqj/yvRw0tJD3TBtnq6p0WOFK/g9mCYT8iN0NVN5UYbEL7FYFVs
         n9nPoZ0xeibDs+qym5DDexgzTDu7Fi3b56EUha+FWfXW7SKmJe2GXe8G3G/B2h2A8I
         lo7csxYo4JJ8xUhgNjoTxJX/ysKt7bpr9C2mhNMdMF2XTKBImARcUWB/xzy+W5nEcj
         w0R7K0BtLhTZQmlQ//8Z0zy+z3X4wY9Z2qvyhLXKa7elkARAMm38cDfWgScGO7dq3o
         MHWbfVu8+mWkA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 24/71] alx: Fix an error handling path in 'alx_probe()'
Date:   Mon, 28 Jun 2021 10:39:16 -0400
Message-Id: <20210628144003.34260-25-sashal@kernel.org>
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

[ Upstream commit 33e381448cf7a05d76ac0b47d4a6531ecd0e5c53 ]

If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
call, as already done in the remove function.

Fixes: ab69bde6b2e9 ("alx: add a simple AR816x/AR817x device driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/atheros/alx/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 9de0f9f5b11c..59af298f99e0 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1653,6 +1653,7 @@ static int alx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	free_netdev(netdev);
 out_pci_release:
 	pci_release_mem_regions(pdev);
+	pci_disable_pcie_error_reporting(pdev);
 out_pci_disable:
 	pci_disable_device(pdev);
 	return err;
-- 
2.30.2

