Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE486E293
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 10:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbfGSIdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 04:33:18 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:12640 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfGSIdR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jul 2019 04:33:17 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d31804a0000>; Fri, 19 Jul 2019 01:33:14 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 19 Jul 2019 01:33:16 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 19 Jul 2019 01:33:16 -0700
Received: from [10.26.11.13] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 19 Jul
 2019 08:33:13 +0000
Subject: Re: [PATCH AUTOSEL 4.14 41/60] PCI: tegra: Enable Relaxed Ordering
 only for Tegra20 & Tegra30
To:     Sasha Levin <sashal@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC:     Vidya Sagar <vidyas@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        <linux-pci@vger.kernel.org>, <linux-tegra@vger.kernel.org>
References: <20190719041109.18262-1-sashal@kernel.org>
 <20190719041109.18262-41-sashal@kernel.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <838a6940-2a37-b91b-d522-8b154f3c71d7@nvidia.com>
Date:   Fri, 19 Jul 2019 09:33:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190719041109.18262-41-sashal@kernel.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL104.nvidia.com (172.18.146.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1563525194; bh=CwkJNwo9JGuYCI5aA8JqxIET9EXeyG9j+gpHZm57R/Y=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Moc19lNh5h03nmEuBY4iFSpNAAb9lFPjmBNJWY6kFQH23j7JMSDjGnzkRDnsp96bO
         VLc3xNAPIL+qrfep3McCdqnH6vwfkGN6pPn6eJ74VKbBzx32dsGw8WV8uB6shz9IfB
         Z/5XcHfDK7bfYdJOibXEjM8GZE0OsBO+pzLr2Vw+DGcO6nRy/ff2PgEzQa7rWJjRGL
         fTckfVfajLlxAFwM5vS0T2kPB13gXA5kpH7TsfcVWxqCss1z8VDKznPOdyfVKFQKCj
         W+Ttx5syfoHl5jth/0hyiilWOCRSzlgkpTloeeoM9KPdYYSWQ/Cpy9EPVBJl7BOlFR
         2t2r07zlFsLNQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Lorenzo,

We have not requested that this is added to stable yet, however, has
been picked up. Do we wish to let it soak in mainline for a release
first? If so maybe we can ask Sasha to drop this for now.

Cheers
Jon

On 19/07/2019 05:10, Sasha Levin wrote:
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
> 

-- 
nvpublic
