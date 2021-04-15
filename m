Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAFF9360264
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 08:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhDOGaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 02:30:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhDOGaO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 02:30:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5077E610E6;
        Thu, 15 Apr 2021 06:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618468190;
        bh=3A32B+gZv0zuuoI1QYyb0Ju4ttAEz+Z30b2UWx7sLHQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nW1eT1knhuE/j19o/RX8RbKIQAuTcJITT3YC+TQYH7wPW4NVdXjqm6y3Yur6nVD+9
         CI5aVlJVTlIf45+GMecqzz9vQLlwe5CIboaakLZLHjfFmlHuSc/7GizkoDCzHfhV0S
         AYplWgCetgpmGSuI62CCjf53b84cpbmbfnNw+EfQ=
Date:   Thu, 15 Apr 2021 08:29:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Prike Liang <Prike.Liang@amd.com>
Cc:     linux-nvme@lists.infradead.org, Chaitanya.Kulkarni@wdc.com,
        hch@infradead.org, stable@vger.kernel.org,
        Alexander.Deucher@amd.com,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Subject: Re: [PATCH v4 2/2] nvme-pci: add AMD PCIe quirk for suspend/resume
Message-ID: <YHfdWYY3QSjIM2lT@kroah.com>
References: <1618458725-17164-1-git-send-email-Prike.Liang@amd.com>
 <1618458725-17164-2-git-send-email-Prike.Liang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1618458725-17164-2-git-send-email-Prike.Liang@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 15, 2021 at 11:52:05AM +0800, Prike Liang wrote:
> The NVME device pluged in some AMD PCIE root port will resume timeout
> from s2idle which caused by NVME power CFG lost in the SMU FW restore.
> This issue can be workaround by using PCIe power set with simple
> suspend/resume process path instead of APST. In the onwards ASIC will
> try do the NVME shutdown save and restore in the BIOS and still need
> PCIe power setting to resume from RTD3 for s2idle.
> 
> Update the nvme_acpi_storage_d3() _with previously added quirk.
> 
> Cc: <stable@vger.kernel.org> # 5.11+
> Signed-off-by: Prike Liang <Prike.Liang@amd.com>
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> [ck: split patches for nvme and pcie]
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> 
> Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

You don't sign off and review a patch.  And you do not put a blank line
between them, this should all be one chunk of text.



> ---
> Changes in v2:
> Fix the patch format and check chip root complex DID instead of PCIe RP
> to avoid the storage device plugged in internal PCIe RP by USB adaptor.
> 
> Changes in v3:
> According to Christoph Hellwig do NVME PCIe related identify opt better
> in PCIe quirk driver rather than in NVME module.
> 
> Changes in v4:
> Split the fix to PCIe and NVMe part and then call the pci_dev_put() put
> the device reference count and finally refine the commit info.
> ---
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

Please look at the root bus for the specific device, do not assume that
you are only on this specific bus.

greg k-h
