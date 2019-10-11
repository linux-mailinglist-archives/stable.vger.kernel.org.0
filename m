Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26967D4956
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 22:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728894AbfJKUfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 16:35:14 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35527 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728889AbfJKUfO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 16:35:14 -0400
Received: by mail-pg1-f195.google.com with SMTP id p30so6438072pgl.2;
        Fri, 11 Oct 2019 13:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pw0y3BwMX+I09FeYhYWoZxZsMfpwQC+D3hPGpejxF9c=;
        b=mD3HMAfYqmZwwaPDcDzJ7S3GANPKaS5D/24iE/S8zvs6k05wi9ECuzfHa0LQgwIHX9
         yFc8dxU/I6b+wsT4e5igFuXC2w4Cfpthng9Ti5TO99l00xxjTFNsVv1ibnHKW5jJERbb
         u9Stn1gMQu1vFLLvEs8A2l+Kw9RPboezSgU5yTsmiWIWUj2Hd4pqcSljF7B6SmCUkr6K
         SO+LumDYZ7f7/9SVK51PVsU80s4sRuKSPd4KwARv9hZ7vcmvt3YyL2UzyElhTHbU7QbD
         V+WpIBlxHPLuwB28zabYXnjhjYjVvsg5iy5BNfl8GMM/SqPCYporY95HPS4WnzfXZxh8
         VulQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pw0y3BwMX+I09FeYhYWoZxZsMfpwQC+D3hPGpejxF9c=;
        b=YlOgexFHsZ5YFi69+q8dHRdqPscdRzkrc9ANefUZuVQtRQqC9/tVweLElC41Ltqero
         NHqQgydqMoT1FKKRDY9WeVRC1YOJxsNkdUHje/rzH4cfL74EVhHHnBVB279wK3xFpmyq
         5lV4pfB6u2oIjD5mUHpF0H9irjuAlKkOp2aoCM2JbJYYAoQK91rvF/NTopPwzACLtGYr
         90ggpGpQdy9CVBEWied61BVLGM6eY4XBymOQ3+Vz8HeLU06/WybY+94VkhLkz+V1AsFm
         uau8Kts1lMenhhV+rkOCKNIRJrB0nNMwUB2jKwRvvjfxouCMMrhKw/14CIdHLpwkQcLP
         0C8A==
X-Gm-Message-State: APjAAAW3jGJFmZHC6xbBMW//YgJMSS6ekzwIJa0eu95XK/kF9O3ykyMB
        qZ6mD8uezbeUQyX/orb4b0Y=
X-Google-Smtp-Source: APXvYqy7ogWKyhR5VgQoU7Lu3/It78efXlgAsGNKn1s2Ou2EJAjAvymDnrjQKlWHvgtnDwPPTDVXGQ==
X-Received: by 2002:a17:90a:8c92:: with SMTP id b18mr19422480pjo.136.1570826112806;
        Fri, 11 Oct 2019 13:35:12 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id h70sm9216625pgc.48.2019.10.11.13.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 13:35:11 -0700 (PDT)
Date:   Fri, 11 Oct 2019 13:35:09 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Henrik Rydberg <rydberg@bitmath.org>,
        Sam Bazely <sambazley@fastmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        Austin Palmer <austinp@valvesoftware.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/3] HID: logitech-hidpp: use devres to manage FF private
 data
Message-ID: <20191011203509.GG229325@dtor-ws>
References: <20191007051240.4410-1-andrew.smirnov@gmail.com>
 <20191007051240.4410-2-andrew.smirnov@gmail.com>
 <CAO-hwJ+jPGa5Z7=Lopsc23m8UOqGWB0=tN+DcotykseAPM7_7w@mail.gmail.com>
 <20191011182617.GE229325@dtor-ws>
 <CAO-hwJLH6SMkLb1kZGj1E+BUHJ+ZsE1n+d=xeJgsvTCjHH1Wzw@mail.gmail.com>
 <20191011203303.GF229325@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011203303.GF229325@dtor-ws>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 11, 2019 at 01:33:03PM -0700, Dmitry Torokhov wrote:
