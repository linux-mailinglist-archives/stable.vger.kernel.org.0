Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0353121B529
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 14:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgGJMhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 08:37:06 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34593 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgGJMhG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 08:37:06 -0400
Received: by mail-lj1-f196.google.com with SMTP id q7so6284309ljm.1;
        Fri, 10 Jul 2020 05:37:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Z9d/yvvSeBYP/yFimwVEayW8WUm+SjIzXBwX9kNmYvs=;
        b=uP4iU1LLUZ65cyArZsocxIny2R87LyXddkkUN0fuJPE+cUO6ctCPXgB2GX9Pj60pE7
         QVDqraHxNSXG1Z8E2BSWDfFbrZpLBanBtaB3IzDQiOfww8Osxgz5doQ8GSQnIngYMD/P
         LzCVAGmdZTidjIsSXPJyil7sBYiy8BpEj2hFr3SpUdvBQgzJA7tibXcAR1sYhyNmk37n
         94/EteKT+7mkPsORNQLUG1A5RIF1r+ppqI7872KAraswtdfUO5BJOFPzUWvOWix4Pu0w
         k3btZHhnyA8mRre7LNb4KtdIsGyyj37WZ/9Q11ayms9yBW38cgxqNWkk/BKh45COAi5p
         LisQ==
X-Gm-Message-State: AOAM530B0jODZOm1We/Mv6a/GUru5n/t++IzEqG1Y3Jzi4dLLCvCMu1r
        1K+/0tPgudBH/h0FEZmHM2iHTWuKHno=
X-Google-Smtp-Source: ABdhPJy7RRMhX3J6hOQmg2Ft3MtLYuIhL9vKehivsw1zElBeZUu9109qUnnYsVj3ER1hiN5ejJYutQ==
X-Received: by 2002:a2e:9555:: with SMTP id t21mr19622039ljh.194.1594384624086;
        Fri, 10 Jul 2020 05:37:04 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id i10sm1853543ljg.80.2020.07.10.05.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 05:37:03 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1jtsH3-00065K-Ns; Fri, 10 Jul 2020 14:37:06 +0200
Date:   Fri, 10 Jul 2020 14:37:05 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     "johan@kernel.org" <johan@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] cdc-acm: acm_init: Set initial BAUD to B0
Message-ID: <20200710123705.GT3453@localhost>
References: <20200710093518.22272-1-joakim.tjernlund@infinera.com>
 <20200710095445.GS3453@localhost>
 <b4fca29185bfce940bf52813b5f92af27282c738.camel@infinera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b4fca29185bfce940bf52813b5f92af27282c738.camel@infinera.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 10, 2020 at 10:16:33AM +0000, Joakim Tjernlund wrote:
> On Fri, 2020-07-10 at 11:54 +0200, Johan Hovold wrote:
> > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you recognize the sender and know the content is safe.
> > 
> > 
> > On Fri, Jul 10, 2020 at 11:35:18AM +0200, Joakim Tjernlund wrote:
> > > BO will disable USB input until the device opens. This will
> > > avoid garbage chars waiting flood the TTY. This mimics a real UART
> > > device better.
> > > For initial termios to reach USB core, USB driver has to be
> > > registered before TTY driver.
> > > 
> > > Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
> > > Cc: stable@vger.kernel.org
> > > ---
> > > 
> > >  I hope this change makes sense to you, if so I belive
> > >  ttyUSB could do the same.
> > 
> > No, this doesn't make sense. B0 is used to hang up an already open tty.
> 
> This is at module init so there is no tty yet.

Right, but init_termios is used for each tty later registered.

And B0 is supposed to be set after opening a tty if you want to trigger
a modem disconnect (deassert DTR).

> acm_probe() will later set:
>         acm->line.dwDTERate = cpu_to_le32(9600);
> 	acm->line.bDataBits = 8;
> 	acm_set_line(acm, &acm->line);
> 
> > 
> > Furthermore, this change only affects the initial terminal settings and
> > won't have any effect the next time you open the same port.
> 
> hmm, it is not ideal but acm_probe() will later set:
>         acm->line.dwDTERate = cpu_to_le32(9600);
> 	acm->line.bDataBits = 8;
> 	acm_set_line(acm, &acm->line);

That's only during probe and won't affect a second open.

> But, would it not make sense to not accept input until TTY is opened ?
> That would be more inline with a real RS232, would it not?

It's a quirk of some of these devices that some will accept input before
the tty has been opened. It should be possible to handle using flow
control if you control the other side of the application.

I don't see how this patch would work at all as B0 only deasserts DTR
when initialising the line settings in set_termios() (for example)
during open but then the tty layer will assert it again shortly after.
And your firmware ignores DTR anyway...

Ahh, I see now that the driver is passing zero as dwDTERate to the
device in set_termios() if B0 is requested, which is non-standard
(drivers typically keep the current rate or set 9600 baud). Perhaps your
firmware happens to disable the UART, but I can't seem to find anything
in the spec that says that this is what is supposed to happen.

> > Why not fix your firmware so that it doesn't transmit before DTR is
> > asserted during open()?
> 
> I would but it is not my firmware, it is a ready made USB to UART
> chip. will talk to the manufacturer though.

Hope that works out.

Johan
