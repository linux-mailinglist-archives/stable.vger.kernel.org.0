Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEFC5340C81
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 19:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbhCRSJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 14:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbhCRSJH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 14:09:07 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCE6C06174A
        for <stable@vger.kernel.org>; Thu, 18 Mar 2021 11:09:07 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id 19so5734066ilj.2
        for <stable@vger.kernel.org>; Thu, 18 Mar 2021 11:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3JUu5Osgme/9Gnkmzi7AIw6D1gJoZ2L/S/b0kvFRqkc=;
        b=OgIM17fa0CWSdX2+9W6QGhGr2+omJSfyQapIt4WpdF0HIgeo93CRIyzrokSH6M+qZE
         7KSbK0FOIqR0i87k9x460B0lg+ZtS5duqQf0oVnXt6aRFNj2FQBFYkXXyB20buvNxgxl
         pykgEmxgSGBkavKdCMCI1DuX7PRD6s2aDIxiQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3JUu5Osgme/9Gnkmzi7AIw6D1gJoZ2L/S/b0kvFRqkc=;
        b=geaZHzJms5Vp4Wn63WWxibEIfCREyHjjsImUVt6M+peJLwyPN6Co6U/Gz+kIA3SX9V
         qG6DHHCMC0IgT56lkVY1yUWn8gNg9Du9hmx37e8j7ezsf7jatJQpEe3ihmrXI+SDHKja
         RUxzRoZ3CJPLl4YS7V3Am7QlXGqL53XKo2oLola7iqJZbWXaxiZ9pW8XvOJnHyQzDTDw
         O7E0yhsr22VyeWeoMQ1JUuJyFMipraHViZKGumzfCa+QK0RyxMV25GeY6YfbO15WthJs
         uqPxyPS282TtfJYGrTdAc3PNvZV9zZpMh1/sJuQvs6PRKe2mUWjLvJTVsv6SH7kaa831
         P/kg==
X-Gm-Message-State: AOAM532ATITysmcXUWUuUzh56tWifEj+vfD15Pq+ef2Asd+U46LAUJC6
        3rQrZKBWNmXMvMCkYvaOfNptkMHJKgpCDnDvE3++Mw==
X-Google-Smtp-Source: ABdhPJzuyWIbEoTQpouaMOa1VAU62wfzJRq8bcut4YWmkeoBZyP/SVSZuj9vlFf8aAzW4tjP33rZUhyaaK695jKKp0Y=
X-Received: by 2002:a05:6e02:1d11:: with SMTP id i17mr11568106ila.145.1616090947065;
 Thu, 18 Mar 2021 11:09:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210317235522.2497292-1-gwendal@chromium.org>
 <20210318075443.GB2916463@dell> <YFMKsRWTIDeeuEEk@kroah.com> <20210318082054.GD2916463@dell>
In-Reply-To: <20210318082054.GD2916463@dell>
From:   Gwendal Grignou <gwendal@chromium.org>
Date:   Thu, 18 Mar 2021 11:08:55 -0700
Message-ID: <CAPUE2uvSdVVjWrA9pO9FJ8sQw70tt9_X=p7PFY2ppUoitvXp8A@mail.gmail.com>
Subject: Re: [PATCH] platform/chrome: cros_ec_dev - Fix security issue
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Greg KH <greg@kroah.com>, stable@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 18, 2021 at 1:20 AM Lee Jones <lee.jones@linaro.org> wrote:
>
> On Thu, 18 Mar 2021, Greg KH wrote:
>
> > On Thu, Mar 18, 2021 at 07:54:43AM +0000, Lee Jones wrote:
> > > On Wed, 17 Mar 2021, Gwendal Grignou wrote:
> > >
> > > > commit 5d749d0bbe811c10d9048cde6dfebc761713abfd upstream.
> > > >
> > > > Prevent memory scribble by checking that ioctl buffer size paramete=
rs
> > > > are sane.
> > > > Without this check, on 32 bits system, if .insize =3D 0xffffffff - =
20 and
> > > > .outsize the amount to scribble, we would overflow, allocate a smal=
l
> > > > amounts and be able to write outside of the malloc'ed area.
> > > > Adding a hard limit allows argument checking of the ioctl. With the
> > > > current EC, it is expected .insize and .outsize to be at around 512=
 bytes
