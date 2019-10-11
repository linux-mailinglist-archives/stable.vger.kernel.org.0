Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A0DD4865
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 21:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbfJKT0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 15:26:07 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:49690 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728963AbfJKT0H (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 15:26:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570821965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cpiu7s7hf2nZP0WQJjeZFG1TgT08vZqZIEI3ha/hazE=;
        b=C1fId8FIlXbEHv1L+7W+bkoE0V0nu5bYzCkSrAvt9ZqNmqXLT9FUp4qRGFPmup68g6+tzO
        +inbSet0+lmmxGfgmrPZSIerf3M2sxCficpIctj3adW8UWdHUwoyUHKstGU6ATbzKYg5pn
        HjMDxYZbBbUNB3KiPVL8uuENukJODWc=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-UpWGJPTZN0qoN9TjJKn3DA-1; Fri, 11 Oct 2019 15:26:03 -0400
Received: by mail-qk1-f199.google.com with SMTP id s14so9939913qkg.12
        for <stable@vger.kernel.org>; Fri, 11 Oct 2019 12:26:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vm9hCEgalMjdO3brVzGiAiZDpN4MX984R0GN6bPTIZw=;
        b=nljXXB0LJHkk6NxFR71zyJFOUL64atJWa1IuQpj3qMGWeL9Yfszheiz9nA+3rbG7Uc
         XWQaRRfEFzHlHhy++yy+ug0jVI/63zK4c78Ax80NlWuX2BIdEbPxDQ8scHOjBnv6aJOl
         PhkAOFpymNPqAQ4cYCCiETKPasMvlgMzZxvpD5iEiIxhLxfUBcNww2yMetMJgjYMDT9Z
         yMOtgOTuD8Yzy/YWbWCfxYtXKe+pBhO5ny7JsuAQCvm94HRVK8jDI3DHaR59Kr8vSzCY
         8RKeTvJTmRih4tauGOggbYh/A/kzueKavMbK6RR1OPWpkJXfIw5+lzxHbnlfcdFnabCi
         WFYA==
X-Gm-Message-State: APjAAAWg99MoQKmPXz0BjuOhIKH+dLkFc6ItjqWSiYi315WKYVio1y5V
        0f26dputCXwAjScFnchn4fPV8JLaumLQcCPEbEfAhMLxGkUEAIen4cQmwTPC3NDBxHdqfgNQsMw
        /E1hpIxO1efICAe/WVzvLDu3bCI0GhxHM
X-Received: by 2002:a37:50a:: with SMTP id 10mr16739704qkf.27.1570821963350;
        Fri, 11 Oct 2019 12:26:03 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx05uDRWS0FZ6McnRw0wvRkHDnrcgb/JBgJnFKj/FIi/+KaVzrBJ5aRpM86Ax1WNWr/Vjw1XePH4a8Ny4dxnhM=
X-Received: by 2002:a37:50a:: with SMTP id 10mr16739692qkf.27.1570821963111;
 Fri, 11 Oct 2019 12:26:03 -0700 (PDT)
MIME-Version: 1.0
References: <20191007051240.4410-1-andrew.smirnov@gmail.com>
 <20191007051240.4410-2-andrew.smirnov@gmail.com> <CAO-hwJ+jPGa5Z7=Lopsc23m8UOqGWB0=tN+DcotykseAPM7_7w@mail.gmail.com>
 <20191011182617.GE229325@dtor-ws>
In-Reply-To: <20191011182617.GE229325@dtor-ws>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Fri, 11 Oct 2019 21:25:52 +0200
Message-ID: <CAO-hwJLH6SMkLb1kZGj1E+BUHJ+ZsE1n+d=xeJgsvTCjHH1Wzw@mail.gmail.com>
Subject: Re: [PATCH 1/3] HID: logitech-hidpp: use devres to manage FF private data
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Henrik Rydberg <rydberg@bitmath.org>,
        Sam Bazely <sambazley@fastmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        Austin Palmer <austinp@valvesoftware.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>
X-MC-Unique: UpWGJPTZN0qoN9TjJKn3DA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 11, 2019 at 8:26 PM Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
> On Fri, Oct 11, 2019 at 04:52:04PM +0200, Benjamin Tissoires wrote:
> > Hi Andrey,
> >
> > On Mon, Oct 7, 2019 at 7:13 AM Andrey Smirnov <andrew.smirnov@gmail.com=
> wrote:
> > >
> > > To simplify resource management in commit that follows as well as to
> > > save a couple of extra kfree()s and simplify hidpp_ff_deinit() switch
> > > driver code to use devres to manage the life-cycle of FF private data=
.
> > >
> > > Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> > > Cc: Jiri Kosina <jikos@kernel.org>
> > > Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > > Cc: Henrik Rydberg <rydberg@bitmath.org>
> > > Cc: Sam Bazely <sambazley@fastmail.com>
> > > Cc: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
> > > Cc: Austin Palmer <austinp@valvesoftware.com>
> > > Cc: linux-input@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > Cc: stable@vger.kernel.org
> >
> > This patch doesn't seem to fix any error, is there a reason to send it
> > to stable? (besides as a dependency of the rest of the series).
> >
> > > ---
> > >  drivers/hid/hid-logitech-hidpp.c | 53 +++++++++++++++++-------------=
--
> > >  1 file changed, 29 insertions(+), 24 deletions(-)
> > >
> > > diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logit=
ech-hidpp.c
> > > index 0179f7ed77e5..58eb928224e5 100644
> > > --- a/drivers/hid/hid-logitech-hidpp.c
> > > +++ b/drivers/hid/hid-logitech-hidpp.c
> > > @@ -2079,6 +2079,11 @@ static void hidpp_ff_destroy(struct ff_device =
*ff)
> > >         struct hidpp_ff_private_data *data =3D ff->private;
> > >
> > >         kfree(data->effect_ids);
> >
> > Is there any reasons we can not also devm alloc data->effect_ids?
> >
> > > +       /*
> > > +        * Set private to NULL to prevent input_ff_destroy() from
> > > +        * freeing our devres allocated memory
> >
> > Ouch. There is something wrong here: input_ff_destroy() calls
> > kfree(ff->private), when the data has not been allocated by
> > input_ff_create(). This seems to lack a little bit of symmetry.
>
> Yeah, ff and ff-memless essentially take over the private data assigned
> to them. They were done before devm and the lifetime of the "private"
> data pieces was tied to the lifetime of the input device to simplify
> error handling and teardown.

Yeah, that stealing of the pointer is not good :)
But OTOH, it helps

>
> Maybe we should clean it up a bit... I'm open to suggestions.

The problem I had when doing the review was that there is no easy way
to have a "devm_input_ff_create_()", because the way it's built is
already "devres-compatible": the destroy gets called by input core.

So I don't have a good answer to simplify in a transparent manner
without breaking the API.

>
> In this case maybe best way is to get rid of hidpp_ff_destroy() and not
> set ff->private and rely on devm to free the buffers. One can get to
> device private data from ff methods via input_get_drvdata() since they
> all (except destroy) are passed input device pointer.

Sounds like a good idea. However, it seems there might be a race when
removing the workqueue:
the workqueue gets deleted in hidpp_remove, when the input node will
be freed by devres, so after the call of hidpp_remove.

So we should probably keep hidpp_ff_destroy() to clean up the ff bits,
and instead move the content of hidpp_ff_deinit() into
hidpp_ff_destroy() so we ensure proper ordering.

Andrey, note that ensuring the workqueue gets freed after the call of
input_destroy_device is something that should definitively go into
stable as this is a potential race problem.

Cheers,
Benjamin

