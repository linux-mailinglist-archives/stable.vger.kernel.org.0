Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B507D484E
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 21:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbfJKTQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 15:16:35 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42671 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728857AbfJKTQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 15:16:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570821393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PmD2iXZzRm5TWXHP4u2nvAta0M6In2JXUUfSGIBG8L8=;
        b=OxK+T2Ft8xLpde41Eq77l0D6tS1/02Cc30vTco+teZ8OdxRgFST5XrPLGnNxSgCW+cEadk
        C+VIqRIVLuSGwz6Pz8Cf4LHUwogBfiN2bs39V7xurxzhyh5ZmC9ohW0FwCgGdm/tNkHObh
        Ynz7qygm46d2Zu7bGaPxjukorhF8mHk=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-LNNKkJ8RMUCMQbUui424Dg-1; Fri, 11 Oct 2019 15:16:32 -0400
Received: by mail-qt1-f200.google.com with SMTP id r15so10410557qtn.12
        for <stable@vger.kernel.org>; Fri, 11 Oct 2019 12:16:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DuLUVOIQimNSFcqes+0fEHnQr+0Rr+pI9L1erbmu+/Y=;
        b=gXLnIKBvCtV5RdAycRuaBL1bQ5VzeFQb8OEdjj4buZ1tOe0XjM/twRdzkEvXsY257p
         HK9SUH7VU1eSUcy7BVsw8onoV31DdijG0+BufcKv6jflkw9UsYi2Mscma1uuIHs2ktLD
         DSyeisgstd05aTJJlie2BFsErlbjU6ZVrDIdbieR0D7l/qq1QMmEB7YId5AuJR0J74Wq
         aX75hKBdOZqYNTByZZ+vvb4lvgveA8pr9IKdMWSIFQwms0v08O3kTT5XmrUM47jlB+M3
         wJMLmcUyRCIX8iYFJ0T+p9LuHHn3iZROGPcUSj7yZdPiB4o/0OFKn9mj5TNu+V3yNA/d
         lX4A==
X-Gm-Message-State: APjAAAVAiGQT63JvxQ8b30YCh8hYj52hvUAiusiNhiRxabVCHcbyui7q
        G/5ev5R8cl+zxhXUgjAbZDnTSrvi1vLz+F8imYGatKZ4b/SvD71o7AfiAUfcPINiT3dzGmrDL31
        kBpX6bR50FRsj+ehY3UKbzwwo55ODJj5m
X-Received: by 2002:ae9:f306:: with SMTP id p6mr17452680qkg.169.1570821391798;
        Fri, 11 Oct 2019 12:16:31 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyCUFq1iJEUGQxH880Dht23cTHsuGZ/C0d5reOJDTvtn3H+V6DJiHEHxyT7/yb4ene1k2/R4IBRnezVo09UkEM=
X-Received: by 2002:ae9:f306:: with SMTP id p6mr17452643qkg.169.1570821391424;
 Fri, 11 Oct 2019 12:16:31 -0700 (PDT)
MIME-Version: 1.0
References: <20191007051240.4410-1-andrew.smirnov@gmail.com>
 <20191007051240.4410-2-andrew.smirnov@gmail.com> <CAO-hwJ+jPGa5Z7=Lopsc23m8UOqGWB0=tN+DcotykseAPM7_7w@mail.gmail.com>
 <CAHQ1cqHS6CHti_gQ806SPZzmDjMaZLOZKQDzGCu9TFspT9M0wg@mail.gmail.com>
In-Reply-To: <CAHQ1cqHS6CHti_gQ806SPZzmDjMaZLOZKQDzGCu9TFspT9M0wg@mail.gmail.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Fri, 11 Oct 2019 21:16:19 +0200
Message-ID: <CAO-hwJ+6iW=P6gC5n8Bu0hfbrerY_o25i_=dhMvs0FpPRuu3yA@mail.gmail.com>
Subject: Re: [PATCH 1/3] HID: logitech-hidpp: use devres to manage FF private data
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Henrik Rydberg <rydberg@bitmath.org>,
        Sam Bazely <sambazley@fastmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        Austin Palmer <austinp@valvesoftware.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>
