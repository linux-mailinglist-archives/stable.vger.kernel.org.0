Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3996E3B1BD7
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 16:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhFWOCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 10:02:36 -0400
Received: from vulcan.natalenko.name ([104.207.131.136]:59538 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbhFWOCg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 10:02:36 -0400
Received: from spock.localnet (unknown [151.237.229.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 6BCE8AF3443;
        Wed, 23 Jun 2021 16:00:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1624456816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rQqup4RSADZYht0Tjo6YJfart8szjUekpTWg50N90zg=;
        b=iiBSiQTzNzNIsxPhqWjmqKJF7tmTZJY5Q/BidWx9FCs62wrCJhiaCYQVZkiRCLrSASONxZ
        H4lrMykgMh1LcGAUVxjofIFlyQq3NDycgDefrxAT2Yl5Me/auyB0nE1qGMoU5gF1t28wtI
        xixdIlLXYHgvej0KMo8u/iqe07PzqLw=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Backport d583d360a6 into 5.12 stable
Date:   Wed, 23 Jun 2021 16:00:14 +0200
Message-ID: <7592880.XtGZTbpMlS@spock>
In-Reply-To: <YNIrp7A0LV0aLc5q@cmpxchg.org>
References: <11282373.oIR2C0Pl9h@spock> <5661831.TEGnOE2T3c@spock> <YNIrp7A0LV0aLc5q@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello.

On =C3=BAter=C3=BD 22. =C4=8Dervna 2021 20:27:51 CEST Johannes Weiner wrote:
> On Tue, Jun 22, 2021 at 07:24:56PM +0200, Oleksandr Natalenko wrote:
> > On =C3=BAter=C3=BD 22. =C4=8Dervna 2021 18:47:59 CEST Greg KH wrote:
> > > On Tue, Jun 22, 2021 at 06:30:46PM +0200, Oleksandr Natalenko wrote:
> > > > I'd like to nominate d583d360a6 ("psi: Fix psi state corruption when
> > > > schedule() races with cgroup move") for 5.12 stable tree.
> > > >=20
> > > > Recently, I've hit this:
> > > >=20
> > > > ```
> > > > kernel: psi: inconsistent task state! task=3D2667:clementine cpu=3D=
21
> > > > psi_flags=3D0 clear=3D1 set=3D0
> > > > ```
> > > >=20
> > > > and after that PSI IO went crazy high. That seems to match the
> > > > symptoms
> > > > described in the commit message.
> > >=20
> > > But this says it fixes 4117cebf1a9f ("psi: Optimize task switch inside
> > > shared cgroups") which did not show up until 5.13-rc1, so how are you
> > > hitting this issue?
> >=20
> > I'm not positive 4117cebf1a9f was a root cause of the race. To me it lo=
oks
> > like 4117cebf1a9f just made an older issue more likely to be hit.
> >=20
> > Peter, Johannes, am I correct saying that it is still possible to hit a
> > corruption described in d583d360a6 on 5.12?
>=20
> I'm not aware of a previous issue, but it's possible you discovered
> one that was incidentally fixed by this change.
>=20
> That said, there haven't been many changes in this area prior to 5.12,
> and I stared at the old code quite a bit to see if there are other
> possible scenarios, so this gives me pause.

Ack.

> > > Did you try this patch on 5.12.y and see that it solved your problem?
> >=20
> > Yes, I've built the kernel with this patch, and so far it runs fine. It
> > can
> > take a while until the condition is hit though since it seems to be very
> > unlikely on 5.12.
>=20
> Is your task moving / being moved between cgroups while it's doing
> work?

Likely, yes. IIUC, KDE spawns apps in separate cgroups so that in that very=
=20
case Clementine should get its own one (?):

```
$ systemd-cgls
=E2=80=A6
=E2=94=82   =E2=94=82 =E2=94=82 =E2=94=9C=E2=94=80app-clementine-df516e4181=
f446ab869e723ea2ed6094.scope=20
=E2=94=82   =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=9C=E2=94=802926 /bin/cleme=
ntine -session=20
10de706f63000162437544200000015700012_1624379013_575845
=E2=94=82   =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=9C=E2=94=803059 /usr/bin/c=
lementine-tagreader /tmp/clementine_735427711
=E2=94=82   =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=9C=E2=94=803060 /usr/bin/c=
lementine-tagreader /tmp/clementine_557274898
=E2=94=82   =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=9C=E2=94=803062 /usr/bin/c=
lementine-tagreader /tmp/clementine_1730944950
=E2=94=82   =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=9C=E2=94=803063 /usr/bin/c=
lementine-tagreader /tmp/clementine_1509249421
=E2=94=82   =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=9C=E2=94=803065 /usr/bin/c=
lementine-tagreader /tmp/clementine_1345386497
=E2=94=82   =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=9C=E2=94=803068 /usr/bin/c=
lementine-tagreader /tmp/clementine_865255891
=E2=94=82   =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=9C=E2=94=803070 /usr/bin/c=
lementine-tagreader /tmp/clementine_1782561441
=E2=94=82   =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=9C=E2=94=803072 /usr/bin/c=
lementine-tagreader /tmp/clementine_421851305
=E2=94=82   =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=9C=E2=94=803073 /usr/bin/c=
lementine-tagreader /tmp/clementine_175368243
=E2=94=82   =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=9C=E2=94=803075 /usr/bin/c=
lementine-tagreader /tmp/clementine_1962830479
=E2=94=82   =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=9C=E2=94=803076 /usr/bin/c=
lementine-tagreader /tmp/clementine_547573203
=E2=94=82   =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=9C=E2=94=803078 /usr/bin/c=
lementine-tagreader /tmp/clementine_1819270047
=E2=94=82   =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=9C=E2=94=803079 /usr/bin/c=
lementine-tagreader /tmp/clementine_1632862299
=E2=94=82   =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=9C=E2=94=803085 /usr/bin/c=
lementine-tagreader /tmp/clementine_1279975869
=E2=94=82   =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=9C=E2=94=803095 /usr/bin/c=
lementine-tagreader /tmp/clementine_1612119641
=E2=94=82   =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=9C=E2=94=803102 /usr/bin/c=
lementine-tagreader /tmp/clementine_1789578483
=E2=94=82   =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=9C=E2=94=803103 /usr/bin/c=
lementine-tagreader /tmp/clementine_1541442265
=E2=94=82   =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=9C=E2=94=803105 /usr/bin/c=
lementine-tagreader /tmp/clementine_1418456770
=E2=94=82   =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=9C=E2=94=803106 /usr/bin/c=
lementine-tagreader /tmp/clementine_1998684543
=E2=94=82   =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=9C=E2=94=803107 /usr/bin/c=
lementine-tagreader /tmp/clementine_1349315391
=E2=94=82   =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=9C=E2=94=803108 /usr/bin/c=
lementine-tagreader /tmp/clementine_231895572
=E2=94=82   =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=9C=E2=94=803110 /usr/bin/c=
lementine-tagreader /tmp/clementine_492688785
=E2=94=82   =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=9C=E2=94=803111 /usr/bin/c=
lementine-tagreader /tmp/clementine_1492630900
=E2=94=82   =E2=94=82 =E2=94=82 =E2=94=82 =E2=94=94=E2=94=803112 /usr/bin/c=
lementine-tagreader /tmp/clementine_2017490599
=E2=80=A6
```

> How long does it usually take to trigger it?

I don't know :(. I don't usually peer into dmesg, and noticed this by a pur=
e=20
chance. Grepping the journal shows nothing else but only this occurrence, a=
nd=20
also the journal is rotating, so some info might be already lost.

> Would it be possible to share a simpler reproducer, or is this part of
> a more complex application?

This was triggered bu KDE's autostart of Clementine player, and I don't hav=
e=20
any specific reproducer. If I find one, I'll share it of course.

Thanks.

=2D-=20
Oleksandr Natalenko (post-factum)


