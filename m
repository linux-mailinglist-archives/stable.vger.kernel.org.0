Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7FFA6DE99
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731772AbfGSE3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:29:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729964AbfGSEFg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:05:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5567218BA;
        Fri, 19 Jul 2019 04:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509134;
        bh=KlTkwHCVaS0kL1uz2CRs61DJvawhdf7Km2s1wciG94g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nFcRphWeZXl1KZdXe8v8ZWDGpHJx3ze8qKpwwzZFKhW9EuR8NYv8tgnKH5toZxz5u
         bkP52dgkrQA5rHXOEVy/HlebrF1bgBcrtuLJQE/CNYZkwjfRbOfgncpfztz9pB1j/+
         UzFoXacN9WOnhFdZYQn9slFpVf9NOXPIr6vy/QUY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vidya Sagar <vidyas@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 089/141] PCI: tegra: Enable Relaxed Ordering only for Tegra20 & Tegra30
Date:   Fri, 19 Jul 2019 00:01:54 -0400
Message-Id: <20190719040246.15945-89-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vidya Sagar <vidyas@nvidia.com>

[ Upstream commit 7be142caabc4780b13a522c485abc806de5c4114 ]

The PCI Tegra controller conversion to a device tree configurable
driver in commit d1523b52bff3 ("PCI: tegra: Move PCIe driver
to drivers/pci/host") implied that code for the driver can be
compiled in for a kernel supporting multiple platforms.

Unfortunately, a blind move of the code did not check that some of the
quirks that were applied in arch/arm (eg enabling Relaxed Ordering on
all PCI devices - since the quirk hook erroneously matches PCI_ANY_ID
for both Vendor-ID and Device-ID) are now applied in all kernels that
compile the PCI Tegra controlled driver, DT and ACPI alike.

This is completely wrong, in that enablement of Relaxed Ordering is only
required by default in Tegra20 platforms as described in the Tegra20
Technical Reference Manual (available at
https://developer.nvidia.com/embedded/downloads#?search=tegra%202 in
Section 34.1, where it is mentioned that Relaxed Ordering bit needs to
be enabled in its root ports to avoid deadlock in hardware) and in the
Tegra30 platforms for the same reasons (unfortunately not documented
in the TRM).

There is no other strict requirement on PCI devices Relaxed Ordering
enablement on any other Tegra platforms or PCI host bridge driver.

Fix this quite upsetting situation by limiting the vendor and device IDs
to which the Relaxed Ordering quirk applies to the root ports in
question, reported above.

Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
[lorenzo.pieralisi@arm.com: completely rewrote the commit log/fixes tag]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-tegra.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pci-tegra.c b/drivers/pci/controller/pci-tegra.c
index f4f53d092e00..2e1fd0c07cf1 100644
--- a/drivers/pci/controller/pci-tegra.c
+++ b/drivers/pci/controller/pci-tegra.c
@@ -545,12 +545,15 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0bf1, tegra_pcie_fixup_class);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0e1c, tegra_pcie_fixup_class);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0e1d, tegra_pcie_fixup_class);
 
-/* Tegra PCIE requires relaxed ordering */
+/* Tegra20 and Tegra30 PCIE requires relaxed ordering */
 static void tegra_pcie_relax_enable(struct pci_dev *dev)
 {
 	pcie_capability_set_word(dev, PCI_EXP_DEVCTL, PCI_EXP_DEVCTL_RELAX_EN);
 }
-DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, tegra_pcie_relax_enable);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x0bf0, tegra_pcie_relax_enable);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x0bf1, tegra_pcie_relax_enable);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x0e1c, tegra_pcie_relax_enable);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x0e1d, tegra_pcie_relax_enable);
 
 static int tegra_pcie_request_resources(struct tegra_pcie *pcie)
 {
-- 
2.20.1

