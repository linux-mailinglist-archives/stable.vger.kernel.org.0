Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCA6C188C
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbfI2RbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:31:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:41540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729176AbfI2RbK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:31:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38913218DE;
        Sun, 29 Sep 2019 17:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778270;
        bh=jLqHmcGJimG4CepNm67Hh12Os147e/ycQFw2SHlJX8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2wd+74V2eF7NA02zn2lL/FM0KA+Qs9x/jyeXcWsXPjUVsHYf0jrDYlZpHOUDOzTsR
         vCfmk8T6tMcLbwVOeCG+slKdUhHsFO18SwS8XuHomVFo68zgDYS/8k3XaxjHUALeX6
         vrs3LhdG4IYGLdy8A0o976hqe4h1eu99tky4YUzg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nishka Dasgupta <nishkadg.linux@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 07/49] PCI: tegra: Fix OF node reference leak
Date:   Sun, 29 Sep 2019 13:30:07 -0400
Message-Id: <20190929173053.8400-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173053.8400-1-sashal@kernel.org>
References: <20190929173053.8400-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nishka Dasgupta <nishkadg.linux@gmail.com>

[ Upstream commit 9e38e690ace3e7a22a81fc02652fc101efb340cf ]

Each iteration of for_each_child_of_node() executes of_node_put() on the
previous node, but in some return paths in the middle of the loop
of_node_put() is missing thus causing a reference leak.

Hence stash these mid-loop return values in a variable 'err' and add a
new label err_node_put which executes of_node_put() on the previous node
and returns 'err' on failure.

Change mid-loop return statements to point to jump to this label to
fix the reference leak.

Issue found with Coccinelle.

Signed-off-by: Nishka Dasgupta <nishkadg.linux@gmail.com>
[lorenzo.pieralisi@arm.com: rewrote commit log]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-tegra.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/controller/pci-tegra.c b/drivers/pci/controller/pci-tegra.c
index 9a917b2456f6c..673a1725ef382 100644
--- a/drivers/pci/controller/pci-tegra.c
+++ b/drivers/pci/controller/pci-tegra.c
@@ -2237,14 +2237,15 @@ static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
 		err = of_pci_get_devfn(port);
 		if (err < 0) {
 			dev_err(dev, "failed to parse address: %d\n", err);
-			return err;
+			goto err_node_put;
 		}
 
 		index = PCI_SLOT(err);
 
 		if (index < 1 || index > soc->num_ports) {
 			dev_err(dev, "invalid port number: %d\n", index);
-			return -EINVAL;
+			err = -EINVAL;
+			goto err_node_put;
 		}
 
 		index--;
@@ -2253,12 +2254,13 @@ static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
 		if (err < 0) {
 			dev_err(dev, "failed to parse # of lanes: %d\n",
 				err);
-			return err;
+			goto err_node_put;
 		}
 
 		if (value > 16) {
 			dev_err(dev, "invalid # of lanes: %u\n", value);
-			return -EINVAL;
+			err = -EINVAL;
+			goto err_node_put;
 		}
 
 		lanes |= value << (index << 3);
@@ -2272,13 +2274,15 @@ static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
 		lane += value;
 
 		rp = devm_kzalloc(dev, sizeof(*rp), GFP_KERNEL);
-		if (!rp)
-			return -ENOMEM;
+		if (!rp) {
+			err = -ENOMEM;
+			goto err_node_put;
+		}
 
 		err = of_address_to_resource(port, 0, &rp->regs);
 		if (err < 0) {
 			dev_err(dev, "failed to parse address: %d\n", err);
-			return err;
+			goto err_node_put;
 		}
 
 		INIT_LIST_HEAD(&rp->list);
@@ -2330,6 +2334,10 @@ static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
 		return err;
 
 	return 0;
+
+err_node_put:
+	of_node_put(port);
+	return err;
 }
 
 /*
-- 
2.20.1

