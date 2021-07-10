Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF36C3C385B
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbhGJXyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:54:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233501AbhGJXxz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:53:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E58D2613E0;
        Sat, 10 Jul 2021 23:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961061;
        bh=N5eJoTF0ViH2kJuzZiUhRZNc/Voul3eL5qnXxBEUhno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rqpk5y8STynGzkyDnq/K818q/6pHUTB+L4+2sRu+hEGULdjMF2wa1Tmq2ALHgAKZz
         BaRaEfrrdYn9FHD1UPZuhJfjI1fPvY/6PW1AexgTdmNmlfI1gBZKCulwWjjSbwwYWl
         +PekKf3KRkEgQUBNDKv+OB2pOYWE29brWpR+xWLqKNOoWxPgbvw04hpmBMLXvDRl+t
         QRhnDYaW+Z+AO/BBAH48fLzmEKQnxI0N+oS4X84xq2l8uS9wvPZK0ZOqhNJ5DhWZ6m
         wfZ0cOL8tkt8IsD7TYWclPoTeGRqXisSj7koDW2155NBjvxozZ5WMHULH2tj2obz8p
         dZie9VwQbI0SA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Javier Martinez Canillas <javierm@redhat.com>,
        Peter Robinson <pbrobinson@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 33/37] PCI: rockchip: Register IRQ handlers after device and data are ready
Date:   Sat, 10 Jul 2021 19:50:11 -0400
Message-Id: <20210710235016.3221124-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235016.3221124-1-sashal@kernel.org>
References: <20210710235016.3221124-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javier Martinez Canillas <javierm@redhat.com>

[ Upstream commit 3cf5f7ab230e2b886e493c7a8449ed50e29d2b98 ]

An IRQ handler may be called at any time after it is registered, so
anything it relies on must be ready before registration.

rockchip_pcie_subsys_irq_handler() and rockchip_pcie_client_irq_handler()
read registers in the PCIe controller, but we registered them before
turning on clocks to the controller.  If either is called before the clocks
are turned on, the register reads fail and the machine hangs.

Similarly, rockchip_pcie_legacy_int_handler() uses rockchip->irq_domain,
but we installed it before initializing irq_domain.

Register IRQ handlers after their data structures are initialized and
clocks are enabled.

Found by enabling CONFIG_DEBUG_SHIRQ, which calls the IRQ handler when it
is being unregistered.  An error during the probe path might cause this
unregistration and IRQ handler execution before the device or data
structure init has finished.

[bhelgaas: commit log]
Link: https://lore.kernel.org/r/20210608080409.1729276-1-javierm@redhat.com
Reported-by: Peter Robinson <pbrobinson@gmail.com>
Tested-by: Peter Robinson <pbrobinson@gmail.com>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Shawn Lin <shawn.lin@rock-chips.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rockchip-host.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/controller/pcie-rockchip-host.c b/drivers/pci/controller/pcie-rockchip-host.c
index 9705059523a6..0d6df73bb918 100644
--- a/drivers/pci/controller/pcie-rockchip-host.c
+++ b/drivers/pci/controller/pcie-rockchip-host.c
@@ -593,10 +593,6 @@ static int rockchip_pcie_parse_host_dt(struct rockchip_pcie *rockchip)
 	if (err)
 		return err;
 
-	err = rockchip_pcie_setup_irq(rockchip);
-	if (err)
-		return err;
-
 	rockchip->vpcie12v = devm_regulator_get_optional(dev, "vpcie12v");
 	if (IS_ERR(rockchip->vpcie12v)) {
 		if (PTR_ERR(rockchip->vpcie12v) != -ENODEV)
@@ -974,8 +970,6 @@ static int rockchip_pcie_probe(struct platform_device *pdev)
 	if (err)
 		goto err_vpcie;
 
-	rockchip_pcie_enable_interrupts(rockchip);
-
 	err = rockchip_pcie_init_irq_domain(rockchip);
 	if (err < 0)
 		goto err_deinit_port;
@@ -993,6 +987,12 @@ static int rockchip_pcie_probe(struct platform_device *pdev)
 	bridge->sysdata = rockchip;
 	bridge->ops = &rockchip_pcie_ops;
 
+	err = rockchip_pcie_setup_irq(rockchip);
+	if (err)
+		goto err_remove_irq_domain;
+
+	rockchip_pcie_enable_interrupts(rockchip);
+
 	err = pci_host_probe(bridge);
 	if (err < 0)
 		goto err_remove_irq_domain;
-- 
2.30.2

