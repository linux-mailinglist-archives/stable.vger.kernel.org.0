Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E470F3F1CA4
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 17:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239586AbhHSP0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 11:26:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239151AbhHSP0K (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Aug 2021 11:26:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 263F86056C;
        Thu, 19 Aug 2021 15:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629386734;
        bh=zFgLCLMUKY91wHstkxXMch3ikWy6/eKSbV2uPLK893I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=So+aetvAIuJ344ue6xpQGJJdI6S4X2p1debKfBHMKN7UElC0T4lWi+JJQzujNdoRj
         BeH32PizUau7kxfgH01il8EWjURyTzcjSInZIY7CanB3HvIsllwGWjeRiaxUWz3d1Z
         34UxO1GvRaC7LWfhldAhtwONAST9u6kVNaZG6Zltpcxq0beBUv90d3OS1/WIhUyOTG
         vo93P+HosfsrtfIqggexDfrivaOw3qOEQYc2mff62g7zIoxeyBl4gC5R9gw4B0rCj2
         wsa6YOuq6q1RD33N7Jgf47jecD2FnlhTcr2KCpi7ThFrmFQTORzFhLzc26UleYPnnu
         2vbYhn1LQXXig==
Date:   Thu, 19 Aug 2021 10:25:32 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] PCI/sysfs: Use correct variable for the legacy_mem sysfs
 object
Message-ID: <20210819152532.GA3206853@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210812132144.791268-1-kw@linux.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Applied to for-linus for v5.14, thanks!

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
