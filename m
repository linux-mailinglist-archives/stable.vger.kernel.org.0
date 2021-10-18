Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C0C431237
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 10:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhJRIiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 04:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbhJRIiW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 04:38:22 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD290C06161C;
        Mon, 18 Oct 2021 01:36:11 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id om14so11687609pjb.5;
        Mon, 18 Oct 2021 01:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=e0kdLkD7pZRAkePxZlavi1XD/fD21XOj14D1C96LosY=;
        b=JFqo3sb8pkZCRSvu1rEeQfI5Y6NbWKbBWKinfaf5aZJtKRdF+BdoM7IhNkHVQrn46w
         4LDhETKduqsWN6QPj2886xrj8BlnnjAiccJbdVqtvbuEElaSDTW9a8xxrpt/KsR9w0PY
         IsVS2M82nileCCN1xp3297ITAkMYEPGnV1U7E8IPis/FwZ1faXv4iQ4qF05rLglJAUKh
         0mmyKBBPefC/KU66DmICjwOFF6QtIxxSp4MbERxJNnc4cWilIpUCxh+xYKavwbAv1MOs
         VPcdnvs/WI/6PG52w39Xz3ROmrzkzVV8ybov4EIuhmb4tyV0qGK7VHzCzIG2z1xyfmoz
         nqIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=e0kdLkD7pZRAkePxZlavi1XD/fD21XOj14D1C96LosY=;
        b=grbEfy2N8i4DT1JEymyM6tOY4mjHC1dr7Ex08tHoVesaLUgRvkmqZLkDYEOxxrUJa+
         B5213cq2Ql9b6b9dFHtod77WGroTO7QsG1nrzwzlv7d4fZScGMYCFmoU+vw3uxh8Cwun
         +8v1MmFOSmn/gyn1j+y2ZosYa+4d2J+oB2ZyTe+yrgf0JArr2p/wbxC9kQi7vHAnDVRN
         d2p1P7tkHpoiKiGGUn5vqfDWaD30JI6o79wPgiD6qR4qFAjWLqZ5zO9yOkS+u0T1RLQr
         Z1eIgne82oSeH038EWlHMQrafH1V4PSfhQXopgrnosRdJ3ttJM63IQI1jZuL/Wjn3bgD
         t4FA==
X-Gm-Message-State: AOAM531+oOx98gBnsBWUg8kAwhcTHwTSHDIPjiPZfJJCMqD/LnvZaQZs
        FMttRvJLYba7QJnpKCs4GKLw7ziBSO8Foc0/n9o=
X-Google-Smtp-Source: ABdhPJwfW2BMs4pFS8i29cq44LoJ8jNyRZ/PdveuFL+L0pWK9sVi4kUmCi6AdaNvyu0JToFHtGXhPAh10oDjVIY2MqE=
X-Received: by 2002:a17:90b:1c8f:: with SMTP id oo15mr31234479pjb.169.1634546171209;
 Mon, 18 Oct 2021 01:36:11 -0700 (PDT)
