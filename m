Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054CD3B626C
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234602AbhF1Org (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:47:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234827AbhF1OmN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:42:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E949B61CE8;
        Mon, 28 Jun 2021 14:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890823;
        bh=THz0LVY2wJia1LqifYXa/uGhV7AAA/g2jwRYhJV/w34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NWvBY2rlzaMltmfgBiP3kL9lCbeKj7qIOdTiZL5DM/mMGXEiQkXsvX4xjWkpijnHB
         ne7hxOJCHUduj3ERQp1+WHvEuVwDmdLrUFdOnW5/CqejgNOpvDNuUJdbwnSn2hUq/V
         kfSP/v5PQU4Sqce5CnOxh8G2WRUnu76NrrZNkdSOQu858nIR/o/D7KNqXlqM5SJYnG
         g3Ta8XRsNmAd6dwGmnbatvxh6dBnzRsbrf0xJA3z5xd/ukF6nKvOraYQT7u33Y3eQR
         ltS9Wp/1FHH0NHz6PGZ1m63cDqEgtfqMDCOgnK+Uah66pmABqsW98pr+h9itqgJDZB
         mJltg6Qjgd6ig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 040/109] netxen_nic: Fix an error handling path in 'netxen_nic_probe()'
Date:   Mon, 28 Jun 2021 10:31:56 -0400
Message-Id: <20210628143305.32978-41-sashal@kernel.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 49a10c7b176295f8fafb338911cf028e97f65f4d ]

If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
call, as already done in the remove function.

Fixes: e87ad5539343 ("netxen: support pci error handlers")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 42b99b182616..a331ad406e7a 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -1618,6 +1618,8 @@ netxen_nic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	free_netdev(netdev);
 
 err_out_free_res:
+	if (NX_IS_REVISION_P3(pdev->revision))
+		pci_disable_pcie_error_reporting(pdev);
 	pci_release_regions(pdev);
 
 err_out_disable_pdev:
-- 
2.30.2

