Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBDE340F47
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 21:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbhCRUlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 16:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbhCRUkp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 16:40:45 -0400
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D814C061760
        for <stable@vger.kernel.org>; Thu, 18 Mar 2021 13:40:44 -0700 (PDT)
Received: by mail-vk1-xa30.google.com with SMTP id w63so1606994vkf.11
        for <stable@vger.kernel.org>; Thu, 18 Mar 2021 13:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xol55/9H4SiYpqW9PDFqK2rSIMyEWIaJbvYIxkmuGOA=;
        b=D1ja9+Cs7QVmfxGC2t4MBWS4rYjTTsocGFOGexTP0gi+5M1B8TFSVQYS/Mr+tWfIJ1
         /qPtxE3EdhkgArFi8zW5u9kGkJijPDuS5AnlhlhkjXcr0YItpI5bX4jQ7gluT8JkiZsI
         N9Tq9o5+Szipn+eGj7vv2Q4hbfzsP5AYjH0qBDOhPOsq5heHR6JGkHQxpT9PDfd6KcrW
         z5mswn4Yc4rB/0i48ZdNeomjdXzBJ7C/xjxkj6R6EVs392CG5PB9E/I0F3ySq3ow8ikF
         x0pn6B1ZQJnXWeRmm3V7Q47+XX2V1LK69/DSaSJstWTbsx7JkvpxggDC0GJQcedjnD2w
         6DxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xol55/9H4SiYpqW9PDFqK2rSIMyEWIaJbvYIxkmuGOA=;
        b=msGLT1P5ByBKU+iEgaoe1bthWXae4ykzlzd7xGU8K5dTDJajysAcgSMKkvQmBxpixN
         k31b6MU5157AiV2iwvV0BLfH+slcbJ2edreKG/0nsm3fL4SLDTnXef5k7NBYolOQPMz4
         NixIlDJ8WUbgUjCh/61yoLzm9JfXiXLo8ByjIyBY3hC+nysTis/CRxpGorz3L3WPi5XJ
         TQda/mFunGe9NGwRVohPQdcvSlRgIy7FrLToe2E5+qyeJ9WTOMcL7kIghFOL/Yxsib7c
         Jsr1YjwTJ3woQm0yKZpwK1za0H65ZBymVQUo5ahZdQIUm1sK9jI8j1wxoex8f0+ril6c
         ZfFA==
X-Gm-Message-State: AOAM5325wmR2PdC7NxS/fLcCrEDVXtldVnuBpTjC/W+DlxI5c7WI5+T6
        YIWehJxxRTwsBYidwteSkPlNnPhuUljQwbLiDoYgqw==
X-Google-Smtp-Source: ABdhPJza7/s835SEdRq/LrIOvtCqfvw6RkbFHI6+Rff1fy9HvfuZEf0HJuKK/0r6FgTZ34f9B4qTL3JMqPUUiJAUQIo=
X-Received: by 2002:a1f:a5d7:: with SMTP id o206mr966897vke.22.1616100041505;
 Thu, 18 Mar 2021 13:40:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210317181249.1062995-1-badhri@google.com> <PR3PR10MB41420951E2867C2E0E5272B980699@PR3PR10MB4142.EURPRD10.PROD.OUTLOOK.COM>
