Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB2C324A3F
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 06:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbhBYFrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 00:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbhBYFrW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 00:47:22 -0500
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796ACC06174A
        for <stable@vger.kernel.org>; Wed, 24 Feb 2021 21:46:42 -0800 (PST)
Received: by mail-vs1-xe30.google.com with SMTP id m18so2037719vsg.7
        for <stable@vger.kernel.org>; Wed, 24 Feb 2021 21:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7rjxHnpyYn9L8b5/UDQL6DJ1bU7foo2uFq2+dZ8sa4Y=;
        b=q6SaxgMehhZKqHr35k4EhsbU7RgRd2N6TlC5zRxFfrx7ADEhd+X5erKoplc/AwXcju
         Dy0/MHQox2Fke9+SpXgXQ2/nAEa6NvE7VmDkWf2fDE69GMFZMu0AdOURM7Nka+s568NP
         R048xtZUf2lSOHFED/00TKEXA03aBxSv0iaF0Cyd/mjo/PPKCxuSdD28Ut9Y5622YPLd
         m/X5K7J2Nmp7qdxNvYPmxcnJNQIaeTWKAQX1Y8rmUB5+H2dn12D1iYdZNDVgLon35/p/
         Tvd9TwA9w7bQhkc28Ehf+M5mNFGvZiupmbNNNndLaHa726HpZ6QtSjH2ttPTbtC3My7B
         9azQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7rjxHnpyYn9L8b5/UDQL6DJ1bU7foo2uFq2+dZ8sa4Y=;
        b=Fo+yeByirthjK7/Ol4ZDVwmKcFiNbAGXjlKwq4AlQsxZe/XyL2SOJfbv82rmBFgHjZ
         eqsEgDrCVStVF7zNSkAqy1LS00orNw29ORaqLjvLyrK3h6+yNi9JmKS+TFKwtMAj3rvn
         9u4j5JcUpA/CZ1Ih+djMbX1XIKcUAVvrnVD07PzQkDGPgZjf8oIzfjxsGO5LfAFvINWW
         LVkc5Xmg7NO3a9Y3vin2TcWkm55tHD8CbGImGDyMwU6Tc69OQQdB3Tea4P/WMGB1VieX
         AmcDHW6KbMM/NS4OTGFrDxQ3nrjrIsaQyg1wQbuMeDTSMPOS+chpNwwmpC7yTO30ogkS
         75XA==
X-Gm-Message-State: AOAM532fEm7iLPJvA4H+Cmvkc8uCN558TqbbsKNguqmzUY/3LZ2R64pf
        vG8ndpfPM2dxqgh+lCDKZJbk6u7+NLgXySJANMDGEg==
X-Google-Smtp-Source: ABdhPJxEPwVthGsdGSRPx7Effuj2Mji3bxKzcuMjub0N8jASxnKfkethKtBAD1IEyxWE8X63GJEE6Ps/1iLJ/Ne+4Uw=
X-Received: by 2002:a05:6102:1275:: with SMTP id q21mr689951vsg.43.1614232001065;
 Wed, 24 Feb 2021 21:46:41 -0800 (PST)
MIME-Version: 1.0
References: <20210219090409.325492-1-badhri@google.com> <c0fbb198-a905-cdd0-3c6e-6af484512a5b@roeck-us.net>
In-Reply-To: <c0fbb198-a905-cdd0-3c6e-6af484512a5b@roeck-us.net>
From:   Badhri Jagan Sridharan <badhri@google.com>
Date:   Wed, 24 Feb 2021 21:46:04 -0800
Message-ID: <CAPTae5LMQQHkvWqcOC7D93kEJ4uJQuUu9Aq_RWTgiBfV74UC+g@mail.gmail.com>
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

