Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDA96A6C38
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 13:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjCAMWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 07:22:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjCAMWU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 07:22:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42C62056A;
        Wed,  1 Mar 2023 04:22:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59451612D6;
        Wed,  1 Mar 2023 12:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4637AC433EF;
        Wed,  1 Mar 2023 12:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677673337;
        bh=Y73VvIt+ABMghUDHeO4YPy/e40v3iuCWDtHe9hlni5A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XVaWq12an66Y1M8gjAf1L5gKOMFCPHjsW0rYw6HJdYZG793YGqui4Ytmw4XZSZny1
         3NhnO6kYPywXth/Hc9bPjBQ5ztK5q/IlN5tpvPuEt14If1JTE3PF8wVb177357a8Zb
         pZC7RZMD74jzk4/8ZlkN5MivWeFKv0t/ENMWDU10=
Date:   Wed, 1 Mar 2023 13:22:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lukasz Majczak <lma@semihalf.com>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Guenter Roeck <groeck@chromium.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        upstream@semihalf.com, stable@vger.kernel.org
Subject: Re: [PATCH] serial: core: fix broken console after suspend
Message-ID: <Y/9Ddl7c2PKSEpsR@kroah.com>
References: <20230301075751.43839-1-lma@semihalf.com>
 <Y/8PUdEwskXuWZHA@kroah.com>
 <CAFJ_xbp+qD-_MGd3+SgBY=8zruZNy7k3CO3OMMmWhMGhA-tARQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFJ_xbp+qD-_MGd3+SgBY=8zruZNy7k3CO3OMMmWhMGhA-tARQ@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 01, 2023 at 10:51:31AM +0100, Lukasz Majczak wrote:
> śr., 1 mar 2023 o 09:39 Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> napisał(a):
> >
> > On Wed, Mar 01, 2023 at 08:57:51AM +0100, Lukasz Majczak wrote:
> > > Re-enable the console device after suspending, causes its cflags,
> > > ispeed and ospeed to be set anew, basing on the values stored in
> > > uport->cons. The issue is that these values are set only once,
> > > when parsing console parameters after boot (see uart_set_options()),
> > > next after configuring a port in uart_port_startup() these parameteres
> > > (cflags, ispeed and ospeed) are copied to termios structure and
> > > the orginal one (stored in uport->cons) are cleared, but there is no place
> > > in code where those fields are checked against 0.
> > > When kernel calls uart_resume_port() and setups console, it copies cflags,
> > > ispeed and ospeed values from uart->cons,but those are alread cleared.
> > > The efect is that console is broken.
> > > This patch address this by preserving the cflags, ispeed and
> > > ospeed fields in uart->cons during uart_port_startup().
> > >
> > > Signed-off-by: Lukasz Majczak <lma@semihalf.com>
> > > Cc: stable@vger.kernel.org
> > > ---
> > >  drivers/tty/serial/serial_core.c | 3 ---
> > >  1 file changed, 3 deletions(-)
> > >
> > > diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> > > index 2bd32c8ece39..394a05c09d87 100644
> > > --- a/drivers/tty/serial/serial_core.c
> > > +++ b/drivers/tty/serial/serial_core.c
> > > @@ -225,9 +225,6 @@ static int uart_port_startup(struct tty_struct *tty, struct uart_state *state,
> > >                       tty->termios.c_cflag = uport->cons->cflag;
> > >                       tty->termios.c_ispeed = uport->cons->ispeed;
> > >                       tty->termios.c_ospeed = uport->cons->ospeed;
> > > -                     uport->cons->cflag = 0;
> > > -                     uport->cons->ispeed = 0;
> > > -                     uport->cons->ospeed = 0;
> > >               }
> > >               /*
> > >                * Initialise the hardware port settings.
> > > --
> > > 2.39.2.722.g9855ee24e9-goog
> > >
> >
> > What commit id does this fix?
> >
> > thanks,
> >
> > greg k-h
> Hi Greg,
> 
> There are actually two commits that introduce problematic uport flags
> clearing in uart_startup (for the sake of simplicity I'd ignore the
> older history):
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v6.2&id=c7d7abff40c27f82fe78b1091ab3fad69b2546f9
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v6.2&id=027b57170bf8bb6999a28e4a5f3d78bf1db0f90c
> It's 10 years between those 2 and to me it was hard to decide about
> picking a proper one for the `Fixes:` tag.
> How would you recommend to proceed wrt applying this patch on the
> stable releases?

Where do you think this needs to go to?  Pick something?

And as you have obviously found this on a device running an older kernel
version, what kernel tree(s) did you test it on?

thanks,

greg k-h
