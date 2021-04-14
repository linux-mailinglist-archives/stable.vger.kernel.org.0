Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF0935ED47
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 08:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbhDNGkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 02:40:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233455AbhDNGj5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 02:39:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C91D7613D4;
        Wed, 14 Apr 2021 06:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618382375;
        bh=GMFz/FIdj2tlORcbNu56F0SLGNpw8QFajqOz94BYLII=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v6m8a7Cb8DYbT3ZWEtxfpdS1uzHpslejPe9BTKjXvjZbwPEvXF9pL0je+ydvqEeUw
         GWYjjJMkEMFh22Un76I8iKZpXQllnGlbOIHQG5/GEynrejKTa+cCnMhsJXFd7+D7De
         MuRL9afbH0AYt09iZo/+g7ZMggUZmm/dfQDDLNcI=
Date:   Wed, 14 Apr 2021 08:39:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Prike Liang <Prike.Liang@amd.com>
Cc:     linux-nvme@lists.infradead.org, kbusch@kernel.org,
        Chaitanya.Kulkarni@wdc.com, hch@infradead.org,
        Shyam-sundar.S-k@amd.com, Alexander.Deucher@amd.com,
        "# 5 . 11+" <stable@vger.kernel.org>
Subject: Re: [PATCH 2/2] nvme-pci: add AMD PCIe quirk for suspend/resume
Message-ID: <YHaOJDm3GCZ8baAV@kroah.com>
References: <1618381200-14856-1-git-send-email-Prike.Liang@amd.com>
 <1618381200-14856-2-git-send-email-Prike.Liang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1618381200-14856-2-git-send-email-Prike.Liang@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 14, 2021 at 02:20:00PM +0800, Prike Liang wrote:
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
> Signed-off-by: Prike Liang <Prike.Liang@amd.com>
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> Cc: <stable@vger.kernel.org> # 5.11+
> ---
>  drivers/nvme/host/pci.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> index 6bad4d4..5a9a192 100644
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
> @@ -2845,6 +2846,10 @@ static bool nvme_acpi_storage_d3(struct pci_dev *dev)
>  	if (!root)
>  		return false;
>  
> +	rdev = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0, 0));
> +	if (rdev && (rdev->dev_flags & PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND))
> +		return NVME_QUIRK_SIMPLE_SUSPEND;
> +
>  	adev = ACPI_COMPANION(&root->dev);
>  	if (!adev)
>  		return false;
> -- 
> 2.7.4
> 

This is still broken, why resend it?
