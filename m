Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D75FF102517
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 14:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbfKSNDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 08:03:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44854 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725798AbfKSNDc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 08:03:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574168610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VVKdPHyNInKr1jXwID8mLSj5pIoLgSLr+NLS/+lX59s=;
        b=QBzFubHnIHunF1tzTLHQLITjgu82qPyk/62e3JDNPHl3OwQQ14qpXRSwQu4NWBg/u9RrH2
        pAmnkQSH8r9TNV4B+IFoy3ls2kpJOrzLcHe9LqK084lJASGixalN+kSdE8lDQgzsrjoGjV
        IEiqd1t8scivkG1GW0qbD16NM0vJEW8=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-CBkKTUcKM86WBjA878TyOA-1; Tue, 19 Nov 2019 08:03:26 -0500
Received: by mail-qv1-f70.google.com with SMTP id i32so14628542qvi.21
        for <stable@vger.kernel.org>; Tue, 19 Nov 2019 05:03:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U7VXEEogLZ2y/UYgVzgWhynH6YujLFzwyuHzw1/YNWU=;
        b=Z2AmeWk3DW99l1Ifp44q2fUjI4mPrWlUdcScVk4bzcphQegmRL8j5x5IPz+6EMtici
         /LdFrDa1/MW4NqODPRKEBeFGwUN6ABLV7Av2HukygnslBlSmAANpE0w+FUVKOPf+snpw
         lQI9Iw8nUJsAubOl63L1tNSwDZ/sY4+0pAmoz5Dy/EXoJddiUu/qIoeVbPwSECUxY/f6
         tPU37B1idmzJ0pWGZERlsUf9oSmiquL+jq524bAC4h7P1Dp/5nWxDUrH0Wab+OcrSY26
         gwjjQwtWWQjXOI8Vek+JoZzk6u74CTGLfNowfkoM6SFlD7ceg8nQF/xdplsM0w08oroE
         fWTw==
X-Gm-Message-State: APjAAAWEv7vf2+nr4vxZEhaPyms8oW8+qykNTaaZVzOQp+wU6yvOifzT
        5ZGdP4kOOzSLk6C75pVOxBsd4XM1ha/hL8UMds9c9WbLl8C9yflekCDdAcF4axrTlMr4ypyZQtY
        xsAXDfCxuXQTGbJdx
X-Received: by 2002:ae9:edc6:: with SMTP id c189mr29290249qkg.351.1574168606026;
        Tue, 19 Nov 2019 05:03:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqyiIfkMbDD3N5CTsf6CCSVQpQTOzwgDzZyzojxHwiP+jBWlIneB91vqUjmHw3eYsoLuHqhzZw==
X-Received: by 2002:ae9:edc6:: with SMTP id c189mr29290210qkg.351.1574168605618;
        Tue, 19 Nov 2019 05:03:25 -0800 (PST)
Received: from redhat.com (bzq-79-176-6-42.red.bezeqint.net. [79.176.6.42])
        by smtp.gmail.com with ESMTPSA id 187sm10260541qkk.103.2019.11.19.05.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 05:03:24 -0800 (PST)
Date:   Tue, 19 Nov 2019 08:03:19 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Khazhismel Kumykov <khazhy@google.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio_balloon: fix shrinker scan number of pages
Message-ID: <20191119080254-mutt-send-email-mst@kernel.org>
References: <20191119101718.38976-1-mst@redhat.com>
 <34c84d6a-d200-c296-39bb-4770bf4517e9@redhat.com>
MIME-Version: 1.0
In-Reply-To: <34c84d6a-d200-c296-39bb-4770bf4517e9@redhat.com>
X-MC-Unique: CBkKTUcKM86WBjA878TyOA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 12:39:51PM +0100, David Hildenbrand wrote:
> On 19.11.19 11:17, Michael S. Tsirkin wrote:
> > virtio_balloon_shrinker_scan should return number of system pages freed=
,
> > but because it's calling functions that deal with balloon pages, it get=
s
> > confused and sometimes returns the number of balloon pages.
> >=20
> > It does not matter practically as the exact number isn't
> > used, but it seems better to be consistent in case someone
> > starts using this API.
>=20
> If it doesn't matter, why cc: stable?

