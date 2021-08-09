Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56E93E40FD
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 09:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbhHIHpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 03:45:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54021 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233554AbhHIHpx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 03:45:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628495133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sNLQyoKHz3doB3VgHoSYiw/2Wi9gt/WD6yUBM0vzV9U=;
        b=X4vnk2y8K43ftq/lKkUZvNw3xKCIWdX7HqG1dNbpg/AQcM6E0G/kI20zD9a0ZzAraooujs
        Ub989RRmzccW/lsGpvbknTkhvRv6UfpDBzNf13a+UvtogM5rtzuJ5XnOu8v5TyVkVA+Xbz
        FejsHiGWbP2S8uUKyAsd8ltGLKPGIy0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-z6TTFUY7OwO2e0ffebZ4jA-1; Mon, 09 Aug 2021 03:45:32 -0400
X-MC-Unique: z6TTFUY7OwO2e0ffebZ4jA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 887631853028;
        Mon,  9 Aug 2021 07:45:30 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC1BD60CC9;
        Mon,  9 Aug 2021 07:45:28 +0000 (UTC)
Message-ID: <33d01b8bb31541be7911f95581cdf608c6c79bf6.camel@redhat.com>
Subject: Re: [PATCH] selftests: KVM: avoid failures due to reserved
 HyperTransport region
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Joao Martins <joao.m.martins@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     stable@vger.kernel.org, David Matlack <dmatlack@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Mon, 09 Aug 2021 10:45:27 +0300
In-Reply-To: <4b530fb6-81cc-be36-aa68-92ec01c65775@oracle.com>
References: <20210805105423.412878-1-pbonzini@redhat.com>
         <4b530fb6-81cc-be36-aa68-92ec01c65775@oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-08-06 at 11:57 +0100, Joao Martins wrote:
> 
> On 8/5/21 11:54 AM, Paolo Bonzini wrote:
> > Accessing guest physical addresses at 0xFFFD_0000_0000 and above causes
> > a failure on AMD processors because those addresses are reserved by
> > HyperTransport (this is not documented).  
> 
> Oh, but it's actually documented in the AMD IOMMU manual [0] (and AMD IOMMU in linux do
> mark it as a reserved IOVA region i.e. HT_RANGE_START..HT_RANGE_END). And it's usually
> marked as a reserved type in E820. At least on the machines I've seen.
> 
> See manual section '2.1.2 IOMMU Logical Topology':
> 
> "Special address controls in Table 3 are interpreted against untranslated guest physical
> addressess (GPA) that lack a PASID TLP prefix."
> 
>  Base Address   Top Address   Use
> 
>   FD_0000_0000h FD_F7FF_FFFFh Reserved interrupt address space
>   FD_F800_0000h FD_F8FF_FFFFh Interrupt/EOI IntCtl
>   FD_F900_0000h FD_F90F_FFFFh Legacy PIC IACK
>   FD_F910_0000h FD_F91F_FFFFh System Management
>   FD_F920_0000h FD_FAFF_FFFFh Reserved Page Tables
>   FD_FB00_0000h FD_FBFF_FFFFh Address Translation
>   FD_FC00_0000h FD_FDFF_FFFFh I/O Space
>   FD_FE00_0000h FD_FFFF_FFFFh Configuration
>   FE_0000_0000h FE_1FFF_FFFFh Extended Configuration/Device Messages
>   FE_2000_0000h FF_FFFF_FFFFh Reserved
> 
> It covers the range starting that address you fixed up ... up to 1Tb, fwiw.
> 
> You mark it ~1010G as max gfn so shouldn't be a problem.
> 
> [0] https://www.amd.com/system/files/TechDocs/48882_IOMMU.pdf
> 
> > Avoid selftests failures
> > by reserving those guest physical addresses.
> > 
> > Fixes: ef4c9f4f6546 ("KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()")
> > Cc: stable@vger.kernel.org
> > Cc: David Matlack <dmatlack@google.com>
> > Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index 10a8ed691c66..d995cc9836ee 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -309,6 +309,12 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
> >  	/* Limit physical addresses to PA-bits. */
> >  	vm->max_gfn = ((1ULL << vm->pa_bits) >> vm->page_shift) - 1;
> >  
> > +#ifdef __x86_64__
> > +	/* Avoid reserved HyperTransport region on AMD processors.  */
> > +	if (vm->pa_bits == 48)
> > +		vm->max_gfn = 0xfffcfffff;
> > +#endif
> > +
> 
> Not sure if it's worth the trouble having a macro with the same name as AMD iommu like:
> 
> #define HT_RANGE_START                (0xfd00000000ULL)
> #define MAX_GFN			      (HT_RANGE_START - 1ULL)
> 
> #ifdef __x86_64__
> 	/* Avoid reserved HyperTransport region on AMD processors.  */
> 	if (vm->pa_bits == 48)
> 		vm->max_gfn = MAX_GFN;
> #endif

I guess now that we know that it is documented, it is worth it,
to remove '== 48' check and add check for an AMD cpu, and add reference
to this manual.

I am mentioning the 48 bit check because I have seen that AMD just recently
posted 5 level NPT support, so I guess CPUs which > 48 bit max physical address
are also probably on horison.

And long term solution for this I guess is to add these areas to a blacklist
and avoid them.

Best regards,
	Maxim Levitsky

> 
> It's a detail, but *perhaps* would help people grepping around it.
> 
> Also, not sure if checking against AMD cpuid vendor is worth, considering this is
> a limitation only on AMD.
> 
> 
> >  	/* Allocate and setup memory for guest. */
> >  	vm->vpages_mapped = sparsebit_alloc();
> >  	if (phy_pages != 0)
> > 


