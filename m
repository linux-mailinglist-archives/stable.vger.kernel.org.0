Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945B4291291
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 16:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438438AbgJQO6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 10:58:23 -0400
Received: from mail-03.mail-europe.com ([91.134.188.129]:44478 "EHLO
        mail-03.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438441AbgJQO6W (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 10:58:22 -0400
Date:   Sat, 17 Oct 2020 14:58:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1602946696;
        bh=XX5l0JqA4j5ycEOGeKlfrui0wBpfH9SbVROZs+7Z7Wc=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=PJL30PpZJiencMSL9LL4zY+rl8xuKBmqTBfI655YK/cnjCPYOSgBDGhKFwBhhAHKR
         Rx2+rFI2znTaVx8UDUdqhLguMjsBik5PL5zxIj9OHdMq8BHG0pEvv4u6/LAR31qHOA
         Z3ao/8PK0KMqL9giEHYDYPUhnGcZlJJaAbtwkQqM=
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
Message-ID: <fRxQJHWq9ZL950ZPGFFm_LfSlMjsjrpG7Y63gd7V7iV647KR8WIfZ4-ljLeo0n4X3Gpu1KIEsMVLxQnzAtJdUdMydi_b0-vjIVb304Da1bQ=@protonmail.com>
In-Reply-To: <20201017140541.fggujaz2klpv3cd5@Rk>
References: <20201016131335.8121-1-coiby.xu@gmail.com> <T2SIcFVxZ81NUwKLDbSESA7Wpm7DYowEiii8ZaxTPtrdXZZeHLq5iZPkN5BLlp-9C6PLwUZOVwNpMdEdPSRZcAG4MmDt-tfyKZoQYJ0KHOA=@protonmail.com> <20201017004556.kuoxzmbvef4yr3kg@Rk> <FWsXxqGztJgszUpmNtKli8eOyeKP-lxFeTsjs2nQAxgYZBkT3JNTU3VdHF4GbQVS_PvKiqbfrZXI7vaUHA_lXTxjPX-WjkNEOdiMUetO8IQ=@protonmail.com> <20201017140541.fggujaz2klpv3cd5@Rk>
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
> >> >> +
> >> >> +static bool interrupt_line_active(struct i2c_client *client)
> >> >> +{
> >> >> +=09unsigned long trigger_type =3D irq_get_trigger_type(client->irq=
);
> >> >> +=09struct irq_desc *irq_desc =3D irq_to_desc(client->irq);
> >> >> +
> >> >> +=09/*
> >> >> +=09 * According to Windows Precsiontion Touchpad's specs
> >> >> +=09 * https://docs.microsoft.com/en-us/windows-hardware/design/com=
ponent-guidelines/windows-precision-touchpad-device-bus-connectivity,
> >> >> +=09 * GPIO Interrupt Assertion Leve could be either ActiveLow or
> >> >> +=09 * ActiveHigh.
> >> >> +=09 */
> >> >> +=09if (trigger_type & IRQF_TRIGGER_LOW)
> >> >> +=09=09return !get_gpio_pin_state(irq_desc);
> >> >> +
> >> >> +=09return get_gpio_pin_state(irq_desc);
> >> >> +}
> >> >
> >> >Excuse my ignorance, but I think some kind of error handling regardin=
g the return
> >> >value of `get_gpio_pin_state()` should be present here.
> >> >
> >> What kind of errors would you expect? It seems (struct gpio_chip *)->g=
et
> >> only return 0 or 1.
> >> >
> >
> >I read the code of a couple gpio chips and - I may be wrong, but - it se=
ems they
> >can return an arbitrary errno.
> >
> I thought all GPIO chip return 0 or 1 since !!val is returned. I find
> an example which could return negative value,
>

Yes, when a function returns `int`, there is a very high chance that the re=
turn
value may be an errno.


> >
> >> >> +
> >> >> +static int i2c_hid_polling_thread(void *i2c_hid)
> >> >> +{
> >> >> +=09struct i2c_hid *ihid =3D i2c_hid;
> >> >> +=09struct i2c_client *client =3D ihid->client;
> >> >> +=09unsigned int polling_interval_idle;
> >> >> +
> >> >> +=09while (1) {
> >> >> +=09=09/*
> >> >> +=09=09 * re-calculate polling_interval_idle
> >> >> +=09=09 * so the module parameters polling_interval_idle_ms can be
> >> >> +=09=09 * changed dynamically through sysfs as polling_interval_act=
ive_us
> >> >> +=09=09 */
> >> >> +=09=09polling_interval_idle =3D polling_interval_idle_ms * 1000;
> >> >> +=09=09if (test_bit(I2C_HID_READ_PENDING, &ihid->flags))
> >> >> +=09=09=09usleep_range(50000, 100000);
> >> >> +
> >> >> +=09=09if (kthread_should_stop())
> >> >> +=09=09=09break;
> >> >> +
> >> >> +=09=09while (interrupt_line_active(client)) {
> >> >
> >> >I realize it's quite unlikely, but can't this be a endless loop if da=
ta is coming
> >> >in at a high enough rate? Maybe the maximum number of iterations coul=
d be limited here?
> >> >
> >> If we find HID reports are constantly read and send to front-end
> >> application like libinput, won't it help expose the problem of the I2C
> >> HiD device?
> >> >
> >
> >I'm not sure I completely understand your point. The reason why I wrote =
what I wrote
> >is that this kthread could potentially could go on forever (since `kthre=
ad_should_stop()`
> >is not checked in the inner while loop) if the data is supplied at a hig=
h enough rate.
> >That's why I said, to avoid this problem, only allow a certain number of=
 iterations
> >for the inner loop, to guarantee that the kthread can stop in any case.
> >
> I mean if "data is supplied at a high enough rate" does happen, this is
> an abnormal case and indicates a bug. So we shouldn't cover it up. We
> expect the user to report it to us.
> >

I agree in principle, but if this abnormal case ever occurs, that'll preven=
t
this module from being unloaded since `kthread_stop()` will hang because th=
e
thread is "stuck" in the inner loop, never checking `kthread_should_stop()`=
.
That's why I think it makes sense to only allow a certain number of operati=
ons
for the inner loop, and maybe show a warning if that's exceeded:

 for (i =3D 0; i < max_iter && interrupt_line_active(...); i++) {
    ....
 }

 WARN_ON[CE](i =3D=3D max_iter[, "data is coming in at an unreasonably high=
 rate"]);

or something like this, where `max_iter` could possibly be some value depen=
dent on
`polling_interval_active_us`, or even just a constant.


> >> >> +=09=09=09i2c_hid_get_input(ihid);
> >> >> +=09=09=09usleep_range(polling_interval_active_us,
> >> >> +=09=09=09=09     polling_interval_active_us + 100);
> >> >> +=09=09}
> >> >> +
> >> >> +=09=09usleep_range(polling_interval_idle,
> >> >> +=09=09=09     polling_interval_idle + 1000);
> >> >> +=09}
> >> >> +
> >> >> +=09do_exit(0);
> >> >> +=09return 0;
> >> >> +}
> [...]
> Thank you for offering your understandings on this patch. When I'm going
> to submit next version, I will add a "Signed-off-by" tag with your name
> and email, does it look good to you?
> [...]

I'm not sure if that follows proper procedures.

 "The sign-off is a simple line at the end of the explanation for the patch=
, which
  certifies that you wrote it or otherwise have the right to pass it on as =
an
  open-source patch."[1]

I'm not the author, nor co-author, nor am I going to pass this patch on, so=
 I don't
think that's appropriate.

Furthermore, please note that

 "[...] you may optionally add a Cc: tag to the patch. **This is the only t=
ag which
  might be added without an explicit action by the person it names** - but =
it should
  indicate that this person was copied on the patch."[2]
  (emphasis mine)


Regards,
Barnab=C3=A1s P=C5=91cze


[1]: https://www.kernel.org/doc/html/latest/process/submitting-patches.html=
#sign-your-work-the-developer-s-certificate-of-origin
[2]: https://www.kernel.org/doc/html/latest/process/submitting-patches.html=
#when-to-use-acked-by-cc-and-co-developed-by
