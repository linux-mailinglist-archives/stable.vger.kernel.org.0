Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2F735F8E6
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 18:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbhDNQYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 12:24:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233385AbhDNQYd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 12:24:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7369B610E6;
        Wed, 14 Apr 2021 16:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618417451;
        bh=Q/fhaOsYAxGrm1f3bVFX328dWe5mUr0miHfundS2aQA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g1yhmRsN+/jmpmyEr5e1YRkKuKuTCnj7umQUtufzonQB8VfPQ0rMymeufvxXLlopY
         qpuU6oEyKVxJ3DQdTxOeXHI7QicjVR1LkDqASGuUPJP75EZtEJGxCWcqyFMwdVQr4i
         PC1eczEW7p4nKY13UKuir9QRfhxpvOd0B8mMwmWvVjwnGBsaX0s0/36E4aKyhs9QrH
         EUvrJUHiOYSyqciwhE3HtVm2q8Sc7yzZp+gBXM8wTMz6nNtYo6uUfV0BufIFADjjXx
         K7gtZIuKPYDPAFFYOAsfwSGDINlJEyIyAdm7WesVQXiE8VPphcVZpNVEoL+FGy/7Sf
         0BLf3IRJ854HA==
Date:   Wed, 14 Apr 2021 09:24:08 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Prike Liang <Prike.Liang@amd.com>
Cc:     linux-nvme@lists.infradead.org, Chaitanya.Kulkarni@wdc.com,
        gregkh@linuxfoundation.org, hch@infradead.org,
        stable@vger.kernel.org, Shyam-sundar.S-k@amd.com,
        Alexander.Deucher@amd.com
Subject: Re: [PATCH 2/2] nvme-pci: add AMD PCIe quirk for suspend/resume
Message-ID: <20210414162408.GC2448507@dhcp-10-100-145-180.wdc.com>
References: <1618388281-15629-1-git-send-email-Prike.Liang@amd.com>
 <1618388281-15629-2-git-send-email-Prike.Liang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1618388281-15629-2-git-send-email-Prike.Liang@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 14, 2021 at 04:18:01PM +0800, Prike Liang wrote:
> The NVME device pluged in some AMD PCIE root port will resume timeout
> from s2idle which caused by NVME power CFG lost in the SMU FW restore.
> This issue can be workaround by using PCIe power set with simple
> suspend/resume process path instead of APST. In the onwards ASIC will
> try do the NVME shutdown save and restore in the BIOS and still need
> PCIe power setting to resume from RTD3 for s2idle.
> 
> Update the nvme_acpi_storage_d3() _with previously added quirk.
> 
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> [ck: split patches for nvme and pcie]

Chaitanya's Sign-off should be under the annotation explaining what he
changed, and placed below the original author's sign-off.

> Signed-off-by: Prike Liang <Prike.Liang@amd.com>
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> Cc: <stable@vger.kernel.org> # 5.11+
> ---

It doesn't appear that you're reading Greg's autobot reply. This spot
right here is where you should describe what is different about this
patch compared to your previous versions.

>  drivers/nvme/host/pci.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> index 6bad4d4..ce9f42b 100644
> --- a/drivers/nvme/host/pci.c
> +++ b/drivers/nvme/host/pci.c
> @@ -2832,6 +2832,7 @@ static bool nvme_acpi_storage_d3(struct pci_dev *dev)
>  {
>  	struct acpi_device *adev;
>  	struct pci_dev *root;
> +	struct pci_dev *rdev;
>  	acpi_handle handle;
>  	acpi_status status;
>  	u8 val;
> @@ -2845,6 +2846,12 @@ static bool nvme_acpi_storage_d3(struct pci_dev *dev)
>  	if (!root)
>  		return false;
>  
> +	rdev = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0, 0));

Instead of assuming '0', shouldn't you use the domain of the NVMe PCI
device?
