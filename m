Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6F14317A4
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 13:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbhJRLoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 07:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbhJRLoK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 07:44:10 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1444C061714;
        Mon, 18 Oct 2021 04:41:59 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id f11so10620776pfc.12;
        Mon, 18 Oct 2021 04:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oxtTocfZDe8NeogbuLWnnR+icWeZEV7xYOyxnqTH3SM=;
        b=DHV9wmyFndQgoNutJNXy8Mn3Thc4M+NvSKgdROTSPktZby8DuA8Y/PgUj17WwZCl0Q
         ASLHqB3NJ4+o+F0MgYOJ0QRk3/spslLQsQXE7aR7sVX/vlkv2W9/8kSfYj7WhdY2/1Bj
         fydbaP5X9fdMUOxtm21srDGnHY85VKX1zaQdBxghbl0fHgwYVRBY6NhZgJjHCkxYqLRZ
         Fk36NNHbBHjrxVNuPnahG6lVlUyhTT+nuUJ05Tom5hUUf36zS9CEUEhEKD7kBAKz9cjV
         Th+7pp1A4FpmsxqF3NPH9slvb3TSi6jXRq+XWXD+o+FHV+0lYE25pynVyEoTvdo4aHe2
         jkWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oxtTocfZDe8NeogbuLWnnR+icWeZEV7xYOyxnqTH3SM=;
        b=0VswrrphndwZu3kqumvZiC85jkaOjiJq/xLqlraj+y8KYB5ERxNsr9GbXiBrykz4wV
         38H8V5kz5XB/B2uFXP5lDbcxRkkkhWyL6Rm8QKoTWHt6oOwdyQ1WPsezwpEcgX0x4mxn
         fggxigcDLSkZGkvQcFLnzz88lKMFdIxlVxLuyHxaYpXwVmSmP4QQH8biuHAbPQn3MI5j
         MabExs761LQBKZu6+Tv+b/6bbG5mwJ5T2ewifRGX/iX7i7QYKqlcUFZuqagnqnVoL8/G
         2Han0OWtP/e4DyDC6C1lS5sO2RVmEDbg88QcJJqloaNP4XRpY7vzG/mtgsgV9QfshH7/
         w2MQ==
X-Gm-Message-State: AOAM531IbPIP1hJ1SlJhvCwhPBiKPvXkJ/BBh5SoCfjVQyRdJjMuIttw
        vH6ao1Y0wN/UK4PjpqQXTgUPiSkHYR7StddTGBk=
X-Google-Smtp-Source: ABdhPJxX1kTRuEYsnSqJEtQqx3+Nw06ckCygthr62u1HSIiaRQXy1kjO8K75emjTpvAbpZ/9geg4JjkdzfxIE/zSDV0=
X-Received: by 2002:a63:4754:: with SMTP id w20mr23146985pgk.98.1634557319344;
 Mon, 18 Oct 2021 04:41:59 -0700 (PDT)
MIME-Version: 1.0
References: <20211008081137.1948848-1-michal.vokac@ysoft.com> <20211018112820.qkebjt2gk2w53lp5@pengutronix.de>
In-Reply-To: <20211018112820.qkebjt2gk2w53lp5@pengutronix.de>
From:   Petr Benes <petrben@gmail.com>
Date:   Mon, 18 Oct 2021 13:41:48 +0200
Message-ID: <CAPwXO5Y8e8zpo_8zrfM=JFNkhKehE0mnpe8wzUzOQiifEZnx9Q@mail.gmail.com>
Subject: Re: [PATCH] thermal: imx: Fix temperature measurements on i.MX6 after alarm
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     =?UTF-8?B?TWljaGFsIFZva8OhxI0=?= <michal.vokac@ysoft.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        linux-pm@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
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

On Mon, 18 Oct 2021 at 13:28, Oleksij Rempel <o.rempel@pengutronix.de> wrot=
e:
>
> Hi Michal,
>
> I hope you have seen this patch:
> https://lore.kernel.org/all/20210924115032.29684-1-o.rempel@pengutronix.d=
e/
>
> Are there any reason why this was ignored?

Missed completely. It looks it addresses the problem more systematically.

>
> On Fri, Oct 08, 2021 at 10:11:37AM +0200, Michal Vok=C3=A1=C4=8D wrote:
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
> >
> > It uses data->irq_enabled as the "local data". Indeed, its value is
> > related to the state of the sensor loosely under normal operation and,
> > frankly, gets unleashed when the thermal interrupt arrives.
> >
> > Current patch adds the "local data" (new member sensor_on in
> > imx_thermal_data) and sets its value in controlled manner.
> >
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
> > --
> > 2.25.1
> >
