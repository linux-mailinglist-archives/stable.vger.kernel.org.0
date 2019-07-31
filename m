Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 664EC7B98A
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 08:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbfGaGPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 02:15:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:55044 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725871AbfGaGPj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 02:15:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 05D0CAD1E;
        Wed, 31 Jul 2019 06:15:37 +0000 (UTC)
Subject: Re: [PATCH] xen/gntdev.c: Replace vm_map_pages() with
 vm_map_pages_zero()
To:     Souptick Joarder <jrdr.linux@gmail.com>,
        marmarek@invisiblethingslab.com, sstabellini@kernel.org,
        boris.ostrovsky@oracle.com
Cc:     linux@armlinux.org.uk, willy@infradead.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <1564511696-4044-1-git-send-email-jrdr.linux@gmail.com>
From:   Juergen Gross <jgross@suse.com>
Message-ID: <436440f5-0031-5ad5-4a22-2acf218ad727@suse.com>
Date:   Wed, 31 Jul 2019 08:15:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1564511696-4044-1-git-send-email-jrdr.linux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30.07.19 20:34, Souptick Joarder wrote:
> 'commit df9bde015a72 ("xen/gntdev.c: convert to use vm_map_pages()")'
> breaks gntdev driver. If vma->vm_pgoff > 0, vm_map_pages()
> will:
>   - use map->pages starting at vma->vm_pgoff instead of 0
>   - verify map->count against vma_pages()+vma->vm_pgoff instead of just
>     vma_pages().
> 
> In practice, this breaks using a single gntdev FD for mapping multiple
> grants.
> 
> relevant strace output:
> [pid   857] ioctl(7, IOCTL_GNTDEV_MAP_GRANT_REF, 0x7ffd3407b6d0) = 0
> [pid   857] mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_SHARED, 7, 0) =
> 0x777f1211b000
> [pid   857] ioctl(7, IOCTL_GNTDEV_SET_UNMAP_NOTIFY, 0x7ffd3407b710) = 0
> [pid   857] ioctl(7, IOCTL_GNTDEV_MAP_GRANT_REF, 0x7ffd3407b6d0) = 0
> [pid   857] mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_SHARED, 7,
> 0x1000) = -1 ENXIO (No such device or address)
> 
> details here:
> https://github.com/QubesOS/qubes-issues/issues/5199
> 
> The reason is -> ( copying Marek's word from discussion)
> 
> vma->vm_pgoff is used as index passed to gntdev_find_map_index. It's
> basically using this parameter for "which grant reference to map".
> map struct returned by gntdev_find_map_index() describes just the pages
> to be mapped. Specifically map->pages[0] should be mapped at
> vma->vm_start, not vma->vm_start+vma->vm_pgoff*PAGE_SIZE.
> 
> When trying to map grant with index (aka vma->vm_pgoff) > 1,
> __vm_map_pages() will refuse to map it because it will expect map->count
> to be at least vma_pages(vma)+vma->vm_pgoff, while it is exactly
> vma_pages(vma).
> 
> Converting vm_map_pages() to use vm_map_pages_zero() will fix the
> problem.
> 
> Marek has tested and confirmed the same.
> 
> Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>

Pushed to xen/tip.git for-linus-5.3a


Juergen
