Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831182960D7
	for <lists+stable@lfdr.de>; Thu, 22 Oct 2020 16:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368093AbgJVOXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Oct 2020 10:23:11 -0400
Received: from mail-03.mail-europe.com ([91.134.188.129]:34538 "EHLO
        mail-03.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368102AbgJVOXK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Oct 2020 10:23:10 -0400
Date:   Thu, 22 Oct 2020 14:22:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1603376582;
        bh=J/71Z3KShQsRLO+e2JfhqSeVPNr+T3r6lOe+dGfMBC0=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=RDn5PrFQo11Lx5fA+oZ7ribs4ddjDMIb9hxYE8hUejC9BcmIXagNAi1PZKbbK4EJX
         JuMLzlx+HyaFn9brV8VUwmUAlWjQt2gWk90CqizceA+8rWYVXEhCpcmRiSEEdvdjNd
         cqdIz04lTntlNdNhVT+Rz0ZMn3mxrBoe7UsQgDNU=
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
Message-ID: <qo0Y8DqV6mbQsSFabOaqRoxYhKdYCZPjqYuF811CTdPXRFFXpx7sNXYcW9OGI5PMyclgsTjI7Xj3Du3v4hYQVBWGJl3t0t8XSbTKE9uOJ2E=@protonmail.com>
In-Reply-To: <20201021134931.462560-1-coiby.xu@gmail.com>
References: <20201021134931.462560-1-coiby.xu@gmail.com>
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

Hi,

I think this looks a lot better than the first version, the issues around
suspend/resume are sorted out as far as I can see. However, I still have a =
couple
comments, mainly minor ones.


> [...]
> +/* polling mode */
> +#define I2C_HID_POLLING_DISABLED 0
> +#define I2C_HID_POLLING_GPIO_PIN 1
> +#define I2C_HID_POLLING_INTERVAL_ACTIVE_US 4000
> +#define I2C_HID_POLLING_INTERVAL_IDLE_MS 10
> +
> +static u8 polling_mode;
> +module_param(polling_mode, byte, 0444);
> +MODULE_PARM_DESC(polling_mode, "How to poll - 0 disabled; 1 based on GPI=
O pin's status");
> +

Minor thing, but maybe the default value should be documented in the parame=
ter
description?


> +static unsigned int polling_interval_active_us =3D I2C_HID_POLLING_INTER=
VAL_ACTIVE_US;
> +module_param(polling_interval_active_us, uint, 0644);
> +MODULE_PARM_DESC(polling_interval_active_us,
> +=09=09 "Poll every {polling_interval_active_us} us when the touchpad is =
active. Default to 4000 us");
> +
> +static unsigned int polling_interval_idle_ms =3D I2C_HID_POLLING_INTERVA=
L_IDLE_MS;

Since these two parameters are mostly read, I think the `__read_mostly`
attribute (linux/cache.h) is justified here.


> +module_param(polling_interval_idle_ms, uint, 0644);
> +MODULE_PARM_DESC(polling_interval_idle_ms,
> +=09=09 "Poll every {polling_interval_idle_ms} ms when the touchpad is id=
le. Default to 10 ms");

This is minor stylistic thing; as far as I see, the prevalent pattern is to=
 put
the default value at the end, in parenthesis:
E.g. "some parameter description (default=3DX)" or "... (default: X)" or so=
mething similar

Maybe __stringify() (linux/stringify.h) could be used here and for the prev=
ious
module parameter?

E.g. "... (default=3D" __stringify(I2C_HID_POLLING_INTERVAL_IDLE_MS) ")"


> [...]
> +static int get_gpio_pin_state(struct irq_desc *irq_desc)
> +{
> +=09struct gpio_chip *gc =3D irq_data_get_irq_chip_data(&irq_desc->irq_da=
ta);
> +
> +=09return gc->get(gc, irq_desc->irq_data.hwirq);
> +}
> +
> +static bool interrupt_line_active(struct i2c_client *client)
> +{
> +=09unsigned long trigger_type =3D irq_get_trigger_type(client->irq);

Can the trigger type change? Because if not, then I think it'd be better to=
 store
the value somewhere and not query it every time.


> +=09struct irq_desc *irq_desc =3D irq_to_desc(client->irq);

Same here.


> +=09ssize_t=09status =3D get_gpio_pin_state(irq_desc);

`get_gpio_pin_state()` returns an `int`, so I am not sure why `ssize_t` is =
used here.


> +
> +=09if (status < 0) {
> +=09=09dev_warn(&client->dev,
> +=09=09=09 "Failed to get GPIO Interrupt line status for %s",
> +=09=09=09 client->name);

I think it's possible that the kernel message buffer is flooded with these
messages, which is not optimal in my opinion.


> +=09=09return false;
> +=09}
> +=09/*
> +=09 * According to Windows Precsiontion Touchpad's specs
> +=09 * https://docs.microsoft.com/en-us/windows-hardware/design/component=
-guidelines/windows-precision-touchpad-device-bus-connectivity,
> +=09 * GPIO Interrupt Assertion Leve could be either ActiveLow or
> +=09 * ActiveHigh.
> +=09 */
> +=09if (trigger_type & IRQF_TRIGGER_LOW)
> +=09=09return !status;
> +
> +=09return status;
> +}
> +
> +static int i2c_hid_polling_thread(void *i2c_hid)
> +{
> +=09struct i2c_hid *ihid =3D i2c_hid;
> +=09struct i2c_client *client =3D ihid->client;
> +=09unsigned int polling_interval_idle;
> +
> +=09while (1) {
> +=09=09if (kthread_should_stop())
> +=09=09=09break;

I think this should be `while (!kthread_should_stop())`.


> +
> +=09=09while (interrupt_line_active(client) &&
> +=09=09       !test_bit(I2C_HID_READ_PENDING, &ihid->flags) &&
> +=09=09       !kthread_should_stop()) {
> +=09=09=09i2c_hid_get_input(ihid);
> +=09=09=09usleep_range(polling_interval_active_us,
> +=09=09=09=09     polling_interval_active_us + 100);
> +=09=09}
> +=09=09/*
> +=09=09 * re-calculate polling_interval_idle
> +=09=09 * so the module parameters polling_interval_idle_ms can be
> +=09=09 * changed dynamically through sysfs as polling_interval_active_us
> +=09=09 */
> +=09=09polling_interval_idle =3D polling_interval_idle_ms * 1000;
> +=09=09usleep_range(polling_interval_idle,
> +=09=09=09     polling_interval_idle + 1000);

I don't quite understand why you use an extra variable here. I'm assuming
you want to "save" a multiplication? I believe the compiler will optimize i=
t
to a single read, and single multiplication regardless whether you use a "t=
emporary"
variable or not.


> +=09}
> +
> +=09do_exit(0);

Looking at other examples, I don't think `do_exit()` is necessary.


> +=09return 0;
> +}
> +
> +static int i2c_hid_init_polling(struct i2c_hid *ihid)
> +{
> +=09struct i2c_client *client =3D ihid->client;
> +
> +=09if (!irq_get_trigger_type(client->irq)) {
> +=09=09dev_warn(&client->dev,
> +=09=09=09 "Failed to get GPIO Interrupt Assertion Level, could not enabl=
e polling mode for %s",
> +=09=09=09 client->name);
> +=09=09return -EINVAL;
> +=09}
> +
> +=09ihid->polling_thread =3D kthread_create(i2c_hid_polling_thread, ihid,
> +=09=09=09=09=09      "I2C HID polling thread");
> +
> +=09if (!IS_ERR(ihid->polling_thread)) {
> +=09=09pr_info("I2C HID polling thread created");
> +=09=09wake_up_process(ihid->polling_thread);
> +=09=09return 0;
> +=09}
> +
> +=09return PTR_ERR(ihid->polling_thread);

I would personally rewrite this parts as

```
if (IS_ERR(...)) {
  dev_err(...);
  return PTR_ERR(...);
}
....
return 0;
```


> +}
> [...]


Regards,
Barnab=C3=A1s P=C5=91cze
