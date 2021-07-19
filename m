Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9803CE320
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235122AbhGSPgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:36:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231282AbhGSPcJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:32:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C1A261414;
        Mon, 19 Jul 2021 16:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711012;
        bh=usjltRtEuFp8h2ICKIOczpm839/NnubVdwqvLBLU3LI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wla2YdXUk+36zcfGhinFHlHOmRFgFqqUtccBUpIUCqT6FR0xAcDRRSZW0apqbswip
         t39QVv1XlCuJ5a2qPGp9uEOf7z8e7bWcYMyXfJjC9qVAlZj4ABFyOeuQL4qiJ26VQq
         SkbBjArSuaHLQof79tB8xepsIN23lX9lz24qWzPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Robinson <pbrobinson@gmail.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 193/351] PCI: rockchip: Register IRQ handlers after device and data are ready
Date:   Mon, 19 Jul 2021 16:52:19 +0200
Message-Id: <20210719144951.350946995@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f1d08a1b1591..78d04ac29cd5 100644
--- a/drivers/pci/controller/pcie-rockchip-host.c
+++ b/drivers/pci/controller/pcie-rockchip-host.c
@@ -592,10 +592,6 @@ static int rockchip_pcie_parse_host_dt(struct rockchip_pcie *rockchip)
 	if (err)
 		return err;
 
-	err = rockchip_pcie_setup_irq(rockchip);
-	if (err)
-		return err;
-
 	rockchip->vpcie12v = devm_regulator_get_optional(dev, "vpcie12v");
 	if (IS_ERR(rockchip->vpcie12v)) {
 		if (PTR_ERR(rockchip->vpcie12v) != -ENODEV)
@@ -973,8 +969,6 @@ static int rockchip_pcie_probe(struct platform_device *pdev)
 	if (err)
 		goto err_vpcie;
 
-	rockchip_pcie_enable_interrupts(rockchip);
-
 	err = rockchip_pcie_init_irq_domain(rockchip);
 	if (err < 0)
 		goto err_deinit_port;
@@ -992,6 +986,12 @@ static int rockchip_pcie_probe(struct platform_device *pdev)
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



