Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86C2C6DCAE
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388104AbfGSEOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:14:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388688AbfGSEOB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:14:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AB2221872;
        Fri, 19 Jul 2019 04:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509640;
        bh=CtIMGofK6vbJ/UInNQ4hzSV0mDxjUM13tvSfz5FMHeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RdW+HhUtAGSu/4YRN2EJcfxeiy9tXmQEhSgS8V0W6GP+OOKWOrib+uJ0PdCi4OeZZ
         PXr5bcc1/zdD8Hti0Yk8VtF7u6YaXht83on2GFD9CPJL6m3gdbrfeDy+dqYh0bkeV8
         11Z4LzrzqJ1yl1FKhKI5xzTAvmdXR0MIbA67ISgw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vidya Sagar <vidyas@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 33/45] PCI: tegra: Enable Relaxed Ordering only for Tegra20 & Tegra30
Date:   Fri, 19 Jul 2019 00:12:52 -0400
Message-Id: <20190719041304.18849-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719041304.18849-1-sashal@kernel.org>
References: <20190719041304.18849-1-sashal@kernel.org>
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
 drivers/pci/host/pci-tegra.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
index 8dfccf733241..6985102a4ae3 100644
--- a/drivers/pci/host/pci-tegra.c
+++ b/drivers/pci/host/pci-tegra.c
@@ -603,12 +603,15 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0bf1, tegra_pcie_fixup_class);
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
 
 static int tegra_pcie_setup(int nr, struct pci_sys_data *sys)
 {
-- 
2.20.1

