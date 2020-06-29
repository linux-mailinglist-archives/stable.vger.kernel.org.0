Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC6E20DC75
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730424AbgF2UPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:15:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732820AbgF2TaR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10EAE251EC;
        Mon, 29 Jun 2020 15:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444909;
        bh=GT2VB5Iqd6Zk1iaUTAJN6eBdprg2RUo19uhmtJmufp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zDatoSSaIU5rMUil7BBYc7jvGSo1As0zTyXTmGF5ZVr4n6Pf7nFZ1xiRzR2WNU3Dg
         vk2ZupmapWbSh9MBk5gmbZOqZ0XonC+MeAY6iL2Wm/+XDJLV29tx9jxWSaEm8nQFA6
         rxbUfEbiJ3/CtxHBBL8FuZzKsogncfabwB9ozlKA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Doug Berger <opendmb@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 005/131] net: bcmgenet: remove HFB_CTRL access
Date:   Mon, 29 Jun 2020 11:32:56 -0400
Message-Id: <20200629153502.2494656-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit 24d476db6dfb0f85130e348ca1bbd14afb73a8be ]

Commit c5a54bbcecec ("net: bcmgenet: abort suspend on error")
mistakenly introduced register accesses that should not occur
in bcmgenet_wol_power_up_cfg().

Fixes: c5a54bbcecec ("net: bcmgenet: abort suspend on error")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index b3596e0ee47ba..57582efa362df 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -191,10 +191,6 @@ void bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
 	reg &= ~MPD_EN;
 	bcmgenet_umac_writel(priv, reg, UMAC_MPD_CTRL);
 
-	reg = bcmgenet_hfb_reg_readl(priv, HFB_CTRL);
-	reg &= ~(RBUF_HFB_EN | RBUF_ACPI_EN);
-	bcmgenet_hfb_reg_writel(priv, reg, HFB_CTRL);
-
 	/* Disable CRC Forward */
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
 	reg &= ~CMD_CRC_FWD;
-- 
2.25.1

