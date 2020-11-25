Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D542F2C405B
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 13:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbgKYMjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 07:39:17 -0500
Received: from mail-40132.protonmail.ch ([185.70.40.132]:53774 "EHLO
        mail-40132.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgKYMjR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 07:39:17 -0500
X-Greylist: delayed 158782 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Nov 2020 07:39:14 EST
Date:   Wed, 25 Nov 2020 12:39:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1606307952;
        bh=lybJm4KNbspx+koo3raaZ40pyMf68YvNuqxbO9ZAm2w=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=gdUByJfulR0dPeAeA90XiXeYnYkBV2vfGUhhdAZtiUBwCyZxPEsCdhzGriIEWdQPu
         lROlNIBLUT0zQS94HvzzJIGCYGBcSqq6JLRBpqFLtZQy0v7aY9JBNU7g7DUS8Jn7xa
         O3hWfBTcTughYsfr5vOVTNhFQu7hZIyzsRWUGntg=
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
Message-ID: <_1j4GSFZpZ-rAOrhM2TQwyID7K4XCCkKwLeIcFMxQ1vlFg6wr544L5Lcrp7BvpsMmkhMYsTUT3yTTM61J7aVTYmGMSddkrz244_uV0gg9mU=@protonmail.com>
In-Reply-To: <20201125105720.xatyiva7psrfyzbi@Rk>
References: <20201021134931.462560-1-coiby.xu@gmail.com> <qo0Y8DqV6mbQsSFabOaqRoxYhKdYCZPjqYuF811CTdPXRFFXpx7sNXYcW9OGI5PMyclgsTjI7Xj3Du3v4hYQVBWGJl3t0t8XSbTKE9uOJ2E=@protonmail.com> <20201122101525.j265hvj6lqgbtfi2@Rk> <xsbDy_74QEfC8byvpA0nIjI0onndA3wuiLm2Iattq-8TLPy28kMq7GKhkfrfzqdBAQfp_w5CTCCJ8XjFmegtZqP58xioheh7OHV7Bam33aQ=@protonmail.com> <20201123143613.zzrm3wgm4m6ngvrz@Rk> <1FeR4cJ-m2i5GGyb68drDocoWP-yJ47BeKKEi2IkYbkppLFRCQPTQT4D6xqVCQcmUIjIsoe9HXhwycxxt5XxtsESO6w4uVMzISa987s_T-U=@protonmail.com> <20201125105720.xatyiva7psrfyzbi@Rk>
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

2020. november 25., szerda 11:57 keltez=C3=A9ssel, Coiby Xu =C3=ADrta:

> On Mon, Nov 23, 2020 at 04:32:40PM +0000, Barnab=C3=A1s P=C5=91cze wrote:
> >> [...]
> >> >> >> +static int get_gpio_pin_state(struct irq_desc *irq_desc)
> >> >> >> +{
> >> >> >> +=09struct gpio_chip *gc =3D irq_data_get_irq_chip_data(&irq_des=
c->irq_data);
> >> >> >> +
> >> >> >> +=09return gc->get(gc, irq_desc->irq_data.hwirq);
> >> >> >> +}
> >> >> [...]
> >> >> >> +=09ssize_t=09status =3D get_gpio_pin_state(irq_desc);
> >> >> >
> >> >> >`get_gpio_pin_state()` returns an `int`, so I am not sure why `ssi=
ze_t` is used here.
> >> >> >
> >> >>
> >> >> I used `ssize_t` because I found gpiolib-sysfs.c uses `ssize_t`
> >> >>
> >> >>      // drivers/gpio/gpiolib-sysfs.c
> >> >>      static ssize_t value_show(struct device *dev,
> >> >>      =09=09struct device_attribute *attr, char *buf)
> >> >>      {
> >> >>      =09struct gpiod_data *data =3D dev_get_drvdata(dev);
> >> >>      =09struct gpio_desc *desc =3D data->desc;
> >> >>      =09ssize_t=09=09=09status;
> >> >>
> >> >>      =09mutex_lock(&data->mutex);
> >> >>
> >> >>      =09status =3D gpiod_get_value_cansleep(desc);
> >> >>          ...
> >> >>      =09return status;
> >> >>      }
> >> >>
> >> >> According to the book Advanced Programming in the UNIX Environment =
by
> >> >> W. Richard Stevens,
> >> >>      With the 1990 POSIX.1 standard, the primitive system data type
> >> >>      ssize_t was introduced to provide the signed return value...
> >> >>
> >> >> So ssize_t is fairly common, for example, the read and write syscal=
l
> >> >> return a value of type ssize_t. But I haven't found out why ssize_t=
 is
> >> >> better int.
> >> >> >
> >> >
> >> >Sorry if I wasn't clear, what prompted me to ask that question is the=
 following:
> >> >`gc->get()` returns `int`, `get_gpio_pin_state()` returns `int`, yet =
you still
> >> >save the return value of `get_gpio_pin_state()` into a variable with =
type
> >> >`ssize_t` for no apparent reason. In the example you cited, `ssize_t`=
 is used
> >> >because the show() callback of a sysfs attribute must return `ssize_t=
`, but here,
> >> >`interrupt_line_active()` returns `bool`, so I don't see any advantag=
e over a
> >> >plain `int`. Anyways, I believe either one is fine, I just found it o=
dd.
> >> >
> >> I don't understand why "the show() callback of a sysfs attribute
> >> must return `ssize_t`" instead of int. Do you think the rationale
> >> behind it is the same for this case? If yes, using "ssize_t" for
> >> status could be justified.
> >> [...]
> >
> >Because it was decided that way, `ssize_t` is a better choice for that p=
urpose
> >than plain `int`. You can see it in include/linux/device.h, that both th=
e
> >show() and store() methods must return `ssize_t`.
> >
>
> Could you explain why `ssize_t` is a better choice? AFAIU, ssize_t
> is used because we can return negative value to indicate an error.

ssize_t: "Signed integer type used for a count of bytes or an error indicat=
ion."[1]

And POSIX mandates that the return type of read() and write() be `ssize_t`,
so it makes sense to keep a similar interface in the kernel since show() an=
d store()
are called as a direct result of the user using the read() and write() syst=
em
calls, respectively.


> If
> we use ssize_t here, it's a reminder that reading a GPIO pin's status
> could fail. And ssize_t reminds us it's a operation similar to read
> or write. So ssize_t is better than int here. And maybe it's the same
> reason why "it was decided that way".
> [...]

I believe it's more appropriate to use ssize_t when it's about a "count of =
elements",
but the GPIO pin state is a single boolean value (or an error indication), =
which
is returned as an `int`. Since it's returned as an `int` - I'm arguing that=
 -
there is no reason to use `ssize_t` here. Anyways, both `ssize_t` and `int`=
 work fine
in this case.


[1]: https://pubs.opengroup.org/onlinepubs/9699919799/functions/V2_chap02.h=
tml#tag_15_12


Regards,
Barnab=C3=A1s P=C5=91cze
