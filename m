Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E36B439216
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 11:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbhJYJOW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 05:14:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232259AbhJYJOW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 05:14:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E140E60F4F;
        Mon, 25 Oct 2021 09:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635153120;
        bh=Ge/ZmxDDKhtclAEjb2Apl1QgMwz8va+DZpGZb8nrUM0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vv1WXthRBlSt8hhdoKG516l7VHI+LLAN5AjZd1xswgL5Sj8xr0kt4uMHfRHwyLQGS
         ctw5lyXqavVId+vib542UByNafwj7lKEOVSzcCHtVIv0VF6y0vF3nIB5UvhelHkGR5
         5JCGC6Vr4juICuQJvCzpirReOt9vsPf73WCYmgus=
Date:   Mon, 25 Oct 2021 11:11:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.10 1/1] s390/pci: fix zpci_zdev_put() on reserve
Message-ID: <YXZ03dkv7UB8l8Il@kroah.com>
References: <20211025090026.3392254-1-schnelle@linux.ibm.com>
 <20211025090026.3392254-2-schnelle@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025090026.3392254-2-schnelle@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 25, 2021 at 11:00:26AM +0200, Niklas Schnelle wrote:
> commit a46044a92add6a400f4dada7b943b30221f7cc80 upstream.
> 
> Since commit 2a671f77ee49 ("s390/pci: fix use after free of zpci_dev")
> the reference count of a zpci_dev is incremented between
> pcibios_add_device() and pcibios_release_device() which was supposed to
> prevent the zpci_dev from being freed while the common PCI code has
> access to it. It was missed however that the handling of zPCI
> availability events assumed that once zpci_zdev_put() was called no
> later availability event would still see the device. With the previously
> mentioned commit however this assumption no longer holds and we must
> make sure that we only drop the initial long-lived reference the zPCI
> subsystem holds exactly once.
> 
> Do so by introducing a zpci_device_reserved() function that handles when
> a device is reserved. Here we make sure the zpci_dev will not be
> considered for further events by removing it from the zpci_list.
> 
> This also means that the device actually stays in the
> ZPCI_FN_STATE_RESERVED state between the time we know it has been
> reserved and the final reference going away. We thus need to consider it
> a real state instead of just a conceptual state after the removal. The
> final cleanup of PCI resources, removal from zbus, and destruction of
> the IOMMU stays in zpci_release_device() to make sure holders of the
> reference do see valid data until the release.
> 
> Fixes: 2a671f77ee49 ("s390/pci: fix use after free of zpci_dev")
> Cc: stable@vger.kernel.org
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> Link: https://lore.kernel.org/r/20211012093425.2247924-1-schnelle@linux.ibm.com
> ---
>  arch/s390/include/asm/pci.h        |  3 ++
>  arch/s390/pci/pci.c                | 45 ++++++++++++++++++++++++++----
>  arch/s390/pci/pci_event.c          |  4 +--
>  drivers/pci/hotplug/s390_pci_hpc.c |  9 +-----
>  4 files changed, 46 insertions(+), 15 deletions(-)

Does not apply:

Applying patch s390-pci-fix-zpci_zdev_put-on-reserve.patch
patching file arch/s390/include/asm/pci.h
patching file arch/s390/pci/pci.c
Hunk #3 FAILED at 835.
Hunk #4 succeeded at 843 (offset 1 line).
1 out of 4 hunks FAILED -- rejects in file arch/s390/pci/pci.c
patching file arch/s390/pci/pci_event.c
patching file drivers/pci/hotplug/s390_pci_hpc.c


What did you make this against?

Ah, that's due to another patch we have in the queue right now.  I'll go
fix this up by hand, thanks!

greg k-h
