Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842683CA922
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241379AbhGOTF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:05:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243369AbhGOTEU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:04:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34ECC613FE;
        Thu, 15 Jul 2021 19:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375600;
        bh=p4UoKnK//5jgto48d8wuORtdCGB0SzO6Zsdb0CdF16A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qa9m4TY0tbBcAomjWEczHOrLRIKQxh/TTQOLV7POqRbo09JJyo8qkq4CSEylAI0qc
         TJO8znbvGw8ld0YSM/ia/fLBU/l/lTWLq/71qMrd1IhRjIRzpSyLBdYXM3emxYYECW
         0OA2yvZdkhHLjD/qRrcxNklrYkziGwqhqibl05Es=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.12 154/242] PCI: tegra194: Fix host initialization during resume
Date:   Thu, 15 Jul 2021 20:38:36 +0200
Message-Id: <20210715182620.324770673@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vidya Sagar <vidyas@nvidia.com>

commit c4bf1f25c6c187864681d5ad4dd1fa92f62d5d32 upstream.

Commit 275e88b06a27 ("PCI: tegra: Fix host link initialization") broke
host initialization during resume as it misses out calling the API
dw_pcie_setup_rc() which is required for host and MSI initialization.

Link: https://lore.kernel.org/r/20210504172157.29712-1-vidyas@nvidia.com
Fixes: 275e88b06a27 ("PCI: tegra: Fix host link initialization")
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/controller/dwc/pcie-tegra194.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -2214,6 +2214,8 @@ static int tegra_pcie_dw_resume_noirq(st
 		goto fail_host_init;
 	}
 
+	dw_pcie_setup_rc(&pcie->pci.pp);
+
 	ret = tegra_pcie_dw_start_link(&pcie->pci);
 	if (ret < 0)
 		goto fail_host_init;


