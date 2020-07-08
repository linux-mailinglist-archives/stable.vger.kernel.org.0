Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067E8218AA9
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 17:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729868AbgGHPCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 11:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729022AbgGHPCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 11:02:02 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F730C061A0B
        for <stable@vger.kernel.org>; Wed,  8 Jul 2020 08:02:01 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id 18so37118292otv.6
        for <stable@vger.kernel.org>; Wed, 08 Jul 2020 08:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xnvnczozBBcp48MYhIL4k8d048bjLCb67Tbr1lAP6do=;
        b=dD5sbTVINSKYG6LI8iQIb9/dRfXH6cSTzpYbhSu6T6LdbXmUXhAvSg2Yf1ql5S/GIP
         fTKLZIIted9X52koEacmyJkMLlkXNwxf+kHd73I6H4rocqm3VfnrPlsy4KZk72N+ycSg
         1t332EW+ntbZ6j5/alVBXw7PigSseR8MGMEO0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xnvnczozBBcp48MYhIL4k8d048bjLCb67Tbr1lAP6do=;
        b=aFhOl7DDAA9ydhqZZ9G0slTuCoewi51orvbAwVu68SOjUEPOLKV/mLElk+OnWhe5gD
         ShdZzUhq4Vq150zLAYBT2Sa0HckGpOV6idgHgwHUdcr+V6VlwmP8Nu1kfvRaRddfGTqu
         cwKBK+33xVDQ9pKuqOX7R7BquG/zXivywNq6sagltLthqee84VJhZrXYasp4iKASPaOj
         qqTfka+lG2Dht5yl2Y1RjwrMJyNkxFoXCuHnEYrRRMD6SzVF1Py+z2JxQShyPKqEhL2l
         8VCdDy9o2yMBsq0j1h1r5SKV8V+yETWE6DS0SM+DiQxXiLoh6v1Su0+rJdYt9Xkclxw0
         M59g==
X-Gm-Message-State: AOAM530oiqgcSON+VlLQHgX1y62T3TQR4h4pwPPNVPEZV1Q+TiCbDkzj
        cZP5qRAbVlFgsYIIDP5VUT7pUiuC0nUCJ+5+WnZqNQ==
X-Google-Smtp-Source: ABdhPJwIxjemNVY+1W1eWrvVFue8y6i42o6Q6XDtKw2tLXebnxb96cPjMlsiMpRHLAkcTFrwW5YgHUhqPwVhBHMfXIE=
X-Received: by 2002:a05:6830:1d0:: with SMTP id r16mr39652535ota.188.1594220519515;
 Wed, 08 Jul 2020 08:01:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200707160012.1299338-1-chris@chris-wilson.co.uk>
 <CALqoU4y61Yc5ndaLSO3WoGSPxGm1nJJufk3U=uxhZe3sT1Xyzg@mail.gmail.com>
 <159414243217.17526.6453360763938648186@build.alporthouse.com>
 <CALqoU4ypBqcAo+xH2usVRffKzR6AkgGdJBmQ0vWe9MZ1kTHCqw@mail.gmail.com>
 <159414692385.17526.10068675168880429917@build.alporthouse.com>
 <b8e6d844-f096-8efc-1252-ef430069d080@amd.com> <20200708095405.GJ3278063@phenom.ffwll.local>
 <d59a0057-31db-ce8e-e83d-cd9e023a9ab2@amd.com>
In-Reply-To: <d59a0057-31db-ce8e-e83d-cd9e023a9ab2@amd.com>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Wed, 8 Jul 2020 17:01:48 +0200
Message-ID: <CAKMK7uF1nXT-q-rJK0s2yUQa8h8qJmzO=p-ouzvXVQ5HgkE9Qg@mail.gmail.com>
Subject: Re: [PATCH 1/2] drm/vgem: Do not allocate backing shmemfs file for an
 import dmabuf object
To:     =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        lepton <ytht.net@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas_os@shipmail.org>,
        "# v4.10+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 8, 2020 at 4:37 PM Christian K=C3=B6nig <christian.koenig@amd.c=
om> wrote:
>
> Am 08.07.20 um 11:54 schrieb Daniel Vetter:
> > On Wed, Jul 08, 2020 at 11:22:00AM +0200, Christian K=C3=B6nig wrote:
> >> Am 07.07.20 um 20:35 schrieb Chris Wilson:
> >>> Quoting lepton (2020-07-07 19:17:51)
> >>>> On Tue, Jul 7, 2020 at 10:20 AM Chris Wilson <chris@chris-wilson.co.=
uk> wrote:
> >>>>> Quoting lepton (2020-07-07 18:05:21)
> >>>>>> On Tue, Jul 7, 2020 at 9:00 AM Chris Wilson <chris@chris-wilson.co=
.uk> wrote:
> >>>>>>> If we assign obj->filp, we believe that the create vgem bo is nat=
ive and
> >>>>>>> allow direct operations like mmap() assuming it behaves as backed=
 by a
