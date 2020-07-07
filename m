Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B95121766D
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 20:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbgGGSSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 14:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728029AbgGGSSE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 14:18:04 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7A2C061755
        for <stable@vger.kernel.org>; Tue,  7 Jul 2020 11:18:03 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id t74so25351026lff.2
        for <stable@vger.kernel.org>; Tue, 07 Jul 2020 11:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BS5oJnyO5K6NCAB/a52k+DpKF9O4k6VgS2Nzs3Rg6YI=;
        b=ey0CiRFAVZbnWmWODi8Xx4vhHFmJgql/gTkk6J7K1SKAyufCkI5s9HfnX8dQtnx7Ss
         uz813mi+4nomybriOWWXmy8bLN0RzFivymy2YY4R8mzM8IVwfY83UYEtJdvtHRnIrS8k
         3eUprbqbJNWX3wIIo+4/Yh8EDHdqm0NshTptsqEidKNb5JZifJyOYMUPYW4oSkXQWleH
         PkhXyZmhn3DCGC2xjIrSo/qS4okjg+aEyhHWtq25j4ajy90Fb0ejYwzcnHAmYwP+n2qP
         rTSVVpPPOC01AhL1yTYbsCKjvQmdIJOUxzNy+cnl4TWx/+9eg838aRsHuxVV7qp1h6IY
         nrQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BS5oJnyO5K6NCAB/a52k+DpKF9O4k6VgS2Nzs3Rg6YI=;
        b=SlGcewxtjfFsGdM55MSEks650299xS1LE7Tms5N/4Pn9YJejT9TXqxbR1oMa/8plmU
         nwL1ml68w3sR+AFYLLZC46zr2kxFYMuVLLCttmTzh+xu7EsE3Y2Ncy2qGUqiwEHfNqh6
         kLvVBhXnwArzosK9HwStpuud51AaM1oajbq838VfPNu81TFkI93jHwD3UnZHvfY2H92+
         klmLqyNkN49l1ubnD6kzrBfWsDDzar/6mdNa6gRk0sXBngCFrz7gDpETWV1APnwNfOC/
         PH+Ze7UjKWxDYT98V/efyTOfY/XJs756tkzdAQpvXlKD0NfRMpsO4LBYI3ry0XmY0WyG
         rXhw==
X-Gm-Message-State: AOAM531xhId+hi6NVT4xQW1SF66WqmkmR+xKEaM+jSnx1h3oHlG1aE27
        G6A65PGFHRo4NLSza8ELAY6rHXqlv7igLBDRjBs=
X-Google-Smtp-Source: ABdhPJy93bC3ASladwqXdXhPKCrPOP5AsPWvyqZe8J8HwWOnhjwya9nI/LymqqZJpEniYeng3NvHsQpNlhFSRPLS4Vg=
X-Received: by 2002:a05:6512:4c6:: with SMTP id w6mr31399501lfq.76.1594145882259;
 Tue, 07 Jul 2020 11:18:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200707160012.1299338-1-chris@chris-wilson.co.uk>
 <CALqoU4y61Yc5ndaLSO3WoGSPxGm1nJJufk3U=uxhZe3sT1Xyzg@mail.gmail.com> <159414243217.17526.6453360763938648186@build.alporthouse.com>
In-Reply-To: <159414243217.17526.6453360763938648186@build.alporthouse.com>
From:   lepton <ytht.net@gmail.com>
Date:   Tue, 7 Jul 2020 11:17:51 -0700
Message-ID: <CALqoU4ypBqcAo+xH2usVRffKzR6AkgGdJBmQ0vWe9MZ1kTHCqw@mail.gmail.com>
Subject: Re: [PATCH 1/2] drm/vgem: Do not allocate backing shmemfs file for an
 import dmabuf object
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Daniel Vetter <daniel@ffwll.ch>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas_os@shipmail.org>,
        "# v4 . 10+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 7, 2020 at 10:20 AM Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> Quoting lepton (2020-07-07 18:05:21)
> > On Tue, Jul 7, 2020 at 9:00 AM Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > >
> > > If we assign obj->filp, we believe that the create vgem bo is native and
> > > allow direct operations like mmap() assuming it behaves as backed by a
> > > shmemfs inode. When imported from a dmabuf, the obj->pages are
> > > not always meaningful and the shmemfs backing store misleading.
> > >
> > > Note, that regular mmap access to a vgem bo is via the dumb buffer API,
> > > and that rejects attempts to mmap an imported dmabuf,
> > What do you mean by "regular mmap access" here?  It looks like vgem is
> > using vgem_gem_dumb_map as .dumb_map_offset callback then it doesn't call
> > drm_gem_dumb_map_offset
>
> As I too found out, and so had to correct my story telling.
>
> By regular mmap() access I mean mmap on the vgem bo [via the dumb buffer
> API] as opposed to mmap() via an exported dma-buf fd. I had to look at
> igt to see how it was being used.
Now it seems your fix is to disable "regular mmap" on imported dma buf
for vgem. I am not really a graphic guy, but then the api looks like:
for a gem handle, user space has to guess to find out the way to mmap
it. If user space guess wrong, then it will fail to mmap. Is this the
expected way
for people to handle gpu buffer?
> -Chris
