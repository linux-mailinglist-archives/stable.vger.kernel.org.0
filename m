Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8154C65ACFF
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 04:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbjABDz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Jan 2023 22:55:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjABDz6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Jan 2023 22:55:58 -0500
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4A911167
        for <stable@vger.kernel.org>; Sun,  1 Jan 2023 19:55:56 -0800 (PST)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 3023tkR7028444;
        Mon, 2 Jan 2023 04:55:46 +0100
Date:   Mon, 2 Jan 2023 04:55:46 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Lukasz Kalamlacki <lukasz@pm.kalamlacki.eu>,
        Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pavlos Parissis <pavlos.parissis@gmail.com>
Subject: Re: Cannot compile 6.1.2 kernel release
Message-ID: <20230102035546.GA28406@1wt.eu>
References: <b0ef1e48-ca8d-9a5e-6e21-688711dab650@pm.kalamlacki.eu>
 <20230101065337.GA20539@1wt.eu>
 <d3f0d0a5-a15f-9735-5f12-b1c00a474531@pm.kalamlacki.eu>
 <Y7FIo0Eup6TKswTA@kroah.com>
 <187e8f10-2b73-3a18-d9ad-48b2d84bd6b9@pm.kalamlacki.eu>
 <20230101100518.GA21587@1wt.eu>
 <Y7JRE4yO6ZOj0HyH@debian.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y7JRE4yO6ZOj0HyH@debian.me>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Bagas,

On Mon, Jan 02, 2023 at 10:35:47AM +0700, Bagas Sanjaya wrote:
> On Sun, Jan 01, 2023 at 11:05:18AM +0100, Willy Tarreau wrote:
> > > 
> > > To be precise I have this on gcc 10 in Debian:
> > > 
> > > 
> > > during GIMPLE pass: fre
> > > drivers/media/pci/cx18/cx18-i2c.c: In function 'init_cx18_i2c':
> > > drivers/media/pci/cx18/cx18-i2c.c:300:1: internal compiler error:
> > > Segmentation fault
> > >    300 | }
> > 
> > As Greg said it's definitely a compiler bug, so it will interest Gcc
> > developers, or your distro's gcc package maintainers in case it's not
> > up to date. There are toolchains available on kernel.org here:
> > 
> >    https://mirrors.edge.kernel.org/pub/tools/crosstool/
> > 
> > The laest 10.x available is 10.4. If it works with this one it may indicate
> > that your package is lacking some recent fixes, so it might be a question
> > for your distro's gcc package maintainers. If it fails it indicates a bug
> > not yet fixed in gcc and your distro maintainers won't be of any help here,
> > you'll have to report it to the gcc devs instead.
> > 
> > Note that they'll very likely ask about a reproducer (and most likely your
> > config). But a quick test for me with this driver built as a module on
> > x86_64 with gcc-10.4 from kernel.org doesn't show any problem:
> > 
> >   $ make CROSS_COMPILE=/f/tc/nolibc/gcc-10.4.0-nolibc/x86_64-linux/bin/x86_64-linux- drivers/media/pci/cx18/cx18-i2c.o
> >   (...)
> >     CC [M]  drivers/media/pci/cx18/cx18-i2c.o
> >   $ ll drivers/media/pci/cx18/cx18-i2c.o 
> >   -rw-rw-r-- 1 willy users 33920 Jan  1 11:00 drivers/media/pci/cx18/cx18-i2c.o
> > 
> 
> Hi Willy,
> 
> I can confirmed that no segfault reported when compiling
> x86_64-defconfig + CONFIG_VIDEO_CX18 using default gcc from Debian 11,
> so this can be hardware issues.

Unlikely, hardware issues rarely cause a crash on the same file in a
project as large as the kernel. However, a bug in the compiler may be
triggered by specific combinations of options, or even the environment
sometimes.

Also, Pavlos also got the problem on 6.0.16 and got it fixed by updating
the compiler.

I think that someone should report the bug to the debian gcc maintainers
and tell them that 10.4.0 as shipped on kernel.org fixes the problem. It
could help them reproduce the issue, update, confirm the problem is gone,
and issue a fixed package.

Thanks,
Willy
