Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5F44F7B9E
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbfKKSh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:37:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:56788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728927AbfKKSh6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:37:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63B5321655;
        Mon, 11 Nov 2019 18:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497477;
        bh=5GCfzcw7ifhT8E8I7e5ibBBMHPJ2248k81D41p85pt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VcqYfs25h4kUbpf7jL3MTydf9gfpsBhJo8iRqiZFrp6ZPcAQLgnNwFLPB/9Q7KAqF
         JIGrj8/gSw2UVWGKG99XUCCrPozhHRHJrVKDOTnR+FDgQu9CX0QiQ9eU2pmJ0MMnat
         lkKYfOsK2h9uhQcqNq96yIWzrvdTLqLPZqjrd4bs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vidya Sagar <vidyas@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 4.14 068/105] PCI: tegra: Enable Relaxed Ordering only for Tegra20 & Tegra30
Date:   Mon, 11 Nov 2019 19:28:38 +0100
Message-Id: <20191111181445.561800865@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vidya Sagar <vidyas@nvidia.com>

commit 7be142caabc4780b13a522c485abc806de5c4114 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/host/pci-tegra.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/pci/host/pci-tegra.c
+++ b/drivers/pci/host/pci-tegra.c
@@ -607,12 +607,15 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NV
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


