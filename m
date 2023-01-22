Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4980676BBA
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 10:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjAVJAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 04:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjAVJAQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 04:00:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1651E5DE;
        Sun, 22 Jan 2023 01:00:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1B97B80975;
        Sun, 22 Jan 2023 09:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7E9C433EF;
        Sun, 22 Jan 2023 09:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674378008;
        bh=dNgodQPXGnAJJaCbMcCFeKdcblqgglKHrbatu82Jl7w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KRA/hQreQBQb0nEgQ4CnN27BhVV7L3kshNH3EpCddpUdpIS9/nxyNBnbXRUvIgiKP
         BWJCM8kLEODe2iKZgvdgorwzxF5mKxqlRjXKw+YMcImPkeZ8F51yKrLh6K4QcGow5M
         za5q+mMQ205brfuTg5Z6To0Gsg5BXfx+XJGfGfQOQV7ofKc31A13Gv/S2S1NOFE8rs
         I0zw+pspqZDKfyj2TPCOs/Ft8XCxHEPpr3EQ3LCQPvp/xTKYf89AsDAhzZV9YlyPCs
         WAtKVBJUJkxxrBJ6J2xBDA2/arDEkJa0CXR4MOosD7SIQYeTJ6Lf4axLjjT1n7y318
         O1BvkJnMmrQ7w==
Date:   Sun, 22 Jan 2023 11:00:04 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, darwi@linutronix.de,
        elena.reshetova@intel.com, kirill.shutemov@linux.intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] PCI/MSI: Cache the MSIX table size
Message-ID: <Y8z7FPcuDXDBi+1U@unreal>
References: <20230119170633.40944-1-alexander.shishkin@linux.intel.com>
 <20230119170633.40944-2-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119170633.40944-2-alexander.shishkin@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 19, 2023 at 07:06:32PM +0200, Alexander Shishkin wrote:
> A malicious device can change its MSIX table size between the table
> ioremap() and subsequent accesses, resulting in a kernel page fault in
> pci_write_msg_msix().
> 
> To avoid this, cache the table size observed at the moment of table
> ioremap() and use the cached value. This, however, does not help drivers
> that peek at the PCIE_MSIX_FLAGS register directly.
> 
> Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/pci/msi/api.c | 7 ++++++-
>  drivers/pci/msi/msi.c | 2 +-
>  include/linux/pci.h   | 1 +
>  3 files changed, 8 insertions(+), 2 deletions(-)

I'm not security expert here, but not sure that this protects from anything.
1. Kernel relies on working and not-malicious HW. There are gazillion ways
to cause crashes other than changing MSI-X.
2. Device can report large table size, kernel will cache it and
malicious device will reduce it back. It is not handled and will cause
to kernel crash too.

Thanks

> 
> diff --git a/drivers/pci/msi/api.c b/drivers/pci/msi/api.c
> index b8009aa11f3c..617ea1256487 100644
> --- a/drivers/pci/msi/api.c
> +++ b/drivers/pci/msi/api.c
> @@ -75,8 +75,13 @@ int pci_msix_vec_count(struct pci_dev *dev)
>  	if (!dev->msix_cap)
>  		return -EINVAL;
>  
> +	if (dev->flags_qsize)
> +		return dev->flags_qsize;
> +
>  	pci_read_config_word(dev, dev->msix_cap + PCI_MSIX_FLAGS, &control);
> -	return msix_table_size(control);
> +	dev->flags_qsize = msix_table_size(control);
> +
> +	return dev->flags_qsize;
>  }
>  EXPORT_SYMBOL(pci_msix_vec_count);
>  
> diff --git a/drivers/pci/msi/msi.c b/drivers/pci/msi/msi.c
> index 1f716624ca56..d50cd45119f1 100644
> --- a/drivers/pci/msi/msi.c
> +++ b/drivers/pci/msi/msi.c
> @@ -715,7 +715,7 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
>  
>  	pci_read_config_word(dev, dev->msix_cap + PCI_MSIX_FLAGS, &control);
>  	/* Request & Map MSI-X table region */
> -	tsize = msix_table_size(control);
> +	tsize = pci_msix_vec_count(dev);
>  	dev->msix_base = msix_map_region(dev, tsize);
>  	if (!dev->msix_base) {
>  		ret = -ENOMEM;
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index adffd65e84b4..2e1a72a2139d 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -352,6 +352,7 @@ struct pci_dev {
>  	u8		rom_base_reg;	/* Config register controlling ROM */
>  	u8		pin;		/* Interrupt pin this device uses */
>  	u16		pcie_flags_reg;	/* Cached PCIe Capabilities Register */
> +	u16		flags_qsize;	/* Cached MSIX table size */
>  	unsigned long	*dma_alias_mask;/* Mask of enabled devfn aliases */
>  
>  	struct pci_driver *driver;	/* Driver bound to this device */
> -- 
> 2.39.0
> 
