Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACE93B6444
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234806AbhF1PGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:06:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235862AbhF1PES (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:04:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8F4961CED;
        Mon, 28 Jun 2021 14:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891396;
        bh=8i3hAnIS9kUl7gH0PEVMlwORpKYUoGqM9NZPTnOfrj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rzcjEihEh16VC98idHN+eV5v2lhPilettckrDVX0bcJXfARBVj7WCtIVla8y3Ye/Y
         TFsagWWan7bLkGuxTcFb7n7Q859/TCXmIYhjCpXpTIYI05aF1QbbcoElIxfl/jZRXC
         5xcWWmsXrtLRPlm21OZVYB0GqM+f65L1w6zb+cCTT6R9fDpC0ZcrELW+YGHkssmuYh
         mww/WUhJcEM3oe5OLFcCGVSgMiK5aNkNjCrbnZA73qXt/y5owZTeBLbIslu+Ivl/Xp
         qMu9OpZAWOBAh2DlrgnbDO4jzIZ4T1R05j1mKbGBjzMFa1jXSWyrHpJr0evRM/UcBb
         WjQTrvOdB1uPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 21/57] netxen_nic: Fix an error handling path in 'netxen_nic_probe()'
Date:   Mon, 28 Jun 2021 10:42:20 -0400
Message-Id: <20210628144256.34524-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
References: <20210628144256.34524-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:42+00:00
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
index f5fc0c416e51..f89441f9bd8d 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -1616,6 +1616,8 @@ err_out_free_netdev:
 	free_netdev(netdev);
 
 err_out_free_res:
+	if (NX_IS_REVISION_P3(pdev->revision))
+		pci_disable_pcie_error_reporting(pdev);
 	pci_release_regions(pdev);
 
 err_out_disable_pdev:
-- 
2.30.2