MIME-Version: 1.0
References: <20211008081137.1948848-1-michal.vokac@ysoft.com> <df545947-2f5b-a355-859d-7f61eab14dcb@linaro.org>
In-Reply-To: <df545947-2f5b-a355-859d-7f61eab14dcb@linaro.org>
From:   Petr Benes <petrben@gmail.com>
Date:   Mon, 18 Oct 2021 10:36:00 +0200
Message-ID: <CAPwXO5Z0OkmXuy=e6JDjFwqJMqOC4FDjs3uiwdZcJSxy5SPtVw@mail.gmail.com>
Subject: Re: [PATCH] thermal: imx: Fix temperature measurements on i.MX6 after alarm
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     =?UTF-8?B?TWljaGFsIFZva8OhxI0=?= <michal.vokac@ysoft.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        linux-pm@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Amit Kucheria <amitk@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Petr_Bene=C5=A1?= <petr.benes@ysoft.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 17 Oct 2021 at 00:23, Daniel Lezcano <daniel.lezcano@linaro.org> wr=
ote:
>
> On 08/10/2021 10:11, Michal Vok=C3=A1=C4=8D wrote:
> > From: Petr Bene=C5=A1 <petr.benes@ysoft.com>
> >
> > SoC temperature readout may not work after thermal alarm fires interrup=
t.
> > This harms userspace as well as CPU cooling device.
> >
> > Two issues with the logic involved. First, there is no protection again=
st
> > concurent measurements, hence one can switch the sensor off while
> > the other one tries to read temperature later. Second, the interrupt pa=
th
> > usually fails. At the end the sensor is powered off and thermal IRQ is
> > disabled. One has to reenable the thermal zone by the sysfs interface.
> >
> > Most of troubles come from commit d92ed2c9d3ff ("thermal: imx: Use
> > driver's local data to decide whether to run a measurement")
>
> Are these troubles observed and reproduced ? Or is it your understanding
> from reading the code ?

Yes, it is observed. We are using:
CONFIG_CPU_THERMAL=3Dy
CONFIG_CPU_FREQ_THERMAL=3Dy
If the SoC temperature oscillates  around the passive trip point, it is not
possible to read out /sys/class/thermal/thermal_zone0/temp after
a while (minutes). For reproduction either heat the device up a bit or set
the passive trip point lower.

>
> get_temp() and tz enable/disable are protected against races in the core
> code via the tz mutex

imx_get_temp() itself doesn't handle concurrent invocations properly, despi=
te
it may seem it does. The sensor is switched on/off without control.
That is a flaw in imx_get_temp().
No evidence the core locking is wrong.

data->irq_enabled is set to false in imx_thermal_alarm_irq() each time
the interrupt arrives. imx_get_temp() does wrong decision based
on the value later.

>
> > It uses data->irq_enabled as the "local data". Indeed, its value is
> > related to the state of the sensor loosely under normal operation and,
> > frankly, gets unleashed when the thermal interrupt arrives.
> >
> > Current patch adds the "local data" (new member sensor_on in
> > imx_thermal_data) and sets its value in controlled manner.>
> > Fixes: d92ed2c9d3ff ("thermal: imx: Use driver's local data to decide w=
hether to run a measurement")
> > Cc: petrben@gmail.com
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Petr Bene=C5=A1 <petr.benes@ysoft.com>
> > Signed-off-by: Michal Vok=C3=A1=C4=8D <michal.vokac@ysoft.com>
> > ---
> >  drivers/thermal/imx_thermal.c | 30 ++++++++++++++++++++++++++----
> >  1 file changed, 26 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_therma=
l.c
> > index 2c7473d86a59..df5658e21828 100644
> > --- a/drivers/thermal/imx_thermal.c
> > +++ b/drivers/thermal/imx_thermal.c
> > @@ -209,6 +209,8 @@ struct imx_thermal_data {
> >       struct clk *thermal_clk;
> >       const struct thermal_soc_data *socdata;
> >       const char *temp_grade;
> > +     struct mutex sensor_lock;
> > +     bool sensor_on;
> >  };
> >
> >  static void imx_set_panic_temp(struct imx_thermal_data *data,
> > @@ -252,11 +254,12 @@ static int imx_get_temp(struct thermal_zone_devic=
e *tz, int *temp)
> >       const struct thermal_soc_data *soc_data =3D data->socdata;
> >       struct regmap *map =3D data->tempmon;
> >       unsigned int n_meas;
> > -     bool wait, run_measurement;
> > +     bool wait;
> >       u32 val;
> >
> > -     run_measurement =3D !data->irq_enabled;
> > -     if (!run_measurement) {
> > +     mutex_lock(&data->sensor_lock);
> > +
> > +     if (data->sensor_on) {
> >               /* Check if a measurement is currently in progress */
> >               regmap_read(map, soc_data->temp_data, &val);
> >               wait =3D !(val & soc_data->temp_valid_mask);
> > @@ -283,13 +286,15 @@ static int imx_get_temp(struct thermal_zone_devic=
e *tz, int *temp)
> >
> >       regmap_read(map, soc_data->temp_data, &val);
> >
> > -     if (run_measurement) {
> > +     if (!data->sensor_on) {
> >               regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
> >                            soc_data->measure_temp_mask);
> >               regmap_write(map, soc_data->sensor_ctrl + REG_SET,
> >                            soc_data->power_down_mask);
> >       }
> >
> > +     mutex_unlock(&data->sensor_lock);
> > +
> >       if ((val & soc_data->temp_valid_mask) =3D=3D 0) {
> >               dev_dbg(&tz->device, "temp measurement never finished\n")=
;
> >               return -EAGAIN;
> > @@ -339,20 +344,26 @@ static int imx_change_mode(struct thermal_zone_de=
vice *tz,
> >       const struct thermal_soc_data *soc_data =3D data->socdata;
> >
> >       if (mode =3D=3D THERMAL_DEVICE_ENABLED) {
> > +             mutex_lock(&data->sensor_lock);
> >               regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
> >                            soc_data->power_down_mask);
> >               regmap_write(map, soc_data->sensor_ctrl + REG_SET,
> >                            soc_data->measure_temp_mask);
> > +             data->sensor_on =3D true;
> > +             mutex_unlock(&data->sensor_lock);
> >
> >               if (!data->irq_enabled) {
> >                       data->irq_enabled =3D true;
> >                       enable_irq(data->irq);
> >               }
> >       } else {
> > +             mutex_lock(&data->sensor_lock);
> >               regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
> >                            soc_data->measure_temp_mask);
> >               regmap_write(map, soc_data->sensor_ctrl + REG_SET,
> >                            soc_data->power_down_mask);
> > +             data->sensor_on =3D false;
> > +             mutex_unlock(&data->sensor_lock);
> >
> >               if (data->irq_enabled) {
> >                       disable_irq(data->irq);
> > @@ -728,6 +739,8 @@ static int imx_thermal_probe(struct platform_device=
 *pdev)
> >       }
> >
> >       /* Make sure sensor is in known good state for measurements */
> > +     mutex_init(&data->sensor_lock);
> > +     mutex_lock(&data->sensor_lock);
> >       regmap_write(map, data->socdata->sensor_ctrl + REG_CLR,
> >                    data->socdata->power_down_mask);
> >       regmap_write(map, data->socdata->sensor_ctrl + REG_CLR,
> > @@ -739,6 +752,8 @@ static int imx_thermal_probe(struct platform_device=
 *pdev)
> >                       IMX6_MISC0_REFTOP_SELBIASOFF);
> >       regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
> >                    data->socdata->power_down_mask);
> > +     data->sensor_on =3D false;
> > +     mutex_unlock(&data->sensor_lock);
> >
> >       ret =3D imx_thermal_register_legacy_cooling(data);
> >       if (ret)
> > @@ -796,10 +811,13 @@ static int imx_thermal_probe(struct platform_devi=
ce *pdev)
> >       if (data->socdata->version =3D=3D TEMPMON_IMX6SX)
> >               imx_set_panic_temp(data, data->temp_critical);
> >
> > +     mutex_lock(&data->sensor_lock);
> >       regmap_write(map, data->socdata->sensor_ctrl + REG_CLR,
> >                    data->socdata->power_down_mask);
> >       regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
> >                    data->socdata->measure_temp_mask);
> > +     data->sensor_on =3D true;
> > +     mutex_unlock(&data->sensor_lock);
> >
> >       data->irq_enabled =3D true;
> >       ret =3D thermal_zone_device_enable(data->tz);
> > @@ -832,8 +850,12 @@ static int imx_thermal_remove(struct platform_devi=
ce *pdev)
> >       struct regmap *map =3D data->tempmon;
> >
> >       /* Disable measurements */
> > +     mutex_lock(&data->sensor_lock);
> >       regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
> >                    data->socdata->power_down_mask);
> > +     data->sensor_on =3D false;
> > +     mutex_unlock(&data->sensor_lock);
> > +
> >       if (!IS_ERR(data->thermal_clk))
> >               clk_disable_unprepare(data->thermal_clk);
> >
> >
>
>
> --
> <http://www.linaro.org/> Linaro.org =E2=94=82 Open source software for AR=
M SoCs
>
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog
