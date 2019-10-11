Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77439D49EB
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 23:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbfJKVdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 17:33:55 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38517 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbfJKVdz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 17:33:55 -0400
Received: by mail-pl1-f193.google.com with SMTP id w8so5026312plq.5;
        Fri, 11 Oct 2019 14:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9YRG58VFTqQ+y2hDFXK3X9NVEo8fqlpVLfA90wbHBMg=;
        b=d/LSXAaV5ZlyWvOaYds6wqcrKgCvic8f3IqeehFJsUUDwu7aRfu9d0SOKG1LkNW8Jg
         oF/zKWyIYETl03c3ZrV/OxMYQ3qXfCI9+qEelqYI2/ikRtzbd2+eOoqN6QKC9NtV2mIC
         m+fLjDiWBu7ebC84P5r+ViP+5OB2mWUYG2pb9U/RKGtWpIt3xLDPyc4bhz/m87BAhoED
         9xJux8Ijn+lNLUi1BF/dNbDCkMHPTwMHeoz02dQYwkquiNiitv/fzHDWddzDUHtJd4sK
         JJa1sM3dect9U8kwkjkUnfAWtlK07U0/hEOtE2HCT7vmk9zos7x/dX7LvAhr+ZZWziOg
         wXLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9YRG58VFTqQ+y2hDFXK3X9NVEo8fqlpVLfA90wbHBMg=;
        b=sSYbwygPkIzbErUPfoqWGohgSGdF+ATkRFAlpj1ytLMfLP1+gPnV7xQnM6O2FVECOT
         R01AdZEleEnaGBmhyMuKAxYdrir7FrGJSPvoHo6ilOuP6/ZRRJplrr1UXkC0UUcu9nq+
         D0vQpANYz36U8I8HzIfsbgUGbBV9S8OsZ4m3aR/5N0RAS/gBOt27RILpZWrAFH+Ft02g
         uWH+uQfBKvlZowCd0Dc+5qpfwz1QWR0mMEMIOLphRxL/P+Jhy8eCmIWx7A+5oT08mImZ
         FbXZYVad6SnVFPB3g/GJ9nm5d8XX7Zp45T18C8ZbV3wf/Znz0ZyLmU1SNYkTQe2McFo+
         +74Q==
X-Gm-Message-State: APjAAAWkuES/kob1bINMBPZzpXHvAh2cQKF2x10T0sJr3em2tAwiwZ1l
        9sQqlDpvATcnYJ511cltvB8=
X-Google-Smtp-Source: APXvYqzQD+1oWprLARBvBEnWQmZzIJ1i1NgD/pT069q3pgQTwne+smg1/J5Zux7qdT4PDos0P6EgUw==
X-Received: by 2002:a17:902:421:: with SMTP id 30mr17285511ple.156.1570829632566;
        Fri, 11 Oct 2019 14:33:52 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id w6sm11411852pfj.17.2019.10.11.14.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 14:33:51 -0700 (PDT)
Date:   Fri, 11 Oct 2019 14:33:49 -0700
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
Message-ID: <20191011213349.GJ229325@dtor-ws>
References: <20191007051240.4410-1-andrew.smirnov@gmail.com>
 <20191007051240.4410-2-andrew.smirnov@gmail.com>
 <CAO-hwJ+jPGa5Z7=Lopsc23m8UOqGWB0=tN+DcotykseAPM7_7w@mail.gmail.com>
 <20191011182617.GE229325@dtor-ws>
 <CAO-hwJLH6SMkLb1kZGj1E+BUHJ+ZsE1n+d=xeJgsvTCjHH1Wzw@mail.gmail.com>
 <20191011203303.GF229325@dtor-ws>
 <20191011203509.GG229325@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011203509.GG229325@dtor-ws>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 11, 2019 at 01:35:09PM -0700, Dmitry Torokhov wrote:
> On Fri, Oct 11, 2019 at 01:33:03PM -0700, Dmitry Torokhov wrote:
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
> > > 
> > > So I don't have a good answer to simplify in a transparent manner
> > > without breaking the API.
> > > 
> > > >
> > > > In this case maybe best way is to get rid of hidpp_ff_destroy() and not
> > > > set ff->private and rely on devm to free the buffers. One can get to
> > > > device private data from ff methods via input_get_drvdata() since they
> > > > all (except destroy) are passed input device pointer.
> > > 
> > > Sounds like a good idea. However, it seems there might be a race when
> > > removing the workqueue:
> > > the workqueue gets deleted in hidpp_remove, when the input node will
> > > be freed by devres, so after the call of hidpp_remove.
> > 
> > Yeah, well, that is a common issue with mixing devm and normal resources
> > (and workqueue here is that "normal" resource), and we should either:
> > 
> > - not use devm
> > - use devm_add_action_or_reset() to work in custom actions that work
> >   freeing of non-managed resources into devm flow.
> 
> Actually, there is a door #3: use system workqueue. After all the work
> that Tejun done on workqueues it is very rare that one actually needs
> a dedicated workqueue (as works usually execute on one if the system
> worker threads that are shared with other workqueues anyway).

And additional note about devm:

I think all HID input drivers that are using devm in probe, but do not
have proper remove() function (and maybe even some with remove) are
broken: hid_device_remove() calls hid_hw_stop() which potentially will
shut off the transport. This happens before devm starts unwinding, so
we still can be trying to communicate with the device in question, but
the transport is gone.

io_started/driver_input_lock is broken on removal as well as we release
the lock when driver may very well be still talking to the device in
devm teardown actions.

I think we have similar kind of issues in other buses as well (i2c, spi,
etc). For example, in i2c we remove the device from power domain before
we actually complete devm unwinding.

Thanks.

-- 
Dmitry