Oh right. Sorry.

> >=20
> > Further, if we ever tried to iteratively leak pages as
> > virtio_balloon_shrinker_scan tries to do, we'd run into issues - this i=
s
> > because freed_pages was accumulating total freed pages, but was also
> > subtracted on each iteration from pages_to_free, which can result in
> > either leaking less memory than we were supposed to free, or or more if
> > pages_to_free underruns.
> >=20
> > On a system with 4K pages we are lucky that we are never asked to leak
> > more than 128 pages while we can leak up to 256 at a time,
> > but it looks like a real issue for systems with page size !=3D 4K.
> >=20
> > Cc: stable@vger.kernel.org
> > Fixes: 71994620bb25 ("virtio_balloon: replace oom notifier with shrinke=
r")
> > Reported-by: Khazhismel Kumykov <khazhy@google.com>
> > Reviewed-by: Wei Wang <wei.w.wang@intel.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >   drivers/virtio/virtio_balloon.c | 17 +++++++++++------
> >   1 file changed, 11 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_ba=
lloon.c
> > index 226fbb995fb0..7cee05cdf3fb 100644
> > --- a/drivers/virtio/virtio_balloon.c
> > +++ b/drivers/virtio/virtio_balloon.c
> > @@ -772,6 +772,13 @@ static unsigned long shrink_free_pages(struct virt=
io_balloon *vb,
> >   =09return blocks_freed << VIRTIO_BALLOON_FREE_PAGE_ORDER;
> >   }
> > +static unsigned long leak_balloon_pages(struct virtio_balloon *vb,
> > +                                          unsigned long pages_to_free)
> > +{
> > +=09return leak_balloon(vb, pages_to_free * VIRTIO_BALLOON_PAGES_PER_PA=
GE) /
> > +=09=09VIRTIO_BALLOON_PAGES_PER_PAGE;
> > +}
> > +
> >   static unsigned long shrink_balloon_pages(struct virtio_balloon *vb,
> >   =09=09=09=09=09  unsigned long pages_to_free)
> >   {
> > @@ -782,11 +789,9 @@ static unsigned long shrink_balloon_pages(struct v=
irtio_balloon *vb,
> >   =09 * VIRTIO_BALLOON_ARRAY_PFNS_MAX balloon pages, so we call it
> >   =09 * multiple times to deflate pages till reaching pages_to_free.
> >   =09 */
> > -=09while (vb->num_pages && pages_to_free) {
> > -=09=09pages_freed +=3D leak_balloon(vb, pages_to_free) /
> > -=09=09=09=09=09VIRTIO_BALLOON_PAGES_PER_PAGE;
> > -=09=09pages_to_free -=3D pages_freed;
> > -=09}
> > +=09while (vb->num_pages && pages_freed < pages_to_free)
> > +=09=09pages_freed +=3D leak_balloon_pages(vb, pages_to_free);
> > +
> >   =09update_balloon_size(vb);
> >   =09return pages_freed;
> > @@ -799,7 +804,7 @@ static unsigned long virtio_balloon_shrinker_scan(s=
truct shrinker *shrinker,
> >   =09struct virtio_balloon *vb =3D container_of(shrinker,
> >   =09=09=09=09=09struct virtio_balloon, shrinker);
> > -=09pages_to_free =3D sc->nr_to_scan * VIRTIO_BALLOON_PAGES_PER_PAGE;
> > +=09pages_to_free =3D sc->nr_to_scan;
> >   =09if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
> >   =09=09pages_freed =3D shrink_free_pages(vb, pages_to_free);
> >=20
>=20
>=20
> --=20
>=20
> Thanks,
>=20
> David / dhildenb

