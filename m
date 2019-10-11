Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF0D6D49B1
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 23:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfJKVLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 17:11:12 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40949 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbfJKVLM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 17:11:12 -0400
Received: by mail-pg1-f193.google.com with SMTP id d26so6474642pgl.7;
        Fri, 11 Oct 2019 14:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=N/BP0N83P9W6C5BiVurtFofWl2LpQAdIEXVffsFrPG0=;
        b=Jvz7fllxnUivk7XuysEKzxZ5YTNQ6Rnby5iUz7DXYwFlPT6t8pI+emQddFG4LRBNnc
         pnVEH1H3VuiSfm/7J6A3Zp2oQ2A4ww6HCks47rmzHy3zRvksVR6xORwoOdQJLWV6Ctxi
         Mmbzm0RbXTDCXGz+0lfNumxIlxQF1pW+kAppSh2DYjLUtP+wLZRtdnKGLvBsHElZI4QD
         tpRQxJWoTjK7SsLHIOovlvYs8Bhw9lk08k0oxa/DtvazlexivTycGwK7wHFwZA7ziNrO
         LzgxBxBXJ5qN/O6VNVOZuy+RqrCx6tfpPiLTtIQpHMLtnDTuow6ycqhk5oT3ccyCO202
         CfJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=N/BP0N83P9W6C5BiVurtFofWl2LpQAdIEXVffsFrPG0=;
        b=Wqsh5VcsHe/vA8gbVYxMN7K2oZZjjRgq9dd/Rh84aHK1+ioRG/4UVAH6juCvobYEYM
         3XP++LIyelTeomsQ4szlYhBgiIjUb1sM+UegBzfy/ynFWURUnZfdmRJ6OLTzeMVkkQjR
         0uHFMn3ScgpEv0mKA64n5pSgUaChSxtgW1l4Mch7zV/ZljhuxGLM08uK8bB1fGLyusNN
         cTjF6a1CHROuUV517TFG8Fp0FZXQyVyMEIHSCrB2e3482XTsFBgnK8ZuHxqxQyg7YIdG
         qvNJd7yqqMdPQ/d9S18fBd5U9By96sZNg8pOl8YdntaXiHQ/pTVVBOLaIhMnyUTWWOp8
         SG6Q==
X-Gm-Message-State: APjAAAUAPFbFNjt8dR5vJYwuNE7Q9732Jmvpvni2erqbjtLitAdAuGPv
        /8AKaBhdq1nCPK4GaH8Rvy8=
X-Google-Smtp-Source: APXvYqzhv6flsAhpHdwLEGMmVOZFh1tfFN/F71S9nwRpqxPCPj1PaB+NyIbIpTED4qh8clbYcS8Hcg==
X-Received: by 2002:a17:90a:8a04:: with SMTP id w4mr18356273pjn.135.1570828271058;
        Fri, 11 Oct 2019 14:11:11 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id e6sm12873050pfl.146.2019.10.11.14.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 14:11:10 -0700 (PDT)
Date:   Fri, 11 Oct 2019 14:11:08 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
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
Message-ID: <20191011211108.GI229325@dtor-ws>
References: <20191007051240.4410-1-andrew.smirnov@gmail.com>
 <20191007051240.4410-2-andrew.smirnov@gmail.com>
 <CAO-hwJ+jPGa5Z7=Lopsc23m8UOqGWB0=tN+DcotykseAPM7_7w@mail.gmail.com>
 <20191011182617.GE229325@dtor-ws>
 <CAO-hwJLH6SMkLb1kZGj1E+BUHJ+ZsE1n+d=xeJgsvTCjHH1Wzw@mail.gmail.com>
 <20191011203303.GF229325@dtor-ws>
 <CAHQ1cqFc-7BpgZuinLakHAjT=6XNzcsQE=RFHOw2xu4Gqdpeog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHQ1cqFc-7BpgZuinLakHAjT=6XNzcsQE=RFHOw2xu4Gqdpeog@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 11, 2019 at 02:02:30PM -0700, Andrey Smirnov wrote:
