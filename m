Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0205532AF3C
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236829AbhCCAQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:16:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:44708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1446823AbhCBMNg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:13:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FD2B64F67;
        Tue,  2 Mar 2021 11:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686244;
        bh=CJV9PpAHviZMj39pAEuKP1GuYA+C66vTtIS8NgAL4GM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LeLjfzf/Fjufw+gnUsMFywDYTRC4AHVl9SXWU2UBPjnO62n42anx8Ij27pHTkUmjm
         6Hk+Rmmu8FwBM60jXt+XaW7kB71U/1qiKBYuiUkkFnOqz9cl1RdQevUEp6rX+dOWlJ
         CBnidYi/4i7ZjDUn2+F0pOVN0DqJl+PhER3NdnWwxK6Vr8O3l5/PCm7QV9mDrR8ttG
         9fgvlLRrASMKna29zFqLczSMYM26e2KPZ037tO9jQLkTLcLI6VIscIF3sGlnN6Zldu
         8tLo30L2scYRD2rj+ousSkDa8xz1WVdzc6sZdhKmAmagqU5JsfJUJl2aOPel3gHO7s
         bdcLuvyg1pF7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 30/47] PCI: mediatek: Add missing of_node_put() to fix reference leak
Date:   Tue,  2 Mar 2021 06:56:29 -0500
Message-Id: <20210302115646.62291-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115646.62291-1-sashal@kernel.org>
References: <20210302115646.62291-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Wilczyński <kw@linux.com>

[ Upstream commit 42814c438aac79746d310f413a27d5b0b959c5de ]

The for_each_available_child_of_node helper internally makes use of the
of_get_next_available_child() which performs an of_node_get() on each
iteration when searching for next available child node.

Should an available child node be found, then it would return a device
node pointer with reference count incremented, thus early return from
the middle of the loop requires an explicit of_node_put() to prevent
reference count leak.

To stop the reference leak, explicitly call of_node_put() before
returning after an error occurred.

Link: https://lore.kernel.org/r/20210120184810.3068794-1-kw@linux.com
Signed-off-by: Krzysztof Wilczyński <kw@linux.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mediatek.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pcie-mediatek.c b/drivers/pci/controller/pcie-mediatek.c
index cf4c18f0c25a..23548b517e4b 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -1035,14 +1035,14 @@ static int mtk_pcie_setup(struct mtk_pcie *pcie)
 		err = of_pci_get_devfn(child);
 		if (err < 0) {
 			dev_err(dev, "failed to parse devfn: %d\n", err);
-			return err;
+			goto error_put_node;
 		}
 
 		slot = PCI_SLOT(err);
 
 		err = mtk_pcie_parse_port(pcie, child, slot);
 		if (err)
-			return err;
+			goto error_put_node;
 	}
 
 	err = mtk_pcie_subsys_powerup(pcie);
@@ -1058,6 +1058,9 @@ static int mtk_pcie_setup(struct mtk_pcie *pcie)
 		mtk_pcie_subsys_powerdown(pcie);
 
 	return 0;
+error_put_node:
+	of_node_put(child);
+	return err;
 }
 
 static int mtk_pcie_probe(struct platform_device *pdev)
-- 
2.30.1

