Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E006A22AD7C
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 13:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgGWLTb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 07:19:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgGWLTb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jul 2020 07:19:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44BDA206F4;
        Thu, 23 Jul 2020 11:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595503170;
        bh=/L66IPWsTwQKHafCML2stlb8sDzgzvJ2TicBnY5PFCg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X5jl6HVtha0ujLKYFWMkzo561uPSVD0kzZS6SzOLXvaCUFCcssfEoXo5t+zcHzM9p
         uUDOfOVysQjBw7DsO0D3sfPkioNQTAsI4aklnyieS12//nilszmfPH+YHWoma7xU7N
         eqYeftvob5QxtWnfbo5cVqV1vFAarES+7wiQ4SlM=
Date:   Thu, 23 Jul 2020 13:19:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Mathias Nyman <mathias.nyman@intel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH V2] usb: tegra: Fix allocation for the FPCI context
Message-ID: <20200723111934.GA1964033@kroah.com>
References: <20200712102837.24340-1-jonathanh@nvidia.com>
 <20200715113842.30680-1-jonathanh@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715113842.30680-1-jonathanh@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 15, 2020 at 12:38:42PM +0100, Jon Hunter wrote:
> Commit 5c4e8d3781bc ("usb: host: xhci-tegra: Add support for XUSB
> context save/restore") is using the IPFS 'num_offsets' value when
> allocating memory for FPCI context instead of the FPCI 'num_offsets'.
> 
> After commit cad064f1bd52 ("devres: handle zero size in devm_kmalloc()")
> was added system suspend started failing on Tegra186. The kernel log
> showed that the Tegra XHCI driver was crashing on entry to suspend when
> attempting the save the USB context. On Tegra186, the IPFS context has a
> zero length but the FPCI content has a non-zero length, and because of
> the bug in the Tegra XHCI driver we are incorrectly allocating a zero
> length array for the FPCI context. The crash seen on entering suspend
> when we attempt to save the FPCI context and following commit
> cad064f1bd52 ("devres: handle zero size in devm_kmalloc()") this now
> causes a NULL pointer deference when we access the memory. Fix this by
> correcting the amount of memory we are allocating for FPCI contexts.
> 
> Cc: stable@vger.kernel.org
> 
> Fixes: 5c4e8d3781bc ("usb: host: xhci-tegra: Add support for XUSB context save/restore")
> 
> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> Acked-by: Thierry Reding <treding@nvidia.com>
> ---
> 
> Changes since V1:
> - Corrected commit message
> - Added Thierry's ACK
> 
>  drivers/usb/host/xhci-tegra.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

No cc: to linux-usb@vger?  :(

I'll go queue this up, but I would have caught it sooner if you had done
so...

thanks,

greg k-h
