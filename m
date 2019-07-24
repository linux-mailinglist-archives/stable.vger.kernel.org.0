Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D23D73326
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 17:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbfGXPxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 11:53:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbfGXPxZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 11:53:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C06B21873;
        Wed, 24 Jul 2019 15:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563983604;
        bh=jn2oSrO/9jERyUvQwuwlZYuTEtCtedMvUctisYGwagw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2GKzG+G3KzdTmHCtSG7BkGwrwUNYMmS41dY4xClObBzRCJYhFd6V4GOFPqzvYB8DZ
         Uz9I1DmBZ7YtR6Oa7Eer3i0a7zhh0bdwrKnJ5SPOZo9DnocS9XZEenb2K/Y1T52mqj
         NYASbFC1ar2IS1yEPZthzYINIqUteyzjM/R+SeiU=
Date:   Wed, 24 Jul 2019 17:53:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     mathias.nyman@linux.intel.com, m.szyprowski@samsung.com,
        nsaenzjulienne@suse.de
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] xhci: Fix immediate data transfer if
 buffer is already DMA" failed to apply to 5.2-stable tree
Message-ID: <20190724155321.GA5571@kroah.com>
References: <1563983027111159@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1563983027111159@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 24, 2019 at 05:43:47PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.2-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> >From 13b82b746310b51b064bc855993a1c84bf862726 Mon Sep 17 00:00:00 2001
> From: Mathias Nyman <mathias.nyman@linux.intel.com>
> Date: Wed, 22 May 2019 14:34:00 +0300
> Subject: [PATCH] xhci: Fix immediate data transfer if buffer is already DMA
>  mapped
> 
> xhci immediate data transfer (IDT) support in 5.2-rc1 caused regression
> on various Samsung Exynos boards with ASIX USB 2.0 ethernet dongle.
> 
> If the transfer buffer in the URB is already DMA mapped then IDT should
> not be used. urb->transfer_dma will already contain a valid dma address,
> and there is no guarantee the data in urb->transfer_buffer is valid.
> 
> The IDT support patch used urb->transfer_dma as a temporary storage,
> copying data from urb->transfer_buffer into it.
> 
> Issue was solved by preventing IDT if transfer buffer is already dma
> mapped, and by not using urb->transfer_dma as temporary storage.
> 
> Fixes: 33e39350ebd2 ("usb: xhci: add Immediate Data Transfer support")
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> CC: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Oh nevermind, this should be a 5.2-only thing.

it shouldn't affect anyone, sorry for the noise.

greg k-h
