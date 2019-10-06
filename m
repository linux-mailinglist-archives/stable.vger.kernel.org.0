Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDB9CCD73E
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbfJFRgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:36:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728594AbfJFRgw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:36:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 999F92077B;
        Sun,  6 Oct 2019 17:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383411;
        bh=OziV/mS8LL+norwroIh4Ev/SnHqGSDWNyykBDI00SGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z6bUwNanSWkh1CnvQZXLIHA+Fos4o371UQsIamAhVdc3yWRRI17WhT65uFne/rbc9
         2FzCr4b2WNJkgsKODyB+O9Wksvm6RUDmYisi1KMqeIYCEp5CY16SGseUCsxhpqkYHk
         zXLhzI4h4Wp37aSb2jj0f5nB8WZixRs5V5LDcrN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nishka Dasgupta <nishkadg.linux@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 095/137] PCI: tegra: Fix OF node reference leak
Date:   Sun,  6 Oct 2019 19:21:19 +0200
Message-Id: <20191006171216.780933880@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171209.403038733@linuxfoundation.org>
References: <20191006171209.403038733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 464ba2538d526..03c42e8684f6d 100644
--- a/drivers/pci/controller/pci-tegra.c
+++ b/drivers/pci/controller/pci-tegra.c
@@ -1994,14 +1994,15 @@ static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
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
@@ -2010,12 +2011,13 @@ static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
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
@@ -2029,13 +2031,15 @@ static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
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
@@ -2062,6 +2066,10 @@ static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
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



