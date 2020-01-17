Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C52F140C79
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 15:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgAQO3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 09:29:40 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46006 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbgAQO3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 09:29:40 -0500
Received: by mail-lf1-f65.google.com with SMTP id 203so18481010lfa.12;
        Fri, 17 Jan 2020 06:29:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+1Hk/Q5L9FpcoIunUGfxi3OKJO1DIyZBiZordWi4mlY=;
        b=c8G9/1UnJFreMm2U8s6OrhwTeis8cJ0NzcPuHhQAk7gMXkQpgXxiXyFgTegojWF1sF
         Nn2mM9Op7BCHRI7HY5PEoEs0roFUjWdAWhhVZZU4kDBp/OjGIeSM5/z9cnDjGJBxTgdb
         ak+a7vitvwI8dU52XKV4MnW5ytspsATli6fffEW32DXBUA+ZNhVvMn0LNa8u0PhQPsT1
         aZRI6OPG9bEUAD+k9k4mQ04EScc1LmbHZa9heuLzLZCAVNk+i/KznOocOzyHWwX1rWld
         rfRqMWhfhsW78LM503oCZTywHj1JrWg3Bo8m/NbwJC63A5U6HnItoL4jOdL3A7e/1XPy
         MreA==
X-Gm-Message-State: APjAAAXj1fTiesem+Na1MjKdOU89Ng+uAkS90Uekdq5BDaUKx5b1NQAU
        6G6ysLfxdwaET9Pjqj/qXxezQZYb
X-Google-Smtp-Source: APXvYqx2BY8Yxsbql5D5153/I4Oajr4wVrWnmsHemfZoHv9K+x5F4/Axst3hr8oMmMIUQP4iSHPkvQ==
X-Received: by 2002:ac2:4c2b:: with SMTP id u11mr5645205lfq.46.1579271378069;
        Fri, 17 Jan 2020 06:29:38 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id g25sm12273212ljn.107.2020.01.17.06.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 06:29:37 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1isScz-0007FJ-7l; Fri, 17 Jan 2020 15:29:37 +0100
Date:   Fri, 17 Jan 2020 15:29:37 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5/5] USB: serial: quatech2: handle unbound ports
Message-ID: <20200117142937.GV2301@localhost>
References: <20200117095026.27655-1-johan@kernel.org>
 <20200117095026.27655-6-johan@kernel.org>
 <20200117103639.GA1835567@kroah.com>
 <20200117105317.GU2301@localhost>
 <20200117131356.GB1848214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117131356.GB1848214@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 17, 2020 at 02:13:56PM +0100, Greg Kroah-Hartman wrote:
> On Fri, Jan 17, 2020 at 11:53:17AM +0100, Johan Hovold wrote:
> > On Fri, Jan 17, 2020 at 11:36:39AM +0100, Greg Kroah-Hartman wrote:
> > > On Fri, Jan 17, 2020 at 10:50:26AM +0100, Johan Hovold wrote:
> > > > Check for NULL port data in the event handlers to avoid dereferencing a
> > > > NULL pointer in the unlikely case where a port device isn't bound to a
> > > > driver (e.g. after an allocation failure on port probe).
> > > > 
> > > > Fixes: f7a33e608d9a ("USB: serial: add quatech2 usb to serial driver")
> > > > Cc: stable <stable@vger.kernel.org>     # 3.5
> > > > Signed-off-by: Johan Hovold <johan@kernel.org>

> > I'll respin this last one in some way, thanks.
> 
> Nah, that's fine, this is ok as-is, thanks.

I wasn't too happy with this myself, so I reverted to my first version
of simply adding the checks the lsr/msr helper where the actual
dereference takes place.

The downside is that it's a bit disconnected from where the actual port
lookup takes place (qt2_process_read_urb()). But I thinks it's still
preferred over adding sanity checks to those event-handler stubs, which
admittedly looks quite weird.

I've applied the first four and will send a v2 of this one.

Johan
