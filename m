Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86DA860DCEA
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 10:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbiJZISl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 04:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbiJZISj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 04:18:39 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55EF98372
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 01:18:36 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 0E7F4E0005;
        Wed, 26 Oct 2022 08:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666772315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5F15LdH32ppPGR7bide78pa8Ark7aZO1AYqZ8pGDmqE=;
        b=d/SDmjbz3Z03QjOQOWqgfunmMJaLYawBtS7mOgjeHbi1au4a561Nz52ntTRWH+Qw/9bUam
        +sStSlwrt6Jna+u2R01SpxFuvZYckYZYHhs2LhOSSdD0oiUGkNWZqPwskQoAic9lVdeEpU
        MSw8iyAJi9LCGxZFOiM7hBGV8Mx37KzP+84/6U/n4ZorTzePNOR83UXQf7110/lRuv8GOm
        0dnTvf+3hxloJjRHMVAv3vimFMP5+ol2msdM+7N3DNseUm8rA0xaknevz8kxNkJiFGGgDb
        wXWb0beCz4P9Jjk6p9ZUrAlLW242twz3l9ZKnq0AYGVgwSeMNdbMJxJGJJC+DA==
Date:   Wed, 26 Oct 2022 10:18:29 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomasz =?UTF-8?B?TW/FhA==?= <tomasz.mon@camlingroup.com>,
        Richard Weinberger <richard@nod.at>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        torvalds <torvalds@linux-foundation.org>,
        Han Xu <han.xu@nxp.com>, kernel <kernel@pengutronix.de>,
        stable <stable@vger.kernel.org>,
        k drobinski <k.drobinski@camlintechnologies.com>
Subject: Re: [PATCH] mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on
 program/erase times
Message-ID: <20221026101829.4a0e9da7@xps-13>
In-Reply-To: <CAJ+vNU2R=FVSpRVWh8RBJ7XZmRRjkqHce1WTGXDKrjeHRbuzSw@mail.gmail.com>
References: <20220701110341.3094023-1-s.hauer@pengutronix.de>
        <c2d545d1f5478e66c0dac47f4bc4c04256ff44aa.camel@camlingroup.com>
        <fd830c7e94de6b4a0b532dfcf46cf1edd22b42fb.camel@camlingroup.com>
        <YtD/9KJZwlVj+6hS@kroah.com>
        <20220715074631.GA7333@pengutronix.de>
        <YtEdIujszEKSprbF@kroah.com>
        <770744970.283550.1657871950910.JavaMail.zimbra@nod.at>
        <20220902090252.75285234@xps-13>
        <CAJ+vNU0r3Enkwn+WzvEJYc_O4NurRyCssx2S-_ZS_cYCpk2-cA@mail.gmail.com>
        <20221024100114.627f87bd@xps-13>
        <CAJ+vNU2R=FVSpRVWh8RBJ7XZmRRjkqHce1WTGXDKrjeHRbuzSw@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tim,

tharvey@gateworks.com wrote on Tue, 25 Oct 2022 15:02:27 -0700:

> On Mon, Oct 24, 2022 at 1:01 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hi Tim,
> >
> > tharvey@gateworks.com wrote on Fri, 21 Oct 2022 14:55:15 -0700:
> > =20
> > > On Fri, Sep 2, 2022 at 12:03 AM Miquel Raynal <miquel.raynal@bootlin.=
com> wrote: =20
> > > >
> > > > Hey folks,
> > > >
> > > > richard@nod.at wrote on Fri, 15 Jul 2022 09:59:10 +0200 (CEST):
> > > > =20
> > > > > ----- Urspr=C3=BCngliche Mail ----- =20
> > > > > >> My IRC history doesn't go back far enough, but if I recall cor=
rectly
> > > > > >> Miquel is on vacation, he would have picked up this patch for =
linux-next
> > > > > >> otherwise. =20
> > > > >
> > > > > Exactly. =20
> > > >
> > > > Indeed, I was off for an extended period of time, I'm (very) slowly
> > > > catching up now.
> > > > =20
> > > > > =20
> > > > > > Ok, let me do a round of stable releases so that people don't g=
et hit by
> > > > > > this now... =20
> > > > >
> > > > > Thanks a lot for doing so.
> > > > > =20
> > > > > > Hopefully this gets fixed up by 5.19-final. =20
> > > > >
> > > > > Sure, I'll pickup this patch. =20
> > > >
> > > > Thanks Greg & Richard for the handling of this issue.
> > > >
> > > > Cheers,
> > > > Miqu=C3=A8l
> > > > =20
> > >
> > > Hello All,
> > >
> > > As Tomasz stated previously 06781a5026350 was merged in v5.19-rc4 and
> > > then was picked up by several stable kernels. While this made it into
> > > the 5.15 and 5.18 stable branches it did not make it into the
> > > following which are thus the are currently broken:
> > > 5.10.y
> > > 5.17.y
> > >
> > > How do we get this patch applied to those stable branches as well to
> > > resolve this? =20
> >
> > It is likely that the original patch (targeting a mainline kernel) did
> > not apply to those branches. In this case you can adapt the fix to the
> > concerned kernels and send it to stable@ (following the Documentation
> > guidelines for backports).
> >
> > Thanks,
> > Miqu=C3=A8l =20
>=20
> Miqu=C3=A8l,
>=20
> Thanks for the pointer. You are correct that this patch which resolves
> the regression does not apply directly to 5.4/5.10/5.17 stable trees.
> I'm looking over
> https://www.kernel.org/doc/html/v4.10/process/stable-kernel-rules.html

Option 3 fits, right?

> and I'm not clear what I need to put in the commit to make it clear
> that it only applies to those specific trees. Do I simply adjust the
> 'Fixes' tag to address the commit from that specific stable branch and
> send one for each stable branch (thus each would have a different sha
> in the Fixes tag) while also adding the 'commit <sha> upstream' to the
> top?

Here are the failures:
https://lore.kernel.org/stable/165858381623360@kroah.com/
https://lore.kernel.org/stable/165858381472139@kroah.com/
https://lore.kernel.org/stable/165858381313218@kroah.com/

You should not adjust the Fixes tag, this tag should really
reflect what you are trying to fix, and not some kind of target for the
backport. However you're changing the commit content so you can also
change the commit log, with eg. the upstream original commit somewhere
there in plain text. You can target a kernel version on the Cc: stable
line (see the doc) and you can also use

	--subject-prefix=3D"PATCH stable <version>"

during git-format-patch, even though I'm not sure this is actually
needed, it's more like courtesy to let reviewers know what you are
doing.

Here is an example, maybe not the best one (forget about the RESEND)
but a typical case:
https://lore.kernel.org/linux-mtd/20220223174431.1083-1-f.fainelli@gmail.co=
m/

Thanks,
Miqu=C3=A8l
