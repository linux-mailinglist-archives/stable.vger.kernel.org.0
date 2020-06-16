Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008F71FBCC9
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 19:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgFPRZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 13:25:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbgFPRZU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 13:25:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CF0120707;
        Tue, 16 Jun 2020 17:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592328319;
        bh=CKJJMzG+vtGvum57y8HTrgub1H73diPSub4DN+rwJk8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w9MJvEIk91QpFexP5tLkO3pKwGJ1bURjALOSq6tDX0LQphmQjd7vBbV9KmrL6Iuml
         ECUva2s3bSuK1cpzh+bTD2d+X1m7HMahvYGAv/yBajccPTA6vgU/nlFp1klajRx0aj
         fwwyE18hZrlCrWk42fWZ5TuHV/0r6BUkNoJl7jEY=
Date:   Tue, 16 Jun 2020 19:25:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Subject: Re: patch "serial: imx: Initialize lock for non-registered console"
 added to tty-next
Message-ID: <20200616172514.GA74477@kroah.com>
References: <159065034721114@kroah.com>
 <CA+G9fYtSmkcCAeKVzUj3B5Yj3ZZw-wiMyQAMwqUOSyiPRB2Byg@mail.gmail.com>
 <20200616071857.GL2428291@smile.fi.intel.com>
 <CA+G9fYuQVxt9iP0uUCS1uvzNQ2MROuZ=RbbLW7F0jmuErPdgrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuQVxt9iP0uUCS1uvzNQ2MROuZ=RbbLW7F0jmuErPdgrw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 16, 2020 at 10:15:23PM +0530, Naresh Kamboju wrote:
> On Tue, 16 Jun 2020 at 12:48, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> >
> > On Tue, Jun 16, 2020 at 11:45:18AM +0530, Naresh Kamboju wrote:
> > > On Thu, 28 May 2020 at 12:49, <gregkh@linuxfoundation.org> wrote:
> > > >
> > > >
> > > > This is a note to let you know that I've just added the patch titled
> > > >
> > > >     serial: imx: Initialize lock for non-registered console
> > > >
> > > > to my tty git tree which can be found at
> > > >     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
> > > > in the tty-next branch.
> > > >
> > > > The patch will show up in the next release of the linux-next tree
> > > > (usually sometime within the next 24 hours during the week.)
> > > >
> > > > The patch will also be merged in the next major kernel release
> > > > during the merge window.
> > > >
> > > > If you have any questions about this process, please let me know.
> > > >
> > > >
> > > > From 8f065acec7573672dd15916e31d1e9b2e785566c Mon Sep 17 00:00:00 2001
> > > > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > > Date: Mon, 25 May 2020 13:59:52 +0300
> > > > Subject: serial: imx: Initialize lock for non-registered console
> > > >
> > > > The commit a3cb39d258ef
> > > > ("serial: core: Allow detach and attach serial device for console")
> > > > changed a bit logic behind lock initialization since for most of the console
> > > > driver it's supposed to have lock already initialized even if console is not
> > > > enabled. However, it's not the case for Freescale IMX console.
> > > >
> > > > Initialize lock explicitly in the ->probe().
> > > >
> > > > Note, there is still an open question should or shouldn't not this driver
> > > > register console properly.
> > > >
> > > > Fixes: a3cb39d258ef ("serial: core: Allow detach and attach serial device for console")
> > > > Reported-by: Guenter Roeck <linux@roeck-us.net>
> > > > Cc: stable <stable@vger.kernel.org>
> > > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > > Link: https://lore.kernel.org/r/20200525105952.13744-1-andriy.shevchenko@linux.intel.com
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > ---
> > > >  drivers/tty/serial/imx.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > >
> > > > diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
> > > > index 986d902fb7fe..6b078e395931 100644
> > > > --- a/drivers/tty/serial/imx.c
> > > > +++ b/drivers/tty/serial/imx.c
> > > > @@ -2404,6 +2404,9 @@ static int imx_uart_probe(struct platform_device *pdev)
> > > >                 }
> > > >         }
> > > >
> > > > +       /* We need to initialize lock even for non-registered console */
> > > > +       spin_lock_init(&sport->port.lock);
> > >
> > > On arm64 Hikey devices running stable-rc 5.7 branch kernel reported following
> > > kernel INFO while booting.
> >
> > Does backporting (applying)
> >
> > 8508f4cba308 ("serial: amba-pl011: Make sure we initialize the port.lock spinlock")
> >
> > fix the issue?
> 
> Cherry-pick is successful in the stable-rc/linux-5.7.y branch
> and the reported problem seems to be fixed.
> However,I will test with 100 loop iteration and will confirm again.
> ---
> $ git cherry-pick  8508f4cba30
> [stable-rc-linux-5.7.y 4133416ed382] serial: amba-pl011: Make sure we
> initialize the port.lock spinlock
>  Author: John Stultz <john.stultz@linaro.org>
>  Date: Tue Apr 28 18:40:50 2020 +0000
>  1 file changed, 1 insertion(+)

I've added this patch to the tree now, thanks.

greg k-h
