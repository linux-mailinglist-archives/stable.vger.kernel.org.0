Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D776D8F8C
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 08:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235467AbjDFGg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 02:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234379AbjDFGgZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 02:36:25 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7DA8A68
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 23:36:24 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id o2so36669565plg.4
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 23:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680762984;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MR2uGYHr2XQbgshfGo1SsPwfCbCQRjTFchS5WzXQOLA=;
        b=H/HUkMo7yH5xEcRprfpCq1CqZA9KAccmnFbceZgLqgyQbLuPaUxBeXB0a3xrn/shNg
         2I8HZivgJ5n3vx6lPdOAXC4SLALjyH0VJ7cR4zsqyaTsLuktp7g4r0YoyDhbse9dZ3X8
         Kxg8L3kCd2Z1suUT/NgCi/Xhi7U6lp1sfnvo0cR2UX6X2nm4DpYGUb+P+II+sbQ0UlLO
         XSXIOjBQlnRDgD71KZrIBcky4EjfA4n5BSZkt8c9ko9/KuUTdPRq9QGdMZx28PcCYId8
         euEPhMgFvwTq3085sGkFmQnpnl9NQgvXQU5efE3J0AvEvPZcm8lFUmGVJHEXWJq9bSRQ
         V6tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680762984;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MR2uGYHr2XQbgshfGo1SsPwfCbCQRjTFchS5WzXQOLA=;
        b=4RdkOlJz3g25aukStAAwGMgZ1P9sscLXti06gllI47D9iLvrPEfa5hmzdgLDML+wIv
         MHiSHR9rsMdfkXCspL+EfWrpUXiMSV9hh+lke9ijtyOGnjCATv5nQLT1Oxszt5oUmZ8g
         FXSohDP4y81f9XQi/jfCf1JlJmMxfl7o/GqNnXAyIQ0A8lQfIgTyzzkPATBENbazoL4N
         ZezIINYU33fj9quoRCgBlQ7xdPpv0LFT8JJkMH+fpTYPiIR+BF2xgmvk9r667EYdttgQ
         LSzESSaeRbgPkwE93yMEzdRqzmtKAI8TIVv/5l04wqRNruCj08w0QTEGp/okjLdSwmoS
         g4vQ==
X-Gm-Message-State: AAQBX9fMtYPwNt2yt5j6fjyMKquBtnFO1hKzhi4BK/O3K13YSwo6CXlA
        9KHZk6VKvUGakfT4xHR7ye5YzED6px0kofD/m1qGRw==
X-Google-Smtp-Source: AKy350aPiL+zgLH4gl35YK6hGGynFK4yB18/TWgTYP+MlgMHiKYq5bgjFyNA1/UaczkXb0Y4XiIwg3ElKi2TTWDCzqM=
X-Received: by 2002:a17:902:b693:b0:1a1:8f72:e9b with SMTP id
 c19-20020a170902b69300b001a18f720e9bmr3407891pls.7.1680762983590; Wed, 05 Apr
 2023 23:36:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230405093133.1858140-1-badhri@google.com> <20230405093133.1858140-2-badhri@google.com>
 <2023040520-corned-recluse-d191@gregkh>
In-Reply-To: <2023040520-corned-recluse-d191@gregkh>
From:   Badhri Jagan Sridharan <badhri@google.com>
Date:   Wed, 5 Apr 2023 23:35:47 -0700
Message-ID: <CAPTae5KoAP6E5ReVX4auco6ctS0jLAhNmknTosJvWvhcp4GO7g@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] usb: gadget: udc: core: Prevent redundant calls to pullup
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stern@rowland.harvard.edu, colin.i.king@gmail.com,
        xuetao09@huawei.com, quic_eserrao@quicinc.com,
        water.zhangjiantao@huawei.com, peter.chen@freescale.com,
        balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 5, 2023 at 10:16=E2=80=AFAM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Wed, Apr 05, 2023 at 09:31:33AM +0000, Badhri Jagan Sridharan wrote:
> > usb_gadget_connect calls gadget->ops->pullup without
> > checking whether gadget->connected was previously set.
> > Make this symmetric to usb_gadget_disconnect by returning
> > early if gadget->connected is already set.
> >
> > Cc: stable@vger.kernel.org
> >
> > Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
> > Fixes: 5a1da544e572 ("usb: gadget: core: do not try to disconnect gadge=
t if it is not connected")
>
> Same changelog comment as before.
Thanks for the feedback Greg ! Have fixed it in v2.

>
> > ---
> >  drivers/usb/gadget/udc/core.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/cor=
e.c
> > index 890f92cb6344..7eeaf7dbb350 100644
> > --- a/drivers/usb/gadget/udc/core.c
> > +++ b/drivers/usb/gadget/udc/core.c
> > @@ -708,6 +708,9 @@ int usb_gadget_connect(struct usb_gadget *gadget)
> >               goto out;
> >       }
> >
> > +     if (gadget->connected)
> > +             goto out;
> > +
>
> What prevents this connected value from changing right after you check
> this?

Nothing in V1 :) However, in v2, the newly introduced mutex guards
gadget->connected
as well.

>
> thanks,
>
> greg k-h