In-Reply-To: <PR3PR10MB41420951E2867C2E0E5272B980699@PR3PR10MB4142.EURPRD10.PROD.OUTLOOK.COM>
From:   Badhri Jagan Sridharan <badhri@google.com>
Date:   Thu, 18 Mar 2021 13:40:05 -0700
Message-ID: <CAPTae5J_GdHsGQvNxgpffk5otyGhY8D48vddvin3A4fkz3KWUA@mail.gmail.com>
Subject: Re: [PATCH v2] usb: typec: tcpm: Invoke power_supply_changed for tcpm-source-psy-
To:     Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 18, 2021 at 8:26 AM Adam Thomson
<Adam.Thomson.Opensource@diasemi.com> wrote:
>
> On 17 March 2021 18:13, Badhri Jagan Sridharan wrote:
>
> > tcpm-source-psy- does not invoke power_supply_changed API when
> > one of the published power supply properties is changed.
> > power_supply_changed needs to be called to notify
> > userspace clients(uevents) and kernel clients.
> >
> > Fixes: f2a8aa053c176("typec: tcpm: Represent source supply through
> > power_supply")
> > Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
> > Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> > Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > ---
> > Changes since V1:
> > - Fixed commit message as per Guenter's suggestion
> > - Added Reviewed-by tags
> > - cc'ed stable
> > ---
> >  drivers/usb/typec/tcpm/tcpm.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
> > index 11d0c40bc47d..e8936ea17f80 100644
> > --- a/drivers/usb/typec/tcpm/tcpm.c
> > +++ b/drivers/usb/typec/tcpm/tcpm.c
> > @@ -945,6 +945,7 @@ static int tcpm_set_current_limit(struct tcpm_port *port,
> > u32 max_ma, u32 mv)
> >
> >       port->supply_voltage = mv;
> >       port->current_limit = max_ma;
> > +     power_supply_changed(port->psy);
> >
> >       if (port->tcpc->set_current_limit)
> >               ret = port->tcpc->set_current_limit(port->tcpc, max_ma, mv);
> > @@ -2931,6 +2932,7 @@ static int tcpm_pd_select_pdo(struct tcpm_port *port,
> > int *sink_pdo,
> >
> >       port->pps_data.supported = false;
> >       port->usb_type = POWER_SUPPLY_USB_TYPE_PD;
> > +     power_supply_changed(port->psy);
> >
> >       /*
> >        * Select the source PDO providing the most power which has a
> > @@ -2955,6 +2957,7 @@ static int tcpm_pd_select_pdo(struct tcpm_port *port,
> > int *sink_pdo,
> >                               port->pps_data.supported = true;
> >                               port->usb_type =
> >                                       POWER_SUPPLY_USB_TYPE_PD_PPS;
> > +                             power_supply_changed(port->psy);
> >                       }
> >                       continue;
> >               default:
> > @@ -3112,6 +3115,7 @@ static unsigned int tcpm_pd_select_pps_apdo(struct
> > tcpm_port *port)
> >                                                 port->pps_data.out_volt));
> >               port->pps_data.op_curr = min(port->pps_data.max_curr,
> >                                            port->pps_data.op_curr);
> > +             power_supply_changed(port->psy);
> >       }
> >
> >       return src_pdo;
>
> Regarding selecting PDOs or PPS APDOs, surely we should only notify of a change
> when we reach SNK_READY which means a new contract has been established? Until
> that point it's possible any requested change could be rejected so why inform
> clients before we know the settings have taken effect? I could be missing
> something here as it's been a little while since I delved into this, but this
> doesn't seem to make sense to me.

I was trying to keep the power_supply_changed call close to the
variables which are used to infer the power supply property values.
Since port->pps_data.max_curr is already updated here and that's used
to infer the CURRENT_MAX a client could still read this before the
request goes through right ?
>
> > @@ -3347,6 +3351,7 @@ static int tcpm_set_charge(struct tcpm_port *port, bool
> > charge)
> >                       return ret;
> >       }
> >       port->vbus_charge = charge;
> > +     power_supply_changed(port->psy);
> >       return 0;
> >  }
> >
> > @@ -3530,6 +3535,7 @@ static void tcpm_reset_port(struct tcpm_port *port)
> >       port->try_src_count = 0;
> >       port->try_snk_count = 0;
> >       port->usb_type = POWER_SUPPLY_USB_TYPE_C;
> > +     power_supply_changed(port->psy);
>
> This is already taken care of at the end of this function, isn't it?
I thought I deleted that. Looks like I didn't. Will send in a patch to
remove that.
Will wait for what we decide for the PPS case so that I can send in
both in the same patch.

Thanks,
Badhri

>
> >       port->nr_sink_caps = 0;
> >       port->sink_cap_done = false;
> >       if (port->tcpc->enable_frs)
> > @@ -5957,7 +5963,7 @@ static int tcpm_psy_set_prop(struct power_supply
> > *psy,
> >               ret = -EINVAL;
> >               break;
> >       }
> > -
> > +     power_supply_changed(port->psy);
> >       return ret;
> >  }
> >
> > @@ -6110,6 +6116,7 @@ struct tcpm_port *tcpm_register_port(struct device
> > *dev, struct tcpc_dev *tcpc)
> >       err = devm_tcpm_psy_register(port);
> >       if (err)
> >               goto out_role_sw_put;
> > +     power_supply_changed(port->psy);
> >
> >       port->typec_port = typec_register_port(port->dev, &port->typec_caps);
> >       if (IS_ERR(port->typec_port)) {
> > --
> > 2.31.0.rc2.261.g7f71774620-goog
>