> On Fri, Oct 11, 2019 at 09:25:52PM +0200, Benjamin Tissoires wrote:
> > On Fri, Oct 11, 2019 at 8:26 PM Dmitry Torokhov
> > <dmitry.torokhov@gmail.com> wrote:
> > >
> > > On Fri, Oct 11, 2019 at 04:52:04PM +0200, Benjamin Tissoires wrote:
> > > > Hi Andrey,
> > > >
> > > > On Mon, Oct 7, 2019 at 7:13 AM Andrey Smirnov <andrew.smirnov@gmail.com> wrote:
> > > > >
> > > > > To simplify resource management in commit that follows as well as to
> > > > > save a couple of extra kfree()s and simplify hidpp_ff_deinit() switch
> > > > > driver code to use devres to manage the life-cycle of FF private data.
> > > > >
> > > > > Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> > > > > Cc: Jiri Kosina <jikos@kernel.org>
> > > > > Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > > > > Cc: Henrik Rydberg <rydberg@bitmath.org>
> > > > > Cc: Sam Bazely <sambazley@fastmail.com>
> > > > > Cc: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
> > > > > Cc: Austin Palmer <austinp@valvesoftware.com>
> > > > > Cc: linux-input@vger.kernel.org
> > > > > Cc: linux-kernel@vger.kernel.org
> > > > > Cc: stable@vger.kernel.org
> > > >
> > > > This patch doesn't seem to fix any error, is there a reason to send it
> > > > to stable? (besides as a dependency of the rest of the series).
> > > >
> > > > > ---
> > > > >  drivers/hid/hid-logitech-hidpp.c | 53 +++++++++++++++++---------------
> > > > >  1 file changed, 29 insertions(+), 24 deletions(-)
> > > > >
> > > > > diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
> > > > > index 0179f7ed77e5..58eb928224e5 100644
> > > > > --- a/drivers/hid/hid-logitech-hidpp.c
> > > > > +++ b/drivers/hid/hid-logitech-hidpp.c
> > > > > @@ -2079,6 +2079,11 @@ static void hidpp_ff_destroy(struct ff_device *ff)
> > > > >         struct hidpp_ff_private_data *data = ff->private;
> > > > >
> > > > >         kfree(data->effect_ids);
> > > >
> > > > Is there any reasons we can not also devm alloc data->effect_ids?
> > > >
> > > > > +       /*
> > > > > +        * Set private to NULL to prevent input_ff_destroy() from
> > > > > +        * freeing our devres allocated memory
> > > >
> > > > Ouch. There is something wrong here: input_ff_destroy() calls
> > > > kfree(ff->private), when the data has not been allocated by
> > > > input_ff_create(). This seems to lack a little bit of symmetry.
> > >
> > > Yeah, ff and ff-memless essentially take over the private data assigned
> > > to them. They were done before devm and the lifetime of the "private"
> > > data pieces was tied to the lifetime of the input device to simplify
> > > error handling and teardown.
> > 
> > Yeah, that stealing of the pointer is not good :)
> > But OTOH, it helps
> > 
> > >
> > > Maybe we should clean it up a bit... I'm open to suggestions.
> > 
> > The problem I had when doing the review was that there is no easy way
> > to have a "devm_input_ff_create_()", because the way it's built is
> > already "devres-compatible": the destroy gets called by input core.
> 
> I do not think we want devm_input_ff_create() explicitly, I think the
> fact that you can "build up" an input device by allocating it, then
> adding slots, poller, ff support, etc, and input core cleans it up is
> all good. It is just the ownership if the driver-private data block is
> not very obvious and is not compatible with allocating via devm.
> 
> > 
> > So I don't have a good answer to simplify in a transparent manner
> > without breaking the API.
> > 
> > >
> > > In this case maybe best way is to get rid of hidpp_ff_destroy() and not
> > > set ff->private and rely on devm to free the buffers. One can get to
> > > device private data from ff methods via input_get_drvdata() since they
> > > all (except destroy) are passed input device pointer.
> > 
> > Sounds like a good idea. However, it seems there might be a race when
> > removing the workqueue:
> > the workqueue gets deleted in hidpp_remove, when the input node will
> > be freed by devres, so after the call of hidpp_remove.
> 
> Yeah, well, that is a common issue with mixing devm and normal resources
> (and workqueue here is that "normal" resource), and we should either:
> 
> - not use devm
> - use devm_add_action_or_reset() to work in custom actions that work
>   freeing of non-managed resources into devm flow.

Actually, there is a door #3: use system workqueue. After all the work
that Tejun done on workqueues it is very rare that one actually needs
a dedicated workqueue (as works usually execute on one if the system
worker threads that are shared with other workqueues anyway).

-- 
Dmitry
