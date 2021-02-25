Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB348324DDA
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 11:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235057AbhBYKQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 05:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbhBYKO3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 05:14:29 -0500
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C30C0617A7
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 02:13:39 -0800 (PST)
Received: by mail-ua1-x92e.google.com with SMTP id a22so1710101uao.9
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 02:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1rwdBW0LAuJT29U18RbZg+7dDhrtIMwM8XGpp8ROhvA=;
        b=FU6ytM8QB25u4uEGM3w/0vqufiuzVnkI06gj4bOLXkPmRSvcYJSzU5MzEMUQd0Uf3Y
         xO6a/BnYszCWKNkC0i62ttuzeeWgCvBO4UewkIk7X6+kB2LnaIe97VC34H/Cba1HhbES
         hkoAw1pqXkUppF3K7zV3KDfwU6oxNfbvpQTyjsN9Xc7OuYjvSl0lT4oPDOF49b2Plrhg
         HFv/FO/IrST6F+GRW9Z/zQDWPfm7PNcr7FCTDuJM/qZuUZptF7wUQk3+lyjIswYGL+K8
         D+RTxerH34BL1ZeXQaQA8xgpfAxaPtVDLiXm/8WdcJxsRWLVtbahz1we5RaI/WsUPNCM
         s6eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1rwdBW0LAuJT29U18RbZg+7dDhrtIMwM8XGpp8ROhvA=;
        b=erVePlLx6DqJe7FhfnLbIvsQi4p0bO9bKFTV50SP9I2sRSd2FDQ8b4qqoYBGNHDUoF
         p86IruyTvl6r6zZ9N7eAn3xnXl0xgt/81Vf+o7yr+e57LZbMVLoJO3L/RW00F0LL4VVn
         COdn9tBQ9gGUG/Oqex1sgZ8EaN0bffzvQmSawZgGjg6Avu8ZNw5E2GrBQegX2dTRCXDx
         1jYQi9edNLZiVFGo4np1lfgr7t1oNfsv9oJskCBHyTsgCAwA7gavnKv+7PRhuAJWK2V9
         ZZzsDZhASY7T9av8mN0zjKU3sgMSxk9WQGI3eDQrOsS4w09Ch8QZd/q/JTB9Oqb0hbsr
         bx8A==
X-Gm-Message-State: AOAM533PU2v8EVw2ahXVZJem3k9GwPINH6IvVDd89OB/T6xO7+hnibUo
        eNwMMMJj9xQMfV7z+MeSBEdra2phl0FUXKgw3LlCDg==
X-Google-Smtp-Source: ABdhPJwJozf9VE/9g7E7vKLycikS7uqN3OXoyJk6oVUQSwSe8WrSJ2f9m+onS8ieEf4pWVssO6bQ8OAgvC3t7H1wL3k=
X-Received: by 2002:ab0:1d11:: with SMTP id j17mr1144266uak.99.1614248018333;
 Thu, 25 Feb 2021 02:13:38 -0800 (PST)
MIME-Version: 1.0
References: <20210219090409.325492-1-badhri@google.com> <c0fbb198-a905-cdd0-3c6e-6af484512a5b@roeck-us.net>
 <CAPTae5LMQQHkvWqcOC7D93kEJ4uJQuUu9Aq_RWTgiBfV74UC+g@mail.gmail.com>
