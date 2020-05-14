Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697051D2E79
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 13:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgENLh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 07:37:27 -0400
Received: from foss.arm.com ([217.140.110.172]:34772 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726190AbgENLh1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 07:37:27 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7633530E;
        Thu, 14 May 2020 04:37:26 -0700 (PDT)
Received: from [192.168.122.166] (unknown [10.119.48.101])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1AD693F305;
        Thu, 14 May 2020 04:37:26 -0700 (PDT)
Subject: Re: [PATCH] USB: usbfs: fix mmap dma mismatch
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Hillf Danton <hdanton@sina.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        syzbot+353be47c9ce21b68b7ed@syzkaller.appspotmail.com,
        stable <stable@vger.kernel.org>
References: <20200514112711.1858252-1-gregkh@linuxfoundation.org>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <9cc0a324-c3d8-44f4-4e65-b6938ab8cb06@arm.com>
Date:   Thu, 14 May 2020 06:37:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200514112711.1858252-1-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

So looking at hcd_buffer_alloc() again, there are 4 cases, 
localmem_pool, hcd_uses_dma, dma_pool_alloc and dma_alloc_coherent 
directly. The dma_pool_alloc appears to just be using 
dma_alloc_coherent, so its really three cases.

Those three cases appear to be handled below:

So:

Reviewed-by: Jeremy Linton <jeremy.linton@arm.com>

I'm testing it now...


Thanks,



On 5/14/20 6:27 AM, Greg Kroah-Hartman wrote:
> In commit 2bef9aed6f0e ("usb: usbfs: correct kernel->user page attribute
> mismatch") we switched from always calling remap_pfn_range() to call
> dma_mmap_coherent() to handle issues with systems with non-coherent USB host
> controller drivers.  Unfortunatly, as syzbot quickly told us, not all the world
> is host controllers with DMA support, so we need to check what host controller
> we are attempting to talk to before doing this type of allocation.
> 
> Thanks to Christoph for the quick idea of how to fix this.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hillf Danton <hdanton@sina.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jeremy Linton <jeremy.linton@arm.com>
> Reported-by: syzbot+353be47c9ce21b68b7ed@syzkaller.appspotmail.com
> Fixes: 2bef9aed6f0e ("usb: usbfs: correct kernel->user page attribute mismatch")
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/usb/core/devio.c | 16 +++++++++++++---
>   1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
> index b9db9812d6c5..d93d94d7ff50 100644
> --- a/drivers/usb/core/devio.c
> +++ b/drivers/usb/core/devio.c
> @@ -251,9 +251,19 @@ static int usbdev_mmap(struct file *file, struct vm_area_struct *vma)
>   	usbm->vma_use_count = 1;
>   	INIT_LIST_HEAD(&usbm->memlist);
>   
> -	if (dma_mmap_coherent(hcd->self.sysdev, vma, mem, dma_handle, size)) {
> -		dec_usb_memory_use_count(usbm, &usbm->vma_use_count);
> -		return -EAGAIN;
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
>   	}
>   
>   	vma->vm_flags |= VM_IO;
> 

