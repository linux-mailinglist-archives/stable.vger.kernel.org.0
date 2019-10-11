Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC558D4AEB
	for <lists+stable@lfdr.de>; Sat, 12 Oct 2019 01:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfJKXX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 19:23:59 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40849 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726243AbfJKXX7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 19:23:59 -0400
Received: by mail-pf1-f193.google.com with SMTP id x127so6940751pfb.7;
        Fri, 11 Oct 2019 16:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YG3xxIsBaIujnkalk/Sset2YYGk0nugkLR8dSYrFUuw=;
        b=Q0+7i2dZuuAKbnCPAOtyEnUXkef8+nsQqlHomu00INDIOv0/FruF2qxwt4KOEn9tRo
         C5fGeFr1w0kS8w7ql7jC+AcTQBTRy3rwqAl3D2oGPr7FDOAXk3CMGD7k4/INX/8Dc3JD
         rmcsia1XeM/SRUt4uvY0GHFEGBpUXd1/SqU2vY58rXlBZuF6ZtZ5GyJl9ACleITFbq8u
         gLSAJsAX7b2DrXa2F/L3PnxEOJ4L3WO/71g93cBmsLAGllrpewfykDrUvHA8B/fRl5wN
         zgC8bJeCZWLFDSnqiPli9Pj3Vi/7/FtN4aickWbSGm8n61KwiS8eMf9m+pcfT7YU4EJt
         PCJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YG3xxIsBaIujnkalk/Sset2YYGk0nugkLR8dSYrFUuw=;
        b=qo6Sd7+b/wOK9JcvE1oDffL1ByW5qW4ojMVocNWiJ1Z9einrkoubtp7HwwCcYy0BWB
         wwF7CDt1QP55u+BD8x1+5R6FKe6bKpCrY5wu81Ee6N1HESUd9L+Cp8CiFrw/7CzzNWmF
         HGrH7TT8YGLdhxR8deIr6Y02Wc9HOyLgen11lckwA9v7MIb6XdKOySBoDHms3hcKUS6d
         xRIrgwl09DhxGncdpZBC+wzlWsGpdozFT/cHf4wQhdloZyXUWrKL3LMaTJpd/RW6PAMT
         uu3KVqweI4R8Mds/xrfb28UIiBj4C+I+ZoeRm3pFkGIdYf7mT4EREyUfigiU2yRejJsP
         8VqQ==
X-Gm-Message-State: APjAAAU0Odp+G/dcU3ZAyQlkAS+jzMjfS1yN4EMgZkoKs4ChArhDQXBZ
        FEtj0W6UEiqfpeQnXtwvRg8=
X-Google-Smtp-Source: APXvYqzFCY0EkEpipX/ByVFLBbWkohEwlNHN4PUfxFDDOnA00hAOhk0fxNPTrkLV6pYkj7LqHtrJHA==
X-Received: by 2002:aa7:93de:: with SMTP id y30mr19926209pff.27.1570836238213;
        Fri, 11 Oct 2019 16:23:58 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id z3sm11808320pjd.25.2019.10.11.16.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 16:23:57 -0700 (PDT)
Date:   Fri, 11 Oct 2019 16:23:54 -0700
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
Message-ID: <20191011232354.GK229325@dtor-ws>
References: <20191007051240.4410-1-andrew.smirnov@gmail.com>
 <20191007051240.4410-2-andrew.smirnov@gmail.com>
 <CAO-hwJ+jPGa5Z7=Lopsc23m8UOqGWB0=tN+DcotykseAPM7_7w@mail.gmail.com>
 <20191011182617.GE229325@dtor-ws>
 <CAO-hwJLH6SMkLb1kZGj1E+BUHJ+ZsE1n+d=xeJgsvTCjHH1Wzw@mail.gmail.com>
 <20191011203303.GF229325@dtor-ws>
 <20191011203509.GG229325@dtor-ws>
 <20191011213349.GJ229325@dtor-ws>
 <CAO-hwJ+mMco-gw4Wt=cCAb5v1XymTiS2HNtzQqtmqMoRCiuueQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO-hwJ+mMco-gw4Wt=cCAb5v1XymTiS2HNtzQqtmqMoRCiuueQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 12, 2019 at 12:48:42AM +0200, Benjamin Tissoires wrote:
