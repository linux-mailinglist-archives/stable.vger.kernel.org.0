Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CED14605FB
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 12:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbhK1MAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 07:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbhK1L6A (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 06:58:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA99C061574;
        Sun, 28 Nov 2021 03:54:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F0AF60FB9;
        Sun, 28 Nov 2021 11:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E5BC004E1;
        Sun, 28 Nov 2021 11:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638100482;
        bh=sHm8phCbm8/YA3JxnPdq7J1ma8QKPtJbjEv7ddaIAKc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nhrPAxSYIOLedxQz73WO0/SxjJ/uefFk0Iw7VIxL9ltu5yQxzp59ssGwiT3B13c8P
         M0e/48D21aaQpP1NRoeVKUdF9VC6vTpcxR+yxQZJEtQ+nMRffdzuUHapzyAEXns0u5
         rIvLE/IMN1V+MHBltW9Uk1r8IA1JxJh2q2ijElxY=
Date:   Sun, 28 Nov 2021 12:54:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, hca@linux.ibm.com, imbrenda@linux.ibm.com
Subject: Re: [PATCH for 4.14-stable] s390/mm: validate VMA in PGSTE
 manipulation functions
Message-ID: <YaNuALgYu4OQDVXN@kroah.com>
References: <16371715631177@kroah.com>
 <20211126171536.22963-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211126171536.22963-1-david@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 26, 2021 at 06:15:36PM +0100, David Hildenbrand wrote:
> commit fe3d10024073f06f04c74b9674bd71ccc1d787cf upstream.
> 
> We should not walk/touch page tables outside of VMA boundaries when
> holding only the mmap sem in read mode. Evil user space can modify the
> VMA layout just before this function runs and e.g., trigger races with
> page table removal code since commit dd2283f2605e ("mm: mmap: zap pages
> with read mmap_sem in munmap"). gfn_to_hva() will only translate using
> KVM memory regions, but won't validate the VMA.
> 
> Further, we should not allocate page tables outside of VMA boundaries: if
> evil user space decides to map hugetlbfs to these ranges, bad things will
> happen because we suddenly have PTE or PMD page tables where we
> shouldn't have them.
> 
> Similarly, we have to check if we suddenly find a hugetlbfs VMA, before
> calling get_locked_pte().
> 
> Fixes: 2d42f9477320 ("s390/kvm: Add PGSTE manipulation functions")
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: Heiko Carstens <hca@linux.ibm.com>
> Link: https://lore.kernel.org/r/20210909162248.14969-4-david@redhat.com
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/s390/mm/pgtable.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)

What about for 5.10-stable and 5.4-stable and 4.19-stable?  Will this
commit work there as well?

thanks,

greg k-h
