Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7452415F908
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 22:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730486AbgBNVyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 16:54:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:59484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728911AbgBNVyc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 16:54:32 -0500
Received: from localhost (unknown [65.119.211.164])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A914A24649;
        Fri, 14 Feb 2020 21:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581717271;
        bh=4EaJD4cBQj2ixLoQQ9Ro1z/eRAHDR7cjQ7KLJA2dnYQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cH50z6/hQ484QtdtM5AbiW5rhX8uAxBJ1xvtyDj7AaCp7i2VBV/JQskY7FIW/iJEK
         qb+yMvXEQrefwv+MBxWKsHs94qopKbTcKYeH7mwqR5UFKZ2KRvwzXt2SDqNx1hrBca
         VV0MIrjMZotasSKN6+pva+GYlfR5aLKTZIPWmGyw=
Date:   Fri, 14 Feb 2020 16:47:30 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@google.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Joerg Roedel <jroedel@suse.de>, Will Deacon <will@kernel.org>,
        John Garry <john.garry@huawei.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.5 253/542] PCI/ATS: Restore EXPORT_SYMBOL_GPL()
 for pci_{enable,disable}_ats()
Message-ID: <20200214214730.GC4193448@kroah.com>
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-253-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214154854.6746-253-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 10:44:05AM -0500, Sasha Levin wrote:
> From: Greg Kroah-Hartman <gregkh@google.com>
> 
> [ Upstream commit bb950bca5d522119f8b9ce3f6cbac4841c6d6517 ]
> 
> Commit d355bb209783 ("PCI/ATS: Remove unnecessary EXPORT_SYMBOL_GPL()")
> unexported a bunch of symbols from the PCI core since the only external
> users were non-modular IOMMU drivers. Although most of those symbols
> can remain private for now, 'pci_{enable,disable_ats()' is required for
> the ARM SMMUv3 driver to build as a module, otherwise we get a build
> failure as follows:
> 
>   | ERROR: "pci_enable_ats" [drivers/iommu/arm-smmu-v3.ko] undefined!
>   | ERROR: "pci_disable_ats" [drivers/iommu/arm-smmu-v3.ko] undefined!
> 
> Re-export these two functions so that the ARM SMMUv3 driver can be build
> as a module.
> 
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Joerg Roedel <jroedel@suse.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@google.com>
> [will: rewrote commit message]
> Signed-off-by: Will Deacon <will@kernel.org>
> Tested-by: John Garry <john.garry@huawei.com> # smmu v3
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/pci/ats.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c
> index b6f064c885c37..3ef0bb281e7cc 100644
> --- a/drivers/pci/ats.c
> +++ b/drivers/pci/ats.c
> @@ -69,6 +69,7 @@ int pci_enable_ats(struct pci_dev *dev, int ps)
>  	dev->ats_enabled = 1;
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(pci_enable_ats);
>  
>  /**
>   * pci_disable_ats - disable the ATS capability
> @@ -87,6 +88,7 @@ void pci_disable_ats(struct pci_dev *dev)
>  
>  	dev->ats_enabled = 0;
>  }
> +EXPORT_SYMBOL_GPL(pci_disable_ats);
>  
>  void pci_restore_ats_state(struct pci_dev *dev)
>  {
> -- 
> 2.20.1
> 

This isn't needed to be backported as the problem it solves is not in
the 5.5 or older kernels, it only showed up in 5.6-rc1, and this was
part of a larger patchset.

So please drop from everywhere, thanks.

greg k-h
