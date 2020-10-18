Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B31A29174B
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 14:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgJRMXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 08:23:22 -0400
Received: from mail-40132.protonmail.ch ([185.70.40.132]:14719 "EHLO
        mail-40132.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbgJRMXW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Oct 2020 08:23:22 -0400
X-Greylist: delayed 77103 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Oct 2020 08:23:21 EDT
Date:   Sun, 18 Oct 2020 12:23:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1603023799;
        bh=Si/sDxp81cibqgSxPPtoAjFrCd8mtAH2nl/znWmdQGY=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=Gku9EbnAj06ght/wpRe3tHwnyij60K657O40Flpnx0uzmEFzcUfhLjSOzX9oU98O5
         6mciQLsTfknvbP+z/OLEFb5NKZWE+mAlwTT5wxlHIONPEoyiGlzMvOD1Fpi1uuul4Y
         riA8tjrkk3oyVp1Rpr66GBnqR4EvzZMX3awKRNm0=
To:     Coiby Xu <coiby.xu@gmail.com>
From:   =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Cc:     "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Helmut Stult <helmut.stult@schinfo.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-To: =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Subject: Re: [PATCH v2] HID: i2c-hid: add polling mode based on connected GPIO chip's pin status
Message-ID: <BXoa8IFE81mt8sW2luHnqgFoZUBIDxRGg8SzTxqCuBMm0PPopB98-w7u1ckq77Gtj2bJCVSFFA83zOPVdP_kynQ8Zkys3B96lFTV6fUCJHM=@protonmail.com>
In-Reply-To: <fRxQJHWq9ZL950ZPGFFm_LfSlMjsjrpG7Y63gd7V7iV647KR8WIfZ4-ljLeo0n4X3Gpu1KIEsMVLxQnzAtJdUdMydi_b0-vjIVb304Da1bQ=@protonmail.com>
References: <20201016131335.8121-1-coiby.xu@gmail.com> <T2SIcFVxZ81NUwKLDbSESA7Wpm7DYowEiii8ZaxTPtrdXZZeHLq5iZPkN5BLlp-9C6PLwUZOVwNpMdEdPSRZcAG4MmDt-tfyKZoQYJ0KHOA=@protonmail.com> <20201017004556.kuoxzmbvef4yr3kg@Rk> <FWsXxqGztJgszUpmNtKli8eOyeKP-lxFeTsjs2nQAxgYZBkT3JNTU3VdHF4GbQVS_PvKiqbfrZXI7vaUHA_lXTxjPX-WjkNEOdiMUetO8IQ=@protonmail.com> <20201017140541.fggujaz2klpv3cd5@Rk> <fRxQJHWq9ZL950ZPGFFm_LfSlMjsjrpG7Y63gd7V7iV647KR8WIfZ4-ljLeo0n4X3Gpu1KIEsMVLxQnzAtJdUdMydi_b0-vjIVb304Da1bQ=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> [...]
> > > > > > +static int i2c_hid_polling_thread(void *i2c_hid)
> > > > > > +{
> > > > > >
> > > > > > -   struct i2c_hid *ihid =3D i2c_hid;
> > > > > > -   struct i2c_client *client =3D ihid->client;
> > > > > > -   unsigned int polling_interval_idle;
> > > > > > -
> > > > > > -   while (1) {
> > > > > > -       /*
> > > > > >
> > > > > >
> > > > > > -        * re-calculate polling_interval_idle
> > > > > >
> > > > > >
> > > > > > -        * so the module parameters polling_interval_idle_ms ca=
n be
> > > > > >
> > > > > >
> > > > > > -        * changed dynamically through sysfs as polling_interva=
l_active_us
> > > > > >
> > > > > >
> > > > > > -        */
> > > > > >
> > > > > >
> > > > > > -       polling_interval_idle =3D polling_interval_idle_ms * 10=
00;
> > > > > >
> > > > > >
> > > > > > -       if (test_bit(I2C_HID_READ_PENDING, &ihid->flags))
> > > > > >
> > > > > >
> > > > > > -       =09usleep_range(50000, 100000);
> > > > > >
> > > > > >
> > > > > > -
> > > > > > -       if (kthread_should_stop())
> > > > > >
> > > > > >
> > > > > > -       =09break;
> > > > > >
> > > > > >
> > > > > > -
> > > > > > -       while (interrupt_line_active(client)) {
> > > > > >
> > > > > >
> > > > >
> > > > > I realize it's quite unlikely, but can't this be a endless loop i=
f data is coming
> > > > > in at a high enough rate? Maybe the maximum number of iterations =
could be limited here?
> > > >
> > > > If we find HID reports are constantly read and send to front-end
> > > > application like libinput, won't it help expose the problem of the =
I2C
> > > > HiD device?
> > > >
> > > > >
> > >
> > > I'm not sure I completely understand your point. The reason why I wro=
te what I wrote
> > > is that this kthread could potentially could go on forever (since `kt=
hread_should_stop()`
> > > is not checked in the inner while loop) if the data is supplied at a =
high enough rate.
> > > That's why I said, to avoid this problem, only allow a certain number=
 of iterations
> > > for the inner loop, to guarantee that the kthread can stop in any cas=
e.
> >
> > I mean if "data is supplied at a high enough rate" does happen, this is
> > an abnormal case and indicates a bug. So we shouldn't cover it up. We
> > expect the user to report it to us.
> >
> > >
>
> I agree in principle, but if this abnormal case ever occurs, that'll prev=
ent
> this module from being unloaded since `kthread_stop()` will hang because =
the
> thread is "stuck" in the inner loop, never checking `kthread_should_stop(=
)`.
> That's why I think it makes sense to only allow a certain number of opera=
tions
> for the inner loop, and maybe show a warning if that's exceeded:
>
> for (i =3D 0; i < max_iter && interrupt_line_active(...); i++) {
> ....
> }
>
> WARN_ON[CE](i =3D=3D max_iter[, "data is coming in at an unreasonably hig=
h rate"]);
>

I now realize that WARN_ON[CE] is probably not the best fit here, `hid_warn=
()` is possibly better.


> or something like this, where `max_iter` could possibly be some value dep=
endent on
> `polling_interval_active_us`, or even just a constant.
> [...]


Regards,
Barnab=C3=A1s P=C5=91cze
