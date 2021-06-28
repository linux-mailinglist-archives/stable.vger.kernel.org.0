Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB38C3B63C8
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbhF1PA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:00:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235234AbhF1O62 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:58:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D37E61D0E;
        Mon, 28 Jun 2021 14:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891228;
        bh=SRGoeeBhRJlJDujcd418Ov2WR4Du2B9Ixo5AdG4KcKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFkqHcPDNtuTA5vCDQNOH1Sx5RwaCLlfEaeVb0uwAHWWWKvD02xHsQXMEr0dAP0dP
         wAFPoRbPq4smJQlPBstx/IXVxn+U/JcyZKvLKKhTb/cpsofPMkwprJ1enl7pGB3dqu
         Ai7X4DGr/xaMIQGR6IIPHlZynMaC2Gu0pMjBBln5PIxpT+2+vSkv6XelSPrYt+/u00
         4aUR0gr2qtKmS4usSeHX9pZysbyRHXePsxaFnaHdF8lf4ByKhUQs0dX41v1BHTL5SA
         lRYSRnHXCHMMbd7eXOu+n0+9xvlCx/MP9Ec1BR2bK3H0P9GbT54JYbn+INxgckSFx9
         1sfMEc1F196iw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 26/71] qlcnic: Fix an error handling path in 'qlcnic_probe()'
Date:   Mon, 28 Jun 2021 10:39:18 -0400
Message-Id: <20210628144003.34260-27-sashal@kernel.org>
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

[ Upstream commit cb3376604a676e0302258b01893911bdd7aa5278 ]

If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
call, as already done in the remove function.

Fixes: 451724c821c1 ("qlcnic: aer support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 0928da21efd0..19dca845042e 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -2707,6 +2707,7 @@ qlcnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	kfree(ahw);
 
 err_out_free_res:
+	pci_disable_pcie_error_reporting(pdev);
 	pci_release_regions(pdev);
 
 err_out_disable_pdev:
-- 
2.30.2