X-MC-Unique: LNNKkJ8RMUCMQbUui424Dg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andrey,

On Fri, Oct 11, 2019 at 8:19 PM Andrey Smirnov <andrew.smirnov@gmail.com> w=
rote:
>
> On Fri, Oct 11, 2019 at 7:52 AM Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
> >
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
>
> Dependency is the only reason for this patch, but it is a pretty big
> reason. Prior to patches 1/3 and 2/3 FF private data was both
> allocated and passed off to FF layer via ff->private =3D data in a span
> of a few lines of code within hidpp_ff_init()/g920_get_config().
> After, said pair is effectively split into two different functions,
> both needing access to FF private data, but called quite far apart in
> hidpp_probe(). Alternatives to patch 1/3 would be to either make sure
> that every error path in hidpp_prob() after the call to
> g920_allocate() is aware of allocated FF data, which seems like a
> nightmare, or, to create a temporary FF data, fill it in
> g920_get_config() and memdup() it in hidpp_ff_init(). Is that (the
> latter) the path that you prefer to take?

Hmm, I don't have a strong opinion on that. The point I don't like
with the devres version is that it seems like a half-backed solution,
as part of the driver would use devres while parts for the same
purpose will not. I do not consider your code untrusted, but this is
usually a reasonable source of leakages, so as a rule a thumb, devres
should be used in a all or nothing fashion.

Basically, both alternative solutions would be OK with me, as long as
the scope of each patch is reduced to the minimum (and having more
than one is OK too).

>
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
>
> No, but I was trying to limit the scope of this patch.
>
> >
> > > +       /*
> > > +        * Set private to NULL to prevent input_ff_destroy() from
> > > +        * freeing our devres allocated memory
> >
> > Ouch. There is something wrong here: input_ff_destroy() calls
> > kfree(ff->private), when the data has not been allocated by
> > input_ff_create(). This seems to lack a little bit of symmetry.
> >
>
> I agree, I think it's a wart in FF API design.

Yep, see Dmitry's answer for ideas :)

>
> > > +        */
> > > +       ff->private =3D NULL;
> > >  }
> > >
> > >  static int hidpp_ff_init(struct hidpp_device *hidpp, u8 feature_inde=
x)
> > > @@ -2090,7 +2095,7 @@ static int hidpp_ff_init(struct hidpp_device *h=
idpp, u8 feature_index)
> > >         const u16 bcdDevice =3D le16_to_cpu(udesc->bcdDevice);
> > >         struct ff_device *ff;
> > >         struct hidpp_report response;
> > > -       struct hidpp_ff_private_data *data;
> > > +       struct hidpp_ff_private_data *data =3D hidpp->private_data;
> > >         int error, j, num_slots;
> > >         u8 version;
> > >
> > > @@ -2129,18 +2134,13 @@ static int hidpp_ff_init(struct hidpp_device =
*hidpp, u8 feature_index)
> > >                 return error;
> > >         }
> > >
> > > -       data =3D kzalloc(sizeof(*data), GFP_KERNEL);
> > > -       if (!data)
> > > -               return -ENOMEM;
> > >         data->effect_ids =3D kcalloc(num_slots, sizeof(int), GFP_KERN=
EL);
> > > -       if (!data->effect_ids) {
> > > -               kfree(data);
> > > +       if (!data->effect_ids)
> > >                 return -ENOMEM;
> > > -       }
> > > +
> > >         data->wq =3D create_singlethread_workqueue("hidpp-ff-sendqueu=
e");
> > >         if (!data->wq) {
> > >                 kfree(data->effect_ids);
> > > -               kfree(data);
> > >                 return -ENOMEM;
> > >         }
> > >
> > > @@ -2199,28 +2199,15 @@ static int hidpp_ff_init(struct hidpp_device =
*hidpp, u8 feature_index)
> > >         return 0;
> > >  }
> > >
> > > -static int hidpp_ff_deinit(struct hid_device *hid)
> > > +static void hidpp_ff_deinit(struct hid_device *hid)
> > >  {
> > > -       struct hid_input *hidinput =3D list_entry(hid->inputs.next, s=
truct hid_input, list);
> > > -       struct input_dev *dev =3D hidinput->input;
> > > -       struct hidpp_ff_private_data *data;
> > > -
> > > -       if (!dev) {
> > > -               hid_err(hid, "Struct input_dev not found!\n");
> > > -               return -EINVAL;
> > > -       }
> > > +       struct hidpp_device *hidpp =3D hid_get_drvdata(hid);
> > > +       struct hidpp_ff_private_data *data =3D hidpp->private_data;
> > >
> > >         hid_info(hid, "Unloading HID++ force feedback.\n");
> > > -       data =3D dev->ff->private;
> > > -       if (!data) {
> >
> > I am pretty sure we might need to keep a test on data not being null.
> >
>
> OK, sure. Could you be more explicit in your reasoning next time
> though? I am assuming this is because hid_hw_stop() might be called
> before?

Honestly, I don't have a good reason for it. I have seen enough of
automatic static/dynamic checks with the same patterns to let my guts
express that we need to check on the value of a pointer stored in
private_data before dereferencing it.

If you are absolutely sure this is not need, a simple comment in the
code is enough :)

>
> > > -               hid_err(hid, "Private data not found!\n");
> > > -               return -EINVAL;
> > > -       }
> > >
> > >         destroy_workqueue(data->wq);
> > >         device_remove_file(&hid->dev, &dev_attr_range);
> > > -
> > > -       return 0;
> > >  }
> >
> > This whole hunk seems unrelated to the devm change.
> > Can you extract a patch that just stores hidpp_ff_private_data in
> > hidpp->private_data and then cleans up hidpp_ff_deinit() before
> > switching it to devm? (or maybe not, see below)
>
> Well it appears you are against the idea of leveraging devres in this
> series, so discussing the fate of said hunk seems moot.

