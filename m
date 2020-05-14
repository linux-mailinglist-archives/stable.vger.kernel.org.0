Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 356221D2F32
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 14:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgENMJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 08:09:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbgENMJs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 08:09:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF48C206A5;
        Thu, 14 May 2020 12:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589458187;
        bh=9TkmUAdX2RQ+u5zgcMGocI9dwuWZ53GZK+S2e9ICxjY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NAQksCZ2qHv+5x3AQC+zmCumpoQNZV3vfkvc+6WxQaygncoy4cPeEar5Lo5WuQDyv
         s/0rbz9abTxLkyqpTsXi1RD1vgyNp4LdbHTqYhWYBdHW+iJxX4uCquQJlgmwsBaAAP
         SzDZ5wS1LdvjlZvf6o+6KTkW4YkqBnCAM7N3WDfE=
Date:   Thu, 14 May 2020 14:09:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hillf Danton <hdanton@sina.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jeremy Linton <jeremy.linton@arm.com>,
        syzbot+353be47c9ce21b68b7ed@syzkaller.appspotmail.com,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: usbfs: fix mmap dma mismatch
Message-ID: <20200514120944.GA2005274@kroah.com>
References: <20200514112711.1858252-1-gregkh@linuxfoundation.org>
 <20200514115829.GA15995@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514115829.GA15995@lst.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 14, 2020 at 01:58:29PM +0200, Christoph Hellwig wrote:
> On Thu, May 14, 2020 at 01:27:11PM +0200, Greg Kroah-Hartman wrote:
> > +	if (hcd->localmem_pool || !hcd_uses_dma(hcd)) {
> > +		if (remap_pfn_range(vma, vma->vm_start,
> > +				    virt_to_phys(usbm->mem) >> PAGE_SHIFT,
> > +				    size, vma->vm_page_prot) < 0) {
> > +			dec_usb_memory_use_count(usbm, &usbm->vma_use_count);
> > +			return -EAGAIN;
> > +		}
> > +	} else {
> > +		if (dma_mmap_coherent(hcd->self.sysdev, vma, mem, dma_handle,
> > +				      size)) {
> > +			dec_usb_memory_use_count(usbm, &usbm->vma_use_count);
> > +			return -EAGAIN;
> > +		}
> 
> What about a goto label to share the error handling path?

I thought about that, but that's a bit messier than the duplicated lines
here :)

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

thanks for the review, and the help with this.

greg k-h
