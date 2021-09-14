Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6407C40B30C
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 17:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234134AbhINPaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 11:30:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233202AbhINPaB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Sep 2021 11:30:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75E0C60234;
        Tue, 14 Sep 2021 15:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631633323;
        bh=x//Xq5RdCeQ+p5Rv8Opn4y5rHTYOJ9G5/f5Fp7RZXaE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Bzb8q6KEJeul99agG7vblZ4uPpwlW804qUp7KOEfS36zFt5jnKUTYvkXWL19QrDOC
         TytJ69GLCrvKjYhJc+xbV1yfeXANabH3NjWgq3g4BxEaDxNHEN7RIm+h+KFoTU2TvW
         biUaFQz+z6EWybB2yO6kTkfH2eIvV+Bz+vD0uR6mmxWRrmPCJRcGKugeEJvviyQFXo
         gE2zxWXVYrWLDPrAyKm3slJvW8o4zoWP0QsaQ5TldeWsGhANMDEqBFcT0fIty2DD6o
         6i/gT6+Qj/xh6mOTBf+dmPk0ZFx9cHE3gG1by9GmVjuyt6feDUgEBzoIxbKyZBGoum
         NQOeakKfV36Rw==
Date:   Tue, 14 Sep 2021 10:28:42 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Evan Quan <evan.quan@amd.com>
Cc:     linux-pci@vger.kernel.org, bhelgaas@google.com,
        Alexander.Deucher@amd.com, stable@vger.kernel.org
Subject: Re: [PATCH] PCI: Create device links for AMD integrated USB xHCI and
 UCSI controllers
Message-ID: <20210914152842.GA1429517@bjorn-Precision-5520>
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
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Evan Quan <evan.quan@amd.com>

Applied to pci/pm for v5.16, thanks!

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
