Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F22A2645E43
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 17:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiLGQAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 11:00:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiLGQAf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 11:00:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46AE32BAB
        for <stable@vger.kernel.org>; Wed,  7 Dec 2022 07:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670428777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3ds86l2H1ZNflWHy4/S2aLn7l+F5D9ot2q/ERt4zH3Q=;
        b=ZQooae21RRhNfwRs8sP1Y+zABPdUBxfmG1+4kKBy848nEJIhQxT/fUko4F7Oi+FSk3Qjmd
        ypSHeVE9nMF+QI5EmYUwsqW0DDkbaBoWCzMZKhdYqGGeI72M9A8kVHUIZiN4SDIhWV1ZDO
        rSn0tohQh+t4+vFM7pTuXs/FwXHSlkU=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-494-uuj5fN9WMhihJOZI_o_HGA-1; Wed, 07 Dec 2022 10:59:36 -0500
X-MC-Unique: uuj5fN9WMhihJOZI_o_HGA-1
Received: by mail-qv1-f72.google.com with SMTP id og17-20020a056214429100b004c6ae186493so37002725qvb.3
        for <stable@vger.kernel.org>; Wed, 07 Dec 2022 07:59:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3ds86l2H1ZNflWHy4/S2aLn7l+F5D9ot2q/ERt4zH3Q=;
        b=jqOwMilZX19I+qC4FKYnTsRYVScCc8Y/uQlJAeElDWc8WQ03ZFavB6pvhyLXABHOPM
         1ipS5KSqweCIFhv6fyUA6LC27EfBXX1ipADH2KyrsPQ00wqpws3RbxBc54Tak/8RqFeA
         GdsGmFzy/srfyBaJsTiBY2FshzsgvIOC29840vzPtncW/5zPCLr7D9hm6fDv76UujuyV
         qS872bqobR+xN6YRtMdSpIycAwcHiNBrCMoYbMtJbZC6JjQb18tPIrnE54PAJTTJGbW7
         d0NJtEI+2We35oKSeBYKy52vywxktVEJK1bHoHsKOQKmoeRH3dSJKqViaJV9nMQP2f3s
         G+6Q==
X-Gm-Message-State: ANoB5pkzLyBzbO59k/QR8XFoj+odaODYLUqD8rxUusqzvKdFq3tIUjGD
        xk+cnIUzvECcTUVoB3atTE0UUgleT1r20B3/EmMQ12UHBnN5mpycn+NgBMt/0CLUujaZmlXOPHz
        uX8AvVqSSvWJMAWZk
X-Received: by 2002:a05:6214:2b97:b0:4c7:734a:9047 with SMTP id kr23-20020a0562142b9700b004c7734a9047mr1202636qvb.50.1670428776078;
        Wed, 07 Dec 2022 07:59:36 -0800 (PST)
X-Google-Smtp-Source: AA0mqf56ieISDBHezYDAzZ+VpWdZ5V6o2u1bx+Hff3p4ac7yFjt3BUL6MXewhOVSKr+NI9MhWdKWhA==
X-Received: by 2002:a05:6214:2b97:b0:4c7:734a:9047 with SMTP id kr23-20020a0562142b9700b004c7734a9047mr1202631qvb.50.1670428775800;
        Wed, 07 Dec 2022 07:59:35 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id bj7-20020a05620a190700b006cfc1d827cbsm17170597qkb.9.2022.12.07.07.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 07:59:35 -0800 (PST)
Date:   Wed, 7 Dec 2022 10:59:34 -0500
From:   Peter Xu <peterx@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ives van Hoorne <ives@codesandbox.io>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hugh@veritas.com>,
        Alistair Popple <apopple@nvidia.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH RFC] mm/userfaultfd: enable writenotify while
 userfaultfd-wp is enabled for a VMA