In-Reply-To: <CAPTae5LMQQHkvWqcOC7D93kEJ4uJQuUu9Aq_RWTgiBfV74UC+g@mail.gmail.com>
From:   Badhri Jagan Sridharan <badhri@google.com>
Date:   Thu, 25 Feb 2021 02:13:01 -0800
Message-ID: <CAPTae5KHy5jfiSnfD9oNjC5Gf_-R-WWHmvRHC1KVs1WKzH4oKA@mail.gmail.com>
Subject: Re: [PATCH v2] usb: typec: tcpm: Wait for vbus discharge to VSAFE0V
 before toggling
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kyle Tso <kyletso@google.com>, USB <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 24, 2021 at 9:46 PM Badhri Jagan Sridharan
<badhri@google.com> wrote:
>
> On Fri, Feb 19, 2021 at 7:56 AM Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > On 2/19/21 1:04 AM, Badhri Jagan Sridharan wrote:
> > > When vbus auto discharge is enabled, TCPM can sometimes be faster than
> > > the TCPC i.e. TCPM can go ahead and move the port to unattached state
> > > (involves disabling vbus auto discharge) before TCPC could effectively
> > > discharge vbus to VSAFE0V. This leaves vbus with residual charge and
> > > increases the decay time which prevents tsafe0v from being met.
> > > This change introduces a new state VBUS_DISCHARGE where the TCPM waits
> > > for a maximum of tSafe0V(max) for vbus to discharge to VSAFE0V before
> > > transitioning to unattached state and re-enable toggling. If vbus
> > > discharges to vsafe0v sooner, then, transition to unattached state
> > > happens right away.
> > >
> > > Also, while in SNK_READY, when auto discharge is enabled, drive
> > > disconnect based on vbus turning off instead of Rp disappearing on
> > > CC pins. Rp disappearing on CC pins is almost instanteous compared
> > > to vbus decay.
> > >
> > > Fixes: f321a02caebd ("usb: typec: tcpm: Implement enabling Auto
> > > Discharge disconnect support")
> > > Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
> > > ---
> > > Changes since V1:
> > > - Add Fixes tag
> > > ---
> > >  drivers/usb/typec/tcpm/tcpm.c | 60 +++++++++++++++++++++++++++++++----
> > >  1 file changed, 53 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
> > > index be0b6469dd3d..0ed71725980f 100644
> > > --- a/drivers/usb/typec/tcpm/tcpm.c
> > > +++ b/drivers/usb/typec/tcpm/tcpm.c
> > > @@ -62,6 +62,8 @@
> > >       S(SNK_TRANSITION_SINK_VBUS),            \
> > >       S(SNK_READY),                           \
> > >                                               \
> > > +     S(VBUS_DISCHARGE),                      \
> > > +                                             \
> > >       S(ACC_UNATTACHED),                      \
> > >       S(DEBUG_ACC_ATTACHED),                  \
> > >       S(AUDIO_ACC_ATTACHED),                  \
> > > @@ -438,6 +440,9 @@ struct tcpm_port {
> > >       enum tcpm_ams next_ams;
> > >       bool in_ams;
> > >
> > > +     /* Auto vbus discharge state */
> > > +     bool auto_vbus_discharge_enabled;
> > > +
> > >  #ifdef CONFIG_DEBUG_FS
> > >       struct dentry *dentry;
> > >       struct mutex logbuffer_lock;    /* log buffer access lock */
> > > @@ -3413,6 +3418,8 @@ static int tcpm_src_attach(struct tcpm_port *port)
> > >       if (port->tcpc->enable_auto_vbus_discharge) {
> > >               ret = port->tcpc->enable_auto_vbus_discharge(port->tcpc, true);
> > >               tcpm_log_force(port, "enable vbus discharge ret:%d", ret);
> > > +             if (!ret)
> > > +                     port->auto_vbus_discharge_enabled = true;
> > >       }
> > >
> > >       ret = tcpm_set_roles(port, true, TYPEC_SOURCE, tcpm_data_role_for_source(port));
> > > @@ -3495,6 +3502,8 @@ static void tcpm_reset_port(struct tcpm_port *port)
> > >       if (port->tcpc->enable_auto_vbus_discharge) {
> > >               ret = port->tcpc->enable_auto_vbus_discharge(port->tcpc, false);
> > >               tcpm_log_force(port, "Disable vbus discharge ret:%d", ret);
> > > +             if (!ret)
> > > +                     port->auto_vbus_discharge_enabled = false;
> > >       }
> > >       port->in_ams = false;
> > >       port->ams = NONE_AMS;
> > > @@ -3568,6 +3577,8 @@ static int tcpm_snk_attach(struct tcpm_port *port)
> > >               tcpm_set_auto_vbus_discharge_threshold(port, TYPEC_PWR_MODE_USB, false, VSAFE5V);
> > >               ret = port->tcpc->enable_auto_vbus_discharge(port->tcpc, true);
> > >               tcpm_log_force(port, "enable vbus discharge ret:%d", ret);
> > > +             if (!ret)
> > > +                     port->auto_vbus_discharge_enabled = true;
> > >       }
> > >
> > >       ret = tcpm_set_roles(port, true, TYPEC_SINK, tcpm_data_role_for_sink(port));
> > > @@ -3684,6 +3695,12 @@ static void run_state_machine(struct tcpm_port *port)
> > >       switch (port->state) {
> > >       case TOGGLING:
> > >               break;
> > > +     case VBUS_DISCHARGE:
> > > +             if (port->port_type == TYPEC_PORT_SRC)
> > > +                     tcpm_set_state(port, SRC_UNATTACHED, PD_T_SAFE_0V);
> > > +             else
> > > +                     tcpm_set_state(port, SNK_UNATTACHED, PD_T_SAFE_0V);
> > > +             break;
> > >       /* SRC states */
> > >       case SRC_UNATTACHED:
> > >               if (!port->non_pd_role_swap)
> > > @@ -4669,7 +4686,9 @@ static void _tcpm_cc_change(struct tcpm_port *port, enum typec_cc_status cc1,
> > >       case SRC_READY:
> > >               if (tcpm_port_is_disconnected(port) ||
> > >                   !tcpm_port_is_source(port)) {
> > > -                     if (port->port_type == TYPEC_PORT_SRC)
> > > +                     if (port->auto_vbus_discharge_enabled && !port->vbus_vsafe0v)
> > > +                             tcpm_set_state(port, VBUS_DISCHARGE, 0);
> > > +                     else if (port->port_type == TYPEC_PORT_SRC)
> > >                               tcpm_set_state(port, SRC_UNATTACHED, 0);
> > >                       else
> > >                               tcpm_set_state(port, SNK_UNATTACHED, 0);
> >
> > Unless I am missing something, the new state is only used to set the
> > PD_T_SAFE_0V timeout. Is it really necessary/useful to add a new state
> > just for that, while keeping the rest of if/else statements ?
> > Personally I would prefer something like
> >                         timeout = (port->auto_vbus_discharge_enabled && !port->vbus_vsafe0v) ? PD_T_SAFE_0V : 0;
> >                         if (port->port_type == TYPEC_PORT_SRC)
> >                                 tcpm_set_state(port, SRC_UNATTACHED, timeout);
> >                         else
> >                                 tcpm_set_state(port, SNK_UNATTACHED, timeout);
> >
> Yes this should be OK as well. I was thinking  it would be more
> clearer during debug if there
> was a separate state altogether, but, looks like we should be fine.
> Implementing/Validating it now. Will send a follow up version today.

Just sent out the V3 version of the patch.



>
> > In this context, any idea why port_type==TYPEC_PORT_DRP results in
> > SNK_UNATTACHED state ? That seems a bit odd.
>
> This comes from the patch here:
> https://lore.kernel.org/r/1582128343-22438-1-git-send-email-jun.li@nxp.com
>
> Looks reasonable to me as tcpm_*_detach functions call  tcpm_detach so
> teardown should
> happen anyways.
>
> static void tcpm_snk_detach(struct tcpm_port *port)
> {
>         tcpm_detach(port);
> }
>
>
> static void tcpm_src_detach(struct tcpm_port *port)
> {
>         tcpm_detach(port);
> }
>
> Thanks,
> Badhri
>
> >
> > Guenter
> >
> > > @@ -4703,7 +4722,18 @@ static void _tcpm_cc_change(struct tcpm_port *port, enum typec_cc_status cc1,
> > >                       tcpm_set_state(port, SNK_DEBOUNCED, 0);
> > >               break;
> > >       case SNK_READY:
> > > -             if (tcpm_port_is_disconnected(port))
> > > +             /*
> > > +              * When set_auto_vbus_discharge_threshold is enabled, CC pins go
> > > +              * away before vbus decays to disconnect threshold. Allow
> > > +              * disconnect to be driven by vbus disconnect when auto vbus
> > > +              * discharge is enabled.
> > > +              *
> > > +              * EXIT condition is based primarily on vbus disconnect and CC is secondary.
> > > +              * "A port that has entered into USB PD communications with the Source and
> > > +              * has seen the CC voltage exceed vRd-USB may monitor the CC pin to detect
> > > +              * cable disconnect in addition to monitoring VBUS.
> > > +              */
> > > +             if (!port->auto_vbus_discharge_enabled && tcpm_port_is_disconnected(port))
> > >                       tcpm_set_state(port, unattached_state(port), 0);
> > >               else if (!port->pd_capable &&
> > >                        (cc1 != old_cc1 || cc2 != old_cc2))
> > > @@ -4803,9 +4833,16 @@ static void _tcpm_cc_change(struct tcpm_port *port, enum typec_cc_status cc1,
> > >                */
> > >               break;
> > >
> > > +     case VBUS_DISCHARGE:
> > > +             /* Do nothing. Waiting for vsafe0v signal */
> > > +             break;
> > >       default:
> > > -             if (tcpm_port_is_disconnected(port))
> > > -                     tcpm_set_state(port, unattached_state(port), 0);
> > > +             if (tcpm_port_is_disconnected(port)) {
> > > +                     if (port->auto_vbus_discharge_enabled && !port->vbus_vsafe0v)
> > > +                             tcpm_set_state(port, VBUS_DISCHARGE, 0);
> > > +                     else
> > > +                             tcpm_set_state(port, unattached_state(port), 0);
> > > +             }
> > >               break;
> > >       }
> > >  }
> > > @@ -4988,9 +5025,12 @@ static void _tcpm_pd_vbus_off(struct tcpm_port *port)
> > >               break;
> > >
> > >       default:
> > > -             if (port->pwr_role == TYPEC_SINK &&
> > > -                 port->attached)
> > > -                     tcpm_set_state(port, SNK_UNATTACHED, 0);
> > > +             if (port->pwr_role == TYPEC_SINK && port->attached) {
> > > +                     if (port->auto_vbus_discharge_enabled && !port->vbus_vsafe0v)
> > > +                             tcpm_set_state(port, VBUS_DISCHARGE, 0);
> > > +                     else
> > > +                             tcpm_set_state(port, SNK_UNATTACHED, 0);
> > > +             }
> > >               break;
> > >       }
> > >  }
> > > @@ -5012,6 +5052,12 @@ static void _tcpm_pd_vbus_vsafe0v(struct tcpm_port *port)
> > >                       tcpm_set_state(port, tcpm_try_snk(port) ? SNK_TRY : SRC_ATTACHED,
> > >                                      PD_T_CC_DEBOUNCE);
> > >               break;
> > > +     case VBUS_DISCHARGE:
> > > +             if (port->port_type == TYPEC_PORT_SRC)
> > > +                     tcpm_set_state(port, SRC_UNATTACHED, 0);
> > > +             else
> > > +                     tcpm_set_state(port, SNK_UNATTACHED, 0);
> > > +             break;
> > >       default:
> > >               break;
> > >       }
> > >
> >
