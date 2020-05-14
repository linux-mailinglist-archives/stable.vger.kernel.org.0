Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9771D2EF1
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 13:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgENL6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 07:58:33 -0400
Received: from verein.lst.de ([213.95.11.211]:51537 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbgENL6c (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 07:58:32 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7EA8E68BEB; Thu, 14 May 2020 13:58:29 +0200 (CEST)
Date:   Thu, 14 May 2020 13:58:29 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Hillf Danton <hdanton@sina.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jeremy Linton <jeremy.linton@arm.com>,
        syzbot+353be47c9ce21b68b7ed@syzkaller.appspotmail.com,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: usbfs: fix mmap dma mismatch
Message-ID: <20200514115829.GA15995@lst.de>
References: <20200514112711.1858252-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514112711.1858252-1-gregkh@linuxfoundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 14, 2020 at 01:27:11PM +0200, Greg Kroah-Hartman wrote:
> +	if (hcd->localmem_pool || !hcd_uses_dma(hcd)) {
> +		if (remap_pfn_range(vma, vma->vm_start,
> +				    virt_to_phys(usbm->mem) >> PAGE_SHIFT,
> +				    size, vma->vm_page_prot) < 0) {
> +			dec_usb_memory_use_count(usbm, &usbm->vma_use_count);
> +			return -EAGAIN;
> +		}
> +	} else {
> +		if (dma_mmap_coherent(hcd->self.sysdev, vma, mem, dma_handle,
> +				      size)) {
> +			dec_usb_memory_use_count(usbm, &usbm->vma_use_count);
> +			return -EAGAIN;
> +		}

What about a goto label to share the error handling path?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
