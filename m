Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDCF5C292
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 20:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfGASEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 14:04:06 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40163 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbfGASEG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 14:04:06 -0400
Received: by mail-lj1-f194.google.com with SMTP id a21so14151198ljh.7
        for <stable@vger.kernel.org>; Mon, 01 Jul 2019 11:04:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MjE0XPXG5+SObe6nqWe6b+FvEpLg7LFAzR1ek564VrQ=;
        b=UtkUFwptAOH936c2uEpu66fHZAuBnVzH8K4qYL4ymu1Ahr/BuB2JG8sOaEx3PWaPLV
         n51OG09Stv2o52/irURrTeak/DZdisKqfYeDL8e7Dap+8DIgLF9b2esMTcb5yPcJFAL7
         HbeyWdO4SgLT1kgwA71FUfVd7I5uIVicfmJFdO2E83w7iuW6EqVILIoQi25uCO/V7M8h
         Dr9khMrsclYCjWOYr1LdAfOoF1TmAU6hPUCABCBE5BLCMtlFY2RYiBcYOZfIQu55L6pZ
         FaENLb69gPJHgr1T8+XMGmvjSLcYuycloI75vdI8Cz3KWO65uvMAf+2w5y8epY4Nd8yn
         //JQ==
X-Gm-Message-State: APjAAAUGATWqYsNsEFXGU0w6HXiz2N3zzuuD1Bu9wUI262ObYnXIiPrx
        oont+Xo2rDmvAcgW1QzkB/jUQqbbmGhirayrgNgbIA==
X-Google-Smtp-Source: APXvYqy5r5OT42DRG2NbZwsc835EZTVSfBwGNLB92WmyLwpvtAd32KmT+/XF0hM1qrPb8gWOqnkclNXq0AvolqMLUEE=
X-Received: by 2002:a2e:9117:: with SMTP id m23mr1503697ljg.134.1562004244498;
 Mon, 01 Jul 2019 11:04:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAGnkfhxxw9keiNj_Qm=2GBYpY38HAq28cOROMRqXfbqq8wNbWQ@mail.gmail.com>
 <20190628225533.GJ11506@sasha-vm> <1560226F-F2C0-440D-9C58-D664DE3C7322@appneta.com>
 <20190629074553.GA28708@kroah.com> <CAGnkfhzmGbeQe7L55nEv575XyubWqCLz=7NQPpH+TajDkkDiXg@mail.gmail.com>
 <20190701175241.GB9081@kroah.com>
In-Reply-To: <20190701175241.GB9081@kroah.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Mon, 1 Jul 2019 20:03:28 +0200
Message-ID: <CAGnkfhx3ykbEsW+=FtpMFWU=_Vnie7RpPYWpWqa1S1HPMXj9kw@mail.gmail.com>
Subject: Re: net: check before dereferencing netdev_ops during busy poll
To:     Josh Elsasser <jelsasser@appneta.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 1, 2019 at 7:53 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Sat, Jun 29, 2019 at 09:39:39PM +0200, Matteo Croce wrote:
> > On Sat, Jun 29, 2019 at 9:45 AM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Fri, Jun 28, 2019 at 07:03:01PM -0700, Josh Elsasser wrote:
> > > > On Jun 28, 2019, at 3:55 PM, Sasha Levin <sashal@kernel.org> wrote:
> > > >
> > > > > What's the upstream commit id?
> > > >
> > > > The commit wasn't needed upstream, as I only sent the original patch after
> > > > 79e7fff47b7b ("net: remove support for per driver ndo_busy_poll()") had
> > > > made the fix unnecessary in Linus' tree.
> > > >
> > > > May've gotten lost in the shuffle due to my poor Fixes tags. The patch in
> > > > question applied only on top of the 4.9 stable release at the time, but the
> > > > actual NPE had been around in some form since 3.11 / 0602129286705 ("net: add
> > > > low latency socket poll").
> > >
> > > Ok, can people then resend this and be very explicit as to why this is
> > > needed only in a stable kernel tree and get reviews from people agreeing
> > > that this really is the correct fix?
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Hi Greg,
> >
> > I think that David alredy reviewed the patch here:
> >
> > https://lore.kernel.org/netdev/20180313.105115.682846171057663636.davem@davemloft.net/
> >
> > Anyway, I tested the patch and it fixes the panic, at least on my
> > iwlwifi card, so:
> >
> > Tested-by: Matteo Croce <mcroce@redhat.com>
>
> Ok, but what can I do with this?  I need a real patch, in mail form,
> that I can apply.  Not a web link to an email archive.
>
> You have read the stable kernel rules, right?  :)
>
> greg k-h

Understood.

Josh, as you are the original author, can you please resend it to -stable?
Feel free to add this tag:

Tested-by: Matteo Croce <mcroce@redhat.com>

Regards,
-- 
Matteo Croce
per aspera ad upstream
