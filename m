Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559294FB518
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 09:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245564AbiDKHnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 03:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245678AbiDKHnE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 03:43:04 -0400
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [IPv6:2001:4b98:dc4:8::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5442D559B
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 00:40:50 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 3B125200012;
        Mon, 11 Apr 2022 07:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649662848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zMslGI0Nk9+SOvYSj6cm9qNbzp4T8QUhXk3AKMJi01s=;
        b=aoaiccUvduO6o44p0B1qYzKY0Wis3SgXfQ+09cO3ZHeQBe5nmVUeKuzHdtX+BrmUCv3uac
        dIu/yEj9qgQAdlmTLtZTbWcHxhMVHf2gPbFFjq6PW1igag3YxxwSiPa1RlCbn8ele1NV30
        FmOxhX8WKVhORHJKrcxC9gdac6eyddcdzhaWRjsZ8ezOC39iYXIouYdm/B15DMU9QSq/dZ
        MxZ1/WHCRGRNN93S9T9QDjdrV3xHwrNo3bdCeLTdIhlV/EYLjgYozqW0irIW/4lLB9ZhAm
        nyOm6IMpSTEPyP8D6ld74i+mmioeuieFa0WNPqqRkpZUmRw9XUVq5LOdksfiOw==
Date:   Mon, 11 Apr 2022 09:40:47 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Tokunori Ikegami <ikegami.t@gmail.com>, richard@nod.at,
        vigneshr@ti.com, linux-mtd@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v7 0/4] mtd: cfi_cmdset_0002: Use chip_ready() for write
 on S29GL064N
Message-ID: <20220411094047.06556ee1@xps13>
In-Reply-To: <6b09d10e-2098-9fb7-be4c-ae67d802cd2d@leemhuis.info>
References: <20220323170458.5608-1-ikegami.t@gmail.com>
        <6b09d10e-2098-9fb7-be4c-ae67d802cd2d@leemhuis.info>
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

Hello,

regressions@leemhuis.info wrote on Sun, 10 Apr 2022 10:51:17 +0200:

> Hi, this is your Linux kernel regression tracker. Top-posting for once,
> to make this easily accessible to everyone.
>=20
> Miquel, Richard, Vignesh: what's up here? This patchset fixes a
> regression. It's quite old, so it's not that urgent, but it looked like
> nothing happened for two and a half week now. Or was progress made
> somewhere?

Vignesh, I'm waiting for your review/ack ;)

> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

Nice 'tool' :)

> P.S.: As the Linux kernel's regression tracker I'm getting a lot of
> reports on my table. I can only look briefly into most of them and lack
> knowledge about most of the areas they concern. I thus unfortunately
> will sometimes get things wrong or miss something important. I hope
> that's not the case here; if you think it is, don't hesitate to tell me
> in a public reply, it's in everyone's interest to set the public record
> straight.
>=20
> #regzbot poke
>=20
> On 23.03.22 18:04, Tokunori Ikegami wrote:
> > Since commit dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to
> > check correct value") buffered writes fail on S29GL064N. This is
> > because, on S29GL064N, reads return 0xFF at the end of DQ polling for
> > write completion, where as, chip_good() check expects actual data
> > written to the last location to be returned post DQ polling completion.
> > Fix is to revert to using chip_good() for S29GL064N which only checks
> > for DQ lines to settle down to determine write completion.
> >=20
> > Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check=
 correct value")
> > Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
> > Cc: stable@vger.kernel.org
> > Link: https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pe=
ngutronix.de/
> >=20
> > Tokunori Ikegami (4):
> >   mtd: cfi_cmdset_0002: Move and rename
> >     chip_check/chip_ready/chip_good_for_write
> >   mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N
> >   mtd: cfi_cmdset_0002: Add S29GL064N ID definition
> >   mtd: cfi_cmdset_0002: Rename chip_ready variables
> >=20
> >  drivers/mtd/chips/cfi_cmdset_0002.c | 112 ++++++++++++++--------------
> >  include/linux/mtd/cfi.h             |   1 +
> >  2 files changed, 55 insertions(+), 58 deletions(-)
> >  =20
>=20


Thanks,
Miqu=C3=A8l
