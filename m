Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C09D4E27EF
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348016AbiCUNnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 09:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348089AbiCUNnE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:43:04 -0400
X-Greylist: delayed 3964 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 21 Mar 2022 06:41:38 PDT
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67285762B3
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 06:41:38 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C30AEC000A;
        Mon, 21 Mar 2022 13:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647870096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GIxuyqU3ctJGiCBP+cbpAyeqP8N2xcPjN2SiYQ6vLN8=;
        b=BBjfOoMCjmQetnwVU70OFIwqXWm7DsCkndUr4172sno2nEVA19xhBE/58rIH4WDJkhrfgV
        d0qsyCmZNJGsNIrMjRWQPvu5mnPQAaoo6yAHO9rO5iJZ5fSMbgQh95x3TYOtxypPGTgoM3
        ZpVqb1NXeo/1NyReIw6ARZyCE+KiowJFpW0zZSJTgDk7OZa8EQaIl6YcY3ehi3qf9piFpP
        HTziz3pO58y7HTIouxr7jN40SdfYK8bhDSQZ5emP55qEZSDTbDuEf5oojqMzE0v5hLZ5JP
        dO0sDy2k5KTaMVM3jRikZw8Lq+WzWdFbNqRQUvf6UOjeYqUPpxA1oN4IkVXEDw==
Date:   Mon, 21 Mar 2022 14:41:34 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Tokunori Ikegami <ikegami.t@gmail.com>,
        linux-mtd@lists.infradead.org,
        Ahmad Fatoum <a.fatoum@pengutronix.de>, stable@vger.kernel.org
Subject: Re: [PATCH v4 2/3] mtd: cfi_cmdset_0002: Use chip_ready() for write
 on S29GL064N
Message-ID: <20220321144134.3076a2ba@xps13>
In-Reply-To: <f950bfe4-9c8d-199d-120f-cc8c1ecca8e3@leemhuis.info>
References: <20220316155455.162362-1-ikegami.t@gmail.com>
        <20220316155455.162362-3-ikegami.t@gmail.com>
        <db755852-effe-c4ca-726c-200d28b0b8a5@leemhuis.info>
        <20220321133529.2d3addaf@xps13>
        <f950bfe4-9c8d-199d-120f-cc8c1ecca8e3@leemhuis.info>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thorsten,

regressions@leemhuis.info wrote on Mon, 21 Mar 2022 13:51:10 +0100:

> On 21.03.22 13:35, Miquel Raynal wrote:
> >
> > regressions@leemhuis.info wrote on Mon, 21 Mar 2022 12:48:11 +0100:
> >=20
> >> On 16.03.22 16:54, Tokunori Ikegami wrote:
> >>> As pointed out by this bug report [1], buffered writes are now broken=
 on
> >>> S29GL064N. This issue comes from a rework which switched from using c=
hip_good()
> >>> to chip_ready(), because DQ true data 0xFF is read on S29GL064N and a=
n error
> >>> returned by chip_good(). One way to solve the issue is to revert the =
change
> >>> partially to use chip_ready for S29GL064N.
> >>>
> >>> [1] https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pe=
ngutronix.de/ =20
> >>
> >> Why did you switch from the documented format for links you added on my
> >> request (see
> >> https://lore.kernel.org/stable/f1b44e87-e457-7783-d46e-0d577cea3b72@le=
emhuis.info/
> >>
> >> ) to v2 to something else that is not recognized by tools and scripts
> >> that rely on proper link tags? You are making my and maybe other peopl=
es
> >> life unnecessary hard. :-((
> >>
> >> FWIW, the proper style should support footnote style like this:
> >>
> >> Link:
> >> https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutr=
onix.de/
> >>  [1]
> >>
> >> Ciao, Thorsten
> >>
> >> #regzbot ^backmonitor:
> >> https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutr=
onix.de/
> >>
> >=20
> > Because today's requirement from maintainers is to provide a Link
> > tag that points to the mail discussion of the patch being applied.
>=20
> That can be an additional Link tag, that is done all the time.
>=20
> > I
> > then asked to use the above form instead to point to the bug report
> > because I don't see the point of having a "Link" tag for it?

Perhaps I should emphasize that I don't remember your initial request
regarding the use of a Link tag and my original idea was to help this
contributor, not kill your tools which I actually know very little
about.

> But it's not your own project, we are all working with thousands of
> people together on this project on various different fronts. That needs
> coordination, as some things otherwise become hard or impossible. That's
> why we have documentation that explains how to do some things. Not
> following it just because you don't like it is not helpful and in this
> case makes my life as a volunteer a lot harder.

Let's be honest, you are referring to a Documentation patch that *you*
wrote and was merged into Linus' tree mid January. How often do you
think people used to the contribution workflow monitor these files?

I am totally fine enforcing the use of Link: tags if this is what has
been decided, just don't expect everybody to switch to a style rather
than another over a night.

> If you don't like the approach explained by the documentation, submit a
> patch adjusting the documentation and then we can talk about this. But
> until that is applied please stick to the format explained by the
> documentation.

This is uselessly condescending.

Thanks,
Miqu=C3=A8l
