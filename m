Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFA39D499C
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 23:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbfJKVCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 17:02:46 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42400 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbfJKVCq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 17:02:46 -0400
Received: by mail-lj1-f196.google.com with SMTP id y23so11081434lje.9;
        Fri, 11 Oct 2019 14:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mqKrOA4KB3b8vrjSq0Kp4tT5A0a3DDbpcu6SdOiguto=;
        b=VZnIl42NrQS9PFUpMDN5U44yRNwQrRJtKxfOsmhCcaQ/FlrENZuAP47jOjh8mnyIY3
         P+WlKto7vhqZ+ZFP1SkTglF2VkGAvg5GYbDhDFdmhu62mXNzh1jFqXHETpc7SavYMzlc
         IqAuyEeSY4dIEUHcSMMiKqfGZI21K3ZLW0W0d4GNTJQXFFHOUIeWDOQRwesh4h4ob9Bo
         WcDnpPsPbd5jGRax+edAWk99MLBcMWhFxk14A4RMEKbiaCTkYSp0EOR+OtBlvzJ/T70p
         BT0sThdvtJoipy2XstY7M7wSiRNEYBR9ehQm9nIVhbKVSH/+wd4uXvgZZhzWsXfXkx5V
         ngKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mqKrOA4KB3b8vrjSq0Kp4tT5A0a3DDbpcu6SdOiguto=;
        b=QVLEQTeb3jAaT7Zsmuwhn4WkVaQ3SSY6pDDlGORsSv6CuCsFBLuDejnlj1buzjZG19
         D/CkeHagjLMK4TCN95kbBEre4mvWupzc0HHvTJabH2zy87Sme7VXxi3SdYJKKnQcXemq
         4tko5m5wIosCfTYGN4WEHacL5UPh7O/8dNlPmYIl/lR13QDjtPwugL0ZCPgtKTVXnsPo
         zDN4vRTxGRJBmrMGgmGWcOaKECfzwz5lDmacMA/Sn5FzF1/300ydOI7NAHOZXlvpWhvW
         LkMoDcbpWBcFkYxugScOMW7KceIXVPbyoXMHi4QFxE8LdnULZW8TIKSdkMJSuga6Zlty
         ocOg==
X-Gm-Message-State: APjAAAWVjzpJT6cScGsznEBVCUAMXuIVa5hmsGjvxO5wlRzbT4aHXnhj
        AovfJQprv9ys4SbbLBNZM+NtW+DlNsusKYCzqk4=
X-Google-Smtp-Source: APXvYqygXXFeDjxLNgImMMQtBqHG4QxDYk1CUWs/EshKOG0iWu9s9U74s6AJ2oLMWzvdlQ+o9DxB3j4Py7jgD8Dp82E=
X-Received: by 2002:a2e:97ca:: with SMTP id m10mr8789741ljj.168.1570827762839;
 Fri, 11 Oct 2019 14:02:42 -0700 (PDT)
MIME-Version: 1.0
References: <20191007051240.4410-1-andrew.smirnov@gmail.com>
 <20191007051240.4410-2-andrew.smirnov@gmail.com> <CAO-hwJ+jPGa5Z7=Lopsc23m8UOqGWB0=tN+DcotykseAPM7_7w@mail.gmail.com>
 <20191011182617.GE229325@dtor-ws> <CAO-hwJLH6SMkLb1kZGj1E+BUHJ+ZsE1n+d=xeJgsvTCjHH1Wzw@mail.gmail.com>
 <20191011203303.GF229325@dtor-ws>
In-Reply-To: <20191011203303.GF229325@dtor-ws>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Fri, 11 Oct 2019 14:02:30 -0700
Message-ID: <CAHQ1cqFc-7BpgZuinLakHAjT=6XNzcsQE=RFHOw2xu4Gqdpeog@mail.gmail.com>
Subject: Re: [PATCH 1/3] HID: logitech-hidpp: use devres to manage FF private data
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
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

On Fri, Oct 11, 2019 at 1:33 PM Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
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

What do you think of creating input_ff_create_with_private() which
would take a pointer to private memory and set a new
"borrowed_private" flag in struct ff_device which input_ff_destroy()
can check to determine if it needs to free ->private or not?

Thanks,
Andrey Smirnov