> >>>>>>> shmemfs inode. When imported from a dmabuf, the obj->pages are
> >>>>>>> not always meaningful and the shmemfs backing store misleading.
> >>>>>>>
> >>>>>>> Note, that regular mmap access to a vgem bo is via the dumb buffe=
r API,
> >>>>>>> and that rejects attempts to mmap an imported dmabuf,
> >>>>>> What do you mean by "regular mmap access" here?  It looks like vge=
m is
> >>>>>> using vgem_gem_dumb_map as .dumb_map_offset callback then it doesn=
't call
> >>>>>> drm_gem_dumb_map_offset
> >>>>> As I too found out, and so had to correct my story telling.
> >>>>>
> >>>>> By regular mmap() access I mean mmap on the vgem bo [via the dumb b=
uffer
> >>>>> API] as opposed to mmap() via an exported dma-buf fd. I had to look=
 at
> >>>>> igt to see how it was being used.
> >>>> Now it seems your fix is to disable "regular mmap" on imported dma b=
uf
> >>>> for vgem. I am not really a graphic guy, but then the api looks like=
:
> >>>> for a gem handle, user space has to guess to find out the way to mma=
p
> >>>> it. If user space guess wrong, then it will fail to mmap. Is this th=
e
> >>>> expected way
> >>>> for people to handle gpu buffer?
> >>> You either have a dumb buffer handle, or a dma-buf fd. If you have th=
e
> >>> handle, you have to use the dumb buffer API, there's no other way to
> >>> mmap it. If you have the dma-buf fd, you should mmap it directly. Tho=
se
> >>> two are clear.
> >>>
> >>> It's when you import the dma-buf into vgem and create a handle out of
> >>> it, that's when the handle is no longer first class and certain uAPI
> >>> [the dumb buffer API in particular] fail.
> >>>
> >>> It's not brilliant, as you say, it requires the user to remember the
> >>> difference between the handles, but at the same time it does prevent
> >>> them falling into coherency traps by forcing them to use the right
> >>> driver to handle the object, and have to consider the additional ioct=
ls
> >>> that go along with that access.
> >> Yes, Chris is right. Mapping DMA-buf through the mmap() APIs of an imp=
orter
> >> is illegal.
> >>
> >> What we could maybe try to do is to redirect this mmap() API call on t=
he
> >> importer to the exporter, but I'm pretty sure that the fs layer wouldn=
't
> >> like that without changes.
> > We already do that, there's a full helper-ified path from I think shmem
> > helpers through prime helpers to forward this all. Including handling
> > buffer offsets and all the other lolz back&forth.
>
> Oh, that most likely won't work correctly with unpinned DMA-bufs and
> needs to be avoided.
>
> Each file descriptor is associated with an struct address_space. And
> when you mmap() through the importer by redirecting the system call to
> the exporter you end up with the wrong struct address_space in your VMA.
>
> That in turn can go up easily in flames when the exporter tries to
> invalidate the CPU mappings for its DMA-buf while moving it.
>
> Where are we doing this? My last status was that this is forbidden.

Hm I thought we're doing all that already, but looking at the code
again we're only doing this when opening a new drm fd or dma-buf fd.
So the right file->f_mapping is always set at file creation time.

And we indeed don't frob this more when going another indirection ...
Maybe we screwed up something somewhere :-/

Also I thought the mapping is only taken after the vma is instatiated,
otherwise the tricks we're playing with dma-buf already wouldn't work:
dma-buf has the buffer always at offset 0, whereas gem drm_fd mmap has
it somewhere else. We already adjust vma->vm_pgoff, so I'm wondering
whether we could adjust vm_file too. Or is that the thing that's
forbidden?
-Daniel

> Christian.
>
> > Of course there's still the problem that many drivers don't forward the
> > cache coherency calls for begin/end cpu access, so in a bunch of cases
> > you'll cache cacheline dirt soup. But that's kinda standard procedure f=
or
> > dma-buf :-P
> >
> > But yeah trying to handle the mmap as an importer, bypassing the export=
:
> > nope. The one exception is if you have some kind of fancy gart with
> > cpu-visible pci bar (like at least integrated intel gpus have). But in
> > that case the mmap very much looks&acts like device access in every way=
.
> >
> > Cheers, Daniel
> >
> >> Regards,
> >> Christian.
> >>
> >>
> >>> -Chris
>


--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
