Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE8F4E2B50
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349766AbiCUO6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349686AbiCUO5x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:57:53 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6E7340EA
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 07:56:23 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2473560003;
        Mon, 21 Mar 2022 14:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647874581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JAo/x8R7rAbW3xDbvvHX3hFb31xZ9EbfQa3/rwY/KzY=;
        b=jj45yubSTsmuEFkrh/iP5XbVEA2Mew4nLlY7ITc4EtuLPueXWnPfsxWdRc9kOlUxTMGwZP
        EVusUHou97LymkpOCPmm3U3TpkETAlUJlbJ8RmzaQv4UeeaS8ooVvsN828zW0eKrUywWH/
        K09lVSgwAwibsxETjOWAKoCrt4TCdUXJUKq5dUszlvgu9eu2jLANgfIsA4sfdvwceuT99X
        1KIUyezsRPRdbBIAlqMfH1hWVnmDIjLkZaD3gYEIFoLRpuUh459gDs1/fzqbua52wFBt55
        la/bejwmebBdYa+KReyCtrpacPRxMVtCqjNtwU2MlLtFopemRxaAOAudq1b0YA==
Date:   Mon, 21 Mar 2022 15:56:18 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Tokunori Ikegami <ikegami.t@gmail.com>,
        linux-mtd@lists.infradead.org,
        Ahmad Fatoum <a.fatoum@pengutronix.de>, stable@vger.kernel.org
Subject: Re: [PATCH v4 2/3] mtd: cfi_cmdset_0002: Use chip_ready() for write
 on S29GL064N
Message-ID: <20220321155618.7bfa214e@xps13>
In-Reply-To: <3ed10e7e-1c73-6464-b1df-6c6e086fa162@leemhuis.info>
References: <20220316155455.162362-1-ikegami.t@gmail.com>
        <20220316155455.162362-3-ikegami.t@gmail.com>
        <db755852-effe-c4ca-726c-200d28b0b8a5@leemhuis.info>
        <20220321133529.2d3addaf@xps13>
        <f950bfe4-9c8d-199d-120f-cc8c1ecca8e3@leemhuis.info>
        <20220321144134.3076a2ba@xps13>
        <3ed10e7e-1c73-6464-b1df-6c6e086fa162@leemhuis.info>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Thorsten,

regressions@leemhuis.info wrote on Mon, 21 Mar 2022 15:17:50 +0100:

> On 21.03.22 14:41, Miquel Raynal wrote:
> > regressions@leemhuis.info wrote on Mon, 21 Mar 2022 13:51:10 +0100: =20
> >> On 21.03.22 13:35, Miquel Raynal wrote: =20
> >>> regressions@leemhuis.info wrote on Mon, 21 Mar 2022 12:48:11 +0100:
> >>> =20
> >>>> On 16.03.22 16:54, Tokunori Ikegami wrote: =20
> >>>>> As pointed out by this bug report [1], buffered writes are now brok=
en on
> >>>>> S29GL064N. This issue comes from a rework which switched from using=
 chip_good()
> >>>>> to chip_ready(), because DQ true data 0xFF is read on S29GL064N and=
 an error
> >>>>> returned by chip_good(). One way to solve the issue is to revert th=
e change
> >>>>> partially to use chip_ready for S29GL064N.
> >>>>>
> >>>>> [1] https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@=
pengutronix.de/   =20
> >>>>
> >>>> Why did you switch from the documented format for links you added on=
 my
> >>>> request (see
> >>>> https://lore.kernel.org/stable/f1b44e87-e457-7783-d46e-0d577cea3b72@=
leemhuis.info/
> >>>>
> >>>> ) to v2 to something else that is not recognized by tools and scripts
> >>>> that rely on proper link tags? You are making my and maybe other peo=
ples
> >>>> life unnecessary hard. :-((
> >>>>
> >>>> FWIW, the proper style should support footnote style like this:
> >>>>
> >>>> Link:
> >>>> https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengu=
tronix.de/
> >>>>  [1]
> >>>>
> >>>> Ciao, Thorsten
> >>>>
> >>>> #regzbot ^backmonitor:
> >>>> https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengu=
tronix.de/
> >>>> =20
> >>>
> >>> Because today's requirement from maintainers is to provide a Link
> >>> tag that points to the mail discussion of the patch being applied. =20
> >>
> >> That can be an additional Link tag, that is done all the time.
> >> =20
> >>> I
> >>> then asked to use the above form instead to point to the bug report
> >>> because I don't see the point of having a "Link" tag for it? =20
> >=20
> > Perhaps I should emphasize that I don't remember your initial request
> > regarding the use of a Link tag =20
>=20
> Happen, no worries.
>=20
> > and my original idea was to help this
> > contributor, not kill your tools which I actually know very little
> > about. =20
> >>> But it's not your own project, we are all working with thousands of =
=20
> >> people together on this project on various different fronts. That needs
> >> coordination, as some things otherwise become hard or impossible. That=
's
> >> why we have documentation that explains how to do some things. Not
> >> following it just because you don't like it is not helpful and in this
> >> case makes my life as a volunteer a lot harder. =20
> >=20
> > Let's be honest, you are referring to a Documentation patch that *you*
> > wrote =20
>=20
> Correct, but in case of submitting-patches it was just a clarification
> how to place links; why the whole aspect was missing in the other is
> kinda odd and likely lost in history...
>=20
> > and was merged into Linus' tree mid January. How often do you
> > think people used to the contribution workflow monitor these files? =20
>=20
> Not often, that's why I have no problem pointing it out, even if that's
> slightly annoying. But you can imagine that it felt kinda odd on my side
> when asking someone to set the links (with references to the docs
> explaining how to set them) and seeing them added then in v2, just so
> see they vanished again in v3 of the same patch. :-/

I fully understand. I actually learned that these tags had to be used
for this purpose, so I will actually enforce their use in my next
reviews.

Just a side question, should the Documentation also mention how
to refer to links for people not used to it? Something like
[5.Posting.rst]:

	"Link: <link> [1]
	 Link: <link> [2]"

My original point was that maintainers would almost always add
a Link tag at the end, containing the mailing-list thread about the
patch being applied. Just saying in the commit log "see the link below"
then becomes misleading.

> > I am totally fine enforcing the use of Link: tags if this is what has
> > been decided, just don't expect everybody to switch to a style rather
> > than another over a night. =20
>=20
> I don't.
>=20
> >> If you don't like the approach explained by the documentation, submit a
> >> patch adjusting the documentation and then we can talk about this. But
> >> until that is applied please stick to the format explained by the
> >> documentation. =20
> > This is uselessly condescending. =20
>=20
> I apologize, it wasn't meant that way.

No worries, thanks :-)

> I had to many discussions already
> where people were not setting any links and it seems the topic is slowly
> hitting a nerve here. Sorry.

I also feel like I am repeating myself sometimes. And then I remember
Rob and the ton of e-mails where he has to repeat himself hundreds of
times a day and I feel slightly better :-p

Cheers, Miqu=C3=A8l
