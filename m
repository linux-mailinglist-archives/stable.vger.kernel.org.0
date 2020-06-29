Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD7F20E94D
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 01:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgF2XXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 19:23:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbgF2XXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 19:23:48 -0400
Received: from kernel.org (unknown [104.132.0.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA80D20780;
        Mon, 29 Jun 2020 23:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593473028;
        bh=hqPs8DLD77hq4TNWe6Dogw9lD5Amp3jnTwpKNY13XfQ=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=RaR4qRznyLd0UK2ArLdMhravXeQv+J6w3qmbvJiQeY5mVMn/wzlaCRy0tOX8eWkWc
         tV4MNXC2C4xY342VflA9gc1RsfDZ2fKyrTmCx2q04do8e0jrFLsH/CoZNcF+2hT89B
         vn8tQskrv914AJIw3pt4B9pDQh+7yWzjAPPiLszw=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <mhng-af462151-9be0-44c9-aeca-7777d4040d72@palmerdabbelt-glaptop1>
References: <mhng-af462151-9be0-44c9-aeca-7777d4040d72@palmerdabbelt-glaptop1>
Subject: Re: [PATCH] clk: sifive: allocate sufficient memory for struct __prci_data
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     mturquette@baylibre.com, Paul Walmsley <paul.walmsley@sifive.com>,
        linux-riscv@lists.infradead.org, schwab@suse.de,
        vincent.chen@sifive.com, stable@vger.kernel.org
To:     Palmer Dabbelt <palmer@dabbelt.com>, vincent.chen@sifive.com
Date:   Mon, 29 Jun 2020 16:23:47 -0700
Message-ID: <159347302727.1987609.17461999827407726291@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Palmer Dabbelt (2020-06-25 15:13:39)
> On Mon, 22 Jun 2020 18:24:17 PDT (-0700), vincent.chen@sifive.com wrote:
> > The (struct __prci_data).hw_clks.hws is an array with dynamic elements.
> > Using struct_size(pd, hw_clks.hws, ARRAY_SIZE(__prci_init_clocks))
> > instead of sizeof(*pd) to get the correct memory size of
> > struct __prci_data for sifive/fu540-prci. After applying this
> > modifications, the kernel runs smoothly with CONFIG_SLAB_FREELIST_RANDOM
> > enabled on the HiFive unleashed board.
> >
> > Fixes: 30b8e27e3b58 ("clk: sifive: add a driver for the SiFive FU540 PR=
CI IP block")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> > ---
> >  drivers/clk/sifive/fu540-prci.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/clk/sifive/fu540-prci.c b/drivers/clk/sifive/fu540=
-prci.c
> > index 6282ee2f361c..a8901f90a61a 100644
> > --- a/drivers/clk/sifive/fu540-prci.c
> > +++ b/drivers/clk/sifive/fu540-prci.c
> > @@ -586,7 +586,10 @@ static int sifive_fu540_prci_probe(struct platform=
_device *pdev)
> >       struct __prci_data *pd;
> >       int r;
> >
> > -     pd =3D devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
> > +     pd =3D devm_kzalloc(dev,
> > +                       struct_size(pd, hw_clks.hws,
> > +                                   ARRAY_SIZE(__prci_init_clocks)),
> > +                       GFP_KERNEL);
> >       if (!pd)
> >               return -ENOMEM;
>=20
> This is on fixes, thanks!

Does that mean applied to sifive tree? I see it in next but only noticed
this by chance because it wasn't sent to the linux-clk mailing list.