> On Fri, Oct 11, 2019 at 11:34 PM Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> >
> > On Fri, Oct 11, 2019 at 01:35:09PM -0700, Dmitry Torokhov wrote:
> > > On Fri, Oct 11, 2019 at 01:33:03PM -0700, Dmitry Torokhov wrote:
> > > > On Fri, Oct 11, 2019 at 09:25:52PM +0200, Benjamin Tissoires wrote:
> > > > > On Fri, Oct 11, 2019 at 8:26 PM Dmitry Torokhov
> > > > > <dmitry.torokhov@gmail.com> wrote:
> > > > > >
> > > > > > On Fri, Oct 11, 2019 at 04:52:04PM +0200, Benjamin Tissoires wrote:
> > > > > > > Hi Andrey,
> > > > > > >
> > > > > > > On Mon, Oct 7, 2019 at 7:13 AM Andrey Smirnov <andrew.smirnov@gmail.com> wrote:
> > > > > > > >
> > > > > > > > To simplify resource management in commit that follows as well as to
> > > > > > > > save a couple of extra kfree()s and simplify hidpp_ff_deinit() switch
> > > > > > > > driver code to use devres to manage the life-cycle of FF private data.
> > > > > > > >
> > > > > > > > Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> > > > > > > > Cc: Jiri Kosina <jikos@kernel.org>
> > > > > > > > Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > > > > > > > Cc: Henrik Rydberg <rydberg@bitmath.org>
> > > > > > > > Cc: Sam Bazely <sambazley@fastmail.com>
> > > > > > > > Cc: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
> > > > > > > > Cc: Austin Palmer <austinp@valvesoftware.com>
> > > > > > > > Cc: linux-input@vger.kernel.org
> > > > > > > > Cc: linux-kernel@vger.kernel.org
> > > > > > > > Cc: stable@vger.kernel.org
> > > > > > >
> > > > > > > This patch doesn't seem to fix any error, is there a reason to send it
> > > > > > > to stable? (besides as a dependency of the rest of the series).
> > > > > > >
> > > > > > > > ---
> > > > > > > >  drivers/hid/hid-logitech-hidpp.c | 53 +++++++++++++++++---------------
> > > > > > > >  1 file changed, 29 insertions(+), 24 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
> > > > > > > > index 0179f7ed77e5..58eb928224e5 100644
> > > > > > > > --- a/drivers/hid/hid-logitech-hidpp.c
> > > > > > > > +++ b/drivers/hid/hid-logitech-hidpp.c
> > > > > > > > @@ -2079,6 +2079,11 @@ static void hidpp_ff_destroy(struct ff_device *ff)
> > > > > > > >         struct hidpp_ff_private_data *data = ff->private;
> > > > > > > >
> > > > > > > >         kfree(data->effect_ids);
> > > > > > >
> > > > > > > Is there any reasons we can not also devm alloc data->effect_ids?
> > > > > > >
> > > > > > > > +       /*
> > > > > > > > +        * Set private to NULL to prevent input_ff_destroy() from
> > > > > > > > +        * freeing our devres allocated memory
> > > > > > >
> > > > > > > Ouch. There is something wrong here: input_ff_destroy() calls
> > > > > > > kfree(ff->private), when the data has not been allocated by
> > > > > > > input_ff_create(). This seems to lack a little bit of symmetry.
> > > > > >
> > > > > > Yeah, ff and ff-memless essentially take over the private data assigned
> > > > > > to them. They were done before devm and the lifetime of the "private"
> > > > > > data pieces was tied to the lifetime of the input device to simplify
> > > > > > error handling and teardown.
> > > > >
> > > > > Yeah, that stealing of the pointer is not good :)
> > > > > But OTOH, it helps
> > > > >
> > > > > >
> > > > > > Maybe we should clean it up a bit... I'm open to suggestions.
> > > > >
> > > > > The problem I had when doing the review was that there is no easy way
> > > > > to have a "devm_input_ff_create_()", because the way it's built is
> > > > > already "devres-compatible": the destroy gets called by input core.
> > > >
> > > > I do not think we want devm_input_ff_create() explicitly, I think the
> > > > fact that you can "build up" an input device by allocating it, then
> > > > adding slots, poller, ff support, etc, and input core cleans it up is
> > > > all good. It is just the ownership if the driver-private data block is
> > > > not very obvious and is not compatible with allocating via devm.
> > > >
> > > > >
> > > > > So I don't have a good answer to simplify in a transparent manner
> > > > > without breaking the API.
> > > > >
> > > > > >
> > > > > > In this case maybe best way is to get rid of hidpp_ff_destroy() and not
> > > > > > set ff->private and rely on devm to free the buffers. One can get to
> > > > > > device private data from ff methods via input_get_drvdata() since they
> > > > > > all (except destroy) are passed input device pointer.
> > > > >
> > > > > Sounds like a good idea. However, it seems there might be a race when
> > > > > removing the workqueue:
> > > > > the workqueue gets deleted in hidpp_remove, when the input node will
> > > > > be freed by devres, so after the call of hidpp_remove.
> > > >
> > > > Yeah, well, that is a common issue with mixing devm and normal resources
> > > > (and workqueue here is that "normal" resource), and we should either:
> > > >
> > > > - not use devm
> > > > - use devm_add_action_or_reset() to work in custom actions that work
> > > >   freeing of non-managed resources into devm flow.
> > >
> > > Actually, there is a door #3: use system workqueue. After all the work
> > > that Tejun done on workqueues it is very rare that one actually needs
> > > a dedicated workqueue (as works usually execute on one if the system
> > > worker threads that are shared with other workqueues anyway).
> >
> > And additional note about devm:
> >
> > I think all HID input drivers that are using devm in probe, but do not
> > have proper remove() function (and maybe even some with remove) are
> > broken: hid_device_remove() calls hid_hw_stop() which potentially will
> > shut off the transport. This happens before devm starts unwinding, so
> > we still can be trying to communicate with the device in question, but
> > the transport is gone.
> 
> Well, that is by design. A driver is supposed to call hid_hw_start()
> at the very end of its .probe(). And the supposed rule is that in the
> specific .remove(), you are to call first hid_hw_stop() to stop the
> transport layer underneath. That also means that in the HID subsystem,
> at least, you are not supposed to talk to the device during the devm
> teardown of the allocated data.
> 
> If you really need to communicate with the device during tear down,
> then you are supposed to write your own .remove, in which you control
> where the hid_hw_stop() happens.
> 
> We might have overlooked one or two, but I think we are on a good basis for now.

You have to be _very_ careful there. For example, we can take a look at
hid-elan.c. If you notice, it uses devm_led_classdev_register() to
create "mute" led and it needs to talk over HID to control it;s
brightness/state. So the driver has custom remove() and calls
hid_hw_stop() from it. But the LED will be unregistered much later (in
the depth of the driver core) so users of LED subsystem are free to send
requests through and the driver will try to talk to the device even
after hid_hw_stop() is called and the io_started/driver_input_lock is
reset/released.

I am sure there are more such examples.

> 
> >
> > io_started/driver_input_lock is broken on removal as well as we release
> > the lock when driver may very well be still talking to the device in
> > devm teardown actions.
> 
> Again, this is not supposed to happen. Once hid_hw_stop() is called,
> we do not have access to the transport, so drivers can't talk to the
> device. So releasing/clearing the locks is supposed to be safe now.

Except that it is hard to enforce once you throw in devm.

> 
> >
> > I think we have similar kind of issues in other buses as well (i2c, spi,
> > etc). For example, in i2c we remove the device from power domain before
> > we actually complete devm unwinding.
> >
> 
> I agree that this looks bad.
> 
> I would need to have a better look at it on Monday. Time to go on week
> end (this jet lag doesn't help me to go to sleep...)

I wonder if every bus should open a new devm group for device and
manually release it after calling ->remove(). That would ensure that all
devm resouces allocated by drivers will be freed before we start
executing bus-specific code.

Thanks.

-- 
Dmitry