> On Fri, Oct 11, 2019 at 1:33 PM Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> >
> > On Fri, Oct 11, 2019 at 09:25:52PM +0200, Benjamin Tissoires wrote:
> > > On Fri, Oct 11, 2019 at 8:26 PM Dmitry Torokhov
> > > <dmitry.torokhov@gmail.com> wrote:
> > > >
> > > > On Fri, Oct 11, 2019 at 04:52:04PM +0200, Benjamin Tissoires wrote:
> > > > > Hi Andrey,
> > > > >
> > > > > On Mon, Oct 7, 2019 at 7:13 AM Andrey Smirnov <andrew.smirnov@gmail.com> wrote:
> > > > > >
> > > > > > To simplify resource management in commit that follows as well as to
> > > > > > save a couple of extra kfree()s and simplify hidpp_ff_deinit() switch
> > > > > > driver code to use devres to manage the life-cycle of FF private data.
> > > > > >
> > > > > > Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> > > > > > Cc: Jiri Kosina <jikos@kernel.org>
> > > > > > Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > > > > > Cc: Henrik Rydberg <rydberg@bitmath.org>
> > > > > > Cc: Sam Bazely <sambazley@fastmail.com>
> > > > > > Cc: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
> > > > > > Cc: Austin Palmer <austinp@valvesoftware.com>
> > > > > > Cc: linux-input@vger.kernel.org
> > > > > > Cc: linux-kernel@vger.kernel.org
> > > > > > Cc: stable@vger.kernel.org
> > > > >
> > > > > This patch doesn't seem to fix any error, is there a reason to send it
> > > > > to stable? (besides as a dependency of the rest of the series).
> > > > >
> > > > > > ---
> > > > > >  drivers/hid/hid-logitech-hidpp.c | 53 +++++++++++++++++---------------
> > > > > >  1 file changed, 29 insertions(+), 24 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
> > > > > > index 0179f7ed77e5..58eb928224e5 100644
> > > > > > --- a/drivers/hid/hid-logitech-hidpp.c
> > > > > > +++ b/drivers/hid/hid-logitech-hidpp.c
> > > > > > @@ -2079,6 +2079,11 @@ static void hidpp_ff_destroy(struct ff_device *ff)
> > > > > >         struct hidpp_ff_private_data *data = ff->private;
> > > > > >
> > > > > >         kfree(data->effect_ids);
> > > > >
> > > > > Is there any reasons we can not also devm alloc data->effect_ids?
> > > > >
> > > > > > +       /*
> > > > > > +        * Set private to NULL to prevent input_ff_destroy() from
> > > > > > +        * freeing our devres allocated memory
> > > > >
> > > > > Ouch. There is something wrong here: input_ff_destroy() calls
> > > > > kfree(ff->private), when the data has not been allocated by
> > > > > input_ff_create(). This seems to lack a little bit of symmetry.
> > > >
> > > > Yeah, ff and ff-memless essentially take over the private data assigned
> > > > to them. They were done before devm and the lifetime of the "private"
> > > > data pieces was tied to the lifetime of the input device to simplify
> > > > error handling and teardown.
> > >
> > > Yeah, that stealing of the pointer is not good :)
> > > But OTOH, it helps
> > >
> > > >
> > > > Maybe we should clean it up a bit... I'm open to suggestions.
> > >
> > > The problem I had when doing the review was that there is no easy way
> > > to have a "devm_input_ff_create_()", because the way it's built is
> > > already "devres-compatible": the destroy gets called by input core.
> >
> > I do not think we want devm_input_ff_create() explicitly, I think the
> > fact that you can "build up" an input device by allocating it, then
> > adding slots, poller, ff support, etc, and input core cleans it up is
> > all good. It is just the ownership if the driver-private data block is
> > not very obvious and is not compatible with allocating via devm.
> >
> 
> What do you think of creating input_ff_create_with_private() which
> would take a pointer to private memory and set a new
> "borrowed_private" flag in struct ff_device which input_ff_destroy()
> can check to determine if it needs to free ->private or not?

From my quick check we only have 3 users of ff->private in the tree:

dtor@dtor-ws:~/kernel/master (next)$ git grep -l "[^a-z]ff\->private" -- drivers/
drivers/hid/hid-logitech-hidpp.c
drivers/hid/usbhid/hid-pidff.c
drivers/input/ff-core.c
drivers/input/ff-memless.c

and I really wonder if we actually need to have this pointer and
maintain it, given that logitech driver appears to not needing it that
much...

Thanks.

-- 
Dmitry
