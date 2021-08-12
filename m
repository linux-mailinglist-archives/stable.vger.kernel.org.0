Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352583EA864
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 18:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbhHLQRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 12:17:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231927AbhHLQRh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Aug 2021 12:17:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D221C6103E;
        Thu, 12 Aug 2021 16:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628785032;
        bh=KHLN9Y+lZHfS5VXhYh9H8i5xR0A3R3Os+eX6SjdXIF8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=KuSQUq0I7urC7eX7fUlW23ZVg1kVf8+otlrR5aRJzZsmgshtE+Ino4AZ08T3PHI/t
         W4blq3XVyIJvJEyLTa1fCmBEhpTlcwJbytKWfeSQPCM21F1h+kjnx7mxHvlg6Ublej
         csmjny/yP8NTy6LEj1C/bsCYbaKX/mBE2N20Ya192yRN8n+xIvEuk9MgQ5DgzeJnh4
         wCmghCjFOWPrtA8+LEpEZzxtwZW/RYb0d8M57LhtXB05Yju+qr9TYXVEuILSCv/VXJ
         5t38qDTrkGSflgtX7BJp4EwPzfDZw45GjJn9/128Fxi56jAFyxEkJplzSy/ejig+IS
         SniEMAtVXmssQ==
Date:   Thu, 12 Aug 2021 11:17:10 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] PCI/sysfs: Use correct variable for the legacy_mem sysfs
 object
Message-ID: <20210812161710.GA2479934@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210812132144.791268-1-kw@linux.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[+to Greg, please update sysfs_defferred_iomem_get_mapping-5.15]

On Thu, Aug 12, 2021 at 01:21:44PM +0000, Krzysztof Wilczyński wrote:
> Two legacy PCI sysfs objects "legacy_io" and "legacy_mem" were updated
> to use an unified address space in the commit 636b21b50152 ("PCI: Revoke
> mappings like devmem").  This allows for revocations to be managed from
> a single place when drivers want to take over and mmap() a /dev/mem
> range.
> 
> Following the update, both of the sysfs objects should leverage the
> iomem_get_mapping() function to get an appropriate address range, but
> only the "legacy_io" has been correctly updated - the second attribute
> seems to be using a wrong variable to pass the iomem_get_mapping()
> function to.
> 
> Thus, correct the variable name used so that the "legacy_mem" sysfs
> object would also correctly call the iomem_get_mapping() function.
> 
> Fixes: 636b21b50152 ("PCI: Revoke mappings like devmem")
> Signed-off-by: Krzysztof Wilczyński <kw@linux.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Ouch.  This needs to be applied to any -stable trees that contain
636b21b50152, which was merged in v5.12.

It *also* needs to be applied with the obvious updates to Greg's
sysfs_defferred_iomem_get_mapping-5.15 branch because it was changed
by f06aff924f97 ("sysfs: Rename struct bin_attribute member to
f_mapping") [1]

[1] https://git.kernel.org/cgit/linux/kernel/git/gregkh/driver-core.git/commit/?id=f06aff924f97

> ---
>  drivers/pci/pci-sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 5d63df7c1820..7bbf2673c7f2 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -978,7 +978,7 @@ void pci_create_legacy_files(struct pci_bus *b)
>  	b->legacy_mem->size = 1024*1024;
>  	b->legacy_mem->attr.mode = 0600;
>  	b->legacy_mem->mmap = pci_mmap_legacy_mem;
> -	b->legacy_io->mapping = iomem_get_mapping();
> +	b->legacy_mem->mapping = iomem_get_mapping();
>  	pci_adjust_legacy_attr(b, pci_mmap_mem);
>  	error = device_create_bin_file(&b->dev, b->legacy_mem);
>  	if (error)
> -- 
> 2.32.0
> 
