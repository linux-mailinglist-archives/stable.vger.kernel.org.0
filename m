Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3094759CE
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 14:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242924AbhLONlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 08:41:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46650 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234413AbhLONlT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 08:41:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639575678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=boKoEDTcSf2tYQEzUv2J2xaejzwtduTfvQXExXc35jk=;
        b=M8owPHbS7mKLBQJHV0xwOl14olQih2N38TyAf+WYzx8MyZwovJh2atsQgVjuvmZpl/pFjV
        VYxIIRzVldPxJn/962bKLOXQvkYGmDuKKi3R7ZWZz0Ks9npHVIcDJjuX6NzOtsBecGvjm1
        bDewouquzWj1JZvpl0Aq5QYAHKXW2vE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-kQ6hF5TRMFW6kBnOWFe8Pw-1; Wed, 15 Dec 2021 08:41:13 -0500
X-MC-Unique: kQ6hF5TRMFW6kBnOWFe8Pw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9153100C663;
        Wed, 15 Dec 2021 13:41:10 +0000 (UTC)
Received: from localhost (ovpn-12-120.pek2.redhat.com [10.72.12.120])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C7316FB8A;
        Wed, 15 Dec 2021 13:41:09 +0000 (UTC)
Date:   Wed, 15 Dec 2021 21:41:06 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Christoph Hellwig <hch@lst.de>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, cl@linux.com,
        John.p.donnelly@oracle.com, kexec@lists.infradead.org,
        stable@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v3 5/5] mm/slub: do not create dma-kmalloc if no managed
 pages in DMA zone
Message-ID: <20211215134106.GE10336@MiWiFi-R3L-srv>
References: <20211213122712.23805-1-bhe@redhat.com>
 <20211213122712.23805-6-bhe@redhat.com>
 <20211213134319.GA997240@odroid>
 <20211214053253.GB2216@MiWiFi-R3L-srv>
 <f5ff82eb-73b6-55b5-53d7-04ab73ce5035@suse.cz>
 <20211215044818.GB1097530@odroid>
 <20211215070335.GA1165926@odroid>
 <20211215072710.GA3010@lst.de>
 <f7c1f169-f9b3-6930-f933-d69ab0287069@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7c1f169-f9b3-6930-f933-d69ab0287069@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/15/21 at 11:34am, Vlastimil Babka wrote:
> On 12/15/21 08:27, Christoph Hellwig wrote:
> > On Wed, Dec 15, 2021 at 07:03:35AM +0000, Hyeonggon Yoo wrote:
> >> I'm not sure that allocating from ZONE_DMA32 instead of ZONE_DMA
> >> for kdump kernel is nice way to solve this problem.
> > 
> > What is the problem with zones in kdump kernels?
> 
> My understanding is that kdump kernel can only use physical memory that it
> got reserved by the main kernel, and the main kernel will reserve some block
> of memory that doesn't include any pages from ZONE_DMA (first 16MB of
> physical memory or whatnot). By looking at the "crashkernel" parameter
> documentation in kernel-parameters.txt it seems we only care about
> below-4GB/above-4GB split.
> So it can easily happen that ZONE_DMA in the kdump kernel will be completely
> empty because the main kernel was using all of it.

Exactly as you said. Even before below regression commit added, we only
have 0~640K reused in kdump kernel. We resued the 1st 640K not because
we need it for zone DMA, just the 1st 640K is needed by BIOS/firmwre
during early stage of system bootup. So there are tens of or several
hundred KB left for managed pages in zone DMA except of those firmware
reserved area in the 1st 640K. After below commit, the 1st 1M is
reserved with memblock_reserve(), so no any physicall memory added to
zone DMA. Then we see the allocation failure.

When we prepare environment for kdump kernel, usually we will customize
a initramfs to includes those necessary ko. E.g a storage device is dump
target, its driver must be loaded. If a network dump specified, network
driver is needed. I never see a ISA device or a device of 24bit
addressing limit is needed in kdump kernel.

6f599d84231f ("x86/kdump: Always reserve the low 1M when the crashkernel option is specified")

> 
> >> Devices that requires ZONE_DMA memory is rare but we still support them.
> > 
> > Indeed.
> > 
> >> >     1) Do not call warn_alloc in page allocator if will always fail
> >> >     to allocate ZONE_DMA pages.
> >> > 
> >> > 
> >> >     2) let's check all callers of kmalloc with GFP_DMA
> >> >     if they really need GFP_DMA flag and replace those by DMA API or
> >> >     just remove GFP_DMA from kmalloc()
> >> > 
> >> >     3) Drop support for allocating DMA memory from slab allocator
> >> >     (as Christoph Hellwig said) and convert them to use DMA32
> >> 
> >> 	(as Christoph Hellwig said) and convert them to use *DMA API*
> >> 
> >> >     and see what happens
> > 
> > This is the right thing to do, but it will take a while.  In fact
> > I dont think we really need the warning in step 1, a simple grep
> > already allows to go over them.  I just looked at the uses of GFP_DMA
> > in drivers/scsi for example, and all but one look bogus.
> > 
> >> > > > Yeah, I have the same guess too for get_capabilities(), not sure about other
> >> > > > callers. Or, as ChristophL and ChristophH said(Sorry, not sure if this is
> >> > > > the right way to call people when the first name is the same. Correct me if
> >> > > > it's wrong), any buffer requested from kmalloc can be used by device driver.
> >> > > > Means device enforces getting memory inside addressing limit for those
> >> > > > DMA transferring buffer which is usually large, Megabytes level with
> >> > > > vmalloc() or alloc_pages(), but doesn't care about this kind of small
> >> > > > piece buffer memory allocated with kmalloc()? Just a guess, please tell
> >> > > > a counter example if anyone happens to know, it could be easy.
> > 
> > The way this works is that the dma_map* calls will bounce buffer memory
> 
> But if ZONE_DMA is not populated, where will it get the bounce buffer from?
> I guess nowhere and the problem still exists?

Agree. When I investigated other ARCHs, arm64 has a fascinating setup
for zone DMA/DMA32. It defaults to have all low 4G memory into zone DMA,
but empty zone DMA32. Only if ACPI/DT reports <32 bit addressing
devices, it will set it as limit of zone DMA.

        ZONE_DMA       ZONE_DMA32
arm64   0~X            X~4G  (X is got from ACPI or DT. Otherwise it's 4G by default, DMA32 is empty)

> 
> > that does to fall into the addressing limitations.  This is a performance
> > overhead, but allows drivers to address all memory in a system.  If the
> > driver controls memory allocation it should use one of the dma_alloc_*
> > APIs that allocate addressable memory from the start.  The allocator
> > will dip into ZONE_DMA and ZONE_DMA32 when needed.
> 

