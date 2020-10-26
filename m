Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553E029A0AB
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409470AbgJ0AcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:32:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409444AbgJZXvd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:51:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D036521BE5;
        Mon, 26 Oct 2020 23:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756292;
        bh=qse8Jdit7YfvkAFgGFWXFvn9m3z3WgltMsv2M44bNIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2HzBqa6/JTOeGRFnjeY4rpGi5P9N8q9W+ihUwAIgJgFwJk26H7n/GB8Dvkh3MBo+M
         3vTFB8ZCoxvlEJg1768PjcR9qNW42hUjnOrnbN329FTdZVAoNwq/LXzfCqb2Xt1y8O
         bbpJQxDI2hlq0DeSNj/1fz5ttsUFZMUVMQdU2jDs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 120/147] PCI: dwc: Add link up check in dw_child_pcie_ops.map_bus()
Date:   Mon, 26 Oct 2020 19:48:38 -0400
Message-Id: <20201026234905.1022767-120-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>

[ Upstream commit 15b23906347c0af8778d1d4edeea415290342d35 ]

NXP Layerscape (ls1028a, ls2088a), dra7xxx and imx6 platforms are either
programmed or statically configured to forward the error triggered by a
link-down state (eg no connected endpoint device) on the system bus for
PCI configuration transactions; these errors are reported as an SError
at system level, which is fatal.

Enumerating a PCI tree when the PCIe link is down is not sensible
either, so even if the link-up check is racy (link can go down after
map_bus() is called) add a link-up check in map_bus() to prevent issuing
configuration transactions when the link is down.

SError report:

 SError Interrupt on CPU2, code 0xbf000002 -- SError
 CPU: 2 PID: 1 Comm: swapper/0 Not tainted 5.9.0-rc5-next-20200914-00001-gf965d3ec86fa #67
 Hardware name: LS1046A RDB Board (DT)
 pstate: 20000085 (nzCv daIf -PAN -UAO BTYPE=--)
 pc : pci_generic_config_read+0x3c/0xe0
 lr : pci_generic_config_read+0x24/0xe0
 sp : ffff80001003b7b0
 x29: ffff80001003b7b0 x28: ffff80001003ba74
 x27: ffff000971d96800 x26: ffff00096e77e0a8
 x25: ffff80001003b874 x24: ffff80001003b924
 x23: 0000000000000004 x22: 0000000000000000
 x21: 0000000000000000 x20: ffff80001003b874
 x19: 0000000000000004 x18: ffffffffffffffff
 x17: 00000000000000c0 x16: fffffe0025981840
 x15: ffffb94c75b69948 x14: 62203a383634203a
 x13: 666e6f635f726568 x12: 202c31203d207265
 x11: 626d756e3e2d7375 x10: 656877202c307830
 x9 : 203d206e66766564 x8 : 0000000000000908
 x7 : 0000000000000908 x6 : ffff800010900000
 x5 : ffff00096e77e080 x4 : 0000000000000000
 x3 : 0000000000000003 x2 : 84fa3440ff7e7000
 x1 : 0000000000000000 x0 : ffff800010034000
 Kernel panic - not syncing: Asynchronous SError Interrupt
 CPU: 2 PID: 1 Comm: swapper/0 Not tainted 5.9.0-rc5-next-20200914-00001-gf965d3ec86fa #67
 Hardware name: LS1046A RDB Board (DT)
 Call trace:
  dump_backtrace+0x0/0x1c0
  show_stack+0x18/0x28
  dump_stack+0xd8/0x134
  panic+0x180/0x398
  add_taint+0x0/0xb0
  arm64_serror_panic+0x78/0x88
  do_serror+0x68/0x180
  el1_error+0x84/0x100
  pci_generic_config_read+0x3c/0xe0
  dw_pcie_rd_other_conf+0x78/0x110
  pci_bus_read_config_dword+0x88/0xe8
  pci_bus_generic_read_dev_vendor_id+0x30/0x1b0
  pci_bus_read_dev_vendor_id+0x4c/0x78
  pci_scan_single_device+0x80/0x100

Link: https://lore.kernel.org/r/20200916054130.8685-1-Zhiqiang.Hou@nxp.com
Signed-off-by: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
[lorenzo.pieralisi@arm.com: rewrote the commit log, remove Fixes tag]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-host.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
index 9dafecba347f0..bbffaa98729fb 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -515,6 +515,17 @@ static int dw_pcie_access_other_conf(struct pcie_port *pp, struct pci_bus *bus,
 	void __iomem *va_cfg_base;
 	struct dw_pcie *pci = to_dw_pcie_from_pp(pp);
 
+	/*
+	 * Checking whether the link is up here is a last line of defense
+	 * against platforms that forward errors on the system bus as
+	 * SError upon PCI configuration transactions issued when the link
+	 * is down. This check is racy by definition and does not stop
+	 * the system from triggering an SError if the link goes down
+	 * after this check is performed.
+	 */
+	if (!dw_pcie_link_up(pci))
+		return NULL;
+
 	busdev = PCIE_ATU_BUS(bus->number) | PCIE_ATU_DEV(PCI_SLOT(devfn)) |
 		 PCIE_ATU_FUNC(PCI_FUNC(devfn));
 
-- 
2.25.1

