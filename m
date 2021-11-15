Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B2745149A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244975AbhKOUKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:10:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:45398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344822AbhKOTZe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 525DD636D0;
        Mon, 15 Nov 2021 19:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003096;
        bh=uaHD+LvuPo7bRxbxm2rQJYilBcs8/qgDugmjycUS0/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KOicbccZn7RatK85ahQXXoMgmkpuOK/4mlEuS+31uCAI5XtikrRi5HxBbdBZ4cOPv
         MR7B0RBEeQolH/Lefp+zZsI8MUr+GMMWzQPIXcjzYFgw6HB3NpP0kQ8ZH365GBMzN7
         iDpinkoElOa86GiyMNMbRBNGC2/7IPXZAzD0CNyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 777/917] PCI: j721e: Fix j721e_pcie_probe() error path
Date:   Mon, 15 Nov 2021 18:04:32 +0100
Message-Id: <20211115165455.290446907@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 496bb18483cc0474913e81e18a6b313aaea4c120 ]

If an error occurs after a successful cdns_pcie_init_phy() call, it must be
undone by a cdns_pcie_disable_phy() call, as already done above and below.

Update the goto to branch at the correct place of the error handling path.

Link: https://lore.kernel.org/r/db477b0cb444891a17c4bb424467667dc30d0bab.1624794264.git.christophe.jaillet@wanadoo.fr
Fixes: 49e0efdce791 ("PCI: j721e: Add support to provide refclk to PCIe connector")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Krzysztof Wilczyński <kw@linux.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pci-j721e.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/cadence/pci-j721e.c b/drivers/pci/controller/cadence/pci-j721e.c
index ffb176d288cd9..918e11082e6a7 100644
--- a/drivers/pci/controller/cadence/pci-j721e.c
+++ b/drivers/pci/controller/cadence/pci-j721e.c
@@ -474,7 +474,7 @@ static int j721e_pcie_probe(struct platform_device *pdev)
 		ret = clk_prepare_enable(clk);
 		if (ret) {
 			dev_err(dev, "failed to enable pcie_refclk\n");
-			goto err_get_sync;
+			goto err_pcie_setup;
 		}
 		pcie->refclk = clk;
 
-- 
2.33.0



