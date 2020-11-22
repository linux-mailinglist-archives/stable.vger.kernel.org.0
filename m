Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C902E2BC5D5
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 14:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgKVNdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 08:33:13 -0500
Received: from mail-02.mail-europe.com ([51.89.119.103]:36574 "EHLO
        mail-02.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbgKVNdM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 08:33:12 -0500
Date:   Sun, 22 Nov 2020 13:33:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1606051989;
        bh=NGfLf+2/UDS8HyaW78yoZusoy/lNepZl6zp7GO3POq4=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=exdWE6k68YH+uJsIPhr9xzHVoeeJFakjTYw+VEh0P1Zp5BXi1sXFKc+UeRl5C5/gO
         w+dR8PmwIfa6FL9auxAEL44O+BTn4W9uWn2p05dkOIG592LOoXcHLkymrDI3lTJ6D1
         eHljNVUH7UVGRqOFjQNC1kgJaGPd4lAr8SFbGfa8=
To:     Coiby Xu <coiby.xu@gmail.com>
From:   =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Cc:     "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Helmut Stult <helmut.stult@schinfo.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-To: =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Subject: Re: [PATCH v3] HID: i2c-hid: add polling mode based on connected GPIO chip's pin status
Message-ID: <xsbDy_74QEfC8byvpA0nIjI0onndA3wuiLm2Iattq-8TLPy28kMq7GKhkfrfzqdBAQfp_w5CTCCJ8XjFmegtZqP58xioheh7OHV7Bam33aQ=@protonmail.com>
In-Reply-To: <20201122101525.j265hvj6lqgbtfi2@Rk>
References: <20201021134931.462560-1-coiby.xu@gmail.com> <qo0Y8DqV6mbQsSFabOaqRoxYhKdYCZPjqYuF811CTdPXRFFXpx7sNXYcW9OGI5PMyclgsTjI7Xj3Du3v4hYQVBWGJl3t0t8XSbTKE9uOJ2E=@protonmail.com> <20201122101525.j265hvj6lqgbtfi2@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi


2020. november 22., vas=C3=A1rnap 11:15 keltez=C3=A9ssel, Coiby Xu =C3=
=ADrta:

> [...]
> >> +static int get_gpio_pin_state(struct irq_desc *irq_desc)
> >> +{
> >> +=09struct gpio_chip *gc =3D irq_data_get_irq_chip_data(&irq_desc->irq=
_data);
> >> +
> >> +=09return gc->get(gc, irq_desc->irq_data.hwirq);
> >> +}
> [...]
> >> +=09ssize_t=09status =3D get_gpio_pin_state(irq_desc);
> >
> >`get_gpio_pin_state()` returns an `int`, so I am not sure why `ssize_t` =
is used here.
> >
>
> I used `ssize_t` because I found gpiolib-sysfs.c uses `ssize_t`
>
>      // drivers/gpio/gpiolib-sysfs.c
>      static ssize_t value_show(struct device *dev,
>      =09=09struct device_attribute *attr, char *buf)
>      {
>      =09struct gpiod_data *data =3D dev_get_drvdata(dev);
>      =09struct gpio_desc *desc =3D data->desc;
>      =09ssize_t=09=09=09status;
>
>      =09mutex_lock(&data->mutex);
>
>      =09status =3D gpiod_get_value_cansleep(desc);
>          ...
>      =09return status;
>      }
>
> According to the book Advanced Programming in the UNIX Environment by
> W. Richard Stevens,
>      With the 1990 POSIX.1 standard, the primitive system data type
>      ssize_t was introduced to provide the signed return value...
>
> So ssize_t is fairly common, for example, the read and write syscall
> return a value of type ssize_t. But I haven't found out why ssize_t is
> better int.
> >

Sorry if I wasn't clear, what prompted me to ask that question is the follo=
wing:
`gc->get()` returns `int`, `get_gpio_pin_state()` returns `int`, yet you st=
ill
save the return value of `get_gpio_pin_state()` into a variable with type
`ssize_t` for no apparent reason. In the example you cited, `ssize_t` is us=
ed
because the show() callback of a sysfs attribute must return `ssize_t`, but=
 here,
`interrupt_line_active()` returns `bool`, so I don't see any advantage over=
 a
plain `int`. Anyways, I believe either one is fine, I just found it odd.


> >> +
> >> +=09if (status < 0) {
> >> +=09=09dev_warn(&client->dev,
> >> +=09=09=09 "Failed to get GPIO Interrupt line status for %s",
> >> +=09=09=09 client->name);
> >
> >I think it's possible that the kernel message buffer is flooded with the=
se
> >messages, which is not optimal in my opinion.
> >
> Thank you! Replaced with dev_dbg in v4.
> [...]

Have you looked at `dev_{warn,dbg,...}_ratelimited()`?


Regards,
Barnab=C3=A1s P=C5=91cze
