Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9B8400638
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 21:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239368AbhICT41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 15:56:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234588AbhICT41 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Sep 2021 15:56:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7C1860FD7;
        Fri,  3 Sep 2021 19:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630698927;
        bh=36yNiRor2maBsEgmJ0JujTWCIWZTI4VY7zC6LPi0DxM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=StE0vBgiBakEKwjlvpqKlg4vB1tzvy6Jk96ZJtV/8RKH0nOpdD8V9j4himZzZQ9tr
         lE7AnkRJ0zs4qOTEUWa2aNJTes0FnI7hJ7uic4m2NAxGdfI4Ancm4CUOmX6DA+XNLd
         uua5stoOMdm16vhB+gFmc1UTf6vLDXiK5AJi/1o9M7gZ7BZbiESllBQzyukky9zqxd
         7y+pXKZjGW6aB1dcj8UVCIWyhF6iHuCQ0LgIW9Ds0XMoHaTVtP6arFnrAtaAfOhZyf
         SjTLPa/JodPaS693K/HsfCQ6mO+i357mE5OKZFdi6IfrudRWmC04givLopMmgCIFJd
         PO0sd9znZlGOw==
Date:   Fri, 3 Sep 2021 14:55:25 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Evan Quan <evan.quan@amd.com>
Cc:     linux-pci@vger.kernel.org, bhelgaas@google.com,
        Alexander.Deucher@amd.com, stable@vger.kernel.org
Subject: Re: [PATCH] PCI: Create device links for AMD integrated USB xHCI and
 UCSI controllers
Message-ID: <20210903195525.GA485189@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903063311.3606226-1-evan.quan@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 03, 2021 at 02:33:11PM +0800, Evan Quan wrote:
> Latest AMD GPUs have built-in USB xHCI and UCSI controllers. Add device
> link support for them.

Please comment on https://git.kernel.org/linus/6d2e369f0d4c .

Is there something the PCI core is missing here?  Or is there
something that needs to be added to ACPI or the PCI firmware spec?

We want a generic way to discover dependencies like this.

A quirk should not be necessary for spec-compliant devices.  Quirks
are an ongoing maintenance burden, and they mean that new hardware
won't work correctly until the OS is patched to know about it.  That's
not what we want.

I expect we'll still need *this* quirk, but first I'd like to know
whether there's a plan to handle this more generically in the future.

When you repost this, please follow the subject line style of
6d2e369f0d4c ("PCI: Add NVIDIA GPU multi-function power
dependencies") so similar patches look similar.

> Cc: stable@vger.kernel.org
> Signed-off-by: Evan Quan <evan.quan@amd.com>
> ---
>  drivers/pci/quirks.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index dea10d62d5b9..f0c5dd3406a1 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -5338,7 +5338,7 @@ DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
>  			      PCI_CLASS_MULTIMEDIA_HD_AUDIO, 8, quirk_gpu_hda);
>  
>  /*
> - * Create device link for NVIDIA GPU with integrated USB xHCI Host
> + * Create device link for GPUs with integrated USB xHCI Host
>   * controller to VGA.
>   */
>  static void quirk_gpu_usb(struct pci_dev *usb)
> @@ -5347,9 +5347,11 @@ static void quirk_gpu_usb(struct pci_dev *usb)
>  }
>  DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
>  			      PCI_CLASS_SERIAL_USB, 8, quirk_gpu_usb);
> +DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_ATI, PCI_ANY_ID,
> +			      PCI_CLASS_SERIAL_USB, 8, quirk_gpu_usb);
>  
>  /*
> - * Create device link for NVIDIA GPU with integrated Type-C UCSI controller
> + * Create device link for GPUs with integrated Type-C UCSI controller
>   * to VGA. Currently there is no class code defined for UCSI device over PCI
>   * so using UNKNOWN class for now and it will be updated when UCSI
>   * over PCI gets a class code.
> @@ -5362,6 +5364,9 @@ static void quirk_gpu_usb_typec_ucsi(struct pci_dev *ucsi)
>  DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
>  			      PCI_CLASS_SERIAL_UNKNOWN, 8,
>  			      quirk_gpu_usb_typec_ucsi);
> +DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_ATI, PCI_ANY_ID,
> +			      PCI_CLASS_SERIAL_UNKNOWN, 8,
> +			      quirk_gpu_usb_typec_ucsi);
>  
>  /*
>   * Enable the NVIDIA GPU integrated HDA controller if the BIOS left it
> -- 
> 2.29.0
> 
