Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533D921B53F
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 14:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgGJMlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 08:41:03 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43158 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbgGJMlD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 08:41:03 -0400
Received: by mail-lf1-f68.google.com with SMTP id g139so3102502lfd.10;
        Fri, 10 Jul 2020 05:41:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=6CAwLKrTVwB+EZpy5zAlDVB8TB3WXssQcqTs1jFGdPU=;
        b=nTVDLdek+aVjEOh8EAIzU8KIDgz375V76fMSSb6DQhEgCo+nOppTsKSDrO08lxAoRd
         dnslVPz4poTdpwFHsoGXpxUSRHD7X4Lb0QjgAS6tUdprhB4IfnIcQBY9wqg0CXubeSxQ
         m1nB/MBAG3AS17tOjXtSewz6or+OuXftHmeJ2I4wVeG2New+tG/1SHtNxgBbqTWSq3Hk
         j91IzQrxlE0lEdnsMKx4nkp5pqpbMlLyG3ixc3G4pkRXM1S0zV9ahoU1zaVt6a0Y1xnG
         TCRDhURVGXzUHhisPWb12/ueG4bZYioLlrAg9JDTQ7LYrxsFLUtLIH9CAb8h/SgKR4Eu
         6ZTQ==
X-Gm-Message-State: AOAM5334q0g5aiPvZIxdFpB6AmfhPIW86HcxHuviMrNJ4wCpR8Z+xiRB
        MvOzlpEUNK0ZrXq9h2oINrg=
X-Google-Smtp-Source: ABdhPJz78fJlREfYuTgKgs0APkWcDWV/Qam234iHPgfxZqAjp5tdrTu/i8AWs/QzE/rd+bDTpLJ+ZQ==
X-Received: by 2002:a19:4247:: with SMTP id p68mr43131333lfa.22.1594384861190;
        Fri, 10 Jul 2020 05:41:01 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id c6sm2130942lff.77.2020.07.10.05.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 05:41:00 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1jtsKt-000675-O4; Fri, 10 Jul 2020 14:41:03 +0200
Date:   Fri, 10 Jul 2020 14:41:03 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] cdc-acm: acm_init: Set initial BAUD to B0
Message-ID: <20200710124103.GU3453@localhost>
References: <20200710093518.22272-1-joakim.tjernlund@infinera.com>
 <20200710103459.GA1203263@kroah.com>
 <428dc1e66dfa5fb604233046013f9fe35c4d9b5e.camel@infinera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <428dc1e66dfa5fb604233046013f9fe35c4d9b5e.camel@infinera.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 10, 2020 at 10:46:19AM +0000, Joakim Tjernlund wrote:
> On Fri, 2020-07-10 at 12:34 +0200, Greg KH wrote:
> > 
> > On Fri, Jul 10, 2020 at 11:35:18AM +0200, Joakim Tjernlund wrote:

> > >       tty_set_operations(acm_tty_driver, &acm_ops);
> > > 
> > > -     retval = tty_register_driver(acm_tty_driver);
> > > +     retval = usb_register(&acm_driver);
> > >       if (retval) {
> > >               put_tty_driver(acm_tty_driver);
> > >               return retval;
> > >       }
> > > 
> > > -     retval = usb_register(&acm_driver);
> > > +     retval = tty_register_driver(acm_tty_driver);
> > >       if (retval) {
> > > -             tty_unregister_driver(acm_tty_driver);
> > > +             usb_deregister(&acm_driver);
> > 
> > Why are you switching these around?  I think I know, but you don't
> > really say...
> 
> I wrote:
>    For initial termios to reach USB core, USB driver has to be
>    registered before TTY driver.
> Found out that by trial and error. Isn't that clear enough?

No, that makes no sense at all since USB core does not care about
init_termios.

Johan
