Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D038347A56B
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 08:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237735AbhLTHcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 02:32:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:26504 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237723AbhLTHcZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 02:32:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639985544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m92q6v4zmCnyHVr0ODCnuNSLZNCopKGH9YDYi2JUVw4=;
        b=UYcUJOdlQ18//2UIEc+/FlLNKgUs9Ul3sLEHtulN6mQoc9LA5ksSWt4qvuelWSBgUeJmsx
        XLCQSeQ4N20ldOsLwI4TQaSXMdl2dCFXrbc5DRRboWHE09QLSDqInSllRzgzhrfUwOpkHl
        /8mFH+DAkNEI11PmNa2mkBF/Lb+mTd0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-Wqir05YXNv-pctpQYNdbUQ-1; Mon, 20 Dec 2021 02:32:19 -0500
X-MC-Unique: Wqir05YXNv-pctpQYNdbUQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6ADD190D342;
        Mon, 20 Dec 2021 07:32:15 +0000 (UTC)
Received: from localhost (ovpn-12-142.pek2.redhat.com [10.72.12.142])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A293460C04;
        Mon, 20 Dec 2021 07:32:12 +0000 (UTC)
Date:   Mon, 20 Dec 2021 15:32:10 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, Vlastimil Babka <vbabka@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, cl@linux.com,
        John.p.donnelly@oracle.com, kexec@lists.infradead.org,
        stable@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v3 5/5] mm/slub: do not create dma-kmalloc if no managed
 pages in DMA zone
Message-ID: <20211220073210.GA31681@MiWiFi-R3L-srv>
References: <20211213122712.23805-1-bhe@redhat.com>
 <20211213122712.23805-6-bhe@redhat.com>
 <20211213134319.GA997240@odroid>
 <20211214053253.GB2216@MiWiFi-R3L-srv>
 <f5ff82eb-73b6-55b5-53d7-04ab73ce5035@suse.cz>
 <20211215044818.GB1097530@odroid>
 <20211215070335.GA1165926@odroid>
 <20211215072710.GA3010@lst.de>
 <Ybx2zGCvWGTmm2Ed@ip-172-31-30-232.ap-northeast-1.compute.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ybx2zGCvWGTmm2Ed@ip-172-31-30-232.ap-northeast-1.compute.internal>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/17/21 at 11:38am, Hyeonggon Yoo wrote:
> On Wed, Dec 15, 2021 at 08:27:10AM +0100, Christoph Hellwig wrote:
> > On Wed, Dec 15, 2021 at 07:03:35AM +0000, Hyeonggon Yoo wrote:
> > > I'm not sure that allocating from ZONE_DMA32 instead of ZONE_DMA
> > > for kdump kernel is nice way to solve this problem.
> > 
> > What is the problem with zones in kdump kernels?
> > 
> > > Devices that requires ZONE_DMA memory is rare but we still support them.
> > 
> > Indeed.
> > 
> > > >     1) Do not call warn_alloc in page allocator if will always fail
> > > >     to allocate ZONE_DMA pages.
> > > > 
> > > > 
> > > >     2) let's check all callers of kmalloc with GFP_DMA
> > > >     if they really need GFP_DMA flag and replace those by DMA API or
> > > >     just remove GFP_DMA from kmalloc()
> > > > 
> > > >     3) Drop support for allocating DMA memory from slab allocator
> > > >     (as Christoph Hellwig said) and convert them to use DMA32
> > > 
> > > 	(as Christoph Hellwig said) and convert them to use *DMA API*
> > > 
> > > >     and see what happens
> > 
> > This is the right thing to do, but it will take a while.  In fact
> > I dont think we really need the warning in step 1,
> 
> Hmm I think step 1) will be needed if someone is allocating pages from
> DMA zone not using kmalloc or DMA API. (for example directly allocating
> from buddy allocator) is there such cases?

I think Christoph meant to take off the warning. I will post a patch to
mute the warning if it's requesting page from DMA zone which has no
managed pages.

> 
> > a simple grep
> > already allows to go over them.  I just looked at the uses of GFP_DMA
> > in drivers/scsi for example, and all but one look bogus.
> >
> 
> That's good. this cleanup will also remove unnecessary limitations.

I searched and investigated several callsites where kmalloc(GFP_DMA) is
called. E.g drivers/scsi/sr.c: sr_probe(). The scsi sr driver doesn't
check DMA supporting capibility at all, e.g the dma limit, to set the
dma mask or coherent_dma_mask. If we want to convert the
kmalloc(GFP_DMA) to dma_alloc* API, scsi sr drvier developer/expert's
suggestion and help is necessary. Either someone who knows this well
help to change it, or give suggestion how to change so that I can do it. 

> 
> > > > > > Yeah, I have the same guess too for get_capabilities(), not sure about other
> > > > > > callers. Or, as ChristophL and ChristophH said(Sorry, not sure if this is
> > > > > > the right way to call people when the first name is the same. Correct me if
> > > > > > it's wrong), any buffer requested from kmalloc can be used by device driver.
> > > > > > Means device enforces getting memory inside addressing limit for those
> > > > > > DMA transferring buffer which is usually large, Megabytes level with
> > > > > > vmalloc() or alloc_pages(), but doesn't care about this kind of small
> > > > > > piece buffer memory allocated with kmalloc()? Just a guess, please tell
> > > > > > a counter example if anyone happens to know, it could be
> > > > > > easy.
> > 
> > The way this works is that the dma_map* calls will bounce buffer memory
> > that does to fall into the addressing limitations.  This is a performance
> > overhead, but allows drivers to address all memory in a system.  If the
> > driver controls memory allocation it should use one of the dma_alloc_*
> > APIs that allocate addressable memory from the start.  The allocator
> > will dip into ZONE_DMA and ZONE_DMA32 when needed.
> 

