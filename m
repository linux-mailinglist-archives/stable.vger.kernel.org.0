Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51D75F745B
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 13:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfKKMy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 07:54:59 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:5520 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbfKKMy7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 07:54:59 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dc959ea0000>; Mon, 11 Nov 2019 04:54:02 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 11 Nov 2019 04:54:58 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 11 Nov 2019 04:54:58 -0800
Received: from [10.25.73.138] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 11 Nov
 2019 12:54:56 +0000
X-Nvconfidentiality: public
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, Jon Hunter <jonathanh@nvidia.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
From:   Vidya Sagar <vidyas@nvidia.com>
Subject: stable request: PCI: tegra: Enable Relaxed Ordering only for Tegra20
 & Tegra30
Message-ID: <11251eb0-5675-9d3d-d15f-c346781e2bff@nvidia.com>
Date:   Mon, 11 Nov 2019 18:24:53 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573476842; bh=+xw4RHjDS36gzKO4cmauOeRZWAtADr2G+vHfvheD29M=;
        h=X-PGP-Universal:X-Nvconfidentiality:To:CC:From:Subject:Message-ID:
         Date:User-Agent:MIME-Version:X-Originating-IP:X-ClientProxiedBy:
         Content-Type:Content-Language:Content-Transfer-Encoding;
        b=kprFEHosLLlHlXcJ4SLvTlzfuXUgike9IfAMT2B6FH2Zq51IftOVYqwjE6RarZ6SL
         Jld+hd7gQ8eLsq5swVpmRvcDJDGXYPMWI4MjbN9aVYIxNJpZTAieRphv2ALeH3Atb4
         hqJ4grZD2E6DqW+AsY3hLRIXYSbjpwPMTZk5VvY8++wlWod3y0RNDjAvYyjveH3wKV
         eZViBnpKzvXZrQrGaqeog/H9x+OnQKiY5tZ4zJCSct/dyWzT24lxAbcbd6Wnij/K1I
         dU0cCIaJecFc+Kw8c3GOA7iasx4Bnchcx442jjU3AMdivBLDegEMThtp3xw+wGJOIn
         AykiT/wSXuOow==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,
We noticed that the Tegra PCIe host controller driver enabled
"Relaxed Ordering" bit in the PCIe configuration space for "all"
devices erroneously. We pushed a fix for this through the
commit: 7be142caabc4780b13a522c485abc806de5c4114 and it has been
soaking in main line for the last four months.
Based on the discussion we had @ http://patchwork.ozlabs.org/patch/1127604/
we would now like to push it to the following stable kernels
4.19                  : Applies cleanly
3.16, 4.4, 4.9 & 4.14 : Following equivalent patch needs to be used as the
                         file was at drivers/pci/host/pci-tegra.c earlier
                         (and moved to drivers/pci/controller/pci-tegra.c starting 4.19)

---
  drivers/pci/host/pci-tegra.c | 7 +++++--
  1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
index 083cf37ca047..56daa83b041c 100644
--- a/drivers/pci/host/pci-tegra.c
+++ b/drivers/pci/host/pci-tegra.c
@@ -615,12 +615,15 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0bf1, tegra_pcie_fixup_class);
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
2.17.1
