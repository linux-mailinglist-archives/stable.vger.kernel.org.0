Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4EA86A6A10
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 10:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjCAJvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 04:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjCAJvq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 04:51:46 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7181D367D2
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 01:51:44 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id ay29-20020a05600c1e1d00b003e9f4c2b623so11379463wmb.3
        for <stable@vger.kernel.org>; Wed, 01 Mar 2023 01:51:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1677664303;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oW952k94eHwop+SfxK3L89foJizL9YBwkHTpjecyhpQ=;
        b=c4Rqu+eEkqy9Bl9PK9NHWqhQM2aSjUazWO5I8r6qS3LnGphqIrK93oqz9lyNQ27G7V
         T1WseVDSNP0GRFUl2xdo8sYfnXn4/YC2jH5Eaw5ngZZCLU7NhBWrwIKuTaNDxnaxq0ad
         PkfsGNHgISOPQOhVYr1FuWm6Ytymv6ZNNgZKCOQJ6bs/opsSvBHLR96p3MsriopmNoBT
         ANNgEOjkeDgsnLmmygrdzJb4fAM8Y025YkwHOk+jtP6LHJxf5c+ggAMhwCkaH4mEjKDh
         jjVhqLXLOUxPUGCyEZFG6+KeaRzU1p9q4ttIrS5+BwPQk64tPDzA7T96Qvs8JsVUGDpy
         ACLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677664303;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oW952k94eHwop+SfxK3L89foJizL9YBwkHTpjecyhpQ=;
        b=s0UlVxtxi0XCTl9aEDIOF8DjQDmrHxZFc/OCPYB8Il7DL9d17oNu3MrkYnjiLButVm
         udJng3HoCpBlrNrkWRFpe8hgcs6A00SN9fswyg4q5F29fN6CNcn+QH1wERQp1OGW+6wE
         xIBl2RpgVLJc/5GAXXfiJofebta5u9xKMkArdK/O4xGcM5pEb9M4q9pezF4Cgggpgfl4
         /54p12QCgCbEAkcZPuR4upXki+C5V52qbHEIXP4sHg9Uwkf8rQCjgHZeCmvwg1ZtmZAw
         GEzzB0YTlAfbP7y0letf4+42+RP5TGDlvptOKl7wxVFX3SJ1+MYidLq9dPt4aU3MmEfg
         TBKg==
X-Gm-Message-State: AO0yUKWzSxuYc0dgpvrLQIZ4cuWPhP4A8LHN8JrAyOXoBjz8OE4bXhcX
        yKBbpiElQWtEXECNraLDe2qMy8ra5a/dksQI1zwYSg==
X-Google-Smtp-Source: AK7set9MhUdTEyc+dfnzsEI00l6Qw7dbEOemGYM/wpEvVNGSGKPx5Hg1YC+yfNIMhGPjox/6alGzPW2Lrcq4MTO2+iE=
X-Received: by 2002:a05:600c:1f06:b0:3eb:3e75:5daf with SMTP id
 bd6-20020a05600c1f0600b003eb3e755dafmr3811676wmb.2.1677664302839; Wed, 01 Mar
 2023 01:51:42 -0800 (PST)
MIME-Version: 1.0
References: <20230301075751.43839-1-lma@semihalf.com> <Y/8PUdEwskXuWZHA@kroah.com>
In-Reply-To: <Y/8PUdEwskXuWZHA@kroah.com>
From:   Lukasz Majczak <lma@semihalf.com>
Date:   Wed, 1 Mar 2023 10:51:31 +0100
Message-ID: <CAFJ_xbp+qD-_MGd3+SgBY=8zruZNy7k3CO3OMMmWhMGhA-tARQ@mail.gmail.com>
Subject: Re: [PATCH] serial: core: fix broken console after suspend
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Guenter Roeck <groeck@chromium.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        upstream@semihalf.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=C5=9Br., 1 mar 2023 o 09:39 Greg Kroah-Hartman
<gregkh@linuxfoundation.org> napisa=C5=82(a):
>
> On Wed, Mar 01, 2023 at 08:57:51AM +0100, Lukasz Majczak wrote:
> > Re-enable the console device after suspending, causes its cflags,
> > ispeed and ospeed to be set anew, basing on the values stored in
> > uport->cons. The issue is that these values are set only once,
> > when parsing console parameters after boot (see uart_set_options()),
> > next after configuring a port in uart_port_startup() these parameteres
> > (cflags, ispeed and ospeed) are copied to termios structure and
> > the orginal one (stored in uport->cons) are cleared, but there is no pl=
ace
> > in code where those fields are checked against 0.
> > When kernel calls uart_resume_port() and setups console, it copies cfla=
gs,
> > ispeed and ospeed values from uart->cons,but those are alread cleared.
> > The efect is that console is broken.
> > This patch address this by preserving the cflags, ispeed and
> > ospeed fields in uart->cons during uart_port_startup().
> >
> > Signed-off-by: Lukasz Majczak <lma@semihalf.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/tty/serial/serial_core.c | 3 ---
> >  1 file changed, 3 deletions(-)
> >
> > diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/seri=
al_core.c
> > index 2bd32c8ece39..394a05c09d87 100644
> > --- a/drivers/tty/serial/serial_core.c
> > +++ b/drivers/tty/serial/serial_core.c
> > @@ -225,9 +225,6 @@ static int uart_port_startup(struct tty_struct *tty=
, struct uart_state *state,
> >                       tty->termios.c_cflag =3D uport->cons->cflag;
> >                       tty->termios.c_ispeed =3D uport->cons->ispeed;
> >                       tty->termios.c_ospeed =3D uport->cons->ospeed;
> > -                     uport->cons->cflag =3D 0;
> > -                     uport->cons->ispeed =3D 0;
> > -                     uport->cons->ospeed =3D 0;
> >               }
> >               /*
> >                * Initialise the hardware port settings.
> > --
> > 2.39.2.722.g9855ee24e9-goog
> >
>
> What commit id does this fix?
>
> thanks,
>
> greg k-h
Hi Greg,

There are actually two commits that introduce problematic uport flags
clearing in uart_startup (for the sake of simplicity I'd ignore the
older history):
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
h=3Dv6.2&id=3Dc7d7abff40c27f82fe78b1091ab3fad69b2546f9
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
h=3Dv6.2&id=3D027b57170bf8bb6999a28e4a5f3d78bf1db0f90c
It's 10 years between those 2 and to me it was hard to decide about
picking a proper one for the `Fixes:` tag.
How would you recommend to proceed wrt applying this patch on the
stable releases?

Best regards,
Lukasz
