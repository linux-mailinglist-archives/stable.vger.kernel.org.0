Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55594076B3
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235963AbhIKNNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:13:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235934AbhIKNNN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:13:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17404611C3;
        Sat, 11 Sep 2021 13:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631365920;
        bh=mv/mgaHOnkOGkztlyC9ZkuUY8ikq0GtV8Y8kFRFjK9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ln+F5Qq6bsKUFO2CZ1TIUztKQ2gPBgKG6nPvAji88Kz2kXTaMjC4Ldiipaxf5o1qo
         X0kGp1cOTVjcWxjbxI5YKRLO9zgTnFZgXqkiifhJXnukmia+JfxtlqPRAeQ0Sb9dbB
         okxHMdyDa1JUHrH7RBUjF+SGSCeSgUtTFlfcNvYpQ8FXSWia7edoHQFAaaSnAwbuB7
         wKnzmBzm+Z53yYdFssRiQp4WgdSZcKiNIQn0HnBkP2+WQOPFyugigo2+R66ARDg1Hm
         u5OpK9LA9ZLO7o+8S52Z45N7bRMWrOWoemUzwW8AV5DMJpUlsSZ0aNmdVj6NqP02R2
         O8qJUmgmlf8Dw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 08/32] PCI: tegra: Fix OF node reference leak
Date:   Sat, 11 Sep 2021 09:11:25 -0400
Message-Id: <20210911131149.284397-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131149.284397-1-sashal@kernel.org>
References: <20210911131149.284397-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit eff21f5da308265678e7e59821795e606f3e560f ]

Commit 9e38e690ace3 ("PCI: tegra: Fix OF node reference leak") has fixed
some node reference leaks in this function but missed some of them.

In fact, having 'port' referenced in the 'rp' structure is not enough to
prevent the leak, until 'rp' is actually added in the 'pcie->ports' list.

Add the missing 'goto err_node_put' accordingly.

Link: https://lore.kernel.org/r/55b11e9a7fa2987fbc0869d68ae59888954d65e2.1620148539.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-tegra.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/controller/pci-tegra.c b/drivers/pci/controller/pci-tegra.c
index c979229a6d0d..b358212d71ab 100644
--- a/drivers/pci/controller/pci-tegra.c
+++ b/drivers/pci/controller/pci-tegra.c
@@ -2193,13 +2193,15 @@ static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
 		rp->np = port;
 
 		rp->base = devm_pci_remap_cfg_resource(dev, &rp->regs);
-		if (IS_ERR(rp->base))
-			return PTR_ERR(rp->base);
+		if (IS_ERR(rp->base)) {
+			err = PTR_ERR(rp->base);
+			goto err_node_put;
+		}
 
 		label = devm_kasprintf(dev, GFP_KERNEL, "pex-reset-%u", index);
 		if (!label) {
-			dev_err(dev, "failed to create reset GPIO label\n");
-			return -ENOMEM;
+			err = -ENOMEM;
+			goto err_node_put;
 		}
 
 		/*
@@ -2217,7 +2219,8 @@ static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
 			} else {
 				dev_err(dev, "failed to get reset GPIO: %ld\n",
 					PTR_ERR(rp->reset_gpio));
-				return PTR_ERR(rp->reset_gpio);
+				err = PTR_ERR(rp->reset_gpio);
+				goto err_node_put;
 			}
 		}
 
-- 
2.30.2

