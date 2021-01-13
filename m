Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804BA2F42ED
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 05:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbhAMEOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 23:14:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43737 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726251AbhAMEOd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 23:14:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610511187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2uX+184DuL6+IbX64Mwow/W3eFyTHIEtajxhKilUb2U=;
        b=ioac+Wmu6mkdsW1k9LjGCeTztNpAIMssp8SXUPMk7jVl73+3p1VKCOV7AzWKV3IN8yZTTv
        wetVVvYI2aE4+9Az0/wwQLxoaw7QPyUVlvMJ8GV/CjUzVwVPmkIH9UkwJUbUVOp7aAQC+g
        qgpFtifzZjj7B3yskrO5UjrlgvB8DeM=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-D1mtKT0OPJaNw31RNOFn_Q-1; Tue, 12 Jan 2021 23:13:03 -0500
X-MC-Unique: D1mtKT0OPJaNw31RNOFn_Q-1
Received: by mail-pj1-f70.google.com with SMTP id m9so368300pji.4
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 20:13:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2uX+184DuL6+IbX64Mwow/W3eFyTHIEtajxhKilUb2U=;
        b=GAKxILEpsWZU2GoU2IF+gZf5MnVEQ/t2vYLzW0CfQPZwjJ40sCOW1ZhstK+vS7+Eon
         GP4elaWFxWBfbsTZiBqhatqtm3fPVtZiJEcPQwQZQC81xjFMlHDs81T4nXYRE9LsqzsS
         9BiDEYoC7IV4AwoNNxAjRdUWURkJTt+j0cUnHLPxGLml1lqMA/1q0xsDiAKklawcbLla
         MTiFsl/3T1uQ5+3G1N18VW2SddEO86gRinjxw8DjIfUi7B6t41VSxdoixtAMSxNdFg0o
         8Sst0kgwJObS09Kzgth53D8sVUxwDhRkV5X4w1TlobHpC+zfXpOo4W6njuiqnKBv5Gnh
         Dwdw==
X-Gm-Message-State: AOAM531IngZozpPY+Wf5uBGeaRjKYNRxnRC4cg4WztOAkCdLdCk+trVn
        UY5BxY/ZvqLRYgJbyoZneLg0M4g9F/x3Y8GdY1dffvvAwv5u9ZqqBJVQ5ayE4lgzCikmGT78PAg
        lEg4PLY7wMIYvu6pvBH0GsEkZxxtGmYdq
X-Received: by 2002:a17:902:8a8a:b029:db:e003:4044 with SMTP id p10-20020a1709028a8ab02900dbe0034044mr366032plo.19.1610511182736;
        Tue, 12 Jan 2021 20:13:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJynudTkku66m+FnxiitvS/UCRuOamqko46/CvqV825uh3S7t3CEzojH3Xb6x1N1Bhbp9yNW4vMWEWRPv+P7H60=
X-Received: by 2002:a17:902:8a8a:b029:db:e003:4044 with SMTP id
 p10-20020a1709028a8ab02900dbe0034044mr366015plo.19.1610511182494; Tue, 12 Jan
 2021 20:13:02 -0800 (PST)
MIME-Version: 1.0
References: <20210112053629.9853-1-lulu@redhat.com> <1403c336-4493-255f-54e3-c55dd2015c40@redhat.com>
In-Reply-To: <1403c336-4493-255f-54e3-c55dd2015c40@redhat.com>
From:   Cindy Lu <lulu@redhat.com>
Date:   Wed, 13 Jan 2021 12:12:25 +0800
Message-ID: <CACLfguVi7XZ_HR4Gxcc3=_XHZnZ8q2bcuJcqEuu56E+MCZB+RA@mail.gmail.com>
Subject: Re: [PATCH v3] vhost_vdpa: fix the problem in vhost_vdpa_set_config_call
To:     Jason Wang <jasowang@redhat.com>
Cc:     Michael Tsirkin <mst@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 13, 2021 at 11:38 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/1/12 =E4=B8=8B=E5=8D=881:36, Cindy Lu wrote:
> > In vhost_vdpa_set_config_call, the cb.private should be vhost_vdpa.
> > this cb.private will finally use in vhost_vdpa_config_cb as
> > vhost_vdpa. Fix this issue.
> >
> > Fixes: 776f395004d82 ("vhost_vdpa: Support config interrupt in vdpa")
> > Acked-by: Jason Wang <jasowang@redhat.com>
> > Signed-off-by: Cindy Lu <lulu@redhat.com>
> > ---
>
>
> Hi Cindy:
>
> I think at least you forget to cc stable.
>
> Thanks
>
Sure Thanks Jason I will post a new version
>
> >   drivers/vhost/vdpa.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > index ef688c8c0e0e..3fbb9c1f49da 100644
> > --- a/drivers/vhost/vdpa.c
> > +++ b/drivers/vhost/vdpa.c
> > @@ -319,7 +319,7 @@ static long vhost_vdpa_set_config_call(struct vhost=
_vdpa *v, u32 __user *argp)
> >       struct eventfd_ctx *ctx;
> >
> >       cb.callback =3D vhost_vdpa_config_cb;
> > -     cb.private =3D v->vdpa;
> > +     cb.private =3D v;
> >       if (copy_from_user(&fd, argp, sizeof(fd)))
> >               return  -EFAULT;
> >
>

