Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55DE135EFFA
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 10:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbhDNIkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 04:40:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350306AbhDNIkJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 04:40:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1061C613CD;
        Wed, 14 Apr 2021 08:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618389587;
        bh=2DHSVSV5XZPd7ez4fn13WfAhWgF0+pHVBEeJRWI0iuo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J6yBBk/yeSazHS6ErkbRhMMWqChBhZToZm+w57V4FSx66MLrm93tH1JK1GSFvSGNa
         zit54wVuWhJNXCT+n1cVYpDeQwm5dqHL9G1lO6j82m/hhaAvUpPPAhSV8u+WadN9DF
         s5URfBhzDnsaOE3aLpigwP5oZFjK/hrDHE/3lvTE=
Date:   Wed, 14 Apr 2021 10:39:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Prike Liang <Prike.Liang@amd.com>
Cc:     linux-nvme@lists.infradead.org, kbusch@kernel.org,
        Chaitanya.Kulkarni@wdc.com, hch@infradead.org,
        stable@vger.kernel.org, Shyam-sundar.S-k@amd.com,
        Alexander.Deucher@amd.com
Subject: Re: [PATCH 2/2] nvme-pci: add AMD PCIe quirk for suspend/resume
Message-ID: <YHaqUQxc0SNIsBri@kroah.com>
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
> Signed-off-by: Prike Liang <Prike.Liang@amd.com>
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> Cc: <stable@vger.kernel.org> # 5.11+
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
> +	if (rdev && (rdev->dev_flags & PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND)) {
> +		pci_dev_put(rdev);
> +		return true;
> +	}
> +
>  	adev = ACPI_COMPANION(&root->dev);
>  	if (!adev)
>  		return false;
> -- 
> 2.7.4
> 


Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- This looks like a new version of a previously submitted patch, but you
  did not list below the --- line any changes from the previous version.
  Please read the section entitled "The canonical patch format" in the
  kernel file, Documentation/SubmittingPatches for what needs to be done
  here to properly describe this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