> > > > or less.
> > > >
> > > > Signed-off-by: Olof Johansson <olof@lixom.net>
> > > > Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
> > > > ---
> > > >  drivers/platform/chrome/cros_ec_dev.c   | 4 ++++
> > > >  drivers/platform/chrome/cros_ec_proto.c | 4 ++--
> > > >  include/linux/mfd/cros_ec.h             | 6 ++++--
> > > >  3 files changed, 10 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/drivers/platform/chrome/cros_ec_dev.c b/drivers/platfo=
rm/chrome/cros_ec_dev.c
> > > > index 2b331d5b9e799..e16d82bb36a9d 100644
> > > > --- a/drivers/platform/chrome/cros_ec_dev.c
> > > > +++ b/drivers/platform/chrome/cros_ec_dev.c
> > > > @@ -137,6 +137,10 @@ static long ec_device_ioctl_xcmd(struct cros_e=
c_dev *ec, void __user *arg)
> > > >   if (copy_from_user(&u_cmd, arg, sizeof(u_cmd)))
> > > >           return -EFAULT;
> > > >
> > > > + if ((u_cmd.outsize > EC_MAX_MSG_BYTES) ||
> > > > +     (u_cmd.insize > EC_MAX_MSG_BYTES))
> > > > +         return -EINVAL;
> > > > +
> > > >   s_cmd =3D kmalloc(sizeof(*s_cmd) + max(u_cmd.outsize, u_cmd.insiz=
e),
> > > >                   GFP_KERNEL);
> > > >   if (!s_cmd)
> > > > diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/plat=
form/chrome/cros_ec_proto.c
> > > > index 5c285f2b3a650..d20190c8f0c06 100644
> > > > --- a/drivers/platform/chrome/cros_ec_proto.c
> > > > +++ b/drivers/platform/chrome/cros_ec_proto.c
> > > > @@ -311,8 +311,8 @@ int cros_ec_query_all(struct cros_ec_device *ec=
_dev)
> > > >                   ec_dev->max_response =3D EC_PROTO2_MAX_PARAM_SIZE=
;
> > > >                   ec_dev->max_passthru =3D 0;
> > > >                   ec_dev->pkt_xfer =3D NULL;
> > > > -                 ec_dev->din_size =3D EC_MSG_BYTES;
> > > > -                 ec_dev->dout_size =3D EC_MSG_BYTES;
> > > > +                 ec_dev->din_size =3D EC_PROTO2_MSG_BYTES;
> > > > +                 ec_dev->dout_size =3D EC_PROTO2_MSG_BYTES;
> > > >           } else {
> > > >                   /*
> > > >                    * It's possible for a test to occur too early wh=
en
> > > > diff --git a/include/linux/mfd/cros_ec.h b/include/linux/mfd/cros_e=
c.h
> > > > index 3ab3cede28eac..93c14e9df6309 100644
> > > > --- a/include/linux/mfd/cros_ec.h
> > > > +++ b/include/linux/mfd/cros_ec.h
> > > > @@ -50,9 +50,11 @@ enum {
> > > >                                   EC_MSG_TX_TRAILER_BYTES,
> > > >   EC_MSG_RX_PROTO_BYTES   =3D 3,
> > > >
> > > > - /* Max length of messages */
> > > > - EC_MSG_BYTES            =3D EC_PROTO2_MAX_PARAM_SIZE +
> > > > + /* Max length of messages for proto 2*/
> > > > + EC_PROTO2_MSG_BYTES             =3D EC_PROTO2_MAX_PARAM_SIZE +
> > > >                                   EC_MSG_TX_PROTO_BYTES,
> > >
> > > Nit: Better to not tab the '=3D' so far and place it all on one line.
> > >
> > > Checkpatch now only complains about lines exceeding 100 chars.
> > >
> > > Once fixed, feel free to apply my:
> > >
> > >   Acked-by: Lee Jones <lee.jones@linaro.org>
> >
> > This commit is already in 4.7, and is from 2016, so I don't know why yo=
u
> > are reviewing it :)
My mistake, I overlooked the branch information is removed when
formatting a patch: it is for branch linux-4.4.y in linux stable git
tree.

>
> Heh!  It looked like a standard patch at first glance.
>
> Must have skipped over the "commit" line in the commit log.
>
> I wonder why it doesn't have my Ack on it already then?
You were not in the loop on the original thread:
https://lkml.org/lkml/2016/3/8/628
Sorry about that,

Gwendal.


>
> --
> Lee Jones [=E6=9D=8E=E7=90=BC=E6=96=AF]
> Senior Technical Lead - Developer Services
> Linaro.org =E2=94=82 Open source software for Arm SoCs
> Follow Linaro: Facebook | Twitter | Blog
