Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4850933B78D
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhCOOAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:00:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229828AbhCON7U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 228BE64F43;
        Mon, 15 Mar 2021 13:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816741;
        bh=50Xuy5NzZD7iZ5ddL4wtXPxtTC/vFPC95KHHeKUGfEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qNHAsHSiG9pnlO6AYUyMLfaNtru+ANdMerV4e86uzPsmx7gZm7F2bxXzmG9Gelcxf
         mhaoS1rIMlPKKNALh9HRr0G32IA6GPjF2YpNKDyPofkJjAa1bV03JTFpitBCopj4Fy
         mUVML5BcFXxS72fwbNhseRPwt/1myFAVknBuvsg8=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 079/168] PCI: mediatek: Add missing of_node_put() to fix reference leak
Date:   Mon, 15 Mar 2021 14:55:11 +0100
Message-Id: <20210315135552.989774904@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
index 626a7c352dfd..728a59655825 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -1063,14 +1063,14 @@ static int mtk_pcie_setup(struct mtk_pcie *pcie)
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
@@ -1086,6 +1086,9 @@ static int mtk_pcie_setup(struct mtk_pcie *pcie)
 		mtk_pcie_subsys_powerdown(pcie);
 
 	return 0;
+error_put_node:
+	of_node_put(child);
+	return err;
 }
 
 static int mtk_pcie_probe(struct platform_device *pdev)
-- 
2.30.1



