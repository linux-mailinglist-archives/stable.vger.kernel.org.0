Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77ECED475E
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 20:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbfJKSTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 14:19:16 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35686 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728721AbfJKSTQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 14:19:16 -0400
Received: by mail-lj1-f195.google.com with SMTP id m7so10754941lji.2;
        Fri, 11 Oct 2019 11:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lbSA0+U8G/oL8JgGMmwp2gpu7thMyfDqSxSYRn93VE8=;
        b=iYKRivIHaYZB06m/Y86bmZXGfmM00SXvHGC602i0nCsr8z4zKxW/hyoNJ7EjarJet9
         0QzCZ+deLV/Ihup/+0O4mMhIq5ckbGm5Nodrtsk3wMqcKGl0HYPK9dgROg0KZREyqFrP
         MlZBBDScHGePvougSkoZNKe/b/k/bR9+4ZvyVfF0OtbkZTdo153hxHjreS3Sx9ek0BEF
         UAKP75LvryhKknrobjpth4g7GB6MeO0ZexYwMRHssPyrWTewL4Ue/BhrbYj1N7ziNMRh
         K3Av7B77T+quLldVMVd8vZUXk1dRJPzV78vLKXayb8Ft4qxonIi/kiKhD03iqtF8dwWB
         uIyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lbSA0+U8G/oL8JgGMmwp2gpu7thMyfDqSxSYRn93VE8=;
        b=GkznQoWPmH5jKX3PWQwikwctm7LnKWr9khysB7OqCOj4dQFLFKIMt89X+eoLXVEApn
         /4+klcMn4X2pjcr7SMEIzFfBwtlOIIP+F6OBlOdPuPrkkikPdaZbNGIuqVq0HXp2Fhx6
         euHdcF3n4Z5MuD3wJEOEKYP8HJMqCTrFGOR8AVlNkbUgSgORYj1qDDWhWcl7BLi+oTuX
         wpvY9I93Czb2m4rKulbWB3PmD3nZUT1hq8mZHYUpddDvUwwnqg/tNxcxbn0atPJBgKpw
         MLTIgUwyDmIaIgX9Wrw2Hymb3ZiOWZIqZ3Qdm1C74Cs2b+Ba3RUdyCFlYZfBJ30Q6nss
         cHmA==
X-Gm-Message-State: APjAAAWW34QZ+kPxDgOr5YPwTZVA6lxpssAMYNjlx32zibdbT4578oIU
        2hSHU9fLI7sZmOVF6Pyzf0fWPLWO+cjDd97SEfw=
X-Google-Smtp-Source: APXvYqw3KYfKyL5he8zBjZLGjb4EzqDCVAOGTBaR5DsqoQ4jy9MsZOBhrseITyN7EmZmKVJSOGsUzQxOeGCKEQR6zaU=
X-Received: by 2002:a2e:9816:: with SMTP id a22mr6723954ljj.102.1570817953123;
 Fri, 11 Oct 2019 11:19:13 -0700 (PDT)
MIME-Version: 1.0
References: <20191007051240.4410-1-andrew.smirnov@gmail.com>
 <20191007051240.4410-2-andrew.smirnov@gmail.com> <CAO-hwJ+jPGa5Z7=Lopsc23m8UOqGWB0=tN+DcotykseAPM7_7w@mail.gmail.com>
In-Reply-To: <CAO-hwJ+jPGa5Z7=Lopsc23m8UOqGWB0=tN+DcotykseAPM7_7w@mail.gmail.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Fri, 11 Oct 2019 11:18:37 -0700
Message-ID: <CAHQ1cqHS6CHti_gQ806SPZzmDjMaZLOZKQDzGCu9TFspT9M0wg@mail.gmail.com>
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

On Fri, Oct 11, 2019 at 7:52 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> Hi Andrey,
>
> On Mon, Oct 7, 2019 at 7:13 AM Andrey Smirnov <andrew.smirnov@gmail.com> wrote:
> >
> > To simplify resource management in commit that follows as well as to
> > save a couple of extra kfree()s and simplify hidpp_ff_deinit() switch
> > driver code to use devres to manage the life-cycle of FF private data.
> >
> > Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> > Cc: Jiri Kosina <jikos@kernel.org>
> > Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > Cc: Henrik Rydberg <rydberg@bitmath.org>
> > Cc: Sam Bazely <sambazley@fastmail.com>
> > Cc: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
> > Cc: Austin Palmer <austinp@valvesoftware.com>
> > Cc: linux-input@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: stable@vger.kernel.org
>
> This patch doesn't seem to fix any error, is there a reason to send it
> to stable? (besides as a dependency of the rest of the series).
>

Dependency is the only reason for this patch, but it is a pretty big
reason. Prior to patches 1/3 and 2/3 FF private data was both
allocated and passed off to FF layer via ff->private = data in a span
of a few lines of code within hidpp_ff_init()/g920_get_config().
After, said pair is effectively split into two different functions,
both needing access to FF private data, but called quite far apart in
hidpp_probe(). Alternatives to patch 1/3 would be to either make sure
that every error path in hidpp_prob() after the call to
g920_allocate() is aware of allocated FF data, which seems like a
nightmare, or, to create a temporary FF data, fill it in
g920_get_config() and memdup() it in hidpp_ff_init(). Is that (the
latter) the path that you prefer to take?

