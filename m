Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0EE3BC1C9
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 18:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhGEQxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 12:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbhGEQxk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 12:53:40 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09570C061574;
        Mon,  5 Jul 2021 09:51:02 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id v20so29776663eji.10;
        Mon, 05 Jul 2021 09:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9sktkUxG3S8lSrJsfOUzMs562zEuFhtkrmIQvaJAQbs=;
        b=PAN65IgOQWPTgYS4XZLZHRGGdkvq294r9wfNQDwpVZ5Sg2GIOhRwo0g8fFyw59GtNt
         SnYVF8kTK7mUso6qcQ4inDbuWQA9sJtODauZhajT7M9iNRIItAybnue76L5pzqlcqWu+
         /Da6qHd+hfWNEHFZsZT8xV7zJDyP61GHAb8jOqO/w5MFYv+6UarVIrblGHT1mO/bEncI
         YNRON9A+EdESr5l4e7CzqQHLe1XO+M5pJc4dEq2VeYCWQh9NmukwWEwqMetAWkleHTWL
         fqfSIibxL1vDYy6Y5rg2HNVQDftnM9q2IrJjkM6DwgaDah8dwFKAMHVneMNBZ4ZpEwMY
         q53A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9sktkUxG3S8lSrJsfOUzMs562zEuFhtkrmIQvaJAQbs=;
        b=nYIF5Hjmj6gg2UFifxtXJKqgYeSjnXrXhIGDZxk1s0pCunf+iKzWlqOXSjUtlSJF+m
         4WaG1SGrbBdddCaMkZlyVP1R595O/p4osTjHuuWZXvi6OlgUG+HNKQdu76f1xIX3UP8M
         Rzrb4BVIeQRlOC+SoJsYYqGji0xRnwAb/7Ln0FJUeeo6WvKSE0iIUq2/bjI+Tt5cuQnX
         BX0oKl30vsuYa8fKvy0jDCcbsryGilWQOy1W9jsbpkO23iG5ejc/Oeq6ldOJxV1jjFS/
         3wepAlIQiWUAMJ12jhekx0VjGre5k+vnTI6WvExbZXqfbsTPeOHRmBcuIIsMI0Q0kZIY
         AWWA==
X-Gm-Message-State: AOAM530bbmq5pyg/htdMnMzEOp6kgtY+qJPAst2byiRQmxqDu4CTC/RM
        p/vKKUxqwuitmN3bmTNiz7SFNukiw7l7gEkMpPw=
X-Google-Smtp-Source: ABdhPJwEAdn1FYjN8xdmsvWsg+tPzoarkVZyD0e+MOk2C3iQV+A/xDvg/0hrjyhcaiYaUoORdbcjJW/FLbSvA7yUiMc=
X-Received: by 2002:a17:906:24c3:: with SMTP id f3mr1922119ejb.145.1625503860490;
 Mon, 05 Jul 2021 09:51:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210701152825.265729-1-jglisse@redhat.com> <CAMpxmJX_3eu+8Oxg2UgiifwD=qwJYM3-qCqwxseM1mnLbn5fJA@mail.gmail.com>
In-Reply-To: <CAMpxmJX_3eu+8Oxg2UgiifwD=qwJYM3-qCqwxseM1mnLbn5fJA@mail.gmail.com>
From:   Alexander Fomichev <fomichev.ru@gmail.com>
Date:   Mon, 5 Jul 2021 19:50:49 +0300
Message-ID: <CAEKnZG5TmoR44dOmK9KmHnWogHvd7MGVXjdXWgew+9smuGEOCg@mail.gmail.com>
Subject: Re: [PATCH] misc: eeprom: at24: Always append device id even if label
 property is set.
To:     Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc:     =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Diego Santa Cruz <Diego.SantaCruz@spinetix.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        "Stable # 4 . 20+" <stable@vger.kernel.org>,
        linux-i2c <linux-i2c@vger.kernel.org>, linux@yadro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The proposed patch has been tested and it solves the problem.
Thanks.

Tested-by: Alexander Fomichev <fomichev.ru@gmail.com>

=D1=87=D1=82, 1 =D0=B8=D1=8E=D0=BB. 2021 =D0=B3. =D0=B2 19:47, Bartosz Gola=
szewski <bgolaszewski@baylibre.com>:
>
> On Thu, Jul 1, 2021 at 5:28 PM <jglisse@redhat.com> wrote:
> >
> > From: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> >
> > We need to append device id even if eeprom have a label property set as=
 some
> > platform can have multiple eeproms with same label and we can not regis=
ter
> > each of those with same label. Failing to register those eeproms trigge=
r
> > cascade failures on such platform (system is no longer working).
> >
> > This fix regression on such platform introduced with 4e302c3b568e
> >
> > Signed-off-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> > Cc: Diego Santa Cruz <Diego.SantaCruz@spinetix.com>
> > Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> > Cc: Jon Hunter <jonathanh@nvidia.com>
> > Cc: stable@vger.kernel.org
> > Cc: linux-i2c@vger.kernel.org
> > ---
> >  drivers/misc/eeprom/at24.c | 17 +++++++----------
> >  1 file changed, 7 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
> > index 7a6f01ace78a..305ffad131a2 100644
> > --- a/drivers/misc/eeprom/at24.c
> > +++ b/drivers/misc/eeprom/at24.c
> > @@ -714,23 +714,20 @@ static int at24_probe(struct i2c_client *client)
> >         }
> >
> >         /*
> > -        * If the 'label' property is not present for the AT24 EEPROM,
> > -        * then nvmem_config.id is initialised to NVMEM_DEVID_AUTO,
> > -        * and this will append the 'devid' to the name of the NVMEM
> > -        * device. This is purely legacy and the AT24 driver has always
> > -        * defaulted to this. However, if the 'label' property is
> > -        * present then this means that the name is specified by the
> > -        * firmware and this name should be used verbatim and so it is
> > -        * not necessary to append the 'devid'.
> > +        * We initialize nvmem_config.id to NVMEM_DEVID_AUTO even if th=
e
> > +        * label property is set as some platform can have multiple eep=
roms
> > +        * with same label and we can not register each of those with s=
ame
> > +        * label. Failing to register those eeproms trigger cascade fai=
lure
> > +        * on such platform.
> >          */
> > +       nvmem_config.id =3D NVMEM_DEVID_AUTO;
> > +
> >         if (device_property_present(dev, "label")) {
> > -               nvmem_config.id =3D NVMEM_DEVID_NONE;
> >                 err =3D device_property_read_string(dev, "label",
> >                                                   &nvmem_config.name);
> >                 if (err)
> >                         return err;
> >         } else {
> > -               nvmem_config.id =3D NVMEM_DEVID_AUTO;
> >                 nvmem_config.name =3D dev_name(dev);
> >         }
> >
> > --
> > 2.31.1
> >
>
> Cc'ing Alexander Fomichev who reported this issue first.
>
> This is the second time someone raises this problem so it seems that
> this change really broke many existing systems. I will apply this
> patch and send it for stable.
>
> Bart



--=20
=D0=A1 =D1=83=D0=B2=D0=B0=D0=B6=D0=B5=D0=BD=D0=B8=D0=B5=D0=BC,
=D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80 =D0=A4=D0=BE=D0=BC=
=D0=B8=D1=87=D1=91=D0=B2.
