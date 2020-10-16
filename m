Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60DB62907E5
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 17:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409687AbgJPPBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 11:01:04 -0400
Received: from mail-03.mail-europe.com ([91.134.188.129]:53214 "EHLO
        mail-03.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409647AbgJPPBD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 11:01:03 -0400
Date:   Fri, 16 Oct 2020 15:00:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1602860456;
        bh=Oq0wpmvGRC9hGW185tYRKgXrLh7BTScF8zS8kr+piaA=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=CVyTAib1rCG/mIIKq/4zeVAAEP/QCMcHgTxRr0lDGwuV3lFEcDxqhg5WnliVrlI4s
         jbYPam7zi+csX2bGlcaZ1xDt3GkQtH8v2+lVcb4iYNhhEEZiGAuPx+eyu3WSOq6A0b
         gpeiTgCiPupV+4CmKudaxFM8Gcg8YrT5lH5ssAtE=
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
Message-ID: <T2SIcFVxZ81NUwKLDbSESA7Wpm7DYowEiii8ZaxTPtrdXZZeHLq5iZPkN5BLlp-9C6PLwUZOVwNpMdEdPSRZcAG4MmDt-tfyKZoQYJ0KHOA=@protonmail.com>
In-Reply-To: <20201016131335.8121-1-coiby.xu@gmail.com>
References: <20201016131335.8121-1-coiby.xu@gmail.com>
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

I still think that `i2c_hid_resume()` and `i2c_hid_suspend()` are asymmetri=
c and
that might lead to issues.


> [...]
> When polling mode is enabled, an I2C device can't wake up the suspended
> system since enable/disable_irq_wake is invalid for polling mode.
>

Excuse my ignorance, but could you elaborate this because I am not sure I u=
nderstand.
Aren't the two things orthogonal (polling and waking up the system)?


> [...]
>  #define I2C_HID_PWR_ON=09=090x00
>  #define I2C_HID_PWR_SLEEP=090x01
>
> +/* polling mode */
> +#define I2C_POLLING_DISABLED 0
> +#define I2C_POLLING_GPIO_PIN 1

This is a very small detail, but I personally think that these defines shou=
ld be
called I2C_HID_.... since they are only used here.


> +#define POLLING_INTERVAL 10
> +
> +static u8 polling_mode;
> +module_param(polling_mode, byte, 0444);
> +MODULE_PARM_DESC(polling_mode, "How to poll - 0 disabled; 1 based on GPI=
O pin's status");
> +
> +static unsigned int polling_interval_active_us =3D 4000;
> +module_param(polling_interval_active_us, uint, 0644);
> +MODULE_PARM_DESC(polling_interval_active_us,
> +=09=09 "Poll every {polling_interval_active_us} us when the touchpad is =
active. Default to 4000 us");
> +
> +static unsigned int polling_interval_idle_ms =3D 10;

There is a define for this value, I don't really see why you don't use it h=
ere.
And if there is a define for one value, I don't really see why there isn't =
one
for the other. (As far as I see `POLLING_INTERVAL` is not even used anywher=
e.)


> +module_param(polling_interval_idle_ms, uint, 0644);
> +MODULE_PARM_DESC(polling_interval_ms,
> +=09=09 "Poll every {polling_interval_idle_ms} ms when the touchpad is id=
le. Default to 10 ms");
>  /* debug option */
>  static bool debug;
>  module_param(debug, bool, 0444);
> @@ -158,6 +178,8 @@ struct i2c_hid {
>
>  =09struct i2c_hid_platform_data pdata;
>
> +=09struct task_struct *polling_thread;
> +
>  =09bool=09=09=09irq_wake_enabled;
>  =09struct mutex=09=09reset_lock;
>  };
> @@ -772,7 +794,9 @@ static int i2c_hid_start(struct hid_device *hid)
>  =09=09i2c_hid_free_buffers(ihid);
>
>  =09=09ret =3D i2c_hid_alloc_buffers(ihid, bufsize);
> -=09=09enable_irq(client->irq);
> +
> +=09=09if (polling_mode =3D=3D I2C_POLLING_DISABLED)
> +=09=09=09enable_irq(client->irq);
>
>  =09=09if (ret)
>  =09=09=09return ret;
> @@ -814,6 +838,86 @@ struct hid_ll_driver i2c_hid_ll_driver =3D {
>  };
>  EXPORT_SYMBOL_GPL(i2c_hid_ll_driver);
>
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
> +=09struct irq_desc *irq_desc =3D irq_to_desc(client->irq);
> +
> +=09/*
> +=09 * According to Windows Precsiontion Touchpad's specs
> +=09 * https://docs.microsoft.com/en-us/windows-hardware/design/component=
-guidelines/windows-precision-touchpad-device-bus-connectivity,
> +=09 * GPIO Interrupt Assertion Leve could be either ActiveLow or
> +=09 * ActiveHigh.
> +=09 */
> +=09if (trigger_type & IRQF_TRIGGER_LOW)
> +=09=09return !get_gpio_pin_state(irq_desc);
> +
> +=09return get_gpio_pin_state(irq_desc);
> +}

Excuse my ignorance, but I think some kind of error handling regarding the =
return
value of `get_gpio_pin_state()` should be present here.


> +
> +static int i2c_hid_polling_thread(void *i2c_hid)
> +{
> +=09struct i2c_hid *ihid =3D i2c_hid;
> +=09struct i2c_client *client =3D ihid->client;
> +=09unsigned int polling_interval_idle;
> +
> +=09while (1) {
> +=09=09/*
> +=09=09 * re-calculate polling_interval_idle
> +=09=09 * so the module parameters polling_interval_idle_ms can be
> +=09=09 * changed dynamically through sysfs as polling_interval_active_us
> +=09=09 */
> +=09=09polling_interval_idle =3D polling_interval_idle_ms * 1000;
> +=09=09if (test_bit(I2C_HID_READ_PENDING, &ihid->flags))
> +=09=09=09usleep_range(50000, 100000);
> +
> +=09=09if (kthread_should_stop())
> +=09=09=09break;
> +
> +=09=09while (interrupt_line_active(client)) {

I realize it's quite unlikely, but can't this be a endless loop if data is =
coming
in at a high enough rate? Maybe the maximum number of iterations could be l=
imited here?


> +=09=09=09i2c_hid_get_input(ihid);
> +=09=09=09usleep_range(polling_interval_active_us,
> +=09=09=09=09     polling_interval_active_us + 100);
> +=09=09}
> +
> +=09=09usleep_range(polling_interval_idle,
> +=09=09=09     polling_interval_idle + 1000);
> +=09}
> +
> +=09do_exit(0);
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
> +=09=09return -1;
> +=09}
> +
> +=09ihid->polling_thread =3D kthread_create(i2c_hid_polling_thread, ihid,
> +=09=09=09=09=09      "I2C HID polling thread");
> +
> +=09if (ihid->polling_thread) {

`kthread_create()` returns an errno in a pointer, so this check is incorrec=
t. It should be

 if (!IS_ERR(ihid->polling_thread))

I think it's a bit inconsistent that in this function you do:

 if (err)
   bail

 if (!err)
   return ok

 return err

moreover, I think the errno should be propagated, so use

 return PTR_ERR(ihid->polling_thread);

for example, when bailing out.


> +=09=09pr_info("I2C HID polling thread");
> +=09=09wake_up_process(ihid->polling_thread);
> +=09=09return 0;
> +=09}
> +
> +=09return -1;
> +}
> +
> [...]
>  #ifdef CONFIG_PM_SLEEP
> @@ -1183,15 +1300,16 @@ static int i2c_hid_suspend(struct device *dev)
>  =09/* Save some power */
>  =09i2c_hid_set_power(client, I2C_HID_PWR_SLEEP);
>
> -=09disable_irq(client->irq);
> -
> -=09if (device_may_wakeup(&client->dev)) {
> -=09=09wake_status =3D enable_irq_wake(client->irq);
> -=09=09if (!wake_status)
> -=09=09=09ihid->irq_wake_enabled =3D true;
> -=09=09else
> -=09=09=09hid_warn(hid, "Failed to enable irq wake: %d\n",
> -=09=09=09=09wake_status);
> +=09if (polling_mode =3D=3D I2C_POLLING_DISABLED) {
> +=09=09disable_irq(client->irq);
> +=09=09if (device_may_wakeup(&client->dev)) {
> +=09=09=09wake_status =3D enable_irq_wake(client->irq);
> +=09=09=09if (!wake_status)
> +=09=09=09=09ihid->irq_wake_enabled =3D true;
> +=09=09=09else
> +=09=09=09=09hid_warn(hid, "Failed to enable irq wake: %d\n",
> +=09=09=09=09=09 wake_status);
> +=09=09}
>  =09} else {
>  =09=09regulator_bulk_disable(ARRAY_SIZE(ihid->pdata.supplies),
>  =09=09=09=09       ihid->pdata.supplies);
> @@ -1208,7 +1326,7 @@ static int i2c_hid_resume(struct device *dev)
>  =09struct hid_device *hid =3D ihid->hid;
>  =09int wake_status;
>
> -=09if (!device_may_wakeup(&client->dev)) {
> +=09if (!device_may_wakeup(&client->dev) || polling_mode !=3D I2C_POLLING=
_DISABLED) {
>  =09=09ret =3D regulator_bulk_enable(ARRAY_SIZE(ihid->pdata.supplies),
>  =09=09=09=09=09    ihid->pdata.supplies);
>  =09=09if (ret)
> @@ -1225,7 +1343,8 @@ static int i2c_hid_resume(struct device *dev)
>  =09=09=09=09wake_status);
>  =09}
>
> -=09enable_irq(client->irq);
> +=09if (polling_mode =3D=3D I2C_POLLING_DISABLED)
> +=09=09enable_irq(client->irq);
> [...]

Before this patch, if a device cannot wake up, then the regulators are disa=
bled
when suspending, after this patch, regulators are only disabled if polling =
is
used. But they are enabled if the device cannot wake up *or* polling is use=
d.

Excuse my ignorance, but I do not understand why the following two changes =
are not enough:

in `i2c_hid_suspend()`:
 if (polling_mode =3D=3D I2C_POLLING_DISABLED)
   disable_irq(client->irq);

in `i2c_hid_resume()`:
 if (polling_mode =3D=3D I2C_POLLING_DISABLED)
   enable_irq(client->irq);


Regards,
Barnab=C3=A1s P=C5=91cze
