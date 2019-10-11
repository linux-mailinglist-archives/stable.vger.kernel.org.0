Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5CDD4983
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 22:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbfJKUwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 16:52:18 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34486 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfJKUwS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 16:52:18 -0400
Received: by mail-lf1-f67.google.com with SMTP id r22so7965910lfm.1;
        Fri, 11 Oct 2019 13:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g7/73Rc0SKWAOwZoR7q0+hWJYXz555sJEfwUC/bv8II=;
        b=NOwHJfGGX76/mb9z7ZvBAt5mN+Brvb/Xtk/F0Ja6c4sBN69CNSgGQg0iJT4Z9z5x1v
         C0X8Wd9H7/wZ9RrIBeIr74t2GbayrJoX/pyDnBrJ2L5VkJy1oTLYHP8UJyn0He0M+pK2
         HmRyJbX653VgAAclfTJdJbQ88gPeLSrVLNK2D0F74BaMPrqeRB2HK8Oi+JUx8ruvdm7u
         6PHVTpaZh+9s26ZXn4P6/sKa0u7wxWCQYMySNwnVCURBV48Sz6TzEkpw5CHfUdeN5qYn
         eIhiYNwZm/2m4JHSCyrqikzZ6e//4fq01KpWXMDZMyw9qcmGMi7UH6FUIIzm/07XOc9s
         b58w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g7/73Rc0SKWAOwZoR7q0+hWJYXz555sJEfwUC/bv8II=;
        b=ehwChliZaBTylb60u2J1Oj0lRipwoT2ds25hjptPB8ixo15H1Nz1y6ZfBLFKyHFQVt
         Q0cnRSaAHjbApeP517PzdfjR4Lhrq1vQWITCQx0pMTJzUpSyxrpjPfkiaj6bFFxvjctf
         cn0Lx2P7b6WWmxILihvWh7IjaAvglTpgjfsMnpkVgjJk+AIHIFsMGriqfsY+LdAG2Lky
         Dp5dfz18eiXrHyzIIZSMErcIZzjYhaYiMSkD78BJpeAJhepuLjs63Wwb3gB7tHMPfqrW
         qRbkivukJQKUt+lKZbUD+W/mEQ7RthcLAE79MFV1IW7tYn5ZtE0Vhv61S5dpBzKUtch+
         h+Gw==
X-Gm-Message-State: APjAAAXHyqSQnw0iMLwtErx1sLzW+aLMuhfTh2O/90qw3msaQ2+4P+5z
        gNuqJIUyTrJcw0fpemPiM+1xTqFOzhrZ2GRBLn0tp9qSG2A=
X-Google-Smtp-Source: APXvYqymAjsNqmLluOTezA+tSFTFbOmRzVJZ10hwCZ1FA3rmcEOFoM1YoC7g/EoH64zCa/IIxm8eiaArxpN61yknMI0=
X-Received: by 2002:a19:fc0b:: with SMTP id a11mr9878797lfi.105.1570827133788;
 Fri, 11 Oct 2019 13:52:13 -0700 (PDT)
MIME-Version: 1.0
References: <20191007051240.4410-1-andrew.smirnov@gmail.com>
 <20191007051240.4410-2-andrew.smirnov@gmail.com> <CAO-hwJ+jPGa5Z7=Lopsc23m8UOqGWB0=tN+DcotykseAPM7_7w@mail.gmail.com>
 <20191011182617.GE229325@dtor-ws> <CAO-hwJLH6SMkLb1kZGj1E+BUHJ+ZsE1n+d=xeJgsvTCjHH1Wzw@mail.gmail.com>
In-Reply-To: <CAO-hwJLH6SMkLb1kZGj1E+BUHJ+ZsE1n+d=xeJgsvTCjHH1Wzw@mail.gmail.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Fri, 11 Oct 2019 13:52:02 -0700
Message-ID: <CAHQ1cqF3VkAwUAKhXZuQx3AuhcTFsBg0_fETiUADf7Uf+9b0rw@mail.gmail.com>
Subject: Re: [PATCH 1/3] HID: logitech-hidpp: use devres to manage FF private data
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Henrik Rydberg <rydberg@bitmath.org>,
        Sam Bazely <sambazley@fastmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        Austin Palmer <austinp@valvesoftware.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 11, 2019 at 12:26 PM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> On Fri, Oct 11, 2019 at 8:26 PM Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> >