On Fri, Feb 19, 2021 at 7:56 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 2/19/21 1:04 AM, Badhri Jagan Sridharan wrote:
> > When vbus auto discharge is enabled, TCPM can sometimes be faster than
> > the TCPC i.e. TCPM can go ahead and move the port to unattached state
> > (involves disabling vbus auto discharge) before TCPC could effectively
> > discharge vbus to VSAFE0V. This leaves vbus with residual charge and
> > increases the decay time which prevents tsafe0v from being met.
> > This change introduces a new state VBUS_DISCHARGE where the TCPM waits
> > for a maximum of tSafe0V(max) for vbus to discharge to VSAFE0V before
> > transitioning to unattached state and re-enable toggling. If vbus
> > discharges to vsafe0v sooner, then, transition to unattached state
> > happens right away.
> >
> > Also, while in SNK_READY, when auto discharge is enabled, drive
> > disconnect based on vbus turning off instead of Rp disappearing on
> > CC pins. Rp disappearing on CC pins is almost instanteous compared
> > to vbus decay.
> >
> > Fixes: f321a02caebd ("usb: typec: tcpm: Implement enabling Auto
> > Discharge disconnect support")
> > Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
> > ---
> > Changes since V1:
> > - Add Fixes tag
> > ---
> >  drivers/usb/typec/tcpm/tcpm.c | 60 +++++++++++++++++++++++++++++++----
> >  1 file changed, 53 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
> > index be0b6469dd3d..0ed71725980f 100644
> > --- a/drivers/usb/typec/tcpm/tcpm.c
> > +++ b/drivers/usb/typec/tcpm/tcpm.c
> > @@ -62,6 +62,8 @@
> >       S(SNK_TRANSITION_SINK_VBUS),            \
> >       S(SNK_READY),                           \
> >                                               \
> > +     S(VBUS_DISCHARGE),                      \
> > +                                             \
> >       S(ACC_UNATTACHED),                      \
> >       S(DEBUG_ACC_ATTACHED),                  \
> >       S(AUDIO_ACC_ATTACHED),                  \
> > @@ -438,6 +440,9 @@ struct tcpm_port {
> >       enum tcpm_ams next_ams;
> >       bool in_ams;
> >
> > +     /* Auto vbus discharge state */
> > +     bool auto_vbus_discharge_enabled;
> > +
> >  #ifdef CONFIG_DEBUG_FS
> >       struct dentry *dentry;
> >       struct mutex logbuffer_lock;    /* log buffer access lock */
> > @@ -3413,6 +3418,8 @@ static int tcpm_src_attach(struct tcpm_port *port)
> >       if (port->tcpc->enable_auto_vbus_discharge) {
> >               ret = port->tcpc->enable_auto_vbus_discharge(port->tcpc, true);
> >               tcpm_log_force(port, "enable vbus discharge ret:%d", ret);
> > +             if (!ret)
> > +                     port->auto_vbus_discharge_enabled = true;
> >       }
> >
> >       ret = tcpm_set_roles(port, true, TYPEC_SOURCE, tcpm_data_role_for_source(port));
> > @@ -3495,6 +3502,8 @@ static void tcpm_reset_port(struct tcpm_port *port)
> >       if (port->tcpc->enable_auto_vbus_discharge) {
> >               ret = port->tcpc->enable_auto_vbus_discharge(port->tcpc, false);
> >               tcpm_log_force(port, "Disable vbus discharge ret:%d", ret);
> > +             if (!ret)
> > +                     port->auto_vbus_discharge_enabled = false;
> >       }
> >       port->in_ams = false;
> >       port->ams = NONE_AMS;
> > @@ -3568,6 +3577,8 @@ static int tcpm_snk_attach(struct tcpm_port *port)
> >               tcpm_set_auto_vbus_discharge_threshold(port, TYPEC_PWR_MODE_USB, false, VSAFE5V);
> >               ret = port->tcpc->enable_auto_vbus_discharge(port->tcpc, true);
> >               tcpm_log_force(port, "enable vbus discharge ret:%d", ret);
> > +             if (!ret)
> > +                     port->auto_vbus_discharge_enabled = true;
> >       }
> >
> >       ret = tcpm_set_roles(port, true, TYPEC_SINK, tcpm_data_role_for_sink(port));
> > @@ -3684,6 +3695,12 @@ static void run_state_machine(struct tcpm_port *port)
> >       switch (port->state) {
> >       case TOGGLING:
> >               break;
> > +     case VBUS_DISCHARGE:
> > +             if (port->port_type == TYPEC_PORT_SRC)
> > +                     tcpm_set_state(port, SRC_UNATTACHED, PD_T_SAFE_0V);
> > +             else
> > +                     tcpm_set_state(port, SNK_UNATTACHED, PD_T_SAFE_0V);
> > +             break;
> >       /* SRC states */
> >       case SRC_UNATTACHED:
> >               if (!port->non_pd_role_swap)
> > @@ -4669,7 +4686,9 @@ static void _tcpm_cc_change(struct tcpm_port *port, enum typec_cc_status cc1,
> >       case SRC_READY:
> >               if (tcpm_port_is_disconnected(port) ||
> >                   !tcpm_port_is_source(port)) {
> > -                     if (port->port_type == TYPEC_PORT_SRC)
> > +                     if (port->auto_vbus_discharge_enabled && !port->vbus_vsafe0v)
> > +                             tcpm_set_state(port, VBUS_DISCHARGE, 0);
> > +                     else if (port->port_type == TYPEC_PORT_SRC)
> >                               tcpm_set_state(port, SRC_UNATTACHED, 0);
> >                       else
> >                               tcpm_set_state(port, SNK_UNATTACHED, 0);
>
> Unless I am missing something, the new state is only used to set the
> PD_T_SAFE_0V timeout. Is it really necessary/useful to add a new state
> just for that, while keeping the rest of if/else statements ?
> Personally I would prefer something like
>                         timeout = (port->auto_vbus_discharge_enabled && !port->vbus_vsafe0v) ? PD_T_SAFE_0V : 0;
>                         if (port->port_type == TYPEC_PORT_SRC)
>                                 tcpm_set_state(port, SRC_UNATTACHED, timeout);
>                         else
>                                 tcpm_set_state(port, SNK_UNATTACHED, timeout);
>
Yes this should be OK as well. I was thinking  it would be more
clearer during debug if there
was a separate state altogether, but, looks like we should be fine.
Implementing/Validating it now. Will send a follow up version today.

> In this context, any idea why port_type==TYPEC_PORT_DRP results in
> SNK_UNATTACHED state ? That seems a bit odd.

This comes from the patch here:
https://lore.kernel.org/r/1582128343-22438-1-git-send-email-jun.li@nxp.com

Looks reasonable to me as tcpm_*_detach functions call  tcpm_detach so
teardown should
happen anyways.

static void tcpm_snk_detach(struct tcpm_port *port)
{
        tcpm_detach(port);
}


static void tcpm_src_detach(struct tcpm_port *port)
{
        tcpm_detach(port);
}

Thanks,
Badhri

>
> Guenter
>
> > @@ -4703,7 +4722,18 @@ static void _tcpm_cc_change(struct tcpm_port *port, enum typec_cc_status cc1,
> >                       tcpm_set_state(port, SNK_DEBOUNCED, 0);
> >               break;
> >       case SNK_READY:
> > -             if (tcpm_port_is_disconnected(port))
> > +             /*
> > +              * When set_auto_vbus_discharge_threshold is enabled, CC pins go
> > +              * away before vbus decays to disconnect threshold. Allow
> > +              * disconnect to be driven by vbus disconnect when auto vbus
> > +              * discharge is enabled.
> > +              *
> > +              * EXIT condition is based primarily on vbus disconnect and CC is secondary.
> > +              * "A port that has entered into USB PD communications with the Source and
> > +              * has seen the CC voltage exceed vRd-USB may monitor the CC pin to detect
> > +              * cable disconnect in addition to monitoring VBUS.
> > +              */
> > +             if (!port->auto_vbus_discharge_enabled && tcpm_port_is_disconnected(port))
> >                       tcpm_set_state(port, unattached_state(port), 0);
> >               else if (!port->pd_capable &&
> >                        (cc1 != old_cc1 || cc2 != old_cc2))
> > @@ -4803,9 +4833,16 @@ static void _tcpm_cc_change(struct tcpm_port *port, enum typec_cc_status cc1,
> >                */
> >               break;
> >
> > +     case VBUS_DISCHARGE:
> > +             /* Do nothing. Waiting for vsafe0v signal */
> > +             break;
> >       default:
> > -             if (tcpm_port_is_disconnected(port))
> > -                     tcpm_set_state(port, unattached_state(port), 0);
> > +             if (tcpm_port_is_disconnected(port)) {
> > +                     if (port->auto_vbus_discharge_enabled && !port->vbus_vsafe0v)
> > +                             tcpm_set_state(port, VBUS_DISCHARGE, 0);
> > +                     else
> > +                             tcpm_set_state(port, unattached_state(port), 0);
> > +             }
> >               break;
> >       }
> >  }
> > @@ -4988,9 +5025,12 @@ static void _tcpm_pd_vbus_off(struct tcpm_port *port)
> >               break;
> >
> >       default:
> > -             if (port->pwr_role == TYPEC_SINK &&
> > -                 port->attached)
> > -                     tcpm_set_state(port, SNK_UNATTACHED, 0);
> > +             if (port->pwr_role == TYPEC_SINK && port->attached) {
> > +                     if (port->auto_vbus_discharge_enabled && !port->vbus_vsafe0v)
> > +                             tcpm_set_state(port, VBUS_DISCHARGE, 0);
> > +                     else
> > +                             tcpm_set_state(port, SNK_UNATTACHED, 0);
> > +             }
> >               break;
> >       }
> >  }
> > @@ -5012,6 +5052,12 @@ static void _tcpm_pd_vbus_vsafe0v(struct tcpm_port *port)
> >                       tcpm_set_state(port, tcpm_try_snk(port) ? SNK_TRY : SRC_ATTACHED,
> >                                      PD_T_CC_DEBOUNCE);
> >               break;
> > +     case VBUS_DISCHARGE:
> > +             if (port->port_type == TYPEC_PORT_SRC)
> > +                     tcpm_set_state(port, SRC_UNATTACHED, 0);
> > +             else
> > +                     tcpm_set_state(port, SNK_UNATTACHED, 0);
> > +             break;
> >       default:
> >               break;
> >       }
> >
>
