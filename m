Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB18461528
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 13:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240432AbhK2MgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 07:36:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59650 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243051AbhK2MeU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 07:34:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B29FB81055;
        Mon, 29 Nov 2021 12:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C96C53FCB;
        Mon, 29 Nov 2021 12:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638189061;
        bh=A5Fr7Gtg0+Nz8L2Xvy3PkEpe6aQ5hQSYEHKKFzuxax4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qS1CbJf6VFbiFeigIZR00/LFpUBskLzglOZ94hm5xft994L/eA26tlyxEIkQxS0QR
         sHJG7CZ42+mlm+GDNvNYgAvjIFCchV7Ft9tXVU2X2xIohEW8WH0p6CCqAbJFJfLHHc
         cGP1UneET0LOZCQMKR5d+cBWWQ5P6rouOswumQqw=
Date:   Mon, 29 Nov 2021 13:30:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, hca@linux.ibm.com, imbrenda@linux.ibm.com
Subject: Re: [PATCH for 4.14-stable] s390/mm: validate VMA in PGSTE
 manipulation functions
Message-ID: <YaTIAiR9NVQBPUBE@kroah.com>
References: <16371715631177@kroah.com>
 <20211126171536.22963-1-david@redhat.com>
 <YaNuALgYu4OQDVXN@kroah.com>
 <7fdab1f3-abf7-1214-8d74-8cdcc6d96918@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fdab1f3-abf7-1214-8d74-8cdcc6d96918@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 09:40:32AM +0100, David Hildenbrand wrote:
> On 28.11.21 12:54, Greg KH wrote:
> > On Fri, Nov 26, 2021 at 06:15:36PM +0100, David Hildenbrand wrote:
> >> commit fe3d10024073f06f04c74b9674bd71ccc1d787cf upstream.
> >>
> >> We should not walk/touch page tables outside of VMA boundaries when
> >> holding only the mmap sem in read mode. Evil user space can modify the
> >> VMA layout just before this function runs and e.g., trigger races with
> >> page table removal code since commit dd2283f2605e ("mm: mmap: zap pages
> >> with read mmap_sem in munmap"). gfn_to_hva() will only translate using
> >> KVM memory regions, but won't validate the VMA.
> >>
> >> Further, we should not allocate page tables outside of VMA boundaries: if
> >> evil user space decides to map hugetlbfs to these ranges, bad things will
> >> happen because we suddenly have PTE or PMD page tables where we
> >> shouldn't have them.
> >>
> >> Similarly, we have to check if we suddenly find a hugetlbfs VMA, before
> >> calling get_locked_pte().
> >>
> >> Fixes: 2d42f9477320 ("s390/kvm: Add PGSTE manipulation functions")
> >> Signed-off-by: David Hildenbrand <david@redhat.com>
> >> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> >> Acked-by: Heiko Carstens <hca@linux.ibm.com>
> >> Link: https://lore.kernel.org/r/20210909162248.14969-4-david@redhat.com
> >> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> >> Signed-off-by: David Hildenbrand <david@redhat.com>
> >> ---
> >>  arch/s390/mm/pgtable.c | 13 +++++++++++++
> >>  1 file changed, 13 insertions(+)
> > 
> > What about for 5.10-stable and 5.4-stable and 4.19-stable?  Will this
> > commit work there as well?
> 
> Good point, I only have "FAILED: patch "[PATCH] s390/mm: validate VMA in
> PGSTE manipulation functions" failed to apply to 4.14-stable tree" in my
> inbox ... but maybe I accidentally deleted the others.

No, odd, I did not send those out, sorry about that.

> This commit can also be used for:
> - 4.19-stable
> - 5.4-stable
> - 5.10-stable

Thanks, will go take this now for all of those.

greg k-h
