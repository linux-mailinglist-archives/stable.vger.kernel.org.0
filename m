Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6DA23284A
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 01:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgG2XnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 19:43:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727072AbgG2XnK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jul 2020 19:43:10 -0400
Received: from localhost (mobile-166-175-62-240.mycingular.net [166.175.62.240])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50AE02074B;
        Wed, 29 Jul 2020 23:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596066189;
        bh=J4o9KJnDavuZtqTw30BUp/XAeVD31Zav05Kpfm5YbMU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=W3q62+6SvHxB9kPFEDBw06ARSwxy5PkFKQlzKijG6niWMScQFnYEMugK3olxRDR8w
         v6HCZXcXnGWWTBNmgHmNf+mbFCrwkrUUaUz5tLE2DZSTYrC/5F7E6qr+p1RaS1ESWa
         +hjR927ybX/SEKUWV9Ik7iGzlQHpNheo/fps418c=
Date:   Wed, 29 Jul 2020 18:43:07 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Robert Hancock <hancockrwd@gmail.com>
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] PCI: Disallow ASPM on ASMedia ASM1083/1085 PCIe-PCI
 bridge
Message-ID: <20200729234307.GA1978955@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722021803.17958-1-hancockrwd@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 21, 2020 at 08:18:03PM -0600, Robert Hancock wrote:
> Recently ASPM handling was changed to no longer disable ASPM on all
> PCIe to PCI bridges. Unfortunately these ASMedia PCIe to PCI bridge
> devices don't seem to function properly with ASPM enabled, as they
> cause the parent PCIe root port to cause repeated AER timeout errors.
> In addition to flooding the kernel log, this also causes the machine
> to wake up immediately after suspend is initiated.
> 
> Fixes: 66ff14e59e8a ("PCI/ASPM: Allow ASPM on links to PCIe-to-PCI/PCI-X Bridges")
> Cc: stable@vger.kernel.org
> Signed-off-by: Robert Hancock <hancockrwd@gmail.com>

I applied this to for-linus for v5.8, since 66ff14e59e8a was merged
for v5.8.  Thanks very much for finding, debugging, and fixing this!

66ff14e59e8a wasn't marked for stable, so if it *was* backported to
stable kernels, I assume whatever process backported it will also
catch this because of the Fixes: tag.

> ---
>  drivers/pci/quirks.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 812bfc32ecb8..e5713114f2ab 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -2330,6 +2330,19 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x10f1, quirk_disable_aspm_l0s);
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x10f4, quirk_disable_aspm_l0s);
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x1508, quirk_disable_aspm_l0s);
>  
> +static void quirk_disable_aspm_l0s_l1(struct pci_dev *dev)
> +{
> +	pci_info(dev, "Disabling ASPM L0s/L1\n");
> +	pci_disable_link_state(dev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
> +}
> +
> +/*
> + * ASM1083/1085 PCIe-PCI bridge devices cause AER timeout errors on the
> + * upstream PCIe root port when ASPM is enabled. At least L0s mode is affected,
> + * disable both L0s and L1 for now to be safe.
> + */
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ASMEDIA, 0x1080, quirk_disable_aspm_l0s_l1);
> +
>  /*
>   * Some Pericom PCIe-to-PCI bridges in reverse mode need the PCIe Retrain
>   * Link bit cleared after starting the link retrain process to allow this
> -- 
> 2.26.2
> 
