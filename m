Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D30C6E6E2
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 15:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728538AbfGSNxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 09:53:21 -0400
Received: from foss.arm.com ([217.140.110.172]:43684 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbfGSNxU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 09:53:20 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C78B4337;
        Fri, 19 Jul 2019 06:53:19 -0700 (PDT)
Received: from e121166-lin.cambridge.arm.com (unknown [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C394F3F71A;
        Fri, 19 Jul 2019 06:53:18 -0700 (PDT)
Date:   Fri, 19 Jul 2019 14:53:09 +0100
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vidya Sagar <vidyas@nvidia.com>,
        Thierry Reding <treding@nvidia.com>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.14 41/60] PCI: tegra: Enable Relaxed Ordering
 only for Tegra20 & Tegra30
Message-ID: <20190719135301.GA685@e121166-lin.cambridge.arm.com>
References: <20190719041109.18262-1-sashal@kernel.org>
 <20190719041109.18262-41-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190719041109.18262-41-sashal@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 19, 2019 at 12:10:50AM -0400, Sasha Levin wrote:
> From: Vidya Sagar <vidyas@nvidia.com>
> 
> [ Upstream commit 7be142caabc4780b13a522c485abc806de5c4114 ]
> 
> The PCI Tegra controller conversion to a device tree configurable
> driver in commit d1523b52bff3 ("PCI: tegra: Move PCIe driver
> to drivers/pci/host") implied that code for the driver can be
> compiled in for a kernel supporting multiple platforms.
> 
> Unfortunately, a blind move of the code did not check that some of the
> quirks that were applied in arch/arm (eg enabling Relaxed Ordering on
> all PCI devices - since the quirk hook erroneously matches PCI_ANY_ID
> for both Vendor-ID and Device-ID) are now applied in all kernels that
> compile the PCI Tegra controlled driver, DT and ACPI alike.
> 
> This is completely wrong, in that enablement of Relaxed Ordering is only
> required by default in Tegra20 platforms as described in the Tegra20
> Technical Reference Manual (available at
> https://developer.nvidia.com/embedded/downloads#?search=tegra%202 in
> Section 34.1, where it is mentioned that Relaxed Ordering bit needs to
> be enabled in its root ports to avoid deadlock in hardware) and in the
> Tegra30 platforms for the same reasons (unfortunately not documented
> in the TRM).
> 
> There is no other strict requirement on PCI devices Relaxed Ordering
> enablement on any other Tegra platforms or PCI host bridge driver.
> 
> Fix this quite upsetting situation by limiting the vendor and device IDs
> to which the Relaxed Ordering quirk applies to the root ports in
> question, reported above.
> 
> Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
> [lorenzo.pieralisi@arm.com: completely rewrote the commit log/fixes tag]
> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Acked-by: Thierry Reding <treding@nvidia.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Hi Sasha,

as Jon requested, please drop this patch from the autosel patch
queue, thank you very much.

Lorenzo

> ---
>  drivers/pci/host/pci-tegra.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
> index 1987fec1f126..d2ad76ef3e83 100644
> --- a/drivers/pci/host/pci-tegra.c
> +++ b/drivers/pci/host/pci-tegra.c
> @@ -607,12 +607,15 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0bf1, tegra_pcie_fixup_class);
>  DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0e1c, tegra_pcie_fixup_class);
>  DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0e1d, tegra_pcie_fixup_class);
>  
> -/* Tegra PCIE requires relaxed ordering */
> +/* Tegra20 and Tegra30 PCIE requires relaxed ordering */
>  static void tegra_pcie_relax_enable(struct pci_dev *dev)
>  {
>  	pcie_capability_set_word(dev, PCI_EXP_DEVCTL, PCI_EXP_DEVCTL_RELAX_EN);
>  }
> -DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, tegra_pcie_relax_enable);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x0bf0, tegra_pcie_relax_enable);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x0bf1, tegra_pcie_relax_enable);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x0e1c, tegra_pcie_relax_enable);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, 0x0e1d, tegra_pcie_relax_enable);
>  
>  static int tegra_pcie_request_resources(struct tegra_pcie *pcie)
>  {
> -- 
> 2.20.1
> 
