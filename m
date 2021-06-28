Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922A33B63CA
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234391AbhF1PAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:00:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235240AbhF1O62 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:58:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6206061D4D;
        Mon, 28 Jun 2021 14:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891228;
        bh=dbwtvw43FfxVeS5GEwXlil/V7Gggzt+mq5HXtzcBMFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cqvJHOd+ulwRPuz9nbx2psPBsUEJjVqkzeuU3p9BXEvIgNkCQWVqoyQrNOx+lrmUt
         P8v/VlCwlKzDVFVn0+lU37esFcXPxiyjAZO9gf2xuMJq6WiO1yUJsO1c8E1TnbtE/0
         TjtBRG1n6ULoVxu8R9ni/IJED1EgLKbgCaHffC/UnufEpnoxrEzxcX1mE8H9Tf1Afl
         +mEdG6wvQFKhd4KuivfiTzANwXEREZvwE8ykGeFGuno4U0OjQJMHILmLHhqvjOiLqo
         6T9K+yezm/EtdGjyEQ1En+7Ut/JASJqXk6zkYMhcxWCg6YGB4HR4K/Aqeh+TtrTxru
         YHXoqG2Etx87w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 27/71] netxen_nic: Fix an error handling path in 'netxen_nic_probe()'
Date:   Mon, 28 Jun 2021 10:39:19 -0400
Message-Id: <20210628144003.34260-28-sashal@kernel.org>
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
index a5ee3d328f3d..75e25a3fe4a7 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -1617,6 +1617,8 @@ netxen_nic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	free_netdev(netdev);
 
 err_out_free_res:
+	if (NX_IS_REVISION_P3(pdev->revision))
+		pci_disable_pcie_error_reporting(pdev);
 	pci_release_regions(pdev);
 
 err_out_disable_pdev:
-- 
2.30.2

