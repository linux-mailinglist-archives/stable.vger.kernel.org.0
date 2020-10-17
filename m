Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7C82911F1
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 15:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437993AbgJQNG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 09:06:27 -0400
Received: from mail-03.mail-europe.com ([91.134.188.129]:42728 "EHLO
        mail-03.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437959AbgJQNG1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 09:06:27 -0400
Date:   Sat, 17 Oct 2020 13:06:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1602939981;
        bh=de22LrvYVNO+7IibwrPlriMTI7Y3usocqLQKuqCcfKU=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=BXMCP97EQIGafljtiwnUqS1RlDD41cD76BVudAxjiFnmiKy6Em6mYmY5XDkNSprcg
         dWoCj8aP12iYNz9BTvA4SYjwOE+NmdCGNQyaTssKoQvMjb2wdOclGejJsp0PQ/tQ3J
         xrdq8mYpKVtmVj0BhNxQwTSPVSbxYLb+IOR1Qh5M=
To:     Coiby Xu <coiby.xu@gmail.com>
From:   =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Cc:     "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Helmut Stult <helmut.stult@schinfo.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-To: =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Subject: Re: [PATCH v2] HID: i2c-hid: add polling mode based on connected GPIO chip's pin status
Message-ID: <FWsXxqGztJgszUpmNtKli8eOyeKP-lxFeTsjs2nQAxgYZBkT3JNTU3VdHF4GbQVS_PvKiqbfrZXI7vaUHA_lXTxjPX-WjkNEOdiMUetO8IQ=@protonmail.com>
In-Reply-To: <20201017004556.kuoxzmbvef4yr3kg@Rk>
References: <20201016131335.8121-1-coiby.xu@gmail.com> <T2SIcFVxZ81NUwKLDbSESA7Wpm7DYowEiii8ZaxTPtrdXZZeHLq5iZPkN5BLlp-9C6PLwUZOVwNpMdEdPSRZcAG4MmDt-tfyKZoQYJ0KHOA=@protonmail.com> <20201017004556.kuoxzmbvef4yr3kg@Rk>
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

> [...]
> >> +static int get_gpio_pin_state(struct irq_desc *irq_desc)
> >> +{
> >> +=09struct gpio_chip *gc =3D irq_data_get_irq_chip_data(&irq_desc->irq=
_data);
> >> +
> >> +=09return gc->get(gc, irq_desc->irq_data.hwirq);
> >> +}
> >> +
> >> +static bool interrupt_line_active(struct i2c_client *client)
> >> +{
> >> +=09unsigned long trigger_type =3D irq_get_trigger_type(client->irq);
> >> +=09struct irq_desc *irq_desc =3D irq_to_desc(client->irq);
> >> +
> >> +=09/*
> >> +=09 * According to Windows Precsiontion Touchpad's specs
> >> +=09 * https://docs.microsoft.com/en-us/windows-hardware/design/compon=
ent-guidelines/windows-precision-touchpad-device-bus-connectivity,
> >> +=09 * GPIO Interrupt Assertion Leve could be either ActiveLow or
> >> +=09 * ActiveHigh.
> >> +=09 */
> >> +=09if (trigger_type & IRQF_TRIGGER_LOW)
> >> +=09=09return !get_gpio_pin_state(irq_desc);
> >> +
> >> +=09return get_gpio_pin_state(irq_desc);
> >> +}
> >
> >Excuse my ignorance, but I think some kind of error handling regarding t=
he return
> >value of `get_gpio_pin_state()` should be present here.
> >
> What kind of errors would you expect? It seems (struct gpio_chip *)->get
> only return 0 or 1.
> >

I read the code of a couple gpio chips and - I may be wrong, but - it seems=
 they
can return an arbitrary errno.


> >> +
> >> +static int i2c_hid_polling_thread(void *i2c_hid)
> >> +{
> >> +=09struct i2c_hid *ihid =3D i2c_hid;
> >> +=09struct i2c_client *client =3D ihid->client;
> >> +=09unsigned int polling_interval_idle;
> >> +
> >> +=09while (1) {
> >> +=09=09/*
> >> +=09=09 * re-calculate polling_interval_idle
> >> +=09=09 * so the module parameters polling_interval_idle_ms can be
> >> +=09=09 * changed dynamically through sysfs as polling_interval_active=
_us
> >> +=09=09 */
> >> +=09=09polling_interval_idle =3D polling_interval_idle_ms * 1000;
> >> +=09=09if (test_bit(I2C_HID_READ_PENDING, &ihid->flags))
> >> +=09=09=09usleep_range(50000, 100000);
> >> +
> >> +=09=09if (kthread_should_stop())
> >> +=09=09=09break;
> >> +
> >> +=09=09while (interrupt_line_active(client)) {
> >
> >I realize it's quite unlikely, but can't this be a endless loop if data =
is coming
> >in at a high enough rate? Maybe the maximum number of iterations could b=
e limited here?
> >
> If we find HID reports are constantly read and send to front-end
> application like libinput, won't it help expose the problem of the I2C
> HiD device?
> >

I'm not sure I completely understand your point. The reason why I wrote wha=
t I wrote
is that this kthread could potentially could go on forever (since `kthread_=
should_stop()`
is not checked in the inner while loop) if the data is supplied at a high e=
nough rate.
That's why I said, to avoid this problem, only allow a certain number of it=
erations
for the inner loop, to guarantee that the kthread can stop in any case.


> >> +=09=09=09i2c_hid_get_input(ihid);
> >> +=09=09=09usleep_range(polling_interval_active_us,
> >> +=09=09=09=09     polling_interval_active_us + 100);
> >> +=09=09}
> >> +
> >> +=09=09usleep_range(polling_interval_idle,
> >> +=09=09=09     polling_interval_idle + 1000);
> >> +=09}
> >> +
> >> +=09do_exit(0);
> >> +=09return 0;
> >> +}
> [...]
> >Excuse my ignorance, but I do not understand why the following two chang=
es are not enough:
> >
> >in `i2c_hid_suspend()`:
> > if (polling_mode =3D=3D I2C_POLLING_DISABLED)
> >   disable_irq(client->irq);
> >
> >in `i2c_hid_resume()`:
> > if (polling_mode =3D=3D I2C_POLLING_DISABLED)
> >   enable_irq(client->irq);
> >
> I think we shouldn't call enable/disable_irq_wake in polling mode
> where we don't set up irq.

I think I now understand what you mean. I'm not sure, but it seems logical =
to me
that you can enable/disable irq wake regardless whether any irq handlers ar=
e
registered or not. Therefore, I figure it makes sense to take the safe path=
,
and don't touch irq wake when polling, just as you did.


> [...]


Regards,
Barnab=C3=A1s P=C5=91cze
