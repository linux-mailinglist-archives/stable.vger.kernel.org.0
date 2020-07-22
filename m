Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C27D229EAA
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 19:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730092AbgGVRkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 13:40:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgGVRkL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jul 2020 13:40:11 -0400
Received: from localhost (mobile-166-175-191-139.mycingular.net [166.175.191.139])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E37A520787;
        Wed, 22 Jul 2020 17:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595439611;
        bh=lTXgEZOM6WAmbI17kym6nz1GakVkLb7xxhXhP7EnIE0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=n5mWjM7/mkPPImvbpjDzNnrzgATHcFcYy651epkQHwXL39Ldnc0oR52J22knvfgxM
         dxTlKRNbXzZ3wdzca6w1idgUgH4+P85bwMJsDKJPLYAOhdfuhZbJqKx5VEKUZNZ4l3
         DsMVEmM1qTXCln9/LKkKVgbpr4uwPEc0NnkCrN/4=
Date:   Wed, 22 Jul 2020 12:40:09 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Robert Hancock <hancockrwd@gmail.com>
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org,
        Puranjay Mohan <puranjay12@gmail.com>
Subject: Re: [PATCH] PCI: Disallow ASPM on ASMedia ASM1083/1085 PCIe-PCI
 bridge
Message-ID: <20200722174009.GA1291928@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722021803.17958-1-hancockrwd@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[+cc Puranjay]

On Tue, Jul 21, 2020 at 08:18:03PM -0600, Robert Hancock wrote:
> Recently ASPM handling was changed to no longer disable ASPM on all
> PCIe to PCI bridges. Unfortunately these ASMedia PCIe to PCI bridge
> devices don't seem to function properly with ASPM enabled, as they
> cause the parent PCIe root port to cause repeated AER timeout errors.
> In addition to flooding the kernel log, this also causes the machine
> to wake up immediately after suspend is initiated.

Hi Robert, thanks a lot for the report of this problem
(https://lore.kernel.org/r/CADLC3L1R2hssRjxHJv9yhdN_7-hGw58rXSfNp-FraZh0Tw+gRw@mail.gmail.com
and https://bugzilla.redhat.com/show_bug.cgi?id=1853960).

I'm pretty sure Linux ASPM support is missing some things.  This
problem might be a hardware problem where a quirk is the right
solution, but it could also be that it's a result of a Linux defect
that we should fix.

Could you collect the dmesg log and "sudo lspci -vvxxxx" output
somewhere (maybe a bugzilla.kernel.org issue)?  I want to figure out
whether this L1 PM substates are enabled on this link, and whether
that's configured correctly.

> Fixes: 66ff14e59e8a ("PCI/ASPM: Allow ASPM on links to PCIe-to-PCI/PCI-X Bridges")
> Cc: stable@vger.kernel.org
> Signed-off-by: Robert Hancock <hancockrwd@gmail.com>
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
