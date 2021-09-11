Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D48540773E
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236017AbhIKNPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:15:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236525AbhIKNOM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:14:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC83661244;
        Sat, 11 Sep 2021 13:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631365964;
        bh=mv/mgaHOnkOGkztlyC9ZkuUY8ikq0GtV8Y8kFRFjK9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NNrrlmbOR4InkFUeQjVkyPK79fRW9usvtmqeFdpD1KMFakDSLFuwhBdFtcd1lK9fh
         njvy8Wj5smMTHjRVi52X1W86rzGFICE2EXt7kHIyN9EdaLkLQVacHotB3AdNqK3cLS
         9PQp1nni369QH4XbOOIcUgADLAS6jWdrsM1xup94ZC3kYvY/Vp50Jp0B2c9iExH/XP
         0yUbRJ8h8hwA3m/DOMmW94v3xohOeGV/fpyNg8cmtAl9AUqRuTMjfR5V6dcK3Cbz0Q
         mm4v9DblYbql2wi6DvLYTZdKX6fvQXNcBX0rDQuq0AwKeVrjLOdUqJ/i6e7437DBtP
         fPL7w8zn1zWog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 08/29] PCI: tegra: Fix OF node reference leak
Date:   Sat, 11 Sep 2021 09:12:12 -0400
Message-Id: <20210911131233.284800-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131233.284800-1-sashal@kernel.org>
References: <20210911131233.284800-1-sashal@kernel.org>
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