> > ---
> >  drivers/hid/hid-logitech-hidpp.c | 53 +++++++++++++++++---------------
> >  1 file changed, 29 insertions(+), 24 deletions(-)
> >
> > diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
> > index 0179f7ed77e5..58eb928224e5 100644
> > --- a/drivers/hid/hid-logitech-hidpp.c
> > +++ b/drivers/hid/hid-logitech-hidpp.c
> > @@ -2079,6 +2079,11 @@ static void hidpp_ff_destroy(struct ff_device *ff)
> >         struct hidpp_ff_private_data *data = ff->private;
> >
> >         kfree(data->effect_ids);
>
> Is there any reasons we can not also devm alloc data->effect_ids?

No, but I was trying to limit the scope of this patch.

>
> > +       /*
> > +        * Set private to NULL to prevent input_ff_destroy() from
> > +        * freeing our devres allocated memory
>
> Ouch. There is something wrong here: input_ff_destroy() calls
> kfree(ff->private), when the data has not been allocated by
> input_ff_create(). This seems to lack a little bit of symmetry.
>

I agree, I think it's a wart in FF API design.

> > +        */
> > +       ff->private = NULL;
> >  }
> >
> >  static int hidpp_ff_init(struct hidpp_device *hidpp, u8 feature_index)
> > @@ -2090,7 +2095,7 @@ static int hidpp_ff_init(struct hidpp_device *hidpp, u8 feature_index)
> >         const u16 bcdDevice = le16_to_cpu(udesc->bcdDevice);
> >         struct ff_device *ff;
> >         struct hidpp_report response;
> > -       struct hidpp_ff_private_data *data;
> > +       struct hidpp_ff_private_data *data = hidpp->private_data;
> >         int error, j, num_slots;
> >         u8 version;
> >
> > @@ -2129,18 +2134,13 @@ static int hidpp_ff_init(struct hidpp_device *hidpp, u8 feature_index)
> >                 return error;
> >         }
> >
> > -       data = kzalloc(sizeof(*data), GFP_KERNEL);
> > -       if (!data)
> > -               return -ENOMEM;
> >         data->effect_ids = kcalloc(num_slots, sizeof(int), GFP_KERNEL);
> > -       if (!data->effect_ids) {
> > -               kfree(data);
> > +       if (!data->effect_ids)
> >                 return -ENOMEM;
> > -       }
> > +
> >         data->wq = create_singlethread_workqueue("hidpp-ff-sendqueue");
> >         if (!data->wq) {
> >                 kfree(data->effect_ids);
> > -               kfree(data);
> >                 return -ENOMEM;
> >         }
> >
> > @@ -2199,28 +2199,15 @@ static int hidpp_ff_init(struct hidpp_device *hidpp, u8 feature_index)
> >         return 0;
> >  }
> >
> > -static int hidpp_ff_deinit(struct hid_device *hid)
> > +static void hidpp_ff_deinit(struct hid_device *hid)
> >  {
> > -       struct hid_input *hidinput = list_entry(hid->inputs.next, struct hid_input, list);
> > -       struct input_dev *dev = hidinput->input;
> > -       struct hidpp_ff_private_data *data;
> > -
> > -       if (!dev) {
> > -               hid_err(hid, "Struct input_dev not found!\n");
> > -               return -EINVAL;
> > -       }
> > +       struct hidpp_device *hidpp = hid_get_drvdata(hid);
> > +       struct hidpp_ff_private_data *data = hidpp->private_data;
> >
> >         hid_info(hid, "Unloading HID++ force feedback.\n");
> > -       data = dev->ff->private;
> > -       if (!data) {
>
> I am pretty sure we might need to keep a test on data not being null.
>

OK, sure. Could you be more explicit in your reasoning next time
though? I am assuming this is because hid_hw_stop() might be called
before?

> > -               hid_err(hid, "Private data not found!\n");
> > -               return -EINVAL;
> > -       }
> >
> >         destroy_workqueue(data->wq);
> >         device_remove_file(&hid->dev, &dev_attr_range);
> > -
> > -       return 0;
> >  }
>
> This whole hunk seems unrelated to the devm change.
> Can you extract a patch that just stores hidpp_ff_private_data in
> hidpp->private_data and then cleans up hidpp_ff_deinit() before
> switching it to devm? (or maybe not, see below)

Well it appears you are against the idea of leveraging devres in this
series, so discussing the fate of said hunk seems moot.

>
> After a few more thoughts, I don't think this mixing of devm and non
> devm is a good idea:
> we could say that the hidpp_ff_private_data and its effect_ids are
> both children of the input_dev, not the hid_device. And we would
> expect the whole thing to simplify with devm, but it's not, because ff
> is not supposed to be used with devm.
>
> I have a feeling the whole ff logic is wrong in term of where things
> should be cleaned up, but I can not come up with a good hint on where
> to start. For example, destroy_workqueue() is called in
> hidpp_ff_deinit() where it might be racy, and maybe we should call it
> in hidpp_ff_destroy()...
>

Yeah, it probably should be moved to hidpp_ff_destroy(). Out of scope
for this series though, I'll deal with it in a separate submission.

> Last, you should base this patch on top of the for-next branch, we
> recently merged a fix for the FF drivers in the HID subsystem:
> https://git.kernel.org/pub/scm/linux/kernel/git/hid/hid.git/commit/?h=for-next&id=d9d4b1e46d9543a82c23f6df03f4ad697dab361b
>

Sure will do.

> Would it be too complex to drop this patch from the series and do a
> proper follow up cleanup series that might not need to go to stable?
>

No it's alright. I'll submit a v2 of this series with only two patches
and send a follow up after.

Thanks,
Andrey Smirnov