Message-ID: <Y5C4Zu9sDvZ7KiCk@x1n>
References: <20221202122748.113774-1-david@redhat.com>
 <Y4oo6cN1a4Yz5prh@x1n>
 <690afe0f-c9a0-9631-b365-d11d98fdf56f@redhat.com>
 <19800718-9cb6-9355-da1c-c7961b01e922@redhat.com>
 <Y45duzmGGUT0+u8t@x1n>
 <92173bad-caa3-6b43-9d1e-9a471fdbc184@redhat.com>
 <Y4+zw4JU7JMlDHbM@x1n>
 <5a626d30-ccc9-6be3-29f7-78f83afbe5c4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5a626d30-ccc9-6be3-29f7-78f83afbe5c4@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 07, 2022 at 02:33:58PM +0100, David Hildenbrand wrote:
> On 06.12.22 22:27, Peter Xu wrote:
> > On Tue, Dec 06, 2022 at 05:28:07PM +0100, David Hildenbrand wrote:
> > > > If no one is using mprotect() with uffd-wp like that, then the reproducer
> > > > may not be valid - the reproducer is defining how it should work, but does
> > > > that really stand?  That's why I said it's ambiguous, because the
> > > > definition in this case is unclear.
> > > 
> > > There are interesting variations like:
> > > 
> > > mmap(PROT_READ, MAP_POPULATE|MAP_SHARED)
> > > uffd_wp()
> > > mprotect(PROT_READ|PROT_WRITE)
> > > 
> > > Where we start out with all-write permissions before we enable selective
> > > write permissions.
> > 
> > Could you elaborate what's the difference of above comparing to:
> > 
> > mmap(PROT_READ|PROT_WRITE, MAP_POPULATE|MAP_SHARED)
> > uffd_wp()
> > 
> > ?
> 
> That mapping would temporarily allow write access. I'd imagine that
> something like that might be useful when atomically replacing an existing
> mapping (MAP_FIXED), and the VMA might already be in use by other threads.
> or when you really want to catch any possible write access.
> 
> For example, libvhost-user.c in QEMU uses for ordinary postcopy:
> 
>         /*
>          * In postcopy we're using PROT_NONE here to catch anyone
>          * accessing it before we userfault.
>          */
>         mmap_addr = mmap(0, dev_region->size + dev_region->mmap_offset,
>                          PROT_NONE, MAP_SHARED | MAP_NORESERVE,
>                          vmsg->fds[0], 0);

I assume this is for missing mode only.  More on wr-protect mode below.

Personally I don't see immediately on whether this is needed.  If the
process itself is trusted then it should be under control of anyone who
will be accessing the pages..  If the other threads are not trusted, then
there's no way to stop anyone from mprotect(RW) after mprotect(NONE)
anyway..

So I may not really get the gut of it.

Another way to make sure no one access it is right after receiving the
memory range from QEMU (VhostUserMemoryRegion), if VuDev.postcopy_listening
is set, then we register the range with UFFD missing immediately.  After
all if postcopy_listening is set it means we passed the advise phase
already (VHOST_USER_POSTCOPY_ADVISE). Any potential access will be blocked
until QEMU starts to read on that uffd.

> 
> I'd imagine, when using uffd-wp (VM snapshotting with shmem?) one might use
> PROT_READ instead before the write-protection is properly set. Because read
> access would be fine in the meantime.

It'll be different for wr-protect IIUC, because unlike missing protections,
we don't worry about writes happening before UFFDIO_WRITEPROTECT.

IMHO the solo thing the vhost-user proc needs to do is one
UFFDIO_WRITEPROTECT for each of the range when QEMU tells it to, then it'll
be fine.  Pre-writes are fine.

Sorry I probably went a bit off-topic.  I just want to make sure I don't
miss any real use case of having mprotect being useful for uffd-wp being
there, because that used to be a grey area for me.

> 
> But I'm just pulling use cases out of my magic hat ;) Nothing stops user
> space from doing things that are not clearly forbidden (well, even then
> users might complain, but that's a different story).

Yes, I think those are always fine but the user just cannot assume it'll
work as they assumed how it will work.

If "doing things that are not clearly forbidden" triggers a host warning or
crash that's a bug, OTOH if the outcome is limited to the process itself
then from kernel pov I think we're good.  I used to even thought about
forbid mprotect() on uffd-wp but I'm not sure whether it's good idea either.

Let's see whether I missed something above, if so I'll rethink.

Thanks,

-- 
Peter Xu

