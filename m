Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2C72C10BB
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 17:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387935AbgKWQde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 11:33:34 -0500
Received: from mail-40130.protonmail.ch ([185.70.40.130]:12843 "EHLO
        mail-40130.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730653AbgKWQct (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 11:32:49 -0500
X-Greylist: delayed 97178 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Nov 2020 11:32:48 EST
Date:   Mon, 23 Nov 2020 16:32:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1606149166;
        bh=1OgKSLrOLrx4rcpdrxHRjSAEiZ/HKQ6P5WUtosWkqYE=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=JEbZobUHS4Epzb0ByFpovC+a3vairdsWw1hz64oTe+DgyIL7hL1P6hUT/fw0ewEh2
         BoL8r+peIJbgMzXqWT2WOtL15lPcm9hOq7gmCVV3GP+AmDe9aGvhZHbn1JeMibqxV4
         GgplxIjMZ5kSc7KwY9R5c75i0sttkz6awyhZBO5o=
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
Message-ID: <1FeR4cJ-m2i5GGyb68drDocoWP-yJ47BeKKEi2IkYbkppLFRCQPTQT4D6xqVCQcmUIjIsoe9HXhwycxxt5XxtsESO6w4uVMzISa987s_T-U=@protonmail.com>
In-Reply-To: <20201123143613.zzrm3wgm4m6ngvrz@Rk>
References: <20201021134931.462560-1-coiby.xu@gmail.com> <qo0Y8DqV6mbQsSFabOaqRoxYhKdYCZPjqYuF811CTdPXRFFXpx7sNXYcW9OGI5PMyclgsTjI7Xj3Du3v4hYQVBWGJl3t0t8XSbTKE9uOJ2E=@protonmail.com> <20201122101525.j265hvj6lqgbtfi2@Rk> <xsbDy_74QEfC8byvpA0nIjI0onndA3wuiLm2Iattq-8TLPy28kMq7GKhkfrfzqdBAQfp_w5CTCCJ8XjFmegtZqP58xioheh7OHV7Bam33aQ=@protonmail.com> <20201123143613.zzrm3wgm4m6ngvrz@Rk>
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

> [...]
> >> >> +static int get_gpio_pin_state(struct irq_desc *irq_desc)
> >> >> +{
> >> >> +=09struct gpio_chip *gc =3D irq_data_get_irq_chip_data(&irq_desc->=
irq_data);
> >> >> +
> >> >> +=09return gc->get(gc, irq_desc->irq_data.hwirq);
> >> >> +}
> >> [...]
> >> >> +=09ssize_t=09status =3D get_gpio_pin_state(irq_desc);
> >> >
> >> >`get_gpio_pin_state()` returns an `int`, so I am not sure why `ssize_=
t` is used here.
> >> >
> >>
> >> I used `ssize_t` because I found gpiolib-sysfs.c uses `ssize_t`
> >>
> >>      // drivers/gpio/gpiolib-sysfs.c
> >>      static ssize_t value_show(struct device *dev,
> >>      =09=09struct device_attribute *attr, char *buf)
> >>      {
> >>      =09struct gpiod_data *data =3D dev_get_drvdata(dev);
> >>      =09struct gpio_desc *desc =3D data->desc;
> >>      =09ssize_t=09=09=09status;
> >>
> >>      =09mutex_lock(&data->mutex);
> >>
> >>      =09status =3D gpiod_get_value_cansleep(desc);
> >>          ...
> >>      =09return status;
> >>      }
> >>
> >> According to the book Advanced Programming in the UNIX Environment by
> >> W. Richard Stevens,
> >>      With the 1990 POSIX.1 standard, the primitive system data type
> >>      ssize_t was introduced to provide the signed return value...
> >>
> >> So ssize_t is fairly common, for example, the read and write syscall
> >> return a value of type ssize_t. But I haven't found out why ssize_t is
> >> better int.
> >> >
> >
> >Sorry if I wasn't clear, what prompted me to ask that question is the fo=
llowing:
> >`gc->get()` returns `int`, `get_gpio_pin_state()` returns `int`, yet you=
 still
> >save the return value of `get_gpio_pin_state()` into a variable with typ=
e
> >`ssize_t` for no apparent reason. In the example you cited, `ssize_t` is=
 used
> >because the show() callback of a sysfs attribute must return `ssize_t`, =
but here,
> >`interrupt_line_active()` returns `bool`, so I don't see any advantage o=
ver a
> >plain `int`. Anyways, I believe either one is fine, I just found it odd.
> >
> I don't understand why "the show() callback of a sysfs attribute
> must return `ssize_t`" instead of int. Do you think the rationale
> behind it is the same for this case? If yes, using "ssize_t" for
> status could be justified.
> [...]

Because it was decided that way, `ssize_t` is a better choice for that purp=
ose
than plain `int`. You can see it in include/linux/device.h, that both the
show() and store() methods must return `ssize_t`.

What I'm arguing here, is that there is no reason to use `ssize_t` in this =
case.
Because `get_gpio_pin_state()` returns `int`. So when you do
```
ssize_t status =3D get_gpio_pin_state(...);
```
then the return value of `get_gpio_pin_state()` (which is an `int`), will b=
e
converted to an `ssize_t`, and saved into `status`. I'm arguing that that i=
s
unnecessary and a plain `int` would work perfectly well in this case. Anywa=
ys,
both work fine, I just found the unnecessary use of `ssize_t` here odd.


Regards,
Barnab=C3=A1s P=C5=91cze
