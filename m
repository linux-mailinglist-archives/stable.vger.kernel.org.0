Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A939C475ACE
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 15:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242239AbhLOOmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 09:42:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52781 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243427AbhLOOmi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 09:42:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639579357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DRVbhue+YBe2AzpJnQbC+hJztV++FER/EJMMHEHF/mE=;
        b=MKNsWdFhVc8rZrbywSKwovKLCFcoETE408NrKmHGHqrEUB5CBLVe72wLtjlTSnUZvnPWeE
        LOLr1ppTcI2k50z9sharK/TgTAAOYNC7BW4ayrWylbNZ8SBEc6w4PiRswvBur9lW+qbTo3
        T+GtGKbIhlOOn0B3a79bmNSZasCzArM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-A5H6TXp3OLCkFI-8D18BaA-1; Wed, 15 Dec 2021 09:42:35 -0500
X-MC-Unique: A5H6TXp3OLCkFI-8D18BaA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5DA31927830;
        Wed, 15 Dec 2021 14:42:33 +0000 (UTC)
Received: from localhost (ovpn-12-120.pek2.redhat.com [10.72.12.120])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 759A370D58;
        Wed, 15 Dec 2021 14:42:31 +0000 (UTC)
Date:   Wed, 15 Dec 2021 22:42:28 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc:     Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org, hch@lst.de,
        cl@linux.com, John.p.donnelly@oracle.com,
        kexec@lists.infradead.org, stable@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v3 5/5] mm/slub: do not create dma-kmalloc if no managed
 pages in DMA zone
Message-ID: <20211215144228.GF10336@MiWiFi-R3L-srv>
References: <20211213122712.23805-1-bhe@redhat.com>
 <20211213122712.23805-6-bhe@redhat.com>
 <20211213134319.GA997240@odroid>
 <20211214053253.GB2216@MiWiFi-R3L-srv>
 <f5ff82eb-73b6-55b5-53d7-04ab73ce5035@suse.cz>
 <20211215044818.GB1097530@odroid>
 <20211215070335.GA1165926@odroid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215070335.GA1165926@odroid>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/15/21 at 07:03am, Hyeonggon Yoo wrote:
> On Wed, Dec 15, 2021 at 04:48:26AM +0000, Hyeonggon Yoo wrote:
> > 
> > Hello Baoquan and Vlastimil.
> > 
> > I'm not sure allowing ZONE_DMA32 for kdump kernel is nice way to solve
> > this problem. Devices that requires ZONE_DMA is rare but we still
> > support them.
> > 
> > If we allow ZONE_DMA32 for ZONE_DMA in kdump kernels,
> > the problem will be hard to find.
> > 
> 
> Sorry, I sometimes forget validating my english writing :(
> 
> What I meant:
> 
> I'm not sure that allocating from ZONE_DMA32 instead of ZONE_DMA
> for kdump kernel is nice way to solve this problem.

Yeah, if it's really <32bit addressing limit on device, it doesn't solve
problem. Not sure if devices really has the limitation when
kmalloc(GFP_DMA) is invoked kernel driver.

> 
> Devices that requires ZONE_DMA memory is rare but we still support them.
> 
> If we use ZONE_DMA32 memory instead of ZONE_DMA in kdump kernels,
> It will be hard to the problem when we use devices that can use only
> ZONE_DMA memory.
> 
> > What about one of those?:
> > 
> >     1) Do not call warn_alloc in page allocator if will always fail
> >     to allocate ZONE_DMA pages.
> > 

Seems we can do like below.

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7c7a0b5de2ff..843bc8e5550a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4204,7 +4204,8 @@ void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...)
 	va_list args;
 	static DEFINE_RATELIMIT_STATE(nopage_rs, 10*HZ, 1);
 
-	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs))
+	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs) ||
+		(gfp_mask & __GFP_DMA) && !has_managed_dma())
 		return;
 
> > 
> >     2) let's check all callers of kmalloc with GFP_DMA
> >     if they really need GFP_DMA flag and replace those by DMA API or
> >     just remove GFP_DMA from kmalloc()

I grepped and got a list, I will try to start with several easy place,
see if we can do something to improve.
start with.


> > 
> >     3) Drop support for allocating DMA memory from slab allocator
> >     (as Christoph Hellwig said) and convert them to use DMA32
> 
> 	(as Christoph Hellwig said) and convert them to use *DMA API*

Yes, that will be ideal result. This is equivalent to 2), or depends
on 2).

> 
> >     and see what happens
> > 
> > Thanks,
> > Hyeonggon.
> > 
> > > >> 
> > > >> Maybe the function get_capabilities() want to allocate memory
> > > >> even if it's not from DMA zone, but other callers will not expect that.
> > > > 
> > > > Yeah, I have the same guess too for get_capabilities(), not sure about other
> > > > callers. Or, as ChristophL and ChristophH said(Sorry, not sure if this is
> > > > the right way to call people when the first name is the same. Correct me if
> > > > it's wrong), any buffer requested from kmalloc can be used by device driver.
> > > > Means device enforces getting memory inside addressing limit for those
> > > > DMA transferring buffer which is usually large, Megabytes level with
> > > > vmalloc() or alloc_pages(), but doesn't care about this kind of small
> > > > piece buffer memory allocated with kmalloc()? Just a guess, please tell
> > > > a counter example if anyone happens to know, it could be easy.
> > > > 
> > > > 
> > > >> 
> > > >> >  			kmalloc_caches[KMALLOC_DMA][i] = create_kmalloc_cache(
> > > >> >  				kmalloc_info[i].name[KMALLOC_DMA],
> > > >> >  				kmalloc_info[i].size,
> > > >> > -- 
> > > >> > 2.17.2
> > > >> > 
> > > >> > 
> > > >> 
> > > > 
> > > 
> 