Well, I really value your work and I am very happy of it. It's just
that for a patch/series aimed at stable, I rather have the patch
series following the stable rules, which are that we should fix one
thing only, and have the most simplest patch possible. I truly believe
adding devres to cleanup the error path is the thing to do, but maybe
not in this series.

>
> >
> > After a few more thoughts, I don't think this mixing of devm and non
> > devm is a good idea:
> > we could say that the hidpp_ff_private_data and its effect_ids are
> > both children of the input_dev, not the hid_device. And we would
> > expect the whole thing to simplify with devm, but it's not, because ff
> > is not supposed to be used with devm.
> >
> > I have a feeling the whole ff logic is wrong in term of where things
> > should be cleaned up, but I can not come up with a good hint on where
> > to start. For example, destroy_workqueue() is called in
> > hidpp_ff_deinit() where it might be racy, and maybe we should call it
> > in hidpp_ff_destroy()...
> >
>
> Yeah, it probably should be moved to hidpp_ff_destroy(). Out of scope
> for this series though, I'll deal with it in a separate submission.

As per Dmitry's suggestion of removing hidpp_ff_destroy() maybe we
should keep it that way, I am not entirely sure about how the races
can happen (I don't think I even have one FF device I could test
against).

>
> > Last, you should base this patch on top of the for-next branch, we
> > recently merged a fix for the FF drivers in the HID subsystem:
> > https://git.kernel.org/pub/scm/linux/kernel/git/hid/hid.git/commit/?h=
=3Dfor-next&id=3Dd9d4b1e46d9543a82c23f6df03f4ad697dab361b
> >
>
> Sure will do.

thanks \o/

>
> > Would it be too complex to drop this patch from the series and do a
> > proper follow up cleanup series that might not need to go to stable?
> >
>
> No it's alright. I'll submit a v2 of this series with only two patches
> and send a follow up after.
>

And thanks a lot again.

Cheers,
Benjamin