> > On Fri, Oct 11, 2019 at 04:52:04PM +0200, Benjamin Tissoires wrote:
> > > Hi Andrey,
> > >
> > > On Mon, Oct 7, 2019 at 7:13 AM Andrey Smirnov <andrew.smirnov@gmail.com> wrote:
> > > >
> > > > To simplify resource management in commit that follows as well as to
> > > > save a couple of extra kfree()s and simplify hidpp_ff_deinit() switch
> > > > driver code to use devres to manage the life-cycle of FF private data.
> > > >
> > > > Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> > > > Cc: Jiri Kosina <jikos@kernel.org>
> > > > Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > > > Cc: Henrik Rydberg <rydberg@bitmath.org>
> > > > Cc: Sam Bazely <sambazley@fastmail.com>
> > > > Cc: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
> > > > Cc: Austin Palmer <austinp@valvesoftware.com>
> > > > Cc: linux-input@vger.kernel.org
> > > > Cc: linux-kernel@vger.kernel.org
> > > > Cc: stable@vger.kernel.org
> > >
> > > This patch doesn't seem to fix any error, is there a reason to send it
> > > to stable? (besides as a dependency of the rest of the series).
> > >
> > > > ---
> > > >  drivers/hid/hid-logitech-hidpp.c | 53 +++++++++++++++++---------------
> > > >  1 file changed, 29 insertions(+), 24 deletions(-)
> > > >
> > > > diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
> > > > index 0179f7ed77e5..58eb928224e5 100644
> > > > --- a/drivers/hid/hid-logitech-hidpp.c
> > > > +++ b/drivers/hid/hid-logitech-hidpp.c
> > > > @@ -2079,6 +2079,11 @@ static void hidpp_ff_destroy(struct ff_device *ff)
> > > >         struct hidpp_ff_private_data *data = ff->private;
> > > >
> > > >         kfree(data->effect_ids);
> > >
> > > Is there any reasons we can not also devm alloc data->effect_ids?
> > >
> > > > +       /*
> > > > +        * Set private to NULL to prevent input_ff_destroy() from
> > > > +        * freeing our devres allocated memory
> > >
> > > Ouch. There is something wrong here: input_ff_destroy() calls
> > > kfree(ff->private), when the data has not been allocated by
> > > input_ff_create(). This seems to lack a little bit of symmetry.
> >
> > Yeah, ff and ff-memless essentially take over the private data assigned
> > to them. They were done before devm and the lifetime of the "private"
> > data pieces was tied to the lifetime of the input device to simplify
> > error handling and teardown.
>
> Yeah, that stealing of the pointer is not good :)
> But OTOH, it helps
>
> >
> > Maybe we should clean it up a bit... I'm open to suggestions.
>
> The problem I had when doing the review was that there is no easy way
> to have a "devm_input_ff_create_()", because the way it's built is
> already "devres-compatible": the destroy gets called by input core.
>
> So I don't have a good answer to simplify in a transparent manner
> without breaking the API.
>
> >
> > In this case maybe best way is to get rid of hidpp_ff_destroy() and not
> > set ff->private and rely on devm to free the buffers. One can get to
> > device private data from ff methods via input_get_drvdata() since they
> > all (except destroy) are passed input device pointer.
>
> Sounds like a good idea. However, it seems there might be a race when
> removing the workqueue:
> the workqueue gets deleted in hidpp_remove, when the input node will
> be freed by devres, so after the call of hidpp_remove.
>
> So we should probably keep hidpp_ff_destroy() to clean up the ff bits,
> and instead move the content of hidpp_ff_deinit() into
> hidpp_ff_destroy() so we ensure proper ordering.
>
> Andrey, note that ensuring the workqueue gets freed after the call of
> input_destroy_device is something that should definitively go into
> stable as this is a potential race problem.

Sure, I'll add this to the series as a separate patch.

Thanks,
Andrey Smirnov
